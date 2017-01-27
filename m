From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: split scsi passthrough fields out of struct request
 V2
Date: Fri, 27 Jan 2017 16:52:25 +0000
Message-ID: <1485535925.4267.1.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485455329.2540.7.camel@sandisk.com>
	<e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
	<1485456745.2540.9.camel@sandisk.com>
	<db7f9165-19db-d1f2-a2fa-7546da57741b@fb.com>
	<20170126185924.GA25289@lst.de>
	<ee95c6dd-cdb4-7da5-2d4a-ec14034eac7a@fb.com>
	<71e22257-0592-fdd3-25e5-a78ceced2ab9@sandisk.com>
	<4054e944-b28d-1cd6-574f-6cd90e28c301@fb.com>
	<1485464486.2540.12.camel@sandisk.com>
	<6995c991-65a4-8dca-c36e-fb2eff277ca9@fb.com>
	<1485467235.2540.14.camel@sandisk.com>
	<e1d5f4e6-c63f-545d-710f-d4d10fa8d2e0@fb.com>
	<1485472465.2540.19.camel@sandisk.com>
	<e222c541-3239-104d-e0b0-40d19b012b66@fb.com>
	<1485474426.2540.25.camel@sandisk.com>
	<b98195e7-6e04-5a59-8b83-ce2e1c5c4e1a@fb.com>
	<1485477510.2540.27.camel@sandisk.com>
	<2d971693-b79d-c1b9-fb2a-f5dd04128c68@fb.com>
	<1485479738.2540.30.camel@sandisk.com>
	<ecca734c-7a9c-f060-9335-c2de089849c2@fb.com>
	<37ab009a-bc2d-d2ae-a875-269ab563a430@fb.com>
	<9cbf0ce5-ed79-0252-fd2d-34bebaafffa3@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9cbf0ce5-ed79-0252-fd2d-34bebaafffa3@fb.com>
Content-Language: en-US
Content-ID: <40E756221F6ED94B9C2662C1EDF7BFF6@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2017-01-27 at 01:04 -0700, Jens Axboe wrote:
> The previous patch had a bug if you didn't use a scheduler, here's a
> version that should work fine in both cases. I've also updated the
> above mentioned branch, so feel free to pull that as well and merge to
> master like before.

Booting time is back to normal with commit f3a8ab7d55bc merged with
v4.10-rc5. That's a great improvement. However, running the srp-test
software triggers now a new complaint:

