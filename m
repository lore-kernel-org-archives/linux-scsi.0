Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF443EB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 22:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbjG1W1o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jul 2023 18:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbjG1W1m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jul 2023 18:27:42 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35EEE4498
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2023 15:27:25 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-686ea67195dso2001505b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2023 15:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1690583244; x=1691188044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TxEx9u7RuHaHHSAnVYLqhTOHTd/40wiauXx1aUUDndM=;
        b=Z+C4c8F3slTpu55XXPhcK91pA9ZANhBF0nQSY3VqLyL3GCx21bSh98cqoHvQlzHymC
         KfVryApQS0u7o0gzK/nWleHtVB5NdSP7Fgv4kG0uhXwCgPcr+vKP0ZnEW7rtIMRD8BIi
         SBXQqnkoi7RHK/SBJ4sGoL6hN9PwmYvy7rSVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690583244; x=1691188044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TxEx9u7RuHaHHSAnVYLqhTOHTd/40wiauXx1aUUDndM=;
        b=EqzN1CJG2JsGRLrHBM1gLf7pJxz+2dojemoh1YK6paniCMn6+5bAT71nRqJcpW5C/9
         M/HkoIu5Rp+J0ZKQTHMSweyg8XBEktIDQrhvyRNqwWQU+aPH+k9DNbepbJtfMGjU3Aht
         zc+ltQuN747PZ6cyFiZ2TR6IWAEUtrZoj9h1kNChi8r8Uoq4ssy9nSmKKsd2F+BaVflL
         wVPNH0cJ+m1OgsK14Z048TnZOT4f9sQ78n8USbrN6aBbAJcdEJEW7Jjo3pvxANec7nWJ
         dVmv9ky8aGAsN1r4cWADfGDkhuKzg4hOz/xkdIFfmKDuSpiq55M9G3lUy1k+yyw6dEdb
         U1Pg==
X-Gm-Message-State: ABy/qLYBJwGj47nibCbtSMluxsULNzK7DIQQURizhakVZ1lsAosBgZOi
        J+GSug3UEZPrgFK5NZpQvtUAHQ==
X-Google-Smtp-Source: APBJJlHBVzfsxrvTTcHtfT0hMHfSLGFwmQxpbcF29cfghuRDdTwZqlUmv4wbk5g/l4EOtyHqWniFPQ==
X-Received: by 2002:a17:902:e885:b0:1b8:8262:7333 with SMTP id w5-20020a170902e88500b001b882627333mr2738551plg.51.1690583244595;
        Fri, 28 Jul 2023 15:27:24 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a18-20020a170902ecd200b001b7fd27144dsm4100996plh.40.2023.07.28.15.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jul 2023 15:27:24 -0700 (PDT)
Date:   Fri, 28 Jul 2023 15:27:23 -0700
From:   Kees Cook <keescook@chromium.org>
To:     James Seo <james@equiv.tech>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] scsi: mpt3sas: Fix an outdated comment
Message-ID: <202307281527.290DBFE9C7@keescook>
References: <20230725161331.27481-1-james@equiv.tech>
 <20230725161331.27481-5-james@equiv.tech>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725161331.27481-5-james@equiv.tech>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 25, 2023 at 09:13:29AM -0700, James Seo wrote:
> May reduce confusion for users of MPI2_CONFIG_PAGE_IO_UNIT_3::GPIOVal[].
> 
> Fixes: a1c4d7741323 ("scsi: mpt3sas: Replace unnecessary dynamic allocation with a static one")
> Signed-off-by: James Seo <james@equiv.tech>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
