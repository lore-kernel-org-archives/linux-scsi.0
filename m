Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9248BC432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 17:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DA7820878
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 17:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbfKTR6s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 12:58:48 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36121 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfKTR6r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 12:58:47 -0500
Received: by mail-pj1-f68.google.com with SMTP id cq11so167269pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2019 09:58:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JOz1WVZ1ZN2RC6ePdz3SPB319kQjcksOXu7r5UuZ5HI=;
        b=DrLxpgD3syaXHtnn5+vYLulkaFMgSmkB4T5lhNpAW+msAzN1lzBP5wDswr/0kWcpmX
         9fg/XnxPGL5K1TylC9DCtFCwuoiGrKLQ2kfzUUmwOXKgb5PoeK1GmYj2s1vOeKin5ebH
         0xB8zoeNSHqz93dewyjFh5j8d/ARd2YOYRO/un5P1fNYdaYt9gMEgYGcrORwTm0KGDes
         fXZu4NO3037tJge8052uGufnoFnccVWqBQArA6AGSSaotdBn0V2F0ywWbmVxJ4sTc0v2
         lLfBvqBQvwfUBukiU8x/PyAn9w6Qf+iMAxdgz3bo1qycMI5JCl4s1EO3LiQtWfWPpK9A
         rHew==
X-Gm-Message-State: APjAAAWZbL1RdPqOAkseKV71JapIf2q92yt0+L1nXQZlEVWwlKNHLAEB
        8lOcgcRy7ZYRMSs/BOk3sQo=
X-Google-Smtp-Source: APXvYqy8C6WCjoxZUIHHWPb8BcwlCVLn8TetfKUlogGxKRR9HJZGi0Auk5ZP1Jh5cecdr3Gn0K7A6Q==
X-Received: by 2002:a17:90a:2623:: with SMTP id l32mr5913595pje.70.1574272726392;
        Wed, 20 Nov 2019 09:58:46 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 190sm11811940pga.65.2019.11.20.09.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 09:58:45 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH v5 4/4] ufs: Simplify the clock scaling
 mechanism implementation
To:     cang@codeaurora.org
Cc:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>, stummala@codeaurora.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191112173743.141503-1-bvanassche@acm.org>
 <20191112173743.141503-5-bvanassche@acm.org>
 <a26c719466edfd2c41eea789a6c908ab@codeaurora.org>
 <8acd9237-7414-5dce-5285-69ed3ce6f28c@acm.org>
 <BN7PR08MB56843E1941F42BEF8239B895DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
 <ca27868b-9d25-36b9-7548-02252c293905@acm.org>
 <e0ab904e1413ae6a89cebbced22a6cf8@codeaurora.org>
 <5659ab82-a087-4cfb-088e-e25d7f5515a3@acm.org>
 <0101016e822696b5-d1c358be-a0a2-4ef6-b04d-627c1fb361f8-000000@us-west-2.amazonses.com>
 <9d680c52-53b3-f57d-a14b-525810148ad2@acm.org>
 <0101016e86e3a961-1840fd1c-d71b-434a-8392-f62d7ece8b0f-000000@us-west-2.amazonses.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6bb86bb6-2906-a0ad-7f83-cc4a2dd3dd5c@acm.org>
Date:   Wed, 20 Nov 2019 09:58:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0101016e86e3a961-1840fd1c-d71b-434a-8392-f62d7ece8b0f-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/19 7:38 PM, cang@codeaurora.org wrote:
> On 2019-11-20 07:16, Bart Van Assche wrote:
>> On 11/18/19 9:33 PM, cang@codeaurora.org wrote:
[ ... ]
> 
> I am still not quite clear about the blk_freeze_queue() part.
> 
>>> In the new implementation of ufshcd_clock_scaling_prepare(), after 
>>> blk_freeze_queue_start(), we call blk_mq_freeze_queue_wait_timeout()
>>> to wait for 1 sec. In addition to those requests which have already
>>> been queued to HW doorbell, more requests will be dispatched within 1 
>>> sec, through the lowest Gear. My first impression is that it might be >>> a bit lazy and I am not sure how much it may affect the benchmarks.
> 
> First of all, reg above lines, do you agree that there can be latency in 
> scaling up/down
> comparing with the old implementation?
> 
> I can understand that after queue is frozen, all calls to blk_get_request()
> are blocked, no submission can be made after this point, due to
> blk_queue_enter() shall wait on q->mq_freeze_wq.
> 
> <--code snippet-->
> wait_event(q->mq_freeze_wq,
>             (atomic_read(&q->mq_freeze_depth) == 0 &&
> <--code snippet-->
> 
>>> And if the request queues are heavily loaded(many bios are waiting 
>>> for a free tag to become a request),
>>> is 1 sec long enough to freeze all these request queue?
> 
> But here I meant those bios, before we call blk_freeze_queue_start(), 
> sent through
> submit_bio() calls which have already entered blk_mq_get_request() and 
> already
> returned from the blk_queue_enter_live(). These bios are waiting for a 
> free tag
> (waiting on func blk_mq_get_tag() when queue is full).
> Shall the request queue be frozen before these bios are handled?
> 
> void blk_mq_freeze_queue_wait(struct request_queue *q)
> {
>       wait_event(q->mq_freeze_wq, percpu_ref_is_zero(&q->q_usage_counter));
> }
> EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait);
> 
> Per my understanding, these bios have already increased 
> &q->q_usage_counter.
> And the &q->q_usage_counter will only become 0 when all of the requests 
> in the
> queue and these bios(after they get free tags and turned into requests) are
> completed from block layer, meaning after blk_queue_exit() is called in
> __blk_mq_free_request() for all of them. Please correct me if I am wrong.

Hi Can,

Please have another look at the request queue freezing mechanism in the 
block layer. If blk_queue_enter() sleeps in wait_event() that implies 
either that the percpu_ref_tryget_live() call failed or that the 
percpu_ref_tryget_live() succeeded and that it was followed by a 
percpu_ref_put() call. Ignoring concurrent q_usage_counter changes, in 
both cases q->q_usage_counter will have the same value as before 
blk_queue_enter() started.

In other words, there shouldn't be a latency difference between the 
current and the proposed approach since neither approach waits for 
completion of bios or SCSI commands that are queued after clock scaling 
started.

Thanks,

Bart.
