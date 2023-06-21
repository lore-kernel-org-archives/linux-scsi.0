Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A523DEB64D8
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jun 2023 18:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjFUSKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jun 2023 14:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjFUSJk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jun 2023 14:09:40 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C07B19A6
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 11:09:38 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-54fba092ef5so4914356a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jun 2023 11:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687370978; x=1689962978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NtCU2aNHiXALlbRX9I4DukzgSyp1YjBiNC4CphoFrEw=;
        b=EqOdfYunj6JALtj6gBMDXY1XZ1NuBHwdT6XXru7HPOH40ch1whOqrIXaaidsAZDU3c
         Fyo49GFMqwN5ola8kxFJPPzHnSTASl4xCJIP6q5pNko7QF/Nq7b3hAnUWDPFGJS2E85F
         NsvAwizAbJH+Sdjb0+9M5uQSkL7rxy7YsCFNE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687370978; x=1689962978;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NtCU2aNHiXALlbRX9I4DukzgSyp1YjBiNC4CphoFrEw=;
        b=h5LVnijf3ywI0/b51JfyF+KG/NHyeuBS/GdR2fyDzjG2jZKXQ7j41efZKtUjcDHUN0
         O5vtFu4eX4LxHvUw33aBrHgYKm+Io3TvhPiYdHDkKiJfBKJpdZdnx2TDvkAod0HCSdAh
         J5RWFyzm6KaxKAmBw7aCHglWHAcinoAeRjHXvFv8YL4aV4Kxfano/Lp6KNvGxlhTbsB/
         i2AQrSO0E2b5g+0euKnAA2QzupFpDCu7+zFuX1Ip3Pn7sMwFNS6U4E7xnGD+LjvGjb2b
         Rzt3YGoPq5HI510rYIi2qteM6SUEfxncT0Jx8mYjqgB9d9IqHtsMttg/gzWZeXX807bk
         7EOA==
X-Gm-Message-State: AC+VfDwCeIE3A8hEuzX6FabjDqkDkWT78+3LCKorvRDCBxIEw/mEhBIz
        PdYPI9BUpXcN2Icbhn6G+rBPPmgijb53t1NU034=
X-Google-Smtp-Source: ACHHUZ4FWbV1RyWBA8tediI/mnxk6UaQLmEhERVpP43CeGJ2wgt9fIxD9VuISBehmuwGWMB9HhtIlQ==
X-Received: by 2002:a17:90b:38c8:b0:260:fd64:a20 with SMTP id nn8-20020a17090b38c800b00260fd640a20mr2364445pjb.9.1687370977767;
        Wed, 21 Jun 2023 11:09:37 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x18-20020a17090abc9200b002533ce5b261sm9274479pjr.10.2023.06.21.11.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 11:09:37 -0700 (PDT)
Date:   Wed, 21 Jun 2023 11:09:36 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bodo Stroesser <bostroesser@gmail.com>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] scsi: target: tcmu: Replace strlcpy with strscpy
Message-ID: <202306211109.72E5989586@keescook>
References: <20230621030033.3800351-1-azeemshaikh38@gmail.com>
 <20230621030033.3800351-3-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621030033.3800351-3-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 21, 2023 at 03:00:33AM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> No return values were used, so direct replacement is safe.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
