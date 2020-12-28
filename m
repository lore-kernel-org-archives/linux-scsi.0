Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B16AC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 01:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4E3922522
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 01:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgL1Bvf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Dec 2020 20:51:35 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:19776 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgL1Bve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Dec 2020 20:51:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609120275; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=1/ATFb4h/mKgO2ui0Fg3/kyVv/b+xfwzspEHFWWxsa8=;
 b=oEvqU/3bGuB2Dh5xlUCf7RSkWsq9LZebSJCVUgz6nxL2d8wYuB1Z3qD3hnB8WdQAgOcoBtbt
 w4zHAZ6QIeevKfgX4i1GNNas951T6lCe+GEg4YUDrIcT/j4E08cJX4Zf70GOs9r6E82ZAyYw
 6SQdVto0qIbNrkjer1eHinIwpvU=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5fe939e8120d248bb5a3b893 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 28 Dec 2020 01:50:32
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 92BB7C43461; Mon, 28 Dec 2020 01:50:31 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 44C15C433CA;
        Mon, 28 Dec 2020 01:50:30 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 28 Dec 2020 09:50:30 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: Re: [PATCH v2 2/3] scsi: ufs: Add handling of the return value of
 pm_runtime_get_sync()
In-Reply-To: <20201224172010.10701-3-huobean@gmail.com>
References: <20201224172010.10701-1-huobean@gmail.com>
 <20201224172010.10701-3-huobean@gmail.com>
Message-ID: <88069c938a06b06f89cc4662cef3c1be@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-25 01:20, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> The race issue may exist between UFS access in UFS sysfs context and 
> UFS
> shutdown, thus will cause pm_runtime_get_sync() resume failure.

Are you trying to fix the race condition by adding these checks or just
adding these checks in case pm_runtime_get_sync() fails?

Can Guo.

> Add handling of the return value of pm_runtime_get_sync(). Let it 
> return
> in case pm_runtime_get_sync() resume failed.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs-sysfs.c | 38 ++++++++++++++++++++++++++++++------
>  1 file changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
> b/drivers/scsi/ufs/ufs-sysfs.c
> index 0e1438485133..8e5e36e01bee 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -154,12 +154,17 @@ static ssize_t auto_hibern8_show(struct device 
> *dev,
>  				 struct device_attribute *attr, char *buf)
>  {
>  	u32 ahit;
> +	int ret;
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> 
>  	if (!ufshcd_is_auto_hibern8_supported(hba))
>  		return -EOPNOTSUPP;
> 
> -	pm_runtime_get_sync(hba->dev);
> +	ret = pm_runtime_get_sync(hba->dev);
> +	if (ret < 0) {
> +		pm_runtime_put_noidle(hba->dev);
> +		return ret;
> +	}
>  	ufshcd_hold(hba, false);
>  	ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
>  	ufshcd_release(hba);
> @@ -225,7 +230,12 @@ static ssize_t ufs_sysfs_read_desc_param(struct
> ufs_hba *hba,
>  	if (param_size > 8)
>  		return -EINVAL;
> 
> -	pm_runtime_get_sync(hba->dev);
> +	ret = pm_runtime_get_sync(hba->dev);
> +	if (ret < 0) {
> +		pm_runtime_put_noidle(hba->dev);
> +		return ret;
> +	}
> +
>  	ret = ufshcd_read_desc_param(hba, desc_id, desc_index,
>  				param_offset, desc_buf, param_size);
>  	pm_runtime_put_sync(hba->dev);
> @@ -594,7 +604,11 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_ATOMIC);		\
>  	if (!desc_buf)                                                  \
>  		return -ENOMEM;                                         \
> -	pm_runtime_get_sync(hba->dev);					\
> +	ret = pm_runtime_get_sync(hba->dev);				\
> +	if (ret < 0) {							\
> +		pm_runtime_put_noidle(hba->dev);			\
> +		return ret;						\
> +	}								\
>  	ret = ufshcd_query_descriptor_retry(hba,			\
>  		UPIU_QUERY_OPCODE_READ_DESC, QUERY_DESC_IDN_DEVICE,	\
>  		0, 0, desc_buf, &desc_len);				\
> @@ -653,7 +667,11 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  	struct ufs_hba *hba = dev_get_drvdata(dev);			\
>  	if (ufshcd_is_wb_flags(QUERY_FLAG_IDN##_uname))			\
>  		index = ufshcd_wb_get_query_index(hba);			\
> -	pm_runtime_get_sync(hba->dev);					\
> +	ret = pm_runtime_get_sync(hba->dev);				\
> +	if (ret < 0) {							\
> +		pm_runtime_put_noidle(hba->dev);			\
> +		return ret;						\
> +	}								\
>  	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
>  		QUERY_FLAG_IDN##_uname, index, &flag);			\
>  	pm_runtime_put_sync(hba->dev);					\
> @@ -711,7 +729,11 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  	u8 index = 0;							\
>  	if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))			\
>  		index = ufshcd_wb_get_query_index(hba);			\
> -	pm_runtime_get_sync(hba->dev);					\
> +	ret = pm_runtime_get_sync(hba->dev);				\
> +	if (ret < 0) {							\
> +		pm_runtime_put_noidle(hba->dev);			\
> +		return ret;						\
> +	}								\
>  	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,	\
>  		QUERY_ATTR_IDN##_uname, index, 0, &value);		\
>  	pm_runtime_put_sync(hba->dev);					\
> @@ -850,7 +872,11 @@ static ssize_t
> dyn_cap_needed_attribute_show(struct device *dev,
>  	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);
>  	int ret;
> 
> -	pm_runtime_get_sync(hba->dev);
> +	ret = pm_runtime_get_sync(hba->dev);
> +	if (ret < 0) {
> +		pm_runtime_put_noidle(hba->dev);
> +		return ret;
> +	}
>  	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>  		QUERY_ATTR_IDN_DYN_CAP_NEEDED, lun, 0, &value);
>  	pm_runtime_put_sync(hba->dev);
