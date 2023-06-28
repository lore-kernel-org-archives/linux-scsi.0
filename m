Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECB9EB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 20:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232077AbjF1UKz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 16:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232197AbjF1UKl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 16:10:41 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD31E2129
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:10:40 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-676f16e0bc4so140912b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687983040; x=1690575040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oSapW0FmCiFhc0XnA8Ry6zuPPnmsaSmu/yInPi5x4CI=;
        b=ghbynXK89qCF+G+B+jPDLyXDKK+ufG/em66+TPqJAG8Y+r0e0gX/WaalZXazXK/5lo
         gVzM0KQhZaGAuuRtF+qBoUmkTZX/7vIviJOp4np2J2qXoySfnZMQDaxV6rxAs/QT+mIv
         ibFAG65bYGMNwQPgdrEftVIz/l2XzU1gE1jco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687983040; x=1690575040;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSapW0FmCiFhc0XnA8Ry6zuPPnmsaSmu/yInPi5x4CI=;
        b=ZyP3ZhUMoVgJwazxfJ+0pKqdr/h+8lraG6UnA85RkoeRcvjZWO40FbrRjelgb7qu3J
         vR9oB8tS55gxWT021EyV7kXswFwQmjD02CoglVjfS5z2Q/AwftQCcKBBLVRHIvvVCh1v
         XZ0E2jQrMn1DgikA2QA249g++k+WzgsMUkdpWfCdnTArE1Re3Oqg6Vq8MbqLCmaaNfpC
         JHOwnCcFf2gt72RuCW4uwMsdgYGSNNTTev8rq4TtDbFMR0XB+Hm8CsbjRdjPpJ2JNGeY
         hQca4zFaclmZpgDhl2WU/dYCZCHTAJ5guLJJY7rtDl5x+zNsDKXp+ZpeHTxpw2PNQX0F
         7WOw==
X-Gm-Message-State: AC+VfDytakHuB8swar/jH6jTglt29qHxru8jk3FbFmAPMKhBw8iumBkU
        us/4FPmoMdpc3nztk1+LtiUQhw==
X-Google-Smtp-Source: ACHHUZ7fnyiiEJe1+e/jMPIJD24SQjyElEYOOpmIF1pRe0YUjvwzuY1nglQC2DszuIErUH2mxMqtjA==
X-Received: by 2002:aa7:88c2:0:b0:682:3126:961a with SMTP id k2-20020aa788c2000000b006823126961amr503644pff.5.1687983040309;
        Wed, 28 Jun 2023 13:10:40 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id h21-20020aa786d5000000b00678cb336f3csm5048691pfo.142.2023.06.28.13.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 13:10:39 -0700 (PDT)
Date:   Wed, 28 Jun 2023 13:10:39 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 04/10][next] scsi: aacraid: Replace one-element array
 with flexible-array member in struct user_sgmapraw
Message-ID: <202306281310.7E77AE98@keescook>
References: <cover.1687974498.git.gustavoars@kernel.org>
 <4c2277b8aa3de8600c807ff8c995635f414161f9.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c2277b8aa3de8600c807ff8c995635f414161f9.1687974498.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 28, 2023 at 11:55:47AM -0600, Gustavo A. R. Silva wrote:
> Replace one-element array with flexible-array member in struct
> user_sgmapraw.
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
