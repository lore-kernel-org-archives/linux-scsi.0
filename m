From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v3 12/12] scsi/ufs: qcom: Don't free resource-managed
 kmalloc element
Date: Mon, 31 Oct 2016 14:14:32 -0700
Message-ID: <569766034ef33abd18048929f6e42df6@codeaurora.org>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
 <1477772534-14170-13-git-send-email-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38430 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S946965AbcJaVOe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Oct 2016 17:14:34 -0400
In-Reply-To: <1477772534-14170-13-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, sboyd@codeaurora.org, ygardi@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org

On 2016-10-29 13:22, Vivek Gautam wrote:
> Host is allocated by managed kmalloc (devm_kmalloc). The
> memory allocated with this function is automatically
> freed on driver detach.
> So, no need to make an exclusive free call over it.
> 
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
> ---
> 
> New patch added in v3 of this cleanup series.
> 
>  drivers/scsi/ufs/ufs-qcom.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 9590df5..60a38b1 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1263,7 +1263,6 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  out_unregister_bus:
>  	phy_exit(host->generic_phy);
>  out_host_free:
> -	devm_kfree(dev, host);
>  	ufshcd_set_variant(hba, NULL);
>  out:
>  	return err;

LGTM, Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
