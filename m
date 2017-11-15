From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] bnx2fc: Fix hung task messages when a cleanup response
 is not received during abort.
Date: Wed, 15 Nov 2017 10:21:32 -0500
Message-ID: <1510759292.5626.1.camel@redhat.com>
References: <20171115150606.10994-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:56748 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932593AbdKOPVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2017 10:21:34 -0500
Received: by mail-qt0-f194.google.com with SMTP id r39so18806594qtr.13
        for <linux-scsi@vger.kernel.org>; Wed, 15 Nov 2017 07:21:34 -0800 (PST)
In-Reply-To: <20171115150606.10994-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

On Wed, 2017-11-15 at 07:06 -0800, Chad Dupuis wrote:
> If a cleanup task is not responded to while we are in
> bnx2fc_abts_cleanup, it
> will hang the SCSI error handler since we use wait_for_completion
> instead of
> wait_for_completion_timeout.  So, use wait_for_completion_timeout so
> that we
> don't hang the SCSI error handler thread forever.
> 
> Fixes the call trace:
> 
> [183373.131468] INFO: task scsi_eh_16:110146 blocked for more than
> 120 seconds.
> [183373.131469] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [183373.131470] scsi_eh_16      D ffff88103f2fca14     0
> 110146      2 0x00000080
> [183373.131472]  ffff880855e77cb0 0000000000000046 ffff881050654e70
> ffff880855e77fd8
> [183373.131474]  ffff880855e77fd8 ffff880855e77fd8 ffff881050654e70
> ffff88103f2fcb48
> [183373.131475]  ffff88103f2fcb50 7fffffffffffffff ffff881050654e70
> ffff88103f2fca14
> [183373.131477] Call Trace:
> [183373.131479]  [<ffffffff8168b579>] schedule+0x29/0x70
> [183373.131481]  [<ffffffff81688fc9>] schedule_timeout+0x239/0x2d0
> [183373.131486]  [<ffffffff8142821e>] ? __dev_printk+0x3e/0x90
> [183373.131487]  [<ffffffff814282cd>] ? dev_printk+0x5d/0x80
> [183373.131490]  [<ffffffff8168b956>] wait_for_completion+0x116/0x170
> [183373.131492]  [<ffffffff810c4ec0>] ? wake_up_state+0x20/0x20
> [183373.131494]  [<ffffffffa048c234>] bnx2fc_abts_cleanup+0x3d/0x62
> [bnx2fc]
> [183373.131497]  [<ffffffffa0483a80>] bnx2fc_eh_abort+0x470/0x580
> [bnx2fc]
> [183373.131500]  [<ffffffff814570af>] scsi_error_handler+0x59f/0x8b0
> [183373.131501]  [<ffffffff81456b10>] ? scsi_eh_get_sense+0x250/0x250
> [183373.131503]  [<ffffffff810b052f>] kthread+0xcf/0xe0
> [183373.131505]  [<ffffffff810b0460>] ?
> kthread_create_on_node+0x140/0x140
> [183373.131507]  [<ffffffff81696418>] ret_from_fork+0x58/0x90
> [183373.131509]  [<ffffffff810b0460>] ?
> kthread_create_on_node+0x140/0x140
> 
> Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c | 40
> ++++++++++++++++++++++++++++++++--------
>  1 file changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
> b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 5b6153f23f01..2cbb5be98ecb 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1084,24 +1084,35 @@ static int bnx2fc_abts_cleanup(struct
> bnx2fc_cmd *io_req)
>  {
>  	struct bnx2fc_rport *tgt = io_req->tgt;
>  	int rc = SUCCESS;
> +	unsigned int time_left;
>  
>  	io_req->wait_for_comp = 1;
>  	bnx2fc_initiate_cleanup(io_req);
>  
>  	spin_unlock_bh(&tgt->tgt_lock);
>  
> -	wait_for_completion(&io_req->tm_done);
> -
> +	/*
> +	 * Can't wait forever on cleanup response lest we let the
> SCSI error
> +	 * handler wait forever
> +	 */
> +	time_left = wait_for_completion_timeout(&io_req->tm_done,
> +	    BNX2FC_FW_TIMEOUT);
>  	io_req->wait_for_comp = 0;
> +	if (!time_left)
> +		BNX2FC_IO_DBG(io_req, "%s(): Wait for cleanup timed
> out.\n",
> +		    __func__);
> +
>  	/*
> -	 * release the reference taken in eh_abort to allow the
> -	 * target to re-login after flushing IOs
> +	 * Release reference held by SCSI command the cleanup
> completion
> +	 * hits the BNX2FC_CLEANUP case in bnx2fc_process_cq_compl()
> and
> +	 * thus the SCSI command is not returnedi by
> bnx2fc_scsi_done().
>  	 */
>  	kref_put(&io_req->refcount, bnx2fc_cmd_release);
>  
>  	spin_lock_bh(&tgt->tgt_lock);
>  	return rc;
>  }
> +
>  /**
>   * bnx2fc_eh_abort - eh_abort_handler api to abort an outstanding
>   *			SCSI command
> @@ -1118,6 +1129,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>  	struct fc_lport *lport;
>  	struct bnx2fc_rport *tgt;
>  	int rc;
> +	unsigned int time_left;
>  
>  	rc = fc_block_scsi_eh(sc_cmd);
>  	if (rc)
> @@ -1194,6 +1206,11 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>  		if (cancel_delayed_work(&io_req->timeout_work))
>  			kref_put(&io_req->refcount,
>  				 bnx2fc_cmd_release); /* drop timer
> hold */
> +		/*
> +		 * We don't want to hold off the upper layer timer
> so simply
> +		 * cleanup the command and return that I/O was
> successfully
> +		 * aborted.
> +		 */
>  		rc = bnx2fc_abts_cleanup(io_req);
>  		/* This only occurs when an task abort was requested
> while ABTS
>  		   is in progress.  Setting the IO_CLEANUP flag will
> skip the
> @@ -1201,7 +1218,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>  		   was a result from the ABTS request rather than
> the CLEANUP
>  		   request */
>  		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req-
> >req_flags);
> -		goto out;
> +		goto done;
>  	}
>  
>  	/* Cancel the current timer running on this io_req */
> @@ -1221,7 +1238,11 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>  	}
>  	spin_unlock_bh(&tgt->tgt_lock);
>  
> -	wait_for_completion(&io_req->tm_done);
> +	/* Wait 2 * RA_TOV + 1 to be sure timeout function hasn't
> fired */
> +	time_left = wait_for_completion_timeout(&io_req->tm_done,
> +	    (2 * rp->r_a_tov + 1) * HZ);
> +	if (time_left)
> +		BNX2FC_IO_DBG(io_req, "Timed out in eh_abort waiting
> for tm_done");
>  
>  	spin_lock_bh(&tgt->tgt_lock);
>  	io_req->wait_for_comp = 0;
> @@ -1233,8 +1254,12 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>  		/* Let the scsi-ml try to recover this command */
>  		printk(KERN_ERR PFX "abort failed, xid = 0x%x\n",
>  		       io_req->xid);
> +		/*
> +		 * Cleanup firmware residuals before returning
> control back
> +		 * to SCSI ML.
> +		 */
>  		rc = bnx2fc_abts_cleanup(io_req);
> -		goto out;
> +		goto done;
>  	} else {
>  		/*
>  		 * We come here even when there was a race condition
> @@ -1249,7 +1274,6 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
>  done:
>  	/* release the reference taken in eh_abort */
>  	kref_put(&io_req->refcount, bnx2fc_cmd_release);
> -out:
>  	spin_unlock_bh(&tgt->tgt_lock);
>  	return rc;
>  }

We experienced this at a major customer and provided this patch after
working with Chad and backported to RHEL as a test kernel.

Its been stable while running a test kernel and the changes look good
ate least to me.

Reviewed-by: Laurence Oberman <loberman@redhat.com>
Tested-by:   Laurence Oberman <loberman@redhat.com>

Thanks
Laurence
