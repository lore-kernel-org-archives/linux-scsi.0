From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] scsi: explicitly release bidi buffers
Date: Wed, 26 Mar 2014 02:46:19 -0700
Message-ID: <20140326094619.GA30655@infradead.org>
References: <20140312110606.GA8230@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58583 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaCZJqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Mar 2014 05:46:21 -0400
Content-Disposition: inline
In-Reply-To: <20140312110606.GA8230@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

Now that LSF is done can I get anyone excited to review these?

On Wed, Mar 12, 2014 at 04:06:06AM -0700, Christoph Hellwig wrote:
> Instead of trying to guess when we have a BIDI buffer in scsi_release_buffers
> add a function to explicitly free the BIDI ressoures in the one place that
> handles them.  This avoids needing a special __scsi_release_buffers for the
> case where we already have freed the request as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index debe30a..3012700 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -511,8 +511,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
>  		scsi_run_queue(sdev->request_queue);
>  }
>  
> -static void __scsi_release_buffers(struct scsi_cmnd *, int);
> -
>  /*
>   * Function:    scsi_end_request()
>   *
> @@ -568,7 +566,7 @@ static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
>  	 * This will goose the queue request function at the end, so we don't
>  	 * need to worry about launching another command.
>  	 */
> -	__scsi_release_buffers(cmd, 0);
> +	scsi_release_buffers(cmd);
>  	scsi_next_command(cmd);
>  	return NULL;
>  }
> @@ -624,30 +622,10 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb)
>  	__sg_free_table(&sdb->table, SCSI_MAX_SG_SEGMENTS, scsi_sg_free);
>  }
>  
> -static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
> -{
> -
> -	if (cmd->sdb.table.nents)
> -		scsi_free_sgtable(&cmd->sdb);
> -
> -	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
> -
> -	if (do_bidi_check && scsi_bidi_cmnd(cmd)) {
> -		struct scsi_data_buffer *bidi_sdb =
> -			cmd->request->next_rq->special;
> -		scsi_free_sgtable(bidi_sdb);
> -		kmem_cache_free(scsi_sdb_cache, bidi_sdb);
> -		cmd->request->next_rq->special = NULL;
> -	}
> -
> -	if (scsi_prot_sg_count(cmd))
> -		scsi_free_sgtable(cmd->prot_sdb);
> -}
> -
>  /*
>   * Function:    scsi_release_buffers()
>   *
> - * Purpose:     Completion processing for block device I/O requests.
> + * Purpose:     Free resources allocate for a scsi_command.
>   *
>   * Arguments:   cmd	- command that we are bailing.
>   *
> @@ -658,15 +636,29 @@ static void __scsi_release_buffers(struct scsi_cmnd *cmd, int do_bidi_check)
>   * Notes:       In the event that an upper level driver rejects a
>   *		command, we must release resources allocated during
>   *		the __init_io() function.  Primarily this would involve
> - *		the scatter-gather table, and potentially any bounce
> - *		buffers.
> + *		the scatter-gather table.
>   */
>  void scsi_release_buffers(struct scsi_cmnd *cmd)
>  {
> -	__scsi_release_buffers(cmd, 1);
> +	if (cmd->sdb.table.nents)
> +		scsi_free_sgtable(&cmd->sdb);
> +
> +	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
> +
> +	if (scsi_prot_sg_count(cmd))
> +		scsi_free_sgtable(cmd->prot_sdb);
>  }
>  EXPORT_SYMBOL(scsi_release_buffers);
>  
> +static void scsi_release_bidi_buffers(struct scsi_cmnd *cmd)
> +{
> +	struct scsi_data_buffer *bidi_sdb = cmd->request->next_rq->special;
> +
> +	scsi_free_sgtable(bidi_sdb);
> +	kmem_cache_free(scsi_sdb_cache, bidi_sdb);
> +	cmd->request->next_rq->special = NULL;
> +}
> +
>  /**
>   * __scsi_error_from_host_byte - translate SCSI error code into errno
>   * @cmd:	SCSI command (unused)
> @@ -799,6 +791,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  			req->next_rq->resid_len = scsi_in(cmd)->resid;
>  
>  			scsi_release_buffers(cmd);
> +			scsi_release_bidi_buffers(cmd);
>  			blk_end_request_all(req, 0);
>  
>  			scsi_next_command(cmd);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
