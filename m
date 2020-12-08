Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1461C4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E24623AA7
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:55:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgLHMzK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgLHMzK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 07:55:10 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC3FC061749;
        Tue,  8 Dec 2020 04:54:30 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id k2so19262170oic.13;
        Tue, 08 Dec 2020 04:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c6WYIJBR+XhsRbnD+26INvZc4Uq/faLVddDY22Y12+I=;
        b=f2rR/A08P8HqinKm4cKRhkaeB9dxEVcdUntPs7bNhtV6QTPwb0MsyBaSdy6SSCwXSP
         ZoZIy8Az7tfW5TL1zWbmrODkqgk5KR5dZtIj2KzdzHMx5krUfd3YaJgZXpLnXF7GPPui
         HjpwmWhGjUTjxNIKPX6Pce8AEbpilgwG5NT+z2hlxG9DcH5BzhWkFA5xOoocZvOH2Tuw
         a7fpwLI71DifiKNOptj+vbaxLezyrZFeOnVMnm0Abw5oy7NUarJum8yBEn1ywGCCP7EL
         JhZq1Aqq9AyEK2zFjtzzbgCRfMx6joU8TfDGYXMvQXNKpX65O272vY4v4Hq3f7vMrtTw
         1/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c6WYIJBR+XhsRbnD+26INvZc4Uq/faLVddDY22Y12+I=;
        b=mWpn3QZxksMvBNIkENZuJoz9LSj/e9hdozJzyPSKZ0I2S8Y8C1EQ9hfdNq3DJFybeM
         l8YO3bN6mY1eKGTQxIf6NpIdA+gECxknGQ9/TQBRE6qaiHjDwEFlOMkOdkPH4ws3O/Rw
         fNjP2382HHbAVhIqeG0PWtOv5/IDGMVgHTzS7YSkW54rnGmNmcBUrWZzkXNyeThY1dAP
         EqCH9djxhN8QsnboS7hTxCpHo8cyGrpmfG53F7kHQzQbsByxzHCglpSTe+qb3K+ZHSBl
         cdz74ZFibkCzvjK6mtnm0UZDPn7rWz446nveNmJ5cvvQrkb62EyuWj6wgSGfVvmvuQ6u
         vjrw==
X-Gm-Message-State: AOAM5310o/A+3cyvry5MnrpRj1yTUvRqG/ON/UtYRY0E4tsl/iH6Q3Xg
        iIy/lBc397LTmG6r+Qfmk8HfQ+SEnz0WODKqqJrdVej6
X-Google-Smtp-Source: ABdhPJzWqO0H6xQo1Pa+3kwG5pzoNzdKSmz9FQ8FqZ7A9U4h+okSZLXN8+9NFz9k18BK4yVodzucg7f/MUDdZT38Td4=
X-Received: by 2002:a05:6808:a1a:: with SMTP id n26mr2498315oij.94.1607432069805;
 Tue, 08 Dec 2020 04:54:29 -0800 (PST)
MIME-Version: 1.0
References: <20201206055332.3144-1-tom.ty89@gmail.com> <20201206055332.3144-2-tom.ty89@gmail.com>
 <20201207133432.GA28592@infradead.org>
In-Reply-To: <20201207133432.GA28592@infradead.org>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Tue, 8 Dec 2020 20:54:18 +0800
Message-ID: <CAGnHSEnp86-gH5vrHFnAdk3Q+DXm_36crWsfQF-ROTt4VADWLw@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: make __blkdev_issue_zero_pages() less confusing
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sure. It's only for code clarity, so definitely no "major benefit".

On Mon, 7 Dec 2020 at 21:34, Christoph Hellwig <hch@infradead.org> wrote:
>
> On Sun, Dec 06, 2020 at 01:53:31PM +0800, Tom Yan wrote:
> > Instead of using the same check for the two layers of loops, count
> > bio pages in the inner loop instead.
>
> I don't really see any major benefit of one version over the other.
