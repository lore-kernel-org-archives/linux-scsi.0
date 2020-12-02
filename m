Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E2BC64E7B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 17:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2537221FA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 17:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730910AbgLBR7X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:59:23 -0500
Received: from a2.mail.mailgun.net ([198.61.254.61]:62716 "EHLO
        a2.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730905AbgLBR7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 12:59:22 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606931941; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=d20BTJhJuOfIeJ6dTfjs7Aw/4YtAMOVaiif/uqb3Chc=; b=wLnrCuuO+2RnZfg8i/LovmDn2ERLy4Oau8GybMtjdku+8SWuU/1Hiflfpr/y/VWVvCr6xyg2
 c+yqu+MrbbryBg4ePXMaIaV0AoxIwhWFHM/EDZ0f2r8ZY193DIzLSbmaGfhYazXgTF/dbsC1
 F+Ln+Q7DWv0MLu0Egq1VbqJBGPA=
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5fc7d5c97edc97d061e452c5 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 02 Dec 2020 17:58:33
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AA702C43469; Wed,  2 Dec 2020 17:58:31 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 121FBC43461;
        Wed,  2 Dec 2020 17:58:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 121FBC43461
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH 1/3] scsi: ufs: Add "wb_on" sysfs node to control WB
 on/off
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201130181143.5739-1-huobean@gmail.com>
 <20201130181143.5739-2-huobean@gmail.com>
 <2a380908-3eb4-2cdc-4156-03e8946ffd88@codeaurora.org>
 <30767ee7973670b86bff61d1d7b2044f17640b75.camel@gmail.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <64458f93-55ed-ae62-e7c2-d4c54721b2b1@codeaurora.org>
Date:   Wed, 2 Dec 2020 09:58:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <30767ee7973670b86bff61d1d7b2044f17640b75.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/2/2020 8:20 AM, Bean Huo wrote:
> On Mon, 2020-11-30 at 15:19 -0800, Asutosh Das (asd) wrote:
>>> +             return -EINVAL;
>>> +
>>> +     pm_runtime_get_sync(hba->dev);
>>> +     res = ufshcd_wb_ctrl(hba, wb_enable);
>>
>> Say, a platform supports clock-scaling and this bit is toggled.
>> The control goes into ufshcd_wb_ctrl for both this sysfs and
>> clock-scaling contexts. The clock-scaling context passes all checks
>> and
>> blocks on waiting for this wb control to be disabled and then tries
>> to
>> enable wb when it's already disabled. Perhaps that's a race there?
> 
> Hi Asutosh
> Appreciate your review.
> There is only inconsistent problem between clock-scaling and sysfs,
> since hba->dev_cmd.lock can garantee there is only one can change
> fWriteBoosterEn. But this is only happening on user willfully wants to
> control WB through sysfs even they know the platform supports clock-
> scaling.
> 
> Since this is for the platform which doesn't support clock-scaling, I
> think based on your comments, it should be acceptable for you like
> this:

Or a synchronization primitive b/w the 2 contexts would work just as 
well. However, I don't have an issue if the user is denied toggling of 
wb anyway. LGTM.

> 
> 
> +static ssize_t wb_on_store(struct device *dev, struct device_attribute
> *attr,
> +                          const char *buf, size_t count)
> +{
> +       struct ufs_hba *hba = dev_get_drvdata(dev);
> +       unsigned int wb_enable;
> +       ssize_t res;
> +
> +       if (ufshcd_is_clkscaling_supported(hba)) {
> +          dev_err(dev, "supports dynamic clk scaling, control WB
> +                       through sysfs is not allowed!");
> +          return -EOPNOTSUPP;
> +       }
> +       if (!ufshcd_is_wb_allowed(hba))
> +               return -EOPNOTSUPP;
> +
> +       if (kstrtouint(buf, 0, &wb_enable))
> +               return -EINVAL;
> +
> +       if (wb_enable != 0 && wb_enable != 1)
> +               return -EINVAL;
> +
> +       pm_runtime_get_sync(hba->dev);
> +       res = ufshcd_wb_ctrl(hba, wb_enable);
> +       pm_runtime_put_sync(hba->dev);
> +
> +       return res < 0 ? res : count;
> +}
> 
> thanks,
> Bean
> 
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
