From: "Srinivas Naga Venkatasatya Pasagadugula - ERS, HCL Tech"
	<satyasrinivasp@hcl.com>
Subject: RE: mvsas: blocked task on writing to tape
Date: Thu, 19 Aug 2010 21:10:04 +0530
Message-ID: <6B62480106F2B34D8404CF2FDAA4D9EF96D9C4CBFF@CHN-HCLT-EVS06.HCLT.CORP.HCL.IN>
References: <i4jbu0$icb$2@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gws07.mail.hcl.in ([203.105.186.27]:57461 "EHLO gws07.hcl.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab0HSP5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2010 11:57:34 -0400
In-Reply-To: <i4jbu0$icb$2@dough.gmane.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Mueller <thomas@chaschperli.ch>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Geetha Gopalan, ERS-HCLTech" <geethagp@hcl.com>

Hi Thomas,
Need below information.
1. Dmesg or /var/log/messages
2. Which kernel version you are using?
3. Are you running any applications? 
4. Whether tape drive is discovered or not? As I was working with this same drive only. I never faced any problem with this drive. 
5. Check whether this is working with 2.6.33 kernels or not? 

-Srini

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Thomas Mueller
Sent: Thursday, August 19, 2010 7:05 PM
To: linux-scsi@vger.kernel.org
Subject: mvsas: blocked task on writing to tape

hi

recently upgraded the kernel from 2.6.32-bpo.4 to -bpo.5 on Debian Lenny.
Since then, the tape drives don't work anymore. after some time writing 
to tape, it stopps working.

I then compiled a vanilla 2.6.35.2 kernel to verify that the
problem still exists - and it does (log below).

debian kernel 2.6.32-bpo.4 is IMHO 2.6.32.11+patches
debian kernel 2.6.32-bpo.5 is IMHO 2.6.32.15+patches

Hardware:
*Areca ARC-1300ix-16 (mvsas)
* Quantum LTO-4 tape drives connected with SAS (1x standalone, 
1x SuperLoader3 with Drive) - both  having problems.

- Thomas

kernel messages from 2.6.35.2 (vanilla kernel.org):

[    1.303780] mvsas 0000:03:00.0: mvsas: driver version 0.8.2
[    1.304219] mvsas 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.304349] mvsas 0000:03:00.0: setting latency timer to 64
[    1.306623] mvsas 0000:03:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
[    4.047535] scsi1 : mvsas
[    4.047961] drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map 1
[    4.057892] drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map 3
[    4.077741] drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map 7
[    4.107512] drivers/scsi/mvsas/mv_sas.c 1260:set wide port phy map f
...
[  445.370604] st1: Block limits 1 - 16777215 bytes.

<writing with btape (bacula tape test tool)>

[ 1440.924322] INFO: task btape:4738 blocked for more than 120 seconds.
[ 1440.924397] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1440.924488] btape         D ffff88025caa6908     0  4738   4531 0x00000000
[ 1440.924646]  ffff88025ec6b680 0000000000000082 000000010000000c 0000000000000010
[ 1440.924915]  00000000000154c0 ffff88025d4c1fd8 ffff88025d4c1fd8 ffff88025caa6630
[ 1440.925173]  00000000000154c0 00000000000154c0 00000000000154c0 ffff88025caa6630
[ 1440.925442] Call Trace:
[ 1440.925521]  [<ffffffff81304001>] ? schedule_timeout+0x2e/0xdd
[ 1440.925592]  [<ffffffff8117864a>] ? blk_peek_request+0x18f/0x1a3
[ 1440.925661]  [<ffffffff81303e92>] ? wait_for_common+0xde/0x15b
[ 1440.925732]  [<ffffffff8103f832>] ? default_wake_function+0x0/0x9
[ 1440.925816]  [<ffffffffa030009e>] ? st_do_scsi+0x2c4/0x2f4 [st]
[ 1440.925887]  [<ffffffff8103709d>] ? __wake_up+0x30/0x44
[ 1440.925956]  [<ffffffffa03041b5>] ? st_write+0x615/0xa74 [st]
[ 1440.926027]  [<ffffffff810eb3c0>] ? vfs_write+0xa9/0x102
[ 1440.926095]  [<ffffffff810eb4d5>] ? sys_write+0x45/0x6e
[ 1440.926164]  [<ffffffff81008a82>] ? system_call_fastpath+0x16/0x1b

