Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3288C0018C
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 01:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD95C23E51
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 01:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389972AbgLKBhc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 20:37:32 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:41470 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389890AbgLKBh2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 20:37:28 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607650630; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=erGP85vPnx/33AtB9CxsMeeaBBxhhifeDpOU4ZgSoBM=;
 b=n5iGtoFuREPz3h+/OIjbFvm3SsI9psdBcPwavfIsXlCGNTV2mLA0m4EjQQoq0r10cSA+xXM+
 0MuMcm+bfRqn+wweX7JtohAnwMeE40JNF2NQ4wK4sRPdMt19spHNBbotc2ARJRuJZLdMy/9U
 1v5xP5z0XgPTxIxvICgz6tXrOOI=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 5fd2cd2965f116f287535053 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 11 Dec 2020 01:36:41
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 899E9C43466; Fri, 11 Dec 2020 01:36:41 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A7827C433CA;
        Fri, 11 Dec 2020 01:36:40 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 11 Dec 2020 09:36:40 +0800
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
Subject: Re: [PATCH 1/2] scsi: ufs: Protect some contexts from unexpected
 clock scaling
In-Reply-To: <a2338ef6da3d4ed4093547ba87e13e94d8dd2a45.camel@gmail.com>
References: <1607520942-22254-1-git-send-email-cang@codeaurora.org>
 <1607520942-22254-2-git-send-email-cang@codeaurora.org>
 <a2338ef6da3d4ed4093547ba87e13e94d8dd2a45.camel@gmail.com>
Message-ID: <48363aee8a746a43440f86f620d9d2e0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-11 01:34, Bean Huo wrote:
> Hi Can
> 
> On Wed, 2020-12-09 at 05:35 -0800, Can Guo wrote:
>> 
>> 
>> @@ -1160,6 +1166,7 @@ static void
>> ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
>>  {
>>  	up_write(&hba->clk_scaling_lock);
>>  	ufshcd_scsi_unblock_requests(hba);
>> +	ufshcd_release(hba);
>>  }
>> 
>>  /**
>> @@ -1175,12 +1182,9 @@ static int ufshcd_devfreq_scale(struct ufs_hba
>> *hba, bool scale_up)
>>  {
>>  	int ret = 0;
>> 
>> -	/* let's not get into low power until clock scaling is
>> completed */
>> -	ufshcd_hold(hba, false);
>> -
>>  	ret = ufshcd_clock_scaling_prepare(hba);
>>  	if (ret)
>> -		goto out;
>> +		return ret;
>> 
>>  	/* scale down the gear before scaling down clocks */
>>  	if (!scale_up) {
>> @@ -1212,8 +1216,6 @@ static int ufshcd_devfreq_scale(struct ufs_hba
>> *hba, bool scale_up)
>> 
>>  out_unprepare:
>>  	ufshcd_clock_scaling_unprepare(hba);
>> -out:
>> -	ufshcd_release(hba);
>>  	return ret;
>>  }
> 
> I didn't understand why moving ufshcd_hold/ufshcd_release into
> ufshcd_clock_scaling_prepare()/ufshcd_clock_scaling_unprepare().
> 
> 
>> 
>> @@ -1294,15 +1296,8 @@ static int ufshcd_devfreq_target(struct device
>> *dev,
>>  	}
>>  	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
>> 
>> -	pm_runtime_get_noresume(hba->dev);
>> -	if (!pm_runtime_active(hba->dev)) {
>> -		pm_runtime_put_noidle(hba->dev);
>> -		ret = -EAGAIN;
>> -		goto out;
>> -	}
>>  	start = ktime_get();
>>  	ret = ufshcd_devfreq_scale(hba, scale_up);
>> -	pm_runtime_put(hba->dev);
>> 
> 
> which branch are you working on?  I didn't see this part codes in the
> branch 5.11/scsi-queue and 5.11/scsi-staging.
> 
> Bean

As I mentioned in my cover-letter, this is based on 5.11/scsi-fixes.
These codes came from one of my earlier changes, but since this change
can cover the old change's functionality, so I removed the codes.

Can Guo.
