Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14099EB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 20:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjF1UKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 16:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjF1UK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 16:10:27 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E0B1FF7
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:10:25 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-66869feb7d1so117987b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687983025; x=1690575025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P1LPKrRFxE7z5JbsWiXfc4MacbMwcaBP5SMmmJSg5X0=;
        b=ZU3GIiembL+qyfBPhg67vh1VPEfgsm2sf0Vwcw6HRFQNJgaVTvdkpkktE/zK0VPcp4
         IZ5FmVj/fjCSttx5u2xwbJe183QdD/j+WgWm6cBdPsCELoLiqyh/PLCkRyjNR4TJ5HIi
         9X/jgh4DeqGFE8/ajeQfuh0wGJgOSE0yizNyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687983025; x=1690575025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1LPKrRFxE7z5JbsWiXfc4MacbMwcaBP5SMmmJSg5X0=;
        b=CpUq0FEO2UfD1+zy05uYEORt6EDEvoiCdWp1pcyia15ZaCeAotUn4gHLvgoL7wJRUo
         m0uuA1GXG00s5/DX0FQeBhd/PXa829+A5apO2vpyZl8RvOj1q30xz8Lhm0FfMy0TBLmg
         4jUgX8zqFu28WlxTlnSiS32/TufDC8Yv8dm74pkPEJb5xik+rEsmXPKdzlb3ntqnPJpi
         E4IvjYei57JJv9v4YXb7CUto7ybAgcVibAXg3/Nrq0I9y733/bPAKByi5R5enG/V1SsL
         PLBCzI3JVr0eicxhgtVxIYRhulgBkWtmMVCm/1YHDtNbffYU42/2N/sIOjUAgeXTdHnu
         4sRw==
X-Gm-Message-State: AC+VfDxcVOqTqWe5MsajmRFLJBqeVAR30hvNylbZp9Wt55sTXfIo8NFq
        8e8logHDThmpXlDPkReeQ32CsrlW56cdr/NKBH0=
X-Google-Smtp-Source: ACHHUZ4WKbNj/e4fSFBNa7A4PfXgK9d496EWwQvNqQn0V6qk9DE1wLP5eFn/lHS8TLGVhPQjuqo7wg==
X-Received: by 2002:a17:903:2656:b0:1b3:f8db:6f0e with SMTP id je22-20020a170903265600b001b3f8db6f0emr10107522plb.43.1687983025193;
        Wed, 28 Jun 2023 13:10:25 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id j7-20020a17090276c700b001ac444fd07fsm8011776plt.100.2023.06.28.13.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 13:10:24 -0700 (PDT)
Date:   Wed, 28 Jun 2023 13:10:24 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 03/10][next] scsi: aacraid: Replace one-element array
 with flexible-array member in struct aac_aifcmd
Message-ID: <202306281310.850C08F8@keescook>
References: <cover.1687974498.git.gustavoars@kernel.org>
 <65907ee4083de62fbaadc5c2e6512e3828912d1b.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65907ee4083de62fbaadc5c2e6512e3828912d1b.1687974498.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 28, 2023 at 11:55:24AM -0600, Gustavo A. R. Silva wrote:
> Replace one-element array with flexible-array member in struct
> aac_aifcmd.
> 
> This results in no differences in binary output.

Confirmed.

> 
> Issue found with the help of Coccinelle and audited and fixed,
> manually.
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/ClangBuiltLinux/linux/issues/1851
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