...

[ 2040.924074] INFO: task btape:4738 blocked for more than 120 seconds.
[ 2040.924106] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2040.924152] btape         D ffff88025caa6908     0  4738   4531 0x00000000
[ 2040.930407]  ffff88025ec6b680 0000000000000082 000000010000000c 0000000000000010
[ 2040.930462]  00000000000154c0 ffff88025d4c1fd8 ffff88025d4c1fd8 ffff88025caa6630
[ 2040.930514]  00000000000154c0 00000000000154c0 00000000000154c0 ffff88025caa6630
[ 2040.930566] Call Trace:
[ 2040.930596]  [<ffffffff81304001>] ? schedule_timeout+0x2e/0xdd
[ 2040.930626]  [<ffffffff8117864a>] ? blk_peek_request+0x18f/0x1a3
[ 2040.930654]  [<ffffffff81303e92>] ? wait_for_common+0xde/0x15b
[ 2040.930689]  [<ffffffff8103f832>] ? default_wake_function+0x0/0x9
[ 2040.930739]  [<ffffffffa030009e>] ? st_do_scsi+0x2c4/0x2f4 [st]
[ 2040.930771]  [<ffffffff8103709d>] ? __wake_up+0x30/0x44
[ 2040.930803]  [<ffffffffa03041b5>] ? st_write+0x615/0xa74 [st]
[ 2040.930845]  [<ffffffff810eb3c0>] ? vfs_write+0xa9/0x102
[ 2040.930872]  [<ffffffff810eb4d5>] ? sys_write+0x45/0x6e
[ 2040.930902]  [<ffffffff81008a82>] ? system_call_fastpath+0x16/0x1b

[ 2142.769455] drivers/scsi/mvsas/mv_sas.c 1716:mvs_abort_task:rc= -5

[ 2160.928073] INFO: task btape:4738 blocked for more than 120 seconds.
[ 2160.928105] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2160.928150] btape         D ffff88025caa6908     0  4738   4531 0x00000000
[ 2160.928188]  ffff88025ec6b680 0000000000000082 000000010000000c 0000000000000010
[ 2160.928238]  00000000000154c0 ffff88025d4c1fd8 ffff88025d4c1fd8 ffff88025caa6630
[ 2160.928301]  00000000000154c0 00000000000154c0 00000000000154c0 ffff88025caa6630
[ 2160.928351] Call Trace:
[ 2160.928381]  [<ffffffff81304001>] ? schedule_timeout+0x2e/0xdd
[ 2160.928413]  [<ffffffff8117864a>] ? blk_peek_request+0x18f/0x1a3
[ 2160.928450]  [<ffffffff81303e92>] ? wait_for_common+0xde/0x15b
[ 2160.928480]  [<ffffffff8103f832>] ? default_wake_function+0x0/0x9
[ 2160.928523]  [<ffffffffa030009e>] ? st_do_scsi+0x2c4/0x2f4 [st]
[ 2160.928552]  [<ffffffff8103709d>] ? __wake_up+0x30/0x44
[ 2160.928580]  [<ffffffffa03041b5>] ? st_write+0x615/0xa74 [st]
[ 2160.928610]  [<ffffffff810eb3c0>] ? vfs_write+0xa9/0x102
[ 2160.928637]  [<ffffffff810eb4d5>] ? sys_write+0x45/0x6e
[ 2160.928665]  [<ffffffff81008a82>] ? system_call_fastpath+0x16/0x1b
[ 2166.914940] drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 0
[ 2172.884346] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[2]:rc= 0
[ 2172.884354] drivers/scsi/mvsas/mv_sas.c 1967:Release slot [0] tag[0], task [ffff880250668fc0]:
[ 2172.884380] st1: Error 50000 (driver bt 0x0, host bt 0x5).




--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

DISCLAIMER:
-----------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only. 
It shall not attach any liability on the originator or HCL or its affiliates. Any views or opinions presented in 
this email are solely those of the author and may not necessarily reflect the opinions of HCL or its affiliates. 
Any form of reproduction, dissemination, copying, disclosure, modification, distribution and / or publication of 
this message without the prior written consent of the author of this e-mail is strictly prohibited. If you have 
received this email in error please delete it and notify the sender immediately. Before opening any mail and 
attachments please check them for viruses and defect.

-----------------------------------------------------------------------------------------------------------------------
