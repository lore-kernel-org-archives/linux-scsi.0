Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D027C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 17:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2126064E82
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 17:40:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbhBHRjm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 12:39:42 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:42043 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhBHRjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 12:39:00 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id D1AFC2EA01C;
        Mon,  8 Feb 2021 12:38:08 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id yWrd7OP0IjJq; Mon,  8 Feb 2021 12:23:10 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 249422EA12B;
        Mon,  8 Feb 2021 12:38:08 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi: scsi_debug: fix a memory leak.
To:     Maurizio Lombardi <mlombard@redhat.com>, jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20210208111734.34034-1-mlombard@redhat.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <c6d19bf6-6f4c-6820-ff28-7324fee1786d@interlog.com>
Date:   Mon, 8 Feb 2021 12:38:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210208111734.34034-1-mlombard@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-08 6:17 a.m., Maurizio Lombardi wrote:
> The sdebug_q_arr pointer must be freed when the module is unloaded
> 
> # cat /sys/kernel/debug/kmemleak
> unreferenced object 0xffff888e1cfb0000 (size 4096):
>    comm "modprobe", pid 165555, jiffies 4325987516 (age 685.194s)
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace:
>      [<00000000458f4f5d>] 0xffffffffc06702d9
>      [<000000003edc4b1f>] do_one_initcall+0xe9/0x57d
>      [<00000000da7d518c>] do_init_module+0x1d1/0x6f0
>      [<000000009a6a9248>] load_module+0x36bd/0x4f50
>      [<00000000ddb0c3ce>] __do_sys_init_module+0x1db/0x260
>      [<000000009532db57>] do_syscall_64+0xa5/0x420
>      [<000000002916b13d>] entry_SYSCALL_64_after_hwframe+0x6a/0xdf
> 
> Fixes: 87c715dcde633f4cc4690a24a240e838181e6a9d
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/scsi_debug.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 4a08c450b756..b6540b92f566 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -6881,6 +6881,7 @@ static void __exit scsi_debug_exit(void)
>   
>   	sdebug_erase_all_stores(false);
>   	xa_destroy(per_store_ap);
> +	kfree(sdebug_q_arr);
>   }
>   
>   device_initcall(scsi_debug_init);
> 

