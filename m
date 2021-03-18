Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC66FC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 05:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C14FF64F0C
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 05:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCRFsi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 01:48:38 -0400
Received: from a0.mail.mailgun.net ([198.61.254.59]:54317 "EHLO
        a0.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhCRFsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 01:48:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1616046502; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=XJsn4KEBggf1PBvkKukN7rEx7imTth6pU5weyXgymiY=;
 b=IE2lKqoHp6eLMJ1vmCE91m/bVr3TyOo0dp/pD0uTUTOaFxXPkdOk6RMQ0t/NWhr0vbtZoLyJ
 UPxYxUIE+MxQbS6qb7oYHYWe/dvzYz1rulrwSfaVcEhTmE+Tl25szi/GBDS2rZqmtd4go14U
 j6vJken2SudT0ErH/1ZzhDxmTJI=
X-Mailgun-Sending-Ip: 198.61.254.59
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 6052e9a06dc1045b7d6d55d7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 18 Mar 2021 05:48:16
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B667BC433ED; Thu, 18 Mar 2021 05:48:15 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 27034C433C6;
        Thu, 18 Mar 2021 05:48:14 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Mar 2021 13:48:14 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, asutoshd@codeaurora.org,
        stanley.chu@mediatek.com, bvanassche@acm.org, huobean@gmail.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH] scsi: ufs: Add selector to ufshcd_query_flag* APIs
In-Reply-To: <20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2@epcms2p2>
References: <CGME20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2@epcms2p2>
 <20210317033143epcms2p25b37bba2bb515c1ce85bf555656ca3f2@epcms2p2>
