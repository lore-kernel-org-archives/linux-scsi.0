Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D6EC64E7B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 23:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B3F72076C
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 23:19:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="kp9v6578"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387581AbgK3XT5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 18:19:57 -0500
Received: from z5.mailgun.us ([104.130.96.5]:61899 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgK3XT4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 18:19:56 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606778376; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=syjTGio1OyJ5XZTcS06LweFoVuBQoMLa4k53wtt4Wi0=; b=kp9v6578gsQnzYjya+Bg3FKOU0VweLOZpFqZ38ulr9g01NrbTygiLjScBjiwNhacz2WBLMF1
 N625J8Vnx1eBSGQIHDQwe6xs/R20kC9vPhhq1c/+DJ5unDZPl2R7RsfoyjZjgH8weMvA7y3b
 uWza1CVVBAX6JerCLBTMN+GOVPY=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5fc57ded07535c81bac92339 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 30 Nov 2020 23:19:09
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2CA22C43465; Mon, 30 Nov 2020 23:19:09 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B8D8CC43461;
        Mon, 30 Nov 2020 23:19:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B8D8CC43461
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201130181143.5739-1-huobean@gmail.com>
 <20201130181143.5739-2-huobean@gmail.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <2a380908-3eb4-2cdc-4156-03e8946ffd88@codeaurora.org>
Date:   Mon, 30 Nov 2020 15:19:05 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201130181143.5739-2-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/2020 10:11 AM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Currently we let UFS WriteBooster driver use clock scaling
> up/down to set WB on/off, for the platform which doesn't
> support UFSHCD_CAP_CLK_SCALING, WB will be always on. Provide
> a sysfs attribute to enable/disable WB during runtime.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>   drivers/scsi/ufs/ufs-sysfs.c | 33 +++++++++++++++++++++++++++++++++
>   drivers/scsi/ufs/ufshcd.c    |  3 +--
>   drivers/scsi/ufs/ufshcd.h    |  2 ++
>   3 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index 08e72b7eef6a..e41d8eb779ec 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -189,6 +189,37 @@ static ssize_t auto_hibern8_store(struct device *dev,
>   	return count;
>   }
>   
> +static ssize_t wb_on_show(struct device *dev, struct device_attribute *attr,
> +			  char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", hba->wb_enabled);
> +}
> +
> +static ssize_t wb_on_store(struct device *dev, struct device_attribute *attr,
> +			   const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	unsigned int wb_enable;
> +	ssize_t res;
> +
> +	if (!ufshcd_is_wb_allowed(hba))
> +		return -EOPNOTSUPP;
> +
> +	if (kstrtouint(buf, 0, &wb_enable))
> +		return -EINVAL;
> +
> +	if (wb_enable != 0 && wb_enable != 1)
> +		return -EINVAL;
> +
> +	pm_runtime_get_sync(hba->dev);
> +	res = ufshcd_wb_ctrl(hba, wb_enable);

Say, a platform supports clock-scaling and this bit is toggled.
The control goes into ufshcd_wb_ctrl for both this sysfs and 
clock-scaling contexts. The clock-scaling context passes all checks and 
blocks on waiting for this wb control to be disabled and then tries to 
enable wb when it's already disabled. Perhaps that's a race there?

> +	pm_runtime_put_sync(hba->dev);
> +
> +	return res < 0 ? res : count;
> +}
> +
>   static DEVICE_ATTR_RW(rpm_lvl);
>   static DEVICE_ATTR_RO(rpm_target_dev_state);
>   static DEVICE_ATTR_RO(rpm_target_link_state);
> @@ -196,6 +227,7 @@ static DEVICE_ATTR_RW(spm_lvl);
>   static DEVICE_ATTR_RO(spm_target_dev_state);
>   static DEVICE_ATTR_RO(spm_target_link_state);
>   static DEVICE_ATTR_RW(auto_hibern8);
> +static DEVICE_ATTR_RW(wb_on);
>   
>   static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
>   	&dev_attr_rpm_lvl.attr,
> @@ -205,6 +237,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
>   	&dev_attr_spm_target_dev_state.attr,
>   	&dev_attr_spm_target_link_state.attr,
>   	&dev_attr_auto_hibern8.attr,
> +	&dev_attr_wb_on.attr,
>   	NULL
>   };
>   
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d169db41ee16..639ba9d1ccbb 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -247,7 +247,6 @@ static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
>   static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
>   static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
>   static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
> -static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
>   static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
>   static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
>   static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
> @@ -5299,7 +5298,7 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
>   				__func__, err);
>   }
>   
> -static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
> +int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
>   {
>   	int ret;
>   	u8 index;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index d0b68df07eef..c7bb61a4e484 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1067,6 +1067,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>   			     u8 *desc_buff, int *buff_len,
>   			     enum query_opcode desc_op);
>   
> +int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
> +
>   /* Wrapper functions for safely calling variant operations */
>   static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
>   {
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
