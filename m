From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Wed, 1 Mar 2006 16:29:29 +0100
Message-ID: <20060301152929.GZ4816@suse.de>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:26664 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S932154AbWCAP3t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 10:29:49 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Tue, Feb 28 2006, Kai Makisara wrote:
> This patch enables clustering and sets max_sectors to 0xffff to enable 
> reading and writing of large blocks with tapes (and large transfers with 
> sg). This change is needed after the sg and st drivers started using 
> chained bios through scsi_request_async() in 2.6.16.
> 
> Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
> 
> --- linux-2.6.16-rc5/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-04 13:25:48.000000000 +0200
> +++ linux-2.6.16-rc5-k1/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-18 09:45:24.000000000 +0200
> @@ -1978,7 +1978,8 @@ static struct scsi_host_template sym2_te
>  	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
>  	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
>  	.this_id		= 7,
> -	.use_clustering		= DISABLE_CLUSTERING,
> +	.use_clustering		= ENABLE_CLUSTERING,
> +	.max_sectors		= 0xFFFF,

Strictly speaking, the clustering bit is unrelated. I seem to recall
Gerard years ago talking about some sym chips that did not like
clustering, hence it was disabled.

-- 
Jens Axboe

