From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] add scsi_cmd_ioctl (SG_IO) support for st
Date: Sun, 1 Feb 2004 13:51:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201135143.B18509@beaverton.ibm.com>
References: <20040201124803.A18050@beaverton.ibm.com> <20040201125031.A18128@beaverton.ibm.com> <20040201213552.B17988@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:34261 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265501AbUBAVwj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Feb 2004 16:52:39 -0500
Content-Disposition: inline
In-Reply-To: <20040201213552.B17988@infradead.org>; from hch@infradead.org on Sun, Feb 01, 2004 at 09:35:52PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

On Sun, Feb 01, 2004 at 09:35:52PM +0000, Christoph Hellwig wrote:
> > +static void st_intr(struct scsi_cmnd *SCpnt)
> > +{
> 
> What about st_done instead?  I know sd and sr use the intr names, but
> they're really misleading.  Also convention for new code is to use
> cmd or scmd as variable names for scsi commands.

st_done is fine, I was matching current st.c coding style for SCpnt
naming, but will change it.

> > +static int st_init_command(struct scsi_cmnd *SCpnt)
> > +{
> > +	struct request *rq;
> > +
> > +	if (!(SCpnt->request->flags & REQ_BLOCK_PC))
> > +		return 0;
> > +
> > +	rq = SCpnt->request;
> > +	if (sizeof(rq->cmd) > sizeof(SCpnt->cmnd))
> > +		return 0;
> > +
> > +	memcpy(SCpnt->cmnd, rq->cmd, sizeof(SCpnt->cmnd));
> > +
> > +	if (rq_data_dir(rq) == WRITE)
> > +		SCpnt->sc_data_direction = DMA_TO_DEVICE;
> > +	else if (rq->data_len)
> > +		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
> > +	else
> > +		SCpnt->sc_data_direction = DMA_NONE;
> > +
> > +	SCpnt->timeout_per_command = rq->timeout;
> > +	SCpnt->transfersize = rq->data_len;
> > +	SCpnt->done = st_intr;
> > +	return 1;
> 
> This one looks obviously good, but yeah, this would much better fit into
> the scsi midlayer.  Not for this patch session, though.
