From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sun, 28 Jan 2018 12:26:38 -0500
Message-ID: <1517160398.12003.1.camel@redhat.com>
References: <1516724659.3339.7.camel@sandisk.com>
         <20180123163717.GE13277@ming.t460p> <1516726653.3339.20.camel@wdc.com>
         <20180124033109.GA15945@ming.t460p> <20180127190920.GA24759@redhat.com>
         <1517091161.3055.7.camel@wdc.com> <20180128002356.GA25933@redhat.com>
         <1517100877.3055.23.camel@wdc.com> <20180128020312.GA26437@redhat.com>
         <1517108417.3055.33.camel@wdc.com> <20180128045805.GA27261@redhat.com>
         <1517158641.3141.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:45786 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752068AbeA1R0k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jan 2018 12:26:40 -0500
Received: by mail-qt0-f170.google.com with SMTP id x27so9961912qtm.12
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jan 2018 09:26:40 -0800 (PST)
In-Reply-To: <1517158641.3141.12.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Sun, 2018-01-28 at 16:57 +0000, Bart Van Assche wrote:
> On Sat, 2018-01-27 at 23:58 -0500, Mike Snitzer wrote:
> > On Sat, Jan 27 2018 at 10:00pm -0500,
> > Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> > 
> > > On Sat, 2018-01-27 at 21:03 -0500, Mike Snitzer wrote:
> > > > You cannot even be forthcoming about the technical merit of a
> > > > change you
> > > > authored (commit 6077c2d70) that I'm left to clean up in the
> > > > face of
> > > > performance bottlenecks it unwittingly introduced?  If you were
> > > > being
> > > > honest: you'd grant that the random delay of 100ms is utterly
> > > > baseless
> > > > (not to mention that kicking the queue like you did is a
> > > > complete
> > > > hack).  So that 100ms delay is what my dm-4.16 commit is
> > > > talking about.
> > > 
> > > There are multiple errors in the above:
> > > 1. I have already explained in detail why commit 6077c2d70 is (a)
> > > correct
> > >    and (b) essential. See e.g. https://www.redhat.com/archives/dm
> > > -devel/2018-January/msg00168.html.
> > 
> > And you'd be wrong.  Again.  We've already established that commit
> > 6077c2d70 is _not_ essential.  Ming's V3, in conjunction with all
> > the
> > changes that already went into block and DM for 4.16, prove that.
> 
> What I wrote was right when commit 6077c2d70 got introduced. My
> explanation
> shows that at that time  was both correct and essential. Ming's v3 is
> in my
> opinion not relevant yet to this discussion because it introduces new
> bugs
> and so far no attempt has been made to address these bugs.
> 
> > > 2. With patch "blk-mq: Avoid that blk_mq_delay_run_hw_queue()
> > > introduces
> > >    unintended delays" applied, there is nothing to clean up
> > > anymore since
> > >    that patch eliminates the queue delays that were triggered by
> > >    blk_mq_delay_run_hw_queue().
> > 
> > The issue Ming fixed is that your random queue kicks break RESTART
> > on
> > dm-mq mpath.
> 
> That comment is too short to be comprehensible for anyone. Can you
> elaborate
> this further?
> 
> > > 3. You know that I'm honest. Suggesting that I'm not is wrong.
> > 
> > No, I trully do _not_ know you're always honest.  You've conflated
> > so
> > many details on this topic that it makes me have serious
> > doubts.  You're
> > lashing out so much, in defense of your dm_mq_queue_rq delayed
> > queue
> > kick, that you're missing there is a genuine generic blk-mq problem
> > that
> > is getting fixed in Ming's V3.
> > 
> > [ ... ]
> > 
> > Bart, the number of emails exchanged on this topic has exhausted
> > _everyone_.  Emotions get tense when things don't evolve despite
> > every
> > oppotunity for progress to be realized.  When people cling to
> > solutions
> > that are no longer relevant.  There is a very real need for
> > progress
> > here.  So either get out of the way or suggest a specific series of
> > change(s) that you feel better than Ming's V3.
> 
> If you and Ming really care about the approach in the patch at the
> start
> of this e-mail thread, what are you waiting for to address the
> technical
> shortcomings that I pointed out?
> 
> > With that, I'll also stop responding to your baiting now and
> > forevermore
> > (e.g. "maintainers should this.. and maintainers should not that"
> > or
> > "your employer is not investing adequately".  Next time you find
> > yourself typing drivel like that: spare us all and hit delete).
> 
> My opinion about what you wrote in this and the other e-mails you
> sent to
> me during the past months is as follows:
> 1. That I have always done my best to provide all the relevant
> technical
>    information.
> 2. That my focus was on the technical aspects of the discussion.
> 3. That you did not try to reach a consensus but rather to dominate
> the
>    discussion.
> 4. That the tone of your e-mails was very aggressive.
> 5. That you insulted me several times personally.
> 
> I believe that your behavior is a violation of the kernel code of
> conflict
> and sufficient to file a complaint with the TAB. From
> Documentation/process/code-of-conflict.rst:
> 
> "If however, anyone feels personally abused, threatened, or otherwise
> uncomfortable due to this process, that is not acceptable.  If so,
> please contact the Linux Foundation's Technical Advisory Board [ ...
> ]"
> 
> Additionally, since you are a U.S. Citizen, you should know that what
> you
> wrote in previous e-mails amounts to libel. A quote from a definition
> of
> libel: "to publish in print (including pictures), writing or
> broadcast
> through radio, television or film, an untruth about another which
> will do
> harm to that person or his/her reputation, by tending to bring the
> target
> into ridicule, hatred, scorn or contempt of others." You should be
> aware
> since I live in the U.S. that this makes it possible for me to sue
> you for
> defamation and to ask for a compensation.
> 
> Bart.

Folks

I think we need to all take some time, take a breath and lets see how
we can figure this out amicably.

Everybody on this list contributes a huge amount of professional and
personal time to improving the kernel. I for one have benefited a huge
amount from assistance given to me in the past by  Bart, Ming and Mike
(and others) and I am not about to take sides here.

While we cannot always be expected to agree we need to find a way to
get over these types of disagreements.

While Ming, Bart and Mike all have strong opinions this has to move
forward so what is the best way for tie breaker here. Do the folks that
know this code really well take a vote, majority wins for now and we
have progress.
Should this turn out to be an issue in the future then it gets
addressed by reverts/changes.

The changes have been tested but there is clearly some exposure or Bart
would not be concerned the way he is about this. The amount of exposure
should govern if this gets accepted or not.

Being a very very low member on the this very talented list I for one
can only contribute as far as testing is concerned and generic testing
of this has been very well behaved so perhaps while we have exposure
its acceptable risk.

I hope I am not speaking out of turn.

Sincerely
Laurence
