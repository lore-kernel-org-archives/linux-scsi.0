Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C950C7619A
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Mar 2023 18:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjCTSll (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 14:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjCTSlT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 14:41:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7988F3C797
        for <linux-scsi@vger.kernel.org>; Mon, 20 Mar 2023 11:33:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so13399506pjt.5
        for <linux-scsi@vger.kernel.org>; Mon, 20 Mar 2023 11:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679337196;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K4mu+bNehauaTgSBwCnPiSfzrVvCzsepaH3d15QbbN4=;
        b=ClQrVslAhJvgqbe8M3xHOKxNgniQIh/uBsT0fWFpMbXdu6MFA1Jpv9xYHkM3UDdd9u
         Q1KcpFDNhByvRzXb6AIGsWNhSajaD0ZFJIvDdVjfFDmky2eS8jQfTixhQBQg+aZpR/E6
         veAKsW9HkLBeX9ZAaVtQ1F3vihHnlFAw3UXa4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679337196;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K4mu+bNehauaTgSBwCnPiSfzrVvCzsepaH3d15QbbN4=;
        b=zFuf0j9SUv2S9YLbWDpvvv96R+oZiFV4arSHA7cUcXUh4ESRal9cyvq1eRU/kFDLSY
         q5Ngf4ZbvlkhpdiLMopY9CpW5iiLRv5JoSSkQFEd+cKVn51J5cwW2iz6Mr7fxCLBY9Ha
         rQCnqnyvY5TCHwJzlr7ufc7raAEeCcu357e59QdEPnCU+59KqCOfqq9n9s5A/Q14wmL2
         OjHm3410xSE1UI668liVJXcuToKxm4mJmEmeP6vVxjyY9FX+zrrrO+32nsXbsHBb7kz+
         FN3TaJDQwqou1QvZsuXyd43m86zbFLRjEZN79TFFoRgQICWa2E4XqdPb5zc0FxFC3NKp
         sgSw==
X-Gm-Message-State: AO0yUKWLsmIJxeloHtD47Yb9x7xoWLBH4So0sjjuQUuHWawS+hXfmJjQ
        LKWQs1sREqZg7MfuJ7uLjj5Ycg==
X-Google-Smtp-Source: AK7set/pnmLIeD8BRH/9kRDtin7NNNPBnPbucuL8sJUzMrogrV26aMT63BiNpaTx4nZIFu8i2QAeRw==
X-Received: by 2002:a05:6a20:4c84:b0:cd:ed5c:513 with SMTP id fq4-20020a056a204c8400b000cded5c0513mr303189pzb.31.1679337196653;
        Mon, 20 Mar 2023 11:33:16 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id k2-20020aa792c2000000b006089fb79f1asm6608990pfa.208.2023.03.20.11.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 11:33:16 -0700 (PDT)
Message-ID: <6418a6ec.a70a0220.1f3d7.afc4@mx.google.com>
X-Google-Original-Message-ID: <202303201133.@keescook>
Date:   Mon, 20 Mar 2023 11:33:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] uapi: target: Replace fake flex-array with
 flexible-array member
References: <ZBSchMvTdl7VObKI@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBSchMvTdl7VObKI@work>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 17, 2023 at 10:59:48AM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address the following warning found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
>   CC      drivers/target/target_core_user.o
> drivers/target/target_core_user.c: In function ‘queue_cmd_ring’:
> drivers/target/target_core_user.c:1096:15: warning: array subscript 0 is outside array bounds of ‘struct iovec[0]’ [-Warray-bounds=]
>  1096 |         iov = &entry->req.iov[0];
>       |               ^~~~~~~~~~~~~~~~~~
> In file included from drivers/target/target_core_user.c:31:
> ./include/uapi/linux/target_core_user.h:122:38: note: while referencing ‘iov’
>   122 |                         struct iovec iov[0];
>       |                                      ^~~
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/270
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
