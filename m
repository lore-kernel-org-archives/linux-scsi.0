From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: SCSI in a post 2.6.0 world
Date: 18 Dec 2003 10:40:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071762015.2378.44.camel@mulgrave>
References: <1071758885.2430.37.camel@mulgrave>
	<20031218153128.GA5389@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:58258 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265216AbTLRPnw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2003 10:43:52 -0500
In-Reply-To: <20031218153128.GA5389@gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2003-12-18 at 10:31, Jeff Garzik wrote:
> FWIW, I'm going to be working in this area, for 2.7.
> 
> My plan has two main goals,
> 
> (a) move the low-level driver API "up" from SCSI, to be available to all
> block drivers.

I agree with this, with caveats: the LLD API for SCSI is designed to be
a command based API, not a register based one.  I see no reason not to
have either a second LLD API that is register based, or a command to
register converter API (sort of like how ide-scsi should have been
done), but I think more discussion on how to do this needs to take
place.

> (b) consolidate "personality" code:  foodisk.c will drive
> PATA/SATA/SCSI/RAID/whatever disks.  foocdrom.c will drive cd-roms.
> footape.c will drive tapes.

In principle this is fine...both SCSI and IDE today use request prep
functions.  It's not such a huge step to do the personality processing
in the prep function (a bit like ide-cd does).

> The overall goal is to have all low-level block drivers at the same
> level, simply utilizing subsystem-specific hooks to provide
> SCSI-specific behavior.
> 
> And all this will be accomplished through evolution of existing code.
> You have convinced me that SCSI doesn't need yet another rewrite ;-) so
> I will be leveraging all the work that's gone into SCSI in 2.6...
> 
> Whenever you hear me mention "/dev/disk", the above is what I am
> referring to.

Well, I'm agnostic on that one.  Having major number discrimination
among ULDs does help figure out command routings, but if it can be done
another way...At the end of the day, udev will completely separate
numbering from naming, so /dev/disc<n> is feasible even in the current
scheme.

As part of this project, were you planning to look at how character
devices can be improved?

James


