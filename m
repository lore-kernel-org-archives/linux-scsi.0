Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18941C2BA1B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E85D964EE7
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Mar 2021 13:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447045AbhCCMre (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 07:47:34 -0500
Received: from z11.mailgun.us ([104.130.96.11]:32227 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1452388AbhCCKUf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 Mar 2021 05:20:35 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614766814; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=QvDPOoM+Z0w8Vvhv9dvc3TRDzSP3WYUluNgQqtl528M=;
 b=xf7fqfS104vMS6yCsTL2X8+Cbx7KxK3zxb1Rx0uxAXRQenFX0es+xyKC/56/GgGZnNS8eMxr
 mgoJvn0soRvbS5pHonF8TmtDgvrnF/ZGo+X1C+OHRinjAR6XekJSac0/M0k4q7YE0ajREtIo
 x7l+Byzaa7zoGZEIAUccec0joRs=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 603f5f004fd7814d5fc602b1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 03 Mar 2021 10:03:44
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0402EC43461; Wed,  3 Mar 2021 10:03:43 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF25AC433C6;
        Wed,  3 Mar 2021 10:03:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 03 Mar 2021 18:03:42 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] scsi: ufs: Minor adjustments to error handling
In-Reply-To: <DM6PR04MB657549A42A64963CA134609CFC989@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1614145010-36079-1-git-send-email-cang@codeaurora.org>
 <1614145010-36079-2-git-send-email-cang@codeaurora.org>
 <DM6PR04MB657549A42A64963CA134609CFC989@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <3c6df42fef5a1e52e655753aadec4a11@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

On 2021-03-03 15:22, Avri Altman wrote:
>> 
>> 
>> In error handling prepare stage, after SCSI requests are blocked, do a
>> down/up_write(clk_scaling_lock) to clean up the queuecommand() path.
>> Meanwhile, stop eeh_work in case it disturbs error recovery. Moreover,
>> reset ufshcd_state at the entrance of ufshcd_probe_hba(), since it may 
>> be
>> called multiple times during error recovery.
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
> I noticed that you tagged Adrian's patch -
> https://lore.kernel.org/lkml/20210301191940.15247-1-adrian.hunter@intel.com/
> So this patch needs to be adjusted accordingly?

Thanks for pointing me to that one, I will rebase mine.

Regards,
Can Guo.

> 
> Thanks,
> Avri
> 
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 18 ++++++++++++------
>>  1 file changed, 12 insertions(+), 6 deletions(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 80620c8..013eb73 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -4987,6 +4987,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba,
>> struct ufshcd_lrb *lrbp)
>>                          * UFS device needs urgent BKOPs.
>>                          */
>>                         if (!hba->pm_op_in_progress &&
>> +                           !ufshcd_eh_in_progress(hba) &&
>>                             
>> ufshcd_is_exception_event(lrbp->ucd_rsp_ptr) &&
>>                             schedule_work(&hba->eeh_work)) {
>>                                 /*
>> @@ -5784,13 +5785,20 @@ static void ufshcd_err_handling_prepare(struct
>> ufs_hba *hba)
>>                         ufshcd_suspend_clkscaling(hba);
>>                 ufshcd_clk_scaling_allow(hba, false);
>>         }
>> +       ufshcd_scsi_block_requests(hba);
>> +       /* Drain ufshcd_queuecommand() */
>> +       down_write(&hba->clk_scaling_lock);
>> +       up_write(&hba->clk_scaling_lock);
>> +       cancel_work_sync(&hba->eeh_work);
>>  }
>> 
>>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>>  {
>> +       ufshcd_scsi_unblock_requests(hba);
>>         ufshcd_release(hba);
>>         if (ufshcd_is_clkscaling_supported(hba))
>>                 ufshcd_clk_scaling_suspend(hba, false);
>> +       ufshcd_clear_ua_wluns(hba);
>>         pm_runtime_put(hba->dev);
>>  }
>> 
>> @@ -5882,8 +5890,8 @@ static void ufshcd_err_handler(struct 
>> work_struct
>> *work)
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>>         ufshcd_err_handling_prepare(hba);
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>> -       ufshcd_scsi_block_requests(hba);
>> -       hba->ufshcd_state = UFSHCD_STATE_RESET;
>> +       if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
>> +               hba->ufshcd_state = UFSHCD_STATE_RESET;
>> 
>>         /* Complete requests that have door-bell cleared by h/w */
>>         ufshcd_complete_requests(hba);
>> @@ -6042,12 +6050,8 @@ static void ufshcd_err_handler(struct 
>> work_struct
>> *work)
>>         }
>>         ufshcd_clear_eh_in_progress(hba);
>>         spin_unlock_irqrestore(hba->host->host_lock, flags);
>> -       ufshcd_scsi_unblock_requests(hba);
>>         ufshcd_err_handling_unprepare(hba);
>>         up(&hba->host_sem);
>> -
>> -       if (!err && needs_reset)
>> -               ufshcd_clear_ua_wluns(hba);
>>  }
>> 
>>  /**
>> @@ -7858,6 +7862,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba,
>> bool async)
>>         unsigned long flags;
>>         ktime_t start = ktime_get();
>> 
>> +       hba->ufshcd_state = UFSHCD_STATE_RESET;
>> +
>>         ret = ufshcd_link_startup(hba);
>>         if (ret)
>>                 goto out;
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
>> Linux
>> Foundation Collaborative Project.
