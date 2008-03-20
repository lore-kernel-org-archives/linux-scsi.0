From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic94xx driver woes continued
Date: Thu, 20 Mar 2008 14:01:54 -0500
Message-ID: <1206039714.3038.40.camel@localhost.localdomain>
References: <47E2B044.70705@ipax.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43002 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbYCTTB5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Mar 2008 15:01:57 -0400
In-Reply-To: <47E2B044.70705@ipax.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-03-20 at 19:43 +0100, Raoul Bhatia [IPAX] wrote:
> hi there,
> 
> we find ourself in the same situation as posted on this list before [1]
> 
> first of all, the hardware details:
> 
> System:
>  > Tyan Transport GT24-B3992
>  > Motherboard: Tyan B3992
>  > Dual Opteron 2218 (Dual-Core)
>  > 8GB RAM
> 
> SAS Controller:
>  > product: AIC-9410W SAS (Razor ASIC RAID)=20
>  > vendor: Adaptec
> 
>  > controler-bios: BIOS present (1,1), 1820
>  > controler-sequencer: Firmware version 1.1 (V30)
> 
> Harddisks:
>  > 4x Seagate Cheetah 15K.5 ST373455SS
> 
> There is a Software Raid10 on top of those 4 disks.
>  > vanilla kernel 2.6.25-rc5
>  > Debian GNU/Linux 4.0, AMD64
> 
> 
> coming to the problem description itself:
> 
> the server is booted, the raid is working as intended
>  > md4 : active raid10 sdb9[1] sda9[0] sdd9[3] sdc9[2]
>  >       100181120 blocks 64K chunks 2 near-copies [4/4] [UUUU]
> 
> now we mount /dev/md4 to /home, cd there and run an io intensive task
> such as stress, tiobench (or even raid-reinit is enough)
>  > stress --hdd 20 --hdd-bytes 2gb --hdd-noclean
> 
> soon we see:
>  > aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
>  > sas: command 0xffff81023fb2ca80, task 0xffff81023ea7ab40, timed out: 
> EH_NOT_HANDLED
>  > ...
>  > sas: Enter sas_scsi_recover_host
>  > sas: trying to find task 0xffff81023ea7ab40
>  > sas: sas_scsi_find_task: aborting task 0xffff81023ea7ab40
>  > ...
>  > sas: --- Exit sas_scsi_recover_host
> 
> please se the attached logfile.

This is all normal.  Seagate drives are known for throwing protocol
errors under stress at certain revs of firmware.  That's what
REQ_TASK_ABORT, reason=0x6 is.

Your logs indicate that the recovery occurred correctly (as in all tasks
were eventually retried), so it doesn't show an actual problem.

> sometimes even a disk is kicked out of the raid configuration.

This would be abnormal, if you have a log of this, could you post it.  I
assume it was because of I/O errors?

James


