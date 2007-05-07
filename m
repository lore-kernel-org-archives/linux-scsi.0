From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 0/2] bidi support
Date: Mon, 07 May 2007 16:02:42 +0900
Message-ID: <20070507160242P.fujita.tomonori@lab.ntt.co.jp>
References: <200705050902.l4592YeE009469@mbox.iij4u.or.jp>
	<200705050924.l459Oo2M020018@mbox.iij4u.or.jp>
	<463EC1B1.1060408@panasas.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55725 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbXEGHLC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 May 2007 03:11:02 -0400
In-Reply-To: <463EC1B1.1060408@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bhalevy@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 0/2] bidi support
Date: Mon, 07 May 2007 09:05:37 +0300

> Tomo,
> 
> Thanks for quickly crafting this patchset.
> Please see my comments in-line below.
> 
> Putting aside the controversial design issues,
> we need to carefully compare our patches against yours
> to make sure no functional issues have been overlooked.

(snip)

> > @@ -685,6 +693,14 @@ static struct scsi_cmnd *scsi_end_reques
> >  		}
> >  	}
> >  
> > +	/*
> > +	 * a REQ_BLOCK_PC command is always completed fully so just do
> > +	 * end the bidi chunk.
> > +	 */
> > +	if (sdb)
> > +		end_that_request_chunk(req->next_rq, uptodate,
> > +				       sdb->request_bufflen);
> 
> I think I agree you shouldn't call end_that_request_last(req->next_rq)
> so sdb and req->next_rq should be freed here, no?

I think that bidi requests are en-queued via blk_execute_rq (or
blk_execute_rq_nowait). The caller frees req and req->next_rq.


> > +static int scsi_data_buffer_init(struct scsi_cmnd *cmd)
> > +{
> > +	struct scatterlist *sgpnt;
> > +	struct scsi_data_buffer *sdb = scsi_bidi_data_buffer(cmd);
> > +	struct request *req = cmd->request;
> > +	int count;
> > +
> > +	sdb->use_sg = req->next_rq->nr_phys_segments;
> > +	sgpnt = do_scsi_alloc_sgtable(sdb->use_sg, &sdb->sglist_len,
> > +				      GFP_ATOMIC);
> > +	if (unlikely(!sgpnt)) {
> > +		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
> > +		scsi_unprep_request(req);
> > +		return BLKPREP_DEFER;
> > +	}
> > +
> > +	req->buffer = NULL;
> 
> req->next_rq->buffer = NULL;
> 
> no?

Yes, but maybe we can remove this.


> > +	sdb->request_buffer = (char *) sgpnt;
> > +	sdb->request_bufflen = req->next_rq->data_len;
> > +
> > +	count = blk_rq_map_sg(req->q, req->next_rq, sgpnt);
> > +	if (likely(count <= sdb->use_sg)) {
> > +		sdb->use_sg = count;
> > +		return BLKPREP_OK;
> > +	}
> > +
> > +	scsi_release_buffers(cmd);
> 
> either kfree(sbd) and blk_put_request(req->next_rq) here, or
> should that be done in scsi_put_command?
> who does that on the error-free path? (see comment above in scsi_end_request)

Yeah, I think that scsi_release_buffers() should free sbd.


> > +	scsi_put_command(cmd);
> > +
> > +	return BLKPREP_KILL;
> > +}
> > +
> >  static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
> >  {
> >  	BUG_ON(!blk_pc_request(cmd->request));
> > @@ -1090,10 +1154,21 @@ static void scsi_blk_pc_done(struct scsi
> >  static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
> >  {
> >  	struct scsi_cmnd *cmd;
> > +	struct scsi_data_buffer *sdb = NULL;
> > +
> > +	if (blk_bidi_rq(req)) {
> > +		sdb = kzalloc(sizeof(*sdb), GFP_ATOMIC);
> > +		if (unlikely(!sdb))
> > +			return BLKPREP_DEFER;
> > +		req->next_rq->special = sdb;
> > +	}
> >  
> >  	cmd = scsi_get_cmd_from_req(sdev, req);
> > -	if (unlikely(!cmd))
> > +	if (unlikely(!cmd)) {
> > +		req->next_rq->special = NULL;
> 
> req->next_rq can be NULL

Opps, thanks.


Thanks, I'll fix them and update the git tree shortly.
