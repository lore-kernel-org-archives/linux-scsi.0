Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF5CC25B48
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 00:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344718AbjJYAa6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 20:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344762AbjJYAa4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 20:30:56 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439DE10CE
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 17:30:53 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 46e09a7af769-6ce37683cf6so3216114a34.3
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 17:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1698193852; x=1698798652; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n87sUffC3jIAj0OzBWNWPGKXdWXX/v+Z+ob+S6qU1cI=;
        b=gudDxT+cXy6mPPgK/JaxC2ja7o1tqiFTSOrZ0XCCODP+5xdE+GmsWHthqvk5JgLtam
         WPyLScPVm3WtFPmtzf8U5e7K+Z+hXQPXRvwHfXV4AqmAwUythEAhdQnUNHMP4VpfuvMo
         bT8yPwpYiC6c7XdEXDJzEv2yViJMt6JIfOP2A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698193852; x=1698798652;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n87sUffC3jIAj0OzBWNWPGKXdWXX/v+Z+ob+S6qU1cI=;
        b=TnBDPB/ONaJDq2kPW78Idi3ZEEFxw0GUi8k3zuske0G8f0Acz+BxR6w6tu1w5cEwps
         EpEThT8jrIwCECCP88WuwqbnvpF+vLvHHwcsHX7/VWCPINt458V1PFQpbRopyU83Xc3R
         vEr9N9UInoEWEs3r2VakQg74U9HxXx3EMttv5hjLCnqgdP/6rkBJE1/Cj1vagIcGz3RQ
         N5x3T/TzrZHe3sAJe3tjPezdGcBn4XwnF9iiMtXdrwULCP1G6iHolNqCr8pov/G1PsVe
         1Mc38gGDVEnD6xsH+NyNGsXeETO4qRsMo0WIzQ9deJmm/X+2XJfqO6FeVvT2mCr2UFj6
         bPhw==
X-Gm-Message-State: AOJu0Yzpfc8y/yf+ZJmxi7qZri8X8V2Bcdsj90Wq0mTj39qBsrRfuK1u
        Vjn5sECWcUFpZ9f5Hc0cBWsxHQ==
X-Google-Smtp-Source: AGHT+IHMIcGzMvlGzYich5XJqb+MzqzGw+o2xZJVqCap7MFd+7g+sf/Oe43NAa3axzWaxPoppkLzdA==
X-Received: by 2002:a05:6870:a99a:b0:1d5:40df:8fb1 with SMTP id ep26-20020a056870a99a00b001d540df8fb1mr16097059oab.19.1698193852500;
        Tue, 24 Oct 2023 17:30:52 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id n3-20020a632703000000b005ae776b8616sm1343461pgn.19.2023.10.24.17.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 17:30:51 -0700 (PDT)
Date:   Tue, 24 Oct 2023 17:30:51 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: csiostor: replace deprecated strncpy with strscpy
Message-ID: <202310241730.7AA375902@keescook>
References: <20231023-strncpy-drivers-scsi-csiostor-csio_init-c-v1-1-5ea445b56864@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023-strncpy-drivers-scsi-csiostor-csio_init-c-v1-1-5ea445b56864@google.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 08:26:13PM +0000, Justin Stitt wrote:
> strncpy() is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> `hw` is kzalloc'd just before this string assignment:
> |       hw = kzalloc(sizeof(struct csio_hw), GFP_KERNEL);
> 
> ... which means any NUL-padding is redundant.
> 
> Since  CSIO_DRV_VERSION is a small string literal (smaller than
> sizeof(dest)):
> 
> ... there is functionally no change in this swap from strncpy() to
> strscpy(). Nonetheless, let's make the change for robustness' sake -- as
> it will ensure that drv_version is _always_ NUL-terminated.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Another direct replacement.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
