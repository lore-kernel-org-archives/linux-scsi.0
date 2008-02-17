From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug: disable clustering
Date: Sun, 17 Feb 2008 00:53:12 -0500
Message-ID: <47B7CBC8.2040209@torque.net>
References: <20080216235714H.tomof@acm.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33784 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbYBQFxd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Feb 2008 00:53:33 -0500
In-Reply-To: <20080216235714H.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] scsi_debug: disable clustering
> 
> scsi_debug does at several places:
> 
> for_each_sg(sdb->table.sgl, sg, sdb->table.nents, k) {
> 	kaddr = (unsigned char *)
> 		kmap_atomic(sg_page(sg), KM_USER0);
> 
> 
> We cannot do something like that with the clustering enabled (or we
> can use scsi_kmap_atomic_sg).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Thanks, Tomo.

Signed-off-by: Douglas Gilbert <dougg@torque.net>


> ---
>  drivers/scsi/scsi_debug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1541c17..d1777a9 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -222,7 +222,7 @@ static struct scsi_host_template sdebug_driver_template = {
>  	.cmd_per_lun =		16,
>  	.max_sectors =		0xffff,
>  	.unchecked_isa_dma = 	0,
> -	.use_clustering = 	ENABLE_CLUSTERING,
> +	.use_clustering = 	DISABLE_CLUSTERING,
>  	.module =		THIS_MODULE,
>  };
>  

