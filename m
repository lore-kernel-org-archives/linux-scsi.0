Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6534C4363D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 10:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FFAB21775
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 10:12:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="XhKoubSB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgIYKMM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 06:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgIYKMM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2020 06:12:12 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43DEC0613CE
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2020 03:12:11 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gx22so2880082ejb.5
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2020 03:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TPEf3AzVgjk7kwnNfb6XrVp/2ZHv60BXvLkYaQtqcxg=;
        b=XhKoubSBgYfp34RWoHp1Bw1lir2e8+DI1jmkEskiBzRmZwfCrg/KwuL2lrEfhxUSt8
         m/CLEJw2/yTmaVEdRAtGnyAKDQpte+e5ocyVe7ThCVqjDJDrQmg7uVOvwbJk7dJ8xyzB
         9hku//c+a0JWHo6+RN5mb+yaQwyuCH2iGifvPKB2jwP2GBzIb0Ke5v5e/AtGr1jlIv1w
         Mz9O9jOIQI8d72UYMPbMBzkD4w+70rIc7op1a3MFzqsdO7gc8CRKUka8378elfho0Z1y
         GgBTG5cxgskSIfj8K0oXqx/LEgCoIS+Wl7n7kZpwqbcxBlb+GbpiUDOrR5R/ynJl1R/1
         kcWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TPEf3AzVgjk7kwnNfb6XrVp/2ZHv60BXvLkYaQtqcxg=;
        b=nziWtuz5YcsWAoLVO+QDPJ4i5YjgSPhdNOwspugxykkOaem/ZvWOZmjM9qEUOVyFAg
         EqeQdeWJPLiMOcKfyjCQq6vvTLui7IG3vo1lQ/Nd/o55huEVdrDKxUERfumZksKGUZgp
         HqnedkMKA38ZtabjWAW8Bm5E7VZ+sQ91Qrrm5vweQtxfYkdG0i1YGaXhMrHomYmyB4RR
         R3fNvMMZi0O00pI6IdGsCx5w1VIPv9Iecqmu0UbaXp9trFKL9xdeqRyUGsUAcjGqIDUg
         JF9bP0cvE/t5l71PkD0BpnaM4X+e9zMImXQixSP4PN1mex8+SOblCfOio7s8/cr4CoLF
         gVOw==
X-Gm-Message-State: AOAM533n1wa90Fj6UuBoMhvJ5TefHNG/4iyd17CnauVRXgZQziot1OdV
        tIJZsQD0SQpJeWheZtNN1fBv7WCA2iTILMdx0p9sg2AUIwhOfQ==
X-Google-Smtp-Source: ABdhPJwaxrkBEcnsGyQUo78TnlxaroBQ3QRW+gkHOcdwYxHL5Y39tJwezzC0Y6DMHtyJVTTqdtOyDR27UOPRwoU5xqs=
X-Received: by 2002:a17:907:b0c:: with SMTP id h12mr1859649ejl.115.1601028730399;
 Fri, 25 Sep 2020 03:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200925061605.31628-1-Viswas.G@microchip.com.com>
 <20200925061605.31628-4-Viswas.G@microchip.com.com> <c0603b76-28a6-4fe7-89c5-129ea0d6b344@huawei.com>
In-Reply-To: <c0603b76-28a6-4fe7-89c5-129ea0d6b344@huawei.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 25 Sep 2020 12:11:59 +0200
Message-ID: <CAMGffEk-2XYp=o1fDHV7sP3rhsfc_1URzULp24JfXhcX5KfEgQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] pm80xx : Increase the number of outstanding IO supported
To:     John Garry <john.garry@huawei.com>
Cc:     Viswas G <Viswas.G@microchip.com.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>, Ruksar.devadi@microchip.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 25, 2020 at 11:59 AM John Garry <john.garry@huawei.com> wrote:
>
> On 25/09/2020 07:16, Viswas G wrote:
> > From: Viswas G<Viswas.G@microchip.com>
> >
> > Increasing the number of Outstanding IOs from 256 to 1024.
> > CCB and tag are allocated according to outstanding IOs.
> > Also updating the can_queue value (max_out_io - PM8001_RESERVE_SLOT)
> > to scsi midlayer.
> >
> > Signed-off-by: Viswas G<Viswas.G@microchip.com>
> > Signed-off-by: Ruksar Devadi<Ruksar.devadi@microchip.com>
>
> Any reason you can't also use the request->tag (instead of generating
> tags internally) for added performance boost? Many other LLDDs do this,
> as managing tags has a performance overhead.
>
> Thanks,
> John

+1, I think the reason probably is easily compatible with the older kernel.
For upstream one, it makes sense to switch to request->tag.

Thanks!
