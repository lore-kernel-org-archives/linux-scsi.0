Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17285C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 07:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C45E323A6A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 07:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgLHHOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 02:14:41 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:52573 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgLHHOk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 02:14:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607411659; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Mqn0rcSrqnI/3QxNQU0p7+wCiRGucPaX14qIV61pDEQ=;
 b=aUQIIOfzN0GG/bJoHDC/5X5ZdLUm2fMELn9M/z4ozEaD9ORMwkZY3Pmu1+Mv7vf2WIM+my9Y
 /bWYgtHcJkIiaYLnSXDduzHAN5DLuv5xozS3xrR+/bcfNFtwuJw6lVGqLMz5XbWP9clwlET/
 cMdhEIBZziSDIFAhYWftN4/XpNE=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fcf27abdc0fd8a3174d7f88 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 08 Dec 2020 07:13:47
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 43000C43464; Tue,  8 Dec 2020 07:13:47 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 118CBC433CA;
        Tue,  8 Dec 2020 07:13:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 08 Dec 2020 15:13:45 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
In-Reply-To: <20201206101335.3418-2-huobean@gmail.com>
References: <20201206101335.3418-1-huobean@gmail.com>
 <20201206101335.3418-2-huobean@gmail.com>
Message-ID: <1d99b564f593f91cc13ca682655def29@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-06 18:13, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Currently UFS WriteBooster driver uses clock scaling up/down to set
> WB on/off, for the platform which doesn't support 
> UFSHCD_CAP_CLK_SCALING,
> WB will be always on. Provide a sysfs attribute to enable/disable WB
> during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable UFS 
> WB.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs-sysfs.c | 40 ++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c    |  3 +--
>  drivers/scsi/ufs/ufshcd.h    |  2 ++
>  3 files changed, 43 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
> b/drivers/scsi/ufs/ufs-sysfs.c
> index 08e72b7eef6a..b3bf7fca00e5 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -189,6 +189,44 @@ static ssize_t auto_hibern8_store(struct device 
> *dev,
>  	return count;
>  }
> 
> +static ssize_t wb_on_show(struct device *dev, struct device_attribute 
> *attr,
> +			  char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return scnprintf(buf, PAGE_SIZE, "%d\n", hba->wb_enabled);
> +}
> +
> +static ssize_t wb_on_store(struct device *dev, struct device_attribute 
> *attr,
> +			   const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	unsigned int wb_enable;
> +	ssize_t res;
> +
> +	if (ufshcd_is_clkscaling_supported(hba)) {
> +		/* If the platform supports UFSHCD_CAP_AUTO_BKOPS_SUSPEND, turn
> +		 * WB on/off will be done while clock scaling up/down.
> +		 */

Double check comment line format?

> +		dev_warn(dev, "To control WB through wb_on is not allowed!\n");
> +		return -EOPNOTSUPP;
> +	}
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
> +	pm_runtime_put_sync(hba->dev);
> +
> +	return res < 0 ? res : count;
> +}
> +
>  static DEVICE_ATTR_RW(rpm_lvl);
>  static DEVICE_ATTR_RO(rpm_target_dev_state);
>  static DEVICE_ATTR_RO(rpm_target_link_state);
> @@ -196,6 +234,7 @@ static DEVICE_ATTR_RW(spm_lvl);
>  static DEVICE_ATTR_RO(spm_target_dev_state);
>  static DEVICE_ATTR_RO(spm_target_link_state);
>  static DEVICE_ATTR_RW(auto_hibern8);
> +static DEVICE_ATTR_RW(wb_on);
> 
>  static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
>  	&dev_attr_rpm_lvl.attr,
> @@ -205,6 +244,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = 
> {
>  	&dev_attr_spm_target_dev_state.attr,
>  	&dev_attr_spm_target_link_state.attr,
>  	&dev_attr_auto_hibern8.attr,
> +	&dev_attr_wb_on.attr,
>  	NULL
>  };
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 92d433d5f3ca..30332592e624 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -247,7 +247,6 @@ static inline int ufshcd_config_vreg_hpm(struct
> ufs_hba *hba,
>  static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
>  static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
>  static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
> -static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
>  static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool 
> set);
>  static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool 
> enable);
>  static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
> @@ -5307,7 +5306,7 @@ static void
> ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
>  				__func__, err);
>  }
> 
> -static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
> +int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
>  {
>  	int ret;
>  	u8 index;
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 61344c49c2cc..c61584dff74a 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -1068,6 +1068,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
>  			     u8 *desc_buff, int *buff_len,
>  			     enum query_opcode desc_op);
> 
> +int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
> +
>  /* Wrapper functions for safely calling variant operations */
>  static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
>  {
