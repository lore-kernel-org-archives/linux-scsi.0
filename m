Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01423C25B67
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 17:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231811AbjJZRpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 13:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjJZRpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 13:45:32 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7C710E
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 10:45:30 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6bee11456baso1138282b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 10:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1698342329; x=1698947129; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lAfQHwAPGilY5JFUvY07Iu65/aCmQBkbdIAGwWe4Mw4=;
        b=OOokzr/xpQa586UCRy1xcsAo2JXtjXKK1A4AH0Mi0GigDWK5n5q4u1PR/MPf7y4mZx
         6lfsYsgMkX3AgdzCDUoaVBEAyZ6mKBXXMfIbGM7AQzKUgVkEUaMNlphLER8SP3XX3QRD
         RJOB3ss9gxH8pBplRtLEDGjf1MqM7kQSLI8uA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698342329; x=1698947129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAfQHwAPGilY5JFUvY07Iu65/aCmQBkbdIAGwWe4Mw4=;
        b=SdSpnjYdDSD0jswgRufSTKZeDCOG+JdCi5MEfN1/uEs8wULwYJmRUCS6S+86r2Gg5M
         jLLk1ulBtVc/VgZUL9t6PPAMnnRq/KP6lkHA+WxIjj6Jf9WOMbS0oF67A9GnEk2lmWyt
         Qn+MimBITWwgAfkpQ/bohiHvruS2gAU0k+Xb4jtOzv2LR4W2vXxZGnt7y8JsCDsd2yYE
         /+AV2H5axSIlPB0mBf0io8O3ELoXyXm9xv29HM+cAtLvGWQlO/j+KtSsjzkNKcLj3CTL
         m3yrzA55P09pFInKRBXVaZxmk805GOvj6Bg+gAi9AhdOjnyOb1DO9uth48gOXHmb0UdO
         j1XQ==
X-Gm-Message-State: AOJu0Yyj5Dd1W1J/XFRLiseevbPhmyTNk6/pB37Z3yMDHtrUvewcp7FP
        CkRfz05+0aoUje6AbirWtjv3eJRo6I75g765ZZA=
X-Google-Smtp-Source: AGHT+IFBdjZbnbEQ859p1Brndxt1jXVT1XtY8KlXeTsIfFnjlV9Z2Y1YMFdXHByJlyYQdj3BFcCO5w==
X-Received: by 2002:a05:6a00:114c:b0:6bd:b7c5:f777 with SMTP id b12-20020a056a00114c00b006bdb7c5f777mr188412pfm.16.1698342329654;
        Thu, 26 Oct 2023 10:45:29 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id i3-20020aa787c3000000b006be047268d5sm11822297pfo.174.2023.10.26.10.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 10:45:29 -0700 (PDT)
Date:   Thu, 26 Oct 2023 10:45:28 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] scsi: elx: libefc: replace deprecated strncpy with
 strscpy_pad/memcpy
Message-ID: <202310261045.5D815BE@keescook>
References: <20231026-strncpy-drivers-scsi-elx-libefc-efc_node-h-v2-1-5c083d0c13f4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026-strncpy-drivers-scsi-elx-libefc-efc_node-h-v2-1-5c083d0c13f4@google.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 26, 2023 at 01:53:13AM +0000, Justin Stitt wrote:
> strncpy() is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> To keep node->current_state_name and node->prev_state_name NUL-padded
> and NUL-terminated let's use strscpy_pad() as this implicitly provides
> both.
> 
> For the swap between the two, a simple memcpy will suffice.
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

Thanks! I think this looks good now.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
