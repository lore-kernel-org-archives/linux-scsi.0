Return-Path: <SRS0=cGsx=6R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37D6C47257
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 01:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DE0420787
	for <linux-scsi@archiver.kernel.org>; Sun,  3 May 2020 01:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="vQyf2HRn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgECBvd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 21:51:33 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:21889 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726684AbgECBvc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2020 21:51:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588470692; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=hB4FBkH/8U2uRl5gbiUMkGwH/lIPHxjTpsf9dChF1Ic=;
 b=vQyf2HRnUi4Q9gahvBCSOFJPH204gGerS4dwIbh8fy4ZfYdOD+I1jD4CiCWY6QAgcpmu90VZ
 ulMUoMyok/zXB20EvrRIFqY+JwtXCaRdiTSQs4ezuMivdaYV0tHjmHGJ4nJb6b+NkOHEbfVb
 pI/S9X7TTwHBA4oZbLFQL7eD9ao=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eae239e.7fd91d01b928-smtp-out-n05;
 Sun, 03 May 2020 01:51:26 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E5F22C4478C; Sun,  3 May 2020 01:51:25 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 14C02C433D2;
        Sun,  3 May 2020 01:51:24 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 03 May 2020 09:51:24 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        asutoshd@codeaurora.org, beanhuo@micron.com,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v3 2/5] scsi: ufs: add "index" in parameter list of
 ufshcd_query_flag()
In-Reply-To: <20200501143835.26032-3-stanley.chu@mediatek.com>
References: <20200501143835.26032-1-stanley.chu@mediatek.com>
 <20200501143835.26032-3-stanley.chu@mediatek.com>
