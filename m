From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH 12/30] blk_end_request: changing ub (take 4)
Date: Wed, 12 Dec 2007 15:38:15 -0500 (EST)
Message-ID: <20071212.153815.39152138.k-ueda@ct.jp.nec.com>
References: <20071211.174647.75757994.k-ueda@ct.jp.nec.com>
	<20071211154803.58beb681.zaitcev@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20071211154803.58beb681.zaitcev@redhat.com>
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

On Tue, 11 Dec 2007 15:48:03 -0800, Pete Zaitcev <zaitcev@redhat.com> wrote:
> >  	if (scsi_status == 0) {
> > -		uptodate = 1;
> > +		error = 0;
> >  	} else {
> > -		uptodate = 0;
> > +		error = -EIO;
> >  		rq->errors = scsi_status;
> >  	}
> > -	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
> > -	end_that_request_last(rq, uptodate);
> > +	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
> > +		BUG();
> 
> Acked-by: Pete Zaitcev <zaitcev@redhat.com>
> 
> I follow the discussion, actually, and wanted to ask someone to look
> closer if it's appropriate to use __blk_end_request() here.
> My understanding was, blk_end_request() is the same thing, only
> takes the queue lock. But then, should I refactor ub so that it
> calls __blk_end_request if request function ends with an error
> and blk_end_request if the end-of-IO even is processed? If not,
> and the above is sufficient, why have blk_end_request at all?

The difference between blk_end_request() and __blk_end_request() is
whether the queue lock is held or not when end_that_request_last()
is called.
It's not relevant to the status of the request (error or not).

I'm using __blk_end_request() here and I think it's sufficient, because:
  o end_that_request_last() must be called with the queue lock held
  o ub_end_rq() calls end_that_request_last() without taking
    the queue lock in itself.
    So the queue lock must have been taken outside ub_end_rq().

But, if ub is calling end_that_request_last() without the queue lock,
it is a bug in the original code and we should use blk_end_request()
to fix that.

Does that answer satisfy you?

Thanks,
Kiyoshi Ueda
