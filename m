Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D2DC433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 15:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B65820825
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 15:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q45ljkoj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgH1P2o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 11:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbgH1P2h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 11:28:37 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B34C061264;
        Fri, 28 Aug 2020 08:28:37 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z9so1286926wmk.1;
        Fri, 28 Aug 2020 08:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=4zDZVOKRqOadCUlMiFS7BJletMH5TookJPK9U8F8DgQ=;
        b=q45ljkojrkWIZ3Ebo9FvI1Lwc65xJNNifYqixJ/Gl2DobnrWm6neaeJHXhKdfk7Wro
         n4o7n/c9pMWz2rIouT98tE6PVM9wTYAd5SzXLVOX+6fCuAyqJQCrKWKKMXuAl7nxHrwP
         VSztNt+zlvly9GWyR7Y3PooQewcTZLj0fCIWFC6lkSqaia1azlehizewnmeTax98toXx
         3gYJsNbtkfO9WQeeaKmorzK25EN5dhJ+gdkNNJoLDZ3QG05lbvAY2DYa+cfEIPOQL8eK
         w+Jfc/bDi1Uza/jwT6fz4Bg7xvscFtW9MNZSeQZmF436qwHm+Cfe7pmRSG7TXBE+zF5C
         P2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=4zDZVOKRqOadCUlMiFS7BJletMH5TookJPK9U8F8DgQ=;
        b=f2FNhn+wGEi5e5Khi1iaX1282Bahk6NY4oG5GjXCRzeKvXKOwbR+qTgu1x2M3qTWQn
         7Hq3Gj7+JiIGNes3kCLvKNEBVlInA1heAHuHfwP26VPIUvyv9tpHo5C6tWUpVtHvp1yc
         /o4Fxt9f0DNIxbG3SVCw1nixVmV5WI/c3N7Ir4Jw9fD+YUHmu7AgDolPRrUgw5uSTcqQ
         vQjGz1OiUB22BLJBcvWW0q8t5X1mDR7Yf8QyPhWJMKWJQBMKcSoq6iifuSJKOLz5wngO
         i+OrUmXvQRfPUZDvnPtQ40RHX+pUlKXxM64r9KZqK/9p7BGhGDOONdHvKQ9oSuFYbkBA
         5Iog==
X-Gm-Message-State: AOAM533BsIvpSZUC4WJxj/HrAVMGUERibUom5xPsUYsfhsay9mjpBnBt
        qyfOrCcDRV+q92K+WC5UZDqZNjF91bKjC4EX
X-Google-Smtp-Source: ABdhPJyIba8MB1Xn/IiwRMPqwu6BvkixjiNRXT6y7dDgf/374vKBegMYD5ww1R3hcATH6g82JShmnw==
X-Received: by 2002:a1c:7dc3:: with SMTP id y186mr2258830wmc.59.1598628515679;
        Fri, 28 Aug 2020 08:28:35 -0700 (PDT)
Received: from felia ([2001:16b8:2d94:4000:f807:c6f3:919:9c25])
        by smtp.gmail.com with ESMTPSA id m125sm2927101wme.35.2020.08.28.08.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 08:28:34 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date:   Fri, 28 Aug 2020 17:28:26 +0200 (CEST)
X-X-Sender: lukas@felia
To:     James Bottomley <jejb@linux.ibm.com>
cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
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
In-Reply-To: <1598626957.3883.17.camel@linux.ibm.com>
Message-ID: <alpine.DEB.2.21.2008281719290.11677@felia>
References: <20200828070824.8032-1-lukas.bulwahn@gmail.com> <20200828091758.GF54274@SPB-NB-133.local> <alpine.DEB.2.21.2008281524360.11562@felia> <1598626957.3883.17.camel@linux.ibm.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On Fri, 28 Aug 2020, James Bottomley wrote:

> On Fri, 2020-08-28 at 15:30 +0200, Lukas Bulwahn wrote:
> > 
> > On Fri, 28 Aug 2020, Roman Bolshakov wrote:
> > 
> > > On Fri, Aug 28, 2020 at 09:08:24AM +0200, Lukas Bulwahn wrote:
> > > > Previous attempts of getting an answer from the qlogic.com group
> > > > alias, i.e., QLogic-Storage-Upstream@qlogic.com, have remained
> > > > unanswered; see links below.
> > > > 
> > > > Mark those sections Orphan to prepare their deletion or give an
> > > > actual person a chance to step up to maintain those drivers.
> > > > 
> > > > Link: https://lore.kernel.org/linux-spdx/20190606205526.447558989
> > > > @linutronix.de
> > > > Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.20063006
> > > > 44130.4919@felia
> > > > Link: https://lore.kernel.org/linux-spdx/alpine.DEB.2.21.20082707
> > > > 40140.31123@felia
> > > > 
> > > 
> > > CC'd Arun,
> > > 
> > > I think it's worth to update the alias to:
> > > 
> > > GR-QLogic-Storage-Upstream@marvell.com
> > > 
> > 
> > So, if these drivers are not orphans, you can answer Thomas
> > Gleixner's original email from 2019. If you can quickly ack that
> > patch set, I am happy to do the donkey work to get this apply nicely
> > on the current master (please CC me on that response).
> 
> I have to wonder what the object is here: to get the problem fixed or
> to make a public spectacle?
>

Let us get the problem fixed; no spectacle here.

> Because if the object had been to get the issue fixed, waiting a year
> before escalating to the SCSI list isn't the best way to achieve
> outcomes, nor is now demanding that the drivers be orphaned for lack of
> response to you ... particularly as you've seen the drivers updated
> over that time if you actually follow kernel releases.
>

I just followed Greg KH's advice; spdx licensing clean-up is not the top 
most priority thing; so it just happened to be laying around for a year.
Feel free to ignore this patch and we solve the problem instead.

> Qlogic or now Marvell tends to rely somewhat heavily on outsourcing for
> driver maintenance and support.  Outsourcers, fairly obviously, aren't
> going to respond to legal issues like this which are outside of their
> remit.  What needs to happen is that someone needs to find a person
> within the Qlogic org who can get this fixed ... possibly involving
> explaining the actual issue along the way.  Would you like us to use
> our contacts to do that?
> 

Yes, I (and I will bet the licensing clean-up janitors) welcome if that 
legal question can be resolved and the kernel can be cleaned up from 
unneeded files.

Lukas
