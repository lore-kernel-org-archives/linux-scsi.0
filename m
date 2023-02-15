Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2E8C636CC
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Feb 2023 21:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjBOVcZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Feb 2023 16:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjBOVcX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2023 16:32:23 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2049526CE8
        for <linux-scsi@vger.kernel.org>; Wed, 15 Feb 2023 13:32:22 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id bt4-20020a17090af00400b002341621377cso3725675pjb.2
        for <linux-scsi@vger.kernel.org>; Wed, 15 Feb 2023 13:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kfYEghNnaEjUfoOcnZ4G0+8zAvGSYgSt957kdbuuys4=;
        b=d1rnikvOvf/SGy/v2+qrDhe4dbC1eCnXDz2MDCEFQFrQmdniFgCZOM0UH4WI+8mPwQ
         rlJUw1nQQEmDoXRV0zbXQF6kb7rEpfJHHVQHdB3XjGdjohKrW7Iwhl5w5fjc/7y68clN
         O0NbwwIz7iyeQ9gHUSU7DHnh/S+DprlGjeGqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfYEghNnaEjUfoOcnZ4G0+8zAvGSYgSt957kdbuuys4=;
        b=3qjZFuYR+5Or4ilWmbcQLjD23VBwS7OdmMqyp0KL30XJ4mVWxhEvnTSZ+33HtzCQBo
         RdRjE3NCq9948mFgpcXE4kWaKty/C+t1jR29g6ooA872WX6/7dYCndw0rzrUYyPjMTHN
         PoY6AQLRZAIreXmsY/2UBZ8vidoY7IbVvfUKjen8UG2cVzE+Wm5V5rwX4aGBCkRGlZ9g
         qQvqae8GVrIIBmDJgF49/lTOEm8NK5rQ8V3cMwsBFKs/mvN55vj+6Eu0gYwWtwLtjgCA
         mEPBOkv5aamnLXPIjo9zJxfjMC9mJp95v7wd2vXfZvOFbx/C2wldvBoa7g7+Tk9IebT5
         LvCA==
X-Gm-Message-State: AO0yUKXHjfdWyunu1olxZEinzNXatPHe+w5X1Cy3yC8snnCvKXUWlN3j
        tazT0qa+pnHIRlngff+0wW03ew==
X-Google-Smtp-Source: AK7set+wTlRh8SP7In9F+w0tsSMTRd836XZmLAJXyqYif3yvQ2ETEmZh7wyNqIPWtp3PhiL6eWURgA==
X-Received: by 2002:a17:903:120e:b0:197:35fc:6a5d with SMTP id l14-20020a170903120e00b0019735fc6a5dmr4153057plh.30.1676496741565;
        Wed, 15 Feb 2023 13:32:21 -0800 (PST)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902b58a00b001991e4e0bdcsm12548670pls.233.2023.02.15.13.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 13:32:21 -0800 (PST)
Message-ID: <63ed4f65.170a0220.b2f75.8a8f@mx.google.com>
X-Google-Original-Message-ID: <202302151330.@keescook>
Date:   Wed, 15 Feb 2023 13:32:20 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        James Bottomley <James.Bottomley@steeleye.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        John Garry <john.g.garry@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Subject: Re: [PATCH] [v2] scsi: ipr: work around fortify-string warning
References: <20230214132831.2118392-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214132831.2118392-1-arnd@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 14, 2023 at 02:28:08PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The ipr_log_vpd_compact() function triggers a fortified memcpy() warning
> about a potential string overflow with all versions of clang:
> 
> In file included from drivers/scsi/ipr.c:43:
> In file included from include/linux/string.h:254:
> include/linux/fortify-string.h:520:4: error: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
>                         __write_overflow_field(p_size_field, size);
>                         ^
> include/linux/fortify-string.h:520:4: error: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror,-Wattribute-warning]
> 2 errors generated.
> 
> I don't see anything actually wrong with the function, but this is the
> only instance I can reproduce of the fortification going wrong in the
> kernel at the moment, so the easiest solution may be to rewrite the
> function into something that does not trigger the warning.
> 
> Instead of having a combined buffer for vendor/device/serial strings,
> use three separate local variables and just truncate the whitespace
> individually.
> 
> Fixes: 8cf093e275d0 ("[SCSI] ipr: Improved dual adapter errors")
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

Reproduced this locally -- I agree your fix looks like the best
approach. I think Clang was seeing the old "i + 2" return as potentially
overflowing in the case where there was no space-padding on any strings.

-- 
Kees Cook
