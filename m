From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ipr: Read buffer overflow
Date: Fri, 07 Aug 2009 17:16:11 -0500
Message-ID: <4A7CA7AB.4010103@linux.vnet.ibm.com>
References: <4A7CA52C.9030407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52979 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZHGWQR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 18:16:17 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.14.3/8.13.1) with ESMTP id n77MEYPj014453
	for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2009 16:14:34 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n77MGDX4262452
	for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2009 16:16:13 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n77MGDxM008881
	for <linux-scsi@vger.kernel.org>; Fri, 7 Aug 2009 16:16:13 -0600
In-Reply-To: <4A7CA52C.9030407@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Roel Kluin wrote:
> If `sglist->num_dma_sg' is zero we write ioadl[-1]
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is it possible for sglist->num_dma_sg to be 0?

No. Its not possible. The code in ipr_update_ioa_ucode ensures this.

Thanks,

Brian

> 
> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
> index 5f04550..736ad07 100644
> --- a/drivers/scsi/ipr.c
> +++ b/drivers/scsi/ipr.c
> @@ -3004,8 +3004,9 @@ static void ipr_build_ucode_ioadl(struct ipr_cmnd *ipr_cmd,
>  			cpu_to_be32(sg_dma_address(&scatterlist[i]));
>  	}
> 
> -	ioadl[i-1].flags_and_data_len |=
> -		cpu_to_be32(IPR_IOADL_FLAGS_LAST);
> +	if (i != 0)
> +		ioadl[i-1].flags_and_data_len |=
> +			cpu_to_be32(IPR_IOADL_FLAGS_LAST);
>  }
> 
>  /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


