Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134B7C4743D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 18:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E61C4613F1
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 18:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhFDSYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 14:24:20 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:33737 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFDSYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 14:24:20 -0400
Received: by mail-pl1-f174.google.com with SMTP id c13so5114981plz.0
        for <linux-scsi@vger.kernel.org>; Fri, 04 Jun 2021 11:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J4cr3GvXSuG4D3gzKE/kKLrguvdOyGMMtXTZNVjyaB8=;
        b=NkPmSJ17gUmq9yi5wiRooIBIzKdAZstsqbh8VlI/FD1HCoPstrCFA6+fL+Hj6ejXdh
         6bk3sGxJH6mEAk5JY9PmL8U96bJ9kF4eBnTY1NxQDR94dfrxRGHeHeSBaLS1qQdc0ZCQ
         LdUlijfmP2qf+mXtR1DEWDqlQyiZ2ibBzqdbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J4cr3GvXSuG4D3gzKE/kKLrguvdOyGMMtXTZNVjyaB8=;
        b=tO+W/CK4Q7EmUyaNwoQfP1fw81r+37tqyrz/Han06un+kH18VnGMlS/h8y2/ApkfAv
         a27G7SqUXifrSljs7c6Lq2mRlQkrOP+bB1B3Z/2I9yZcINsuCw/wzCtQvfK7RdH7oeTf
         hr3lYEwKmQMQhG/gRDa8xaH8T4wj5g46UwSPdpqvKbw5wEwwpIbdyJ5HUcTsHCTTs/wR
         N1eFbUHSJdRGbDv9oGh2gXBTHzCGPQIn0KTOhiC3zZ3orGCt3D57VJJaaQL+ZBdF0PeB
         5Pr0pFscekUDD3LyJQEf8mucon4SCykB8zjfcvzrUnJXsB7v2LLKIdwFnkgkcd+JDQxd
         sYaw==
X-Gm-Message-State: AOAM533fYFdy04DTWqyaKeQPgEKFtFQI/+Da9QRu0IM5A7PmwcNgZDJe
        Ge781/Ak/TERPl1YBmrpmlZjEA==
X-Google-Smtp-Source: ABdhPJxwmuqGUaEMbhWFHdKZGCTvFvIHvNRyJQOSzn13N6LUaSNNjxuVa76ohg77rSq7qDKhPYEfSA==
X-Received: by 2002:a17:902:7043:b029:104:8fa9:7443 with SMTP id h3-20020a1709027043b02901048fa97443mr5636864plt.64.1622830894023;
        Fri, 04 Jun 2021 11:21:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o7sm2773948pgs.45.2021.06.04.11.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 11:21:33 -0700 (PDT)
Date:   Fri, 4 Jun 2021 11:21:32 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: NCR5380: Fix fall-through warning for Clang
Message-ID: <202106041121.990FFB1387@keescook>
References: <20210604022752.GA168289@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604022752.GA168289@embeddedor>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 03, 2021 at 09:27:52PM -0500, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix
> a fall-through warning by replacing a /* fallthrough */ comment
> with the new pseudo-keyword macro fallthrough;
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
