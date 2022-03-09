Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E41C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 17:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbiCIRTg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 12:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237022AbiCIRTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 12:19:13 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DA8BE1CD
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 09:17:32 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id a5so2906462pfv.2
        for <linux-scsi@vger.kernel.org>; Wed, 09 Mar 2022 09:17:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WeI6/9C1BCTGBKT+PvqLfTEaKntfc/ed6405/bCzY/w=;
        b=WDfWjEYckw/zTayapSSYfsRn64vQBqxp7Z9KMMkfujfBKUpKOHI8XIHGLayFZN4H2b
         u0u1AgWKPSDhByMnD5ntwL4Zs0Q77Drden/IjHQYanPve8puiSrPE2dDhQNRe3eWpmpZ
         tRmPU7DNz9Taggr1RjPonwqTWgEnaruaVIYSE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WeI6/9C1BCTGBKT+PvqLfTEaKntfc/ed6405/bCzY/w=;
        b=nz66zX2OWPTX48ubv7FdW7bM/sgurlDTjwsPSAAi4eTlCKPAvm23KoObe3lL3PAIql
         1Ehc483ap4M7EMaasU4coOL3f9X65SKU7VDezpliN4PPSozU0H/AzqTeWOGZu37qTQti
         nbryGsrP59M794vH+5MxgasxJZ7BhHO3v2Ap75bmUmmXePBCgeUlg9I3l195dZyBBGbv
         tuXw4ecMW6f8c7AJZSV/SYs2aRqLQfI4M2wC7sc0mV0pRnwvPxxOV1KviKJAc4FlFcFj
         hofWGdRnXXUMOFU0Cqhj9htciSS3rpbvOPKBFDXoZrBRONVy1SO6wUZVpNcQGeKJDCQn
         2A7w==
X-Gm-Message-State: AOAM5317+qkXU5IK/P6o55uoV9ss22TCdToJyqsUt5zsEgdvh0Au0chw
        7OIwokdv6VlFWjpDcb+341Of2w==
X-Google-Smtp-Source: ABdhPJyXk5M0FslPX7mQv4MfQEiZWkG1072olU1PS3FqjAEjICXjju+odpKPfrx+08nAfrdTgndITQ==
X-Received: by 2002:a63:1554:0:b0:363:794c:9e31 with SMTP id 20-20020a631554000000b00363794c9e31mr628489pgv.66.1646846252021;
        Wed, 09 Mar 2022 09:17:32 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t6-20020a63b246000000b0038085c0a9d7sm2818271pgo.49.2022.03.09.09.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 09:17:31 -0800 (PST)
Date:   Wed, 9 Mar 2022 09:17:30 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-hardening@vger.kernel.org,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Subject: Re: [PATCH] scsi: mpt3sas: Convert to flexible arrays
Message-ID: <202203090913.ED0241BEC@keescook>
References: <20220201223948.1455637-1-keescook@chromium.org>
 <164462189850.7606.6908949862618145181.b4-ty@oracle.com>
 <CAK=zhgpQcJkRKVNFHy6mDqV9hOyzFsV_uqOWur8UsNLRZy-VdA@mail.gmail.com>
 <yq1ee3blsqp.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1ee3blsqp.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 08, 2022 at 10:20:28PM -0500, Martin K. Petersen wrote:
> 
> Sreekanth,
> 
> > I am observing below kernel panic when I load the driver with this
> > patch changes. After reverting this patch changes then the driver is
> > getting loaded successfully.
> 
> I am puzzled. The driver loads fine for me. I have verified that the
> generated object file is identical before and after Kees' patch.

I've double-checked this again myself; I don't see any binary
difference. Can you share your .config? I was using defconfig with
these added:

SCSI_LOWLEVEL=y
SCSI_MPT3SAS=y

-- 
Kees Cook
