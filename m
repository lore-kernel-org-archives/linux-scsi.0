Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B3CFC71153
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 18:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbjH2StO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238551AbjH2Ssw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 14:48:52 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE3ACD6
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 11:48:47 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bf6ea270b2so29605695ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 11:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1693334927; x=1693939727;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WlpFwu22BuXcdAslyPLnhdHAaPNdS1lUhQ/bzoXJHU0=;
        b=KjzHMEZS1fi+BT9hdiRi+W2XW02HxQYoYIckKHIXt6urLwJwvMF1uKUCljUVryZ3Iu
         cf8z584cgA8JVHL+So+nlfKCTisXkUFWAXt842plGp40TLCpDNlBtnqfeg6ZNxNNCCkW
         grXX0rANGAXeDphxdobpmuEsJZhMU093xuD3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693334927; x=1693939727;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WlpFwu22BuXcdAslyPLnhdHAaPNdS1lUhQ/bzoXJHU0=;
        b=V1+pjsoY1Q8EiqQfw51Y2jPPb4VlB0FeSi4HNCqcT4Hs1m2Z1c9/lJJXYURoKb2v6x
         Q6tbaB9PXGq8ARklt3EGQanXdmtauIB7pEi6BBA8a/n3lLGxUEr1zRxT9dsBrasJr6+a
         6hE+3DvtVEG824fHmd2/A/OFSZrRBsckvrgnVRgTj1mpRO4N7uS38K47IrpGvKOE8M4o
         1D5vVyhYX2W116aV/+IHEcK8CwfuNmgrDIOX45EYYdyxs49ozu2vI2WFHmqowEWHmy03
         l9ZuF4h0XwpLvTZGumlSXQO3MHHlKTghKgWcrqEPc0149zxEgJUj35awMBOUkJnfFXF+
         s7fQ==
X-Gm-Message-State: AOJu0YzpI7C81YC1X63t2H99MrGbtnLlIFiXFuhl6S456WVUDYU13O/E
        BqzX6w+lznRQ1WIcZuwYYNiseQ==
X-Google-Smtp-Source: AGHT+IG6Sdl5CBNfsQf6qLGj2msuoi5Z+xNqTfNTxcW4FtLo4dCGfrPkxFnX0y+F/LV9qNNxHbnxKw==
X-Received: by 2002:a17:903:1212:b0:1bd:b8c0:b58f with SMTP id l18-20020a170903121200b001bdb8c0b58fmr29470329plh.50.1693334927083;
        Tue, 29 Aug 2023 11:48:47 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902748600b001b2069072ccsm9708751pll.18.2023.08.29.11.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 11:48:46 -0700 (PDT)
Date:   Tue, 29 Aug 2023 11:48:45 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Tom Rix <trix@redhat.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH 0/2] scsi: fix 2 cases of -Wfortify-source
Message-ID: <202308291147.2CB91AB9@keescook>
References: <20230828-scsi_fortify-v1-0-8dde624a3b2c@google.com>
 <CAKwvOdmaeupeLgJWjMD4iJ1pi9NFTN-MTp3uC0jDVp2T2+Ctxw@mail.gmail.com>
 <CAKwvOdmpSmWGUA-SHJ9PofayfxFc--MJuxgQ0cU8bnDB6c=wag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOdmpSmWGUA-SHJ9PofayfxFc--MJuxgQ0cU8bnDB6c=wag@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 29, 2023 at 09:33:55AM -0700, Nick Desaulniers wrote:
> On Mon, Aug 28, 2023 at 4:41 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Mon, Aug 28, 2023 at 3:25 PM Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> > >
> > > clang-18 has improved its support for detecting operations that will
> > > truncate values at runtime via -wfortify-source resulting in two new
> >
> > ^ -Wfortify-source
> >
> > > warnings (or errors with CONFIG_WERROR=y):
> > >
> > >   drivers/scsi/myrb.c:1906:10: warning: 'snprintf' will always be
> > >   truncated; specified size is 32, but format string expands to at least
> > >   34 [-Wfortify-source]
> > >
> > >   drivers/scsi/myrs.c:1089:10: warning: 'snprintf' will always be
> > >   truncated; specified size is 32, but format string expands to at least
> > >   34 [-Wfortify-source]

These should just use sysfs_emit() instead. Then all the bounds checking
against the PAGE_SIZE buffer gets done correctly, etc.

-- 
Kees Cook
