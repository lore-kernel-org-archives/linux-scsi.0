Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE43C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 16:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E56DD20671
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 16:59:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ZxaFO0T6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgENQ7n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 12:59:43 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:54534 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbgENQ7m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 May 2020 12:59:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589475581; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=0otaf4UY3NXJ4Hsxvlo2D2szfdAn1HRad9eqi5t7VMo=; b=ZxaFO0T6HEPTFk8jz1qdEfcb59zEZLd5mOHn/ZhlJjPrq6Qbaf2aJV56SDM+Tvwcf9QtFPSa
 Ck8WvNEQ4YSFhiyxg/KGKGmD3XfXoUSSGCoBS1TzIP1WpeUA9Q5tA3Nt35n8mIp4Ld/gosEJ
 hl/EQVVTlJy8ETpyScLuf1yDX/o=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ebd78ed.7f4c77718ea0-smtp-out-n01;
 Thu, 14 May 2020 16:59:25 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DD954C433F2; Thu, 14 May 2020 16:59:22 +0000 (UTC)
Received: from [192.168.8.150] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 441F1C433F2;
        Thu, 14 May 2020 16:59:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 441F1C433F2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1 4/4] scsi: ufs: Fix WriteBooster flush during runtime
 suspend
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "Andy Teng ($B{}G!9((B)" <Andy.Teng@mediatek.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        =?UTF-8?B?S3VvaG9uZyBXYW5nICjnjovlnIvptLsp?= 
        <kuohong.wang@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>
References: <20200512104750.8711-1-stanley.chu@mediatek.com>
 <20200512104750.8711-5-stanley.chu@mediatek.com>
 <725d057c-2379-710e-287f-ac11a59c08bc@codeaurora.org>
 <1589423030.3197.94.camel@mtkswgap22> <1589467766.3197.100.camel@mtkswgap22>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <f26eec65-7591-fd98-bd17-d90267333637@codeaurora.org>
