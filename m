Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 593F0C4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 19:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B779613BD
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 19:20:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhFATWa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 15:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbhFATW3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 15:22:29 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A4DC061756
        for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2021 12:20:47 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c12so288716pfl.3
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 12:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e8Ludc7+SRdC4P/GvfuW5pve9HdBju2sXZN9m9IZG0w=;
        b=QlFaI5TSMl7bx3+oJ7+7FCToZ007kP6DYaQnxVVxXTVvLgW1vXP5ldrI70BJqaHhIn
         E3A4tgiUYgEHFdbgAZfIh1R7hGpWO8HkenAuHMA5+UAwOp9P52HwqWpPX5ESon6sgFYz
         WHSf8UV5OtWk1pZU2BE+a2dx1ZeE/w9HTdcYQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e8Ludc7+SRdC4P/GvfuW5pve9HdBju2sXZN9m9IZG0w=;
        b=VdZofG9a+i/XqCRjiWc73K4gLzPtXJtBySMQ6WbKIMRE4pu2NQv6oIHjc8Mg9qWefl
         oAfAv0YajEkWWkCnFOKK4XjipMzA7X+n5ZknnARV5lY/a7Nmb8i0WoR8AkYDhL++kXyP
         SR6EFOV7Q/PKZPtD6zsXn3dmT6+Qaz9FFtwUjhpvkPjo8fNnsCOht74CGv4bJ1k77aSn
         19bZiHj7nrHcYR/I80ni+qSXx4+7xGXE6XkGq0JTn1swnVcVehkhvKriM8KFXme/J9zp
         8AjQ2zMpUpFCdR17syNsGh3lxVI28A17m5w/xpT8LarvzZmkTJ8+3kWXI6qFJfKqIq96
         nsOg==
X-Gm-Message-State: AOAM532lspdVHDgU+Xkb8F0iAMdI9hl4YLf+fha20Ue49e9c1uC8owQd
        0aN1fqX5dx9FPKXRZYZFT2qL4Q==
X-Google-Smtp-Source: ABdhPJwbxztlQ1QzCwxed9H51atEgwLlgUDY24XP2IBHwlNqCDjrOO3+Kp1oj8gKUUmoHKdqC3hpgg==
X-Received: by 2002:a63:451f:: with SMTP id s31mr7591039pga.209.1622575246796;
        Tue, 01 Jun 2021 12:20:46 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u13sm9789021pga.64.2021.06.01.12.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 12:20:45 -0700 (PDT)
Date:   Tue, 1 Jun 2021 12:20:45 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpt3sas: Fix fall-through warnings for Clang
Message-ID: <202106011220.97EF373@keescook>
References: <20210528200828.GA39349@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528200828.GA39349@embeddedor>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 28, 2021 at 03:08:28PM -0500, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix a couple
> of warnings by explicitly adding break statements instead of just letting
> the code fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
