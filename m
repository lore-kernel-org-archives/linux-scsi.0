Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7BDC32771
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Sep 2022 05:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiIXFVj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Sep 2022 01:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233308AbiIXFVi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Sep 2022 01:21:38 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717C413A3BC
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 22:21:36 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y136so1943462pfb.3
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 22:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=PPRXlLTYZ3zKwK3ad/AozhJnwUlEmFf37ZAwcK6Vux0=;
        b=bRJXy8HIQ7D6BUQDEqhfdStJXXZPFcATdYsA3rCgRlPoLjgYgY5pIsXL1oREfpTrlq
         r+HKkeru+wwduG9JSy6j462a31Q+ODUAvGRE0Nzs/yT/tmihFFPGrSRBuAng65iiMuzv
         Ys9IftdSKHBvGu0i0NGbCSw0nd2mCLt5qQj5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=PPRXlLTYZ3zKwK3ad/AozhJnwUlEmFf37ZAwcK6Vux0=;
        b=kS+aSdTzkgMRedAn0SJ6bpYe+sF1AmwtbArxDskYV1wfgCI0kVjf0XHCcOFduMLZen
         tc2VagwewOpBrxLKP2aMiTj3nuzecaIdB18TdZ2yXNS5wLSDr+5j15wgtQGp/2hwaAaO
         9fnWrHyn07v23QOxAi+nXRR35T4rVkrhdeLruTuUTGIDbUmUAn+SUE8co48RcKlJEcuG
         kAsJKG0jGrU7CWfg+PoMCxIP1x5CiKuqmGP7OaLAjmcIZ3/wK791VVxFt920i4MnOhMC
         Tm81VHr3dQOefX5Z0NzQ8tStb74HpB60jInCeyNgWnV8KQ8eXXzUNfcIfirRKZ1PpmIs
         U1cQ==
X-Gm-Message-State: ACrzQf36ypq1NfNz0wWgvnloPEn+cqkLgEGxOSvMS8yHwZYTzGiZRML+
        DcxUeqX6fMqUeX2vgDNnUd+z+A==
X-Google-Smtp-Source: AMsMyM4XsIuTS/5fCoS42BuVeEKj1MdwRkTAi8gz+gbjVvEbLwrI//toZFaRVR1w62R1BSjWFLQd9w==
X-Received: by 2002:a05:6a00:2409:b0:54e:a3ad:d32d with SMTP id z9-20020a056a00240900b0054ea3add32dmr12611930pfh.70.1663996895927;
        Fri, 23 Sep 2022 22:21:35 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w16-20020a170902e89000b00176d8e33601sm6937804plg.203.2022.09.23.22.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 22:21:35 -0700 (PDT)
Date:   Fri, 23 Sep 2022 22:21:34 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH] scsi: pm8001: Replace one-element array with
 flexible-array member
Message-ID: <202209232203.2F77ADD1CA@keescook>
References: <Yyy31OuBza1FJCXP@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yyy31OuBza1FJCXP@work>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 22, 2022 at 02:30:28PM -0500, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct fw_control_info.

I think this changelog should include some explanation of why this change
is safe. As far as I can see, it would be:

This is the only change needed; struct fw_control_info is only ever used
for casting to existing allocations. No sizeof() is used on any of the
resulting variables.

> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/207
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101836 [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Another one down! :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
