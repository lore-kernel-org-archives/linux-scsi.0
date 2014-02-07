From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 04/17] scsi: avoid useless free_list lock roundtrips
Date: Fri, 07 Feb 2014 10:05:56 +0100
Message-ID: <52F4A1F4.3090508@redhat.com>
References: <20140205123930.150608699@bombadil.infradead.org> <20140205124019.577883829@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:41650 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBGJGB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 04:06:01 -0500
Received: by mail-qa0-f48.google.com with SMTP id f11so4709420qae.7
        for <linux-scsi@vger.kernel.org>; Fri, 07 Feb 2014 01:06:00 -0800 (PST)
In-Reply-To: <20140205124019.577883829@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Il 05/02/2014 13:39, Christoph Hellwig ha scritto:
> Avoid hitting the host-wide free_list lock unless we need to put a command
> back onto the freelist.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ebcea6c..4139486 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -320,15 +320,16 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
>  {
>  	unsigned long flags;
>
> -	/* changing locks here, don't need to restore the irq state */
> -	spin_lock_irqsave(&shost->free_list_lock, flags);
>  	if (unlikely(list_empty(&shost->free_list))) {
> -		list_add(&cmd->list, &shost->free_list);
> -		cmd = NULL;
> +		spin_lock_irqsave(&shost->free_list_lock, flags);
> +		if (list_empty(&shost->free_list)) {
> +			list_add(&cmd->list, &shost->free_list);
> +			cmd = NULL;
> +		}
> +		spin_unlock_irqrestore(&shost->free_list_lock, flags);
>  	}
> -	spin_unlock_irqrestore(&shost->free_list_lock, flags);
>
> -	if (likely(cmd != NULL))
> +	if (cmd)
>  		scsi_pool_free_command(shost->cmd_pool, cmd);
>
>  	put_device(dev);

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

