Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED53C433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 16 May 2021 16:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57E6960FDB
	for <linux-scsi@archiver.kernel.org>; Sun, 16 May 2021 16:17:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhEPQTI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 May 2021 12:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhEPQTI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 May 2021 12:19:08 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30165C061573;
        Sun, 16 May 2021 09:17:52 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id k10so5603589ejj.8;
        Sun, 16 May 2021 09:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fUZoBFjO/vsp3cDiO+TNP6HxbVjdq2qyqXhhcYkxauo=;
        b=ACQtT8g9/CGzltUjQWC4yGPj0K4b7qM0gOSaqu+g1o0Bvz3jo+GwkXS2pcg6pYuBBI
         73qNqSgPK+0lZuYouKtmi1JsZ3A+awoIdyVbXMnF4sbVM1uhfT4L9v0BsUrY4xT8wyqS
         gMrU+rGZY1JF95MCX4UsNk8W55d8gyxp2uyBVmIwWiqTEVCHPZwDNjArki44dY6poTMu
         pY7AJt6aUGLH0KX/6QoMpjOu+VqBGz98FevR2WkGZR9UCmrUORCJqyomCanpca0+ErrL
         HN3gCAOJYaCmofpdnriLXrVvpmbyeIIps0UZE6QwAp7KHyYVAE+W9/6fm5mbXdSkUG6u
         G3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fUZoBFjO/vsp3cDiO+TNP6HxbVjdq2qyqXhhcYkxauo=;
        b=aTzxUCe7BRt1KLS2FvvUXT5fStNu9W7+x3vageXVgT7EWY6QFccQstULAEsHW5Id+s
         uas6/5l16wSXxUL5uXEImtLmCPrREtcGCnZswy/EXMAn4KDu3PRSQavmFW4DPBJMTQ3v
         cp+E76qTVHBATVPN6NwN7yAVWRp44TH0bq4mAlRb9xx96AnTGtmsDGh+gLMieprO1EMV
         90lxE9FX/9H6w7fTz4UHn4gm9IP7lAYRnAZFtX9gqaqIp1JedEs1hwtx2RPKbMedYhaf
         hHmx/qQRIEUE2RcN54MaoruRN3lgfJ9tKA2UYC9RaV6kLNLE/JaH2XAhpo40IlyHUeIv
         PJQA==
X-Gm-Message-State: AOAM5336sS3G+0XUWbhzlSLKvLtBFFyaPtniSEunM8mJehkNHHH7pN0q
        uWc22lrtL0VpTplLw9sfGvpGdMbXsDI=
X-Google-Smtp-Source: ABdhPJyf/yjyVvzKXfqAE0ii0+bNrnCevQLq7kHv90igLqLgCzdaY1+0Fq86nNW+PVS5UqqqGycajg==
X-Received: by 2002:a17:906:7f8a:: with SMTP id f10mr6525167ejr.12.1621181870749;
        Sun, 16 May 2021 09:17:50 -0700 (PDT)
