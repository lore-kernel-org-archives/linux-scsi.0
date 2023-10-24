Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B062C00A8F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 06:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbjJXGye (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 02:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjJXGyd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 02:54:33 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC5D92
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 23:54:30 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6B1E76732D; Tue, 24 Oct 2023 08:54:27 +0200 (CEST)
Date:   Tue, 24 Oct 2023 08:54:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
        djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com
Subject: Re: [PATCH 13/16] fnic: allocate device reset command on the fly
Message-ID: <20231024065427.GD9847@lst.de>
References: <20231023091507.120828-1-hare@suse.de> <20231023091507.120828-14-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023091507.120828-14-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adding the fnic maintainers as they are probably most qualified to
review and test this.

On Mon, Oct 23, 2023 at 11:15:04AM +0200, Hannes Reinecke wrote:
> Allocate a reset command on the fly instead of relying
> on using the command which triggered the device failure.
> This might fail if all available tags are busy, but in
> that case it'll be safer to fall back to host reset anyway.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/fnic/fnic.h      |   1 -
>  drivers/scsi/fnic/fnic_scsi.c | 113 ++++++++++++++++------------------
>  drivers/scsi/snic/snic_scsi.c |   5 +-
>  3 files changed, 55 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 93c68931a593..8ffcafb4687f 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -236,7 +236,6 @@ struct fnic {
>  	unsigned int wq_count;
>  	unsigned int cq_count;
>  
> -	struct mutex sgreset_mutex;
>  	struct dentry *fnic_stats_debugfs_host;
>  	struct dentry *fnic_stats_debugfs_file;
>  	struct dentry *fnic_reset_debugfs_file;
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 9761b2c9db48..7a8b6285a096 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -1984,7 +1984,6 @@ static inline int fnic_queue_dr_io_req(struct fnic *fnic,
>  
>  struct fnic_pending_aborts_iter_data {
>  	struct fnic *fnic;
> -	struct scsi_cmnd *lr_sc;
>  	struct scsi_device *lun_dev;
>  	int ret;
>  };
> @@ -2002,7 +2001,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
>  	DECLARE_COMPLETION_ONSTACK(tm_done);
>  	enum fnic_ioreq_state old_ioreq_state;
>  
> -	if (sc == iter_data->lr_sc || sc->device != lun_dev)
> +	if (sc->device != lun_dev)
>  		return true;
>  
>  	io_lock = fnic_io_lock_tag(fnic, abt_tag);
> @@ -2105,17 +2104,11 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
>  		return false;
>  	}
>  	fnic_priv(sc)->state = FNIC_IOREQ_ABTS_COMPLETE;
> -
> -	/* original sc used for lr is handled by dev reset code */
> -	if (sc != iter_data->lr_sc)
> -		fnic_priv(sc)->io_req = NULL;
> +	fnic_priv(sc)->io_req = NULL;
>  	spin_unlock_irqrestore(io_lock, flags);
>  
> -	/* original sc used for lr is handled by dev reset code */
> -	if (sc != iter_data->lr_sc) {
> -		fnic_release_ioreq_buf(fnic, io_req, sc);
> -		mempool_free(io_req, fnic->io_req_pool);
> -	}
> +	fnic_release_ioreq_buf(fnic, io_req, sc);
> +	mempool_free(io_req, fnic->io_req_pool);
>  
>  	/*
>  	 * Any IO is returned during reset, it needs to call scsi_done
> @@ -2135,8 +2128,7 @@ static bool fnic_pending_aborts_iter(struct scsi_cmnd *sc, void *data)
>   * successfully aborted, 1 otherwise
>   */
>  static int fnic_clean_pending_aborts(struct fnic *fnic,
> -				     struct scsi_cmnd *lr_sc,
> -				     bool new_sc)
> +				     struct scsi_cmnd *lr_sc)
>  
>  {
>  	int ret = 0;
> @@ -2146,9 +2138,6 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
>  		.ret = SUCCESS,
>  	};
>  
> -	if (new_sc)
> -		iter_data.lr_sc = lr_sc;
> -
>  	scsi_host_busy_iter(fnic->lport->host,
>  			    fnic_pending_aborts_iter, &iter_data);
>  	if (iter_data.ret == FAILED) {
> @@ -2174,7 +2163,8 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
>   */
>  int fnic_device_reset(struct scsi_cmnd *sc)
>  {
> -	struct request *rq = scsi_cmd_to_rq(sc);
> +	struct scsi_device *sdev = sc->device;
> +	struct request *req;
>  	struct fc_lport *lp;
>  	struct fnic *fnic;
>  	struct fnic_io_req *io_req = NULL;
> @@ -2187,15 +2177,17 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	struct scsi_lun fc_lun;
>  	struct fnic_stats *fnic_stats;
>  	struct reset_stats *reset_stats;
> -	int tag = rq->tag;
> +	int tag;
>  	DECLARE_COMPLETION_ONSTACK(tm_done);
> -	bool new_sc = 0;
>  
>  	/* Wait for rport to unblock */
> -	fc_block_scsi_eh(sc);
> +	rport = starget_to_rport(scsi_target(sdev));
> +	ret = fc_block_rport(rport);
> +	if (ret)
> +		return ret;
>  
>  	/* Get local-port, check ready and link up */
> -	lp = shost_priv(sc->device->host);
> +	lp = shost_priv(sdev->host);
>  
>  	fnic = lport_priv(lp);
>  	fnic_stats = &fnic->fnic_stats;
> @@ -2203,53 +2195,55 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  
>  	atomic64_inc(&reset_stats->device_resets);
>  
> -	rport = starget_to_rport(scsi_target(sc->device));
>  	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -		      "Device reset called FCID 0x%x, LUN 0x%llx sc 0x%p\n",
> -		      rport->port_id, sc->device->lun, sc);
> +		      "Device reset called FCID 0x%x, LUN 0x%llx\n",
> +		      rport->port_id, sdev->lun);
>  
>  	if (lp->state != LPORT_ST_READY || !(lp->link_up))
> -		goto fnic_device_reset_end;
> +		return ret;
>  
>  	/* Check if remote port up */
>  	if (fc_remote_port_chkready(rport)) {
>  		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
> -		goto fnic_device_reset_end;
> +		return ret;
>  	}
>  
> -	fnic_priv(sc)->flags = FNIC_DEVICE_RESET;
> -
> -	if (unlikely(tag < 0)) {
> +	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
> +				 BLK_MQ_REQ_NOWAIT);
> +	if (!req) {
>  		/*
> -		 * For device reset issued through sg3utils, we let
> -		 * only one LUN_RESET to go through and use a special
> -		 * tag equal to max_tag_id so that we don't have to allocate
> -		 * or free it. It won't interact with tags
> -		 * allocated by mid layer.
> +		 * Request allocation might fail, indicating that
> +		 * all tags are busy.
> +		 * But device reset will be called only from within
> +		 * SCSI EH, at which time all I/O is stopped. So the
> +		 * only active tags would be for failed I/O, but
> +		 * when all I/O is failed it'll be better to escalate
> +		 * to host reset anyway.
>  		 */
> -		mutex_lock(&fnic->sgreset_mutex);
> -		tag = fnic->fnic_max_tag_id;
> -		new_sc = 1;
> +		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host,
> +			      "Device reset allocation failed, all tags busy\n");
> +		return ret;
>  	}
> +	sc = blk_mq_rq_to_pdu(req);
> +
> +	tag = req->tag;
>  	io_lock = fnic_io_lock_hash(fnic, sc);
>  	spin_lock_irqsave(io_lock, flags);
>  	io_req = fnic_priv(sc)->io_req;
> +	if (io_req)
> +		goto fnic_device_reset_end;
>  
> -	/*
> -	 * If there is a io_req attached to this command, then use it,
> -	 * else allocate a new one.
> -	 */
> +	io_req = mempool_alloc(fnic->io_req_pool, GFP_ATOMIC);
>  	if (!io_req) {
> -		io_req = mempool_alloc(fnic->io_req_pool, GFP_ATOMIC);
> -		if (!io_req) {
> -			spin_unlock_irqrestore(io_lock, flags);
> -			goto fnic_device_reset_end;
> -		}
> -		memset(io_req, 0, sizeof(*io_req));
> -		io_req->port_id = rport->port_id;
> -		fnic_priv(sc)->io_req = io_req;
> +		spin_unlock_irqrestore(io_lock, flags);
> +		goto fnic_device_reset_end;
>  	}
> +	memset(io_req, 0, sizeof(*io_req));
> +	io_req->port_id = rport->port_id;
> +	fnic_priv(sc)->io_req = io_req;
> +
>  	io_req->dr_done = &tm_done;
> +	fnic_priv(sc)->flags = FNIC_DEVICE_RESET;
>  	fnic_priv(sc)->state = FNIC_IOREQ_CMD_PENDING;
>  	fnic_priv(sc)->lr_status = FCPIO_INVALID_CODE;
>  	spin_unlock_irqrestore(io_lock, flags);
> @@ -2260,11 +2254,13 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	 * issue the device reset, if enqueue failed, clean up the ioreq
>  	 * and break assoc with scsi cmd
>  	 */
> +	WRITE_ONCE(req->state, MQ_RQ_IN_FLIGHT);
>  	if (fnic_queue_dr_io_req(fnic, sc, io_req)) {
>  		spin_lock_irqsave(io_lock, flags);
>  		io_req = fnic_priv(sc)->io_req;
>  		if (io_req)
>  			io_req->dr_done = NULL;
> +		WRITE_ONCE(req->state, MQ_RQ_IDLE);
>  		goto fnic_device_reset_clean;
>  	}
>  	spin_lock_irqsave(io_lock, flags);
> @@ -2279,11 +2275,12 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  				    msecs_to_jiffies(FNIC_LUN_RESET_TIMEOUT));
>  
>  	spin_lock_irqsave(io_lock, flags);
> +	WRITE_ONCE(req->state, MQ_RQ_IDLE);
>  	io_req = fnic_priv(sc)->io_req;
>  	if (!io_req) {
>  		spin_unlock_irqrestore(io_lock, flags);
>  		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> -				"io_req is null tag 0x%x sc 0x%p\n", tag, sc);
> +				"io_req is null tag 0x%x\n", tag);
>  		goto fnic_device_reset_end;
>  	}
>  	io_req->dr_done = NULL;
> @@ -2326,7 +2323,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  				spin_unlock_irqrestore(io_lock, flags);
>  				FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>  				"Abort and terminate issued on Device reset "
> -				"tag 0x%x sc 0x%p\n", tag, sc);
> +				"tag 0x%x\n", tag);
>  				break;
>  			}
>  		}
> @@ -2364,7 +2361,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	 * the lun reset cmd. If all cmds get cleaned, the lun reset
>  	 * succeeds
>  	 */
> -	if (fnic_clean_pending_aborts(fnic, sc, new_sc)) {
> +	if (fnic_clean_pending_aborts(fnic, sc)) {
>  		spin_lock_irqsave(io_lock, flags);
>  		io_req = fnic_priv(sc)->io_req;
>  		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
> @@ -2393,15 +2390,15 @@ int fnic_device_reset(struct scsi_cmnd *sc)
>  	}
>  
>  fnic_device_reset_end:
> -	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no, rq->tag, sc,
> +	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no,
> +		  scsi_cmd_to_rq(sc)->tag, sc,
>  		  jiffies_to_msecs(jiffies - start_time),
>  		  0, ((u64)sc->cmnd[0] << 32 |
>  		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
>  		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
>  		  fnic_flags_and_state(sc));
>  
> -	if (new_sc)
> -		mutex_unlock(&fnic->sgreset_mutex);
> +	blk_mq_free_request(req);
>  
>  	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
>  		      "Returning from device reset %s\n",
> @@ -2633,8 +2630,6 @@ static bool fnic_abts_pending_iter(struct scsi_cmnd *sc, void *data)
>  	 * ignore this lun reset cmd or cmds that do not belong to
>  	 * this lun
>  	 */
> -	if (iter_data->lr_sc && sc == iter_data->lr_sc)
> -		return true;
>  	if (iter_data->lun_dev && sc->device != iter_data->lun_dev)
>  		return true;
>  
> @@ -2677,10 +2672,8 @@ int fnic_is_abts_pending(struct fnic *fnic, struct scsi_cmnd *lr_sc)
>  		.ret = 0,
>  	};
>  
> -	if (lr_sc) {
> +	if (lr_sc)
>  		iter_data.lun_dev = lr_sc->device;
> -		iter_data.lr_sc = lr_sc;
> -	}
>  
>  	/* walk again to check, if IOs are still pending in fw */
>  	scsi_host_busy_iter(fnic->lport->host,
> diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
> index f123531e7dd1..c38f648da3d7 100644
> --- a/drivers/scsi/snic/snic_scsi.c
> +++ b/drivers/scsi/snic/snic_scsi.c
> @@ -2367,7 +2367,7 @@ snic_cmpl_pending_tmreq(struct snic *snic, struct scsi_cmnd *sc)
>  }
>  
>  static bool
> -snic_scsi_cleanup_iter(struct scsi_cmnd *sc, void *data, bool reserved)
> +snic_scsi_cleanup_iter(struct scsi_cmnd *sc, void *data)
>  {
>  	struct snic *snic = data;
>  	struct snic_req_info *rqi = NULL;
> @@ -2541,8 +2541,7 @@ struct snic_tgt_scsi_abort_io_data {
>  	int abt_cnt;
>  };
>  
> -static bool snic_tgt_scsi_abort_io_iter(struct scsi_cmnd *sc, void *data,
> -					bool reserved)
> +static bool snic_tgt_scsi_abort_io_iter(struct scsi_cmnd *sc, void *data)
>  {
>  	struct snic_tgt_scsi_abort_io_data *iter_data = data;
>  	struct snic *snic = iter_data->snic;
> -- 
> 2.35.3
---end quoted text---