Message-ID: <8e49758427cb7ca42df36a67ab4b9fd9@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-17 11:31, Daejun Park wrote:
> Unlike other query APIs in UFS, ufshcd_query_flag has a fixed selector
> as 0. This patch allows ufshcd_query_flag API to choose selector value
> by parameter.
> 
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufs-sysfs.c |  2 +-
>  drivers/scsi/ufs/ufshcd.c    | 29 +++++++++++++++++------------
>  drivers/scsi/ufs/ufshcd.h    |  2 +-
>  3 files changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
> b/drivers/scsi/ufs/ufs-sysfs.c
> index acc54f530f2d..606b058a3394 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -746,7 +746,7 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  		index = ufshcd_wb_get_query_index(hba);			\
>  	pm_runtime_get_sync(hba->dev);					\
>  	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
> -		QUERY_FLAG_IDN##_uname, index, &flag);			\
> +		QUERY_FLAG_IDN##_uname, index, &flag, 0);		\
>  	pm_runtime_put_sync(hba->dev);					\
>  	if (ret) {							\
>  		ret = -EINVAL;						\
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8c0ff024231c..c2fd9c58d6b8 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2940,13 +2940,15 @@ static inline void ufshcd_init_query(struct
> ufs_hba *hba,
>  }
> 
>  static int ufshcd_query_flag_retry(struct ufs_hba *hba,
> -	enum query_opcode opcode, enum flag_idn idn, u8 index, bool 
> *flag_res)
> +	enum query_opcode opcode, enum flag_idn idn, u8 index, bool 
> *flag_res,
> +	u8 selector)
>  {
>  	int ret;
>  	int retries;
> 
>  	for (retries = 0; retries < QUERY_REQ_RETRIES; retries++) {
> -		ret = ufshcd_query_flag(hba, opcode, idn, index, flag_res);
> +		ret = ufshcd_query_flag(hba, opcode, idn, index, flag_res,
> +					selector);
>  		if (ret)
>  			dev_dbg(hba->dev,
>  				"%s: failed with error %d, retries %d\n",
> @@ -2969,15 +2971,17 @@ static int ufshcd_query_flag_retry(struct 
> ufs_hba *hba,
>   * @idn: flag idn to access
>   * @index: flag index to access
>   * @flag_res: the flag value after the query request completes
> + * @selector: selector field
>   *
>   * Returns 0 for success, non-zero in case of failure
>   */
>  int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
> -			enum flag_idn idn, u8 index, bool *flag_res)
> +			enum flag_idn idn, u8 index, bool *flag_res,
> +			u8 selector)
>  {
>  	struct ufs_query_req *request = NULL;
>  	struct ufs_query_res *response = NULL;
> -	int err, selector = 0;
> +	int err;
>  	int timeout = QUERY_REQ_TIMEOUT;
> 
>  	BUG_ON(!hba);
> @@ -4331,7 +4335,7 @@ static int ufshcd_complete_dev_init(struct 
> ufs_hba *hba)
>  	ktime_t timeout;
> 
>  	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> -		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL);
> +		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL, 0);
>  	if (err) {
>  		dev_err(hba->dev,
>  			"%s setting fDeviceInit flag failed with error %d\n",
> @@ -4343,7 +4347,8 @@ static int ufshcd_complete_dev_init(struct 
> ufs_hba *hba)
>  	timeout = ktime_add_ms(ktime_get(), FDEVICEINIT_COMPL_TIMEOUT);
>  	do {
>  		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> -					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
> +					QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res,
> +					0);
>  		if (!flag_res)
>  			break;
>  		usleep_range(5000, 10000);
> @@ -5250,7 +5255,7 @@ static int ufshcd_enable_auto_bkops(struct 
> ufs_hba *hba)
>  		goto out;
> 
>  	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> -			QUERY_FLAG_IDN_BKOPS_EN, 0, NULL);
> +			QUERY_FLAG_IDN_BKOPS_EN, 0, NULL, 0);
>  	if (err) {
>  		dev_err(hba->dev, "%s: failed to enable bkops %d\n",
>  				__func__, err);
> @@ -5300,7 +5305,7 @@ static int ufshcd_disable_auto_bkops(struct 
> ufs_hba *hba)
>  	}
> 
>  	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
> -			QUERY_FLAG_IDN_BKOPS_EN, 0, NULL);
> +			QUERY_FLAG_IDN_BKOPS_EN, 0, NULL, 0);
>  	if (err) {
>  		dev_err(hba->dev, "%s: failed to disable bkops %d\n",
>  				__func__, err);
> @@ -5463,7 +5468,7 @@ int ufshcd_wb_ctrl(struct ufs_hba *hba, bool 
> enable)
> 
>  	index = ufshcd_wb_get_query_index(hba);
>  	ret = ufshcd_query_flag_retry(hba, opcode,
> -				      QUERY_FLAG_IDN_WB_EN, index, NULL);
> +				      QUERY_FLAG_IDN_WB_EN, index, NULL, 0);
>  	if (ret) {
>  		dev_err(hba->dev, "%s write booster %s failed %d\n",
>  			__func__, enable ? "enable" : "disable", ret);
> @@ -5490,7 +5495,7 @@ static int
> ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
>  	index = ufshcd_wb_get_query_index(hba);
>  	return ufshcd_query_flag_retry(hba, val,
>  				QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8,
> -				index, NULL);
> +				index, NULL, 0);
>  }
> 
>  static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool 
> enable)
> @@ -5511,7 +5516,7 @@ static inline int ufshcd_wb_toggle_flush(struct
> ufs_hba *hba, bool enable)
>  	index = ufshcd_wb_get_query_index(hba);
>  	ret = ufshcd_query_flag_retry(hba, opcode,
>  				      QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, index,
> -				      NULL);
> +				      NULL, 0);
>  	if (ret) {
>  		dev_err(hba->dev, "%s WB-Buf Flush %s failed %d\n", __func__,
>  			enable ? "enable" : "disable", ret);
> @@ -7751,7 +7756,7 @@ static int ufshcd_device_params_init(struct 
> ufs_hba *hba)
>  	ufshcd_get_ref_clk_gating_wait(hba);
> 
>  	if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> -			QUERY_FLAG_IDN_PWR_ON_WPE, 0, &flag))
> +			QUERY_FLAG_IDN_PWR_ON_WPE, 0, &flag, 0))
>  		hba->dev_info.f_power_on_wp_en = flag;
> 
>  	/* Probe maximum power mode co-supported by both UFS host and device 
> */
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 1af91661dc83..67a26b2be36f 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1077,7 +1077,7 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
>  int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
>  		      enum attr_idn idn, u8 index, u8 selector, u32 *attr_val);
>  int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
> -	enum flag_idn idn, u8 index, bool *flag_res);
> +	enum flag_idn idn, u8 index, bool *flag_res, u8 selector);
> 
>  void ufshcd_auto_hibern8_enable(struct ufs_hba *hba);
>  void ufshcd_auto_hibern8_update(struct ufs_hba *hba, u32 ahit);
