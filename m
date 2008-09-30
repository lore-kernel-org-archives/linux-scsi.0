From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Tue, 30 Sep 2008 10:11:53 -0700
Message-ID: <20080930171153.GB4007@linux.vnet.ibm.com>
References: <Pine.LNX.4.44L0.0809301101000.2451-100000@iolanthe.rowland.org> <1222789380.3232.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58257 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbYI3RMK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 13:12:10 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m8UHC7QM007270
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2008 13:12:07 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m8UHC1Ax241312
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2008 13:12:01 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m8UHC1FC023545
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2008 13:12:01 -0400
Content-Disposition: inline
In-Reply-To: <1222789380.3232.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Tue, 2008-09-30 at 11:08 -0400, Alan Stern wrote:
> > On Tue, 30 Sep 2008, James Bottomley wrote:
> > 
> > > I don't really think this is the right approach, since the retry case
> > > needs to be split apart again.
> > > 
> > > The only time scsi_requeue_command() needs to be called is if the
> > > request completes successfully but has leftovers.  The reason is that
> > > the command will be different next time around, so it has to be
> > > re-prepared.  In all the other cases, the same command can be reused.
> > > This will have the knock on effect of not resetting the timers or the
> > > counters, so it has to be done carefully.
> > 
> > All right.  (Incidentally, do you happen to know the derivation of 
> > "knock on effect"?  The American form, "side effect", seems more 
> > self-explanatory.)
> 
> The etymology is probably from Rugby: a knock on takes the ball further
> than allowed by the rules, usually as an unintended consequence of some
> other action.
> 
> > > Of the three requeue cases:
> > > 
> > > UNIT_ATTENTION needs immediate retry
> > > NOT_READY needs delayed retry
> > > ILLEGAL_REQUEST with cmd switch (assuming we still do it) needs
> > > immediate retry
> > 
> > If the command is switched from 10-byte to 6-byte form, won't it need 
> > to be re-prepared?
> 
> Yes, sorry, that one needs a re-prepare requeue.
> 
> > > DID_RESET is arguable either way, but probably needs delayed.
> > > 
> > > immediate requeue is done by:
> > > 
> > > scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
> > > 
> > > And delayed by
> > > 
> > > scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> > 
> > Easily fixed.  And it looks like neither of these needs a call to
> > scsi_next_command(), right?
> 
> Right, which is a nice side effect.

scsi_finish_command is only called from scsi_eh_flush_done_q (newer
patches moves this to scsi_attempt_requeue_command) and scsi_softirq_done.
scsi_io_completion is only called from scsi_finish_command. In
scsi_softirq_done we just called scsi_decide_disposition to map the
result. Could some (or all) of the sense mapping be moved to
scsi_decide_disposition? It seems incorrect to decode this same data in
more than one location plus in some cases could prevent device handlers
from the full control they need. Is there some path or behavior that I am
missing?

Also since previous mid retry changes are related to retry behavior borrowing
this thread for a related request....

James, It would be good if you have time to look at the repost of mid
retry changes and if they are ok would you consider applying them plus
these changes.  It would be good to also have a refresh of
scsi-post-merge-2.6 tree with Jens tree. I am running testing now, but my
tree needed a lot of merging assistance and it would be good to know what
others are testing is the same.
http://thread.gmane.org/gmane.linux.scsi/44715

Since this change plus Mike C's and mine effect retry / completion
behavior it would be good to test these changes all together.

Thanks,

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
