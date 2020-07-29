Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D1AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 22:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA7B92053B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 22:46:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="VhI2/KLt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgG2WqJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 18:46:09 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:50246 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726628AbgG2WqJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 18:46:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596062768; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=DNhClZ5F3J2ftESrdBiYlqeVHdgvkBigRNnujyyth30=; b=VhI2/KLtruBVyyP7QVx1OqQTMjchV8u4gyaaKAX9Uqf4w0C94l/wTffvoRBVlTzkayegVCNI
 mdr79qH2BQWNqfKSFH7vMzHU4O4qjtPXwwpfpGioqmbs67R6e63U2oC4PaTSGQGCzMD9XBzA
 CfDcJiwpq/JCDdH0a8hnyVYOygA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5f21fc11634c4259e3526bb0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 29 Jul 2020 22:45:37
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5C0E1C43391; Wed, 29 Jul 2020 22:45:37 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D62B4C433C9;
        Wed, 29 Jul 2020 22:45:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D62B4C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v7 7/8] scsi: ufs: Move dumps in IRQ handler to error
 handler
To:     Can Guo <cang@codeaurora.org>
Cc:     nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, sh425.lee@samsung.com,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1595912460-8860-1-git-send-email-cang@codeaurora.org>
 <1595912460-8860-8-git-send-email-cang@codeaurora.org>
 <7e5e942d-449b-bd52-32da-7f5beed116b7@codeaurora.org>
 <dff9541177ebf68950ca13d2f13d88ba@codeaurora.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <d66389fa-4ca2-bf7e-6b3d-d77eada4eb0e@codeaurora.org>
Date:   Wed, 29 Jul 2020 15:45:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dff9541177ebf68950ca13d2f13d88ba@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/29/2020 6:02 AM, Can Guo wrote:
> Hi Asutosh,
> 
> On 2020-07-29 02:06, Asutosh Das (asd) wrote:
>> On 7/27/2020 10:00 PM, Can Guo wrote:
>>> Sometime dumps in IRQ handler are heavy enough to cause system stability
>>> issues, move them to error handler.
>>>
>>> Signed-off-by: Can Guo <cang@codeaurora.org>
>>> ---
>>>   drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++----------------
>>>   1 file changed, 15 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index c480823..b2bafa3 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -5682,6 +5682,21 @@ static void ufshcd_err_handler(struct 
>>> work_struct *work)
>>>                       UFSHCD_UIC_DL_TCx_REPLAY_ERROR))))
>>>           needs_reset = true;
>>>   +    if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR |
>>> +                  UFSHCD_UIC_HIBERN8_MASK)) {
>>> +        bool pr_prdt = !!(hba->saved_err & SYSTEM_BUS_FATAL_ERROR);
>>> +
>>> +        dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 0x%x\n",
>>> +                __func__, hba->saved_err, hba->saved_uic_err);
>>> +        spin_unlock_irqrestore(hba->host->host_lock, flags);
>>> +        ufshcd_print_host_state(hba);
>>> +        ufshcd_print_pwr_info(hba);
>>> +        ufshcd_print_host_regs(hba);
>>> +        ufshcd_print_tmrs(hba, hba->outstanding_tasks);
>>> +        ufshcd_print_trs(hba, hba->outstanding_reqs, pr_prdt);
>>> +        spin_lock_irqsave(hba->host->host_lock, flags);
>>> +    }
>>> +
>>>       /*
>>>        * if host reset is required then skip clearing the pending
>>>        * transfers forcefully because they will get cleared during
>>> @@ -5900,22 +5915,6 @@ static irqreturn_t ufshcd_check_errors(struct 
>>> ufs_hba *hba)
>>>             /* block commands from scsi mid-layer */
>>>           ufshcd_scsi_block_requests(hba);
>>> -
>>> -        /* dump controller state before resetting */
>>> -        if (hba->saved_err & (INT_FATAL_ERRORS | UIC_ERROR)) {
>>> -            bool pr_prdt = !!(hba->saved_err &
>>> -                    SYSTEM_BUS_FATAL_ERROR);
>>> -
>>> -            dev_err(hba->dev, "%s: saved_err 0x%x saved_uic_err 
>>> 0x%x\n",
>>> -                    __func__, hba->saved_err,
>>> -                    hba->saved_uic_err);
>>> -
>>> -            ufshcd_print_host_regs(hba);
>>> -            ufshcd_print_pwr_info(hba);
>> How about keep the above prints and move the tmrs and trs to eh?
>> Sometimes in system instability, the eh may not get a chance to run
>> even. Still the above prints would provide some clues.
> 
> Here is the IRQ handler, ufshcd_print_host_regs() is sometime heavy
> enough to cause stability issues during my fault injection test, since
> it prints host regs, reg's history, crypto debug infos plus prints
> from vops_dump.
> 
> How about just printing host regs and reg history here? Most time, these
> infos are enough.
> 
That'd work too.

> Thanks,
> 
> Can Guo.
> 
>>> -            ufshcd_print_tmrs(hba, hba->outstanding_tasks);
>>> -            ufshcd_print_trs(hba, hba->outstanding_reqs,
>>> -                    pr_prdt);
>>> -        }
>>>           ufshcd_schedule_eh_work(hba);
>>>           retval |= IRQ_HANDLED;
>>>       }
>>>


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
