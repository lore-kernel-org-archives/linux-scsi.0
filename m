From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 17 Apr 2018 13:46:04 -0700
Message-ID: <CAGXu5jL9miO3OXpjAxm9t8v=f_f5StB=Tk=aV8BVRdEj-Y-PDA@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
 <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
 <2864697.7uzmEJovl2@natalenko.name> <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
 <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
 <CAGXu5jLhnWnUiscP9B=kTEFNyRw9jgFn7Zr5FxhZrO20553+1Q@mail.gmail.com>
 <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com>
 <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
 <CAGXu5jJTMqbXia7TmN2yEW11SM+XC3pkMt=bb+xBrY7-OOf=tw@mail.gmail.com>
 <CAGXu5j+xX3kDDS_sPY44hPVb=8isMX-evYzPx3ur=rge1rL5JQ@mail.gmail.com>
 <CAGXu5jJmvKcANUSsCz3fjGSv-tv1hceNd3rOpT4WTfYRb65RRA@mail.gmail.com> <8473f909-2123-0cfc-43b1-beba0b1aef9b@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8473f909-2123-0cfc-43b1-beba0b1aef9b@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Paolo Valente <paolo.valente@linaro.org>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Bart Van Assche <bart.vanassche@wdc.com>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 17, 2018 at 1:28 PM, Jens Axboe <axboe@kernel.dk> wrote:
> It has to be the latter bfqq->dispatched increment, as those are
> transient (and bfqd is not).

Yeah, and I see a lot of comments around the lifetime of rq and bfqq,
so I assume something is not being locked correctly.

#define RQ_BFQQ(rq)             ((rq)->elv.priv[1])

static struct request *__bfq_dispatch_request(struct blk_mq_hw_ctx *hctx)
{
        struct bfq_data *bfqd = hctx->queue->elevator->elevator_data;
        struct request *rq = NULL;
        struct bfq_queue *bfqq = NULL;

        if (!list_empty(&bfqd->dispatch)) {
                rq = list_first_entry(&bfqd->dispatch, struct request,
                                      queuelist);
                list_del_init(&rq->queuelist);

                bfqq = RQ_BFQQ(rq);

                if (bfqq) {
                        /*
                         * Increment counters here, because this
                         * dispatch does not follow the standard
                         * dispatch flow (where counters are
                         * incremented)
                         */
                        bfqq->dispatched++;
...

I see elv.priv[1] assignments made in a few places -- is it possible
there is some kind of uninitialized-but-not-NULL state that can leak
in there?

bfq_prepare_request() assigns elv.priv[1], and bfq_insert_request()
only checks that it's non-NULL (if at all) in one case. Can
bfq_insert_request() get called without bfq_prepare_request() being
called first?

-Kees

-- 
Kees Cook
Pixel Security
