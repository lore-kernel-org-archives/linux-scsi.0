From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: BUG and Oops while trying to issue a discard to LVM on RAID1 md
Date: Wed, 5 Oct 2016 16:13:12 +0100
Message-ID: <CALjAwxgS20CsEtpsTGo50cCUSMtpAtzQ=jc8yv9OB9+eW6Jmmg@mail.gmail.com>
References: <CALjAwxjOeTvpSWaFXn+LftOVC=R1=RsbERCpfX3Tt448zoKwVw@mail.gmail.com>
 <CALjAwxiFUS4RWvM7xSxQQibCUuM+Yp8Qsk3-bJKfbD6M7z5i3w@mail.gmail.com> <CALjAwxjojE4BJaf=g7i0mexryExuMvkr9tT_5JfzD+janCrYSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALjAwxjojE4BJaf=g7i0mexryExuMvkr9tT_5JfzD+janCrYSw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Gill <jgill@vmware.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On 5 October 2016 at 16:04, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 4 October 2016 at 07:20, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> On 4 October 2016 at 07:17, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>> While trying to do a discard inside an ESXi 6 VM to an LVM device atop
>>> an md RAID1 device composed of two SATA SSDs passed up as a raw disk
>>> mappings through a PVSCSI controller, this BUG followed by an Oops was
>>> hit:
>>>
>>> [   86.902888] ------------[ cut here ]------------
>>> [   86.904600] kernel BUG at arch/x86/kernel/pci-nommu.c:66!

(sent that a bit too soon)

On a 4.8.0 kernel the problem seems to have shifted a bit but still
results in a lock up:

