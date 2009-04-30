From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 08/10] block: cleanup rq->data_len usages
Date: Thu, 30 Apr 2009 16:47:48 +0300
Message-ID: <49F9AC04.9060403@panasas.com>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1240996428-10159-9-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 04/29/2009 12:13 PM, Tejun Heo wrote:
> With recent unification of fields, it's now guaranteed that
> rq->data_len always equals blk_rq_bytes().  Convert all non-IDE direct
> users to accessors.  IDE will be converted in a separate patch.
> 
> [ Impact: convert direct rq->data_len usages to blk_rq_bytes() ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Pete Zaitcev <zaitcev@redhat.com>
> Cc: Eric Moore <Eric.Moore@lsi.com>
> Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
> Cc: Darrick J. Wong <djwong@us.ibm.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Eric Moore <Eric.Moore@lsi.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
<snip>
>  drivers/scsi/osd/osd_initiator.c         |    4 ++--
>  fs/exofs/osd.c                           |    4 ++--
<snip>
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 2a5f077..d178a8b 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1299,7 +1299,7 @@ int osd_finalize_request(struct osd_request *or,
>  			return ret;
>  		}
>  		OSD_DEBUG("out bytes=%llu (bytes_req=%u)\n",
> -			_LLU(or->out.total_bytes), or->out.req->data_len);
> +			_LLU(or->out.total_bytes), blk_rq_bytes(or->out.req));
>  	}
>  	if (or->in.bio) {
>  		ret = blk_rq_append_bio(or->request->q, or->in.req, or->in.bio);
> @@ -1308,7 +1308,7 @@ int osd_finalize_request(struct osd_request *or,
>  			return ret;
>  		}
>  		OSD_DEBUG("in bytes=%llu (bytes_req=%u)\n",
> -			_LLU(or->in.total_bytes), or->in.req->data_len);
> +			_LLU(or->in.total_bytes), blk_rq_bytes(or->in.req));
>  	}
>  
>  	or->out.pad_buff = sg_out_pad_buffer;

Sorry about this stupid debug-print. Leftover from the learning days
Ack for this bit.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 39b3acf..3d16c70 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -682,14 +682,13 @@ EXPORT_SYMBOL(scsi_release_buffers);
>  static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
>  {
>  	struct request *req = cmd->request;
> -	unsigned int dlen = req->data_len;
> -	unsigned int next_dlen = req->next_rq->data_len;
>  
>  	req->resid_len = scsi_out(cmd)->resid;
>  	req->next_rq->resid_len = scsi_in(cmd)->resid;
>  
>  	/* The req and req->next_rq have not been completed */
> -	BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));
> +	BUG_ON(blk_end_bidi_request(req, 0, blk_rq_bytes(req),
> +				    blk_rq_bytes(req->next_rq)));
>  

Just blk_end_request_all() actually. If you let blk_end_request_all also do bidi

>  	scsi_release_buffers(cmd);
>  

and then it can be in-lined into caller, where blk_pc_request(req) just do blk_end_request_all
regardless (and only the residual setting is conditional)

I'll send a patch to scsi_lib later once this settles a bit.

> @@ -966,7 +965,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
>  	BUG_ON(count > sdb->table.nents);
>  	sdb->table.nents = count;
>  	if (blk_pc_request(req))
> -		sdb->length = req->data_len;
> +		sdb->length = blk_rq_bytes(req);
>  	else
>  		sdb->length = blk_rq_sectors(req) << 9;

Is this true. I thought they must be the same now. I was actually anticipating this if() removed.

>  	return BLKPREP_OK;
> @@ -1087,21 +1086,21 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
>  		if (unlikely(ret))
>  			return ret;
>  	} else {
> -		BUG_ON(req->data_len);
> +		BUG_ON(blk_rq_bytes(req));
>  
>  		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
>  		req->buffer = NULL;
>  	}
>  
>  	cmd->cmd_len = req->cmd_len;
> -	if (!req->data_len)
> +	if (!blk_rq_bytes(req))
>  		cmd->sc_data_direction = DMA_NONE;
>  	else if (rq_data_dir(req) == WRITE)
>  		cmd->sc_data_direction = DMA_TO_DEVICE;
>  	else
>  		cmd->sc_data_direction = DMA_FROM_DEVICE;
>  	
> -	cmd->transfersize = req->data_len;
> +	cmd->transfersize = blk_rq_bytes(req);
>  	cmd->allowed = req->retries;
>  	return BLKPREP_OK;
>  }
> diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
> index 48ba413..1030327 100644
> --- a/drivers/scsi/scsi_tgt_lib.c
> +++ b/drivers/scsi/scsi_tgt_lib.c
> @@ -387,7 +387,7 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
>  	 * we use REQ_TYPE_BLOCK_PC so scsi_init_io doesn't set the
>  	 * length for us.
>  	 */
> -	cmd->sdb.length = rq->data_len;
> +	cmd->sdb.length = blk_rq_bytes(rq);
>  
>  	return 0;
>  
> diff --git a/fs/exofs/osd.c b/fs/exofs/osd.c
> index b249ae9..c97420b 100644
> --- a/fs/exofs/osd.c
> +++ b/fs/exofs/osd.c
> @@ -50,10 +50,10 @@ int exofs_check_ok_resid(struct osd_request *or, u64 *in_resid, u64 *out_resid)
>  
>  	/* FIXME: should be include in osd_sense_info */
>  	if (in_resid)
> -		*in_resid = or->in.req ? or->in.req->data_len : 0;
> +		*in_resid = or->in.req ? blk_rq_bytes(or->in.req) : 0;

+		*in_resid = or->in.req ? or->in.req->resid_len : 0;

>  
>  	if (out_resid)
> -		*out_resid = or->out.req ? or->out.req->data_len : 0;
> +		*out_resid = or->out.req ? blk_rq_bytes(or->out.req) : 0;

+		*out_resid = or->out.req ? or->out.req->resid_len : 0;

>  
>  	return ret;
>  }

OK This segment is wrong. It should be moved to the residual count patch
(PATCH 3/10) the assignment into *in_resid/*out_resid should shourly triggered
a warning ;-)

Thanks
Boaz
