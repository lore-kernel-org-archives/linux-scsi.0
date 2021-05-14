Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B708DC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 04:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B33761446
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 04:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232186AbhENE0F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 00:26:05 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53456 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbhENE0F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 00:26:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620966294; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=B12lR8Tgnnt28vycPjGzdYf8HrH/LE8cR39W1z6TMjw=;
 b=qQ23zDd2iuCMp0KQYVSspXgV7EqjH5gvvwO4e10Zog9IJDZtaHsYVqBSyhrB9YC6uSpiOWba
 7n+jaF6Xzf3KIEpbU9D3SlAztD/yrDi100kX/n4bdx2EnVGUC1fhNSEdQDWwTLFq32VE5BDU
 P3FUTob6pTcjNg4rxV8kSd4EUxo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 609dfb967bf557a012dd6947 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 May 2021 04:24:54
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 49AE3C433F1; Fri, 14 May 2021 04:24:54 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0FEE7C433D3;
        Fri, 14 May 2021 04:24:52 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 14 May 2021 12:24:51 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: Increase the usable queue depth
In-Reply-To: <10919d97-9a11-b0f9-c786-31d56b22d74a@acm.org>
References: <20210513164912.5683-1-bvanassche@acm.org>
 <c8932f54e6e95797c2969a16d07fd926@codeaurora.org>
 <10919d97-9a11-b0f9-c786-31d56b22d74a@acm.org>
Message-ID: <75c681d88b2e98a143ae601fbe895742@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-14 12:19, Bart Van Assche wrote:
> On 5/13/21 9:04 PM, Can Guo wrote:
>> Hi Bart,
>> 
>> On 2021-05-14 00:49, Bart Van Assche wrote:
>>> With the current implementation of the UFS driver active_queues is 1
>>> instead of 0 if all UFS request queues are idle. That causes
>>> hctx_may_queue() to divide the queue depth by 2 when queueing a 
>>> request
>>> and hence reduces the usable queue depth.
>> 
>> This is interesting. When all UFS queues are idle, in 
>> hctx_may_queue(),
>> active_queues reads 1 (users == 1, depth == 32), where is it divided 
>> by 2?
>> 
>> static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>>                                  struct sbitmap_queue *bt)
>> {
>>        unsigned int depth, users;
>> 
>> ....
>>                users = atomic_read(&hctx->tags->active_queues);
>>        }
>> 
>>        if (!users)
>>                return true;
>> 
>>        /*
>>         * Allow at least some tags
>>         */
>>        depth = max((bt->sb.depth + users - 1) / users, 4U);
>>        return __blk_mq_active_requests(hctx) < depth;
>> }
> 
> Hi Can,
> 
> If no I/O scheduler has been configured then the active_queues counter
> is increased from inside blk_get_request() by blk_mq_tag_busy() before
> hctx_may_queue() is called. So if active_queues == 1 when the UFS 
> device
> is idle, the active_queues counter will be increased to 2 if a request
> is submitted to another request queue than hba->cmd_queue. This will
> cause the hctx_may_queue() calls from inside __blk_mq_alloc_request()
> and __blk_mq_get_driver_tag() to limit the queue depth to 32 / 2 = 16.
> 
> If an I/O scheduler has been configured then __blk_mq_get_driver_tag()
> will be the first function to call blk_mq_tag_busy() while processing a
> request. The hctx_may_queue() call in __blk_mq_get_driver_tag() will
> limit the queue depth to 32 / 2 = 16 if an I/O scheduler has been
> configured.
> 
> Bart.

Yes, I just figured out what you are saying from the commit message and
gave my reviewed-by tag. Thanks for the explanation and the fix.

Regards,
Can Guo.
