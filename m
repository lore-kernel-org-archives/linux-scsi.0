From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Tue, 30 Sep 2008 13:07:26 -0500
Message-ID: <1222798046.3232.59.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0809301101000.2451-100000@iolanthe.rowland.org>
	 <1222789380.3232.33.camel@localhost.localdomain>
	 <20080930171153.GB4007@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52432 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752812AbYI3SHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 14:07:55 -0400
In-Reply-To: <20080930171153.GB4007@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2008-09-30 at 10:11 -0700, Mike Anderson wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > On Tue, 2008-09-30 at 11:08 -0400, Alan Stern wrote:
> > > On Tue, 30 Sep 2008, James Bottomley wrote:
> > > 
> > > > I don't really think this is the right approach, since the retry case
> > > > needs to be split apart again.
> > > > 
> > > > The only time scsi_requeue_command() needs to be called is if the
> > > > request completes successfully but has leftovers.  The reason is that
> > > > the command will be different next time around, so it has to be
> > > > re-prepared.  In all the other cases, the same command can be reused.
> > > > This will have the knock on effect of not resetting the timers or the
> > > > counters, so it has to be done carefully.
> > > 
> > > All right.  (Incidentally, do you happen to know the derivation of 
> > > "knock on effect"?  The American form, "side effect", seems more 
> > > self-explanatory.)
> > 
> > The etymology is probably from Rugby: a knock on takes the ball further
> > than allowed by the rules, usually as an unintended consequence of some
> > other action.
> > 
> > > > Of the three requeue cases:
> > > > 
> > > > UNIT_ATTENTION needs immediate retry
> > > > NOT_READY needs delayed retry
> > > > ILLEGAL_REQUEST with cmd switch (assuming we still do it) needs
> > > > immediate retry
> > > 
> > > If the command is switched from 10-byte to 6-byte form, won't it need 
> > > to be re-prepared?
> > 
> > Yes, sorry, that one needs a re-prepare requeue.
> > 
> > > > DID_RESET is arguable either way, but probably needs delayed.
> > > > 
> > > > immediate requeue is done by:
> > > > 
> > > > scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
> > > > 
> > > > And delayed by
> > > > 
> > > > scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> > > 
> > > Easily fixed.  And it looks like neither of these needs a call to
> > > scsi_next_command(), right?
> > 
> > Right, which is a nice side effect.
> 
> scsi_finish_command is only called from scsi_eh_flush_done_q (newer
> patches moves this to scsi_attempt_requeue_command) and scsi_softirq_done.
> scsi_io_completion is only called from scsi_finish_command. In
> scsi_softirq_done we just called scsi_decide_disposition to map the
> result. Could some (or all) of the sense mapping be moved to
> scsi_decide_disposition? It seems incorrect to decode this same data in
> more than one location plus in some cases could prevent device handlers
> from the full control they need. Is there some path or behavior that I am
> missing?

Well, it already is done in scsi_decide_disposition() with a call to
scsi_check_sense().

However, there's a slight problem in that some senses need to be
interpreted differently depending on what the ULD is which leads to the
current 3 tier system (before in decide disposition, during in ULD done
and after in scsi_io_completion).

The discriminators in the done functions do look to be duplicates, so I
suppose they could be collapsed.

> Also since previous mid retry changes are related to retry behavior borrowing
> this thread for a related request....
> 
> James, It would be good if you have time to look at the repost of mid
> retry changes and if they are ok would you consider applying them plus
> these changes.

They're on my list ... it's just there's rather a lot of them and I was
hoping someone else would get there first ...

>   It would be good to also have a refresh of
> scsi-post-merge-2.6 tree with Jens tree. I am running testing now, but my
> tree needed a lot of merging assistance and it would be good to know what
> others are testing is the same.
> http://thread.gmane.org/gmane.linux.scsi/44715

Um, it shouldn't need any merging assistance ... it rebases into
linux-next just fine.  Are you sure you're doing the right thing.

To get this tree, you need to set it up as a remote

git remote add -f scsi-postmerge git://git.kernel.org//pub/scm/linux/kernel/git/jejb/scsi-post-merge-2.6.git

in a tree you want to use it in (must contain at least scsi-misc and
Jens block#for-2.6.28) and rebase the postmerge tree into your current

git rebase --onto master scsi-postmerge/merge-base scsi-postmerge/master

This will create a temporary branch for you to play with (git branch
will show 

* (no branch)
  master

).  If you play around with it and find it to be OK, you can create a
new branch for it

git branch <new branch name>
git checkout <new branch name>

And the temporary branch will become permanent (you can even force your
temporary to become master with git branch -f master)

> Since this change plus Mike C's and mine effect retry / completion
> behavior it would be good to test these changes all together.

James


