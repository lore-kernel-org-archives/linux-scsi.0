From: Carlos Morgado <chbm@cprm.net>
Subject: qla1280 crash doing rescan
Date: Tue, 24 Aug 2004 15:58:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824145815.GB31252@cprm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avalon.cprm.net ([195.8.0.51]:19209 "EHLO avalon.cprm.net")
	by vger.kernel.org with ESMTP id S267903AbUHXO6R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 10:58:17 -0400
Received: from whisky.cprm.net (whisky.cprm.net [195.8.0.39])
	by avalon.cprm.net (8.9.3p3/8.9.3) with ESMTP id PAA03493
	for <linux-scsi@vger.kernel.org>; Tue, 24 Aug 2004 15:58:16 +0100 (WET DST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Delete all the devices via /sys and issued a echo '- - -' > scan.
Resulted in:

Aug 24 16:36:51 box kernel: scsi: unknown device type 31
Aug 24 16:36:51 box kernel:   Vendor:           Model: HSZ70             Rev: 0000
Aug 24 16:36:51 box kernel:   Type:   Unknown                            ANSI SCSI revision: 02Aug 24 16:36:51 box kernel: Unable to handle kernel paging request at virtual address d4811250
Aug 24 16:36:51 box kernel:  printing eip:
Aug 24 16:36:51 box kernel: d48d0c48
Aug 24 16:36:51 box kernel: *pde = 13f42067
Aug 24 16:36:51 box kernel: *pte = 00000000
Aug 24 16:36:51 box kernel: Oops: 0000 [#1]
Aug 24 16:36:51 box kernel: Modules linked in: qla1280 raid0 ipv6 3c59x dm_mod thermal processor fan button battery ac rtc
Aug 24 16:36:51 box kernel: CPU:    0
Aug 24 16:36:51 box kernel: EIP:    0060:[<d48d0c48>]    Not tainted
Aug 24 16:36:51 box kernel: EFLAGS: 00010246   (2.6.8)
Aug 24 16:36:51 box kernel: EIP is at qla1280_slave_configure+0xf8/0x270 [qla1280]
Aug 24 16:36:51 box kernel: eax: 00000000   ebx: d163aa60   ecx: 000000fd   edx: 00000000
Aug 24 16:36:51 box kernel: esi: 00000000   edi: 00000000   ebp: d35a3400   esp: d1d85d9c
Aug 24 16:36:51 box kernel: ds: 007b   es: 007b   ss: 0068
Aug 24 16:36:51 box kernel: Process bash (pid: 1522, threadinfo=d1d84000 task=d3bbcbf0)
Aug 24 16:36:51 box kernel: Stack: d35a3400 00000022 000000ff fd5a3454 d163aa40 00000000 d163a1bc d48d0b50
Aug 24 16:36:51 box kernel:        00000002 d3c6b9dc d35a3400 c02821ac d35a3400 00000002 00000003 00000000
Aug 24 16:36:51 box kernel:        00000000 00000000 d35a3400 c0e61ec0 d3748c00 d1d85e0c c0282316 d35a3400
Aug 24 16:36:51 box kernel: Call Trace:
Aug 24 16:36:51 box kernel:  [<d48d0b50>] qla1280_slave_configure+0x0/0x270 [qla1280]
Aug 24 16:36:51 box kernel:  [<c02821ac>] scsi_add_lun+0x2ec/0x380
Aug 24 16:36:51 box kernel:  [<c0282316>] scsi_probe_and_add_lun+0xd6/0x1d0
Aug 24 16:36:51 box kernel:  [<c0282a7c>] scsi_scan_target+0x9c/0x120
Aug 24 16:36:51 box kernel:  [<c0282b89>] scsi_scan_channel+0x89/0xa0
Aug 24 16:36:51 box kernel:  [<c0282c91>] scsi_scan_host_selected+0xf1/0x100
Aug 24 16:36:51 box kernel:  [<c0282f6d>] scsi_scan+0xbd/0xd0
Aug 24 16:36:51 box kernel:  [<c01339c0>] __alloc_pages+0x320/0x3a0
Aug 24 16:36:51 box kernel:  [<c0282f9d>] store_scan+0x1d/0x30
Aug 24 16:36:51 box kernel:  [<c024c2da>] class_device_attr_store+0x3a/0x40
Aug 24 16:36:51 box kernel:  [<c017c14b>] flush_write_buffer+0x3b/0x50
Aug 24 16:36:51 box kernel:  [<c017c1c0>] sysfs_write_file+0x60/0x70
Aug 24 16:36:51 box kernel:  [<c014b2a8>] vfs_write+0xb8/0x130
Aug 24 16:36:51 box kernel:  [<c014b3f1>] sys_write+0x51/0x80
Aug 24 16:36:51 box kernel:  [<c0105bad>] sysenter_past_esp+0x52/0x71
Aug 24 16:36:51 box kernel: Code: 0f b6 15 50 12 81 d4 f6 c2 01 75 1c 0f b7 05 52 12 81 d4 66
Aug 24 16:36:51 box sshd(pam_unix)[1520]: session closed for user root


2.6.8 + qla1280 3.24.4
02:0c.0 SCSI storage controller: QLogic Corp. ISP1020 Fast-wide SCSI (rev 05)
02:0c.0 Class 0100: 1077:1020 (rev 05)
        Flags: bus master, medium devsel, latency 32, IRQ 9
        I/O ports at d400
        Memory at f3800000 (32-bit, non-prefetchable) [size=4K]

(ps: not subscribed to linux-scsi)

-- 
Carlos Morgado <chbm@cprm.net> - Internet Engineering - Phone +351 214146594
GPG key: 0x75E451E2 FP: B98B 222B F276 18C0 266B  599D 93A1 A3FB 75E4 51E2
The views expressed above do not bind my employer.
