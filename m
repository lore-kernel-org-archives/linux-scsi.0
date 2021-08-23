Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3192FC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 16:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 171BC6124D
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 16:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhHWQQV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 12:16:21 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:45594 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbhHWQQT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 12:16:19 -0400
Received: by mail-pf1-f174.google.com with SMTP id t42so13227568pfg.12;
        Mon, 23 Aug 2021 09:15:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J3xy8ugS4gYXz5Du83QXFFrIFwR5k1kzlrOz6o7VFs0=;
        b=QnctFPjOTpUpzNzrUjykI3iF9NDyXGGcpI8ILyHi9FMQvFmlML1vSNtTC2G0ZZuQM0
         G+LF5f3iSM9OGoExrlhsahlExFpEnYzUhrNDCkaWWzNbis0gViFo0j1PmCsT+ZgUFGAG
         DH32isHnyWE0X5tVR/HMO/mq3M9py0XABiDdyRGLx+TZOgZLseHYZnZdatFvnz0WsOMK
         SB0iVL+o4bEPVgzJ8bnzNg0NQkYxYTAx9ReDT88rpxY8IcDGcF4QA3AS8UI9L6r2OK6F
         HY7o5zQBOJRTwJlKD53i66BeoSVwiiRM+EqFm+gtNzSVMPoX8Ymr+6n3oCDp8Hwn3J8v
         t5bQ==
X-Gm-Message-State: AOAM531/E0IsRZ9DoTgYWi/zYqJ0s5cg6tfKPuqYeBm51ShncwGMIDpE
        sLkknTitx2O0WGoOtnu4KGk=
X-Google-Smtp-Source: ABdhPJwPI9KQa34651t/EihprPOCWjOxeLDtuB7jLYdxgEMoHuXXw6mSqEu1t1DnoSQNOyC0kYHnqg==
X-Received: by 2002:a63:4b5a:: with SMTP id k26mr32526405pgl.241.1629735336860;
        Mon, 23 Aug 2021 09:15:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:e98a:ca44:7012:ad8e])
        by smtp.gmail.com with ESMTPSA id z3sm14397744pjn.43.2021.08.23.09.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 09:15:35 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: core: Fix hang of freezing queue between
 blocking and running device
To:     lijinlin3@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     john.garry@huawei.com, qiulaibin@huawei.com, linfeilong@huawei.com,
        wubo40@huawei.com
References: <20210809141308.3700854-1-lijinlin3@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <08c4bb7e-830e-c9e6-2537-18131c7e0fc6@acm.org>
Date:   Mon, 23 Aug 2021 09:15:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809141308.3700854-1-lijinlin3@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/21 7:13 AM, lijinlin3@huawei.com wrote:
> From: Li Jinlin <lijinlin3@huawei.com>
> 
> We found a hang issue, the test steps are as follows:
>    1. blocking device via scsi_device_set_state()
>    2. dd if=/dev/sda of=/mnt/t.log bs=1M count=10
>    3. echo none > /sys/block/sda/queue/scheduler
>    4. echo "running" >/sys/block/sda/device/state
> 
> Step 3 and 4 should finish this work after step 4, but they hangs.
> 
>    CPU#0               CPU#1                CPU#2
>    ---------------     ----------------     ----------------
>                                             Step 1: blocking device
> 
>                                             Step 2: dd xxxx
>                                                    ^^^^^^ get request
>                                                           q_usage_counter++
> 
>                        Step 3: switching scheculer
>                        elv_iosched_store
>                          elevator_switch
>                            blk_mq_freeze_queue
>                              blk_freeze_queue
>                                > blk_freeze_queue_start
>                                  ^^^^^^ mq_freeze_depth++
> 
>                                > blk_mq_run_hw_queues
>                                  ^^^^^^ can't run queue when dev blocked
> 
>                                > blk_mq_freeze_queue_wait
>                                  ^^^^^^ Hang here!!!
>                                         wait q_usage_counter==0
> 
>    Step 4: running device
>    store_state_field
>      scsi_rescan_device
>        scsi_attach_vpd
>          scsi_vpd_inquiry
>            __scsi_execute
>              blk_get_request
>                blk_mq_alloc_request
>                  blk_queue_enter
>                  ^^^^^^ Hang here!!!
>                         wait mq_freeze_depth==0
> 
>      blk_mq_run_hw_queues
>      ^^^^^^ dispatch IO, q_usage_counter will reduce to zero
> 
>                              blk_mq_unfreeze_queue
>                              ^^^^^ mq_freeze_depth--
> 
> Step 3 and 4 wait for each other.
> 
> To fix this, we need to run queue before rescanning device when the device
> state changes to SDEV_RUNNING.
> 
> Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after offlinining device")
> Signed-off-by: Li Jinlin <lijinlin3@huawei.com>
> Signed-off-by: Qiu Laibin <qiulaibin@huawei.com>
> ---
> changes since v1 send with Message-ID:
> 20210805143231.1713299-1-lijinlin3@huawei.com
> 
>   - Modify the subject to make it distinct
>   - Modify the message to fix typo and make it distinct
>   - Reduce the number of SOB
> 
>   drivers/scsi/scsi_sysfs.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index c3a710bceba0..aa701582c950 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -809,12 +809,12 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>   	ret = scsi_device_set_state(sdev, state);
>   	/*
>   	 * If the device state changes to SDEV_RUNNING, we need to
> -	 * rescan the device to revalidate it, and run the queue to
> -	 * avoid I/O hang.
> +	 * run the queue to avoid I/O hang, and rescan the device
> +	 * to revalidate it.
>   	 */
>   	if (ret == 0 && state == SDEV_RUNNING) {
> -		scsi_rescan_device(dev);
>   		blk_mq_run_hw_queues(sdev->request_queue, true);
> +		scsi_rescan_device(dev);
>   	}
>   	mutex_unlock(&sdev->state_mutex);

The patch looks fine to me but I think the comment in 
store_state_field() should be expanded. Although the description in the 
commit message makes it clear how I/O may hang, that is not clear from 
the source code comment. Please mention in the comment that running the 
queue first is necessary because another thread may be waiting inside 
blk_mq_freeze_queue_wait() and because that call may be waiting for 
pending I/O to finish.

Thanks,

Bart.

