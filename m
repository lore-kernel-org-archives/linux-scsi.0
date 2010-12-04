From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 2.6.36
Date: Sat, 4 Dec 2010 08:44:47 -0700
Message-ID: <201012040844.47337.thomas@fjellstrom.ca>
References: <201010290650.32892.thomas@fjellstrom.ca> <201012042033380623575@usish.com> <201012040554.31111.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomasu.net ([64.85.170.234]:37243 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209Ab0LDPou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Dec 2010 10:44:50 -0500
In-Reply-To: <201012040554.31111.thomas@fjellstrom.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang <jack_wang@usish.com>
Cc: David Milburn <dmilburn@redhat.com>, Andre Tomt <andre@tomt.net>, Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On December 4, 2010, Thomas Fjellstrom wrote:
> On December 4, 2010, jack_wang wrote:
> > 
> > Here is what I get with that returning 0 rather than -1 as you requested:
> > [19107.040031] sas: command 0xffff88011c77f9c0, task 0xffff88022ae51600, timed out: BLK_EH_NOT_HANDLED
> > [19107.040062] sas: Enter sas_scsi_recover_host
> > [19107.040072] sas: trying to find task 0xffff88022ae51600
> > [19107.040079] sas: sas_scsi_find_task: aborting task 0xffff88022ae51600
> > [19107.040089] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff88022ae51600 slot=ffff880224066680 slot_idx=x4
> > [19107.040101] sas: sas_scsi_find_task: task 0xffff88022ae51600 is aborted
> > [19107.040107] sas: sas_eh_handle_sas_errors: task 0xffff88022ae51600 is aborted
> > [19107.040113] sas: sas_ata_task_done: SAS error 8d
> > [19107.040124] ata21: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> > [19107.040860] ata21: status=0x01 { Error }
> > [19107.040866] ata21: error=0x04 { DriveStatusError }
> > [19107.040886] sas: --- Exit sas_scsi_recover_host
> > [19318.000085] sas: command 0xffff8801250291c0, task 0xffff88018a8e5b80, timed out: BLK_EH_NOT_HANDLED
> > [19318.000125] sas: Enter sas_scsi_recover_host
> > [19318.000135] sas: trying to find task 0xffff88018a8e5b80
> > [19318.000141] sas: sas_scsi_find_task: aborting task 0xffff88018a8e5b80
> > [19318.000152] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880224040000 task=ffff88018a8e5b80 slot=ffff8802240666d8 slot_idx=x5
> > [19318.000163] sas: sas_scsi_find_task: task 0xffff88018a8e5b80 is aborted
> > [19318.000169] sas: sas_eh_handle_sas_errors: task 0xffff88018a8e5b80 is aborted
> > [19318.000175] sas: sas_ata_task_done: SAS error 8d
> > [19318.000185] ata24: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
> > [19318.000896] ata24: status=0x01 { Error }
> > [19318.000902] ata24: error=0x04 { DriveStatusError }
> > [19318.000922] sas: --- Exit sas_scsi_recover_host
> > 
> > 
> > 
> > [Jack] Do all the drives discoverd? There are still commands timeout, maybe the disks need more time to response, or something
> > wrong with the driver, I'm not sure.
> 
> All drives come up. That last set of logs is something that happens once
> or twice an hour while running. I just rebooted again to see what
> difference the change makes with a fresh startup. So far it seems that
> the controller is running properly in SATA II/3Gbps mode after the reboot.
> 
> Just to contrast what the kernel reports in the two scenarios:
> rmmod+modprobe:
> sas: DOING DISCOVERY on port 0, pid:7283
> drivers/scsi/mvsas/mv_sas.c 1388:found dev[0:5] is gone.
> sas: sas_ata_phy_reset: Found ATA device.
> ata15.00: ATA-8: ST31000528AS, CC34, max UDMA/133
> ata15.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata15.00: qc timeout (cmd 0xef)
> [snip mvsas reset]
> sas: sas_ata_phy_reset: Found ATA device.
> sas: sas_to_ata_err: Saw error 2.  What to do?
> sas: sas_ata_task_done: SAS error 2
> ata15.00: failed to IDENTIFY (I/O error, err_mask=0x100)
> sas: STUB sas_ata_scr_read
> ata15: limiting SATA link speed to 1.5 Gbps
> ata15.00: limiting speed to UDMA/133:PIO3
> 
> fresh boot:
> sas: DOING DISCOVERY on port 0, pid:312
> drivers/scsi/mvsas/mv_sas.c 1388:found dev[0:5] is gone.
> sas: sas_ata_phy_reset: Found ATA device.
> ata9.00: ATA-8: ST31000528AS, CC34, max UDMA/133
> ata9.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
> ata9.00: configured for UDMA/133
> 
> This seems to happen on all ports. As does my original issue, though it
> (the original issue) doesn't happen to all ports at the same time, rather
> events seem to randomly happen, to one or more ports at random times.
> 
> As you can see, the drive are 1TB Seagate SATAII drives. They are setup
> in a md-raid 5 array. Luckily these events don't bubble any errors up
> the stack causing a rebuild.

Even after the reboot it still happens, though with that change, it /seems/
as if the pause is gone, but I can't be sure yet.

[ 6080.020026] sas: command 0xffff880172dfbe80, task 0xffff8800379cbb40, timed out: BLK_EH_NOT_HANDLED
[ 6080.020053] sas: Enter sas_scsi_recover_host
[ 6080.020062] sas: trying to find task 0xffff8800379cbb40
[ 6080.020069] sas: sas_scsi_find_task: aborting task 0xffff8800379cbb40
[ 6080.020079] drivers/scsi/mvsas/mv_sas.c 1703:<7>mv_abort_task() mvi=ffff880222a00000 task=ffff8800379cbb40 slot=ffff880222a26680 slot_idx=x4
[ 6080.020090] sas: sas_scsi_find_task: task 0xffff8800379cbb40 is aborted
[ 6080.020096] sas: sas_eh_handle_sas_errors: task 0xffff8800379cbb40 is aborted
[ 6080.020102] sas: sas_ata_task_done: SAS error 8d
[ 6080.020113] ata9: translated ATA stat/err 0x01/04 to SCSI SK/ASC/ASCQ 0xb/00/00
[ 6080.020931] ata9: status=0x01 { Error }
[ 6080.020937] ata9: error=0x04 { DriveStatusError }
[ 6080.021008] sas: --- Exit sas_scsi_recover_host

Hopefully we can figure out whats causing these errors.

> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 
> 
> 


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
