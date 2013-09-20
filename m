From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] scsi: improved eh timeout handler
Date: Fri, 20 Sep 2013 15:59:16 +0800
Message-ID: <523C0054.9010908@cn.fujitsu.com>
References: <1378123118-111972-1-git-send-email-hare@suse.de> <1378123118-111972-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:55427 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab3ITH6q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Sep 2013 03:58:46 -0400
In-Reply-To: <1378123118-111972-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

Hi, Hannes:

On 09/02/2013 07:58 PM, Hannes Reinecke wrote:
> +scmd_eh_abort_handler(struct work_struct *work)
> +{
> +	struct scsi_cmnd *scmd =
> +		container_of(work, struct scsi_cmnd, abort_work.work);
> +	struct scsi_device *sdev = scmd->device;
> +	unsigned long flags;
> +	int rtn;
> +
> +	spin_lock_irqsave(sdev->host->host_lock, flags);
> +	if (scsi_host_eh_past_deadline(sdev->host)) {
> +		spin_unlock_irqrestore(sdev->host->host_lock, flags);
> +		SCSI_LOG_ERROR_RECOVERY(3,
> +			scmd_printk(KERN_INFO, scmd,
> +				    "scmd %p eh timeout, not aborting\n", scmd));
> +	} else {
> +		spin_unlock_irqrestore(sdev->host->host_lock, flags);
> +		SCSI_LOG_ERROR_RECOVERY(3,
> +			scmd_printk(KERN_INFO, scmd,
> +				    "aborting command %p\n", scmd));
> +		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
> +		if (rtn == SUCCESS) {
> +			scmd->result |= DID_TIME_OUT<<  16;
> +			if (!scsi_noretry_cmd(scmd)&&
> +			    (++scmd->retries<= scmd->allowed)) {

I think scsi_host_eh_past_deadline() should be checked here like:

-			if (!scsi_noretry_cmd(scmd)&&
+			if (!scsi_host_eh_past_deadline(sdev->host)&&
+			    !scsi_noretry_cmd(scmd)&&

According to my test, once retry requires 30 seconds. If eh_deadline
is reached, we can stop EH here without waiting for long term
retrying.

Thanks,
Ren

>
> +				SCSI_LOG_ERROR_RECOVERY(3,
> +					scmd_printk(KERN_WARNING, scmd,
> +						    "scmd %p retry "
> +						    "aborted command\n", scmd));
> +				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
> +			} else {
> +				SCSI_LOG_ERROR_RECOVERY(3,
> +					scmd_printk(KERN_WARNING, scmd,
> +						    "scmd %p finish "
> +						    "aborted command\n", scmd));
> +				scsi_finish_command(scmd);
> +			}
> +			return;
> +		}

