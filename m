Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36C1C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D5B96128E
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhFWBet (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:34:49 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:47188 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhFWBes (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jun 2021 21:34:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1624411951; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=CrrnpDfUdPHc9/5MJchBP5+uWYdhn9UchGZ0bYOLPvE=;
 b=pceLZNVh+i1THUD5Q6uVTNF0ASnsbu4Ia+L7Fi9I8mG6O0n5KzOglC8R6fmRc1IfLp9YQDYX
 Na6ynYcQLlGlryymaU1uYNkpDbAQ3yWyoIF+KG4LpEqg3M3xSvuzCEXFluMW/y9X7IHGDqLS
 132pTLnZ4TVr24eJjw745A3n3JQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 60d28f2e0090905e16b5b8e3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 23 Jun 2021 01:32:30
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 03357C43143; Wed, 23 Jun 2021 01:32:28 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1CE66C433F1;
        Wed, 23 Jun 2021 01:32:28 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Jun 2021 09:32:28 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/9] scsi: ufs: Differentiate status between hba pm ops
 and wl pm ops
In-Reply-To: <a5804465-2ad4-f122-0458-dcdd75f39310@acm.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
 <1623300218-9454-2-git-send-email-cang@codeaurora.org>
 <a5804465-2ad4-f122-0458-dcdd75f39310@acm.org>
Message-ID: <d3a80cdc7435238a26315c0631df2862@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2021-06-17 01:50, Bart Van Assche wrote:
> On 6/9/21 9:43 PM, Can Guo wrote:
>> @@ -8784,7 +8786,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba 
>> *hba, enum ufs_pm_op pm_op)
>>  	enum ufs_dev_pwr_mode req_dev_pwr_mode;
>>  	enum uic_link_state req_link_state;
>> 
>> -	hba->pm_op_in_progress = true;
>> +	hba->wl_pm_op_in_progress = true;
>>  	if (pm_op != UFS_SHUTDOWN_PM) {
>>  		pm_lvl = pm_op == UFS_RUNTIME_PM ?
>>  			 hba->rpm_lvl : hba->spm_lvl;
>> @@ -8919,7 +8921,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba 
>> *hba, enum ufs_pm_op pm_op)
>>  		hba->clk_gating.is_suspended = false;
>>  		ufshcd_release(hba);
>>  	}
>> -	hba->pm_op_in_progress = false;
>> +	hba->wl_pm_op_in_progress = false;
>>  	return ret;
>>  }
> 
> Are the __ufshcd_wl_suspend() calls serialized in any way? If not, will
> the value of wl_pm_op_in_progress be incorrect if multiple kernel
> threads run __ufshcd_wl_suspend() concurrently and one of the
> __ufshcd_wl_suspend() instances returns earlier than the other?
> 

Sorry for getting back late on this... I was stuck by some urgent 
issues.

Yes, __ufshcd_wl_suspend() calls are serilized, because it is called by
either runtime suspend or system suspend, and runtime suspend and system
suspend are serialized - Rafael J. Wysocki has put a lot of efforts on 
it,
see also 1e2ef05bb8cf8 ("PM: Limit race conditions between runtime PM 
and
system sleep (v2)")).

> Thanks,
> 
> Bart.
