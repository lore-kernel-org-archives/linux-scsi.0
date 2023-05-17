Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E8BAC77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 19:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjEQTOD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 15:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjEQTOC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 15:14:02 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C674EED
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 12:13:50 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1a516fb6523so11954445ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 12:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684350830; x=1686942830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s3LyAD6kF+WYm6aM+dOL9pdJx+PYnMvlk4fW1DFmn8o=;
        b=aUN6Cw/VFUP8+Ce3d4zl8ZPmQT7+wxj4JmACdz58rbbxwEk3ZVr4Z1/5zHdUBrqcwi
         ee5OXXjwCTv6JjzwnROTkQ0h9MPxgv2Ietsiqce1dVljKQpSb/WAikrFdpXm9om+2lo7
         O0HUc6JtU7Drp1ypY6o2YWppaBJGMTkC4Xe+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684350830; x=1686942830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s3LyAD6kF+WYm6aM+dOL9pdJx+PYnMvlk4fW1DFmn8o=;
        b=OejFxfx+5kS/T8o1aYxLTyc7mXtmYeRc4juIskiRud0okl8d+OkM8a0T9eCnXRshY6
         /LdTLIk46c9ofPJM5lCNWiXI34tc1a24Laqg0a5rVHVHLcDTlqqSMkfzr+jNBY4gwGIR
         fpg9VOwUrz1B8dq6dsdJR8aba8SpdAcRZlxszvo37XG3pIUagEduCLFg7OnPVkzid14P
         jmI8Q87MV5w+BSSY4DS9/biy4AkjcOvGL8KmRdES1VooEiyy9KQzz6ZBq9CAB8Ocztsz
         BTeY5tOQVxB57I+y48ijbBHTT8rLseqiquAK2DVaOozDcHFL6W9dAhPcnlOxzq0FIQIC
         SNhw==
X-Gm-Message-State: AC+VfDwHl1uGMazIP+gCDETbleZ+IVaIJEQ6IHQXRRVmbrhAq7Y/JiA7
        /S5hGkA/i04aZxwTjPS0cdxx0A==
X-Google-Smtp-Source: ACHHUZ6dcH8haH9mHEP9elVIRuuwE25P3Is4Xzixr93z0vZSba8vGzbWx2zxi6KVOnS6/pPFpPBo2w==
X-Received: by 2002:a17:902:8344:b0:1ae:3991:e4f9 with SMTP id z4-20020a170902834400b001ae3991e4f9mr5665517pln.61.1684350830446;
        Wed, 17 May 2023 12:13:50 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id jf15-20020a170903268f00b001ab2592ed33sm2121288plb.171.2023.05.17.12.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:13:49 -0700 (PDT)
Date:   Wed, 17 May 2023 12:13:49 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bnx2i: Replace all non-returning strlcpy with
 strscpy
Message-ID: <202305171213.DD6DF93F39@keescook>
References: <20230517143130.1519941-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517143130.1519941-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 17, 2023 at 02:31:30PM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> No return values were used, so direct replacement is safe.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
