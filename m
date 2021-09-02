Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E14C83026
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 16:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6208160FE6
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 16:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242304AbhIBQya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 12:54:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:49269 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231368AbhIBQy3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Sep 2021 12:54:29 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1630601611; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=jS2JS4srs1sXC1rOnpAyNwkxNXU/GrZr6bVYsR5lmiU=; b=N36cTQFh4o8tmy4P/oqn3OQy97yDSnx/PSUpUxVphCjN2j6pLRcVm9FfcwnVLuxkx2bw7S8U
 XiIsdVbpajsF+nazjhsMqWEwsn+93HABfa8pw073nCUC6w64DaKrXcOnDrdhNDhd0b5N1K8V
 f4l2QAJBhnf3jyo/Hl3gmYQBGuo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 61310185e0fcecca196b6d06 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 02 Sep 2021 16:53:25
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 74260C43616; Thu,  2 Sep 2021 16:53:24 +0000 (UTC)
Received: from [192.168.1.8] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 929BDC4338F;
        Thu,  2 Sep 2021 16:53:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 929BDC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: [PATCH 1/3] scsi: ufs: Fix error handler clear ua deadlock
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <d5f5552d-257a-62ee-f0a3-55c00959e63b@intel.com>
 <20210902101818.4132-1-adrian.hunter@intel.com>
 <20210902101818.4132-2-adrian.hunter@intel.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <94d26736-b56a-4946-9d45-6ee4a7540a3b@codeaurora.org>
Date:   Thu, 2 Sep 2021 09:53:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210902101818.4132-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/2/2021 3:18 AM, Adrian Hunter wrote:
> There is no guarantee to be able to enter the queue if requests are
> blocked. That is because freezing the queue will block entry to the
> queue, but freezing also waits for outstanding requests which can make
> no progress while the queue is blocked.
> 
> That situation can happen when the error handler issues requests to
> clear unit attention condition. The deadlock is very unlikely, so the
> error handler can be expected to clear ua at some point anyway, so the
> simple solution is not to wait to enter the queue.
> 
> Additionally, note that the RPMB queue might be not be entered because
> it is runtime suspended, but in that case ua will be cleared at RPMB
> runtime resume.
> 
> Fixes: aa53f580e67b49 ("scsi: ufs: Minor adjustments to error handling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---

Looks good to me.
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufshcd.c | 33 +++++++++++++++++++--------------
>   1 file changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 67889d74761c..52fb059efa77 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -224,7 +224,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba);
>   static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
>   static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
>   static void ufshcd_hba_exit(struct ufs_hba *hba);
> -static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
> +static int ufshcd_clear_ua_wluns(struct ufs_hba *hba, bool nowait);
>   static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
>   static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
>   static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
> @@ -4110,7 +4110,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
>   		dev_err(hba->dev, "%s: link recovery failed, err %d",
>   			__func__, ret);
>   	else
> -		ufshcd_clear_ua_wluns(hba);
> +		ufshcd_clear_ua_wluns(hba, false);
>   
>   	return ret;
>   }
> @@ -5974,7 +5974,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>   	ufshcd_release(hba);
>   	if (ufshcd_is_clkscaling_supported(hba))
>   		ufshcd_clk_scaling_suspend(hba, false);
> -	ufshcd_clear_ua_wluns(hba);
> +	ufshcd_clear_ua_wluns(hba, true);
>   	ufshcd_rpm_put(hba);
>   }
>   
> @@ -7907,7 +7907,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>   	if (ret)
>   		goto out;
>   
> -	ufshcd_clear_ua_wluns(hba);
> +	ufshcd_clear_ua_wluns(hba, false);
>   
>   	/* Initialize devfreq after UFS device is detected */
>   	if (ufshcd_is_clkscaling_supported(hba)) {
> @@ -7943,7 +7943,8 @@ static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
>   }
>   
>   static int
> -ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
> +ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev,
> +			   bool nowait)
>   {
>   	/*
>   	 * Some UFS devices clear unit attention condition only if the sense
> @@ -7951,6 +7952,7 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
>   	 */
>   	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, UFS_SENSE_SIZE, 0};
>   	struct scsi_request *rq;
> +	blk_mq_req_flags_t flags;
>   	struct request *req;
>   	char *buffer;
>   	int ret;
> @@ -7959,8 +7961,8 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
>   	if (!buffer)
>   		return -ENOMEM;
>   
> -	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN,
> -			      /*flags=*/BLK_MQ_REQ_PM);
> +	flags = BLK_MQ_REQ_PM | (nowait ? BLK_MQ_REQ_NOWAIT : 0);
> +	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN, flags);
>   	if (IS_ERR(req)) {
>   		ret = PTR_ERR(req);
>   		goto out_free;
> @@ -7990,7 +7992,7 @@ ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
>   	return ret;
>   }
>   
> -static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
> +static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun, bool nowait)
>   {
>   	struct scsi_device *sdp;
>   	unsigned long flags;
> @@ -8016,7 +8018,10 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
>   	if (ret)
>   		goto out_err;
>   
> -	ret = ufshcd_request_sense_async(hba, sdp);
> +	ret = ufshcd_request_sense_async(hba, sdp, nowait);
> +	if (nowait && ret && wlun == UFS_UPIU_RPMB_WLUN &&
> +	    pm_runtime_suspended(&sdp->sdev_gendev))
> +		ret = 0; /* RPMB runtime resume will clear UAC */
>   	scsi_device_put(sdp);
>   out_err:
>   	if (ret)
> @@ -8025,16 +8030,16 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
>   	return ret;
>   }
>   
> -static int ufshcd_clear_ua_wluns(struct ufs_hba *hba)
> +static int ufshcd_clear_ua_wluns(struct ufs_hba *hba, bool nowait)
>   {
>   	int ret = 0;
>   
>   	if (!hba->wlun_dev_clr_ua)
>   		goto out;
>   
> -	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN);
> +	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN, nowait);
>   	if (!ret)
> -		ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN);
> +		ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN, nowait);
>   	if (!ret)
>   		hba->wlun_dev_clr_ua = false;
>   out:
> @@ -8656,7 +8661,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
>   	 */
>   	hba->host->eh_noresume = 1;
>   	if (hba->wlun_dev_clr_ua)
> -		ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN);
> +		ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN, false);
>   
>   	cmd[4] = pwr_mode << 4;
>   
> @@ -9825,7 +9830,7 @@ static inline int ufshcd_clear_rpmb_uac(struct ufs_hba *hba)
>   
>   	if (!hba->wlun_rpmb_clr_ua)
>   		return 0;
> -	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN);
> +	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN, false);
>   	if (!ret)
>   		hba->wlun_rpmb_clr_ua = 0;
>   	return ret;
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
