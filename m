From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: SCSI in a post 2.6.0 world
Date: Thu, 18 Dec 2003 13:22:30 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10312181320100.7879-100000@master.linux-ide.org>
References: <20031218155728.GA8663@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:48397
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S265333AbTLRVam (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2003 16:30:42 -0500
In-Reply-To: <20031218155728.GA8663@gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


JG,

I gotta stop having these midnight sessions of conversation with you, one
idea and you explode in a fever to change the world.  I agree of the need,
I just have concern for actually deployment with out a dual path for
testing.

Recall our discussion on ./drivers/storage

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Thu, 18 Dec 2003, Jeff Garzik wrote:

> On Thu, Dec 18, 2003 at 10:40:14AM -0500, James Bottomley wrote:
> > On Thu, 2003-12-18 at 10:31, Jeff Garzik wrote:
> > > FWIW, I'm going to be working in this area, for 2.7.
> > > 
> > > My plan has two main goals,
> > > 
> > > (a) move the low-level driver API "up" from SCSI, to be available to all
> > > block drivers.
> > 
> > I agree with this, with caveats: the LLD API for SCSI is designed to be
> > a command based API, not a register based one.  I see no reason not to
> > have either a second LLD API that is register based, or a command to
> > register converter API (sort of like how ide-scsi should have been
> > done), but I think more discussion on how to do this needs to take
> > place.
> 
> No need for caveats.  There will be no register-based LLD API.
> 
> Command-based is fine.  SATA _needs_ command-based, because ATA these
> days is queued.
> 
> Recall, some crazy cracker created ATA-over-ethernet <grin>
> 
> 
> > > (b) consolidate "personality" code:  foodisk.c will drive
> > > PATA/SATA/SCSI/RAID/whatever disks.  foocdrom.c will drive cd-roms.
> > > footape.c will drive tapes.
> > 
> > In principle this is fine...both SCSI and IDE today use request prep
> > functions.  It's not such a huge step to do the personality processing
> > in the prep function (a bit like ide-cd does).
> 
> You got it.
> 
> 
> > > The overall goal is to have all low-level block drivers at the same
> > > level, simply utilizing subsystem-specific hooks to provide
> > > SCSI-specific behavior.
> > > 
> > > And all this will be accomplished through evolution of existing code.
> > > You have convinced me that SCSI doesn't need yet another rewrite ;-) so
> > > I will be leveraging all the work that's gone into SCSI in 2.6...
> > > 
> > > Whenever you hear me mention "/dev/disk", the above is what I am
> > > referring to.
> > 
> > Well, I'm agnostic on that one.  Having major number discrimination
> > among ULDs does help figure out command routings, but if it can be done
> > another way...At the end of the day, udev will completely separate
> > numbering from naming, so /dev/disc<n> is feasible even in the current
> > scheme.
> 
> Indeed.
> 
> 
> > As part of this project, were you planning to look at how character
> > devices can be improved?
> 
> Absolutely.  /dev/tape is part of this too.  And I'm hoping SCSI
> generic will go away in favor of Jens' "bsg", which allows userspace
> to send SCSI CDBs, ATA taskfiles, RAID I2O messages, or whatever.
> 
> 	Jeff
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

