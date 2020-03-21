Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF35C4332D
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2646B2070A
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="p06+53Bc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCUAwt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:52:49 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:59970 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726773AbgCUAwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Mar 2020 20:52:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584751969; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: References: To: From:
 Subject: Sender; bh=Vc66dKLAtaL9Qm6w1/aU7U8XxNcIsLmVSGtfwyA4Q+c=; b=p06+53BcvzU6riCTGErbMLnaI6GDiD+YRnfE+z+TV+zGDI10uNLOlnZwG8JR34QLsXMV4tcK
 Y/pZwkyir1V+0rY4/dmkNOTuFouvJdS6wGqkaHzvWOfctXp68eSTyodaYItvYJ7fifs4kfgp
 DyKKTCUFue3QVOK4FrbT4xZU/eE=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e756556.7f9ac8c18bc8-smtp-out-n02;
 Sat, 21 Mar 2020 00:52:38 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 55113C433BA; Sat, 21 Mar 2020 00:52:37 +0000 (UTC)
Received: from [192.168.8.111] (cpe-70-95-153-89.san.res.rr.com [70.95.153.89])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF621C433D2;
        Sat, 21 Mar 2020 00:52:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AF621C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [<RFC PATCH v2> 3/3] ufs: sysfs: add sysfs entries for write
 booster
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
To:     asutoshd@qti.qualcomm.com, linux-scsi@vger.kernel.org
References: <cover.1584750888.git.asutoshd@codeaurora.org>
 <7dcdd3ec5b49a17d14c53540bf70bb725c6bc1cb.1584750888.git.asutoshd@codeaurora.org>
