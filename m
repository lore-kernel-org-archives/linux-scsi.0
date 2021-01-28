Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD214C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 03:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A14E360C3D
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 03:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhA1Dfj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 22:35:39 -0500
Received: from a1.mail.mailgun.net ([198.61.254.60]:51026 "EHLO
        a1.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhA1Dfg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 22:35:36 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611804918; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=k799vAWQKhIKDzFLTFOrNxO82k2RAuyDNRkNXxXXN5A=;
 b=lOigCKwb4wo951H1cs7oNrpD8r985p0JGIaKfLm5ivrTlzBUSBJQB8wh4FA+sjtCBZbBJ2/Z
 6B8fVcqODSSZ/lWuwnZ5wp8dp3ZLFW8CJ6Gsju6r3MXzFXyxsn3BLXzgyErDGGDQQbXgCR/A
 +LYpQUsWOzkzOLQV9WN7Bexeb0o=
X-Mailgun-Sending-Ip: 198.61.254.60
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 601230d7d75e1218e355a532 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 28 Jan 2021 03:34:47
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 39673C43462; Thu, 28 Jan 2021 03:34:46 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 565E7C433CA;
        Thu, 28 Jan 2021 03:34:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 Jan 2021 11:34:45 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     jaegeuk@kernel.org, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: Give clk scaling min gear a value
In-Reply-To: <20210128032807.GA5254@yoga>
References: <1611802172-37802-1-git-send-email-cang@codeaurora.org>
 <20210128032807.GA5254@yoga>
Message-ID: <8c0d0edebbfaa0fdd47acb6d180fa84d@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-28 11:28, Bjorn Andersson wrote:
> On Wed 27 Jan 20:49 CST 2021, Can Guo wrote:
> 
>> The initialization of clk_scaling.min_gear was removed by mistake. 
>> This
>> change adds it back, otherwise clock scaling down would fail.
>> 
> 
> Thanks for the patch Can, it solves the problem I'm seeing!
> 
> Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Tested-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> 
> And perhaps a:
> 
> Reported-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 

I missed the two lines due to I was not working on the latest
scsi code tip - I should have tested it based on commit 29b87e92a216
("scsi: ufs: Stop hardcoding the scale down gear"), my bad.

Anyways, thanks for the test!

Regards,
Can Guo.

> Regards,
> Bjorn
> 
>> Fixes: 4543d9d78227 ("scsi: ufs: Refactor 
>> ufshcd_init/exit_clk_scaling/gating()")
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 36bcbb3..8ef6796 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1602,6 +1602,9 @@ static void ufshcd_init_clk_scaling(struct 
>> ufs_hba *hba)
>>  	if (!ufshcd_is_clkscaling_supported(hba))
>>  		return;
>> 
>> +	if (!hba->clk_scaling.min_gear)
>> +		hba->clk_scaling.min_gear = UFS_HS_G1;
>> +
>>  	INIT_WORK(&hba->clk_scaling.suspend_work,
>>  		  ufshcd_clk_scaling_suspend_work);
>>  	INIT_WORK(&hba->clk_scaling.resume_work,
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
>> Linux Foundation Collaborative Project.
>> 
