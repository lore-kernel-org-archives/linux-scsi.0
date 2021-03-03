Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB21C2BA11
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B21A160234
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379545AbhCCMrE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:04 -0500
Received: from z11.mailgun.us ([104.130.96.11]:14531 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1840731AbhCCEch (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 2 Mar 2021 23:32:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614745938; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=8de6SU8LERMt+uXN76aXoq2VfDor2GQ9K83y5pTYVaM=;
 b=fBmVWZ8CnkaW0YMiCNZKJcne54vEiX+i05zxTi2ZjJD4BkN2hG/huZPOGt+bYMAJa6aAxI+w
 NxI5+UqARpkaCjp+YYtdN9u6kL3qpIy+KzL/HPRTxiNVQWkvnZIRhH6UeS/O4jZE4u3EgBPv
 xqRwxV0r0ekNN79WhVIjjJyZqSc=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 603f11346639e8e6857ec708 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Mar 2021 04:31:48
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EFE5BC43462; Wed,  3 Mar 2021 04:31:47 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D871DC433C6;
        Wed,  3 Mar 2021 04:31:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Mar 2021 12:31:46 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Asutosh Das <asutoshd@codeaurora.org>
Cc:     martin.petersen@oracle.com, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 2/2] ufs: sysfs: Resume the proper scsi device
In-Reply-To: <5d7c0cd1ff4bc5295015244f057d252fe9040993.1614725302.git.asutoshd@codeaurora.org>
References: <cover.1614725302.git.asutoshd@codeaurora.org>
 <5d7c0cd1ff4bc5295015244f057d252fe9040993.1614725302.git.asutoshd@codeaurora.org>
Message-ID: <61ea8834f91d4582c93608d18352686a@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-03 06:52, Asutosh Das wrote:
> Resumes the actual scsi device the unit descriptor of which
> is being accessed instead of the hba alone.
> 
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufs-sysfs.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
> b/drivers/scsi/ufs/ufs-sysfs.c
> index acc54f5..3fc182b 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -245,9 +245,9 @@ static ssize_t wb_on_store(struct device *dev,
> struct device_attribute *attr,
>  		goto out;
>  	}
> 
> -	pm_runtime_get_sync(hba->dev);
> +	scsi_autopm_get_device(hba->sdev_ufs_device);
>  	res = ufshcd_wb_ctrl(hba, wb_enable);
> -	pm_runtime_put_sync(hba->dev);
> +	scsi_autopm_put_device(hba->sdev_ufs_device);
>  out:
>  	up(&hba->host_sem);
>  	return res < 0 ? res : count;
> @@ -297,10 +297,10 @@ static ssize_t ufs_sysfs_read_desc_param(struct
> ufs_hba *hba,
>  		goto out;
>  	}
> 
> -	pm_runtime_get_sync(hba->dev);
> +	scsi_autopm_get_device(hba->sdev_ufs_device);
>  	ret = ufshcd_read_desc_param(hba, desc_id, desc_index,
>  				param_offset, desc_buf, param_size);
> -	pm_runtime_put_sync(hba->dev);
> +	scsi_autopm_put_device(hba->sdev_ufs_device);
>  	if (ret) {
>  		ret = -EINVAL;
>  		goto out;
> @@ -678,7 +678,7 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  		up(&hba->host_sem);					\
>  		return -ENOMEM;						\
>  	}								\
> -	pm_runtime_get_sync(hba->dev);					\
> +	scsi_autopm_get_device(hba->sdev_ufs_device);			\
>  	ret = ufshcd_query_descriptor_retry(hba,			\
>  		UPIU_QUERY_OPCODE_READ_DESC, QUERY_DESC_IDN_DEVICE,	\
>  		0, 0, desc_buf, &desc_len);				\
> @@ -695,7 +695,7 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  		goto out;						\
>  	ret = sysfs_emit(buf, "%s\n", desc_buf);			\
>  out:									\
> -	pm_runtime_put_sync(hba->dev);					\
> +	scsi_autopm_put_device(hba->sdev_ufs_device);			\
>  	kfree(desc_buf);						\
>  	up(&hba->host_sem);						\
>  	return ret;							\
> @@ -744,10 +744,10 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  	}								\
>  	if (ufshcd_is_wb_flags(QUERY_FLAG_IDN##_uname))			\
>  		index = ufshcd_wb_get_query_index(hba);			\
> -	pm_runtime_get_sync(hba->dev);					\
> +	scsi_autopm_get_device(hba->sdev_ufs_device);			\
>  	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
>  		QUERY_FLAG_IDN##_uname, index, &flag);			\
> -	pm_runtime_put_sync(hba->dev);					\
> +	scsi_autopm_put_device(hba->sdev_ufs_device);			\
>  	if (ret) {							\
>  		ret = -EINVAL;						\
>  		goto out;						\
> @@ -813,10 +813,10 @@ static ssize_t _name##_show(struct device 
> *dev,				\
>  	}								\
>  	if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))			\
>  		index = ufshcd_wb_get_query_index(hba);			\
> -	pm_runtime_get_sync(hba->dev);					\
> +	scsi_autopm_get_device(hba->sdev_ufs_device);			\
>  	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,	\
>  		QUERY_ATTR_IDN##_uname, index, 0, &value);		\
> -	pm_runtime_put_sync(hba->dev);					\
> +	scsi_autopm_put_device(hba->sdev_ufs_device);			\
>  	if (ret) {							\
>  		ret = -EINVAL;						\
>  		goto out;						\
> @@ -899,11 +899,15 @@ static ssize_t _pname##_show(struct device 
> *dev,			\
>  	struct scsi_device *sdev = to_scsi_device(dev);			\
>  	struct ufs_hba *hba = shost_priv(sdev->host);			\
>  	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);			\
> +	int ret;							\
>  	if (!ufs_is_valid_unit_desc_lun(&hba->dev_info, lun,		\
>  				_duname##_DESC_PARAM##_puname))		\
>  		return -EINVAL;						\
> -	return ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,	\
> +	scsi_autopm_get_device(sdev);					\
> +	ret = ufs_sysfs_read_desc_param(hba, QUERY_DESC_IDN_##_duname,	\
>  		lun, _duname##_DESC_PARAM##_puname, buf, _size);	\
> +	scsi_autopm_put_device(sdev);					\
> +	return ret;							\
>  }									\
>  static DEVICE_ATTR_RO(_pname)
> 
> @@ -964,10 +968,10 @@ static ssize_t
> dyn_cap_needed_attribute_show(struct device *dev,
>  		goto out;
>  	}
> 
> -	pm_runtime_get_sync(hba->dev);
> +	scsi_autopm_get_device(hba->sdev_ufs_device);
>  	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
>  		QUERY_ATTR_IDN_DYN_CAP_NEEDED, lun, 0, &value);
> -	pm_runtime_put_sync(hba->dev);
> +	scsi_autopm_put_device(hba->sdev_ufs_device);
>  	if (ret) {
>  		ret = -EINVAL;
>  		goto out;
