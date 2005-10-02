From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [oops] rmmod aic7xyz (2.6.14-rc3 and 2.6.13)
Date: Sat, 1 Oct 2005 22:17:46 -0700
Message-ID: <20051001221746.54d26f43.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:53973 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1750971AbVJBFRs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Oct 2005 01:17:48 -0400
Received: from midway ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Sat, 1 Oct 2005 22:17:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>


trivial to reproduce:

modprobe aic7xxx
mount -t ext3 -o data=writeback /dev/sda4 /media/zip
ls -l /media/zip
umount /media/zip
rmmod aic7xxx ---> oops


Oct  1 20:45:56 midway kernel: [42954270.510000] EXT3 FS on sda4, internal journal
Oct  1 20:45:56 midway kernel: [42954270.510000] EXT3-fs: mounted filesystem with writeback data mode.
Oct  1 20:45:56 midway hal.hotplug[14632]: DEVPATH is not set
Oct  1 21:24:46 midway syslog-ng[2237]: STATS: dropped 0
Oct  1 21:29:27 midway hal.hotplug[23883]: DEVPATH is not set
Oct  1 21:45:03 midway kernel: [42957801.730000] sda: Spinning up disk............ready
Oct  1 21:45:03 midway kernel: [42957816.350000] SCSI device sda: 2091050 512-byte hdwr sectors (1071 MB)
Oct  1 21:45:03 midway kernel: [42957816.350000] sda: Write Protect is off
Oct  1 21:45:03 midway kernel: [42957816.350000] sda: Mode Sense: 39 00 10 08
Oct  1 21:45:03 midway kernel: [42957816.360000] SCSI device sda: drive cache: write back
Oct  1 21:45:03 midway kernel: [42957816.360000] SCSI device sda: 2091050 512-byte hdwr sectors (1071 MB)
Oct  1 21:45:03 midway kernel: [42957816.360000] sda: Write Protect is off
Oct  1 21:45:03 midway kernel: [42957816.360000] sda: Mode Sense: 39 00 10 08
Oct  1 21:45:03 midway kernel: [42957816.370000] SCSI device sda: drive cache: write back
Oct  1 21:45:03 midway kernel: [42957816.370000]  sda: sda4
Oct  1 21:45:03 midway /etc/hotplug.d/block/50-hwscan.hotplug[24030]: new block device /block/sda/sda4
Oct  1 21:51:27 midway kernel: [42958200.670000] Synchronizing SCSI cache for disk sda: 
Oct  1 21:51:27 midway kernel: [42958200.670000] Unable to handle kernel paging request at virtual address e4bff163
Oct  1 21:51:27 midway kernel: [42958200.670000]  printing eip:
Oct  1 21:51:27 midway kernel: [42958200.670000] f9f732a7
Oct  1 21:51:27 midway kernel: [42958200.670000] *pde = 00093067
Oct  1 21:51:27 midway kernel: [42958200.670000] *pte = 24bff000
Oct  1 21:51:27 midway kernel: [42958200.670000] Oops: 0002 [#1]
Oct  1 21:51:27 midway kernel: [42958200.670000] SMP DEBUG_PAGEALLOC
Oct  1 21:51:27 midway kernel: [42958200.670000] Modules linked in: aic7xxx usbhid usbserial video1394 ohci1394 raw1394 ieee1394
Oct  1 21:51:27 midway kernel: [42958200.670000] CPU:    0
Oct  1 21:51:27 midway kernel: [42958200.670000] EIP:    0060:[<f9f732a7>]    Not tainted VLI
Oct  1 21:51:27 midway kernel: [42958200.670000] EFLAGS: 00010046   (2.6.14-rc3) 
Oct  1 21:51:27 midway kernel: [42958200.670000] EIP is at ahc_linux_run_command+0x58f/0x6ce [aic7xxx]
Oct  1 21:51:27 midway kernel: [42958200.670000] eax: 00000003   ebx: e39f9df8   ecx: 00000063   edx: e4bff100
Oct  1 21:51:27 midway kernel: [42958200.670000] esi: e42c8034   edi: e35c0100   ebp: daaa9bd0   esp: daaa9ba8
Oct  1 21:51:27 midway kernel: [42958200.670000] ds: 007b   es: 007b   ss: 0068
Oct  1 21:51:27 midway kernel: [42958200.670000] Process rmmod (pid: 24065, threadinfo=daaa8000 task=cb79baf0)
Oct  1 21:51:27 midway kernel: [42958200.670000] Stack: c180af60 daaa9bcc 00000003 4180af60 e42c8034 e39f9e30 cf612eb0 cf612eb0 
Oct  1 21:51:27 midway kernel: [42958200.670000]        e4eaef5c e3a00bf8 daaa9bec f9f7193c e39f9df8 e4eaef5c cf612eb0 00000293 
Oct  1 21:51:27 midway kernel: [42958200.670000]        e3a00bf8 daaa9c10 c02c22cb cf612eb0 c02c2487 00000000 ded7ff58 ded7ff58 
Oct  1 21:51:27 midway kernel: [42958200.670000] Call Trace:
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c0103671>] show_stack+0x7a/0x82
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c0103785>] show_registers+0xf4/0x15d
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c0103948>] die+0xe2/0x15b
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c0381a14>] do_page_fault+0x383/0x52c
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c010336f>] error_code+0x4f/0x54
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<f9f7193c>] ahc_linux_queue+0x51/0x5c [aic7xxx]
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02c22cb>] scsi_dispatch_cmd+0x209/0x293
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02c7c0c>] scsi_request_fn+0x287/0x31b
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02865ba>] __generic_unplug_device+0x20/0x25
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02865d7>] generic_unplug_device+0x18/0x28
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02871a9>] blk_execute_rq_nowait+0x38/0x3d
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c0287254>] blk_execute_rq+0xa6/0xcd
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02c6ae4>] scsi_execute+0xaf/0xc9
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02c6b4f>] scsi_execute_req+0x51/0x76
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02cfbd9>] sd_sync_cache+0x4f/0xab
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02d114e>] sd_shutdown+0x34/0x39
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02d108e>] sd_remove+0x1c/0x5f
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c02803be>] __device_release_driver+0x56/0x70
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c0280400>] device_release_driver+0x28/0x3b
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c027fcd9>] bus_remove_device+0x57/0x69
Oct  1 21:51:27 midway kernel: [42958200.670000]  [<c027eeef>] device_del+0x2f/0x5e
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c02ca764>] __scsi_remove_device+0x2e/0x69
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c02c9a44>] scsi_forget_host+0x3b/0x62
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c02c2dd1>] scsi_remove_host+0x76/0xde
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<f9f7289e>] ahc_platform_free+0x29/0x148 [aic7xxx]
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<f9f679ca>] ahc_free+0x79/0xc8 [aic7xxx]
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<f9f75345>] ahc_linux_pci_dev_remove+0x41/0x48 [aic7xxx]
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c01cba33>] pci_device_remove+0x1b/0x30
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c02803be>] __device_release_driver+0x56/0x70
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c028048a>] driver_detach+0x77/0x8d
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c027fe9f>] bus_remove_driver+0x3e/0x5d
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c0280745>] driver_unregister+0xd/0x1a
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c01cbc4f>] pci_unregister_driver+0x10/0x1b
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<f9f7552a>] ahc_linux_pci_exit+0xd/0xf [aic7xxx]
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<f9f7495b>] ahc_linux_exit+0x8/0x1a [aic7xxx]
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c012ee35>] sys_delete_module+0x14a/0x185
Oct  1 21:51:28 midway kernel: [42958200.670000]  [<c01027ef>] sysenter_past_esp+0x54/0x75
Oct  1 21:51:28 midway kernel: [42958200.670000] Code: 8b 4d e8 8b 41 20 f6 40 08 01 74 06 8b 01 80 48 1a 80 8b 75 e8 8b 5d 08 8b 06 0f b6 8b 1f 01 00 00 8b 93 24 01 00 00 0f b6 40 1b <88> 04 11 8b 83 0c 01 00 00 0f b6 8b 1f 01 00 00 fe c1 a8 40 88 

---
~Randy
