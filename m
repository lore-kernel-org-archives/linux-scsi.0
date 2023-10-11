Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00C3CD98D9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Oct 2023 00:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344450AbjJKAtq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Oct 2023 20:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344367AbjJKAtp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2023 20:49:45 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA95492
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2023 17:49:44 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-690f7bf73ddso4428800b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2023 17:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696985384; x=1697590184; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KRRRoTo2wnsSX5xq5u8T59QWy7S3kko/dv8df4DFlb0=;
        b=T9TC41alCgWEAl+Sv9w6QlzSI2YKErlX9EH5dDQypuuk5xJNA1iee+6SiQ5zXNY5rI
         10t4K1Je26ycLIRMVPvDDnw8seA16x7xZ6p7dSeZxPQWzKnT9WzSMwsNQgtJbciQKwSP
         JwqEnwFFU48eb4siOPmSLUYu7Ch63ToZGC238=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696985384; x=1697590184;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KRRRoTo2wnsSX5xq5u8T59QWy7S3kko/dv8df4DFlb0=;
        b=Ot2vQm/faXG+GfySLdDFWWeJJctVZTBPfzSAU9Z52f5CP3pf+uV4HXn1UL+uHaScc3
         WpldV41YxY8eib40T6WlARamHSCc34JU84sq1jLtyCZxikY9lsk/cUdrTSE25yE43QTr
         EFaNTqP48xRPi1BY023YXMisy0uENym/XLV/lDsrluMEK0epgfBHtC/To8kHzQP+fQNU
         J2/GK/YxA5CSXUJa4/kK1v0GxFPZtw1yJEievqFyrEl87rXByyHvehdKONsTa0raEvPw
         Af3XThc1Yb/1IqjfrhTfkGIIykvWlVeVBR5EnKWkUgu/iaWsHOJ19D9Hxb/Pm2Fjhx36
         ptrw==
X-Gm-Message-State: AOJu0YzwwHwvpSMrBaqqfeoA9u/IwPdBGJR5OYQ7lR48ZT6hxi7cntsq
        ZNHR8aVYhTCoFy02VoE7vuw8cA==
X-Google-Smtp-Source: AGHT+IH2fFpFd4eP3vIi8kSEraLfKgo8XfCxhm6jKaFV+PkGlZw8qgOPt1QHhoorPyZIqBO+YaMYUg==
X-Received: by 2002:a05:6a00:2da5:b0:68e:2d2d:56c1 with SMTP id fb37-20020a056a002da500b0068e2d2d56c1mr19330340pfb.9.1696985384264;
        Tue, 10 Oct 2023 17:49:44 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id z24-20020a637e18000000b0057411f9a516sm10914474pgc.7.2023.10.10.17.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 17:49:43 -0700 (PDT)
Date:   Tue, 10 Oct 2023 17:49:38 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Seo <james@equiv.tech>,
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
Message-ID: <202310101748.5E39C3A@keescook>
References: <20230806170604.16143-1-james@equiv.tech>
 <yq1edjr25ed.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1edjr25ed.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 24, 2023 at 11:00:57PM -0400, Martin K. Petersen wrote:
> 
> > Commit df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3") has
> > resulted in the only arrays that UBSAN_BOUNDS considers unbounded
> > being trailing arrays declared with [] as the last member of a struct.
> > Unbounded trailing arrays declared with [1] are common in mpt3sas,
> > which is causing spurious warnings to appear in some situations, e.g.
> > when more than one physical disk is connected:
> 
> Broadcom: Please review/test. Thanks!

Another thread ping. Is anyone at broadcom around? I'd really like to
see this series (or some form of it) land to avoid all these runtime
warnings...

-- 
Kees Cook
