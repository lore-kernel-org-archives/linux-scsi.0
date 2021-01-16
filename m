Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC068C433E9
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jan 2021 17:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76C7A22C7D
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jan 2021 17:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbhAPR2a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:28:30 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:16033 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbhAPR2a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jan 2021 12:28:30 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610818085; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=0dHu++QekREWKfFB4VSL2SVnCqROQ8FyxEr6561h1QY=;
 b=BZMsKTkywpPF2Iv+9tknCPB+SxRZ/iCksviI9UssxdHKwSAczWwN0RnuviaaXP8gIM9B96gZ
 Rc1zC1Qq768zGBfhd815r5683k4ZOtgc/XzbJw5KcNAGZGHJSms8t2CZkqCVU3W/PCkhSkV2
 AoUXd3XSELGrmu9O5B3rhqGq82U=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 6002e9c97086580d321df903 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 16 Jan 2021 13:27:37
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 76487C43468; Sat, 16 Jan 2021 13:27:36 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0CED5C433C6;
        Sat, 16 Jan 2021 13:27:35 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sat, 16 Jan 2021 21:27:34 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Fix a possible NULL pointer issue
In-Reply-To: <8dea503d-9ab7-c003-9ade-3470def21764@intel.com>
References: <1609479893-8889-1-git-send-email-cang@codeaurora.org>
 <1609479893-8889-2-git-send-email-cang@codeaurora.org>
 <7cff30c3-6df8-7b8c-0f5b-a95980b8f706@acm.org>
 <b2385bdf0ce1ac799ccf77c2e952d9bf@codeaurora.org>
 <204e13398c0b4c3d61786815e757e0bf@codeaurora.org>
 <8dea503d-9ab7-c003-9ade-3470def21764@intel.com>
Message-ID: <154d7c439cc8bca807273f4a40852054@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-15 21:07, Adrian Hunter wrote:
> On 2/01/21 3:10 pm, Can Guo wrote:
>> On 2021-01-02 20:29, Can Guo wrote:
>>> On 2021-01-02 00:05, Bart Van Assche wrote:
>>>> On 12/31/20 9:44 PM, Can Guo wrote:
>>>>> During system resume/suspend, hba could be NULL. In this case, do 
>>>>> not touch
>>>>> eh_sem.
>>>>> 
>>>>> Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM 
>>>>> events
>>>>> and async scan")
>>>>> 
>>>>> Signed-off-by: Can Guo <cang@codeaurora.org>
>>>>> ---
>>>>>  drivers/scsi/ufs/ufshcd.c | 9 +++++----
>>>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>>> 
>>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>>>> index e221add..34e2541 100644
>>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>>> @@ -8896,8 +8896,11 @@ int ufshcd_system_suspend(struct ufs_hba 
>>>>> *hba)
>>>>>      int ret = 0;
>>>>>      ktime_t start = ktime_get();
>>>>> 
>>>>> +    if (!hba)
>>>>> +        return 0;
>>>>> +
>>>>>      down(&hba->eh_sem);
>>>>> -    if (!hba || !hba->is_powered)
>>>>> +    if (!hba->is_powered)
>>>>>          return 0;
>>>>> 
>>>>>      if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
>>>>> @@ -8945,10 +8948,8 @@ int ufshcd_system_resume(struct ufs_hba 
>>>>> *hba)
>>>>>      int ret = 0;
>>>>>      ktime_t start = ktime_get();
>>>>> 
>>>>> -    if (!hba) {
>>>>> -        up(&hba->eh_sem);
>>>>> +    if (!hba)
>>>>>          return -EINVAL;
>>>>> -    }
>>>>> 
>>>>>      if (!hba->is_powered || pm_runtime_suspended(hba->dev))
>>>>>          /*
>>>> 
>>>> Hi Can,
>>>> 
>>>> How can ufshcd_system_suspend() or ufshcd_system_resume() be called 
>>>> with a
>>>> NULL argument? In ufshcd_pci_probe() I see that pci_set_drvdata() is 
>>>> called
>>>> before pm_runtime_allow(). ufshcd_pci_remove() calls 
>>>> pm_runtime_forbid().
>>>> 
>>>> Thanks,
>>>> 
>>>> Bart.
>>> 
>>> Hi Bart,
>>> 
>>> You are right about ufshcd_RUNTIME_suspend/resume() - 
>>> platform_set_drvdata()
>>> is called before pm_runtime_enable(), so runtime suspend/resume 
>>> cannot happen
>>> before pm_runtime_enable() is called. We can remove the sanity checks 
>>> of
>>> !hba there, they are outdated.
>> 
>> Add more history here - before Stanley's change (see below),
>> platform_set_drvdata()
>> is called AFTER pm_runtime_enable(), which was why we needed sanity 
>> checks
>> of !hba.
>> But now the sanity checks are unnecessary in
>> ufshcd_RUNTIME_suspend/resume(), so
>> feel free to remove them.
>> 
>> But still, things are a bit different for 
>> ufshcd_SYSTEM_suspend/resume(), we
>> need
>> the sanity checks of !hba there if my understanding is correct.
>> 
>> commit 24e2e7a19f7e4b83d0d5189040d997bce3596473
>> Author: Stanley Chu <stanley.chu@mediatek.com>
>> Date:   Wed Jun 12 23:19:05 2019 +0800
>> 
>>     scsi: ufs: Avoid runtime suspend possibly being blocked forever
>> 
>> Thanks,
>> Can Guo.
>> 
>>> 
>>> But for ufshcd_SYSTEM_suspend/resume() callbacks (not runtime ones), 
>>> my
>>> understanding is that system suspend/resume may happen after probe 
>>> (vendor
>>> driver probe calls ufshcd_pltfrm_init()) starts but before
>>> platform_set_drvdata()
>>> is called, in this case hba is NULL.
>>> 
>>> int ufshcd_pltfrm_init(struct platform_device *pdev,
>>>                const struct ufs_hba_variant_ops *vops)
>>> {
>>> ...
>>>      platform_set_drvdata(pdev, hba);
>>> 
>>>     pm_runtime_set_active(&pdev->dev);
>>>     pm_runtime_enable(&pdev->dev);
>>> }
> 
> Hi Can
> 
> I expect probe and system suspend are synchronized e.g. by 
> device_lock(), so
> hba would not be NULL.  Is there any example of it being NULL in system 
> suspend?
> 
> Regards
> Adrian

Hi Adrian,

Thanks for the remind - I didn't notice they are protected by 
device_lock().
You are right, hba cannot be NULL in current code... Maybe if (!hba) was
there just for a sanity check. I will make a change to remove these 
checks.

Thanks,
Can Guo.
