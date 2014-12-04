From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/12] advansys: use host_reset
Date: Thu, 4 Dec 2014 10:17:41 +0100
Message-ID: <20141204091741.GC23891@lst.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de> <1417607105-85455-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57365 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbaLDJRo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 04:17:44 -0500
Content-Disposition: inline
In-Reply-To: <1417607105-85455-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

> -#define AdvAbortQueue(asc_dvc, scsiq) \
> +#define AdvAbortQueue(asc_dvc, srb_tag) \
>          AdvSendIdleCmd((asc_dvc), (ushort) IDLE_CMD_ABORT, \
> -                       (ADV_DCNT) (scsiq))
> +                       (ADV_DCNT) (srb_tag))

This change looks unrelated.

> @@ -11250,7 +11250,7 @@ static struct scsi_host_template advansys_template = {
>  	.name = DRV_NAME,
>  	.info = advansys_info,
>  	.queuecommand = advansys_queuecommand,
> -	.eh_bus_reset_handler = advansys_reset,
> +	.eh_host_reset_handler = advansys_reset,

Please also update the comments in advansys_reset that talk about bus
resets and in one case event about a device reset.

