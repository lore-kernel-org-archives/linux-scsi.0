From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: oops if unplug dd of=/dev/scd$n
Date: 12 Sep 2003 13:44:34 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063395874.19224.14.camel@patehci2>
References: <1063378664.5059.19.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:15000 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261369AbTILTne
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 15:43:34 -0400
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 1A19E1808
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2003 13:43:34 -0600 (MDT)
In-Reply-To: <1063378664.5059.19.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I unplugged (& therefore rebooted) again per request offline.

Similar /proc/kmsg appear.  (And by the way, I see often here a "sector"
= 8 * "block" e.g. 16608288 = 8 * 2076036.)

<4>SCSI error : <1 0 0 0> return code = 0x70000
<4>end_request: I/O error, dev sr1, sector 16608288
<3>Buffer I/O error on device sr1, logical block 2076036
<4>lost page write due to I/O error on sr1
...
<4>lost page write due to I/O error on sr1
<4>SCSI error : <1 0 0 0> return code = 0x10000
<4>end_request: I/O error, dev sr1, sector 54044664
<3>Buffer I/O error on device sr1, logical block 6755583
<4>lost page write due to I/O error on sr1
<1>Unable to handle kernel NULL pointer dereference at virtual address 00000000
<4> printing eip:
<4>c01eb383
<1>*pde = 00000000
<4>Oops: 0000 [#1]
<4>CPU:    1
<4>EIP:    0060:[<c01eb383>]    Not tainted
<4>EFLAGS: 00210282
<4>EIP is at get_kobj_path_length+0x19/0x30
<4>eax: 00000000   ebx: 00000000   ecx: ffffffff   edx: dde64af4
<4>esi: 00000015   edi: 00000000   ebp: c683de78   esp: c683de6c
<4>ds: 007b   es: 007b   ss: 0068
<4>Process dd (pid: 3870, threadinfo=c683c000 task=d0b33940)
<4>Stack: c683c000 0000008c c178e280 c683dec0 c01eb543 c03ff060 c17c65ac 0000008c 
<4>       c17c6588 c683dea4 df91a1be d6255c00 c178e200 d6255c19 c03c35a0 c038cfce 
<4>       00000000 c17c65b0 c17c65ac c03ff0a8 ddec9eac c683ded8 c01eba47 c0387165 
<4>Call Trace:
<4> [<c01eb543>] kset_hotplug+0x15e/0x2b0
<4> [<df91a1be>] sr_remove+0x6f/0x8d [sr_mod]
<4> [<c01eba47>] kobject_del+0x66/0x6d
<4> [<c024bbd1>] device_del+0x83/0xa5
<4> [<c0280f64>] scsi_device_put+0xe0/0xfe
<4> [<df8e78d6>] cdrom_release+0x8c/0x105 [cdrom]
<4> [<c0166597>] blkdev_put+0x20f/0x23e
<4> [<c015e497>] __fput+0x123/0x135
<4> [<c015caf4>] filp_close+0x57/0x81
<4> [<c015cb9f>] sys_close+0x81/0xc7
<4> [<c010b46d>] sysenter_past_esp+0x52/0x71
<4>
<4>Code: f2 ae f7 d1 49 8b 52 24 8d 74 31 01 85 d2 75 e7 5b 89 f0 5e 
<4> 

Pat LaVarre


