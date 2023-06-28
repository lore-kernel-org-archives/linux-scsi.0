Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6970AEB64D7
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Jun 2023 20:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjF1UvR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 16:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjF1UvQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 16:51:16 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9BE130
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:51:14 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1b078b34df5so151089fac.2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 13:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687985473; x=1690577473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hToyBpF286Hw/boztsHPGGVcJfrub4UlNJjY6++yzrQ=;
        b=PlhS6mZUDCXu/H5P96F7OAgMX8ScSlMC1/t4KPNfwE+io6blSxqzJeLUACudjJYv9I
         lxXDKVMaMR1yUIfyBwVbNKLwConVSG9Xq2gJiukgntJhnu9DddVY3QuqxUO2uUNAEA9l
         bt+5N2/qHPYcFF7Ls3181LHQG5jAqXjX7n7Nw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687985473; x=1690577473;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hToyBpF286Hw/boztsHPGGVcJfrub4UlNJjY6++yzrQ=;
        b=gwDrdhmcx1jqDxnab5bcu8nGpc9LiEtWMDkv7xH2o+/oJfu5O4qdwWj1oAeXSS6zS7
         VLQmu8qsR0jwNOHvtZ0BE/U2+rNW/9icGLTQCU7ryPF/tMYtCIikE7HXZMaIRASLFXX2
         oPQO0jkQp781kmj4uDxRcDrXbJ3QlujgC38zWfwYe5yarhxsl827ty6LjPeOnHp0yyx6
         793t5haEJjhyyDU4LdKwS6wNKm7AwmRGs8Oq9iCf74wFLFB9HwilH31kQp+jq3GliQVH
         g7Jo4+7eJoKPy2c11iwaZ8GB73+cfg3xDihFRIukZr022C7SyJVhJ1Lh2xXMxuwwW77n
         TIbQ==
X-Gm-Message-State: AC+VfDyzR9blj0MWPrLBdHoeMALMmCLZJd/vsXdXGGpyl5L7X7lcOMVc
        FCp1dXAblC6g5y6i27atfNxeIA==
X-Google-Smtp-Source: ACHHUZ5nxR8s1z286EFR3jK8wMq1RzdKDcYrke+gXGBTPWlH/qBXPY6I5dfuU5bCNP15XZNh06y8QA==
X-Received: by 2002:a05:6870:770c:b0:1b0:1b2b:7e0b with SMTP id dw12-20020a056870770c00b001b01b2b7e0bmr12966828oab.30.1687985473125;
        Wed, 28 Jun 2023 13:51:13 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id n20-20020a17090ade9400b0025bc49aa716sm8194783pjv.27.2023.06.28.13.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jun 2023 13:51:12 -0700 (PDT)
Date:   Wed, 28 Jun 2023 13:51:12 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     aacraid@microsemi.com, "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 02/10][next] scsi: aacraid: Use struct_size() helper in
 aac_get_safw_ciss_luns()
Message-ID: <202306281351.91DB52F4C@keescook>
References: <cover.1687974498.git.gustavoars@kernel.org>
 <cd80ea8f2446fe62ec15ffb0bbcecb69e0c342af.1687974498.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd80ea8f2446fe62ec15ffb0bbcecb69e0c342af.1687974498.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 28, 2023 at 11:54:58AM -0600, Gustavo A. R. Silva wrote:
> Prefer struct_size() over open-coded versions.
> 
> This results in no differences in binary output.
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
