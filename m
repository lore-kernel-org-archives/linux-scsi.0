From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: Set the minimum valid value of 'eh_deadline' as 0
Date: Wed, 09 Oct 2013 08:28:27 -0400
Message-ID: <1381321707.27183.21.camel@localhost.localdomain>
References: <524C48AC.2010901@suse.de>
	 <1381304600-7862-1-git-send-email-renmx@cn.fujitsu.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab3JIM3i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Oct 2013 08:29:38 -0400
In-Reply-To: <1381304600-7862-1-git-send-email-renmx@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: hare@suse.de, jbottomley@parallels.com, linux-scsi@vger.kernel.org, joern@logfs.org, james.smart@emulex.com, bvanassche@acm.org, roland@purestorage.com

On Wed, 2013-10-09 at 15:43 +0800, Ren Mingxin wrote:
> The former minimum valid value of 'eh_deadline' is 1s, which means
> the earliest occasion to shorten EH is 1 second later since a
> command is failed or timed out. But if we want to skip EH steps
> ASAP, we have to wait until the first EH step is finished. If the
> duration of the first EH step is long, this waiting time is
> excruciating. So, it is necessary to accept 0 as the minimum valid
> value for 'eh_deadline'.
> 
> According to my test, with Hannes' patchset 'New EH command timeout
> handler' as well, the minimum IO time is improved from 73s
> (eh_deadline = 1) to 43s(eh_deadline = 0) when commands are timed
> out by disabling RSCN and target port.
> 
> Another thing: scsi_finish_command() should be invoked if
> scsi_eh_scmd_add() is returned on failure - let EH finish those
> commands.
> 
> Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
> ---
>  drivers/scsi/hosts.c      |   14 +++++++++++---
>  drivers/scsi/scsi_error.c |   40 +++++++++++++++++++++++++++-------------
>  drivers/scsi/scsi_sysfs.c |   36 +++++++++++++++++++++++++-----------
>  include/scsi/scsi_host.h  |    2 +-
>  4 files changed, 64 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index f334859..e84123a 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -316,11 +316,11 @@ static void scsi_host_dev_release(struct device *dev)
>  	kfree(shost);
>  }
>  
> -static unsigned int shost_eh_deadline;
> +static unsigned int shost_eh_deadline = -1;

This should probably be "static int shost_eh_deadline = -1;".
And the range tests in scsi_host_alloc() and store_shost_eh_deadline()
below should probably use INT_MAX rather than UINT_MAX.

