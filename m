Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB224C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EDE464EDF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:25:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhBBIZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbhBBISf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 03:18:35 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AE7C06174A
        for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2021 00:17:54 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m1so1455621wml.2
        for <linux-scsi@vger.kernel.org>; Tue, 02 Feb 2021 00:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ACGAKZnb6JF4l8ikEp5I5AXDxCVsSoURups5lEzImcE=;
        b=faVgTeBCLeqPvkrmO4za/Et/AIZPpbyYeOSQwvHRa9gdZ2t4QAgk5uHJv5ELGJyfWx
         NkW06AKTrif2dFxuIWk9dry3jBm80jDcKSAwR+3ic2S+E2AAtxF4udrC71YF65Y0tO3u
         7DeAp0qh96TSD3KmOfO+E1qFOaGHSmzNHJTP1Nb2G0+QA14xARDqk8MP+ptlN3uFwcKI
         7vzCnPl/s0q93U1hzL1wUoiRTPZ8QqYlU8TMztPh09dh5E/z9izsSuQGckGZD+JXdAGe
         tvLAIdwmpIJdI2YMcngrqC3yFgBxmKtzzy4z98byi4krI9324BskEq4vkdLQx9jKpy/8
         N90w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ACGAKZnb6JF4l8ikEp5I5AXDxCVsSoURups5lEzImcE=;
        b=EyZl+pJ/yLkZR0LGKxZKfKfgCrwcZXqe3oIAJXvObj5EzRNeAxjbNOlWccCl+wSTE1
         tGTVVVBcCwNyMSVGGUapzUaC/dufzNQXL4888LE/1UNOFkp09Yn4u2II3A4WhlvtU+NA
         h3d3wJWiHJxVx2oQD6LLjdtUSFWHpsw1elT8OjrhYR33rIszY8zHzzpBipWTKqXJT9We
         6JFH+WvF07sgsvZtM8zn26sHJPgBN6BC41VPaXpDSJlTH4dAI/Nfs/LseCehXi79wQgV
         tig8d8f0qQiFmiNo8glW6K8DOmjxaPXiSeLkq5SOZ5D727hKXiBLg9j4hH9wcd7PdzLU
         HUfQ==
X-Gm-Message-State: AOAM532eAYZigOA1Sbi+vlx6XTKTIKrlGnsCXV9dATUCoHQSJf+p8TGd
        p5PPOOHiZzFhJ79jab1RtQkXGw==
X-Google-Smtp-Source: ABdhPJxxw8SaCGfa18oKKwhPP66vF4sF3f2ps9se2LMWTc4wfpbd+MEzuOcdQstMg0aiFEYB2sBnxw==
X-Received: by 2002:a1c:e905:: with SMTP id q5mr2443624wmc.84.1612253873405;
        Tue, 02 Feb 2021 00:17:53 -0800 (PST)
Received: from dell ([91.110.221.188])
        by smtp.gmail.com with ESMTPSA id d10sm5269530wrn.88.2021.02.02.00.17.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 00:17:52 -0800 (PST)
Date:   Tue, 2 Feb 2021 08:17:51 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Satish Kharat <satishkh@cisco.com>,
        Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: pmcraid: fix 'ioarcb' alignment warning
Message-ID: <20210202081751.GZ4774@dell>
References: <20210201170013.727112-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210201170013.727112-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 01 Feb 2021, Arnd Bergmann wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> Building with 'make W=1' enables -Wpacked-not-aligned, and this
> warns about pmcraid because of incompatible alignment constraints for
> pmcraid_passthrough_ioctl_buffer:
> 
> drivers/scsi/pmcraid.h:1044:1: warning: alignment 1 of 'struct pmcraid_passthrough_ioctl_buffer' is less than 32 [-Wpacked-not-aligned]
>  1044 | } __attribute__ ((packed));
>       | ^
> drivers/scsi/pmcraid.h:1041:24: warning: 'ioarcb' offset 16 in 'struct pmcraid_passthrough_ioctl_buffer' isn't aligned to 32 [-Wpacked-not-aligned]
>  1041 |  struct pmcraid_ioarcb ioarcb;
> 
> The inner structure is documented as having 32 byte alignment here,
> but is starts at a 16 byte offset in the outer structure, so it's never
> actually aligned, as the outer structure is also marked 'packed'.
> 
> Lee Jones point this out as one of the last files that need to be changed
> before the warning can be enabled by default.
> 
> Change the annotations in a way that avoids the warning but leaves the
> layout unchanged, by removing the packing on the inner structure and
> adding it to the outer one. The one-byte request_buffer[] array should
> have been a flexible array member here, which is how I change it to
> avoid extra padding from the alignment attribute.

Looks good to me.

Reviewed-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
