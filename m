Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7050CC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 06:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28DFF23331
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 06:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgLVGNk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 01:13:40 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:14823 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgLVGNj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 01:13:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608617599; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=bTzOEAjYYkkK45qiQFIpzidx0Vu7oEn/P14qlsljJoE=;
 b=ghEr6ZHWIvW0Xs1ittDnScPaXFfQx7kpx3bjtmgyV4UYHAlKTYFFR8DjJBmujdNE1f/QRJqG
 eXF4WyBbvE0ESCsgcXNIqMrQRDrZC6sInF3nkI6f+DmmB4cfUe5O/98KJKcMOOUH2s0hntKp
 qbrwBbZ73c3Lh+CrkvV/dMSdCgg=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fe18e636d011aad6617394e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 22 Dec 2020 06:12:51
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0665AC433CA; Tue, 22 Dec 2020 06:12:51 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3E7C1C433C6;
        Tue, 22 Dec 2020 06:12:49 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 22 Dec 2020 14:12:49 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/7] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
In-Reply-To: <1608617307.14045.3.camel@mtkswgap22>
References: <20201215230519.15158-1-huobean@gmail.com>
 <20201215230519.15158-2-huobean@gmail.com>
 <1608617307.14045.3.camel@mtkswgap22>
Message-ID: <a01cdd4ff6afd2a9166741caed3c2b3d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-22 14:08, Stanley Chu wrote:
> Hi Bean,
> 
> On Wed, 2020-12-16 at 00:05 +0100, Bean Huo wrote:
>> From: Bean Huo <beanhuo@micron.com>
>> 
>> Currently UFS WriteBooster driver uses clock scaling up/down to set
>> WB on/off, for the platform which doesn't support 
>> UFSHCD_CAP_CLK_SCALING,
>> WB will be always on. Provide a sysfs attribute to enable/disable WB
>> during runtime. Write 1/0 to "wb_on" sysfs node to enable/disable UFS 
>> WB.
>> 
>> Reviewed-by: Avri Altman <avri.altman@wdc.com>
>> Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
>> Signed-off-by: Bean Huo <beanhuo@micron.com>
>> ---
>>  drivers/scsi/ufs/ufs-sysfs.c | 41 
>> ++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/ufs/ufshcd.c    |  3 +--
>>  drivers/scsi/ufs/ufshcd.h    |  2 ++
>>  3 files changed, 44 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufs-sysfs.c 
>> b/drivers/scsi/ufs/ufs-sysfs.c
>> index 08e72b7eef6a..f3ca3d6b82c4 100644
>> --- a/drivers/scsi/ufs/ufs-sysfs.c
>> +++ b/drivers/scsi/ufs/ufs-sysfs.c
>> @@ -189,6 +189,45 @@ static ssize_t auto_hibern8_store(struct device 
>> *dev,
>>  	return count;
>>  }
>> 
>> +static ssize_t wb_on_show(struct device *dev, struct device_attribute 
>> *attr,
>> +			  char *buf)
>> +{
>> +	struct ufs_hba *hba = dev_get_drvdata(dev);
>> +
>> +	return sysfs_emit(buf, "%d\n", hba->wb_enabled);
>> +}
>> +
>> +static ssize_t wb_on_store(struct device *dev, struct 
>> device_attribute *attr,
>> +			   const char *buf, size_t count)
>> +{
>> +	struct ufs_hba *hba = dev_get_drvdata(dev);
>> +	unsigned int wb_enable;
>> +	ssize_t res;
>> +
>> +	if (ufshcd_is_clkscaling_supported(hba)) {
>> +		/*
>> +		 * If the platform supports UFSHCD_CAP_CLK_SCALING, turn WB
>> +		 * on/off will be done while clock scaling up/down.
>> +		 */
>> +		dev_warn(dev, "To control WB through wb_on is not allowed!\n");
>> +		return -EOPNOTSUPP;
>> +	}
>> +	if (!ufshcd_is_wb_allowed(hba))
>> +		return -EOPNOTSUPP;
>> +
>> +	if (kstrtouint(buf, 0, &wb_enable))
>> +		return -EINVAL;
>> +
>> +	if (wb_enable != 0 && wb_enable != 1)
>> +		return -EINVAL;
>> +
>> +	pm_runtime_get_sync(hba->dev);
>> +	res = ufshcd_wb_ctrl(hba, wb_enable);
> 
> May this operation race with UFS shutdown flow?
> 
> To be more clear, ufshcd_wb_ctrl() here may be executed after host 
> clock
> is disabled by shutdown flow?
> 
> If yes, we need to avoid it.

I have the same doubt - can user still access sysfs nodes after system
starts to run shutdown routines? If yes, then we need to remove all UFS
sysfs nodes in ufshcd_shutdown().

Thanks,

Can Guo.

> 
> Thanks,
> Stanley Chu
> 
>> +	pm_runtime_put_sync(hba->dev);
>> +
>> +	return res < 0 ? res : count;
>> +}
>> +
>>  static DEVICE_ATTR_RW(rpm_lvl);
>>  static DEVICE_ATTR_RO(rpm_target_dev_state);
>>  static DEVICE_ATTR_RO(rpm_target_link_state);
>> @@ -196,6 +235,7 @@ static DEVICE_ATTR_RW(spm_lvl);
>>  static DEVICE_ATTR_RO(spm_target_dev_state);
>>  static DEVICE_ATTR_RO(spm_target_link_state);
>>  static DEVICE_ATTR_RW(auto_hibern8);
>> +static DEVICE_ATTR_RW(wb_on);
>> 
>>  static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
>>  	&dev_attr_rpm_lvl.attr,
>> @@ -205,6 +245,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] 
>> = {
>>  	&dev_attr_spm_target_dev_state.attr,
>>  	&dev_attr_spm_target_link_state.attr,
>>  	&dev_attr_auto_hibern8.attr,
>> +	&dev_attr_wb_on.attr,
>>  	NULL
>>  };
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index e221add25a7e..5e1dcf4de67e 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -246,7 +246,6 @@ static inline int ufshcd_config_vreg_hpm(struct 
>> ufs_hba *hba,
>>  static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
>>  static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
>>  static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
>> -static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
>>  static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool 
>> set);
>>  static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool 
>> enable);
>>  static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
>> @@ -5351,7 +5350,7 @@ static void 
>> ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
>>  				__func__, err);
>>  }
>> 
>> -static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
>> +int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
>>  {
>>  	int ret;
>>  	u8 index;
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 9bb5f0ed4124..2a97006a2c93 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -1068,6 +1068,8 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba 
>> *hba,
>>  			     u8 *desc_buff, int *buff_len,
>>  			     enum query_opcode desc_op);
>> 
>> +int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
>> +
>>  /* Wrapper functions for safely calling variant operations */
>>  static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
>>  {
