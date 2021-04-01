Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1661BC4706C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 17:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BF476138D
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 17:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbhDARpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:45:52 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:63060 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234999AbhDARl6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 13:41:58 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617298917; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=bHbr7KBSlGV8bKA1algZFTTPRBsvH2U+aHDd0G/QszY=;
 b=K+Ib09350xPkGb62RZ6slk8T+V98TuIEXDRv0zAGK67Sv58FODou1Ep8fqi8hp60tG71XvHd
 zebgCQG8XxbpbhZ9qx1wY9VvAHsgo/Vxh7ZStjO5qSsogUCYexxgAOfdZL9TzhGDT72ZCoPo
 9Vi8svAPi7eiy6jX+fiSAW6Cp78=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 6065e0d48166b7eff77a57fd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 01 Apr 2021 15:03:48
 GMT
Sender: nitirawa=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EFE16C43466; Thu,  1 Apr 2021 15:03:47 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nitirawa)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 74421C433CA;
        Thu,  1 Apr 2021 15:03:46 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 01 Apr 2021 20:33:46 +0530
From:   nitirawa@codeaurora.org
To:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Cc:     cang@codeaurora.org, stummala@codeaurora.org,
        vbadigan@codeaurora.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bjorn.andersson@linaro.org,
        adrian.hunter@intel.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        asutoshd=codeaurora.org@codeaurora.org
Subject: Re: [PATCH V2 2/3] scsi: ufs: add a vops to configure VCC voltage
 level
In-Reply-To: <80f681a6-165f-0610-dfea-6b66ce4abddc@codeaurora.org>
References: <1616363857-26760-1-git-send-email-nitirawa@codeaurora.org>
 <1616363857-26760-3-git-send-email-nitirawa@codeaurora.org>
 <80f681a6-165f-0610-dfea-6b66ce4abddc@codeaurora.org>
Message-ID: <0681d6426135afebf4feca549bf0a79c@codeaurora.org>
X-Sender: nitirawa@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-31 23:30, Asutosh Das (asd) wrote:
> On 3/21/2021 2:57 PM, Nitin Rawat wrote:
>> Add a vops to configure VCC voltage VCC voltage level
>> for platform supporting both ufs2.x and ufs 3.x devices.
>> 
>> Suggested-by: Stanley Chu <stanley.chu@mediatek.com>
>> Suggested-by: Asutosh Das <asutoshd@codeaurora.org>
>> Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
>> Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
>> Signed-off-by: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
>> ---
>>   drivers/scsi/ufs/ufshcd.c |  4 ++++
>>   drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
>>   2 files changed, 14 insertions(+)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 633ca8e..5bfe987 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -7763,6 +7763,10 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
>>   		goto out;
>> 
>>   	ufshcd_clear_ua_wluns(hba);
>> +	if (ufshcd_vops_setup_vcc_regulators(hba))
> This would be invoked even for platforms that don't support both 2.x
> and 3.x and don't need to set the voltages in the driver.
> I guess platforms that support both 2.x and 3.x and can't set the
> regulator voltages from dts due to different voltage requirements of
> 2.x and 3.x, should request the driver to set the voltages. And the
> driver may do so after determining the device version.
> 
>> +		dev_err(hba->dev,
>> +			"%s: Failed to set the VCC regulator values, continue with 
>> 2.7v\n",
>> +			__func__);
>> 
>>   	/* Initialize devfreq after UFS device is detected */
>>   	if (ufshcd_is_clkscaling_supported(hba)) {
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> index 0db796a..8f0945d 100644
>> --- a/drivers/scsi/ufs/ufshcd.h
>> +++ b/drivers/scsi/ufs/ufshcd.h
>> @@ -324,6 +324,7 @@ struct ufs_pwr_mode_info {
>>    * @device_reset: called to issue a reset pulse on the UFS device
>>    * @program_key: program or evict an inline encryption key
>>    * @event_notify: called to notify important events
>> + * @setup_vcc_regulators : update vcc regulator level
>>    */
>>   struct ufs_hba_variant_ops {
>>   	const char *name;
>> @@ -360,6 +361,7 @@ struct ufs_hba_variant_ops {
>>   			       const union ufs_crypto_cfg_entry *cfg, int slot);
>>   	void	(*event_notify)(struct ufs_hba *hba,
>>   				enum ufs_event_type evt, void *data);
>> +	int    (*setup_vcc_regulators)(struct ufs_hba *hba);
>>   };
>> 
>>   /* clock gating state  */
>> @@ -1269,6 +1271,14 @@ static inline void 
>> ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
>>   		hba->vops->config_scaling_param(hba, profile, data);
>>   }
>> 
>> +static inline int ufshcd_vops_setup_vcc_regulators(struct ufs_hba 
>> *hba)
>> +{
>> +	if (hba->vops && hba->vops->setup_vcc_regulators)
>> +		return hba->vops->setup_vcc_regulators(hba);
>> +
>> +	return 0;
>> +}
>> +
>>   extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
>> 
>>   /*
>> --
>> 2.7.4
>> 

Hi Asutosh,
Thanks for the suggestion. I will check and try to accommodate your 
suggestion.
Regards,
Nitin
