From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] nvmet_fc: add defer_req callback for deferment of
 cmd buffer return
Date: Wed, 2 Aug 2017 10:16:17 +0200
Message-ID: <20170802081617.GD4256@linux-x5ow.site>
References: <20170801221240.31723-1-jsmart2021@gmail.com>
 <20170801221240.31723-2-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48662 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751192AbdHBIQW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Aug 2017 04:16:22 -0400
Content-Disposition: inline
In-Reply-To: <20170801221240.31723-2-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: linux-nvme@lists.infradead.org, James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On Tue, Aug 01, 2017 at 03:12:39PM -0700, James Smart wrote:
> @@ -463,9 +472,9 @@ static struct nvmet_fc_fcp_iod *
>  nvmet_fc_alloc_fcp_iod(struct nvmet_fc_tgt_queue *queue)
>  {
>  	static struct nvmet_fc_fcp_iod *fod;
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&queue->qlock, flags);
> +	/* Caller must hold queue->qlock */
+       lockped_assert_held(&queue->qlock); 
So we can check if the caller really holds the queue lock.

> +
>  	fod = list_first_entry_or_null(&queue->fod_list,
>  					struct nvmet_fc_fcp_iod, fcp_list);
>  	if (fod) {

[...]

> +	for (;;) {
> +		deferfcp = list_first_entry_or_null(&queue->pending_cmd_list,
> +				struct nvmet_fc_defer_fcp_req, req_list);
> +		if (!deferfcp)
> +			break;

        while ((deferfcp = list_first_entry_or_null(&queue->pending_cmd_list,
				struct nvmet_fc_defer_fcp_req,
				req_list)) != NULL) {
?

Other than that,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
