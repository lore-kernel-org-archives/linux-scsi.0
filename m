From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] ipr: Avoid target_destroy accessing memory after it
 was freed
Date: Thu, 09 May 2013 12:32:51 -0400
Message-ID: <20130509123251.Horde.QCkcE5ir309Ri8_zg1zUKrA@imap.linux.ibm.com>
References: <20130314185222.994529433@linux.vnet.ibm.com>
 <20130314185803.484999352@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:46612 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3EIQc7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 May 2013 12:32:59 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Thu, 9 May 2013 12:32:58 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 4EB846E803C
	for <linux-scsi@vger.kernel.org>; Thu,  9 May 2013 12:32:49 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r49GWqms304928
	for <linux-scsi@vger.kernel.org>; Thu, 9 May 2013 12:32:52 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r49GWpq0026345
	for <linux-scsi@vger.kernel.org>; Thu, 9 May 2013 12:32:52 -0400
In-Reply-To: <20130314185803.484999352@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, klebers@linux.vnet.ibm.com

Hi James,

Patch 1 and Patch 2 merged into next-scsi and 3.9.0 on 4/6/13 but  
Patch3 is missed in both of next-scsi
and 3.9.0 tree. Can you merge Patch 3 or I need to re-send the Patch3?

Thanks for your help!
Wendy

Quoting wenxiong@linux.vnet.ibm.com:

> Defined target_ids,array_ids and vsets_ids as unsigned long to avoid
> target_destroy accessing memory after it was freed.
>
>
> Signed-off-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ipr.c |   16 ----------------
>  drivers/scsi/ipr.h |    6 +++---
>  2 files changed, 3 insertions(+), 19 deletions(-)
>
> Index: b/drivers/scsi/ipr.c
> ===================================================================
> --- a/drivers/scsi/ipr.c	2013-03-14 13:16:03.398966326 -0500
> +++ b/drivers/scsi/ipr.c	2013-03-14 13:17:04.828022126 -0500
> @@ -8972,19 +8972,6 @@ static int ipr_alloc_mem(struct ipr_ioa_
>  	if (!ioa_cfg->res_entries)
>  		goto out;
>
> -	if (ioa_cfg->sis64) {
> -		ioa_cfg->target_ids = kzalloc(sizeof(unsigned long) *
> -					      BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
> -		ioa_cfg->array_ids = kzalloc(sizeof(unsigned long) *
> -					     BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
> -		ioa_cfg->vset_ids = kzalloc(sizeof(unsigned long) *
> -					    BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
> -
> -		if (!ioa_cfg->target_ids || !ioa_cfg->array_ids
> -			|| !ioa_cfg->vset_ids)
> -			goto out_free_res_entries;
> -	}
> -
>  	for (i = 0; i < ioa_cfg->max_devs_supported; i++) {
>  		list_add_tail(&ioa_cfg->res_entries[i].queue, &ioa_cfg->free_res_q);
>  		ioa_cfg->res_entries[i].ioa_cfg = ioa_cfg;
> @@ -9081,9 +9068,6 @@ out_free_vpd_cbs:
>  			    ioa_cfg->vpd_cbs, ioa_cfg->vpd_cbs_dma);
>  out_free_res_entries:
>  	kfree(ioa_cfg->res_entries);
> -	kfree(ioa_cfg->target_ids);
> -	kfree(ioa_cfg->array_ids);
> -	kfree(ioa_cfg->vset_ids);
>  	goto out;
>  }
>
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2013-03-14 11:49:21.408965542 -0500
> +++ b/drivers/scsi/ipr.h	2013-03-14 13:16:20.131452448 -0500
> @@ -1440,9 +1440,9 @@ struct ipr_ioa_cfg {
>  	/*
>  	 * Bitmaps for SIS64 generated target values
>  	 */
> -	unsigned long *target_ids;
> -	unsigned long *array_ids;
> -	unsigned long *vset_ids;
> +	unsigned long target_ids[BITS_TO_LONGS(IPR_MAX_SIS64_DEVS)];
> +	unsigned long array_ids[BITS_TO_LONGS(IPR_MAX_SIS64_DEVS)];
> +	unsigned long vset_ids[BITS_TO_LONGS(IPR_MAX_SIS64_DEVS)];
>
>  	u16 type; /* CCIN of the card */
>
>
> --



