Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7814C4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 01:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D01E23DE4
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 01:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392514AbgLKBNB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 20:13:01 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:26223 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394530AbgLKBMo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 20:12:44 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607649145; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=cttgESEWFCsZorIB9/3597MAjlCoUbt49Ntrs4a/FsM=;
 b=NQQnJvV5URJlyGq2gEq4kn3xz18YnAwaaW0kfsxmnrR8AF2H1kTVZPbyO0rbcBonL4r5ujVY
 fr7l2BgkKIENmympfUqKikGr/vRjjR5BlRgQT1J9c1QsD9rys8w2HgaDl9fD0ubNx7ZEQnqv
 Py7iFwbcQ/YITFZK0wobW3+8Rxo=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5fd2c75df81e894c552807ca (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 11 Dec 2020 01:11:57
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A61F5C43466; Fri, 11 Dec 2020 01:11:56 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A2989C433C6;
        Fri, 11 Dec 2020 01:11:55 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 11 Dec 2020 09:11:55 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: ufs: Clean up ufshcd_exit_clk_scaling/gating()
In-Reply-To: <f12d2c516d2a038bcc27677d9b982c52d19d5027.camel@gmail.com>
References: <1607520942-22254-1-git-send-email-cang@codeaurora.org>
 <1607520942-22254-3-git-send-email-cang@codeaurora.org>
 <f12d2c516d2a038bcc27677d9b982c52d19d5027.camel@gmail.com>
Message-ID: <cb2a78e46f7f5f57e0bcdb69e11e8e5c@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-11 02:03, Bean Huo wrote:
> On Wed, 2020-12-09 at 05:35 -0800, Can Guo wrote:
>> ufshcd_hba_exit() is always called after ufshcd_exit_clk_scaling()
>> and
>> ufshcd_exit_clk_gating(), so move ufshcd_exit_clk_scaling/gating() to
>> ufshcd_hba_exit().
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 12266bd..41a12d6 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1846,11 +1846,14 @@ static void ufshcd_init_clk_scaling(struct
>> ufs_hba *hba)
>>         snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
>>                  hba->host->host_no);
>>         hba->clk_scaling.workq =
>> create_singlethread_workqueue(wq_name);
>> +
>> +       hba->clk_scaling.is_initialized = true;
>>  }
>> 
>>  static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
>>  {
>> -       if (!ufshcd_is_clkscaling_supported(hba))
>> +       if (!ufshcd_is_clkscaling_supported(hba) ||
>> +           !hba->clk_scaling.is_initialized)
>>                 return;
>> 
>>         if (hba->devfreq)
>> @@ -1894,12 +1897,16 @@ static void ufshcd_init_clk_gating(struct
>> ufs_hba *hba)
>>         hba->clk_gating.enable_attr.attr.mode = 0644;
>>         if (device_create_file(hba->dev, &hba-
>> >clk_gating.enable_attr))
>>                 dev_err(hba->dev, "Failed to create sysfs for
>> clkgate_enable\n");
>> +
>> +       hba->clk_gating.is_initialized = true;
>>  }
> 
> you don't need these two is_initialized at all. they are only be false
> when scaling/gating is not supported??
> 
> Bean

In the case of scaling/gating are supported, the flags are used in
ufshcd_exit_clk_scaling/gating() - when ufshcd_hba_exit() calls
ufshcd_exit_clk_scaling/gating(), the two funcs need to make sure
they really have something to remove, otherwise NULL pointer issues.

Can Guo.
