Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A98AC432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 16:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4637520803
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 16:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfLCQQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 11:16:43 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45741 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfLCQQm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 11:16:42 -0500
Received: by mail-pg1-f196.google.com with SMTP id k1so1862101pgg.12
        for <linux-scsi@vger.kernel.org>; Tue, 03 Dec 2019 08:16:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NjwXDRiIWEha6wy/A/ULrudSS0F/BR7C8ywMCzIBohs=;
        b=OKkguC3m9kYLf6BxfjhBFCNhmn+60xDbqZ2EIPdY7sIQMTvu6I2tGXwfQfweA6cKfw
         cNBKV4/+c7pl/crVVuret4b80aOBjS0ToX4qE7sQ4UyhxOIPIiWAupjLje1N3K4RQlIR
         fF2c5J9DamxIKf8VwexQpU2C05uTpjoznu/kNPhitWJw0L0Zc3nJU+wy3ZoRRMKQMKB+
         hkH5+vJUNNvZ5gyFTWlFw72mhduZv4O315NLrVo4vMvgWkNe7AXeK9fkn2bAWlR+GfQ1
         q4Z4CiG+kKR2iO0nAiUgOm3FgkJ3TbXB6NeiTOwNDuEC1aRxzPph8PH+Jw7n3wbwSFRj
         hP5Q==
X-Gm-Message-State: APjAAAVhOdEUgFxuWaGreRZOTcewGawxd0luwmGhZGbg4ryeCwm9VQun
        VyNqZw5vojRVuvGtHwNx+Q4=
X-Google-Smtp-Source: APXvYqwSR91T8V96MfD78msiBbuF9aDsdrjeq/c/JV+4LVTEnE36XhurhablrY2vIf69Vk0HCR/KGw==
X-Received: by 2002:a63:4503:: with SMTP id s3mr6168597pga.311.1575389801988;
        Tue, 03 Dec 2019 08:16:41 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id f18sm4504855pfk.124.2019.12.03.08.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 08:16:41 -0800 (PST)
Subject: Re: [PATCH v6 4/4] ufs: Simplify the clock scaling mechanism
 implementation
To:     cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191121220850.16195-1-bvanassche@acm.org>
 <20191121220850.16195-5-bvanassche@acm.org>
 <0101016ea17f117f-41755175-dc9e-4454-bda6-3653b9aa31ff-000000@us-west-2.amazonses.com>
 <c26ba983-b166-785f-86e8-dd60c802fa77@acm.org>
 <0101016ec51ebc59-20291ae8-1b14-4e71-a9a4-2ecbb9733b0a-000000@us-west-2.amazonses.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9f9165cf-83fa-1c40-082b-c96458c1b593@acm.org>
Date:   Tue, 3 Dec 2019 08:16:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0101016ec51ebc59-20291ae8-1b14-4e71-a9a4-2ecbb9733b0a-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/19 9:39 PM, cang@codeaurora.org wrote:
> On 2019-11-26 09:05, Bart Van Assche wrote:
>>  static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
>>  {
>> -    #define DOORBELL_CLR_TOUT_US        (1000 * 1000) /* 1 sec */
>> +    unsigned long deadline = jiffies + HZ /* 1 sec */;
>>      int ret = 0;
>>      /*
>>       * make sure that there are no outstanding requests when
>>       * clock scaling is in progress
>>       */
>>      ufshcd_scsi_block_requests(hba);
>> +    blk_freeze_queue_start(hba->cmd_queue);
>> +    blk_freeze_queue_start(hba->tmf_queue);
>> +    if (blk_mq_freeze_queue_wait_timeout(hba->cmd_queue,
>> +                max_t(long, 1, deadline - jiffies)) <= 0)
>> +        goto unblock;
>> +    if (blk_mq_freeze_queue_wait_timeout(hba->tmf_queue,
>> +                max_t(long, 1, deadline - jiffies)) <= 0)
>> +        goto unblock;
>>      down_write(&hba->clk_scaling_lock);
> 
> Hi Bart,
> 
> It looks better, but there is a race condition here. Consider below 
> sequence,
> thread A takes the clk_scaling_lock and waiting on blk_get_request(), while
> thread B has frozen the queue and waiting for the lock.
> 
> Thread A
>      Call ufshcd_exec_dev_cmd() or ufshcd_issue_devman_upiu_cmd()
>      [a] down_write(hba->clk_scaling_lock)
>      [d] blk_get_request()
> 
> Thread B
>      Call ufshcd_clock_scaling_prepare()
>      [b] blk_freeze_queue_start(hba->cmd_queue)
>      [c] blk_mq_freeze_queue_wait_timeout(hba->cmd_queue) returns > 0
>      [e] down_write(hba->clk_scaling_lock)
> 
> BTW, I see no needs to freeze the hba->cmd_queue in scaling_prepare.
> I went through our previous discussions and you mentioned freezing 
> hba->cmd_queue
> can serialize scaling and err handler.
> However, it is not necessary and not 100% true. We've already have 
> ufshcd_eh_in_progress()
> check in ufshcd_devfreq_target() before call ufshcd_devfreq_scale().
> If you think this is not enough(err handler may kick off after this 
> check), having
> hba->cmd_queue frozen in scaling_prepare() does not mean the err handler 
> is finished either,
> because device management commands are only used in certain steps during 
> err handler.
> Actually, with the original design, we don't see any problems caused by
> concurrency of scaling and err handler, and if the concurrency really 
> happens,
> scaling would just fail.

Hi Can,

That's a good catch. When I repost this patch series I will leave out 
the freeze and unfreeze operations for hba->cmd_queue.

Bart.
