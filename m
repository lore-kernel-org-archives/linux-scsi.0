From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] Invalid request_limit unnoticed?
Date: Wed, 06 May 2009 16:24:18 -0500
Message-ID: <4A020002.6020109@linux.vnet.ibm.com>
References: <49FCA9BE.3030408@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:57540 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761002AbZEFVYZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2009 17:24:25 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n46LLmmG025565
	for <linux-scsi@vger.kernel.org>; Wed, 6 May 2009 15:21:48 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n46LOPYg239010
	for <linux-scsi@vger.kernel.org>; Wed, 6 May 2009 15:24:25 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n46LONji028827
	for <linux-scsi@vger.kernel.org>; Wed, 6 May 2009 15:24:25 -0600
In-Reply-To: <49FCA9BE.3030408@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Robert C Jennings <rcjenn@us.ibm.com>, Santiago Leon <sleon@ec.ibm.com>

Acked by: Brian King <brking@linux.vnet.ibm.com>

Roel Kluin wrote:
> Remove redundant test on unsigned.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com> 
> ---
> Maybe a different test is required? 
> 
> To see that it is unsigned:
> 
> git grep -E -n "(req_lim_delta|__be32;$)"
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
> index c9aa761..8d3925f 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -910,9 +910,6 @@ static void login_rsp(struct srp_event_struct *evt_struct)
> 
>  	dev_info(hostdata->dev, "SRP_LOGIN succeeded\n");
> 
> -	if (evt_struct->xfer_iu->srp.login_rsp.req_lim_delta < 0)
> -		dev_err(hostdata->dev, "Invalid request_limit.\n");
> -
>  	/* Now we know what the real request-limit is.
>  	 * This value is set rather than added to request_limit because
>  	 * request_limit could have been set to -1 by this client.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


