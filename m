From: "Wouter Naaktgeboren" <wouter_naaktgeboren@xs4all.nl>
Subject: mvsas: ongoing problems with freezes with Marvell 6480
Date: Fri, 3 Sep 2010 11:39:57 +0200
Message-ID: <000301cb4b4b$f899f1e0$e9cdd5a0$@nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1611 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0ICJkB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Sep 2010 05:40:01 -0400
Received: from Quadpower (a1175.upc-a.chello.nl [62.163.1.175])
	(authenticated bits=0)
	by smtp-vbr7.xs4all.nl (8.13.8/8.13.8) with ESMTP id o839dxWH079071
	for <linux-scsi@vger.kernel.org>; Fri, 3 Sep 2010 11:39:59 +0200 (CEST)
	(envelope-from wouter_naaktgeboren@xs4all.nl)
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I'm currently using Debian Lenny with 2.6.36-rc3. The errors still continue
to appear,
I am using 2x Supermicro SASLP-MV8 with 8x2TB drives and another server with
1 controller
and 7 drives, both in a raid6 setup.

The following errors keep appearing on random drives:
[159834.848088] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task()
mvi=ffff88011b800000 task=ffff880005456100 slot=ffff88011b826788 slot_idx=x7
[159834.848094] drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
[159834.848110] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x89800.
[159834.848112] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x1001
[159834.848117] drivers/scsi/mvsas/mv_sas.c 2111:phy1 Unplug Notice
[159834.858090] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x199800.
[159834.858092] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x1081
[159836.856068] mvsas 0000:03:00.0: Phy1 : No sig fis
[159836.856068] drivers/scsi/mvsas/mv_sas.c 2024:phy1 Attached Device
[159836.901772] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x89800.
[159836.901774] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x1001001
[159836.901779] drivers/scsi/mvsas/mv_sas.c 2111:phy1 Unplug Notice
[159836.901801] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x199800.
[159836.901803] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x81
[159836.905970] drivers/scsi/mvsas/mv_sas.c 2083:port 1 ctrl sts=0x199800.
[159836.905972] drivers/scsi/mvsas/mv_sas.c 2085:Port 1 irq sts = 0x10000
[159836.905975] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[1]
[159836.909962] drivers/scsi/mvsas/mv_sas.c 1224:port 1 attach dev info is
8000000
[159836.909962] drivers/scsi/mvsas/mv_sas.c 1226:port 1 attach sas addr is 1
[159836.909962] drivers/scsi/mvsas/mv_sas.c 378:phy 1 byte dmaded.
[159837.056084] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for
device[1]:rc= 0

the array hangs after this message.

[159837.056091] ata8: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ
0xb/00/00
[159837.056101] ata8.00: device reported invalid CHS sector 0
[159837.056103] ata8: status=0x01 { Error }
[159837.056105] ata8: error=0x04 { DriveStatusError }

And unhangs after this message. I have notice that if I run "mdadm --detail
/dev/md0" the
array immediately unhangs and continues as normal. If I do nothing the array
will hang for
10-15 seconds before continuing as normal. The disks don't drop out of the
array, but the
freezes are driving me insane. 

-Wouter

