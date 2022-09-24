Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FC58C6FA82
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 05:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbiIXF2X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Sep 2022 01:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbiIXF2W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Sep 2022 01:28:22 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8151449E2
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 22:28:21 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f193so2071027pgc.0
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 22:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=n9mIFFUz+T7uzqeFEnuohJ6a+X7KhoEOiIg4sADalFc=;
        b=DMo/kxxHl+Sb+Hj218OrIpHroTvFp5bVZW/blQ+vD2xPuKFvzWV2XfFMYZC1slpkHg
         RKrTtkaoAGI0KeDNQ12tSDjhEm+ho4NrFro1D2Di0rypfTv40/6Fqz49lkpFtSMKXW+b
         q8+2e6If6ow7WCVv3mHzBTuCjepy7Z4j64V4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=n9mIFFUz+T7uzqeFEnuohJ6a+X7KhoEOiIg4sADalFc=;
        b=wcRRneLPXqL4b66cxKyG3HOvbwA7jKeBmN5mXIBThXLonfwYs8TeFB8Tq+DgDpsztk
         zlV5XrokY6pvwScFlsLm10LTHlP7IkhGuaH+3jO+v7w97eSoP+XG1Uyo7LMW8nd+kExU
         j7/AXnL7wJ2tRd/qemz0ZhsJ15jXXwcJCQ/G5txXiwrINHXA8dn001d7MpuvlPlYfA3J
         E5nCnLIBJey2WpPaW5PZPWXH0yUgjWmxWecj/yDGowYjM2oxZlOgL9Oh6uiDfExm4YKC
         LJtKUWrnehnZVX4xN1m99bJUl3vcRtE7M5zT/hL6Bq57eBjEIo6BYoKUixelqOZWifCD
         FbPQ==
X-Gm-Message-State: ACrzQf2yq7FB5bii7oXqfs1NJID5INNoVhev3EyFFWXNq/BD5WiHBcx/
        DxwnJfUoyuEN/B2VGpEBdhASaw==
X-Google-Smtp-Source: AMsMyM7aAuSih3DGaIHDIjGNOp3XiITsYugjJXNQV613GX2y2nc6YZcMCh4lpIlCsz/1lj5HVe6+Gw==
X-Received: by 2002:a63:470e:0:b0:438:a091:5a3b with SMTP id u14-20020a63470e000000b00438a0915a3bmr10499420pga.332.1663997300746;
        Fri, 23 Sep 2022 22:28:20 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y21-20020a626415000000b0053e607a6bf0sm7359583pfb.43.2022.09.23.22.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 22:28:20 -0700 (PDT)
Date:   Fri, 23 Sep 2022 22:28:19 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: 3w-xxxx: Replace one-element array with
 flexible-array member
Message-ID: <202209232227.7D348DF@keescook>
References: <YyyyvB30jnjRaw/F@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyyyvB30jnjRaw/F@work>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 22, 2022 at 02:08:44PM -0500, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct TAG_TW_New_Ioctl and refactor the rest of the code,
> accordingly.
> 
> Notice that, in multiple places, the subtraction of 1 from
> sizeof(TW_New_Ioctl) is removed, as this operation is now implicit
> after the flex-array transformation.

Doing a build before/after this patch results in no binary output
differences. Another 1-element array converted! :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