[   26.208152] ------------[ cut here ]------------
[   26.208935] kernel BUG at ./include/linux/scatterlist.h:90!
[   26.209799] invalid opcode: 0000 [#1] SMP
[   26.210454] Modules linked in: vmw_vsock_vmci_transport vsock
sb_edac edac_core intel_powerclamp coretemp crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel raid1 intel_rapl_perf ppdev
vmw_balloon pcspkr joydev vmxnet3 acpi_cpufreq tpm_tis tpm_tis_core
tpm vmw_vmci fjes shpchp parport_pc parport i2c_piix4 dm_multipath
vmwgfx drm_kms_helper ttm drm crc32c_intel serio_raw vmw_pvscsi
ata_generic pata_acpi
[   26.216797] CPU: 0 PID: 220 Comm: kworker/0:1H Not tainted
4.8.0-1.vanilla.knurd.1.fc24.x86_64 #1
[   26.218191] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
[   26.219861] Workqueue: kblockd blk_delay_work
[   26.220570] task: ffff9608bf300000 task.stack: ffff9608b9d90000
[   26.221505] RIP: 0010:[<ffffffff9d3b7b37>]  [<ffffffff9d3b7b37>]
blk_rq_map_sg+0x317/0x560
[   26.222812] RSP: 0018:ffff9608b9d93b78  EFLAGS: 00010002
[   26.223650] RAX: 002000000000000e RBX: 0000000000000200 RCX: ffff9608bb71bd00
[   26.224766] RDX: 000000000007fc01 RSI: 0000000000000002 RDI: 0000000000000400
[   26.225867] RBP: ffff9608b9d93c00 R08: ffff9608bec1ca00 R09: 0000000000000000
[   26.226992] R10: ffff9608bb71bd00 R11: ffff9608bb74d900 R12: 0000000000000200
[   26.228085] R13: 0000000000000400 R14: 0000000000000000 R15: ffff9608bb71b800
[   26.229195] FS:  0000000000000000(0000) GS:ffff9608bec00000(0000)
knlGS:0000000000000000
[   26.230509] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   26.231442] CR2: 00007fe4bc4ea000 CR3: 0000000039cab000 CR4: 00000000001406f0
[   26.232620] Stack:
[   26.232967]  ffff9608b9d93bd0 ffffffff9d3f2f1d ffff9608bb71bd00
0108002000000000
[   26.234269]  ffff9608bfaade60 ffff9608bf162380 0000000000000000
002000000000000e
[   26.235558]  0000040000000200 0000000000000000 0000000000000000
0000000080a6fe96
[   26.236854] Call Trace:
[   26.237263]  [<ffffffff9d3f2f1d>] ? __sg_alloc_table+0x7d/0x160
[   26.238217]  [<ffffffff9d56992d>] scsi_init_sgtable+0x3d/0x70
[   26.239148]  [<ffffffff9d5699a4>] scsi_init_io+0x44/0x1c0
[   26.240013]  [<ffffffff9d576b32>] sd_init_command+0x2b2/0xde0
[   26.240970]  [<ffffffff9d56178b>] ? scsi_host_alloc_command+0x4b/0xc0
[   26.242015]  [<ffffffff9d569c21>] scsi_setup_cmnd+0x101/0x160
[   26.242962]  [<ffffffff9d569df4>] scsi_prep_fn+0xf4/0x180
[   26.243869]  [<ffffffff9d3b2aee>] blk_peek_request+0x16e/0x2b0
[   26.244836]  [<ffffffff9d56b50f>] scsi_request_fn+0x3f/0x5f0
[   26.245756]  [<ffffffff9d3addd3>] __blk_run_queue+0x33/0x40
[   26.246636]  [<ffffffff9d3afc55>] blk_delay_work+0x25/0x40
[   26.247506]  [<ffffffff9d0ba514>] process_one_work+0x184/0x430
[   26.248433]  [<ffffffff9d0ba80e>] worker_thread+0x4e/0x480
[   26.249311]  [<ffffffff9d0ba7c0>] ? process_one_work+0x430/0x430
[   26.250265]  [<ffffffff9d0ba7c0>] ? process_one_work+0x430/0x430
[   26.251210]  [<ffffffff9d0c0328>] kthread+0xd8/0xf0
[   26.251993]  [<ffffffff9d7fd43f>] ret_from_fork+0x1f/0x40
[   26.252845]  [<ffffffff9d0c0250>] ? kthread_worker_fn+0x180/0x180
[   26.253801] Code: c6 41 01 c5 41 29 c0 41 29 c4 44 39 ea 75 c9 41
83 c6 01 45 31 ed eb c0 48 8b 4c 24 10 48 8b 31 83 e6 03 a8 03 0f 84
38 ff ff ff <0f> 0b 48 8b 5c 24 20 4c 89 54 24 30 48 89 df ff 90 c0 00
00 00
[   26.258363] RIP  [<ffffffff9d3b7b37>] blk_rq_map_sg+0x317/0x560
[   26.259345]  RSP <ffff9608b9d93b78>
[   26.259890] ---[ end trace bb376bf807673a6f ]---
[   26.260678] BUG: unable to handle kernel paging request at 0000000080a6fe96
[   26.261828] IP: [<ffffffff9d0e323b>] __wake_up_common+0x2b/0x80
[   26.262785] PGD 0
[   26.263141] Oops: 0000 [#2] SMP
[   26.263644] Modules linked in: vmw_vsock_vmci_transport vsock
sb_edac edac_core intel_powerclamp coretemp crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel raid1 intel_rapl_perf ppdev
vmw_balloon pcspkr joydev vmxnet3 acpi_cpufreq tpm_tis tpm_tis_core
tpm vmw_vmci fjes shpchp parport_pc parport i2c_piix4 dm_multipath
vmwgfx drm_kms_helper ttm drm crc32c_intel serio_raw vmw_pvscsi
ata_generic pata_acpi
[   26.270080] CPU: 0 PID: 220 Comm: kworker/0:1H Tainted: G      D
     4.8.0-1.vanilla.knurd.1.fc24.x86_64 #1
[   26.271661] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
[   26.273349] task: ffff9608bf300000 task.stack: ffff9608b9d90000
[   26.274273] RIP: 0010:[<ffffffff9d0e323b>]  [<ffffffff9d0e323b>]
__wake_up_common+0x2b/0x80
[   26.275621] RSP: 0018:ffff9608b9d93e38  EFLAGS: 00010086
[   26.276454] RAX: 0000000000000282 RBX: ffff9608b9d93f10 RCX: 0000000000000000
[   26.277593] RDX: 0000000080a6fe96 RSI: 0000000000000003 RDI: ffff9608b9d93f10
[   26.278742] RBP: ffff9608b9d93e70 R08: 0000000000000000 R09: 6220656361727420
[   26.279865] R10: ffffffff9dc2a074 R11: 0000000000000551 R12: ffff9608b9d93f18
[   26.280960] R13: 0000000000000282 R14: 0000000000000001 R15: 0000000000000003
[   26.282104] FS:  0000000000000000(0000) GS:ffff9608bec00000(0000)
knlGS:0000000000000000
[   26.283386] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   26.284306] CR2: 0000000000000028 CR3: 0000000039cab000 CR4: 00000000001406f0
[   26.285485] Stack:
[   26.285822]  00000001bf2f0000 0000000000000000 ffff9608b9d93f10
ffff9608b9d93f08
[   26.287094]  0000000000000282 0000000000000001 0000000000000000
ffff9608b9d93e80
[   26.288374]  ffffffff9d0e32f3 ffff9608b9d93ea8 ffffffff9d0e3e57
0000000000000000
[   26.289669] Call Trace:
[   26.290077]  [<ffffffff9d0e32f3>] __wake_up_locked+0x13/0x20
[   26.290993]  [<ffffffff9d0e3e57>] complete+0x37/0x50
[   26.291778]  [<ffffffff9d09e13c>] mm_release+0xbc/0x140
[   26.292605]  [<ffffffff9d0a47f5>] do_exit+0x155/0xb10
[   26.293443]  [<ffffffff9d7feac7>] rewind_stack_do_exit+0x17/0x20
[   26.294405]  [<ffffffff9d0c0250>] ? kthread_worker_fn+0x180/0x180
[   26.295405] Code: 0f 1f 44 00 00 55 48 89 e5 41 57 41 56 41 55 41
54 4c 8d 67 08 53 41 89 f7 48 83 ec 10 89 55 cc 48 8b 57 08 4c 89 45
d0 49 39 d4 <48> 8b 32 74 40 48 8d 42 e8 4c 8d 6e e8 41 89 ce 8b 18 48
8b 4d
[   26.299988] RIP  [<ffffffff9d0e323b>] __wake_up_common+0x2b/0x80
[   26.300989]  RSP <ffff9608b9d93e38>
[   26.301541] CR2: 0000000080a6fe96
[   26.302108] ---[ end trace bb376bf807673a70 ]---
[   26.302847] Fixing recursive fault but reboot is needed!
[   26.303708] BUG: unable to handle kernel paging request at ffffffffffffffd8
[   26.304877] IP: [<ffffffff9d0c09f0>] kthread_data+0x10/0x20
[   26.305813] PGD 37e09067 PUD 37e0b067 PMD 0
[   26.306583] Oops: 0000 [#3] SMP
[   26.307076] Modules linked in: vmw_vsock_vmci_transport vsock
sb_edac edac_core intel_powerclamp coretemp crct10dif_pclmul
crc32_pclmul ghash_clmulni_intel raid1 intel_rapl_perf ppdev
vmw_balloon pcspkr joydev vmxnet3 acpi_cpufreq tpm_tis tpm_tis_core
tpm vmw_vmci fjes shpchp parport_pc parport i2c_piix4 dm_multipath
vmwgfx drm_kms_helper ttm drm crc32c_intel serio_raw vmw_pvscsi
ata_generic pata_acpi
[   26.313552] CPU: 0 PID: 220 Comm: kworker/0:1H Tainted: G      D
     4.8.0-1.vanilla.knurd.1.fc24.x86_64 #1
[   26.315166] Hardware name: VMware, Inc. VMware Virtual
Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
[   26.316846] task: ffff9608bf300000 task.stack: ffff9608b9d90000
[   26.317798] RIP: 0010:[<ffffffff9d0c09f0>]  [<ffffffff9d0c09f0>]
kthread_data+0x10/0x20
[   26.319098] RSP: 0018:ffff9608b9d93e48  EFLAGS: 00010002
[   26.319952] RAX: 0000000000000000 RBX: ffff9608bec19580 RCX: 0000000000000000
[   26.321061] RDX: ffff9608be8030b0 RSI: ffff9608bf300080 RDI: ffff9608bf300000
[   26.322230] RBP: ffff9608b9d93e48 R08: ffff9608bf3000a8 R09: 0000000000000000
[   26.323365] R10: ffffffff9dc2a074 R11: 0000000000000574 R12: ffff9608bf3005d8
[   26.324514] R13: ffff9608bec19580 R14: ffff9608bf300000 R15: 0000000000019580
[   26.325660] FS:  0000000000000000(0000) GS:ffff9608bec00000(0000)
knlGS:0000000000000000
[   26.326945] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   26.327870] CR2: 0000000000000028 CR3: 0000000039cab000 CR4: 00000000001406f0
[   26.329050] Stack:
[   26.329381]  ffff9608b9d93e58 ffffffff9d0bc05e ffff9608b9d93eb0
ffffffff9d7f880b
[   26.330683]  00ffffff9d1b37ad ffff9608bf300000 ffff9608b9d93ed8
ffff9608b9d93e90
[   26.331976]  ffff9608b9d94000 0000000000000009 ffff9608b9d93d88
0000000000000009
[   26.333272] Call Trace:
[   26.333684]  [<ffffffff9d0bc05e>] wq_worker_sleeping+0xe/0x80
[   26.334600]  [<ffffffff9d7f880b>] __schedule+0x50b/0x770
[   26.335455]  [<ffffffff9d7f8aa5>] schedule+0x35/0x80
[   26.336246]  [<ffffffff9d0a4f8e>] do_exit+0x8ee/0xb10
[   26.337077]  [<ffffffff9d7feac7>] rewind_stack_do_exit+0x17/0x20
[   26.338046]  [<ffffffff9d0c0250>] ? kthread_worker_fn+0x180/0x180
[   26.339039] Code: 27 94 73 00 e9 53 ff ff ff e8 9d ff fd ff 0f 1f
00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 60 05 00 00
55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
00 00
[   26.343640] RIP  [<ffffffff9d0c09f0>] kthread_data+0x10/0x20
[   26.344598]  RSP <ffff9608b9d93e48>
[   26.345154] CR2: ffffffffffffffd8
[   26.345704] ---[ end trace bb376bf807673a71 ]---
[   26.346454] Fixing recursive fault but reboot is needed!

-- 
Sitsofe | http://sucs.org/~sits/
