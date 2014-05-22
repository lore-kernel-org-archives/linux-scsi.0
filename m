From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC] Remove the cancel_delayed_work() call from scsi_put_command()
Date: Thu, 22 May 2014 18:22:13 +0200
Message-ID: <537E2435.7030705@redhat.com>
References: <537CAA79.2030304@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:49826 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaEVQWS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 12:22:18 -0400
Received: by mail-ee0-f52.google.com with SMTP id e53so2716962eek.25
        for <linux-scsi@vger.kernel.org>; Thu, 22 May 2014 09:22:17 -0700 (PDT)
In-Reply-To: <537CAA79.2030304@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

Il 21/05/2014 15:30, Bart Van Assche ha scritto:
> +static bool scmd_being_handled_in_other_context(struct scsi_cmnd *scmd)
> +{
> +	struct Scsi_Host *shost = scmd->device->host;
> +	struct scsi_cmnd *c;
> +	unsigned long flags;
> +	bool ret = false;
> +
> +	if (!blk_rq_completed(scmd->request))
> +		return true;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +	list_for_each_entry(c, &shost->eh_cmd_q, eh_entry) {
> +		if (c == scmd) {
> +			ret = true;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	return ret;
> +}
> +
>  /**
>   * scmd_eh_abort_handler - Handle command aborts
>   * @work:	command to be aborted.
> @@ -120,6 +142,8 @@ scmd_eh_abort_handler(struct work_struct *work)
>  	struct scsi_device *sdev = scmd->device;
>  	int rtn;
>
> +	WARN_ON_ONCE(scmd_being_handled_in_other_context(scmd));

What about a simpler, though less accuracte

	WARN_ON(!blk_rq_completed(scmd->request));

that doesn't need the host_lock?

Paolo
