Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2000C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 06:53:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F73E22CA2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 06:53:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391473AbhALGxB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 01:53:01 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:12655 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbhALGxB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 01:53:01 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610434361; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=AMekzKIoXfjswvih+CfUuEZfypT+jF7HVNK0MT9+CpY=;
 b=mhH8Jbfm1Y6nfG05hHSJKvHoBzTvL2/pfWSkVV5UOYhLOwNfIEb5bmHgEGfkt7MXQHmcWALZ
 0a9TV3/roL/bZok11LEcV7/eM+eSEi9sSny5S/Xjue3UTbChG7cg+XJEVvOhIhENALcx5tuT
 F/coySe562y+0kfjr9Y/jX9FjIQ=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5ffd471ef1be2d22c46eb43b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 12 Jan 2021 06:52:14
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 032EAC43463; Tue, 12 Jan 2021 06:52:13 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2FBACC433CA;
        Tue, 12 Jan 2021 06:52:13 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 12 Jan 2021 14:52:13 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] scsi: ufs: Fix a possible NULL pointer issue
In-Reply-To: <1610433327.17820.5.camel@mtkswgap22>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
 <1609595975-12219-2-git-send-email-cang@codeaurora.org>
 <1610433327.17820.5.camel@mtkswgap22>
Message-ID: <6d03cdacda2f757ba0d0f39ce625eaec@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-12 14:35, Stanley Chu wrote:
> Hi Can,
> 
> On Sat, 2021-01-02 at 05:59 -0800, Can Guo wrote:
>> During system resume/suspend, hba could be NULL. In this case, do not 
>> touch
>> eh_sem.
>> 
>> Fixes: 88a92d6ae4fe ("scsi: ufs: Serialize eh_work with system PM 
>> events and async scan")
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index e221add..9829c8d 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -94,6 +94,8 @@
>>  		       16, 4, buf, __len, false);                        \
>>  } while (0)
>> 
>> +static bool early_suspend;
>> +
>>  int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
>>  		     const char *prefix)
>>  {
>> @@ -8896,8 +8898,14 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
>>  	int ret = 0;
>>  	ktime_t start = ktime_get();
>> 
>> +	if (!hba) {
>> +		early_suspend = true;
>> +		return 0;
>> +	}
>> +
>>  	down(&hba->eh_sem);
>> -	if (!hba || !hba->is_powered)
>> +
>> +	if (!hba->is_powered)
>>  		return 0;
>> 
>>  	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
>> @@ -8945,9 +8953,12 @@ int ufshcd_system_resume(struct ufs_hba *hba)
>>  	int ret = 0;
>>  	ktime_t start = ktime_get();
>> 
>> -	if (!hba) {
>> -		up(&hba->eh_sem);
>> +	if (!hba)
>>  		return -EINVAL;
>> +
>> +	if (unlikely(early_suspend)) {
>> +		early_suspend = false;
>> +		down(&hba->eh_sem);
>>  	}
> 
> I guess early_suspend here is to handle the case that hba is null 
> during
> ufshcd_system_suspend() but !null during ufshcd_system_resume(). If 
> yes,
> would it be possible? If no, may I know what is the purpose?
> 

Yes, you are right. I think it is possible. platform_set_drvdata()
is called in ufshcd_pltfrm_init(). Say suspend happens before
platform_set_drvdata() is called, but resume comes back after
platform_set_drvdata() is called. What do you think?

Thanks,
Can Guo.

> Thanks a lot.
> Stanley Chu
> 
>> 
>>  	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
