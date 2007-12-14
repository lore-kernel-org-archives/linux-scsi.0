From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 12/30] blk_end_request: changing ub (take 4)
Date: Fri, 14 Dec 2007 12:04:54 -0500 (EST)
Message-ID: <20071214.120454.39153297.k-ueda@ct.jp.nec.com>
References: <20071211154803.58beb681.zaitcev@redhat.com>
	<20071212.153815.39152138.k-ueda@ct.jp.nec.com>
	<20071213135916.27ebe3f9.zaitcev@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071213135916.27ebe3f9.zaitcev@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: zaitcev@redhat.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Hi Pete,

On Thu, 13 Dec 2007 13:59:16 -0800, Pete Zaitcev <zaitcev@redhat.com> wrote:
> > > > -	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
> > > > -	end_that_request_last(rq, uptodate);
> > > > +	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
> > > > +		BUG();
> > >
> > > My understanding was, blk_end_request() is the same thing, only
> > > takes the queue lock. But then, should I refactor ub so that it
> > > calls __blk_end_request if request function ends with an error
> > > and blk_end_request if the end-of-IO even is processed?
> >
> > I'm using __blk_end_request() here and I think it's sufficient, because:
> >   o end_that_request_last() must be called with the queue lock held
> >   o ub_end_rq() calls end_that_request_last() without taking
> >     the queue lock in itself.
> >     So the queue lock must have been taken outside ub_end_rq().
> >
> > But, if ub is calling end_that_request_last() without the queue lock,
> > it is a bug in the original code and we should use blk_end_request()
> > to fix that.
> 
> So, I have to rewrite ub to split the paths after all, right?
> Let's do this then: I'll wait until your patch gets to Linus and
> then update it with the split. The reason is, I need the whole
> enchilada applied and I don't want to bother tracking iterations
> and all the little segments (of which you already have 30).
> Until then, ub will have a race by using your original small patch.

No.
Are you doubting that the current ub code has the problem, aren't you?
My patch shouldn't introduce a NEW problem to ub.

I have investigated all code paths which call ub_end_rq() in ub.c,
and confirmed that ub_end_rq() is always called with the queue lock
held.  (sc->lock is registered as a queue lock.)

So there is no such race in the current ub code.
You don't need to rewrite ub.

Thanks,
Kiyoshi Ueda
