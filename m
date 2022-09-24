Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996C7C32771
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 05:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiIXFej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Sep 2022 01:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiIXFeh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Sep 2022 01:34:37 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE94EE09
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 22:34:32 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id jm5so1855334plb.13
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 22:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=mz4Rd8XWjT7uEpyICKIeRorRz31JPqdwkS3WoVtgZ1E=;
        b=YAnoJQHThRucbW61ua/u6xNobwvjSMsDBhWmagFZ+jbbrBjAwyHJJyB9yeBIr+6Zy/
         ovycT5eSDOxv1lYHVmEGovIeFd7IOJFrk7sEGwNL9eQXPQAHd7IXayXmzOpmFR/tDDzV
         192WwYusYzo/demCP5XvZzv+K+L4jFJ3cNbzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=mz4Rd8XWjT7uEpyICKIeRorRz31JPqdwkS3WoVtgZ1E=;
        b=Jne+lrRnp32ArZzUiWey6mR3/pqscMm+NKfeCioZ6nYJH34S4n256F1uJoz3todMr4
         H5aJv33y18EvIeHoFs+BS+PDaXhFlwyIESRWiJqjBgcsZGN3SPXco7RSg7LFKlsi8k9W
         6Ms3D9ByELD3fJDfCxCVRIni3PdkhShFPlPxizzYnw7Q/DdgT3YqP0hu1uRNywqtQght
         WBNbWpAyl3mMw2bkr3gmsd4oraiOwY+Rq30DGL0Lv/CiK9nOCvEKTHgx09AgUE/TxPoL
         VPQXlxfVjZn0gpvAaHxiYoWqzfjrZq3SVj+XABQPp2sEmOS7uwajqtRSSy8a5qagyd1C
         /eEg==
X-Gm-Message-State: ACrzQf3GOSzpOTZhSWNQA27E419iFE0bp7cCVu8jNS7DXJVC7JVzXF/y
        FSCndwNyfBZw8IRwZKqad3r3Lg==
X-Google-Smtp-Source: AMsMyM6eKPkiP7tFNEPog0WIlIXL+zDxpnUgG9qnl3Zw/qL9B1ZDflmlKJ96AswT2LjX30R8TtwzBg==
X-Received: by 2002:a17:90b:3ec2:b0:202:b123:29cc with SMTP id rm2-20020a17090b3ec200b00202b12329ccmr25574626pjb.167.1663997671985;
        Fri, 23 Sep 2022 22:34:31 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b21-20020aa79515000000b00537e40747adsm7346146pfp.36.2022.09.23.22.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 22:34:31 -0700 (PDT)
Date:   Fri, 23 Sep 2022 22:34:30 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: hptiop: Replace one-element array with
 flexible-array member in struct hpt_iop_request_ioctl_command
Message-ID: <202209232233.0C4FB343@keescook>
References: <YyyUvuId7dAZadej@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyyUvuId7dAZadej@work>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 22, 2022 at 12:00:46PM -0500, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct hpt_iop_request_ioctl_command.

I see no binary differences with the patch, so that's good! :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
