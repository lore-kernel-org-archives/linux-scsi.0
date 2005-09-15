From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC/RFT 2/4] add scsi helpers
Date: Thu, 15 Sep 2005 11:13:03 +0100
Message-ID: <20050915101303.GB24689@infradead.org>
References: <1126736388.16778.25.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:21680 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932465AbVIOKNE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 06:13:04 -0400
Content-Disposition: inline
In-Reply-To: <1126736388.16778.25.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

> +struct __scsi_request {
> +	void *data;
> +	void (*done)(void *data, char *sense, int result, int resid);
> +	char sense[SCSI_SENSE_BUFFERSIZE];
> +};

I don't think this is a good structure name.  Just something like
iocontext  or similar?

> +int scsi_execute_async_iov_req(struct scsi_device *sdev,
> +			       const unsigned char *cmd, int data_direction,
> +			       struct kvec *vec, int vec_count, int timeout,
> +			       int retries, void *privdata,
> +			       void (*done)(void *, char *, int, int))

If you passed an request_queue_t instead of th scsi_device this function
would not have any knowledge about scsi internals and could be moved up
to the block layer.  not sure that's actually a good idea.

If we stick to putting it into the scsi layer the done callback could
normalize the sense data, though.

> +	struct request *req;
> +	struct __scsi_request *sreq;
> +	int write = (data_direction == DMA_TO_DEVICE);

What about just passing in a write parameter directly?

> +
> +	sreq = kzalloc(sizeof(*sreq), GFP_ATOMIC);
> +	if (!sreq) {
> +		return DRIVER_ERROR << 24;
> +	}
> +
> +	req = blk_get_request(sdev->request_queue, write, GFP_ATOMIC);

can you add a gfp_mask argument instead of hardcoding GFP_ATOMIC?