Received: from [192.168.178.40] (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id y19sm9124870edc.73.2021.05.16.09.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 May 2021 09:17:50 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: target: tcmu: Fix xarray RCU warning
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20210515065006.210238-1-shinichiro.kawasaki@wdc.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <c736b783-9965-2bd9-e38b-b5188b34872e@gmail.com>
Date:   Sun, 16 May 2021 18:17:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210515065006.210238-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15.05.21 08:50, Shin'ichiro Kawasaki wrote:
> Commit f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE = N *
> PAGE_SIZE") introduced xas_next() calls to iterate xarray elements.
> These calls triggered the WARNING "suspicious RCU usage" at tcmu device
> set up [1]. In the call stack of xas_next(), xas_load() was called.
> According to its comment, this function requires "the xa_lock or the RCU
> lock".
> 
> To avoid the warning, guard xas_next() calls. For the small loop of
> xas_next(), guard with the RCU lock. For the large loop of xas_next(),
> guard with the xa_lock using xas_lock().
> 
> [1]
> 
> [ 1899.867091] =============================
> [ 1899.871199] WARNING: suspicious RCU usage
> [ 1899.875310] 5.13.0-rc1+ #41 Not tainted
> [ 1899.879222] -----------------------------
> [ 1899.883299] include/linux/xarray.h:1182 suspicious rcu_dereference_check() usage!
> [ 1899.890940] other info that might help us debug this:
> [ 1899.899082] rcu_scheduler_active = 2, debug_locks = 1
> [ 1899.905719] 3 locks held by kworker/0:1/1368:
> [ 1899.910161]  #0: ffffa1f8c8b98738 ((wq_completion)target_submission){+.+.}-{0:0}, at: process_one_work+0x1ee/0x580
> [ 1899.920732]  #1: ffffbd7040cd7e78 ((work_completion)(&q->sq.work)){+.+.}-{0:0}, at: process_one_work+0x1ee/0x580
> [ 1899.931146]  #2: ffffa1f8d1c99768 (&udev->cmdr_lock){+.+.}-{3:3}, at: tcmu_queue_cmd+0xea/0x160 [target_core_user]
> [ 1899.941678] stack backtrace:
> [ 1899.946093] CPU: 0 PID: 1368 Comm: kworker/0:1 Not tainted 5.13.0-rc1+ #41
> [ 1899.953070] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
> [ 1899.962459] Workqueue: target_submission target_queued_submit_work [target_core_mod]
> [ 1899.970337] Call Trace:
> [ 1899.972839]  dump_stack+0x6d/0x89
> [ 1899.976222]  xas_descend+0x10e/0x120
> [ 1899.979875]  xas_load+0x39/0x50
> [ 1899.983077]  tcmu_get_empty_blocks+0x115/0x1c0 [target_core_user]
> [ 1899.989318]  queue_cmd_ring+0x1da/0x630 [target_core_user]
> [ 1899.994897]  ? rcu_read_lock_sched_held+0x3f/0x70
> [ 1899.999695]  ? trace_kmalloc+0xa6/0xd0
> [ 1900.003501]  ? __kmalloc+0x205/0x380
> [ 1900.007167]  tcmu_queue_cmd+0x12f/0x160 [target_core_user]
> [ 1900.012746]  __target_execute_cmd+0x23/0xa0 [target_core_mod]
> [ 1900.018589]  transport_generic_new_cmd+0x1f3/0x370 [target_core_mod]
> [ 1900.025046]  transport_handle_cdb_direct+0x34/0x50 [target_core_mod]
> [ 1900.031517]  target_queued_submit_work+0x43/0xe0 [target_core_mod]
> [ 1900.037837]  process_one_work+0x268/0x580
> [ 1900.041952]  ? process_one_work+0x580/0x580
> [ 1900.046195]  worker_thread+0x55/0x3b0
> [ 1900.049921]  ? process_one_work+0x580/0x580
> [ 1900.054192]  kthread+0x143/0x160
> [ 1900.057499]  ? kthread_create_worker_on_cpu+0x40/0x40
> [ 1900.062661]  ret_from_fork+0x1f/0x30
> 
> Fixes: f5ce815f34bc ("scsi: target: tcmu: Support DATA_BLOCK_SIZE = N * PAGE_SIZE")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
> Changes from v1:
> * Used xas_(un)lock() instead of rcu_read_(un)lock() for the large loop
> 
>   drivers/target/target_core_user.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 198d25ae482a..834bd3910de8 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -516,8 +516,10 @@ static inline int tcmu_get_empty_block(struct tcmu_dev *udev,
>   	dpi = dbi * udev->data_pages_per_blk;
>   	/* Count the number of already allocated pages */
>   	xas_set(&xas, dpi);
> +	rcu_read_lock();
>   	for (cnt = 0; xas_next(&xas) && cnt < page_cnt;)
>   		cnt++;
> +	rcu_read_unlock();
>   
>   	for (i = cnt; i < page_cnt; i++) {
>   		/* try to get new page from the mm */
> @@ -727,6 +729,7 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
>   			page_cnt = udev->data_pages_per_blk;
>   
>   		xas_set(&xas, dbi * udev->data_pages_per_blk);
> +		xas_lock(&xas);
>   		for (page_inx = 0; page_inx < page_cnt && data_len; page_inx++) {
>   			page = xas_next(&xas);
>   
> @@ -763,6 +766,7 @@ static inline void tcmu_copy_data(struct tcmu_dev *udev,
>   			if (direction == TCMU_SG_TO_DATA_AREA)
>   				flush_dcache_page(page);
>   		}
> +		xas_unlock(&xas);
>   	}
>   }
>   
> 

Thank you for v2 patch.

May I ask you to put xas_lock before the big outer "while" loop and the
xas_unlock behind it? Since we hold the cmdr_lock mutex when calling
tcmu_copy_data, it doesn't harm to hold xas lock for duration of entire
data copy. So let's take the lock once before starting the loop and
release it after data copy is done. That saves some cpu cycles if
data consists of multiple data blocks.

-Bodo
