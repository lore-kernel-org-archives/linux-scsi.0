Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC54DC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Nov 2022 07:09:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbiKSHJb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Nov 2022 02:09:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiKSHJa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Nov 2022 02:09:30 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFFF950DE
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 23:09:29 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b21so6408763plc.9
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 23:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ACiJTbXNJeqE/gxlmjEP49H2c4SghNGRkjD+ba2fsY=;
        b=X+H4O1YxrB7WboZ+TpnIVWrX5yqtIjQX5Bgu41ubRJotRsZa2e7rzFXUbtMnVyP8MK
         a6uxX4rQy+sJFGMuKW5X+d6EP1MKXJC0k3ccQfFy1HnD5zkD0jKI53LZSk4pI/lqE5sZ
         tVwDkAiDVtodv4Riox1/pue3VHY5ZA+WN4N8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ACiJTbXNJeqE/gxlmjEP49H2c4SghNGRkjD+ba2fsY=;
        b=5wMRhx1lQkD01VoJsMyK9+cKY6/i2ZSNbJpG3sLwO5BqcSXggIRMjLEzpNk92z/UCj
         GUO0QNqTU1pIWVs6H3OEzO1LP8UpHfEOeG0TWlCl8FtnSEgS4JYwzDgP2TAO1qpPeHL+
         X6dGCQYeKFcDfnZVALx6wv9tyO0Rio9oL9nDWNuqn50JsenV9FMcsnECX/7NpyJv4+b5
         3U+Fp8sRz/OkSdOvcYx1h/z2/2eEiaaJ1NAYosPXhWXNHWoCbOa+gGx/iJ0zavq0biAn
         XMwK64UmBL8omGllG7q9s5n7ZP9sY9b5TwF7WYpxIHvKPsySmMoYZ/dplWE5FyfKIBpx
         oNhQ==
X-Gm-Message-State: ANoB5plO/uDm44rscNR/1aVLIPyq5drYElDDsVkANNG/qX6+z7n+TsC0
        H9cWSlSkJD27FPQNarJb/RH/ig==
X-Google-Smtp-Source: AA0mqf5zwvmnUs0B49pK5yJ7yPu5BHkdCfLczJZ3lPalcKIdye1gPv2FogDayRYZhRw0bf6P1zAnQQ==
X-Received: by 2002:a17:902:70c9:b0:176:a0cc:5eff with SMTP id l9-20020a17090270c900b00176a0cc5effmr2887849plt.128.1668841768770;
        Fri, 18 Nov 2022 23:09:28 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g9-20020a17090a4b0900b001efa9e83927sm6455386pjh.51.2022.11.18.23.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 23:09:28 -0800 (PST)
Date:   Fri, 18 Nov 2022 23:09:27 -0800
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2][next] scsi: qla2xxx: Replace one-element array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <202211182309.E0127C6A0@keescook>
References: <cover.1668814746.git.gustavoars@kernel.org>
 <faa40e6b31ecc9387ad1644bb1957aa53d7c682f.1668814746.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faa40e6b31ecc9387ad1644bb1957aa53d7c682f.1668814746.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 18, 2022 at 05:47:13PM -0600, Gustavo A. R. Silva wrote:
> One-element arrays as fake flex arrays are deprecated and we are moving
> towards adopting C99 flexible-array members, instead. So, replace
> one-element array declaration in struct ct_sns_gpnft_rsp, which is
> ultimately being used inside a union:
> 
> drivers/scsi/qla2xxx/qla_def.h:
> 3240 struct ct_sns_gpnft_pkt {
> 3241         union {
> 3242                 struct ct_sns_req req;
> 3243                 struct ct_sns_gpnft_rsp rsp;
> 3244         } p;
> 3245 };
> 
> Important to mention is that doing a build before/after this patch results
> in no binary differences.
> 
> This help us make progress towards globally enabling
> -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/245
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
