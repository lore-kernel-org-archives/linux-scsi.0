From: John Sullivan <sullivan@enyo.com>
Subject: mvsas, errors with 88SE9485 in 4x PCI slot.
Date: Sun, 25 Sep 2011 04:31:25 -0700
Message-ID: <4E7F110D.6020500@enyo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from enyo.com ([192.220.73.72]:2720 "EHLO enyo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab1IYLiF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Sep 2011 07:38:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org


Hi,

I have a system with a Supermicro X9SCM (Intel C204 chipset) motherboard
and three Supermicro AOC-SAS2LP-MV8 controllers.

The AOC-SAS2LP-MV8 is based on the newer Marvell 88SE9485 controller,
which supports 8 channels of 6Gb/s SAS.  The `9485 is natively an 8x
PCI-E device.  This card is supported only in the latest 3.0/3.1.0-rc
kernels.  I am running 3.1.0-rc7.

The motherboard has 2 x8 PCI-E slots and 2 x4 PCI-E slots.  The `9845
in the x4 PCI-E slot consistently gets storms of errors from the mvsas
driver under heavy I/O, usually resulting in a drive getting kicked.

The cards in the x8 PCI-E slots work fine.  Under light I/O (moving or
copying small files) the x4 card is OK, but starting an md raid check
or rebuild operation or sustained large file copy dies in 2-3 minutes.

I have tried every combination I can think of, removing all but one card 
and then trying each of the 3 cards in both x8 and x4 slots.

There may be some flaw in my experiment, but as far as I can tell,
the only time I get errors is in the x4 slot.

These errors usually take the form of:

> [  360.342793] drivers/scsi/mvsas/mv_sas.c 1904:port 6 slot 24 rx_desc 30018 has error info8000000080000000.
> [  360.342801] drivers/scsi/mvsas/mv_94xx.c 595:command active EEFFFFEF,  slot [18].
> [  360.351415] drivers/scsi/mvsas/mv_sas.c 1904:port 4 slot 10 rx_desc 3000A has error info0000000001000000.
> [  360.351418] drivers/scsi/mvsas/mv_94xx.c 595:command active FFFFFBEF,  slot [a].
> [  360.352397] drivers/scsi/mvsas/mv_sas.c 1904:port 4 slot 27 rx_desc 3001B has error info0000000001000000.
> [  360.352399] drivers/scsi/mvsas/mv_94xx.c 595:command active F7FFDFEF,  slot [1b].
 > ...
> [  366.357261] sas: command 0xe745e480, task 0xe0876500, timed out: BLK_EH_NOT_HANDLED
> [  366.357264] sas: command 0xe6f3b180, task 0xe0877a40, timed out: BLK_EH_NOT_HANDLED
> [  366.357267] sas: command 0xe1234c00, task 0xe08768c0, timed out: BLK_EH_NOT_HANDLED
 > ...
> [  366.357295] sas: Enter sas_scsi_recover_host
> [  366.357297] sas: trying to find task 0xe0876500
> [  366.357298] sas: sas_scsi_find_task: aborting task 0xe0876500
> [  366.357301] drivers/scsi/mvsas/mv_sas.c 1678:mvs_abort_task() mvi=e9ac0000 task=e0876500 slot=e9ad78cc slot_idx=x7
> [  366.357303] sas: sas_scsi_find_task: task 0xe0876500 is aborted
> [  366.357305] sas: sas_eh_handle_sas_errors: task 0xe0876500 is aborted
 > ...
> [  366.357395] ata15: sas eh calling libata cmd error handler
> [  366.357399] ata1: sas eh calling libata port error handler
> [  366.357405] ata2: sas eh calling libata port error handler

This seems like an fairly specific, configuration dependent problem.

I assume this is supported (x8 controller in x4 PCI-slot) and should
"just work", but I don't have any confirmation one way or the other.

Can any one tell me if this should or shouldn't work?  Any suggestions
for a fix?  I am willing to test patches or step through code to debug
this if someone can give me a pointer to get started.

Thanks,
John.



