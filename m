Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2DFC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 06:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB60622E00
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 06:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbhAGGJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 01:09:01 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:55934 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbhAGGJA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 01:09:00 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609999719; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=+a87TyKtx6vmxXVtX4yZ9FKeMPLuVHzbUuTQERMuiu0=;
 b=IMLlwvh6nn+t2xMqLOJU4qgi0xxPR+aFk1J+q/aulfAjDuzqqXRP1GkqIV+tDTZVDDCKS6WL
 DAkMLCrfz1oHoHcTEg/sb5BwOToLEbd4CxyV3YgJr/Nmk+aO26HNKtzUCWAN7CqDr3I7SlIl
 MPrNUYHKxGQ7bDT8OX+uQeRmX6Q=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5ff6a54d661021aa28fb3469 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Jan 2021 06:08:13
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E73CEC43464; Thu,  7 Jan 2021 06:08:12 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9A836C433C6;
        Thu,  7 Jan 2021 06:08:11 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 Jan 2021 14:08:11 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: Replace sprintf and snprintf with
 sysfs_emit
In-Reply-To: <20210106211541.23039-1-huobean@gmail.com>
References: <20210106211541.23039-1-huobean@gmail.com>
Message-ID: <7c6c583a46c157b549d855039566fac9@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-07 05:15, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> sprintf and snprintf may cause output defect in sysfs content, it is
> better to use new added sysfs_emit function which knows the size of the
> temporary buffer.
> 

Reviewed-by: Can Guo <cang@codeaurora.org>

> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
> Nothing changed in this patch, just take it out from patchset:
> https://patchwork.kernel.org/project/linux-scsi/cover/20201224172010.10701-1-huobean@gmail.com/
> 
> ---
>  drivers/scsi/ufs/ufs-sysfs.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
> b/drivers/scsi/ufs/ufs-sysfs.c
> index 08e72b7eef6a..0e1438485133 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -67,7 +67,7 @@ static ssize_t rpm_lvl_show(struct device *dev,
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> 
> -	return sprintf(buf, "%d\n", hba->rpm_lvl);
> +	return sysfs_emit(buf, "%d\n", hba->rpm_lvl);
>  }
> 
>  static ssize_t rpm_lvl_store(struct device *dev,
> @@ -81,7 +81,7 @@ static ssize_t rpm_target_dev_state_show(struct 
> device *dev,
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> 
> -	return sprintf(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
> +	return sysfs_emit(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
>  			ufs_pm_lvl_states[hba->rpm_lvl].dev_state));
>  }
> 
> @@ -90,7 +90,7 @@ static ssize_t rpm_target_link_state_show(struct 
> device *dev,
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> 
> -	return sprintf(buf, "%s\n", ufschd_uic_link_state_to_string(
> +	return sysfs_emit(buf, "%s\n", ufschd_uic_link_state_to_string(
>  			ufs_pm_lvl_states[hba->rpm_lvl].link_state));
>  }
> 
> @@ -99,7 +99,7 @@ static ssize_t spm_lvl_show(struct device *dev,
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> 
> -	return sprintf(buf, "%d\n", hba->spm_lvl);
> +	return sysfs_emit(buf, "%d\n", hba->spm_lvl);
>  }
> 
>  static ssize_t spm_lvl_store(struct device *dev,
> @@ -113,7 +113,7 @@ static ssize_t spm_target_dev_state_show(struct 
> device *dev,
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> 
> -	return sprintf(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
> +	return sysfs_emit(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
>  				ufs_pm_lvl_states[hba->spm_lvl].dev_state));
>  }
> 
> @@ -122,7 +122,7 @@ static ssize_t spm_target_link_state_show(struct
> device *dev,
>  {
>  	struct ufs_hba *hba = dev_get_drvdata(dev);
> 
> -	return sprintf(buf, "%s\n", ufschd_uic_link_state_to_string(
> +	return sysfs_emit(buf, "%s\n", ufschd_uic_link_state_to_string(
>  				ufs_pm_lvl_states[hba->spm_lvl].link_state));
>  }
> 
> @@ -165,7 +165,7 @@ static ssize_t auto_hibern8_show(struct device 
> *dev,
>  	ufshcd_release(hba);
>  	pm_runtime_put_sync(hba->dev);
> 
> -	return scnprintf(buf, PAGE_SIZE, "%d\n", ufshcd_ahit_to_us(ahit));
> +	return sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
>  }
> 
>  static ssize_t auto_hibern8_store(struct device *dev,
> @@ -233,18 +233,18 @@ static ssize_t ufs_sysfs_read_desc_param(struct
> ufs_hba *hba,
>  		return -EINVAL;
>  	switch (param_size) {
>  	case 1:
> -		ret = sprintf(sysfs_buf, "0x%02X\n", *desc_buf);
> +		ret = sysfs_emit(sysfs_buf, "0x%02X\n", *desc_buf);
>  		break;
>  	case 2:
> -		ret = sprintf(sysfs_buf, "0x%04X\n",
> +		ret = sysfs_emit(sysfs_buf, "0x%04X\n",
>  			get_unaligned_be16(desc_buf));
>  		break;
>  	case 4:
> -		ret = sprintf(sysfs_buf, "0x%08X\n",
> +		ret = sysfs_emit(sysfs_buf, "0x%08X\n",
>  			get_unaligned_be32(desc_buf));
>  		break;
>  	case 8:
> -		ret = sprintf(sysfs_buf, "0x%016llX\n",
> +		ret = sysfs_emit(sysfs_buf, "0x%016llX\n",
>  			get_unaligned_be64(desc_buf));
>  		break;
>  	}
> @@ -609,7 +609,7 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  				      SD_ASCII_STD);			\
>  	if (ret < 0)							\
>  		goto out;						\
> -	ret = snprintf(buf, PAGE_SIZE, "%s\n", desc_buf);		\
> +	ret = sysfs_emit(buf, "%s\n", desc_buf);		\
>  out:									\
>  	pm_runtime_put_sync(hba->dev);					\
>  	kfree(desc_buf);						\
> @@ -659,7 +659,7 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  	pm_runtime_put_sync(hba->dev);					\
>  	if (ret)							\
>  		return -EINVAL;						\
> -	return sprintf(buf, "%s\n", flag ? "true" : "false"); \
> +	return sysfs_emit(buf, "%s\n", flag ? "true" : "false");	\
>  }									\
>  static DEVICE_ATTR_RO(_name)
> 
> @@ -717,7 +717,7 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  	pm_runtime_put_sync(hba->dev);					\
>  	if (ret)							\
>  		return -EINVAL;						\
> -	return sprintf(buf, "0x%08X\n", value);				\
> +	return sysfs_emit(buf, "0x%08X\n", value);			\
>  }									\
>  static DEVICE_ATTR_RO(_name)
> 
> @@ -856,7 +856,7 @@ static ssize_t
> dyn_cap_needed_attribute_show(struct device *dev,
>  	pm_runtime_put_sync(hba->dev);
>  	if (ret)
>  		return -EINVAL;
> -	return sprintf(buf, "0x%08X\n", value);
> +	return sysfs_emit(buf, "0x%08X\n", value);
>  }
>  static DEVICE_ATTR_RO(dyn_cap_needed_attribute);
