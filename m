From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: BUG and Oops while trying to issue a discard to LVM on RAID1 md
Date: Tue, 4 Oct 2016 07:20:37 +0100
Message-ID: <CALjAwxiFUS4RWvM7xSxQQibCUuM+Yp8Qsk3-bJKfbD6M7z5i3w@mail.gmail.com>
References: <CALjAwxjOeTvpSWaFXn+LftOVC=R1=RsbERCpfX3Tt448zoKwVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALjAwxjOeTvpSWaFXn+LftOVC=R1=RsbERCpfX3Tt448zoKwVw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jim Gill <jgill@vmware.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 4 October 2016 at 07:17, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> While trying to do a discard inside an ESXi 6 VM to an LVM device atop
> an md RAID1 device composed of two SATA SSDs passed up as a raw disk
> mappings through a PVSCSI controller, this BUG followed by an Oops was
> hit:
>
> [   86.902888] ------------[ cut here ]------------
> [   86.904600] kernel BUG at arch/x86/kernel/pci-nommu.c:66!
> [   86.906538] invalid opcode: 0000 [#1] SMP
> [   86.907991] Modules linked in: vmw_vsock_vmci_transport vsock
> sb_edac edac_core intel_powerclamp coretemp crct10dif_pclmul raid1
> crc32_pclmul ppdev ghash_clmulni_intel vmw_balloon joydev
> intel_rapl_perf vmxnet3 acpi_cpufreq tpm_tis fjes parport_pc tpm
> vmw_vmci parport shpchp i2c_piix4 dm_multipath vmwgfx drm_kms_helper
> ttm drm crc32c_intel serio_raw ata_generic vmw_pvscsi pata_acpi
> [   86.914919] CPU: 0 PID: 214 Comm: kworker/0:1H Not tainted
> 4.7.5-200.fc24.x86_64 #1
> [   86.916123] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
> [   86.917720] Workqueue: kblockd blk_delay_work
> [   86.918395] task: ffff88003a65bd00 ti: ffff88003fb18000 task.ti:
> ffff88003fb18000
> [   86.919478] RIP: 0010:[<ffffffffb402ecb1>]  [<ffffffffb402ecb1>]
> nommu_map_sg+0x91/0xc0
> [   86.920697] RSP: 0018:ffff88003fb1bc70  EFLAGS: 00010046
> [   86.921471] RAX: 0000000000000200 RBX: 0000000000000001 RCX: 0000000000000001
> [   86.922539] RDX: 0000000000000000 RSI: ffff88003f8ca600 RDI: ffff88003ce820a0
> [   86.923611] RBP: ffff88003fb1bc98 R08: 0000000000000000 R09: 0000000000000000
> [   86.924692] R10: ffff88003f053000 R11: ffff88003c38c900 R12: 0000000000000001
> [   86.925733] R13: ffff88003ce820a0 R14: 0000000000000001 R15: ffff88003f8ca600
> [   86.926817] FS:  0000000000000000(0000) GS:ffff88003ec00000(0000)
> knlGS:0000000000000000
> [   86.928084] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   86.928958] CR2: 00007fc762951dd0 CR3: 000000003b6f8000 CR4: 00000000001406f0
> [   86.930034] Stack:
> [   86.930334]  0000000000000001 ffff88003ce820a0 ffffffffb4c1b1c0
> 0000000000000001
> [   86.931541]  0000000000000001 ffff88003fb1bcd8 ffffffffb4565e87
> ffff88003f8ca600
> [   86.932762]  ffff88003f075f80 ffff88003c38c900 ffff88003f944000
> ffff88003f082c90
> [   86.933990] Call Trace:
> [   86.934361]  [<ffffffffb4565e87>] scsi_dma_map+0x97/0xc0
> [   86.935122]  [<ffffffffc00b23e5>] pvscsi_queue+0x4a5/0x860 [vmw_pvscsi]
> [   86.936129]  [<ffffffffb4564280>] ? scsi_test_unit_ready+0x150/0x150
> [   86.937099]  [<ffffffffb4561bbd>] scsi_dispatch_cmd+0xdd/0x220
> [   86.937936]  [<ffffffffb4564ab1>] scsi_request_fn+0x461/0x5f0
> [   86.938811]  [<ffffffffb402574a>] ? __switch_to+0x29a/0x4a0
> [   86.939705]  [<ffffffffb43a79e3>] __blk_run_queue+0x33/0x40
> [   86.940504]  [<ffffffffb43a97b5>] blk_delay_work+0x25/0x40
> [   86.941308]  [<ffffffffb40ba3a4>] process_one_work+0x184/0x440
> [   86.942246]  [<ffffffffb40ba6ae>] worker_thread+0x4e/0x480
> [   86.943054]  [<ffffffffb40ba660>] ? process_one_work+0x440/0x440
> [   86.944033]  [<ffffffffb40ba660>] ? process_one_work+0x440/0x440
> [   86.944961]  [<ffffffffb40c0588>] kthread+0xd8/0xf0
> [   86.945699]  [<ffffffffb47ec77f>] ret_from_fork+0x1f/0x40
> [   86.946507]  [<ffffffffb40c04b0>] ? kthread_worker_fn+0x180/0x180
> [   86.947479] Code: ff ff ff 85 c0 74 3c 41 8b 47 0c 4c 89 ff 83 c3
> 01 41 89 47 18 e8 10 d1 3b 00 41 39 dc 49 89 c7 74 1e 49 8b 17 48 83
> e2 fc 75 af <0f> 0b be 3f 00 00 00 48 c7 c7 59 51 a2 b4 e8 5c 1f 07 00
> eb 80
> [   86.951837] RIP  [<ffffffffb402ecb1>] nommu_map_sg+0x91/0xc0
> [   86.952728]  RSP <ffff88003fb1bc70>
> [   86.953238] ---[ end trace 9ce6a81b32bb6ab3 ]---
> [   86.954013] BUG: unable to handle kernel paging request at ffffffffffffffd8
> [   86.955145] IP: [<ffffffffb40c0c60>] kthread_data+0x10/0x20
> [   86.956059] PGD 34c09067 PUD 34c0b067 PMD 0
> [   86.956776] Oops: 0000 [#2] SMP
> [   86.957245] Modules linked in: vmw_vsock_vmci_transport vsock
> sb_edac edac_core intel_powerclamp coretemp crct10dif_pclmul raid1
> crc32_pclmul ppdev ghash_clmulni_intel vmw_balloon joydev
> intel_rapl_perf vmxnet3 acpi_cpufreq tpm_tis fjes parport_pc tpm
> vmw_vmci parport shpchp i2c_piix4 dm_multipath vmwgfx drm_kms_helper
> ttm drm crc32c_intel serio_raw ata_generic vmw_pvscsi pata_acpi
> [   86.962934] CPU: 0 PID: 214 Comm: kworker/0:1H Tainted: G      D
>      4.7.5-200.fc24.x86_64 #1
> [   86.964251] Hardware name: VMware, Inc. VMware Virtual
> Platform/440BX Desktop Reference Platform, BIOS 6.00 09/30/2014
> [   86.965871] task: ffff88003a65bd00 ti: ffff88003fb18000 task.ti:
> ffff88003fb18000
> [   86.966969] RIP: 0010:[<ffffffffb40c0c60>]  [<ffffffffb40c0c60>]
> kthread_data+0x10/0x20
> [   86.968221] RSP: 0018:ffff88003fb1b940  EFLAGS: 00010002
> [   86.968978] RAX: 0000000000000000 RBX: ffff88003ec18100 RCX: 0000000000000000
> [   86.970043] RDX: ffff88003e803090 RSI: ffff88003a65bd80 RDI: ffff88003a65bd00
> [   86.971059] RBP: ffff88003fb1b940 R08: ffff88003a65bda8 R09: 0000000000000000
> [   86.972105] R10: 0000000000000000 R11: 000000000015eb90 R12: ffff88003a65c350
> [   86.973160] R13: ffff88003ec18100 R14: ffff88003a65bd00 R15: 0000000000018100
> [   86.974262] FS:  0000000000000000(0000) GS:ffff88003ec00000(0000)
> knlGS:0000000000000000
> [   86.975480] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   86.976352] CR2: 0000000000000028 CR3: 000000003b6f8000 CR4: 00000000001406f0
> [   86.977517] Stack:
> [   86.977843]  ffff88003fb1b950 ffffffffb40bb23e ffff88003fb1b9a8
> ffffffffb47e802f
> [   86.979065]  00ff88003fb1b9c0 ffff88003a65bd00 ffff88003a65c238
> 0000000000000000
> [   86.980295]  ffff88003fb1c000 0000000000000000 ffff88003fb1ba00
> ffff88003fb1b4a0
> [   86.981525] Call Trace:
> [   86.981938]  [<ffffffffb40bb23e>] wq_worker_sleeping+0xe/0x90
> [   86.982843]  [<ffffffffb47e802f>] __schedule+0x50f/0x780
> [   86.983672]  [<ffffffffb47e82d5>] schedule+0x35/0x80
> [   86.984465]  [<ffffffffb40a4d43>] do_exit+0x7c3/0xb50
> [   86.985193]  [<ffffffffb40297dc>] oops_end+0x9c/0xd0
> [   86.985974]  [<ffffffffb4029c9b>] die+0x4b/0x70
> [   86.986684]  [<ffffffffb4026bb2>] do_trap+0xb2/0x140
> [   86.987444]  [<ffffffffb4026f99>] do_error_trap+0x89/0x110
> [   86.988279]  [<ffffffffb402ecb1>] ? nommu_map_sg+0x91/0xc0
> [   86.989098]  [<ffffffffb43ebf1a>] ? sg_init_table+0x1a/0x40
> [   86.989904]  [<ffffffffb40274f0>] do_invalid_op+0x20/0x30
> [   86.990757]  [<ffffffffb47ee13e>] invalid_op+0x1e/0x30
> [   86.991574]  [<ffffffffb402ecb1>] ? nommu_map_sg+0x91/0xc0
> [   86.992410]  [<ffffffffb4565e87>] scsi_dma_map+0x97/0xc0
> [   86.993241]  [<ffffffffc00b23e5>] pvscsi_queue+0x4a5/0x860 [vmw_pvscsi]
> [   86.994239]  [<ffffffffb4564280>] ? scsi_test_unit_ready+0x150/0x150
> [   86.995184]  [<ffffffffb4561bbd>] scsi_dispatch_cmd+0xdd/0x220
> [   86.996109]  [<ffffffffb4564ab1>] scsi_request_fn+0x461/0x5f0
> [   86.996943]  [<ffffffffb402574a>] ? __switch_to+0x29a/0x4a0
> [   86.997807]  [<ffffffffb43a79e3>] __blk_run_queue+0x33/0x40
> [   86.998665]  [<ffffffffb43a97b5>] blk_delay_work+0x25/0x40
> [   86.999504]  [<ffffffffb40ba3a4>] process_one_work+0x184/0x440
> [   87.000365]  [<ffffffffb40ba6ae>] worker_thread+0x4e/0x480
> [   87.001150]  [<ffffffffb40ba660>] ? process_one_work+0x440/0x440
> [   87.002088]  [<ffffffffb40ba660>] ? process_one_work+0x440/0x440
> [   87.003017]  [<ffffffffb40c0588>] kthread+0xd8/0xf0
> [   87.003800]  [<ffffffffb47ec77f>] ret_from_fork+0x1f/0x40
> [   87.004576]  [<ffffffffb40c04b0>] ? kthread_worker_fn+0x180/0x180
> [   87.005463] Code: f7 89 72 00 e9 53 ff ff ff e8 dd fb fd ff 0f 1f
> 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 d8 05 00 00
> 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44
> 00 00
> [   87.009721] RIP  [<ffffffffb40c0c60>] kthread_data+0x10/0x20
> [   87.010615]  RSP <ffff88003fb1b940>
> [   87.011170] CR2: ffffffffffffffd8
> [   87.011732] ---[ end trace 9ce6a81b32bb6ab4 ]---
> [   87.012411] Fixing recursive fault but reboot is needed!
>
> Once the above happens the VM freezes up and needs to be hard reset.
> The kernel is 4.7.5-200.fc24.x86_64 from Fedora 24.
>
> A slightly related issue where just a "BUG at block/bio.c:1785" is hit
> can be seen over on
> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1243446.html

CC'ing Jim at VMware as Arvind's email address bounced.

-- 
Sitsofe | http://sucs.org/~sits/
