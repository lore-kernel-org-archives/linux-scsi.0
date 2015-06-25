From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/1] ipr: Fix invalid array indexing for HRRQ
Date: Thu, 25 Jun 2015 16:36:32 +0200
Message-ID: <558C11F0.6020505@suse.cz>
References: <201506251344.t5PDiZLv025988@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33061 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbbFYOgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2015 10:36:35 -0400
In-Reply-To: <201506251344.t5PDiZLv025988@d03av03.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, stable@vger.kernel.org

On 06/25/2015, 03:44 PM, Brian King wrote:
> Fixes another signed / unsigned array indexing bug in the ipr driver.

Could you be more specific? Specifically, I fail to see why you do +1
twice now.

> --- linux/drivers/scsi/ipr.c~ipr_hrrq_index_fix	2015-06-23 11:43:18.151741523 -0500
> +++ linux-bjking1/drivers/scsi/ipr.c	2015-06-23 11:43:18.157741435 -0500
> @@ -1052,10 +1052,15 @@ static void ipr_send_blocking_cmd(struct
>  
>  static int ipr_get_hrrq_index(struct ipr_ioa_cfg *ioa_cfg)
>  {
> +	unsigned int hrrq;
> +
>  	if (ioa_cfg->hrrq_num == 1)
> -		return 0;
> -	else
> -		return (atomic_add_return(1, &ioa_cfg->hrrq_index) % (ioa_cfg->hrrq_num - 1)) + 1;
> +		hrrq = 0;
> +	else {
> +		hrrq = atomic_add_return(1, &ioa_cfg->hrrq_index);
> +		hrrq = ((hrrq + 1) % (ioa_cfg->hrrq_num - 1)) + 1;
> +	}
> +	return hrrq;

thanks,
-- 
js
suse labs
