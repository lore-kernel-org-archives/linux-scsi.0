Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9597AC4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 03:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C3A861100
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 03:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbhHSDLF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbhHSDLE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 23:11:04 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A69C061764
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 20:10:29 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id oc2-20020a17090b1c0200b00179e56772d6so460590pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 20:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=44tEnZFPFnBMsICDtIDsLD4D1O3OeCUDGBmdVAHfoDE=;
        b=EEM9oA9fPM97nMDhCOZjD5M8wpHvZO1+W3YsUtdCzMsJdwqORrENCbGJWLlPX1vbIY
         MqHWurAFPzr+SNHLyx3+w7pVpso1SS7CxHwSh2e0f74VmsWG38Vo6z7+io2TxfjDAqSh
         kydrkFmMssM7qZhPX1T8VIrntvSkHVjvxymcI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=44tEnZFPFnBMsICDtIDsLD4D1O3OeCUDGBmdVAHfoDE=;
        b=eov3IVzUcZotjiPSq1OPd0K+zQGTzrHPeLW7SXVccf/9Hv9Cvt6Y5oWT6+l6e4R6Wu
         gliBViuRovoW6XgEe+XEDBsYYotwGJXeHKZalanH8d5pzEbF9XIyXNZqH3ie7k2ukg87
         L9kI7a3xT/qx7lu2x85E8cPSk9sOi8anvVkJDOE/n/kTguNa31Egy4pwIcMhupKc7af5
         3WVMzQWfTS31OoTSsE03G6XaEWBZrV1Ak2HZBINCjAU0Yq8w/wq9Gpjf+h6m9tS79Wz5
         GcMOMFZrLBB14QnL+1SKam8bXdR6yVbyWIXT9ihf2PrmSHJKRdQ/1F7Wa4NR2PLBC1LD
         CXww==
X-Gm-Message-State: AOAM533IpraDlf/aqerP0fbdw24em6Hu1dPcRnXwomPoDZBUyiqfrRHQ
        Ykm+mKMEmQvA/zo6ntO+8bnDPg==
X-Google-Smtp-Source: ABdhPJyq5B8Qpp8tC4kDn23OtU+6Gmeo14EFvstV64HOICyjAYh7sKstIPlJToWfUwawegf6cVB0Yw==
X-Received: by 2002:a17:90a:e88:: with SMTP id 8mr12706324pjx.108.1629342628598;
        Wed, 18 Aug 2021 20:10:28 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id ge6sm6499248pjb.52.2021.08.18.20.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 20:10:28 -0700 (PDT)
Date:   Wed, 18 Aug 2021 20:10:27 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Kevin Mitchell <kevmitch@arista.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] lkdtm: replace SCSI_DISPATCH_CMD with
 SCSI_QUEUE_RQ
Message-ID: <202108182010.BB18020B8@keescook>
References: <20210819022940.561875-1-kevmitch@arista.com>
 <20210819022940.561875-2-kevmitch@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819022940.561875-2-kevmitch@arista.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 18, 2021 at 07:29:39PM -0700, Kevin Mitchell wrote:
> When scsi_dispatch_cmd was moved to scsi_lib.c and made static, some
> compilers (i.e., at least gcc 8.4.0) decided to compile this
> inline. This is a problem for lkdtm.ko, which inserted a kprobe
> on this function for the SCSI_DISPATCH_CMD crashpoint.
> 
> Move this crashpoint one function up the call chain to
> scsi_queue_rq. Though this is also a static function, it should never be
> inlined because it is assigned as a structure entry. Therefore,
> kprobe_register should always be able to find it.
> 
> Fixes: 82042a2cdb55 ("scsi: move scsi_dispatch_cmd to scsi_lib.c")
> Signed-off-by: Kevin Mitchell <kevmitch@arista.com>

Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  Documentation/fault-injection/provoke-crashes.rst | 2 +-
>  drivers/misc/lkdtm/core.c                         | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/fault-injection/provoke-crashes.rst b/Documentation/fault-injection/provoke-crashes.rst
> index a20ba5d93932..18de17354206 100644
> --- a/Documentation/fault-injection/provoke-crashes.rst
> +++ b/Documentation/fault-injection/provoke-crashes.rst
> @@ -29,7 +29,7 @@ recur_count
>  cpoint_name
>  	Where in the kernel to trigger the action. It can be
>  	one of INT_HARDWARE_ENTRY, INT_HW_IRQ_EN, INT_TASKLET_ENTRY,
> -	FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_DISPATCH_CMD,
> +	FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_QUEUE_RQ,
>  	IDE_CORE_CP, or DIRECT
>  
>  cpoint_type
> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
> index 9dda87c6b54a..016cb0b150fc 100644
> --- a/drivers/misc/lkdtm/core.c
> +++ b/drivers/misc/lkdtm/core.c
> @@ -82,7 +82,7 @@ static struct crashpoint crashpoints[] = {
>  	CRASHPOINT("FS_DEVRW",		 "ll_rw_block"),
>  	CRASHPOINT("MEM_SWAPOUT",	 "shrink_inactive_list"),
>  	CRASHPOINT("TIMERADD",		 "hrtimer_start"),
> -	CRASHPOINT("SCSI_DISPATCH_CMD",	 "scsi_dispatch_cmd"),
> +	CRASHPOINT("SCSI_QUEUE_RQ",	 "scsi_queue_rq"),
>  	CRASHPOINT("IDE_CORE_CP",	 "generic_ide_ioctl"),
>  #endif
>  };
> -- 
> 2.32.0
> 

-- 
Kees Cook
