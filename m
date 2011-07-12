From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH 3/3] libsas: fix sas_queuecommand return values
Date: Tue, 12 Jul 2011 09:16:57 +0800
Message-ID: <0047AC94FAA94EB397D508D5E8CFC53D@usish.com.cn>
References: <20110711184922.859239377@bombadil.infradead.org> <20110711185045.547083012@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:50866 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab1GLBRL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2011 21:17:11 -0400
In-Reply-To: <20110711185045.547083012@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

> ->queuecommand must return either 0, or one of the SCSI_MLQUEUE_* return
> values.  Non-transient errors are indicated by setting cmd->result before
> calling ->scsi_done and returning 0.  Fix libsas to adhere to this calling
> convention.  Note that the DID_ERROR for returns from the low-level driver
> might not be correct for all cases, but it's the best we can do with
> the current layering in libsas.  I also suspect that the pre-existing
> handling of -SAS_QUEUE_FULL should really be SCSI_MLQUEUE_HOST_BUSY, but
> I'll leave that for a separate change.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/drivers/scsi/libsas/sas_scsi_host.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/libsas/sas_scsi_host.c	2011-07-11
> 20:25:25.529428978 +0200
> +++ linux-2.6/drivers/scsi/libsas/sas_scsi_host.c	2011-07-11
> 20:29:22.321479498 +0200
> @@ -207,7 +207,7 @@ int sas_queuecommand(struct Scsi_Host *h
> 
>  	task = sas_create_task(cmd, dev, GFP_ATOMIC);
>  	if (!task)
> -		return -ENOMEM;
> +		return SCSI_MLQUEUE_HOST_BUSY;
> 
>  	/* Queue up, Direct Mode or Task Collector Mode. */
>  	if (sas_ha->lldd_max_execute_num < 2)
> @@ -223,9 +223,10 @@ out_free_task:
>  	SAS_DPRINTK("lldd_execute_task returned: %d\n", res);
>  	ASSIGN_SAS_TASK(cmd, NULL);
>  	sas_free_task(task);
> -	if (res != -SAS_QUEUE_FULL)
> -		return res;
> -	cmd->result = DID_SOFT_ERROR << 16; /* retry */
> +	if (res = -SAS_QUEUE_FULL)
[Jack Wang] Seems you should use res == -SAS_QUEUE_FULL ? 
I will test the patchset and report result later.
> +		cmd->result = DID_SOFT_ERROR << 16; /* retry */
> +	else
> +		cmd->result = DID_ERROR << 16;
>  out_done:
>  	cmd->scsi_done(cmd);
>  	return 0;
> 

