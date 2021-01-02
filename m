Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D4B1C433DB
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jan 2021 12:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 152D8221F5
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Jan 2021 12:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbhABMat (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 07:30:49 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:30945 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbhABMat (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 07:30:49 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609590626; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Oa6eWAu8hCJdpwRyR6afe1+t/IsPfz5IbNBUNLezFiA=;
 b=YmcWvhSKNfRunexSEjdbl2Lm2BxFdn7GPpyEkavPhpekEG1XoWNE1T22u4oOQ5y6ZPWKoAY0
 ecPaVCPDdWJFsWH1vNGhdoFuBxiC8wyfiTdjSR7BD2Gq/Z5agyVJ3bheeVpkKom4VUJoi65x
 Wes4vOvFMqKsHlLJaqbx9qURsc0=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5ff06745b73be0303d6c9ea6 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 02 Jan 2021 12:29:57
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3F80FC43462; Sat,  2 Jan 2021 12:29:57 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4DAD3C433C6;
        Sat,  2 Jan 2021 12:29:56 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 02 Jan 2021 20:29:56 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
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
Subject: Re: [PATCH v2 1/2] scsi: ufs: Fix a possible NULL pointer issue
In-Reply-To: <7cff30c3-6df8-7b8c-0f5b-a95980b8f706@acm.org>
References: <1609479893-8889-1-git-send-email-cang@codeaurora.org>
 <1609479893-8889-2-git-send-email-cang@codeaurora.org>
 <7cff30c3-6df8-7b8c-0f5b-a95980b8f706@acm.org>
Message-ID: <b2385bdf0ce1ac799ccf77c2e952d9bf@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-02 00:05, Bart Van Assche wrote:
> On 12/31/20 9:44 PM, Can Guo wrote:
>> During system resume/suspend, hba could be NULL. In this case, do not 
>> touch
>> eh_sem.
>> 
>> Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM 
>> events and async scan")
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index e221add..34e2541 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -8896,8 +8896,11 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>>  	int ret = 0;
>>  	ktime_t start = ktime_get();
>> 
>> +	if (!hba)
>> +		return 0;
>> +
>>  	down(&hba->eh_sem);
>> -	if (!hba || !hba->is_powered)
>> +	if (!hba->is_powered)
>>  		return 0;
>> 
>>  	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
>> @@ -8945,10 +8948,8 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>>  	int ret = 0;
>>  	ktime_t start = ktime_get();
>> 
>> -	if (!hba) {
>> -		up(&hba->eh_sem);
>> +	if (!hba)
>>  		return -EINVAL;
>> -	}
>> 
>>  	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
>>  		/*
> 
> Hi Can,
> 
> How can ufshcd_system_suspend() or ufshcd_system_resume() be called 
> with a
> NULL argument? In ufshcd_pci_probe() I see that pci_set_drvdata() is 
> called
> before pm_runtime_allow(). ufshcd_pci_remove() calls 
> pm_runtime_forbid().
> 
> Thanks,
> 
> Bart.

Hi Bart,

You are right about ufshcd_RUNTIME_suspend/resume() - 
platform_set_drvdata()
is called before pm_runtime_enable(), so runtime suspend/resume cannot 
happen
before pm_runtime_enable() is called. We can remove the sanity checks of
!hba there, they are outdated.

But for ufshcd_SYSTEM_suspend/resume() callbacks (not runtime ones), my
understanding is that system suspend/resume may happen after probe 
(vendor
driver probe calls ufshcd_pltfrm_init()) starts but before 
platform_set_drvdata()
is called, in this case hba is NULL.

int ufshcd_pltfrm_init(struct platform_device *pdev,
		       const struct ufs_hba_variant_ops *vops)
{
...
  	platform_set_drvdata(pdev, hba);

	pm_runtime_set_active(&pdev->dev);
	pm_runtime_enable(&pdev->dev);
}

Thanks,

Can Guo.
