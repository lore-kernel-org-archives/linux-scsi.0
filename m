Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0071C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 21:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD40B206DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 21:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591391540;
	bh=LOC7J01Oq/U8Jhk1N8/yzSzXoeUWCptQ70CQKe61Mbs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=n2dBXpc8O6vpJqa76+EKf5uPAcAJmseRxIZdoLHmRe02s4tlX3vEijMPRkVwRn6Wz
	 WmxBDoiqnIv/lUreogKFEhR1/YMew/g5XfgabxxsOJBECiHH5l1XWHANQxCq7KZUJr
	 4YP7lvxVq/IQ4wPJMqX9264ud1PBaAdo9YVQSzEM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgFEVMU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 17:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgFEVMU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 17:12:20 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAF1C08C5C2
        for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2020 14:12:19 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e4so13463839ljn.4
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2020 14:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=14R55ZKvpOnzJ4vLF+zswvbqpQYyCsLayXmmbG2iU5A=;
        b=XWNgx39kpLgYRPFYKrRtzRIaIxKu+xNlnkkj7oOii+v2J8BaNUl4vfcqFKkJgW+CYY
         0SIp5PvrfN+ZmIp+tKX5xxQw8ODR52HX+tzB7Nz5b1tJk0QzsJAXFmHmEW79M35fXW2m
         Z0aMrpog04rXRODX/DlKFGTGvKoQbWh6YQhDo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=14R55ZKvpOnzJ4vLF+zswvbqpQYyCsLayXmmbG2iU5A=;
        b=KfmECz8ZKq+BfIwQ94oa/kwzko+4UJOwM2kS4lqkIlwJpzd/rA9Lt7Ggr0UZ/0TUQK
         sTl4bewwMcnOjZc57ItoUOz80Wr56/ATsi/2xWwkcs+TBXoytZzKEgGCIxShWOf1L9DF
         yCUuyFEQZERAjdwrRXnB9F6AjdiKuXC9hTGMTqEGquaGt3aofpVZ7i9PLJZW35M7mgMy
         yBrJsBU7DPr+N/IAynAUZJXKFHZsbpX6ejedKR3v60VLUJ/OYvv1irzWYd0fHTjxTl3w
         N/OmYnW5ZrKRwfHkTsheWsS0+0sskani8OI49//+H+6UXS+mkuPDJS48mdAFZTPwZHsL
         G1tw==
X-Gm-Message-State: AOAM533ePA0gS/jU/85E+YrcEB8kUuownUCzCfhKLhzKyA50WpNVDFES
        GBgj/WLfT3fUvO1Ghq2PPo7PXa8zhxQ=
X-Google-Smtp-Source: ABdhPJyLuj+yyRaY1SmIMGYpwXo+9Kg7y0uHBuwoxNvXmhEzjZwPXxsAF8XGVH9yrTonDnPdrkfjhw==
X-Received: by 2002:a2e:9608:: with SMTP id v8mr1716816ljh.172.1591391537583;
        Fri, 05 Jun 2020 14:12:17 -0700 (PDT)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id b9sm1197576ljd.76.2020.06.05.14.12.16
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 14:12:16 -0700 (PDT)
Received: by mail-lf1-f41.google.com with SMTP id z206so6633451lfc.6
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2020 14:12:16 -0700 (PDT)
X-Received: by 2002:a05:6512:62:: with SMTP id i2mr6221141lfo.152.1591391535762;
 Fri, 05 Jun 2020 14:12:15 -0700 (PDT)
MIME-Version: 1.0
References: <1591332925.3685.16.camel@HansenPartnership.com>
In-Reply-To: <1591332925.3685.16.camel@HansenPartnership.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 5 Jun 2020 14:11:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjiQmscZHzOYKmMpFoy4h4xF1Mvf9O8i6qtTtS38t6Wsg@mail.gmail.com>
Message-ID: <CAHk-=wjiQmscZHzOYKmMpFoy4h4xF1Mvf9O8i6qtTtS38t6Wsg@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.6+ merge window
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 4, 2020 at 9:55 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

   "Already up to date."

Did you forget to force a push? That scsi-misc tag is your tag from April 10.

            Linus
