Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC906C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 06:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8E8823127
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 06:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgLVGOo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 01:14:44 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:44418 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgLVGOo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 01:14:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608617663; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=/q3dGheHBelER20ImuCZIS2a3WdkHlIdCKxbC6QSlUk=;
 b=smM6JIZaHEREaieb9jJLpH+seLVang5mnckEK+YzLwv3t+BtJaTOCa8oEFJbsG98fi9fWfvu
 P1GdTRwchMmm7Z/V63eLj/I1W2RUGwXXhaTabcO3wiutUdj82LaEXd7jeUsLsWcCL3e/UAZS
 cl5RYSx4Qh81Ki1HYY9V+kbZix0=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5fe18ebfcfd94dd328da9876 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 06:14:23
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7FE26C433ED; Tue, 22 Dec 2020 06:14:23 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 88C8DC433CA;
        Tue, 22 Dec 2020 06:14:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 22 Dec 2020 14:14:21 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 6/7] scsi: ufs: Cleanup WB buffer flush toggle
 implementation
In-Reply-To: <20201215230519.15158-7-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
 <20201215230519.15158-7-huobean@gmail.com>
Message-ID: <e98421b3b26e22941db25e3a31e500cd@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-16 07:05, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Delete ufshcd_wb_buf_flush_enable() and ufshcd_wb_buf_flush_disable(),
> move the implementation into ufshcd_wb_toggle_flush().
> 

Reviewed-by: Can Guo <cang@codeaurora.org>

> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 66 +++++++++++++--------------------------
>  1 file changed, 21 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 466a85051d54..ba8298f0d017 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -244,10 +244,8 @@ static int ufshcd_setup_vreg(struct ufs_hba *hba, 
> bool on);
>  static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
>  					 struct ufs_vreg *vreg);
>  static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
> -static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
> -static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
>  static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool 
> set);
> -static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool 
> enable);
> +static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool 
> enable);
>  static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
>  static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
> 
> @@ -5398,60 +5396,38 @@ static int
> ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
>  				index, NULL);
>  }
> 
> -static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool 
> enable)
> -{
> -	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
> -		return;
> -
> -	if (enable)
> -		ufshcd_wb_buf_flush_enable(hba);
> -	else
> -		ufshcd_wb_buf_flush_disable(hba);
> -
> -}
> -
> -static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba)
> +static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool 
> enable)
>  {
>  	int ret;
>  	u8 index;
> +	enum query_opcode opcode;
> 
> -	if (!ufshcd_is_wb_allowed(hba) || hba->dev_info.wb_buf_flush_enabled)
> +	if (hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL)
>  		return 0;
> 
> -	index = ufshcd_wb_get_query_index(hba);
> -	ret = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> -				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN,
> -				      index, NULL);
> -	if (ret)
> -		dev_err(hba->dev, "%s WB - buf flush enable failed %d\n",
> -			__func__, ret);
> -	else
> -		hba->dev_info.wb_buf_flush_enabled = true;
> -
> -	dev_dbg(hba->dev, "WB - Flush enabled: %d\n", ret);
> -	return ret;
> -}
> -
> -static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba)
> -{
> -	int ret;
> -	u8 index;
> -
> -	if (!ufshcd_is_wb_allowed(hba) || 
> !hba->dev_info.wb_buf_flush_enabled)
> +	if (!ufshcd_is_wb_allowed(hba) ||
> +	    hba->dev_info.wb_buf_flush_enabled == enable)
>  		return 0;
> 
> +	if (enable)
> +		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
> +	else
> +		opcode = UPIU_QUERY_OPCODE_CLEAR_FLAG;
> +
>  	index = ufshcd_wb_get_query_index(hba);
> -	ret = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
> -				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN,
> -				      index, NULL);
> +	ret = ufshcd_query_flag_retry(hba, opcode,
> +				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, index,
> +				      NULL);
>  	if (ret) {
> -		dev_warn(hba->dev, "%s: WB - buf flush disable failed %d\n",
> -			 __func__, ret);
> -	} else {
> -		hba->dev_info.wb_buf_flush_enabled = false;
> -		dev_dbg(hba->dev, "WB - Flush disabled: %d\n", ret);
> +		dev_err(hba->dev, "%s WB-Buf Flush %s failed %d\n", __func__,
> +			enable ? "enable" : "disable", ret);
> +		goto out;
>  	}
> 
> +	hba->dev_info.wb_buf_flush_enabled = enable;
> +
> +	dev_dbg(hba->dev, "WB-Buf Flush %s\n", enable ? "enabled" : 
> "disabled");
> +out:
>  	return ret;
>  }
