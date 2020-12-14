Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01A57C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 22:28:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB3FC224F9
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 22:28:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439698AbgLNW1l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 17:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729522AbgLNW1k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 17:27:40 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D21FC0613D6;
        Mon, 14 Dec 2020 14:27:00 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id p22so18874050edu.11;
        Mon, 14 Dec 2020 14:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9luV3WbxPFSpfKcSxGTt+i2DTKMuuCfUMkAWdvBYnQ8=;
        b=kS2Adh400G0tNs14Wunz/+BXHNaef+bplNXckFElS9vOk/aIbsMpN13Mw5YX8ss1Zf
         HkPwcQ3iL4qsP9iS1TWHQs6C0rtfeppvo0iyni++sLkPyVSLTGyfgvGaqkvsJ7y4Ini/
         LHCDmTHdVhGA/JWaYzLffVJAU+gfUp7n2csFcazC+hk5HzkikOo26nO7pTwUyhJafwKU
         9mlE0uZGsYpJlbD0U9lan0Os7AN9ViFsB4PyovJYjpNrKgS5eFNzXP8ZF1bR9OSZDBHi
         3dcfBDWSe1G/4vsxLHZREus7Ffz51YLJ29KZd/vjPrkiZOXCbxvGpa8r4UQQ3taAR2oZ
         3Wgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9luV3WbxPFSpfKcSxGTt+i2DTKMuuCfUMkAWdvBYnQ8=;
        b=Nj+Kg4RoP2nHN7RxgV/AQXAkY+DgFx3+8CZKiifdZqL3lUER/H1ViEhX3cqXEnEdrx
         Q+T9bkY6QoTswZy7ns2YmsTf/IYbGm2tRrPZFR9DI+4Dd+rRtKV120majMuflGQ32YjP
         0CAbCA5pl+0V2fFqHEnAe8t/Q2YbN68Eej7dkbSkEZy601nG6+8+5dhXqmBW+4iOUX4g
         WUhh8G8qDp2pr5/i1o2uXxe7BfIZfF70zKvSMw2SfyqLo5Pv9j3QU0vIkp7ObAru/UF/
         0EJQHudAKV4aA6Zh/Hn1ICskJceCyHVKATjdOMjbTFmJBQtE0xWmbmCWKcGBcx+Cdn/V
         JEgw==
X-Gm-Message-State: AOAM531YT+jXMEoqYQAl/No3Iwsainxxmj6IHnC/m5i/+ZRVzABZQiXC
        zUD1FvmqEUth2i8kMVxJvg8=
X-Google-Smtp-Source: ABdhPJwHL6hPC8jxHxTuBp6MbCoN3XRzcPwg8KD/sr7DdnkrTpxZ3otko5xBe0AQ37OFk09V8Ma/Eg==
X-Received: by 2002:a50:d757:: with SMTP id i23mr27217416edj.116.1607984819259;
        Mon, 14 Dec 2020 14:26:59 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.googlemail.com with ESMTPSA id b14sm11072712edu.3.2020.12.14.14.26.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 14:26:58 -0800 (PST)
Message-ID: <f0bc0bd63c712db452d0204220d53c4bf7101c79.camel@gmail.com>
Subject: Re: [PATCH v3 1/6] scsi: ufs: Remove stringize operator '#'
 restriction
From:   Bean Huo <huobean@gmail.com>
To:     Joe Perches <joe@perches.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 14 Dec 2020 23:26:57 +0100
In-Reply-To: <f9017bc73dadfb84366734062d93722d8d7ecc59.camel@perches.com>
References: <20201214202014.13835-1-huobean@gmail.com>
         <20201214202014.13835-2-huobean@gmail.com>
         <f9017bc73dadfb84366734062d93722d8d7ecc59.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-12-14 at 13:23 -0800, Joe Perches wrote:
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > Current EM macro definition, we use stringize operator '#', which
> > turns
> > the argument it precedes into a quoted string. Thus requires the
> > symbol
> > of __print_symbolic() should be the string corresponding to the
> > name of
> > the enum.
> > 
> > However, we have other cases, the symbol and enum name are not the
> > same,
> > we can redefine EM/EMe, but there will introduce some redundant
> > codes.
> > This patch is to remove this restriction, let others reuse the
> > current
> > EM/EMe definition.
> 
> While this version doesn't have the copy/paste typo,
> I fail to see value in defining EMe as a trailing comma
> in an array declaration isn't meaningful and doesn't emit
> any error or warning.
> 
> Maybe all the uses of EMe can be converted to EM and the
> macro definitions removed.

Hi Joe
I removed EMe, but there is this error:

./include/trace/trace_events.h:300:18: error: initializer element is
not constant
    { symbol_array, { -1, NULL }};   \

./include/trace/trace_events.h:300:18: error: expected expression
before ‘,’ token
    { symbol_array, { -1, NULL }};   \


did you choose kernel trace and event trace before compiling?


Thanks,
Bean

