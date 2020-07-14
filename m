Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DEFC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F4721927
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="tN0++k2F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbgGNEME (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 00:12:04 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:32884 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbgGNEME (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 00:12:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594699923; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=hsEKA/3eRhukZygPW6Cac0stnOTwRE32z+LOOhbzLN0=;
 b=tN0++k2F2BkuIgOKwHBHiox23t+88conFMUWnfjhAuWgFmu0hyHEfxjidIkWCtfqmhpWPUYd
 DP7LBvMOr5q4dlSJOzi43vJSrHFqW59tdcmDvNpuz8B6bOESQpXcuvhCBiIZh2scRCk5ONtV
 atX8C2K0sts5TtKZTtzg1EJEnB4=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n16.prod.us-west-2.postgun.com with SMTP id
 5f0d3056512812c070c94d90 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 14 Jul 2020 04:11:02
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 15219C43387; Tue, 14 Jul 2020 04:11:01 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 17BF8C433C8;
        Tue, 14 Jul 2020 04:11:01 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 14 Jul 2020 12:11:01 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
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
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] scsi: ufs: Fix imbalanced scsi_block_reqs_cnt
 caused by ufshcd_hold()
In-Reply-To: <5470be4c-cfa4-ebe5-a817-e53f26c7eaf6@acm.org>
References: <1594693693-22466-1-git-send-email-cang@codeaurora.org>
 <1594693693-22466-3-git-send-email-cang@codeaurora.org>
 <5470be4c-cfa4-ebe5-a817-e53f26c7eaf6@acm.org>
Message-ID: <b9abe84856f5d2f6eced90a55638743c@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-14 11:41, Bart Van Assche wrote:
> On 2020-07-13 19:28, Can Guo wrote:
>> The scsi_block_reqs_cnt increased in ufshcd_hold() is supposed to be
>> decreased back in ufshcd_ungate_work() in a paired way. However, if
>> specific ufshcd_hold/release sequences are met, it is possible that
>> scsi_block_reqs_cnt is increased twice but only one ungate work is
>> queued. To make sure scsi_block_reqs_cnt is handled by ufshcd_hold() 
>> and
>> ufshcd_ungate_work() in a paired way, increase it only if queue_work()
>> returns true.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index ebf7a95..33214bb 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -1611,12 +1611,12 @@ int ufshcd_hold(struct ufs_hba *hba, bool 
>> async)
>>  		 */
>>  		/* fallthrough */
>>  	case CLKS_OFF:
>> -		ufshcd_scsi_block_requests(hba);
>>  		hba->clk_gating.state = REQ_CLKS_ON;
>>  		trace_ufshcd_clk_gating(dev_name(hba->dev),
>>  					hba->clk_gating.state);
>> -		queue_work(hba->clk_gating.clk_gating_workq,
>> -			   &hba->clk_gating.ungate_work);
>> +		if (queue_work(hba->clk_gating.clk_gating_workq,
>> +			       &hba->clk_gating.ungate_work))
>> +			ufshcd_scsi_block_requests(hba);
>>  		/*
>>  		 * fall through to check if we should wait for this
>>  		 * work to be done or not.
> 
> Since "ungate_work" involves calling ufshcd_scsi_unblock_requests() and
> since this patch changes the order in which 
> ufshcd_scsi_block_requests()
> and queue_work() are called, I think this patch introduces a race
> condition. Has it been considered to leave the 
> ufshcd_scsi_block_requests()
> call where it is and to call ufshcd_scsi_unblock_requests() if
> queue_work() fails?
> 
> Thanks,
> 
> Bart.

Hi Bart,

The racing does not exist due to we still hold the spin lock here. 
Before
release the spin lock, the ungate_work, even it starts to run, cannot
move forward as it needs to require the spin lock once in the entrance.

static void ufshcd_ungate_work(struct work_struct *work)
{
...
         spin_lock_irqsave(hba->host->host_lock, flags);
         if (hba->clk_gating.state == CLKS_ON) {
                 spin_unlock_irqrestore(hba->host->host_lock, flags);
                 goto unblock_reqs;
         }
...
}
