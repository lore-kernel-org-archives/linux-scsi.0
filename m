Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00241C07E9D
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 06:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbiIXGG2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Sep 2022 02:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233150AbiIXGGX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Sep 2022 02:06:23 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD5B13B02B
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 23:06:21 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so7748002pjk.4
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 23:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=AWMu/McMAHOInUGLKjW0IWLj+xXBo94zkzcoUaCWYEo=;
        b=T2J7+KLc0zkKZJu6SL+njcGC21cUjTVY9l5pGzwaqBnNZ4CYr2MlWY1nKxJXONgXcT
         45WdyRdan+VWD41IyM6Dzdha1p80JP3H8YkwCDkXxRlCCZ0Z/C4e9iq9GyxxiUeljGu4
         BQz4dNiUYUKZ5QME1dIqO7S6x18NZRrUfsZyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=AWMu/McMAHOInUGLKjW0IWLj+xXBo94zkzcoUaCWYEo=;
        b=BBsED/ayo6nmA1OgLhGAwzEnvj9L0pQ0C6zeHz0P8qbulsn6/f07kCMagXyhORBJuN
         5QKGFTklgjF3OCQH1TQ8xbmX/JgENJ7cJuEccGFZcWBAgw+DbG4o2Cw9eVLSHy6s+c8r
         ukJ1PExIimVqa6fv+s1Oi7VOs/u6gY3fZ4G7rjpRXkhIfrso7cIS5qjhbNAzW8EC+L0O
         +tt6dKrKXlaQTgcED78IYaCcc3WTa22nPu4255Rz4WYyYePASIZhCW9c8/16/5Cof6xk
         ia75U8BDjy4trz0pCOukueS9CFqvLOGSUgvVFQ7MkedPUEUgy+ZtZR8z4dAb0xwGd79Z
         oayg==
X-Gm-Message-State: ACrzQf1p8kGzdGCR2yK5ZDbJrT2dYKkgGv+vFwqZf8V8979tqWL9jzk0
        P30QscchnWHHwY91ZiY/to6n9m9qrDyh1A==
X-Google-Smtp-Source: AMsMyM4StouRatp1QX9v6675j36Y+QCSYAjjgPuayYL8XnlJhFb4lPSj6MMHONev0v15ZRZENXFZDA==
X-Received: by 2002:a17:90b:1bc7:b0:202:52ce:a1d with SMTP id oa7-20020a17090b1bc700b0020252ce0a1dmr13750710pjb.110.1663999581220;
        Fri, 23 Sep 2022 23:06:21 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u13-20020a170902714d00b00178aaf6247bsm7045441plm.21.2022.09.23.23.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 23:06:20 -0700 (PDT)
Date:   Fri, 23 Sep 2022 23:06:19 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/2][next] scsi: hptiop: Use struct_size() helper in code
 related to struct hpt_iop_request_scsi_command
Message-ID: <202209232305.60356F5EDF@keescook>
References: <cover.1663865333.git.gustavoars@kernel.org>
 <54e2bb1e39b21394c5a90cacbadfb6136b012788.1663865333.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54e2bb1e39b21394c5a90cacbadfb6136b012788.1663865333.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 22, 2022 at 11:55:33AM -0500, Gustavo A. R. Silva wrote:
> Prefer struct_size() over open-coded versions of idiom:
> 
> sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count
> 
> where count is the max number of items the flexible array is supposed to
> contain.
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Looks correct; thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