Date:   Thu, 14 May 2020 09:59:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589467766.3197.100.camel@mtkswgap22>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/14/2020 7:49 AM, Stanley Chu wrote:
> Hi Asutosh,
> 
> On Thu, 2020-05-14 at 10:23 +0800, Stanley Chu wrote:
>> Hi Asutosh,
>>
>> On Wed, 2020-05-13 at 12:31 -0700, Asutosh Das (asd) wrote:
>>> On 5/12/2020 3:47 AM, Stanley Chu wrote:
>>>> Currently UFS host driver promises VCC supply if UFS device
>>>> needs to do WriteBooster flush during runtime suspend.
>>>>
>>>> However the UFS specification mentions,
>>>>
>>>> "While the flushing operation is in progress, the device is
>>>> in Active power mode."
>>>>
>>>> Therefore UFS host driver needs to promise more: Keep UFS
>>>> device as "Active power mode", otherwise UFS device shall not
>>>> do any flush if device enters Sleep or PowerDown power mode.
>>>>
>>>> Fix this by not changing device power mode if WriteBooster
>>>> flush is required in ufshcd_suspend().
>>>>
>>>> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
>>>> ---
>>>>    drivers/scsi/ufs/ufs.h    |  1 -
>>>>    drivers/scsi/ufs/ufshcd.c | 39 +++++++++++++++++++--------------------
>>>>    2 files changed, 19 insertions(+), 21 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
>>>> index b3135344ab3f..9e4bc2e97ada 100644
>>>> --- a/drivers/scsi/ufs/ufs.h
>>>> +++ b/drivers/scsi/ufs/ufs.h
>>>> @@ -577,7 +577,6 @@ struct ufs_dev_info {
>>>>    	u32 d_ext_ufs_feature_sup;
>>>>    	u8 b_wb_buffer_type;
>>>>    	u32 d_wb_alloc_units;
>>>> -	bool keep_vcc_on;
>>>>    	u8 b_presrv_uspc_en;
>>>>    };
>>>>    
>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>>> index 169a3379e468..2d0aff8ac260 100644
>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>> @@ -8101,8 +8101,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
>>>>    	    !hba->dev_info.is_lu_power_on_wp) {
>>>>    		ufshcd_setup_vreg(hba, false);
>>>>    	} else if (!ufshcd_is_ufs_dev_active(hba)) {
>>>> -		if (!hba->dev_info.keep_vcc_on)
>>>> -			ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
>>>> +		ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
>>>>    		if (!ufshcd_is_link_active(hba)) {
>>>>    			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq);
>>>>    			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq2);
>>>> @@ -8172,6 +8171,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>>>>    	enum ufs_pm_level pm_lvl;
>>>>    	enum ufs_dev_pwr_mode req_dev_pwr_mode;
>>>>    	enum uic_link_state req_link_state;
>>>> +	bool keep_curr_dev_pwr_mode = false;
>>>>    
>>>>    	hba->pm_op_in_progress = 1;
>>>>    	if (!ufshcd_is_shutdown_pm(pm_op)) {
>>>> @@ -8226,28 +8226,27 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>>>>    			/* make sure that auto bkops is disabled */
>>>>    			ufshcd_disable_auto_bkops(hba);
>>>>    		}
>>>> +
>>> Unnecessary newline, perhaps?
>>
>> Yap, I will remove it in next version.
>>
>>>>    		/*
>>>> -		 * With wb enabled, if the bkops is enabled or if the
>>>> -		 * configured WB type is 70% full, keep vcc ON
>>>> -		 * for the device to flush the wb buffer
>>>> +		 * If device needs to do BKOP or WB buffer flush, keep device
>>>> +		 * power mode as "active power mode" and its VCC supply.
>>>>    		 */
>>>> -		if ((hba->auto_bkops_enabled && ufshcd_is_wb_allowed(hba)) ||
>>>> -		    ufshcd_wb_keep_vcc_on(hba))
>>>> -			hba->dev_info.keep_vcc_on = true;
>>>> -		else
>>>> -			hba->dev_info.keep_vcc_on = false;
>>>> -	} else {
>>>> -		hba->dev_info.keep_vcc_on = false;
>>>> +		keep_curr_dev_pwr_mode = hba->auto_bkops_enabled ||
>>>> +			ufshcd_wb_keep_vcc_on(hba);
>>> Should the device be in UFS_ACTIVE_PWR_MODE to perform auto-bkops?
>>>
>>> Also, is it needed to keep the device in UFS_ACTIVE_PWR_MODE , if flush
>>> on hibern8 is enabled and the link is being put to hibern8 mode during
>>> runtime-suspend? Perhaps that should also be factored in here?
>>
>> Both auto-bkops and WriteBooster flush during Hibern8 need device power
>> mode to be "Active Power Mode".
>>
>> For auto-bkops, the spec mentions,
>>
>> "If the background operations enable bit is set and the device is in
>> Active power mode or Idle power mode, then the device is allowed to
>> execute any internal operations."
>>
>> For WriteBooster flush during Hibern8, the spec mentions,
>>
>> "While the flushing operation is in progress, the device is in Active
>> power mode."
>>
>> Therefore here we can use an unified "keep_curr_dev_pwr_mode" to
>> indicate the same requirements of above both features.
>>
>> Besides, both operations may access flash array inside UFS device thus
>> VCC supply shall be also kept.
>>
>> Before this patch, the original code will keep device power mode (stay
>> in Active Power Mode) if hba->auto_bkops_enabled is set as true during
>> runtime-suspend with UFSHCD_CAP_AUTO_BKOPS_SUSPEND capability is
>> enabled. This patch will not change this decision, just add
>> "WriteBooster flush during Hibern8" feature as another condition to do
>> so.
>>
>> Thank you so much to remind me that "Link shall be put in Hibern8" is a
>> necessary condition for "WriteBooster flush during Hibern8". I will add
>> more checking for keep_curr_dev_pwr_mode to prevent unnecessary power
>> drain.
>>
>>>>    	}
>>>>    
>>>> -	if ((req_dev_pwr_mode != hba->curr_dev_pwr_mode) &&
>>>> -	    ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
>>>> -	    !ufshcd_is_runtime_pm(pm_op))) {
>>>> -		/* ensure that bkops is disabled */
>>>> -		ufshcd_disable_auto_bkops(hba);
>>>> -		ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
>>>> -		if (ret)
>>>> -			goto enable_gating;
>>>> +	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
>>>> +		if ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled) ||
>>>> +		    !ufshcd_is_runtime_pm(pm_op)) {
>>>> +			/* ensure that bkops is disabled */
>>>> +			ufshcd_disable_auto_bkops(hba);
>>>> +		}
>>>> +
>>>> +		if (!keep_curr_dev_pwr_mode) {
>>>> +			ret = ufshcd_set_dev_pwr_mode(hba, req_dev_pwr_mode);
>>>
>>> Now, when the WB buffer is completely flushed out, the device should be
>>> put back into UFS_SLEEP_PWR_MODE or UFS_POWERDOWN_PWR_MODE. Say, the
>>> device buffer has to be flushed and during runtime-suspend, the device
>>> is put to UFS_ACTIVE_PWR_MODE and Vcc is kept ON; the device doesn't
>>> resume nor does the system enters suspend for a very long time, and with
>>> AH8 and hibern8 disabled, there will be an unnecessary power drain for
>>> that much time.
> 
> Another thought is that if keep_curr_dev_pwr_mode will be set as true
> only if link is put in Hibern8 or Auto-Hibern8 is enabled. By this way,
> the power consumption shall be very small after flush or auto-bkop is
> finished.
> 
> Then the checking of flush status during runtime-suspend may be not
> necessary.
> 
>>>
>>> How about a periodic interval checking of flush status if
>>> keep_curr_dev_pwr_mode evaluates to be true?
>>
>> This is a good point!
>>
>> The same thing also happens for auto-bkops. How about add a timer to
>> leave runtime suspend if keep_curr_dev_pwr_mode is set as true? This is
>> simple and also favors power. The timeout value could be adjustable
>> according to the available WriteBooster buffer size.
>>
>> A periodic interval checking of flush status needs to re-activate link
>> to communicate with the device. This would be tricky and the
>> re-activation flow is just like runtime-resume.
>>
>> What would you think?
>>
>> Thanks.
>> Stanley Chu
>>
>>
>> _______________________________________________
>> Linux-mediatek mailing list
>> Linux-mediatek@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-mediatek
> 

Hi Stanley,
I think that'd work, but there's definitely a penalty of keeping Vcc ON.
And if we do want to keep it ON, then we'd have to measure how much 
excess power is being used - after the flush is done.

I think setting keep_curr_dev_pwr_mode to true iff h8 and ah8 are 
enabled is a good idea. In addition to that, adding a timer to check 
flush status if keep_curr_dev_pwr_mode is set to true would keep the 
power consumption to a minimum. So I suggest to have the delayed check 
of flush status as well.

Thanks,
-asd

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
