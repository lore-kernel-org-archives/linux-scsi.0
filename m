Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25647C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 23:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE979222C2
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 23:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfKSXQ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 18:16:28 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43368 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfKSXQ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 18:16:28 -0500
Received: by mail-pl1-f193.google.com with SMTP id a18so12804650plm.10
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2019 15:16:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hTOR85rHhpJpwmJGQB9pG2RjYPuwdBvT2RRQa1h5aA4=;
        b=UiC11HLjTJzBnqQTuX6PSx1nOSRXX1EaMexIFzO6o85VNt1WpzJEeW+kiK6hVzqw0f
         AV4WbreWVYAQ+4xUZqY5wS2U2//WEttlAsOKzp4+kdFt7rqhhL6Kwsx8uuGK9vDAanHL
         uuz/MgKPp3QLowkxap3sZFrNdXltYIBQn/KK41br72o55/5Eh2TmOOx85Ce5dmnioGda
         rtSf6mpWxn/rL4uFIZ9T2lgYY1TWeWTYiVnL3clBtiaDerjpTox4amwpHcUHBRDqJjHE
         CwrgjNn57kWVUc7sm4x//J8opRRUhVt470IdTEBdlJcl28d4v1td2k14LSkP1L0goEkz
         ThJA==
X-Gm-Message-State: APjAAAXsCzazSPx19cZeMHrsyW/lnLv5LEFwBUDQ8NrSxpFWFfl6qXGa
        HSu3D0Cv5M49GabF57BXjq8=
X-Google-Smtp-Source: APXvYqwBix+LHfAtNZaoYhj4pxyiKHoYVbV6uC0Crj/l1PmlUPyfUNQcW7xkaxNHp2HuD3pPt7ySSQ==
X-Received: by 2002:a17:902:8f94:: with SMTP id z20mr117415plo.21.1574205387366;
        Tue, 19 Nov 2019 15:16:27 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id h2sm8303037pgj.45.2019.11.19.15.16.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2019 15:16:26 -0800 (PST)
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
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9d680c52-53b3-f57d-a14b-525810148ad2@acm.org>
Date:   Tue, 19 Nov 2019 15:16:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0101016e822696b5-d1c358be-a0a2-4ef6-b04d-627c1fb361f8-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 9:33 PM, cang@codeaurora.org wrote:
> Aside the functionality, we need to take this change carefully as it may 
> relate with performance.
> With the old implementation, when devfreq decides to scale up, we can 
> make sure that all requests
> sent to UFS device after this point will go through the highest UFS 
> Gear. Scaling up will happen
> right after doorbell is cleared, not even need to wait till the requests 
> are freed from block layer.
> And 1 sec is long enough to clean out the doorbell by HW.
> 
> In the new implementation of ufshcd_clock_scaling_prepare(), after 
> blk_freeze_queue_start(), we call
> blk_mq_freeze_queue_wait_timeout() to wait for 1 sec. In addition to 
> those requests which have already
> been queued to HW doorbell, more requests will be dispatched within 1 
> sec, through the lowest Gear.
> My first impression is that it might be a bit lazy and I am not sure how 
> much it may affect the benchmarks.
> 
> And if the request queues are heavily loaded(many bios are waiting for a 
> free tag to become a request),
> is 1 sec long enough to freeze all these request queues? If no, 
> performance would be affected if scaling up
> fails frequently.
> As per my understanding, the request queue will become frozen only after 
> all the existing requests and
> bios(which are already waiting for a free tag on the queue) to be 
> completed and freed from block layer.
> Please correct me if I am wrong.
> 
> While, in the old implementation, when devfreq decides to scale up, 
> scaling can always
> happen for majority chances, except for those unexpected HW issues.

Hi Can,

I agree with the description above of the current behavior of the UFS 
driver. But I do not agree with the interpretation of the behavior of 
the changes I proposed. The implementation in the block layer of request 
queue freezing is as follows:

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

As long as calls from other threads to 
blk_mq_freeze_queue()/blk_mq_unfreeze_queue() are balanced, after 
blk_freeze_queue_start() returns it is guaranteed that 
q->q_usage_counter is in __PERCPU_REF_DEAD mode. Calls to 
blk_get_request() etc. block in that mode until the request queue is 
unfrozen. See also blk_queue_enter().

In other words, calling blk_freeze_queue() from inside 
ufshcd_clock_scaling_prepare() should preserve the current behavior, 
namely that ufshcd_clock_scaling_prepare() waits for ongoing requests to 
finish and also that submission of new requests is postponed until clock 
scaling has finished. Do you agree with this analysis?

Thanks,

Bart.
