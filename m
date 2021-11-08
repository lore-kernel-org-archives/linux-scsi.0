Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0380BC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 18:06:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D632461503
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 18:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhKHSJD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 13:09:03 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:11993 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbhKHSJC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 13:09:02 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1636394778; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: From: References: Cc: To: Subject: MIME-Version: Date:
 Message-ID: Sender; bh=qdP3pfEiGyokm42mGFVc01Dx1x+2CfYZViMk3abklI8=; b=r3NAKEcDQFSptfBSbcq3+qRdPwnMFRgzrQZRLbXSDpsxWCqvBV62sOc/shXvZtbBaCb2J255
 AoWCM58SAFxrA0Mw28Gr4VYRnO9sk6SOdS/C58INriYe02Qu4YWkXwGpIpCKpPQEGqe3zD13
 1d+ov597aJVrd7aVQGjfeTjFDJM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 618967199198e3b2562935b2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Nov 2021 18:06:17
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6428CC4361A; Mon,  8 Nov 2021 18:06:17 +0000 (UTC)
Received: from [192.168.1.3] (cpe-66-27-70-157.san.res.rr.com [66.27.70.157])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7E7C0C4360D;
        Mon,  8 Nov 2021 18:06:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 7E7C0C4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Message-ID: <715a04b2-1791-1884-22a8-4ed8c680cfb8@codeaurora.org>
Date:   Mon, 8 Nov 2021 10:06:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC] scsi: ufs-core: Do not use clk_scaling_lock in
 ufshcd_queuecommand()
To:     Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Luca Porzio <lporzio@micron.com>, linux-scsi@vger.kernel.org
References: <20211029133751.420015-1-adrian.hunter@intel.com>
 <24e21ff3-c992-c71e-70e3-e0c3926fbcda@acm.org>
 <c2d76154-b2ef-2e66-0a56-cd22ac8c652f@intel.com>
 <d3d70c8e-f260-ca2d-f4c1-2c9dd1a08c5d@acm.org>
 <3f4ef5e8-38e8-2e90-6da4-abc67aac9e4d@intel.com>
 <263538ad-51b5-4594-9951-8bcc2373da19@acm.org>
 <24399ee4-4feb-4670-ce9c-0872795c03ea@intel.com>
 <1a6fef86-9917-ddad-1845-d0406150ecb8@acm.org>
 <4895a54b-6d49-9204-e7b2-336854c83ed4@codeaurora.org>
 <c06be499-fc66-1260-400c-0458eb6de7cf@acm.org>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
In-Reply-To: <c06be499-fc66-1260-400c-0458eb6de7cf@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/2021 10:10 AM, Bart Van Assche wrote:
> On 11/4/21 7:23 AM, Asutosh Das (asd) wrote:
>> In the current clock scaling code, the expectation is to scale up as 
>> soon as possible.
>>
>> For e.g. say, the current gear is G1 and there're pending requests in 
>> the queue but the DBR is empty and there's a decision to scale up. 
>> During scale-up, if the queues are frozen, wouldn't those requests be 
>> issued to the driver and executed in G1 instead of G4?
>> I think this would lead to higher run to run variance in performance.
> 
> Hi Asutosh,
> 
> My understanding of the current clock scaling implementation is as 
> follows (please correct me if I got anything wrong):
> * ufshcd_clock_scaling_prepare() is called before clock scaling happens
>    and ufshcd_clock_scaling_unprepare() is called after clock scaling has
>    finished.
> * ufshcd_clock_scaling_prepare() calls ufshcd_scsi_block_requests() and
>    ufshcd_wait_for_doorbell_clr().
> * ufshcd_wait_for_doorbell_clr() waits until both the UTP Transfer
>    Request List Doorbell Register and UTP Task Management Request List
>    DoorBell Register are zero. Hence, it waits until all pending SCSI
>    commands, task management commands and device commands have finished.
> 
> As far as I can see from a conceptual viewpoint there is no difference
> between calling ufshcd_wait_for_doorbell_clr() or freezing the request
> queues. There is an implementation difference however: 
> blk_mq_freeze_queue() waits for an RCU grace period. This can introduce
> an additional delay of several milliseconds compared to 
> ufshcd_wait_for_doorbell_clr(). If this is a concern I can look into 
> expediting the RCU grace period during clock scaling.
> 
> Thanks,
> 
> Bart.
Hi Bart,
The current scaling code invokes scsi_block_request() which would block 
incoming requests right away in prepare. So any un-issued requests 
wouldn't be issued.

I'm not sure if this exact behavior would manifest if 
blk_freeze_queue_start() is used and scsi_block_request() is removed.
I see that it invokes - blk_mq_run_hw_queues().
void blk_freeze_queue_start(struct request_queue *q)
{
         mutex_lock(&q->mq_freeze_lock);
         if (++q->mq_freeze_depth == 1) {
                 percpu_ref_kill(&q->q_usage_counter);
                 mutex_unlock(&q->mq_freeze_lock);
                 if (queue_is_mq(q))
                         blk_mq_run_hw_queues(q, false);
         } else {
                 mutex_unlock(&q->mq_freeze_lock);
         }
}

Would blk_mq_run_hw_queues() issue any pending requests in the queue? If 
so, then these requests would be completed in the unchanged power-mode 
which is not what we want.

-asd

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
