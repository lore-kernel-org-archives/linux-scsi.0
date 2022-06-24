Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BCACCA473
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jun 2022 20:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiFXUNP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jun 2022 16:13:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbiFXUNO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jun 2022 16:13:14 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279D231535
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2022 13:13:12 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d17so3436365pfq.9
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2022 13:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JO7J5gYwMc2oJpLpkWigLEC53bU/Q4t+rjJSx2/0CdY=;
        b=eGNfcAvYM1eEBkUwfnn/Tbo9MYHzrrNAEqTo3aweTmsmcvdHJIQolhJdks3ZI06Hnz
         ToODfaBXKu5XQl3iJjSxgXgx6b2mCmS/au7xy6QtVRe0KR4YlQCAc0i1LzEkzN2B9d7a
         f9wuhNf0912A84p4kuE5f2tjgeK9s/ObIhPYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JO7J5gYwMc2oJpLpkWigLEC53bU/Q4t+rjJSx2/0CdY=;
        b=SITUjvwaz/xCHPdWBz9Q8tVjveOSAXZ4wTYAsL2QmcJP4emUMzraF0rZe/LwJavOay
         6SgrPWy9cdnVZvg6cq60wMFH8Ml48KKy+nh06RC/4zVBjrW7BtwuVW+rEjPGKs7dkf5r
         4iVh3B+zrdgY7oETD1mJjOhQzDeikPmjkh58sUyGbX4riQwShaaHJshH7NnAg9Y42gHq
         SiUtFYUkLTbDNGCwhUiM2rmzLcOnHeuvm25Gpf8gJ9rebc9LANoPk8uuiL3Txr15qN4/
         6mTGmvSguGSGre8wIuQMGqS9mHe0zJXzXcwTaarVWJ/q6qYdjnA8v8wYJc6sB5+auRit
         UTpQ==
X-Gm-Message-State: AJIora8N0PGHET6m1HqXz0BD35WmsJxx2f76M5dJl4VfLWrqCdqsVJAP
        5WLxIzuOk3MQdYS0IU43WuWcQw==
X-Google-Smtp-Source: AGRyM1skZyJeAmzbptZd5plp8ZRer/MKu/mlvmAuyKbVM9kantiVUC5Iiok1Xs7xFNvbtfSGSAKjZw==
X-Received: by 2002:a63:8c1b:0:b0:40c:7af0:cdaa with SMTP id m27-20020a638c1b000000b0040c7af0cdaamr513452pgd.326.1656101591612;
        Fri, 24 Jun 2022 13:13:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902e14a00b0016196bd15f4sm2228549pla.15.2022.06.24.13.13.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 13:13:11 -0700 (PDT)
Date:   Fri, 24 Jun 2022 13:13:10 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 3/4][next] scsi: megaraid_sas: Replace one-element
 array with flexible-array member in MR_DRV_RAID_MAP
Message-ID: <202206241312.EC413977@keescook>
References: <cover.1628136510.git.gustavoars@kernel.org>
 <b43d4083d9788bb746dc0b2205d6a67ebb609b0d.1628136510.git.gustavoars@kernel.org>
 <202206221457.1A12D768EF@keescook>
 <20220623014533.GA7132@embeddedor>
 <20220623031401.GA8896@embeddedor>
 <202206230816.1383511C@keescook>
 <20220623153825.GA6458@embeddedor>
 <202206241047.903049ED@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202206241047.903049ED@keescook>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 24, 2022 at 10:48:39AM -0700, Kees Cook wrote:
> On Thu, Jun 23, 2022 at 05:38:25PM +0200, Gustavo A. R. Silva wrote:
> > Which object files are you comparing here? because I don't see the zero
> > change when comparing the before and after of megaraid_sas_fp.o with
> > the change you propose.
> 
> Hm, maybe I did something wrong. But I was looking at megaraid_sas_fp.o

Explaining my process got a bit long, so I wrote a blog post on it.
Here's how I did my examination of the resulting output:

https://outflux.net/blog/archives/2022/06/24/finding-binary-differences/

-- 
Kees Cook
