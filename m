From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 02/22] SCSI: implement host_eh_scheduled hack for libata
Date: Sat, 13 May 2006 17:34:54 -0400
Message-ID: <446650FE.8050308@pobox.com>
References: <11473487904197-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <11473487904197-git-send-email-htejun@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, axboe@suse.de, albertcc@tw.ibm.com, forrest.zhao@intel.com, efalk@google.com, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> libata needs to invoke EH without scmd.  This patch adds
> shost->host_eh_scheduled to implement such behavior.
> 
> As this is a temporary hack for libata, no general interface is
> defined.  This patch simply adds handling for host_eh_scheduled where
> needed and exports scsi_eh_wakeup() to modules.  The rest is upto
> libata.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

I ACK the change (the important part), but not the description or comments.

Rationale for ACK (if it matters):  Back when the first version of this 
was posted, after our initial discussion I reviewed the uses of 
->host_failed and ->host_busy, and had considered twiddling those rather 
than adding another state variable.  Being in EH when host_failed==0 
made me nervous.  However, after reviewing the uses, I now feel that 
your approach presented probably creates less complex code.



> b3095135fd8d02d5b31591d87243afb3aeb217da
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 1c75646..442ae59 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -56,6 +56,7 @@ void scsi_eh_wakeup(struct Scsi_Host *sh
>  				printk("Waking error handler thread\n"));
>  	}
>  }
> +EXPORT_SYMBOL_GPL(scsi_eh_wakeup);	/* exported only for libata */
>  
>  /**
>   * scsi_eh_scmd_add - add scsi cmd to error handling.
> @@ -1517,7 +1518,7 @@ int scsi_error_handler(void *data)
>  	 */
>  	set_current_state(TASK_INTERRUPTIBLE);
>  	while (!kthread_should_stop()) {
> -		if (shost->host_failed == 0 ||
> +		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
>  		    shost->host_failed != shost->host_busy) {
>  			SCSI_LOG_ERROR_RECOVERY(1,
>  				printk("Error handler scsi_eh_%d sleeping\n",
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7b0f9a3..c55d195 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -566,7 +566,7 @@ void scsi_device_unbusy(struct scsi_devi
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	shost->host_busy--;
>  	if (unlikely(scsi_host_in_recovery(shost) &&
> -		     shost->host_failed))
> +		     (shost->host_failed || shost->host_eh_scheduled)))
>  		scsi_eh_wakeup(shost);
>  	spin_unlock(shost->host_lock);
>  	spin_lock(sdev->request_queue->queue_lock);
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index d160880..e31ada2 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -35,6 +35,7 @@ static inline int scsi_sense_valid(struc
>  }
>  
>  
> +extern void scsi_eh_wakeup(struct Scsi_Host *shost);	/* libata only */
>  extern void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
>  			       struct list_head *done_q);
>  extern void scsi_eh_flush_done_q(struct list_head *done_q);
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index de6ce54..3b454c2 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -472,6 +472,7 @@ struct Scsi_Host {
>  	 */
>  	unsigned int host_busy;		   /* commands actually active on low-level */
>  	unsigned int host_failed;	   /* commands that failed. */
> +	unsigned int host_eh_scheduled;	   /* XXX - libata hack, do NOT use */

However, the nitpicks I have with the comments and patch description:

* Although your comments about "libata only" are true, it is more 
correct to say that these are exclusive to ->eh_strategy_handler() 
users.  It just so happens that libata is the only in-tree user... 
however when making changes to the SCSI driver API, you should be in a 
"I'm updating the SCSI EH API" frame of mine as well.

* In your patch description you mention this change (or a subset 
thereof) is temporary, but do not explain why it is temporary, and what 
will be the eventual replacement.

* In general this change should be described as an addition to the SCSI 
LLDD EH API...  I even disagree to some extent of calling it a hack. 
One must Do What Needs To Be Done, And No More.  There is no shame in 
that :)

The ->eh_strategy_handler API is guaranteed to be rough, because there 
weren't really any in-tree users until libata came along.  Now we're 
exposing the rough edges, and fixing them.

	Jeff


