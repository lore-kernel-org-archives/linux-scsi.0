From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
Date: Wed, 17 Nov 2010 09:28:39 -0600
Message-ID: <1290007719.4736.9.camel@mulgrave.site>
References: <20101117062958.GA2894@havoc.gtf.org>
	 <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com>
	 <4CE38D70.4010507@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758252Ab0KQP2o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 10:28:44 -0500
In-Reply-To: <4CE38D70.4010507@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>

On Wed, 2010-11-17 at 03:08 -0500, Jeff Garzik wrote:
> On 11/17/2010 01:44 AM, Linus Torvalds wrote:
> > On Tue, Nov 16, 2010 at 10:29 PM, Jeff Garzik<jeff@garzik.org>  wrote:
> >>
> >> +       spin_lock(shost->host_lock);
> >> +       scsi_cmd_get_serial(shost, cmd);
> >>         spin_unlock(shost->host_lock);
> >
> > This is just sad.
> >
> > How important is that serial number? So important that we need to do a
> > spinlock over it here? And it _must_ be per-shost?
> 
> Quite unimportant.  Quoting James from 
> http://marc.info/?l=linux-kernel&m=128949079704323&w=2
> > There are only a few drivers left that actually make use of a serial
> > number.  Of those, the only modern ones are qla4, lpfc, mpt2sas and
> > megaraid.
> >
> > So the next logical step seems to be eliminate the overloading of the
> > serial number zero value, which removes the last mid-layer use (dpt_i2o
> > seems to abuse this unnecessarily as well), then the serial number code
> > can be pushed down into the queuecommand routines of only those drivers
> > that actually use it.  None of the modern ones seems to have a
> > legitimate use, so I think their uses can mostly be eliminated.  Thus,
> > we might be able to get away with a simple queuecommand push down and
> > never bother with atomics for this (since it's unlikely the legacy users
> > would convert away from a lock wrapping their queuecommand routines).
> 
> 
> Looking solely at the SCSI code (ie. ignoring LLD code), it seems like 
> the magic number zero for serial_number is signaling a boolean condition 
> "are we an EH command?"
> 
> EH tests this at the very beginning of the abort/reset/explode error 
> handling sequence, presumably to avoid recursive EH invocations 
> (scsi_try_to_abort_cmd).
> 
> So maybe an EH expert (Tejun?) can correct me here, but I think we may 
> be able to completely the lock/get-serial/unlock sequence from libata, 
> as long as scsi_init_cmd_errh() reliably sets an "I am an EH command" flag.
> 
> Would be nice if true...

Right ... I couldn't persuade anyone else to do it, so I'll probably end
up coding it.  It looks like the serial number zero check might be
bogus.  If so I'll remove it, then push the serial number acquisition
down only into the locked queuecommand of only those drivers that
actually use it (which were listed in the quoted email, and which might
have a big impetus to remove it if the use is trivial).  Then we can
begin unwinding the locking.

James


