From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: 03 Sep 2002 22:54:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1031090078.21439.37.camel@irongate.swansea.linux.org.uk>
References: <200209032132.g83LWdD09043@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200209032132.g83LWdD09043@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2002-09-03 at 22:32, James Bottomley wrote:
> I think the block layer, which already knows about the barrier ordering, is 
> the appropriate place for this.  If you think the scsi error handler is a 
> hairy wart now, just watch it grow into a stonking great carbuncle as I try to 
> introduce it to the concept of command queue ordering and appropriate recovery.

Point taken

> I agree with your reasoning.  However, errors occur infrequently enough (I 
> hope) so that its just not worth the extra code complexity to make the error 
> handler look for that case.

When you ar ehandling CD-ROM problems then they can be quite a lot. Not
helped by the fact some ancient CD's seem to like to take a long walk in
the park when told to reset.

> cancellation implementations, it's potentially full of holes.  The only uses 
> it might have---like oops I didn't mean to fixate that CD, give it back to me 
> now---aren't clearly defined in the SPEC to produce the desired effect (stop 
> the fixation so the drive door can be opened).

Yes but does windows assume it. There are two specs 8)

> The pain of coming back from a reset (and I grant, it isn't trivial) is well 
> known and well implemented in SCSI.  It also, from error handlings point of 
> view, sets the device back to a known point in the state model.
> 

Resetting the bus is antisocial to say the least. We had lots of hangs
with the old eh handler that went away when the new one didnt keep
resetting the bus. If we do reset the bus then we have to handle "Sorry
can't reset the bus" (we have cards that can't or won't) as well as
being conservative about timings, making sure we don't reset the bus
during the seconds while a device rattles back into online state and so
on.

