From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: Devices going offline on Adaptec 29320 using driver
	AIC79XXafter messages "Attempting to queue an ABORT message:CDB"
Date: Tue, 25 Nov 2008 16:14:54 -0600
Message-ID: <1227651294.3415.36.camel@localhost.localdomain>
References: <CA39D769C8FE694788CE376026984BAB0117D222@ILEXC1U01.ndc.lucent.com>
	 <1227650031.3415.31.camel@localhost.localdomain>
	 <CA39D769C8FE694788CE376026984BAB0117D26F@ILEXC1U01.ndc.lucent.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60014 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974AbYKYWO6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2008 17:14:58 -0500
In-Reply-To: <CA39D769C8FE694788CE376026984BAB0117D26F@ILEXC1U01.ndc.lucent.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Rhine, Jay (Jay)" <jrhine@alcatel-lucent.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2008-11-25 at 16:08 -0600, Rhine, Jay (Jay) wrote:
> > The slight problem here is that no-one has a sequencer manual which
> tells us what all this means.  However, it's 
> > completely normal since the driver has a dump_card_state() call in the
> abort routine.
> >
> > Why the abort was called in the first place is anyone's guess, but it
> > probably came from a command timing out.   The timeout could either be
> a
> > sequencer error or simply a normal problem because you're hammering
> the device hard and it took longer to get to the 
> > command to process.
> >
> > You can test this latter quite easily by doubling the command
> timeouts:
> >
> > echo 60 > /sys/class/scsi_disk/*/device/timeout
> >
> > And seeing if the trouble occurs with the same frequency.  If it does,
> there's likely some sequencer issue;  if the 
> > frequency decreases, it's device related and you can probably throttle
> the device by reducing the queue depth to avoid 
> > the situation.
> >
> > James
> 
> James,
> 
> 	That sounds like a good idea.  I will try to adjust the timeout.
> However, I have to ask about the "completely normal part".  I can see
> the abort message occasionaly occurring normally if the drives always
> recovered after the abort.  However, is it normal that the devices will
> go offline the second time this situation occurs?  I'm afraid my
> knowledge of SCSI does not go to this level of detail.  If it is normal,
> and I can substancially reduce the frequency by some tweaking I can live
> with that.  However, if this there is a real bug I would like to get it
> fixed.

Completely normal as in some disk arrays can take 60-120s to process
commands under heavy load ... this depends on disk array though.  The
classic one to do this is the EMC symmetrix:  It has such a massive
cache that it can accept I/O at cable rates while spitting it out to the
platters at less than this.  It's like a sink filling up until you reach
the overflow.  By the time this happens, it can take minutes to get data
from the cable across the cache to the platters causing command timeouts
unless the O/S is tuned to accept far longer timeout intervals.

If it's a bug in the sequencer, it's going to be very hard to fix
without documentation, so I'd hope for the former.

James


