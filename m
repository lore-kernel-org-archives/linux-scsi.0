From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add scsi_cmd_ioctl (SG_IO) support for st
Date: Sun, 1 Feb 2004 21:35:52 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201213552.B17988@infradead.org>
References: <20040201124803.A18050@beaverton.ibm.com> <20040201125031.A18128@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:45324 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265636AbUBAVf6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 16:35:58 -0500
Content-Disposition: inline
In-Reply-To: <20040201125031.A18128@beaverton.ibm.com>; from patmans@us.ibm.com on Sun, Feb 01, 2004 at 12:50:31PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

> +static void st_intr(struct scsi_cmnd *SCpnt)
> +{

What about st_done instead?  I know sd and sr use the intr names, but
they're really misleading.  Also convention for new code is to use
cmd or scmd as variable names for scsi commands.

> +static int st_init_command(struct scsi_cmnd *SCpnt)
> +{
> +	struct request *rq;
> +
> +	if (!(SCpnt->request->flags & REQ_BLOCK_PC))
> +		return 0;
> +
> +	rq = SCpnt->request;
> +	if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
> +		return 0;
> +
> +	memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
> +
> +	if (rq_data_dir(rq) == WRITE)
> +		SCpnt->sc_data_direction = DMA_TO_DEVICE;
> +	else if (rq->data_len)
> +		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
> +	else
> +		SCpnt->sc_data_direction = DMA_NONE;
> +
> +	SCpnt->timeout_per_command = rq->timeout;
> +	SCpnt->transfersize = rq->data_len;
> +	SCpnt->done = st_intr;
> +	return 1;

This one looks obviously good, but yeah, this would much better fit into
the scsi midlayer.  Not for this patch session, though.

