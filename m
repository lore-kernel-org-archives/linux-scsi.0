From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SCSI in a post 2.6.0 world
Date: Thu, 18 Dec 2003 10:57:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031218155728.GA8663@gtf.org>
References: <1071758885.2430.37.camel@mulgrave> <20031218153128.GA5389@gtf.org> <1071762015.2378.44.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([63.247.75.124]:56717 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S265242AbTLRP53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2003 10:57:29 -0500
Content-Disposition: inline
In-Reply-To: <1071762015.2378.44.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Dec 18, 2003 at 10:40:14AM -0500, James Bottomley wrote:
> On Thu, 2003-12-18 at 10:31, Jeff Garzik wrote:
> > FWIW, I'm going to be working in this area, for 2.7.
> > 
> > My plan has two main goals,
> > 
> > (a) move the low-level driver API "up" from SCSI, to be available to all
> > block drivers.
> 
> I agree with this, with caveats: the LLD API for SCSI is designed to be
> a command based API, not a register based one.  I see no reason not to
> have either a second LLD API that is register based, or a command to
> register converter API (sort of like how ide-scsi should have been
> done), but I think more discussion on how to do this needs to take
> place.

No need for caveats.  There will be no register-based LLD API.

Command-based is fine.  SATA _needs_ command-based, because ATA these
days is queued.

Recall, some crazy cracker created ATA-over-ethernet <grin>


> > (b) consolidate "personality" code:  foodisk.c will drive
> > PATA/SATA/SCSI/RAID/whatever disks.  foocdrom.c will drive cd-roms.
> > footape.c will drive tapes.
> 
> In principle this is fine...both SCSI and IDE today use request prep
> functions.  It's not such a huge step to do the personality processing
> in the prep function (a bit like ide-cd does).

You got it.


> > The overall goal is to have all low-level block drivers at the same
> > level, simply utilizing subsystem-specific hooks to provide
> > SCSI-specific behavior.
> > 
> > And all this will be accomplished through evolution of existing code.
> > You have convinced me that SCSI doesn't need yet another rewrite ;-) so
> > I will be leveraging all the work that's gone into SCSI in 2.6...
> > 
> > Whenever you hear me mention "/dev/disk", the above is what I am
> > referring to.
> 
> Well, I'm agnostic on that one.  Having major number discrimination
> among ULDs does help figure out command routings, but if it can be done
> another way...At the end of the day, udev will completely separate
> numbering from naming, so /dev/disc<n> is feasible even in the current
> scheme.

Indeed.


> As part of this project, were you planning to look at how character
> devices can be improved?

Absolutely.  /dev/tape is part of this too.  And I'm hoping SCSI
generic will go away in favor of Jens' "bsg", which allows userspace
to send SCSI CDBs, ATA taskfiles, RAID I2O messages, or whatever.

	Jeff



