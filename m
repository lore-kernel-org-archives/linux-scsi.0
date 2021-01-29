Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50CFDC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 05:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 101BF64DFF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Jan 2021 05:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhA2Frh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Jan 2021 00:47:37 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:34757 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhA2Frh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 Jan 2021 00:47:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611899234; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=n2o6XDlbL/t7pa9ksIQ0MJIKQ1F8tE9oChxG/T+mGDY=;
 b=L4PmHxz8rnn/S1bQAvf6zLgtVuR0wRjdQnKtfM5DM5L4ok66xZrU+MCUEPKnvHzuLKusN4pq
 iDwM1wGDnXN1wgj3VXrXQenxYWn7hs3VqSpZYxB0FAkFU7HHqZ0+EvyIIN/LnjhZesbOsC8l
 VCl5pPDu1TBZv7AF+kqwR9zu/wE=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 6013a141d08556f4550f9128 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 Jan 2021 05:46:41
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B760EC43463; Fri, 29 Jan 2021 05:46:40 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF43BC433CA;
        Fri, 29 Jan 2021 05:46:39 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 29 Jan 2021 13:46:39 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
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
Subject: Re: [PATCH v3 1/3] scsi: ufs: Fix task management request completion
 timeout
In-Reply-To: <b73ad496-1658-d587-146a-138ac8f522a9@acm.org>
References: <1611807365-35513-1-git-send-email-cang@codeaurora.org>
 <1611807365-35513-2-git-send-email-cang@codeaurora.org>
 <b73ad496-1658-d587-146a-138ac8f522a9@acm.org>
Message-ID: <1bcdd48c6afb079aadc8464847295363@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-29 11:22, Bart Van Assche wrote:
> On 1/27/21 8:16 PM, Can Guo wrote:
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
>> allocate and free TMFs")
>> 
>> Signed-off-by: Can Guo <cang@codeaurora.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 8da75e6..c0c5925 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -6395,6 +6395,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba 
>> *hba,
>> 
>>  	spin_lock_irqsave(host->host_lock, flags);
>>  	task_tag = hba->nutrs + free_slot;
>> +	blk_mq_start_request(req);
>> 
>>  	treq->req_header.dword_0 |= cpu_to_be32(task_tag);
> 
> blk_mq_start_request() not only marks a request as in-flight but also
> starts a timer. However, no timeout handler has been defined in
> ufshcd_tmf_ops. Should a timeout handler be defined in that data 
> structure?
> 

Block mq driver gives 30s as default timeout,
TMR timeout is 100ms in UFS driver. So we don't
need a timeout handler as of now.

Thanks,
Can Guo.

> Thanks,
> 
> Bart.
