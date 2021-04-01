Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E20BC433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 02:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FA4060240
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 02:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbhDAC5s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 22:57:48 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:29073 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbhDAC5q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 22:57:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617245866; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ihkaRcStWCro4pWEBNLLU91BJBcl7So6zd9+6ElANS8=;
 b=MrVEKyVJdtye64ky0IFsDNSHLWoWssFHJRj4Eac3lOKhcZpXy12GNJsB5THk+lzF7l6r19tg
 QAD0/3JzQ77JsdqpIcQJWHEUqPa9p288cM8JC35lcAOQ0N/Db7s8+sHKSxbTHzlfYYc9XzsF
 3sTm/R4dQ+4gUCKCUYk4hK0+Vj0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60653699e0e9c9a6b61d4ca8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 01 Apr 2021 02:57:29
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E4F0AC433C6; Thu,  1 Apr 2021 02:57:28 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5A0FDC433ED;
        Thu,  1 Apr 2021 02:57:27 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 01 Apr 2021 10:57:27 +0800
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
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] scsi: ufs: Fix task management request completion
 timeout
In-Reply-To: <BL0PR04MB656448E22577076A27F1EADAFC7C9@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <1617166236-39908-1-git-send-email-cang@codeaurora.org>
 <1617166236-39908-2-git-send-email-cang@codeaurora.org>
 <BL0PR04MB656448E22577076A27F1EADAFC7C9@BL0PR04MB6564.namprd04.prod.outlook.com>
Message-ID: <cca5f34bae70586cbb7d524670ee8758@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-01 00:45, Avri Altman wrote:
>> ufshcd_tmc_handler() calls blk_mq_tagset_busy_iter(fn =
>> ufshcd_compl_tm()),
>> but since blk_mq_tagset_busy_iter() only iterates over all reserved 
>> tags
>> and requests which are not in IDLE state, ufshcd_compl_tm() never gets 
>> a
>> chance to run. Thus, TMR always ends up with completion timeout. Fix 
>> it by
>> calling blk_mq_start_request() in  __ufshcd_issue_tm_cmd().
>> 
>> Fixes: 69a6c269c097 ("scsi: ufs: Use blk_{get,put}_request() to 
>> allocate and
>> free TMFs")
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index b49555fa..d4f8cb2 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -6464,6 +6464,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba
>> *hba,
>> 
>>         spin_lock_irqsave(host->host_lock, flags);
>>         task_tag = hba->nutrs + free_slot;
>> +       blk_mq_start_request(req);
> Maybe just set req->state to MQ_RQ_IN_FLIGHT
> Without all other irrelevant initializations such as add timeout etc.
> 

I don't see any other drivers do that, is it appropriate
to call WRITE_ONCE(rq->state, MQ_RQ_IN_FLIGHT) outside
block layer?

Thanks,
Can Guo.

> Thanks,
> Avri
>> 
>>         treq->req_header.dword_0 |= cpu_to_be32(task_tag);
>> 
>> --
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
>> Linux Foundation Collaborative Project.
