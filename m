Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3FB4C25B48
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 00:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344759AbjJYA2g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 20:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344753AbjJYA2g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 20:28:36 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E3C10CE
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 17:28:34 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1ca6809fb8aso35966655ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 17:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1698193714; x=1698798514; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f1VOdbNwXAH3NHxdn8pigR7QBmM0uZMTBZfW6F7KshE=;
        b=IZJJbnUsk2yQA2mU78DmBH83qZOWJWvpY0RxMEMSP/3Zh56Bag65bTpA+yVudag0OQ
         lDxJxtX+ixpEUySmJ6PMUeyB7U1pZDgeJEBlsfSmiQ/0xC1idBb/2r9Bckw3vixdisPW
         LjEDTztFrBZ6FjabGApG4DI3++YQG5RTj22/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698193714; x=1698798514;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f1VOdbNwXAH3NHxdn8pigR7QBmM0uZMTBZfW6F7KshE=;
        b=QJ6+xjbF60uo/XpWior3HIGtAHyyUxyGctcE0IUP3hYue7qr54Ixro67IeEKMHkS49
         CQ6I+qcTjOrmes2DfDxZOXEbgOFgLfK9Ne9Lva2RctcYtt5mKZdzqWh5ogNdH0xZqlBf
         eWjm3dC38mhG3svBwU8CN7yduNp1QRj6CHJPvzQFFU+9KJi5iZOFI3DIyUSyoRsrgm/X
         d6FsURrGFAco3cHZO6eFY92v86yJk6PW1ttuzg/SU7GjXs0MS5uI5QRPuzuYTJ0lUfap
         JkykPM+EAhUfaQCvk7/cIJwMOUF9rYNodbN8YbmGCuaqXhezSBQoAWjecpfhY95KVV/j
         p0nw==
X-Gm-Message-State: AOJu0Yx6j2qfBLts3yFif1RhYQ8LejB12WpKn6KZ6R9sdmZWGxkZmTU/
        tlYlCv1YkacQ05Ru84LAA91p4t7KgdlyRQILly0=
X-Google-Smtp-Source: AGHT+IEnXLVJRa3cR/YMGF26nXSPNxl2kYEhL044D3Dodeq+sGspMNV1yT079dieG/mr4U+ldjBmZA==
X-Received: by 2002:a17:903:6d0:b0:1ca:de41:753f with SMTP id kj16-20020a17090306d000b001cade41753fmr6488394plb.15.1698193713899;
        Tue, 24 Oct 2023 17:28:33 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id z20-20020a170902ee1400b001c724732058sm7964995plb.235.2023.10.24.17.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 17:28:33 -0700 (PDT)
Date:   Tue, 24 Oct 2023 17:28:32 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2fc: replace deprecated strncpy with strscpy
Message-ID: <202310241728.6CEDB92754@keescook>
References: <20231023-strncpy-drivers-scsi-bnx2fc-bnx2fc_fcoe-c-v1-1-a3736943cde2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023-strncpy-drivers-scsi-bnx2fc-bnx2fc_fcoe-c-v1-1-a3736943cde2@google.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 23, 2023 at 08:12:22PM +0000, Justin Stitt wrote:
> strncpy() is deprecated for use on NUL-terminated destination strings
> [1] and as such we should prefer more robust and less ambiguous string
> interfaces.
> 
> We expect hba->chip_num to be NUL-terminated based on its usage with
> format strings:
> 
> 	snprintf(fc_host_symbolic_name(lport->host), 256,
> 		 "%s (QLogic %s) v%s over %s",
> 		BNX2FC_NAME, hba->chip_num, BNX2FC_VERSION,
> 		interface->netdev->name);
> 
> Moreover, NUL-padding is not required as hba is zero-allocated from its
> callsite:
> 
> 	hba = kzalloc(sizeof(*hba), GFP_KERNEL);
> 
> Considering the above, a suitable replacement is `strscpy` [2] due to
> the fact that it guarantees NUL-termination on the destination buffer
> without unnecessarily NUL-padding.
> 
> Regarding stats_addr->version, I've opted to also use strscpy() instead
> of strscpy_pad() as I typically see these XYZ_get_strings() pass
> zero-allocated data. I couldn't track all of where
> bnx2fc_ulp_get_stats() is used and if required, we could opt for
> strscpy_pad().
> 
> Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings [1]
> Link: https://manpages.debian.org/testing/linux-manual-4.8/strscpy.9.en.html [2]
> Link: https://github.com/KSPP/linux/issues/90
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Justin Stitt <justinstitt@google.com>

This all looks correct to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
