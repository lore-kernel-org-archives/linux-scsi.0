Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91765C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 13:44:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 678B5207DF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 13:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pCT4pUfI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbgH1Nnx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 09:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729582AbgH1NmD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 09:42:03 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1B1C061264;
        Fri, 28 Aug 2020 06:30:57 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i7so383257wre.13;
        Fri, 28 Aug 2020 06:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=rLh0TPLDRuHOF1sa434RgV9ws5clmGQaNXDdUaR7GmQ=;
        b=pCT4pUfIHlx9O2ITdmY6m/sbmp1b1Z/cp65/o1lcKDvl+A7DMxXchyIHOA3WZkjsnF
         Ism/mGsI1nxAb3iPvLqcseknvp16pzyRaW7N12cqo/tAfKaQLv11ndd95ebWN8IBp/sl
         xdJntUwPN/YbxE+zK5hu7FXMWD+z3QXXSx+7mgf4ANazLT1oBJyPJKGxnP1c8MVM8iRu
         kV+8zEi6/87Y1xmCWm/qxLLkNr5o/HwZTwv+uyUoF876Xsi7mbAtItMVLPgojpKICY9e
         h4ZjhziNfOgPemc/weD7q5VXzTVlLhfmKwgW4ghnwWtxi3Q+f8bLea4WWfHZWopVXQuH
         ohWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=rLh0TPLDRuHOF1sa434RgV9ws5clmGQaNXDdUaR7GmQ=;
        b=dX2FToRh8fq5gO+xziDaU3R/vO+/MeJidtpPJzO5qPZD66/oQYnbgZEJISjfO/A72q
         +sAcj5bUtucWDleEks8IHRrPJT9egzYL4Nr7upRB0ph8i8696v04cpl1vzJevGNWJntA
         6vq5fncKOszMdokPMfYfj8/qqW9DbhyYaxxPMqZ+1dm9z86Gcr9fTXEDvf0T7J2zRD0l
         DZckUBEc/Cjj6Uz4DPKl/BiVaWmysUTGQjwvaJYaisVeJ2BoxK8JZ1uDN0sItjvJsWAu
         vtsHyH2StC5lb1DhTwZLtorOthWGe7LjXUqiEGdiEXgRj7vywCcjqNxw98i4AF7RoZmP
         /KGA==
X-Gm-Message-State: AOAM5333+N9zPW/t52r2DKg9Uu/YjfDuikT/yiKZ6BOc0uZOkEMuW0GO
        DN+ULrMlE5KdGmRWZwo42yg=
X-Google-Smtp-Source: ABdhPJyfgahGUNslcWxi1Qo1bcb+12VpnW3m9WmMwH9GuULHZ3CZ8GQBwKDjrNeoJpwJ4+ZgVCKvEQ==
X-Received: by 2002:adf:de08:: with SMTP id b8mr1503680wrm.4.1598621456377;
        Fri, 28 Aug 2020 06:30:56 -0700 (PDT)
Received: from felia ([2001:16b8:2d94:4000:f807:c6f3:919:9c25])
        by smtp.gmail.com with ESMTPSA id n205sm2539670wma.47.2020.08.28.06.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 06:30:55 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date:   Fri, 28 Aug 2020 15:30:44 +0200 (CEST)
X-X-Sender: lukas@felia
To:     Roman Bolshakov <r.bolshakov@yadro.com>
cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com,
        Arun Easi <aeasi@marvell.com>
Subject: Re: [PATCH] MAINTAINERS: orphan sections with qlogic.com group
 alias
In-Reply-To: <20200828091758.GF54274@SPB-NB-133.local>
Message-ID: <alpine.DEB.2.21.2008281524360.11562@felia>
References: <20200828070824.8032-1-lukas.bulwahn@gmail.com> <20200828091758.GF54274@SPB-NB-133.local>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Fri, 28 Aug 2020, Roman Bolshakov wrote:

> On Fri, Aug 28, 2020 at 09:08:24AM +0200, Lukas Bulwahn wrote:
> > Previous attempts of getting an answer from the qlogic.com group alias,
> > i.e., QLogic-Storage-Upstream@qlogic.com, have remained unanswered; see
> > links below.
> > 
> > Mark those sections Orphan to prepare their deletion or give an actual
> > person a chance to step up to maintain those drivers.
> > 
> > Link: https://lore.kernel.org/linux-spdx/20190606205526.447558989@linutronix.de
> > Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.2006300644130.4919@felia
> > Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.2008270740140.31123@felia
> > 
> 
> CC'd Arun,
> 
> I think it's worth to update the alias to:
> 
> GR-QLogic-Storage-Upstream@marvell.com
> 

So, if these drivers are not orphans, you can answer Thomas Gleixner's 
original email from 2019. If you can quickly ack that patch set, I am 
happy to do the donkey work to get this apply nicely on the current 
master (please CC me on that response).

Lukas
