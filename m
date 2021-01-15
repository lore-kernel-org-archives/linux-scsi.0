Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1F0C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 13:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE2BC23136
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 13:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732297AbhAONIN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 08:08:13 -0500
Received: from mga12.intel.com ([192.55.52.136]:30033 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731957AbhAONIM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Jan 2021 08:08:12 -0500
IronPort-SDR: FXqdTMvEsB93t+kcUR+4gI49aL9UY1mLGegMDCg2VPphywYKtTytvpOLEEprFnuKV7CbKD+7x0
 ZwXQZ1zxmsKg==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="157724043"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="157724043"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 05:07:31 -0800
IronPort-SDR: 6YR778+hus2fU+STJcThOeRRIhWnhQOy3bMSti4spS1Bi8wSghUjWZHFSBgH0DeF2nXcMyH6ya
 bd1FvZt8ozZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="354299548"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.149]) ([10.237.72.149])
  by fmsmga008.fm.intel.com with ESMTP; 15 Jan 2021 05:07:26 -0800
Subject: Re: [PATCH v2 1/2] scsi: ufs: Fix a possible NULL pointer issue
To:     Can Guo <cang@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1609479893-8889-1-git-send-email-cang@codeaurora.org>
 <1609479893-8889-2-git-send-email-cang@codeaurora.org>
 <7cff30c3-6df8-7b8c-0f5b-a95980b8f706@acm.org>
 <b2385bdf0ce1ac799ccf77c2e952d9bf@codeaurora.org>
 <204e13398c0b4c3d61786815e757e0bf@codeaurora.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <8dea503d-9ab7-c003-9ade-3470def21764@intel.com>
Date:   Fri, 15 Jan 2021 15:07:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <204e13398c0b4c3d61786815e757e0bf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/01/21 3:10 pm, Can Guo wrote:
> On 2021-01-02 20:29, Can Guo wrote:
>> On 2021-01-02 00:05, Bart Van Assche wrote:
>>> On 12/31/20 9:44 PM, Can Guo wrote:
>>>> During system resume/suspend, hba could be NULL. In this case, do not touch
>>>> eh_sem.
>>>>
>>>> Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM events
>>>> and async scan")
>>>>
>>>> Signed-off-by: Can Guo <cang@codeaurora.org>
>>>> ---
>>>>  drivers/scsi/ufs/ufshcd.c | 9 +++++----
>>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>>> index e221add..34e2541 100644
>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>> @@ -8896,8 +8896,11 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>>>>      int ret = 0;
>>>>      ktime_t start = ktime_get();
>>>>
>>>> +    if (!hba)
>>>> +        return 0;
>>>> +
>>>>      down(&hba->eh_sem);
>>>> -    if (!hba || !hba->is_powered)
>>>> +    if (!hba->is_powered)
>>>>          return 0;
>>>>
>>>>      if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
>>>> @@ -8945,10 +8948,8 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>>>>      int ret = 0;
>>>>      ktime_t start = ktime_get();
>>>>
>>>> -    if (!hba) {
>>>> -        up(&hba->eh_sem);
>>>> +    if (!hba)
>>>>          return -EINVAL;
>>>> -    }
>>>>
>>>>      if (!hba->is_powered || pm_runtime_suspended(hba->dev))
>>>>          /*
>>>
>>> Hi Can,
>>>
>>> How can ufshcd_system_suspend() or ufshcd_system_resume() be called with a
>>> NULL argument? In ufshcd_pci_probe() I see that pci_set_drvdata() is called
>>> before pm_runtime_allow(). ufshcd_pci_remove() calls pm_runtime_forbid().
>>>
>>> Thanks,
>>>
>>> Bart.
>>
>> Hi Bart,
>>
>> You are right about ufshcd_RUNTIME_suspend/resume() - platform_set_drvdata()
>> is called before pm_runtime_enable(), so runtime suspend/resume cannot happen
>> before pm_runtime_enable() is called. We can remove the sanity checks of
>> !hba there, they are outdated.
> 
> Add more history here - before Stanley's change (see below),
> platform_set_drvdata()
> is called AFTER pm_runtime_enable(), which was why we needed sanity checks
> of !hba.
> But now the sanity checks are unnecessary in
> ufshcd_RUNTIME_suspend/resume(), so
> feel free to remove them.
> 
> But still, things are a bit different for ufshcd_SYSTEM_suspend/resume(), we
> need
> the sanity checks of !hba there if my understanding is correct.
> 
> commit 24e2e7a19f7e4b83d0d5189040d997bce3596473
> Author: Stanley Chu <stanley.chu@mediatek.com>
> Date:   Wed Jun 12 23:19:05 2019 +0800
> 
>     scsi: ufs: Avoid runtime suspend possibly being blocked forever
> 
> Thanks,
> Can Guo.
> 
>>
>> But for ufshcd_SYSTEM_suspend/resume() callbacks (not runtime ones), my
>> understanding is that system suspend/resume may happen after probe (vendor
>> driver probe calls ufshcd_pltfrm_init()) starts but before
>> platform_set_drvdata()
>> is called, in this case hba is NULL.
>>
>> int ufshcd_pltfrm_init(struct platform_device *pdev,
>>                const struct ufs_hba_variant_ops *vops)
>> {
>> ...
>>      platform_set_drvdata(pdev, hba);
>>
>>     pm_runtime_set_active(&pdev->dev);
>>     pm_runtime_enable(&pdev->dev);
>> }

Hi Can

I expect probe and system suspend are synchronized e.g. by device_lock(), so
hba would not be NULL.  Is there any example of it being NULL in system suspend?

Regards
Adrian
