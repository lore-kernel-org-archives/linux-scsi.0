From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 2.6.36
Date: Sat, 4 Dec 2010 04:52:04 -0700
Message-ID: <201012040452.04587.thomas@fjellstrom.ca>
References: <201010290650.32892.thomas@fjellstrom.ca> <4CF95394.7010400@redhat.com> <201012041550372348573@usish.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomasu.net ([64.85.170.234]:50470 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab0LDLwW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Dec 2010 06:52:22 -0500
In-Reply-To: <201012041550372348573@usish.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang <jack_wang@usish.com>
Cc: David Milburn <dmilburn@redhat.com>, Andre Tomt <andre@tomt.net>, Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On December 4, 2010, jack_wang wrote:
> Hi, I've done as you requested.
> here's all of the output from the first (and currently only) event:
> [ 1428.000080] sas: command 0xffff880184ed1680, task 0xffff88017a0f2680, timed out: BLK_EH_NOT_HANDLED
> [ 1428.080051] sas: command 0xffff880224e03880, task 0xffff88017a0f24c0, timed out: BLK_EH_NOT_HANDLED
> [ 1428.080077] sas: Enter sas_scsi_recover_host
> [ 1428.080085] sas: trying to find task 0xffff88017a0f2680
> [ 1428.080092] sas: sas_scsi_find_task: aborting task 0xffff88017a0f2680
> [ 1428.080102] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff88017a0f2680 slot=ffff880224066680 slot_idx=x4
> [ 1428.080113] sas: sas_scsi_find_task: querying task 0xffff88017a0f2680
> [ 1428.080119] drivers/scsi/mvsas/mv_sas.c 1632:mvs_query_task:rc= 5
> [ 1428.080125] sas: sas_scsi_find_task: task 0xffff88017a0f2680 failed to abort
> [ 1428.080130] sas: task 0xffff88017a0f2680 is not at LU: I_T recover
> [ 1428.080135] sas: I_T nexus reset for dev 0000000000000000
> [ 1428.080172] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x89800.
> [ 1428.080180] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x1001
> [ 1428.080193] drivers/scsi/mvsas/mv_sas.c 2111:phy0 Unplug Notice
> [ 1428.090228] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x199800.
> [ 1428.090236] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x1081
> [ 1428.111954] drivers/scsi/mvsas/mv_sas.c 2083:port 0 ctrl sts=0x199800.
> [ 1428.111962] drivers/scsi/mvsas/mv_sas.c 2085:Port 0 irq sts = 0x10000
> [ 1428.111969] drivers/scsi/mvsas/mv_sas.c 2138:notify plug in on phy[0]
> [ 1428.146351] drivers/scsi/mvsas/mv_sas.c 1224:port 0 attach dev info is 20004
> [ 1428.146351] drivers/scsi/mvsas/mv_sas.c 1226:port 0 attach sas addr is 0
> [ 1428.222044] drivers/scsi/mvsas/mv_sas.c 378:phy 0 byte dmaded.
> [ 1428.222109] sas: sas_form_port: phy0 belongs to port0 already(1)!
> [ 1430.300028] drivers/scsi/mvsas/mv_sas.c 1586:mvs_I_T_nexus_reset for device[0]:rc= 0
> [ 1430.300040] sas: I_T 0000000000000000 recovered
> [ 1430.300048] sas: sas_ata_task_done: SAS error 8d
> [ 1430.300059] ata9: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> [ 1430.300883] ata9.00: device reported invalid CHS sector 0
> [ 1430.300888] ata9: status=0x01 { Error }
> [ 1430.300894] ata9: error=0x04 { DriveStatusError }
> [ 1430.300950] sas: trying to find task 0xffff88017a0f24c0
> [ 1430.300956] sas: sas_scsi_find_task: aborting task 0xffff88017a0f24c0
> [ 1430.300963] sas: sas_scsi_find_task: task 0xffff88017a0f24c0 is done
> [ 1430.300968] sas: sas_eh_handle_sas_errors: task 0xffff88017a0f24c0 is done
> [ 1430.300974] sas: sas_ata_task_done: SAS error 8d
> [ 1430.300982] ata12: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> [ 1430.301777] ata12.00: device reported invalid CHS sector 0
> [ 1430.301782] ata12: status=0x01 { Error }
> [ 1430.301788] ata12: error=0x04 { DriveStatusError }
> [ 1430.301808] sas: --- Exit sas_scsi_recover_host
> Thanks.
> 
> [Jack] The error shows that there are two commands have no respounse utill the timer timeout, and scsi host enter error hander
> to quary and abort task but all failed so try to reset the device .
> 
> I look into mvs_abort_task in mv_sas.c,
> if (SATA_DEV == dev->dev_type) {
> struct mvs_slot_info *slot = task->lldd_task;
> struct task_status_struct *tstat;
> u32 slot_idx = (u32)(slot - mvi->slot_info);
> tstat = &task->task_status;
> mv_dprintk(KERN_DEBUG "mv_abort_task() mvi=%p task=%p "
>    "slot=%p slot_idx=x%x\n",
>    mvi, task, slot, slot_idx);
> tstat->stat = SAS_ABORTED_TASK;
> if (mvi_dev && mvi_dev->running_req)
> mvi_dev->running_req--;
> if (sas_protocol_ata(task->task_proto))
> mvs_free_reg_set(mvi, mvi_dev);
> mvs_slot_task_free(mvi, task, slot, slot_idx);
> return -1;
>  //// here the return -1 looks suspicuse , you can remove it to have a try
> >
> [Jack] Sorry, please try to use return 0 to see if help. 

Here is what I get with that returning 0 rather than -1 as you requested:

[19107.040031] sas: command 0xffff88011c77f9c0, task 0xffff88022ae51600, timed out: BLK_EH_NOT_HANDLED
[19107.040062] sas: Enter sas_scsi_recover_host
[19107.040072] sas: trying to find task 0xffff88022ae51600
[19107.040079] sas: sas_scsi_find_task: aborting task 0xffff88022ae51600
[19107.040089] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff88022ae51600 slot=ffff880224066680 slot_idx=x4
[19107.040101] sas: sas_scsi_find_task: task 0xffff88022ae51600 is aborted
[19107.040107] sas: sas_eh_handle_sas_errors: task 0xffff88022ae51600 is aborted
[19107.040113] sas: sas_ata_task_done: SAS error 8d
[19107.040124] ata21: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
[19107.040860] ata21: status=0x01 { Error }
[19107.040866] ata21: error=0x04 { DriveStatusError }
[19107.040886] sas: --- Exit sas_scsi_recover_host
[19318.000085] sas: command 0xffff8801250291c0, task 0xffff88018a8e5b80, timed out: BLK_EH_NOT_HANDLED
[19318.000125] sas: Enter sas_scsi_recover_host
[19318.000135] sas: trying to find task 0xffff88018a8e5b80
[19318.000141] sas: sas_scsi_find_task: aborting task 0xffff88018a8e5b80
[19318.000152] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff88018a8e5b80 slot=ffff8802240666d8 slot_idx=x5
[19318.000163] sas: sas_scsi_find_task: task 0xffff88018a8e5b80 is aborted
[19318.000169] sas: sas_eh_handle_sas_errors: task 0xffff88018a8e5b80 is aborted
[19318.000175] sas: sas_ata_task_done: SAS error 8d
[19318.000185] ata24: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
[19318.000896] ata24: status=0x01 { Error }
[19318.000902] ata24: error=0x04 { DriveStatusError }
[19318.000922] sas: --- Exit sas_scsi_recover_host

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
