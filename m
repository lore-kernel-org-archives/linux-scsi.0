Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B2DC433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 23:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DA7B61164
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 23:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhEFX5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 19:57:24 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:38323 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233079AbhEFX5Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 May 2021 19:57:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620345385; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=oh8xZVGuqLycTwJErYqujO7L5uqwXmnARXiCoVD1V5k=;
 b=uC586Ge4ndh+xgpM4oPKNXTeIcMjl5AeKnQE17n3l2pWsEHuP/0kGslOhxnBBoRVu/dQHZGG
 W/zpEnYsuXaYw6IcW2vNGX3aWFopq6XSMhAr7uNrvXOhrEJLR9HCfsLQUwGT+j8/3ma8AXO0
 nzxSYUm1uFh/S8rRdRlJFOSRJk0=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60948221c06dd10a2df1a887 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 06 May 2021 23:56:17
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BA85FC43143; Thu,  6 May 2021 23:56:16 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2997CC4338A;
        Thu,  6 May 2021 23:56:14 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 May 2021 07:56:14 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: Re: [PATCH 099/117] ufs: Remove a local variable
In-Reply-To: <20210420021402.27678-9-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-9-bvanassche@acm.org>
Message-ID: <e4d910fc3915e6952439d7eebe4eef8c@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-20 10:13, Bart Van Assche wrote:
> A later patch will introduce a type with the name 'scsi_status'. Remove
> a local variable with the same name to prevent confusion. This patch
> does not change any functionality.
> 
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fa596cf66c23..0c2c18f2acf3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4934,7 +4934,6 @@ static inline int
>  ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb 
> *lrbp)
>  {
>  	int result = 0;
> -	int scsi_status;
>  	int ocs;
> 
>  	/* overall command status of utrd */
> @@ -4952,18 +4951,10 @@ ufshcd_transfer_rsp_status(struct ufs_hba
> *hba, struct ufshcd_lrb *lrbp)
>  		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_set(0, 0);
>  		switch (result) {
>  		case UPIU_TRANSACTION_RESPONSE:
> -			/*
> -			 * get the response UPIU result to extract
> -			 * the SCSI command status
> -			 */
> -			result = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr);
> -
> -			/*
> -			 * get the result based on SCSI status response
> -			 * to notify the SCSI midlayer of the command status
> -			 */
> -			scsi_status = result & MASK_SCSI_STATUS;
> -			result = ufshcd_scsi_cmd_status(lrbp, scsi_status);
> +			/* Propagate the SCSI status to the SCSI midlayer. */
> +			result = ufshcd_scsi_cmd_status(lrbp,
> +				ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) &
> +				MASK_SCSI_STATUS);
> 
>  			/*
>  			 * Currently we are only supporting BKOPs exception

Reviewed-by: Can Guo <cang@codeaurora.org>
