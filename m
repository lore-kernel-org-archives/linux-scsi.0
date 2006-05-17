From: Jens Axboe <axboe@suse.de>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Wed, 17 May 2006 09:37:02 +0200
Message-ID: <20060517073701.GE4197@suse.de>
References: <4468B596.9090508@garzik.org> <1147789098.3505.19.camel@mulgrave.il.steeleye.com> <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com> <4469F9FB.7020807@garzik.org> <1147797507.3505.52.camel@mulgrave.il.steeleye.com> <446A048B.6040703@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <446A048B.6040703@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 16 2006, Jeff Garzik wrote:
> James Bottomley wrote:
> >On Tue, 2006-05-16 at 12:12 -0400, Jeff Garzik wrote:
> >>Its an API-which-only-libata-uses that we're discussing.  And because 
> >>its moving to the block layer, its also a 
> >>temporary-API-which-only-libata-uses.
> >
> >OK ... this may be the root of the problem.  I really would like libata
> >to migrate to being block only ... especially as PATA looks to be trying
> >to follow you into the SCSI subsystem.  However, this has been the
> >statement for the past two years (at least), and really, few
> >enhancements have been made to block that you need to make good on this.
> >I think one of the things we'll try to find time to do at the storage
> >summit is to take a hard look at block to see exactly what has to be
> >added to make libata solely dependent upon it.
> 
> 100% agreed...

Ditto! I'd be more than willing to implement some of these features (and
already started to, the per command timeout for instance), but I was
starting to write off libata moving to block as a silly pipe dream in
all honesty... But if momentum is picking up behind this move, then I'll
all for it.

> The general list, off the top of my head:
> 
> * objects: storage message, storage device, storage host, and the 
> requisite interconnections

Storage message -> request. The rq-cmd-type branch of the block repo has
most/some of that done. For an explicit storage device + host, I have no
plans to expland on what we have.

> * queuecommand-style API

That's a style issue, rather than a required item. You can roll that on
top of the current api by just doing a:

int queuecommand_helper(request_queue_t *q, struct request *rq)
{
        /* issue request */
        ...
        return OK/DEFER/REJECT/WHATEVER
}

blk_queuecommand_helper(request_queue_t *q, queue_command_fn *fn)
{
        struct request *rq;
        int ret;

        do {
                rq = elv_next_request(q);
                if (!rq)
                        break;

                ret = fn(q, rq);
                if (ret == OK)
                        continue;

                /* handle replugging/killing/whatever */
        } while (1);
}

if you really wanted.

> * EH thread(s)
> * timers, for command timeouts

Agree, we can abstract out the grunt handling of timeouts and the
context required in the block layer.

> * SCSI-style MLqueue and state stuff, i.e. ability to return "device 
> busy", "host busy", "retry this command", ...

Comes with the blk_queuecommand_helper() type setup from above.

> And once libata is happy at the block layer, move SCSI to using this 
> stuff too :)

Definitely.

-- 
Jens Axboe