>  
>  module_param_named(eh_deadline, shost_eh_deadline, uint, S_IRUGO|S_IWUSR);
>  MODULE_PARM_DESC(eh_deadline,
> -		 "SCSI EH timeout in seconds (should be between 1 and 2^32-1)");
> +		 "SCSI EH timeout in seconds (should be between 0 and 2^32-1)");
>  
>  static struct device_type scsi_host_type = {
>  	.name =		"scsi_host",
> @@ -394,7 +394,15 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
>  	shost->use_clustering = sht->use_clustering;
>  	shost->ordered_tag = sht->ordered_tag;
> -	shost->eh_deadline = shost_eh_deadline * HZ;
> +	if (shost_eh_deadline == -1)
> +		shost->eh_deadline = -1;
> +	else if ((ulong) shost_eh_deadline * HZ > UINT_MAX) {
> +		printk(KERN_WARNING "scsi%d: eh_deadline %u exceeds the "
> +		       "maximum, setting to %u\n",
> +		       shost->host_no, shost_eh_deadline, UINT_MAX / HZ);
> +		shost->eh_deadline = UINT_MAX / HZ * HZ;

Just use "shost->eh_deadline = INT_MAX" here, leave off the "/ HZ * HZ".

> +	} else
> +		shost->eh_deadline = shost_eh_deadline * HZ;
>  
>  	if (sht->supported_mode == MODE_UNKNOWN)
>  		/* means we didn't set it ... default to INITIATOR */
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index adb4cbe..c2f9431 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -90,7 +90,7 @@ EXPORT_SYMBOL_GPL(scsi_schedule_eh);
>  
>  static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
>  {
> -	if (!shost->last_reset || !shost->eh_deadline)
> +	if (!shost->last_reset || shost->eh_deadline == -1)
>  		return 0;
>  
>  	if (time_before(jiffies,
> @@ -127,29 +127,43 @@ scmd_eh_abort_handler(struct work_struct *work)
>  		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
>  		if (rtn == SUCCESS) {
>  			scmd->result |= DID_TIME_OUT << 16;
> -			if (!scsi_noretry_cmd(scmd) &&
> +			spin_lock_irqsave(sdev->host->host_lock, flags);
> +			if (scsi_host_eh_past_deadline(sdev->host)) {
> +				spin_unlock_irqrestore(sdev->host->host_lock,
> +						       flags);
> +				SCSI_LOG_ERROR_RECOVERY(3,
> +					scmd_printk(KERN_INFO, scmd,
> +						    "scmd %p eh timeout, "
> +						    "not retrying aborted "
> +						    "command\n", scmd));
> +			} else if (!scsi_noretry_cmd(scmd) &&
>  			    (++scmd->retries <= scmd->allowed)) {
> +				spin_unlock_irqrestore(sdev->host->host_lock,
> +						       flags);
>  				SCSI_LOG_ERROR_RECOVERY(3,
>  					scmd_printk(KERN_WARNING, scmd,
>  						    "scmd %p retry "
>  						    "aborted command\n", scmd));
>  				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
> +				return;
>  			} else {
> +				spin_unlock_irqrestore(sdev->host->host_lock,
> +						       flags);
>  				SCSI_LOG_ERROR_RECOVERY(3,
>  					scmd_printk(KERN_WARNING, scmd,
>  						    "scmd %p finish "
>  						    "aborted command\n", scmd));
>  				scsi_finish_command(scmd);
> +				return;
>  			}
> -			return;
> -		}
> -		SCSI_LOG_ERROR_RECOVERY(3,
> -			scmd_printk(KERN_INFO, scmd,
> -				    "scmd %p abort failed, rtn %d\n",
> -				    scmd, rtn));
> +		} else
> +			SCSI_LOG_ERROR_RECOVERY(3,
> +				scmd_printk(KERN_INFO, scmd,
> +					    "scmd %p abort failed, rtn %d\n",
> +					    scmd, rtn));
>  	}
>  
> -	if (scsi_eh_scmd_add(scmd, 0)) {
> +	if (!scsi_eh_scmd_add(scmd, 0)) {
>  		SCSI_LOG_ERROR_RECOVERY(3,
>  			scmd_printk(KERN_WARNING, scmd,
>  				    "scmd %p terminate "
> @@ -197,7 +211,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>  		return FAILED;
>  	}
>  
> -	if (shost->eh_deadline && !shost->last_reset)
> +	if (shost->eh_deadline != -1 && !shost->last_reset)
>  		shost->last_reset = jiffies;
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  
> @@ -231,7 +245,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
>  		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
>  			goto out_unlock;
>  
> -	if (shost->eh_deadline && !shost->last_reset)
> +	if (shost->eh_deadline != -1 && !shost->last_reset)
>  		shost->last_reset = jiffies;
>  
>  	ret = 1;
> @@ -265,7 +279,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
>  	trace_scsi_dispatch_cmd_timeout(scmd);
>  	scsi_log_completion(scmd, TIMEOUT_ERROR);
>  
> -	if (host->eh_deadline && !host->last_reset)
> +	if (host->eh_deadline != -1 && !host->last_reset)
>  		host->last_reset = jiffies;
>  
>  	if (host->transportt->eh_timed_out)
> @@ -2130,7 +2144,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
>  			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	if (shost->eh_deadline)
> +	if (shost->eh_deadline != -1)
>  		shost->last_reset = 0;
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  	scsi_eh_flush_done_q(&eh_done_q);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 57c78ef..b0591aa 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -287,7 +287,9 @@ show_shost_eh_deadline(struct device *dev,
>  {
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  
> -	return sprintf(buf, "%d\n", shost->eh_deadline / HZ);
> +	if (shost->eh_deadline == -1)
> +		return snprintf(buf, strlen("off") + 2, "off\n");
> +	return sprintf(buf, "%u\n", shost->eh_deadline / HZ);
>  }
>  
>  static ssize_t
> @@ -296,22 +298,34 @@ store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
>  {
>  	struct Scsi_Host *shost = class_to_shost(dev);
>  	int ret = -EINVAL;
> -	int deadline;
> -	unsigned long flags;
> +	unsigned long deadline, flags;
> +	char *cp;
>  
>  	if (shost->transportt && shost->transportt->eh_strategy_handler)
>  		return ret;
>  
> -	if (sscanf(buf, "%d\n", &deadline) == 1) {
> -		spin_lock_irqsave(shost->host_lock, flags);
> -		if (scsi_host_in_recovery(shost))
> -			ret = -EBUSY;
> -		else {
> +	if (!strncmp(buf, "off", strlen("off")))
> +		deadline = -1;
> +	else {
> +		deadline = simple_strtoul(buf, &cp, 0);
> +		if ((*cp && (*cp != '\n')) ||
> +		    deadline * HZ > UINT_MAX)
> +			return ret;
> +	}
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	if (scsi_host_in_recovery(shost))
> +		ret = -EBUSY;
> +	else {
> +		if (deadline == -1)
> +			shost->eh_deadline = -1;
> +		else
>  			shost->eh_deadline = deadline * HZ;
> -			ret = count;
> -		}
> -		spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +		ret = count;
>  	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
>  	return ret;
>  }
>  
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 6ca9174..b50355c 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -603,7 +603,7 @@ struct Scsi_Host {
>  	unsigned int host_eh_scheduled;    /* EH scheduled without command */
>  
>  	unsigned int host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
> -	int eh_deadline;
> +	unsigned int eh_deadline;
>  	unsigned long last_reset;
>  
>  	/*


