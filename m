Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E178C25B6B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 22:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjJYWdr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 18:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjJYWdq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 18:33:46 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E2F90
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 15:33:44 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-578b4997decso247363a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 15:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1698273224; x=1698878024; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=opwJbFfeZezmZEuzzSOhTaSQsmNEsDE8+V++KHmxwZU=;
        b=Zw3Pa2e/3+U+nznqtw6EsgqekwKOZLCpgWcrIdIfIW361ngegMlGJERzrO5alHI5dI
         jLq4udAqM9dnFbutIBzFOjmZJnW4iCVSWbf5WZYCZ322B+1l6Nte6LyYoIHENGf+yid3
         Kpat33kudd0NZpR0Iu0Du8TRvk8zZ/F1JMFXA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698273224; x=1698878024;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opwJbFfeZezmZEuzzSOhTaSQsmNEsDE8+V++KHmxwZU=;
        b=XQZ2Ts3MIX2lJhIS3CBW7hZy//rMX6Hg9vQWNu+CCjIYvIhq0O8Dznx87sMs0aCmuV
         KoIW8oToCnXGodH6Pm3WyVc91B6VKPDOvR5Wi31SbFysV2FCTaJbbRGfl9iyaBc5W6gZ
         x8LPSTaDjoZdxB++dnpurkQ1MrClfgoau7trRIoeI7apxq3nHdw+wYH+1Nhq5imt/yjv
         KRkPdXX+Z420aIAc2hDy8Yg06Ew1J/p3rnyhxHjVQeuezwplDT2HNydbyMXEbW2fjW2k
         +NakSs7WEHM6uFea2vMCtatHZdbuzPK0Qt50rPve50T/M9Ye9a1tR3N3lGie9bKBJsqh
         Yrqg==
X-Gm-Message-State: AOJu0YyU0X1sFvzMnhJxALZWRlR54h9ql3k8pfXBV45SUxOZh/fh6/kr
        3QdFVDCrcd452C1B29hpTi9rSQ==
X-Google-Smtp-Source: AGHT+IGxTFCX8xvKt6P4f2+i6TbGxj5yvVEoDiE/MOxfbaqndU4RC184AnRD+2msme7KJciUUZryGw==
X-Received: by 2002:a17:90a:1996:b0:27d:2054:9641 with SMTP id 22-20020a17090a199600b0027d20549641mr16534515pji.36.1698273223913;
        Wed, 25 Oct 2023 15:33:43 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id n17-20020a17090aab9100b0027fccaa6a29sm372876pjq.15.2023.10.25.15.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 15:33:43 -0700 (PDT)
Date:   Wed, 25 Oct 2023 15:33:43 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        James Seo <james@equiv.tech>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] scsi: mpt3sas: Use flexible arrays and do a few
 cleanups
Message-ID: <202310251533.1A27F79450@keescook>
References: <20230806170604.16143-1-james@equiv.tech>
 <202310230929.494FD6E14E@keescook>
 <yq1il6vfoiu.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1il6vfoiu.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 24, 2023 at 10:05:33PM -0400, Martin K. Petersen wrote:
> 
> Kees,
> 
> > Here's a tested-by: from Boris:
> >
> > https://lore.kernel.org/all/20231023135615.GBZTZ7fwRh48euq3ew@fat_crate.local
> 
> I'm a bit concerned bringing this in just before the merge window.
> Please ping me if I forget to merge once -rc1 is out.

Sounds good; thanks!

-- 
Kees Cook
