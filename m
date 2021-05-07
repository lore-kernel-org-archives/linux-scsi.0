Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2A9C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 00:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE6E261104
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 00:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhEGALH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 20:11:07 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:58460 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbhEGALD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 20:11:03 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620346204; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=y50Tp06sgVT325DJvVR0ytlS5WUR+7/cO6FOhNpeAB8=;
 b=Nmz0O+eZsnIaXBpF15Dsc0xiX4EXY8hx/mP8RVMlxDUJXNZslAlOzq4/BGLafyBes9Hbx8sF
 4dbo6rSNU18IKoN9uWtLtXmdA1wAI+5dLwAVzHmXomlZG9dlbM9xh/41CUahqa/vv43cbuK5
 9Io/F0UavjmcbCZlWPCip+zJ9uI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60948549c06dd10a2dfb0d15 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 07 May 2021 00:09:45
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 85FD9C43145; Fri,  7 May 2021 00:09:44 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8D3BFC433D3;
        Fri,  7 May 2021 00:09:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 May 2021 08:09:42 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>, Yue Hu <huyue2@yulong.com>
Subject: Re: [PATCH 102/117] ufs: Convert to the scsi_status union
In-Reply-To: <20210420021402.27678-12-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-12-bvanassche@acm.org>
Message-ID: <aa572642ad49f5c3642b026b97e8a58d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-04-20 10:13, Bart Van Assche wrote:
> An explanation of the purpose of this patch is available in the patch
> "scsi: Introduce the scsi_status union".
> 
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Yue Hu <huyue2@yulong.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufs_bsg.c |  2 +-
>  drivers/scsi/ufs/ufshcd.c  | 27 +++++++++++++++------------
>  2 files changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
> index 5b2bc1a6f922..4dcc09136a50 100644
> --- a/drivers/scsi/ufs/ufs_bsg.c
> +++ b/drivers/scsi/ufs/ufs_bsg.c
> @@ -152,7 +152,7 @@ static int ufs_bsg_request(struct bsg_job *job)
>  	kfree(desc_buff);
> 
>  out:
> -	bsg_reply->result = ret;
> +	bsg_reply->status.combined = ret;
>  	job->reply_len = sizeof(struct ufs_bsg_reply);
>  	/* complete the job here only if no error */
>  	if (ret == 0)
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d966d80838fb..cec555d3fcd7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4933,7 +4933,7 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp,
> enum sam_status scsi_status)
>  static inline int
>  ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb 
> *lrbp)
>  {
> -	int result = 0;
> +	union scsi_status result;
>  	int ocs;
> 
>  	/* overall command status of utrd */
> @@ -4951,7 +4951,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  		switch (ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr)) {
>  		case UPIU_TRANSACTION_RESPONSE:
>  			/* Propagate the SCSI status to the SCSI midlayer. */
> -			result = ufshcd_scsi_cmd_status(lrbp,
> +			result.combined = ufshcd_scsi_cmd_status(lrbp,
>  				ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) &
>  				MASK_SCSI_STATUS);
> 
> @@ -4981,23 +4981,23 @@ ufshcd_transfer_rsp_status(struct ufs_hba
> *hba, struct ufshcd_lrb *lrbp)
>  			break;
>  		case UPIU_TRANSACTION_REJECT_UPIU:
>  			/* TODO: handle Reject UPIU Response */
> -			result = DID_ERROR << 16;
> +			result.combined = DID_ERROR << 16;
>  			dev_err(hba->dev,
>  				"Reject UPIU not fully implemented\n");
>  			break;
>  		default:
>  			dev_err(hba->dev,
>  				"Unexpected request response code = %x\n",
> -				result);
> -			result = DID_ERROR << 16;
> +				result.combined);
> +			result.combined = DID_ERROR << 16;
>  			break;
>  		}
>  		break;
>  	case OCS_ABORTED:
> -		result |= DID_ABORT << 16;
> +		result.combined |= DID_ABORT << 16;
>  		break;
>  	case OCS_INVALID_COMMAND_STATUS:
> -		result |= DID_REQUEUE << 16;
> +		result.combined |= DID_REQUEUE << 16;
>  		break;
>  	case OCS_INVALID_CMD_TABLE_ATTR:
>  	case OCS_INVALID_PRDT_ATTR:
> @@ -5009,7 +5009,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  	case OCS_INVALID_CRYPTO_CONFIG:
>  	case OCS_GENERAL_CRYPTO_ERROR:
>  	default:
> -		result |= DID_ERROR << 16;
> +		result.combined |= DID_ERROR << 16;
>  		dev_err(hba->dev,
>  				"OCS error from controller = %x for tag %d\n",
>  				ocs, lrbp->task_tag);
> @@ -5021,7 +5021,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  	if ((host_byte(result) != DID_OK) &&
>  	    (host_byte(result) != DID_REQUEUE) && !hba->silence_err_logs)
>  		ufshcd_print_trs(hba, 1 << lrbp->task_tag, true);
> -	return result;
> +	return result.combined;
>  }
> 
>  /**
> @@ -5083,7 +5083,7 @@ static void __ufshcd_transfer_req_compl(struct
> ufs_hba *hba,
>  			ufshcd_add_command_trace(hba, index, UFS_CMD_COMP);
>  			result = ufshcd_transfer_rsp_status(hba, lrbp);
>  			scsi_dma_unmap(cmd);
> -			cmd->result = result;
> +			cmd->status.combined = result;
>  			/* Mark completed command as NULL in LRB */
>  			lrbp->cmd = NULL;
>  			/* Do not touch lrbp after scsi done */
> @@ -8437,6 +8437,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba 
> *hba,
>  	struct scsi_sense_hdr sshdr;
>  	struct scsi_device *sdp;
>  	unsigned long flags;
> +	union scsi_status start_stop_res;
>  	int ret;
> 
>  	spin_lock_irqsave(hba->host->host_lock, flags);
> @@ -8471,13 +8472,15 @@ static int ufshcd_set_dev_pwr_mode(struct 
> ufs_hba *hba,
>  	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
>  	 * already suspended childs.
>  	 */
> -	ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> +	start_stop_res.combined =
> +		scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
>  			START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
> +	ret = start_stop_res.combined;
>  	if (ret) {
>  		sdev_printk(KERN_WARNING, sdp,
>  			    "START_STOP failed for power mode: %d, result %x\n",
>  			    pwr_mode, ret);
> -		if (driver_byte(ret) == DRIVER_SENSE)
> +		if (driver_byte(start_stop_res) == DRIVER_SENSE)
>  			scsi_print_sense_hdr(sdp, NULL, &sshdr);
>  	}

Thanks for the change, do you miss ufshcd_send_request_sense()?

Regards,
Can Guo.
