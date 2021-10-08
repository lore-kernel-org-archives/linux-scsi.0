Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4658AC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 16:41:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2324560F9C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 16:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhJHQmy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 12:42:54 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:52023 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhJHQmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Oct 2021 12:42:54 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633711259; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=kHfDDgR5llcD5oBuqF26xeoc++cr4Itq9Lj0qxdQCdY=; b=YUoD+1c4qQ862bHrx179tS+pC7fKnGeceikEI9fBRjJZn0fTMEgxcMHAFQWGv/MchQhixkIN
 IA9z28SrORjcEb+YY6v7M1Gv4EJztQMZp2sWkIPoYDRg6iNCVayBOQFEUpUStnyUNQoFAGy7
 JkNIkdfv84gYPD7ncY8pPwNbQ5Y=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 61607494ab9da96e647d5f03 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 08 Oct 2021 16:40:52
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2DCE8C4361C; Fri,  8 Oct 2021 16:40:51 +0000 (UTC)
Received: from [10.71.115.70] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A992FC4338F;
        Fri,  8 Oct 2021 16:40:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org A992FC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <374d943a-dadf-51e0-ebf1-a3d3db4c4e0c@codeaurora.org>
Date:   Fri, 8 Oct 2021 09:40:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH V2] scsi: ufs: core: Fix synchronization between
 scsi_unjam_host() and ufshcd_queuecommand()
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20211008084048.257498-1-adrian.hunter@intel.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <20211008084048.257498-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/8/2021 1:40 AM, Adrian Hunter wrote:
> The SCSI error handler calls scsi_unjam_host() which can call the queue
> function ufshcd_queuecommand() indirectly. The error handler changes the
> state to UFSHCD_STATE_RESET while running, but error interrupts that
> happen while the error handler is running could change the state to
> UFSHCD_STATE_EH_SCHEDULED_NON_FATAL which would allow requests to go
> through ufshcd_queuecommand() even though the error handler is running.
> Block that hole by checking whether the error handler is in progress.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---

LGTM.
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

> 
> Changes in V2:
> 
> 	Add comment
> 
>   drivers/scsi/ufs/ufshcd.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f34227add27d..29d202207b18 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2688,7 +2688,19 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   
>   	switch (hba->ufshcd_state) {
>   	case UFSHCD_STATE_OPERATIONAL:
> +		break;
>   	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
> +		/*
> +		 * SCSI error handler can call ->queuecommand() while UFS error
> +		 * handler is in progress. Error interrupts could change the
> +		 * state from UFSHCD_STATE_RESET to
> +		 * UFSHCD_STATE_EH_SCHEDULED_NON_FATAL. Prevent requests
> +		 * being issued in that case.
> +		 */
> +		if (ufshcd_eh_in_progress(hba)) {
> +			err = SCSI_MLQUEUE_HOST_BUSY;
> +			goto out;
> +		}
>   		break;
>   	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
>   		/*
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
