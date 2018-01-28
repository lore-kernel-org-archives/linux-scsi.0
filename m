From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3] blk-mq: introduce BLK_STS_DEV_RESOURCE
Date: Sat, 27 Jan 2018 23:58:05 -0500
Message-ID: <20180128045805.GA27261@redhat.com>
References: <1516724659.3339.7.camel@sandisk.com>
 <20180123163717.GE13277@ming.t460p>
 <1516726653.3339.20.camel@wdc.com>
 <20180124033109.GA15945@ming.t460p>
 <20180127190920.GA24759@redhat.com>
 <1517091161.3055.7.camel@wdc.com>
 <20180128002356.GA25933@redhat.com>
 <1517100877.3055.23.camel@wdc.com>
 <20180128020312.GA26437@redhat.com>
 <1517108417.3055.33.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517108417.3055.33.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 27 2018 at 10:00pm -0500,
Bart Van Assche <Bart.VanAssche@wdc.com> wrote:

> On Sat, 2018-01-27 at 21:03 -0500, Mike Snitzer wrote:
> > You cannot even be forthcoming about the technical merit of a change you
> > authored (commit 6077c2d70) that I'm left to clean up in the face of
> > performance bottlenecks it unwittingly introduced?  If you were being
> > honest: you'd grant that the random delay of 100ms is utterly baseless
> > (not to mention that kicking the queue like you did is a complete
> > hack).  So that 100ms delay is what my dm-4.16 commit is talking about.
> 
> There are multiple errors in the above:
> 1. I have already explained in detail why commit 6077c2d70 is (a) correct
>    and (b) essential. See e.g. https://www.redhat.com/archives/dm-devel/2018-January/msg00168.html.

And you'd be wrong.  Again.  We've already established that commit
6077c2d70 is _not_ essential.  Ming's V3, in conjunction with all the
changes that already went into block and DM for 4.16, prove that.

Yet here you go repeating yourself.  You are clinging to a patch that
absolutely had no business going in when it did.  And even when
presented with the reality that it was not the proper way to fix the
issue you observed you keep going back to it like you cured cancer with
a single line of code.

> 2. With patch "blk-mq: Avoid that blk_mq_delay_run_hw_queue() introduces
>    unintended delays" applied, there is nothing to clean up anymore since
>    that patch eliminates the queue delays that were triggered by
>    blk_mq_delay_run_hw_queue().

The issue Ming fixed is that your random queue kicks break RESTART on
dm-mq mpath.

> 3. You know that I'm honest. Suggesting that I'm not is wrong.

No, I trully do _not_ know you're always honest.  You've conflated so
many details on this topic that it makes me have serious doubts.  You're
lashing out so much, in defense of your dm_mq_queue_rq delayed queue
kick, that you're missing there is a genuine generic blk-mq problem that
is getting fixed in Ming's V3.

> 4. I never claimed that 100ms is the optimal value for the queue
>    rerunning delay. I have already explained to you that I copied that
>    value from older dm-rq code.

And I pointed out to you that you most certainly did _not_ copy the
value from elsewhere:
https://www.redhat.com/archives/dm-devel/2018-January/msg00202.html

The specific delay used isn't the issue; the need to kick the queue like
this is.  Ming's V3 avoids unnecessary kicking.

> > Don't project onto me Bart.  This isn't the first time you've been
> > completely unprofessional and sadly it likely won't be the last.
> 
> The only person who is behaving unprofessionally in this e-mail thread
> is you.

Bart, the number of emails exchanged on this topic has exhausted
_everyone_.  Emotions get tense when things don't evolve despite every
oppotunity for progress to be realized.  When people cling to solutions
that are no longer relevant.  There is a very real need for progress
here.  So either get out of the way or suggest a specific series of
change(s) that you feel better than Ming's V3.

With that, I'll also stop responding to your baiting now and forevermore
(e.g. "maintainers should this.. and maintainers should not that" or
"your employer is not investing adequately".  Next time you find
yourself typing drivel like that: spare us all and hit delete).
