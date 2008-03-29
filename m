From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: aic94xx driver woes continued
Date: Sat, 29 Mar 2008 15:33:46 -0700 (PDT)
Message-ID: <651476.15877.qm@web31809.mail.mud.yahoo.com>
References: <1206039714.3038.40.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:49053 "HELO
	web31809.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751066AbYC2Wk2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Mar 2008 18:40:28 -0400
In-Reply-To: <1206039714.3038.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

--- On Thu, 3/20/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Subject: Re: aic94xx driver woes continued
> To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
> Cc: linux-scsi@vger.kernel.org
> Date: Thursday, March 20, 2008, 12:01 PM
> On Thu, 2008-03-20 at 19:43 +0100, Raoul Bhatia [IPAX]
> wrote:
> > hi there,
> > 
> > we find ourself in the same situation as posted on
> this list before [1]
> > 
> > first of all, the hardware details:
> > 
> > System:
> >  > Tyan Transport GT24-B3992
> >  > Motherboard: Tyan B3992
> >  > Dual Opteron 2218 (Dual-Core)
> >  > 8GB RAM
> > 
> > SAS Controller:
> >  > product: AIC-9410W SAS (Razor ASIC RAID)=20
> >  > vendor: Adaptec
> > 
> >  > controler-bios: BIOS present (1,1), 1820
> >  > controler-sequencer: Firmware version 1.1 (V30)
> > 
> > Harddisks:
> >  > 4x Seagate Cheetah 15K.5 ST373455SS
> > 
> > There is a Software Raid10 on top of those 4 disks.
> >  > vanilla kernel 2.6.25-rc5
> >  > Debian GNU/Linux 4.0, AMD64
> > 
> > 
> > coming to the problem description itself:
> > 
> > the server is booted, the raid is working as intended
> >  > md4 : active raid10 sdb9[1] sda9[0] sdd9[3]
> sdc9[2]
> >  >       100181120 blocks 64K chunks 2 near-copies
> [4/4] [UUUU]
> > 
> > now we mount /dev/md4 to /home, cd there and run an io
> intensive task
> > such as stress, tiobench (or even raid-reinit is
> enough)
> >  > stress --hdd 20 --hdd-bytes 2gb --hdd-noclean
> > 
> > soon we see:
> >  > aic94xx: escb_tasklet_complete: REQ_TASK_ABORT,
> reason=0x6
> >  > sas: command 0xffff81023fb2ca80, task
> 0xffff81023ea7ab40, timed out: 
> > EH_NOT_HANDLED
> >  > ...
> >  > sas: Enter sas_scsi_recover_host
> >  > sas: trying to find task 0xffff81023ea7ab40
> >  > sas: sas_scsi_find_task: aborting task
> 0xffff81023ea7ab40
> >  > ...
> >  > sas: --- Exit sas_scsi_recover_host
> > 
> > please se the attached logfile.
> 
> This is all normal.  Seagate drives are known for throwing
> protocol
> errors under stress at certain revs of firmware. 
> That's what
> REQ_TASK_ABORT, reason=0x6 is.

Reason 6 just means a "Protocol Error", without access to the HW
registers, sequencer and most importantly a protocol link trace of
the problem for analysis, you cannot be sure whose fault it is and why.

    Luben