Message-ID: <e641291b-e32b-901e-6bd2-a6c5fb995841@codeaurora.org>
Date:   Fri, 20 Mar 2020 17:52:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <7dcdd3ec5b49a17d14c53540bf70bb725c6bc1cb.1584750888.git.asutoshd@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/20/2020 5:48 PM, Asutosh Das wrote:
> Adds unit, device, geometry descriptor sysfs entries.
> Adds flags sysfs entries for write booster.
> 
> Change-Id: I53ac9e83baa4a012187ee215280032d96deedf62
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>   drivers/scsi/ufs/ufs-sysfs.c | 39 ++++++++++++++++++++++++++++++++++++++-
>   drivers/scsi/ufs/ufs.h       |  6 ++++++
>   2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> index dbdf8b0..db3b932 100644
> --- a/drivers/scsi/ufs/ufs-sysfs.c
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -274,6 +274,10 @@ UFS_DEVICE_DESC_PARAM(device_version, _DEV_VER, 2);
>   UFS_DEVICE_DESC_PARAM(number_of_secure_wpa, _NUM_SEC_WPA, 1);
>   UFS_DEVICE_DESC_PARAM(psa_max_data_size, _PSA_MAX_DATA, 4);
>   UFS_DEVICE_DESC_PARAM(psa_state_timeout, _PSA_TMT, 1);
> +UFS_DEVICE_DESC_PARAM(ext_feature_sup, _EXT_UFS_FEATURE_SUP, 4);
> +UFS_DEVICE_DESC_PARAM(wb_presv_us_en, _WB_US_RED_EN, 1);
> +UFS_DEVICE_DESC_PARAM(wb_type, _WB_TYPE, 1);
> +UFS_DEVICE_DESC_PARAM(wb_shared_alloc_units, _WB_SHARED_ALLOC_UNITS, 4);
>   
>   static struct attribute *ufs_sysfs_device_descriptor[] = {
>   	&dev_attr_device_type.attr,
> @@ -302,6 +306,10 @@ static struct attribute *ufs_sysfs_device_descriptor[] = {
>   	&dev_attr_number_of_secure_wpa.attr,
>   	&dev_attr_psa_max_data_size.attr,
>   	&dev_attr_psa_state_timeout.attr,
> +	&dev_attr_ext_feature_sup.attr,
> +	&dev_attr_wb_presv_us_en.attr,
> +	&dev_attr_wb_type.attr,
> +	&dev_attr_wb_shared_alloc_units.attr,
>   	NULL,
>   };
>   
> @@ -371,6 +379,12 @@ UFS_GEOMETRY_DESC_PARAM(enh4_memory_max_alloc_units,
>   	_ENM4_MAX_NUM_UNITS, 4);
>   UFS_GEOMETRY_DESC_PARAM(enh4_memory_capacity_adjustment_factor,
>   	_ENM4_CAP_ADJ_FCTR, 2);
> +UFS_GEOMETRY_DESC_PARAM(wb_max_alloc_units, _WB_MAX_ALLOC_UNITS, 4);
> +UFS_GEOMETRY_DESC_PARAM(wb_max_wb_luns, _WB_MAX_WB_LUNS, 1);
> +UFS_GEOMETRY_DESC_PARAM(wb_buff_cap_adj, _WB_BUFF_CAP_ADJ, 1);
> +UFS_GEOMETRY_DESC_PARAM(wb_sup_red_type, _WB_SUP_RED_TYPE, 1);
> +UFS_GEOMETRY_DESC_PARAM(wb_sup_wb_type, _WB_SUP_WB_TYPE, 1);
> +
>   
>   static struct attribute *ufs_sysfs_geometry_descriptor[] = {
>   	&dev_attr_raw_device_capacity.attr,
> @@ -402,6 +416,11 @@ static struct attribute *ufs_sysfs_geometry_descriptor[] = {
>   	&dev_attr_enh3_memory_capacity_adjustment_factor.attr,
>   	&dev_attr_enh4_memory_max_alloc_units.attr,
>   	&dev_attr_enh4_memory_capacity_adjustment_factor.attr,
> +	&dev_attr_wb_max_alloc_units.attr,
> +	&dev_attr_wb_max_wb_luns.attr,
> +	&dev_attr_wb_buff_cap_adj.attr,
> +	&dev_attr_wb_sup_red_type.attr,
> +	&dev_attr_wb_sup_wb_type.attr,
>   	NULL,
>   };
>   
> @@ -608,7 +627,7 @@ static ssize_t _name##_show(struct device *dev,				\
>   	if (ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,		\
>   		QUERY_FLAG_IDN##_uname, &flag))				\
>   		return -EINVAL;						\
> -	return sprintf(buf, "%s\n", flag ? "true" : "false");		\
> +	return sprintf(buf, "%s\n", flag ? "true" : "false"); \
>   }									\
>   static DEVICE_ATTR_RO(_name)
>   
> @@ -620,6 +639,9 @@ UFS_FLAG(life_span_mode_enable, _LIFE_SPAN_MODE_ENABLE);
>   UFS_FLAG(phy_resource_removal, _FPHYRESOURCEREMOVAL);
>   UFS_FLAG(busy_rtc, _BUSY_RTC);
>   UFS_FLAG(disable_fw_update, _PERMANENTLY_DISABLE_FW_UPDATE);
> +UFS_FLAG(wb_enable, _WB_EN);
> +UFS_FLAG(wb_flush_en, _WB_BUFF_FLUSH_EN);
> +UFS_FLAG(wb_flush_during_h8, _WB_BUFF_FLUSH_DURING_HIBERN8);
>   
>   static struct attribute *ufs_sysfs_device_flags[] = {
>   	&dev_attr_device_init.attr,
> @@ -630,6 +652,9 @@ static struct attribute *ufs_sysfs_device_flags[] = {
>   	&dev_attr_phy_resource_removal.attr,
>   	&dev_attr_busy_rtc.attr,
>   	&dev_attr_disable_fw_update.attr,
> +	&dev_attr_wb_enable.attr,
> +	&dev_attr_wb_flush_en.attr,
> +	&dev_attr_wb_flush_during_h8.attr,
>   	NULL,
>   };
>   
> @@ -667,6 +692,11 @@ UFS_ATTRIBUTE(exception_event_status, _EE_STATUS);
>   UFS_ATTRIBUTE(ffu_status, _FFU_STATUS);
>   UFS_ATTRIBUTE(psa_state, _PSA_STATE);
>   UFS_ATTRIBUTE(psa_data_size, _PSA_DATA_SIZE);
> +UFS_ATTRIBUTE(wb_flush_status, _WB_FLUSH_STATUS);
> +UFS_ATTRIBUTE(wb_avail_buf, _AVAIL_WB_BUFF_SIZE);
> +UFS_ATTRIBUTE(wb_life_time_est, _WB_BUFF_LIFE_TIME_EST);
> +UFS_ATTRIBUTE(wb_cur_buf, _CURR_WB_BUFF_SIZE);
> +
>   
>   static struct attribute *ufs_sysfs_attributes[] = {
>   	&dev_attr_boot_lun_enabled.attr,
> @@ -685,6 +715,10 @@ static struct attribute *ufs_sysfs_attributes[] = {
>   	&dev_attr_ffu_status.attr,
>   	&dev_attr_psa_state.attr,
>   	&dev_attr_psa_data_size.attr,
> +	&dev_attr_wb_flush_status.attr,
> +	&dev_attr_wb_avail_buf.attr,
> +	&dev_attr_wb_life_time_est.attr,
> +	&dev_attr_wb_cur_buf.attr,
>   	NULL,
>   };
>   
> @@ -736,6 +770,8 @@ UFS_UNIT_DESC_PARAM(provisioning_type, _PROVISIONING_TYPE, 1);
>   UFS_UNIT_DESC_PARAM(physical_memory_resourse_count, _PHY_MEM_RSRC_CNT, 8);
>   UFS_UNIT_DESC_PARAM(context_capabilities, _CTX_CAPABILITIES, 2);
>   UFS_UNIT_DESC_PARAM(large_unit_granularity, _LARGE_UNIT_SIZE_M1, 1);
> +UFS_UNIT_DESC_PARAM(wb_buf_alloc_units, _WB_BUF_ALLOC_UNITS, 4);
> +
>   
>   static struct attribute *ufs_sysfs_unit_descriptor[] = {
>   	&dev_attr_boot_lun_id.attr,
> @@ -751,6 +787,7 @@ static struct attribute *ufs_sysfs_unit_descriptor[] = {
>   	&dev_attr_physical_memory_resourse_count.attr,
>   	&dev_attr_context_capabilities.attr,
>   	&dev_attr_large_unit_granularity.attr,
> +	&dev_attr_wb_buf_alloc_units.attr,
>   	NULL,
>   };
>   
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index 2c77b3e..5c26659 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -267,6 +267,7 @@ enum device_desc_param {
>   	DEVICE_DESC_PARAM_PSA_TMT		= 0x29,
>   	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
>   	DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP	= 0x4F,
> +	DEVICE_DESC_PARAM_WB_US_RED_EN		= 0x53,
>   	DEVICE_DESC_PARAM_WB_TYPE		= 0x54,
>   	DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS = 0x55,
>   };
> @@ -313,6 +314,11 @@ enum geometry_desc_param {
>   	GEOMETRY_DESC_PARAM_ENM4_MAX_NUM_UNITS	= 0x3E,
>   	GEOMETRY_DESC_PARAM_ENM4_CAP_ADJ_FCTR	= 0x42,
>   	GEOMETRY_DESC_PARAM_OPT_LOG_BLK_SIZE	= 0x44,
> +	GEOMETRY_DESC_PARAM_WB_MAX_ALLOC_UNITS	= 0x4F,
> +	GEOMETRY_DESC_PARAM_WB_MAX_WB_LUNS	= 0x53,
> +	GEOMETRY_DESC_PARAM_WB_BUFF_CAP_ADJ	= 0x54,
> +	GEOMETRY_DESC_PARAM_WB_SUP_RED_TYPE	= 0x55,
> +	GEOMETRY_DESC_PARAM_WB_SUP_WB_TYPE	= 0x56,
>   };
>   
>   /* Health descriptor parameters offsets in bytes*/
> 
Hi,
Please ignore this patch, I'll send the proper series.


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
