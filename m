From: Jonathan <jonathan.625266@earthlink.net>
Subject: uas - kernel panic on drive connection
Date: Fri, 4 Jul 2014 10:40:28 -0400
Message-ID: <20140704104028.2014aaf4@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:41126 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbaGDOuk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2014 10:50:40 -0400
Received: from [24.144.93.31] (helo=localhost.localdomain)
	by elasmtp-dupuy.atl.sa.earthlink.net with esmtpa (Exim 4.67)
	(envelope-from <jonathan.625266@earthlink.net>)
	id 1X34f8-0001mP-Mu
	for linux-scsi@vger.kernel.org; Fri, 04 Jul 2014 10:40:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Beginning with kernel 3.15.1, I am getting hard lockups every time I connect a drive to my USB 3 HDD dock with ASMedia ASM1051E UASP compliant chipset. The only way I am able work around this is to set the quirk to ignore uas for the device. Here are the kernel messages during connection followed by a backtrace:

[  229.882190] usb 2-1: new SuperSpeed USB device number 3 using xhci_hcd
[  229.908001] usb-storage 2-1:1.0: USB Mass Storage device detected
[  229.908218] usb-storage 2-1:1.0: Quirks match for vid 174c pid 55aa: 400000
[  229.908349] scsi7 : usb-storage 2-1:1.0
[  230.912633] scsi 7:0:0:0: Direct-Access     ASMT     2105             0    PQ: 0 ANSI: 6
[  230.914818] sd 7:0:0:0: [sdc] Attached SCSI removable disk
[  289.680267] usb 2-1: USB disconnect, device number 3
[  319.599862] usb 2-1: new SuperSpeed USB device number 4 using xhci_hcd
[  319.626881] scsi8 : uas
[  319.628221] xhci_hcd 0000:02:00.0: ERROR Transfer event TRB DMA ptr not part of current TD
[  320.029323] BUG: unable to handle kernel paging request at 0000000001000003
[  320.029393] IP: [<ffffffff81198b0b>] kmem_cache_alloc+0x6b/0x170
[  320.029445] PGD 40821a067 PUD 401bbf067 PMD 40411c067 PTE 0
[  320.029505] Oops: 0000 [#1] PREEMPT SMP 
[  320.029552] Modules linked in: uas usb_storage netconsole des_generic ecb md4 nls_utf8 cifs dns_resolver sch_fq_codel fuse nf_conntrack_ipv4 nf_defrag_ipv4 xt_tcpudp xt_conntrack nf_conntrack iptable_filter ip_tables x_tables vmnet(O) vsock vmci(O) vmmon(O) w83627ehf hwmon_vid adm1021 xfs libcrc32c nls_iso8859_1 nls_cp437 vfat fat coretemp hwmon iTCO_wdt intel_rapl iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp crct10dif_pclmul crc32_pclmul ppdev crc32c_intel snd_hda_codec_hdmi ghash_clmulni_intel aesni_intel snd_hda_codec_realtek snd_hda_codec_generic aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd e1000e hdpvr microcode evdev snd_hda_intel i915 joydev v4l2_dv_timings ptp mousedev psmouse r8168(O) mac_hid snd_hda_controller videodev serio_raw pcspkr media snd_hda_code
 c i2c_i801 lpc_ich pps_core snd_hwdep drm_kms_helper snd_pcm snd_timer drm snd battery tpm_tis parport_pc tpm intel_gtt parport i2c_algo_bit mei_me soundcore mei nuvoton_cir video shpchp button processor nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc lirc_zilog(C) i2c_core lirc_dev rc_core ext4 crc16 mbcache jbd2 hid_generic usbhid hid sd_mod crc_t10dif crct10dif_common atkbd libps2 ehci_pci xhci_hcd ehci_hcd firewire_ohci ahci libahci libata firewire_core crc_itu_t scsi_mod usbcore usb_common i8042 serio
[  320.030938] CPU: 0 PID: 782 Comm: mysqld Tainted: G         C O  3.15.3-ARCH #1
[  320.030988] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./Z68 Pro3-M, BIOS P2.30 06/29/2012
[  320.031052] task: ffff8800c9488a30 ti: ffff8800cebd8000 task.ti: ffff8800cebd8000
[  320.031103] RIP: 0010:[<ffffffff81198b0b>]  [<ffffffff81198b0b>] kmem_cache_alloc+0x6b/0x170
[  320.031165] RSP: 0018:ffff8800cebdba78  EFLAGS: 00010082
[  320.031203] RAX: 0000000000000000 RBX: ffffffffa0118140 RCX: 0000000000833300
[  320.031251] RDX: 0000000000833280 RSI: 0000000000000020 RDI: ffffffffa00fd04b
[  320.031298] RBP: ffff8800cebdbaa8 R08: 0000000000017560 R09: ffff8803fad57380
[  320.031346] R10: 000000000000002f R11: ffff8803fad5002f R12: 0000000001000003
[  320.031394] R13: 0000000000000020 R14: ffff880407af1000 R15: ffff88040ec01900
[  320.031442] FS:  00007f28c2bff700(0000) GS:ffff88041f200000(0000) knlGS:0000000000000000
[  320.031496] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  320.031536] CR2: 0000000001000003 CR3: 0000000407474000 CR4: 00000000000407f0
[  320.031584] Stack:
[  320.031602]  ffffffffa00fd030 ffffffffa0118140 ffff8803fad57380 0000000000000020
[  320.031669]  ffff880407af1000 0000000000000020 ffff8800cebdbae0 ffffffffa00fd04b
[  320.031738]  ffff8803c8e93780 ffff880407af1000 ffff880407430968 000000000084f7e0
[  320.031806] Call Trace:
[  320.031839]  [<ffffffffa00fd030>] ? scsi_host_alloc_command+0x30/0xd0 [scsi_mod]
[  320.031899]  [<ffffffffa00fd04b>] scsi_host_alloc_command+0x4b/0xd0 [scsi_mod]
[  320.031956]  [<ffffffffa00fd0e8>] __scsi_get_command+0x18/0xe0 [scsi_mod]
[  320.032009]  [<ffffffffa00fd1cb>] scsi_get_command+0x1b/0xd0 [scsi_mod]
[  320.032064]  [<ffffffffa0104c74>] scsi_get_cmd_from_req+0x74/0xa0 [scsi_mod]
[  320.032121]  [<ffffffffa0105a2d>] scsi_setup_fs_cmnd+0x3d/0xb0 [scsi_mod]
[  320.032173]  [<ffffffffa0247c68>] sd_prep_fn+0x3b8/0xd30 [sd_mod]
[  320.032219]  [<ffffffff8126a411>] blk_peek_request+0x131/0x280
[  320.032268]  [<ffffffffa0105ade>] scsi_request_fn+0x3e/0x4b0 [scsi_mod]
[  320.032315]  [<ffffffff81266853>] __blk_run_queue+0x33/0x40
[  320.032356]  [<ffffffff81267afe>] queue_unplugged+0x2e/0xd0
[  320.032398]  [<ffffffff8126a8dd>] blk_flush_plug_list+0x1ed/0x270
[  320.032442]  [<ffffffff8126ad14>] blk_finish_plug+0x14/0x50
[  320.032491]  [<ffffffffa0303539>] ext4_writepages+0x449/0xd20 [ext4]
[  320.032539]  [<ffffffff8114d06e>] do_writepages+0x1e/0x30
[  320.032579]  [<ffffffff8114134d>] __filemap_fdatawrite_range+0x5d/0x80
[  320.032625]  [<ffffffff8114146a>] filemap_write_and_wait_range+0x2a/0x70
[  320.032680]  [<ffffffffa02fa790>] ext4_sync_file+0x110/0x370 [ext4]
[  320.032726]  [<ffffffff811e4e8e>] do_fsync+0x4e/0x80
[  320.032764]  [<ffffffff811e5140>] SyS_fsync+0x10/0x20
[  320.032804]  [<ffffffff81515ee9>] system_call_fastpath+0x16/0x1b
[  320.032846] Code: 0f 84 ca 00 00 00 4c 8b 20 4d 85 e4 0f 84 de 00 00 00 48 83 78 10 00 0f 84 d3 00 00 00 49 63 47 20 48 8d 8a 80 00 00 00 4d 8b 07 <49> 8b 1c 04 4c 89 e0 65 49 0f c7 08 0f 94 c0 84 c0 74 a2 49 63 
[  320.033293] RIP  [<ffffffff81198b0b>] kmem_cache_alloc+0x6b/0x170
[  320.033342]  RSP <ffff8800cebdba78>
[  320.033369] CR2: 0000000001000003
[  320.033396] ---[ end trace f435c843a04f8e94 ]---
