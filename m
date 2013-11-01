From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] scsi: improved eh timeout handler
Date: Fri, 01 Nov 2013 14:10:12 +0800
Message-ID: <527345C4.2000504@cn.fujitsu.com>
References: <1383224573-113346-1-git-send-email-hare@suse.de> <1383224573-113346-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60274 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754714Ab3KAGJT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Nov 2013 02:09:19 -0400
In-Reply-To: <1383224573-113346-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

Hi, Hannes:

I'm sorry that I don't know why you didn't consider my former patch
below which not only raises the minimum valid value of 'eh_deadline'
as '0' for your former patchset but also includes some fix for your
this patchset:

http://www.spinics.net/lists/linux-scsi/msg69361.html

If you think I'd post the minimum value issue as a improvement when
your patchset is accepted, I've no problem;-)

On 10/31/2013 09:02 PM, Hannes Reinecke wrote:
> +void
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
> +				    "scmd %p eh timeout, not aborting\n",
> +				    scmd));
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

scsi_host_eh_past_deadline() should also be checked here before long
term retrying.

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
> +		SCSI_LOG_ERROR_RECOVERY(3,
> +			scmd_printk(KERN_INFO, scmd,
> +				    "scmd %p abort failed, rtn %d\n",
> +				    scmd, rtn));
> +	}
> +
> +	if (scsi_eh_scmd_add(scmd, 0)) {

scsi_finish_command() should be invoked if scsi_eh_scmd_add() is
returned on failure.

Thanks,
Ren

>
> +		SCSI_LOG_ERROR_RECOVERY(3,
> +			scmd_printk(KERN_WARNING, scmd,
> +				    "scmd %p terminate "
> +				    "aborted command\n", scmd));
> +		scmd->result |= DID_TIME_OUT<<  16;
> +		scsi_finish_command(scmd);
> +	}
> +}
> <snip>
