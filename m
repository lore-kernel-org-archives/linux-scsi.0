From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 3/6] ipr: Fix possible error path oops during
 initialization
Date: Fri, 27 Mar 2015 12:50:04 -0400
Message-ID: <20150327125004.Horde.uxRTPqERGkzSkAVZ0RQVwg1@ltc.linux.ibm.com>
References: <201503261623.t2QGNtSX003713@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38040 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbbC0QuK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 12:50:10 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Fri, 27 Mar 2015 12:50:09 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id AB18138C8046
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 12:50:06 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t2RGo6js24641696
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 16:50:06 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t2RGo5ac019864
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 12:50:06 -0400
In-Reply-To: <201503261623.t2QGNtSX003713@d03av03.boulder.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, hch@lst.de, linux-scsi@vger.kernel.org, kreling@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, dan.carpenter@oracle.com

Reviewed-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Brian King <brking@linux.vnet.ibm.com>:

> Fixes a possible oops during adapter initialization in some
> memory allocation failure error paths scenarios.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/ipr.c |   14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff -puN drivers/scsi/ipr.c~ipr_free_cmd_blks_oops drivers/scsi/ipr.c
> --- linux/drivers/scsi/ipr.c~ipr_free_cmd_blks_oops	2015-03-26  
> 11:14:41.465782868 -0500
> +++ linux-bjking1/drivers/scsi/ipr.c	2015-03-26 11:14:41.471782829 -0500
> @@ -9061,13 +9061,15 @@ static void ipr_free_cmd_blks(struct ipr
>  {
>  	int i;
>
> -	for (i = 0; i < IPR_NUM_CMD_BLKS; i++) {
> -		if (ioa_cfg->ipr_cmnd_list[i])
> -			dma_pool_free(ioa_cfg->ipr_cmd_pool,
> -				      ioa_cfg->ipr_cmnd_list[i],
> -				      ioa_cfg->ipr_cmnd_list_dma[i]);
> +	if (ioa_cfg->ipr_cmnd_list) {
> +		for (i = 0; i < IPR_NUM_CMD_BLKS; i++) {
> +			if (ioa_cfg->ipr_cmnd_list[i])
> +				dma_pool_free(ioa_cfg->ipr_cmd_pool,
> +					      ioa_cfg->ipr_cmnd_list[i],
> +					      ioa_cfg->ipr_cmnd_list_dma[i]);
>
> -		ioa_cfg->ipr_cmnd_list[i] = NULL;
> +			ioa_cfg->ipr_cmnd_list[i] = NULL;
> +		}
>  	}
>
>  	if (ioa_cfg->ipr_cmd_pool)
> _


