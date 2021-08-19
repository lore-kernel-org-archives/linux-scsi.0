Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B4CC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 03:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D85F26108E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 03:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbhHSDLj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 23:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235920AbhHSDLh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 23:11:37 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB656C061764
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 20:11:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id gz13-20020a17090b0ecdb0290178c0e0ce8bso6393897pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 20:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rl+Oi5khJo7hFK7PBKKHjQStJ64ZgXoOec1kgWLG674=;
        b=bXo9ZMG6KTE8mnZRG6kTIcdSOofux9kWlkge9EiafdecULnl4pDv6y5BSK64lRK65/
         7rjz8glJ0sUo2uABQMHnyCEmTSa0iiTbdGALtYV+1ybUl3Y2tA7P0+gNcKPFYDdJYdt+
         pKoLftcVmWPuYyFTweUBD6lA9akWqxY6LzOm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rl+Oi5khJo7hFK7PBKKHjQStJ64ZgXoOec1kgWLG674=;
        b=F0lnHIAigKUy8q134Q52eYGlFwpGRUjQD6hvmTOpzm8gqod+T9tsqam+IY+Cypr50H
         uIn6riayDreKXKyHPFk73tCGtw7zAI77vAMscpreC1u8+JOCThzjhyCA/ZmJDJUtnszg
         iTmir5MmYrJaYdO2HaijF2B1323lwn5s4RqZoih0fmUK+i/BIG0DyFZvfKs0MkI/R0QO
         8DmVunHNEQqDPjYVigvWdSWD6KMBNaF7NJu8Vg5SsnTq52ffCKvplQVF1GLcHjIdA7Y2
         8w5JhWSvkr4hqrdXeOyLtVCewIr337oE7kjwzAKsa4RAfxloDENEOmiRdsVBtzmbutqu
         yQJA==
X-Gm-Message-State: AOAM531p0zyWsdZcWgQoVXci7+T8AefFG9Vm1I5W/fEiNd0iAfk+rJci
        /qkNPzgLO84EOhkX0MeOVoVLhg==
X-Google-Smtp-Source: ABdhPJz6rsd/Ws3McXCBRgp4UctWrFV3kyWzaRLVcXVV7WZmeINYmkYvWQBIdENbViDS/hfMGSzFHw==
X-Received: by 2002:a17:90a:da02:: with SMTP id e2mr13108754pjv.89.1629342661596;
        Wed, 18 Aug 2021 20:11:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t18sm1199910pfg.111.2021.08.18.20.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 20:11:00 -0700 (PDT)
Date:   Wed, 18 Aug 2021 20:10:59 -0700
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
Subject: Re: [PATCH v2 2/2] lkdtm: remove IDE_CORE_CP crashpoint
Message-ID: <202108182010.C7278F4FAA@keescook>
References: <20210819022940.561875-1-kevmitch@arista.com>
 <20210819022940.561875-3-kevmitch@arista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210819022940.561875-3-kevmitch@arista.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 18, 2021 at 07:29:40PM -0700, Kevin Mitchell wrote:
> With the removal of the legacy IDE driver in kb7fb14d3ac63 ("ide: remove
> the legacy ide driver"), this crashpoint no longer points to a valid
> function.
> 
> Signed-off-by: Kevin Mitchell <kevmitch@arista.com>

Hah, whoops. Yes. :)

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

> ---
>  Documentation/fault-injection/provoke-crashes.rst | 3 +--
>  drivers/misc/lkdtm/core.c                         | 1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/Documentation/fault-injection/provoke-crashes.rst b/Documentation/fault-injection/provoke-crashes.rst
> index 18de17354206..3abe84225613 100644
> --- a/Documentation/fault-injection/provoke-crashes.rst
> +++ b/Documentation/fault-injection/provoke-crashes.rst
> @@ -29,8 +29,7 @@ recur_count
>  cpoint_name
>  	Where in the kernel to trigger the action. It can be
>  	one of INT_HARDWARE_ENTRY, INT_HW_IRQ_EN, INT_TASKLET_ENTRY,
> -	FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_QUEUE_RQ,
> -	IDE_CORE_CP, or DIRECT
> +	FS_DEVRW, MEM_SWAPOUT, TIMERADD, SCSI_QUEUE_RQ, or DIRECT.
>  
>  cpoint_type
>  	Indicates the action to be taken on hitting the crash point.
> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
> index 016cb0b150fc..e50e7bfc4674 100644
> --- a/drivers/misc/lkdtm/core.c
> +++ b/drivers/misc/lkdtm/core.c
> @@ -83,7 +83,6 @@ static struct crashpoint crashpoints[] = {
>  	CRASHPOINT("MEM_SWAPOUT",	 "shrink_inactive_list"),
>  	CRASHPOINT("TIMERADD",		 "hrtimer_start"),
>  	CRASHPOINT("SCSI_QUEUE_RQ",	 "scsi_queue_rq"),
> -	CRASHPOINT("IDE_CORE_CP",	 "generic_ide_ioctl"),
>  #endif
>  };
>  
> -- 
> 2.32.0
> 

-- 
Kees Cook
