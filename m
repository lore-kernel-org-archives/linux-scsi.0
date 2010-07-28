From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: [PATCH 0/6] scsi_dh : Couple of fixes for scsi device handlers
Date: Wed, 28 Jul 2010 16:58:43 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4D05DC420@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:35735 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234Ab0G1W6u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 18:58:50 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>

These patches fix the following two cases. 
1. Devices going away while scsi device hander's activate is still in progress.

2. Removal of scsi_dh_data(calling detach handler) when scsi device hander's activate is still in progress.

We have been seeing these problems while running multipath failover tests on LSI storage. These patches fix the problem. We have verified it.

Here is the panic we have been seeing while running failover failback tests.

> 00:40:42:869  COM1 >------------[ cut here ]------------
> 00:40:42:869  COM1 >kernel BUG at /usr/src/packages/BUILD/lsi-
> scsi_dh_rdac-01.00/obj/default/scsi_dh_rdac.c:232!
> 00:40:42:869  COM1 >invalid opcode: 0000 [1] SMP 
> 00:40:42:885  COM1 >last sysfs file: /sys/kernel/uevent_seqnum
> 00:40:42:885  COM1 >CPU 3 
> 00:40:42:885  COM1 >Modules linked in: dm_round_robin dm_multipath 
> nls_utf8 cifs(X) microcode af_packet ipv6 fuse loop dm_mod iTCO_wdt 
> iTCO_vendor_support dcdbas(X) pcspkr rtc_cmos rtc_core serio_raw 
> rtc_lib i5000_edac edac_core bnx2 shpchp sg pci_hotplug button 
> mptctl usbhid hid ff_memless uhci_hcd ehci_hcd usbcore sd_mod 
> crc_t10dif mpt2sas(N) raid_class edd ext3 mbcache jbd fan 
> ide_pci_generic piix ide_core ata_generic ata_piix libata dock 
> mptsas mptscsih mptbase scsi_transport_sas thermal processor 
> thermal_sys hwmon scsi_dh_rdac(X) scsi_dh scsi_mod
> 00:40:42:932  COM1 >Supported: No
> 00:40:42:932  COM1 >Pid: 14044, comm: kmpath_handlerd Tainted: G    
> 2.6.27.39-0.3-default #1
> 00:40:42:932  COM1 >RIP: 0010:  
> rdac_activate+0x257/0x387 [scsi_dh_rdac]
> 00:40:42:947  COM1 >RSP: 0018:ffff880127109dc0  EFLAGS: 00010246
> 00:40:42:947  COM1 >RAX: ffff8800ae02f000 RBX: 0000000000000001 RCX:
> 0000000000000018
> 00:40:42:963  COM1 >RDX: 0000000000001bbc RSI: 0000000000000282 RDI:
> ffff8800c2ccd918
> 00:40:42:963  COM1 >RBP: 00000000fffffffb R08: ffffffff806eaf78 R09:
> ffff880028087720
> 00:40:42:963  COM1 >R10: 0000000000000000 R11: ffffffff80284ebe R12:
> ffffffffa0030fbe
> 00:40:42:978  COM1 >R13: 0000000000000000 R14: 0000000000000282 R15:
> 0000000000000000
> 00:40:42:978  COM1 >FS:  0000000000000000(0000) GS:ffff88012fb81ec0
> (0000) knlGS:0000000000000000
> 00:40:42:978  COM1 >CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> 00:40:42:994  COM1 >CR2: 00000000f7701630 CR3: 0000000101d5e000 CR4:
> 00000000000006e0
> 00:40:42:994  COM1 >DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> 00:40:43:010  COM1 >DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> 00:40:43:010  COM1 >Process kmpath_handlerd (pid: 14044, threadinfo 
> ffff880127108000, task ffff88012710e680)
> 00:40:43:010  COM1 >Stack:  ffff880127109ec0 ffffffff8049c431 
> 0000000000000000 ffff880127109e50
> 00:40:43:025  COM1 > ffff8800ae02f000 ffff8800b5032208 
> ffff8800b5032200 ffff8800ae02f250
> 00:40:43:025  COM1 > ffff8800b5032216 0000000580a33680 
> ffff8800c2ccd6b0 ffff8800ae02f120
> 00:40:43:041  COM1 >Call Trace:
> 00:40:43:041  COM1 > scsi_dh_activate+0x81/0x9b[scsi_dh]
> 00:40:43:041  COM1 > activate_path+0x22/0x46 
> [dm_multipath]
> 00:40:43:041  COM1 > run_workqueue+0x7a/0x100
> 00:40:43:057  COM1 > worker_thread+0xd8/0xe7
> 00:40:43:057  COM1 > kthread+0x47/0x73
> 00:40:43:057  COM1 > child_rip+0xa/0x11
> 00:40:43:057  COM1 >
> 00:40:43:057  COM1 >
> 00:40:43:057  COM1 >Code: 4c 89 ea e8 78 dd 30 e0 4c 89 ef 89 c5 e8 
> db a8 30 e0 85 ed 0f 84 da 00 00 00 48 8b 44 24 20 4c 8b a8 d0 05 00
> 00 4d 85 ed 75 04 <0f> 0b eb fe 48 8b 7c 24 40 48 8d 54 24 60 be 60 
> 00 00 00 e8 ae 
> 00:40:43:072  COM1 >RIP   rdac_activate+0x257/
> 0x387 [scsi_dh_rdac]
> 00:40:43:088  COM1 > RSP <ffff880127109dc0>
> 00:40:43:088  COM1 >---[ end trace 00e89c598c82483b ]---
