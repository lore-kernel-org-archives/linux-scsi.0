Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DCBCC2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 18:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 186A82075D
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 18:07:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="A/XPJh8Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390787AbgAXSHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 13:07:12 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:44151 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388823AbgAXSHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Jan 2020 13:07:12 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579889231; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=9+wXY3l9oUGzzH+9Q9rfM50WnovWwoUmCINjjGPM7L0=; b=A/XPJh8ZOFZoSWzFvhw5qATFEalBCXRofn6meDjB0OV+aF99518RW07pZq/nR0/TlpggYAPQ
 EsAVQMeo1OgIhfdt/jbvUz8U1PnEpa87kCRE1NNejPDILJRh4UDFrHFj5jzoFUJrFB15DIsd
 EsM68IqjVrmdQsoIHGo3O6oCSLs=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e2b323f.7f0d81001a08-smtp-out-n02;
 Fri, 24 Jan 2020 18:06:55 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A3258C433CB; Fri, 24 Jan 2020 18:06:54 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 76B8CC43383;
        Fri, 24 Jan 2020 18:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 76B8CC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v4 6/8] scsi: ufs: Add dev ref clock gating wait time
 support
To:     Can Guo <cang@codeaurora.org>, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-7-git-send-email-cang@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <328f4768-e986-8566-4929-17420f9dbbce@codeaurora.org>
Date:   Fri, 24 Jan 2020 10:06:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579764349-15578-7-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/22/2020 11:25 PM, Can Guo wrote:
> In UFS version 3.0, a newly added attribute bRefClkGatingWaitTime defines
> the minimum time for which the reference clock is required by device during
> transition to LS-MODE or HIBERN8 state. Make this change to reflect the new
> requirement by adding delays before turning off the clock.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

>   drivers/scsi/ufs/ufs.h    |  3 +++
>   drivers/scsi/ufs/ufshcd.c | 41 +++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 44 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 3327981..385bac8 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -168,6 +168,7 @@ enum attr_idn {
>   	QUERY_ATTR_IDN_FFU_STATUS		= 0x14,
>   	QUERY_ATTR_IDN_PSA_STATE		= 0x15,
>   	QUERY_ATTR_IDN_PSA_DATA_SIZE		= 0x16,
> +	QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME	= 0x17,
>   };
>   
>   /* Descriptor idn for Query requests */
> @@ -530,6 +531,8 @@ struct ufs_dev_info {
>   	bool f_power_on_wp_en;
>   	/* Keeps information if any of the LU is power on write protected */
>   	bool is_lu_power_on_wp;
> +	u16 spec_version;
> +	u32 clk_gating_wait_us;
>   };
>   
>   #define MAX_MODEL_LEN 16
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c316a07..1ee2187 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -91,6 +91,9 @@
>   /* default delay of autosuspend: 2000 ms */
>   #define RPM_AUTOSUSPEND_DELAY_MS 2000
>   
> +/* Default value of wait time before gating device ref clock */
> +#define UFSHCD_REF_CLK_GATING_WAIT_US 0xFF /* microsecs */
> +
>   #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
>   	({                                                              \
>   		int _ret;                                               \
> @@ -3357,6 +3360,37 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
>   				      param_offset, param_read_buf, param_size);
>   }
>   
> +static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
> +{
> +	int err = 0;
> +	u32 gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
> +
> +	if (hba->dev_info.spec_version >= 0x300) {
> +		err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> +				QUERY_ATTR_IDN_REF_CLK_GATING_WAIT_TIME, 0, 0,
> +				&gating_wait);
> +		if (err)
> +			dev_err(hba->dev, "Failed reading bRefClkGatingWait. err = %d, use default %uus\n",
> +					 err, gating_wait);
> +
> +		if (gating_wait == 0) {
> +			gating_wait = UFSHCD_REF_CLK_GATING_WAIT_US;
> +			dev_err(hba->dev, "Undefined ref clk gating wait time, use default %uus\n",
> +					 gating_wait);
> +		}
> +
> +		/*
> +		 * bRefClkGatingWaitTime defines the minimum time for which the
> +		 * reference clock is required by device during transition from
> +		 * HS-MODE to LS-MODE or HIBERN8 state. Give it more time to be
> +		 * on the safe side.
> +		 */
> +		hba->dev_info.clk_gating_wait_us = gating_wait + 50;
> +	}
> +
> +	return err;
> +}
> +
>   /**
>    * ufshcd_memory_alloc - allocate memory for host memory space data structures
>    * @hba: per adapter instance
> @@ -6628,6 +6662,10 @@ static int ufs_get_device_desc(struct ufs_hba *hba,
>   	dev_desc->wmanufacturerid = desc_buf[DEVICE_DESC_PARAM_MANF_ID] << 8 |
>   				     desc_buf[DEVICE_DESC_PARAM_MANF_ID + 1];
>   
> +	/* getting Specification Version in big endian format */
> +	hba->dev_info.spec_version = desc_buf[DEVICE_DESC_PARAM_SPEC_VER] << 8 |
> +				      desc_buf[DEVICE_DESC_PARAM_SPEC_VER + 1];
> +
>   	model_index = desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
>   	err = ufshcd_read_string_desc(hba, model_index,
>   				      &dev_desc->model, SD_ASCII_STD);
> @@ -7046,6 +7084,9 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>   
>   		/* clear any previous UFS device information */
>   		memset(&hba->dev_info, 0, sizeof(hba->dev_info));
> +
> +		ufshcd_get_ref_clk_gating_wait(hba);
> +
>   		if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
>   				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
>   			hba->dev_info.f_power_on_wp_en = flag;
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
