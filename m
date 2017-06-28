From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: set host_byte to DID_REQUEUE when ocs =
 OCS_ABORTED
Date: Wed, 28 Jun 2017 16:42:36 -0700
Message-ID: <7bb81ce8005715d416539754246b2989@codeaurora.org>
References: <20170624102722.4050-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34002 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdF1Xmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2017 19:42:38 -0400
In-Reply-To: <20170624102722.4050-1-zangleigang@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2017-06-24 03:27, Zang Leigang wrote:
> Host set ocs to OCS_ABORTED when clear a doorbell in err handler.

OCS field is valid after host controller has cleared the corresponding 
doorbell (UTRLDBR) bit to zero. And here HW would be clearing the 
doorbell bit, not the SW. So I am not sure what do you mean in sentence 
above? Can you please elaborate more on this?

> Then scsi_decide_disposition return SUCCESS. This may cause some
> filesystem panic because a FAILED REQUESET. Requeue and complete is
> better.

Why do you think retrying this HW aborted request will succeed next 
time? Are we going to fix some request parameters before retrying? If 
not, it will most likely fail again.


> 
> Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ffe8d8608818..e050dcea1bea 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4545,8 +4545,6 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
> struct ufshcd_lrb *lrbp)
>  		}
>  		break;
>  	case OCS_ABORTED:
> -		result |= DID_ABORT << 16;
> -		break;
>  	case OCS_INVALID_COMMAND_STATUS:
>  		result |= DID_REQUEUE << 16;
>  		break;

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
