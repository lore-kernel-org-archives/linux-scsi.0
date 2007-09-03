From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/7] blk_end_request: add blk_rq_size() macros
Date: Mon, 3 Sep 2007 09:45:47 +0200
Message-ID: <20070903074547.GI4253@kernel.dk>
References: <20070831.184146.18307878.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070831.184146.18307878.k-ueda@ct.jp.nec.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, mike.miller@hp.com, grant.likely@secretlab.ca, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 31 2007, Kiyoshi Ueda wrote:
> This patch adds macros to get the size of request in bytes.
> They are useful because blk_end_request() takes bytes
> as a completed I/O size instead of sectors.
> 
> Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> ---
>  blkdev.h |    9 +++++++++
>  1 files changed, 9 insertions(+)
> 
> diff -rupN 01-blkendreq-interface/include/linux/blkdev.h 02-sect2byte-macro/include/linux/blkdev.h
> --- 01-blkendreq-interface/include/linux/blkdev.h	2007-08-23 17:22:50.000000000 -0400
> +++ 02-sect2byte-macro/include/linux/blkdev.h	2007-08-23 17:25:59.000000000 -0400
> @@ -737,6 +737,15 @@ extern void end_request(struct request *
>  extern void blk_complete_request(struct request *);
>  
>  /*
> + * blk_end_request() takes bytes instead of sectors as a complete size.
> + * blk_rq_size() returns the entire size left to complete in the request.
> + * blk_rq_cur_size() returns the size left to complete in the current segment.
> + */
> +#define sect2byte(nr_sectors) ((nr_sectors) << 9)
> +#define blk_rq_size(rq) (sect2byte((rq)->hard_nr_sectors))
> +#define blk_rq_cur_size(rq) (sect2byte((rq)->current_nr_sectors))
> +
> +/*
>   * end_that_request_first/chunk() takes an uptodate argument. we account
>   * any value <= as an io error. 0 means -EIO for compatability reasons,
>   * any other < 0 value is the direct error type. An uptodate value of

Don't use a sect2byte() macro, kill that. And it doesn't look quite
right, for blk_pc_requests() you don't want to look at *nr_sectors.
Something ala:

static unsigned int blk_rq_size(struct request *rq)
{
        if (blk_fs_request(rq))
                return rq->nr_sectors << 9;

        return rq->data_len;
}

static unsigned int blk_rq_cur_size(struct request *rq)
{
        if (blk_fs_request(rq))
                return rq->current_nr_sectors << 9;

        if (rq->bio)
                return rq->bio->bi_size;

        return rq->data_len;
}

-- 
Jens Axboe

