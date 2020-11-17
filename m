Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94BBC6369E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 01:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8893424697
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 01:55:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aqmrosfB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgKQBza (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 20:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKQBz3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 20:55:29 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF7EC0613CF;
        Mon, 16 Nov 2020 17:55:28 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id u4so19058888qkk.10;
        Mon, 16 Nov 2020 17:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KEPcv8NsHyY9jn1p7ctfrHalxftbHgtxAgS6+iU39QQ=;
        b=aqmrosfBQ/5/PP8/aSzmMcASYA6bzhZZ0iLhCWySTuJ3zEqFQB/9C6UAqcIBj1fnr2
         LGhS6mTVor9TUp+QFdNEmtwgtmCIDmgr28ahA3iDTC/BIQo631GOGbUZmFwI6lsaL7Sm
         LtNldi2sik+cVNUOcyel/1xHElXyk4Drx/ZvQ39CHWyG9LHHBP3xvGmWYu8h4HS40YUs
         i0dKzgqvQ288lGgPKfsAE6I6tvfWueNLxJWqbcxYBPYGwGafXzPRGw9vsJFFfYCieBgK
         7Zos0Q/2MCnLpZGzcfk7SdKcj/kghkn7SqgXoml9AZ98wFqJPmlD4/JWReQ/X1AUoPCG
         BJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KEPcv8NsHyY9jn1p7ctfrHalxftbHgtxAgS6+iU39QQ=;
        b=SI2yhFrFU0nt40zj/pLj3lNZVqA1vgk/cFqYqI4mZ5WIE4lCJjB0sGWf45OhWNDU7S
         UcSnlNLfluSQiy/Hgorq7bv61qA5GbpYLI97tqjYKHP0ceuMjVqw3D/VYPwrjd9gaG8I
         kod+6XvNncTh5vIjo0JXz6jQIrCKpBEMrn/rzbcl9ImFdIrmThBNml+ZRc2puMAEe35i
         F9WSvcNK5dUDDwvjxsfmT1akv6LiDRSanZZDJa0OeB1cuqlN+h10IFajxaKVUNhRLqlv
         EAwkpB1p2TXwvMTr51PagFRE3X0CliacbAeOZ5L+2HVkby6eqe40FSDijE4wbj19OE9d
         YWoQ==
X-Gm-Message-State: AOAM5312bCTjcvcPIwYny8vjzYVPk5Fq86tiXTRE4Nmfafgq/ATjrSnv
        gVpGFOanMxQK3esGUFIxmz4=
X-Google-Smtp-Source: ABdhPJw9i642wA8GS5Vz69dYKUT5unO+SJAk/iIsFmxZYjbY39d80Y8HtJY3Oxea3EUINg/dGMgOrQ==
X-Received: by 2002:ae9:ea14:: with SMTP id f20mr17234195qkg.239.1605578128013;
        Mon, 16 Nov 2020 17:55:28 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id c6sm3401553qkg.54.2020.11.16.17.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 17:55:27 -0800 (PST)
Date:   Mon, 16 Nov 2020 18:55:25 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: remove obsolete variable in sd_remove()
Message-ID: <20201117015525.GA801777@ubuntu-m3-large-x86>
References: <20201116070035.11870-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116070035.11870-1-lukas.bulwahn@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 16, 2020 at 08:00:35AM +0100, Lukas Bulwahn wrote:
> Commit 140ea3bbf39a ("sd: use __register_blkdev to avoid a modprobe for an
> unregistered dev_t") removed blk_register_region(devt, ...) in sd_remove()
> and since then, devt is unused in sd_remove().
> 
> Hence, make W=1 warns:
> 
>   drivers/scsi/sd.c:3516:8:
>       warning: variable 'devt' set but not used [-Wunused-but-set-variable]
> 
> Simply remove this obsolete variable.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
