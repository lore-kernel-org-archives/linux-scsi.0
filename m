From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: 03 Sep 2002 21:59:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1031086777.21579.33.camel@irongate.swansea.linux.org.uk>
References: <200209031909.g83J9iG07312@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200209031909.g83J9iG07312@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2002-09-03 at 20:09, James Bottomley wrote:
> dledford@redhat.com said:
> > Leave abort active.  It does actually work in certain scenarios.  The
> > CD  burner scenario that started this thread is an example of
> > somewhere that  an abort should actually do the job. 
> 
> Unfortunately, it would destroy the REQ_BARRIER approach in the block layer.  
> At best, abort probably causes a command to overtake a barrier it shouldn't, 
> at worst we abort the ordered tag that is the barrier and transactional 
> integrity is lost.

What do we plan to do for the cases where reset is disabled because we
have shared disk scsi so don't want to reset and hose the reservations ?

If your error correction always requires all commands return to the
block layer then the block layer is IMHO broken. Its messy enough doing
that before you hit the fun situations where insert scsi commands of
their own the block layer never initiated.

Next you only need to return stuff if commands have been issued between
the aborting command and a barrier. Since most sane systems will never
be causing REQ_BARRIER that should mean the general case for an abort is
going to be fine. The CD burner example is also true for this. If we
track barrier sequences then we will know the barrier count for the
command we are aborting and the top barrier count for commands issued to
the device. Finally you only need to go to the large hammer approach
when you are dealing with a media changing command (ie WRITE*) - if we
abort a read then knowing we don't queue overlapping read then write to
disk we already know that the read will not break down the tag ordering
as I understand it ?

If we get to the point we need an abort we don't want to issue a reset.
Not every device comes back sane from a reset and in some cases we have
to issue a whole sequence of commands to get the state of the device
back (door locking, power management, ..)