Message-ID: <e4528d5ec4cba4bfb50aeb8c1012672b@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-01 22:38, Stanley Chu wrote:
> For preparation of LU Dedicated buffer mode support on WriteBooster
> feature, "index" parameter shall be added and allowed to be specified
> by callers.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Reviewed-by: Bean Huo <beanhuo@micron.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufs-sysfs.c |  2 +-
>  drivers/scsi/ufs/ufshcd.c    | 28 +++++++++++++++-------------
>  drivers/scsi/ufs/ufshcd.h    |  2 +-
>  3 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
> b/drivers/scsi/ufs/ufs-sysfs.c
> index 93484408bc40..b86b6a40d7e6 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -631,7 +631,7 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  	struct ufs_hba *hba = dev_get_drvdata(dev);			\
>  	pm_runtime_get_sync(hba->dev);					\
>  	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
> -		QUERY_FLAG_IDN##_uname, &flag);				\
> +		QUERY_FLAG_IDN##_uname, 0, &flag);			\
>  	pm_runtime_put_sync(hba->dev);					\
>  	if (ret)							\
>  		return -EINVAL;						\
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c6668799d956..f23705379b7d 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2784,13 +2784,13 @@ static inline void ufshcd_init_query(struct
> ufs_hba *hba,
>  }
> 
>  static int ufshcd_query_flag_retry(struct ufs_hba *hba,
> -	enum query_opcode opcode, enum flag_idn idn, bool *flag_res)
> +	enum query_opcode opcode, enum flag_idn idn, u8 index, bool 
> *flag_res)
>  {
>  	int ret;
>  	int retries;
> 
>  	for (retries = 0; retries < QUERY_REQ_RETRIES; retries++) {
> -		ret = ufshcd_query_flag(hba, opcode, idn, flag_res);
> +		ret = ufshcd_query_flag(hba, opcode, idn, index, flag_res);
>  		if (ret)
>  			dev_dbg(hba->dev,
>  				"%s: failed with error %d, retries %d\n",
> @@ -2811,16 +2811,17 @@ static int ufshcd_query_flag_retry(struct 
> ufs_hba *hba,
>   * @hba: per-adapter instance
>   * @opcode: flag query to perform
>   * @idn: flag idn to access
> + * @index: flag index to access
>   * @flag_res: the flag value after the query request completes
>   *
>   * Returns 0 for success, non-zero in case of failure
>   */
>  int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
> -			enum flag_idn idn, bool *flag_res)
> +			enum flag_idn idn, u8 index, bool *flag_res)
>  {
>  	struct ufs_query_req *request = NULL;
>  	struct ufs_query_res *response = NULL;
> -	int err, index = 0, selector = 0;
> +	int err, selector = 0;
>  	int timeout = QUERY_REQ_TIMEOUT;
> 
>  	BUG_ON(!hba);
> @@ -4177,7 +4178,7 @@ static int ufshcd_complete_dev_init(struct 
> ufs_hba *hba)
>  	bool flag_res = true;
> 
>  	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> -		QUERY_FLAG_IDN_FDEVICEINIT, NULL);
> +		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL);
>  	if (err) {
>  		dev_err(hba->dev,
>  			"%s setting fDeviceInit flag failed with error %d\n",
> @@ -4188,7 +4189,7 @@ static int ufshcd_complete_dev_init(struct 
> ufs_hba *hba)
>  	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
>  	for (i = 0; i < 1000 && !err && flag_res; i++)
>  		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> -			QUERY_FLAG_IDN_FDEVICEINIT, &flag_res);
> +			QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
> 
>  	if (err)
>  		dev_err(hba->dev,
> @@ -5003,7 +5004,7 @@ static int ufshcd_enable_auto_bkops(struct 
> ufs_hba *hba)
>  		goto out;
> 
>  	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> -			QUERY_FLAG_IDN_BKOPS_EN, NULL);
> +			QUERY_FLAG_IDN_BKOPS_EN, 0, NULL);
>  	if (err) {
>  		dev_err(hba->dev, "%s: failed to enable bkops %d\n",
>  				__func__, err);
> @@ -5053,7 +5054,7 @@ static int ufshcd_disable_auto_bkops(struct 
> ufs_hba *hba)
>  	}
> 
>  	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
> -			QUERY_FLAG_IDN_BKOPS_EN, NULL);
> +			QUERY_FLAG_IDN_BKOPS_EN, 0, NULL);
>  	if (err) {
>  		dev_err(hba->dev, "%s: failed to disable bkops %d\n",
>  				__func__, err);
> @@ -5219,7 +5220,7 @@ static int ufshcd_wb_ctrl(struct ufs_hba *hba,
> bool enable)
>  		opcode = UPIU_QUERY_OPCODE_CLEAR_FLAG;
> 
>  	ret = ufshcd_query_flag_retry(hba, opcode,
> -				      QUERY_FLAG_IDN_WB_EN, NULL);
> +				      QUERY_FLAG_IDN_WB_EN, 0, NULL);
>  	if (ret) {
>  		dev_err(hba->dev, "%s write booster %s failed %d\n",
>  			__func__, enable ? "enable" : "disable", ret);
> @@ -5243,7 +5244,7 @@ static int
> ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
>  		val = UPIU_QUERY_OPCODE_CLEAR_FLAG;
> 
>  	return ufshcd_query_flag_retry(hba, val,
> -			       QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8,
> +			       QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8, 0,
>  				       NULL);
>  }
> 
> @@ -5264,7 +5265,8 @@ static int ufshcd_wb_buf_flush_enable(struct 
> ufs_hba *hba)
>  		return 0;
> 
>  	ret = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> -				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
> +				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN,
> +				      0, NULL);
>  	if (ret)
>  		dev_err(hba->dev, "%s WB - buf flush enable failed %d\n",
>  			__func__, ret);
> @@ -5283,7 +5285,7 @@ static int ufshcd_wb_buf_flush_disable(struct
> ufs_hba *hba)
>  		return 0;
> 
>  	ret = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
> -				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
> +				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, 0, NULL);
>  	if (ret) {
>  		dev_warn(hba->dev, "%s: WB - buf flush disable failed %d\n",
>  			 __func__, ret);
> @@ -7263,7 +7265,7 @@ static int ufshcd_device_params_init(struct 
> ufs_hba *hba)
>  	ufshcd_get_ref_clk_gating_wait(hba);
> 
>  	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> -			QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
> +			QUERY_FLAG_IDN_PWR_ON_WPE, 0, &flag))
>  		hba->dev_info.f_power_on_wp_en = flag;
> 
>  	/* Probe maximum power mode co-supported by both UFS host and device 
> */
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 056537e52c19..e555d794d441 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -946,7 +946,7 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>  int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
>  		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
>  int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
> -	enum flag_idn idn, bool *flag_res);
> +	enum flag_idn idn, u8 index, bool *flag_res);
> 
>  void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
>  void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
