Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8B2C432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 03:31:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 826EE206DB
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 03:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbfKPDbM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 22:31:12 -0500
Received: from smtp.infotech.no ([82.134.31.41]:49934 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727323AbfKPDbL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Nov 2019 22:31:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E43DA204191;
        Sat, 16 Nov 2019 04:31:09 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ur7A6L6K-T6h; Sat, 16 Nov 2019 04:31:03 +0100 (CET)
Received: from [192.168.0.207] (unknown [110.150.152.53])
        by smtp.infotech.no (Postfix) with ESMTPA id 2812F204162;
        Sat, 16 Nov 2019 04:31:01 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi_debug: num_tgts must be >= 0
To:     Maurizio Lombardi <mlombard@redhat.com>, jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20191115163727.24626-1-mlombard@redhat.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <a52b6464-c710-3477-a79d-dca0b9915bf6@interlog.com>
Date:   Sat, 16 Nov 2019 14:30:57 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191115163727.24626-1-mlombard@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-16 3:37 a.m., Maurizio Lombardi wrote:
> Passing the parameter "num_tgts=-1" will start
> an infinite loop that exhausts the system memory

Ouch.

> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index d323523f5f9d..32965ec76965 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5263,6 +5263,11 @@ static int __init scsi_debug_init(void)
>   		return -EINVAL;
>   	}
>   
> +	if (sdebug_num_tgts < 0) {
> +		pr_err("num_tgts must be >= 0\n");
> +		return -EINVAL;
> +	}
> +
>   	if (sdebug_guard > 1) {
>   		pr_err("guard must be 0 or 1\n");
>   		return -EINVAL;
> 

