From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH 12/30] blk_end_request: changing ub (take 4)
Date: Tue, 11 Dec 2007 15:48:03 -0800
Message-ID: <20071211154803.58beb681.zaitcev@redhat.com>
References: <20071211.174647.75757994.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20071211.174647.75757994.k-ueda@ct.jp.nec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, zaitcev@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 11 Dec 2007 17:46:47 -0500 (EST), Kiyoshi Ueda <k-ueda@ct.jp.nec.com> wrote:

>  	if (scsi_status == 0) {
> -		uptodate = 1;
> +		error = 0;
>  	} else {
> -		uptodate = 0;
> +		error = -EIO;
>  		rq->errors = scsi_status;
>  	}
> -	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
> -	end_that_request_last(rq, uptodate);
> +	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
> +		BUG();

Acked-by: Pete Zaitcev <zaitcev@redhat.com>

I follow the discussion, actually, and wanted to ask someone to look
closer if it's appropriate to use __blk_end_request() here.
My understanding was, blk_end_request() is the same thing, only
takes the queue lock. But then, should I refactor ub so that it
calls __blk_end_request if request function ends with an error
and blk_end_request if the end-of-IO even is processed? If not,
and the above is sufficient, why have blk_end_request at all?

-- Pete
