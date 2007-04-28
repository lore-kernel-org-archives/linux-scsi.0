From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 4/4] bidi support: bidirectional request
Date: Sun, 29 Apr 2007 04:48:03 +0900
Message-ID: <200704281948.l3SJm9jS001428@mbox.iij4u.or.jp>
References: <46225E18.7070404@panasas.com>
	<462261E8.5090005@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <462261E8.5090005@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: bharrosh@panasas.com
Cc: jens.axboe@oracle.com, James.Bottomley@SteelEye.com, akpm@osdl.org, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, bhalevy@panasas.com, osd-dev@open-osd.org
List-Id: linux-scsi@vger.kernel.org

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/4] bidi support: bidirectional request
Date: Sun, 15 Apr 2007 20:33:28 +0300

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 645d24b..16a02ee 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -322,6 +322,7 @@ struct request {
>      void *end_io_data;
> 
>      struct request_io_part uni;
> +    struct request_io_part bidi_read;
>  };

Would be more straightforward to have:

struct request_io_part in;
struct request_io_part out;


>  /*
> @@ -600,6 +601,34 @@ static inline struct request_io_part* rq_uni(struct request* req)
>      return &req->uni;
>  }
>
> +static inline struct request_io_part* rq_out(struct request* req)
> +{
> +    WARN_ON_BIDI_FLAG(req);
> +    return &req->uni;
> +}
> +
> +static inline struct request_io_part* rq_in(struct request* req)
> +{
> +    WARN_ON_BIDI_FLAG(req);
> +    if (likely(rq_dma_dir(req) != DMA_BIDIRECTIONAL))
> +        return &req->uni;
> +
> +    if (likely(req->cmd_flags & REQ_BIDI))
> +        return &req->bidi_read;
> +
> +    return &req->uni;
> +}
> +
> +static inline struct request_io_part* rq_io(struct request* req,
> +                                            enum dma_data_direction dir)
> +{
> +    if (dir == DMA_FROM_DEVICE)
> +        return rq_in(req);
> +
> +    WARN_ON( (dir != DMA_TO_DEVICE) && (dir != DMA_NONE) );
> +    return &req->uni;
> +}

static inline struct request_io_part* rq_io(struct request* req)
{
	return (req is WRITE) ? &req->out : &req->in;
}