[  215.600386] sd 11:0:0:0: [sdh] Attached SCSI disk
[  215.609485] sd 11:0:0:0: alua: port group 00 state A non-preferred suppo=
rts TOlUSNA
[  215.722900] scsi 13:0:0:0: alua: Detached
[  215.724452] general protection fault: 0000 [#1] SMP
[  215.724484] Modules linked in: dm_service_time ib_srp scsi_transport_srp=
 target_core_user uio target_core_pscsi target_core_file ib_srpt target_cor=
e_iblock target_core_mod brd netconsole xt_CHECKSUM iptable_mangle ipt_MASQ=
UERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat libcrc32c nf_c=
onntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject=
_ipv4 xt_tcpudp tun bridge stp llc ebtable_filter ebtables ip6table_filter =
ip6_tables iptable_filter ip_tables x_tables af_packet ib_ipoib rdma_ucm ib=
_ucm ib_uverbs ib_umad rdma_cm msr configfs ib_cm iw_cm mlx4_ib ib_core sb_=
edac edac_core x86_pkg_temp_thermal intel_powerclamp ipmi_ssif coretemp kvm=
_intel hid_generic kvm usbhid irqbypass crct10dif_pclmul crc32_pclmul crc32=
c_intel mlx4_core ghash_clmulni_intel iTCO_wdt dcdbas pcbc tg3
[  215.724629]  iTCO_vendor_support ptp aesni_intel pps_core aes_x86_64 pcs=
pkr crypto_simd libphy ipmi_si glue_helper cryptd ipmi_devintf tpm_tis devl=
ink fjes ipmi_msghandler tpm_tis_core tpm mei_me lpc_ich mei mfd_core butto=
n shpchp wmi mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sy=
simgblt fb_sys_fops ttm drm sr_mod cdrom ehci_pci ehci_hcd usbcore usb_comm=
on sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua autofs4
[  215.724719] CPU: 9 PID: 8043 Comm: multipathd Not tainted 4.10.0-rc5-dbg=
+ #1
[  215.724748] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.0.2 1=
1/17/2014
[  215.724775] task: ffff8801717998c0 task.stack: ffffc90002a9c000
[  215.724804] RIP: 0010:scsi_device_put+0xb/0x30
[  215.724829] RSP: 0018:ffffc90002a9faa0 EFLAGS: 00010246
[  215.724855] RAX: 6b6b6b6b6b6b6b6b RBX: ffff88038bf85698 RCX: 00000000000=
00006
[  215.724880] RDX: 0000000000000006 RSI: ffff88017179a108 RDI: ffff88038bf=
85698
[  215.724906] RBP: ffffc90002a9faa8 R08: ffff880384786008 R09: 00000001001=
70007
[  215.724932] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88038bf=
85698
[  215.724958] R13: ffff88038919f090 R14: dead000000000100 R15: ffff88038a4=
1dd28
[  215.724983] FS:  00007fbf8c6cf700(0000) GS:ffff88046f440000(0000) knlGS:=
0000000000000000
[  215.725010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  215.725035] CR2: 00007f1262ef3ee0 CR3: 000000044f6cc000 CR4: 00000000001=
406e0
[  215.725060] Call Trace:
[  215.725086]  scsi_disk_put+0x2d/0x40
[  215.725110]  sd_release+0x3d/0xb0
[  215.725137]  __blkdev_put+0x29e/0x360
[  215.725163]  blkdev_put+0x49/0x170
[  215.725192]  dm_put_table_device+0x58/0xc0 [dm_mod]
[  215.725219]  dm_put_device+0x70/0xc0 [dm_mod]
[  215.725269]  free_priority_group+0x92/0xc0 [dm_multipath]
[  215.725295]  free_multipath+0x70/0xc0 [dm_multipath]
[  215.725320]  multipath_dtr+0x19/0x20 [dm_multipath]
[  215.725348]  dm_table_destroy+0x67/0x120 [dm_mod]
[  215.725379]  dev_suspend+0xde/0x240 [dm_mod]
[  215.725434]  ctl_ioctl+0x1f5/0x520 [dm_mod]
[  215.725489]  dm_ctl_ioctl+0xe/0x20 [dm_mod]
[  215.725515]  do_vfs_ioctl+0x8f/0x700
[  215.725589]  SyS_ioctl+0x3c/0x70
[  215.725614]  entry_SYSCALL_64_fastpath+0x18/0xad
[  215.725641] RIP: 0033:0x7fbf8aca0667
[  215.725665] RSP: 002b:00007fbf8c6cd668 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000010
[  215.725692] RAX: ffffffffffffffda RBX: 0000000000000046 RCX: 00007fbf8ac=
a0667
[  215.725716] RDX: 00007fbf8006b940 RSI: 00000000c138fd06 RDI: 00000000000=
00007
[  215.725743] RBP: 0000000000000009 R08: 00007fbf8c6cb3c0 R09: 00007fbf8b6=
8d8d8
[  215.725768] R10: 0000000000000075 R11: 0000000000000246 R12: 00007fbf8c6=
cd770
[  215.725793] R13: 0000000000000013 R14: 00000000006168f0 R15: 0000000000f=
74780
[  215.725820] Code: bc 24 b8 00 00 00 e8 55 c8 1c 00 48 83 c4 08 48 89 d8 =
5b 41 5c 41 5d 41 5e 41 5f 5d c3 0f 1f 00 55 48 89 e5 53 48 8b 07 48 89 fb =
<48> 8b 80 a8 01 00 00 48 8b 38 e8 f6 68 c5 ff 48 8d bb 38 02 00 =

[  215.725903] RIP: scsi_device_put+0xb/0x30 RSP: ffffc90002a9faa0

(gdb) list *(scsi_device_put+0xb)
0xffffffff8149fc2b is in scsi_device_put (drivers/scsi/scsi.c:957).
952 =A0=A0=A0=A0=A0* count of the underlying LLDD module. =A0The device is =
freed once the last
953 =A0=A0=A0=A0=A0* user vanishes.
954 =A0=A0=A0=A0=A0*/
955 =A0=A0=A0=A0void scsi_device_put(struct scsi_device *sdev)
956 =A0=A0=A0=A0{
957 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0module_put(sdev->host->hostt->modul=
e);
958 =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0put_device(&sdev->sdev_gendev);
959 =A0=A0=A0=A0}
960 =A0=A0=A0=A0EXPORT_SYMBOL(scsi_device_put);
961
(gdb) disas scsi_device_put
Dump of assembler code for function scsi_device_put:
 =A0=A00xffffffff8149fc20 <+0>: =A0=A0=A0=A0push =A0=A0%rbp
 =A0=A00xffffffff8149fc21 <+1>: =A0=A0=A0=A0mov =A0=A0=A0%rsp,%rbp
 =A0=A00xffffffff8149fc24 <+4>: =A0=A0=A0=A0push =A0=A0%rbx
 =A0=A00xffffffff8149fc25 <+5>: =A0=A0=A0=A0mov =A0=A0=A0(%rdi),%rax
 =A0=A00xffffffff8149fc28 <+8>: =A0=A0=A0=A0mov =A0=A0=A0%rdi,%rbx
 =A0=A00xffffffff8149fc2b <+11>: =A0=A0=A0mov =A0=A0=A00x1a8(%rax),%rax
 =A0=A00xffffffff8149fc32 <+18>: =A0=A0=A0mov =A0=A0=A0(%rax),%rdi
 =A0=A00xffffffff8149fc35 <+21>: =A0=A0=A0callq =A00xffffffff810f6530 <modu=
le_put>
 =A0=A00xffffffff8149fc3a <+26>: =A0=A0=A0lea =A0=A0=A00x238(%rbx),%rdi
 =A0=A00xffffffff8149fc41 <+33>: =A0=A0=A0callq =A00xffffffff814714b0 <put_=
device>
 =A0=A00xffffffff8149fc46 <+38>: =A0=A0=A0pop =A0=A0=A0%rbx
 =A0=A00xffffffff8149fc47 <+39>: =A0=A0=A0pop =A0=A0=A0%rbp
 =A0=A00xffffffff8149fc48 <+40>: =A0=A0=A0retq =A0=A0=A0
End of assembler dump.
(gdb) print &((struct Scsi_Host *)0)->hostt =A0
$2 =3D (struct scsi_host_template **) 0x1a8 <irq_stack_union+424>

Apparently scsi_device_put() was called for a SCSI device that was already
freed (memory poisoning was enabled in my test). This is something I had
not yet seen before.

Bart.
