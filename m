Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53A73C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 12:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbiCCMTa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 07:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiCCMT3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 07:19:29 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEC0DF493
        for <linux-scsi@vger.kernel.org>; Thu,  3 Mar 2022 04:18:30 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id m6so7535108wrr.10
        for <linux-scsi@vger.kernel.org>; Thu, 03 Mar 2022 04:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W95klwG+EWnuJlXqfneyIPG4bMJIpYFCGfgCPBAo/s4=;
        b=BVoUYAMy6igzOx7YCxgmD2obGVeA4FBbFy39UaDXpcyotfQj1WSs4cD2dBmZ3jehpH
         Xv0H27JfD7LtNc3KTOYt5JsPQaESLbVZdrRIjVdCS/EqEN+LtHV3OI92ZhbhaxnOPsMB
         zwIbvmQMtvcWtqQz/AOpNYfJzkMTFsv4hojr0PuJEFUbZHgxYNi3BKpDV1mgkUzm+fR0
         4lMaaRE5yh5PGutSdpreHiYAqhMDl6KUHTvi2q6aV5S93rhbYz2wGWOzwPq3hB3YVbYG
         uAhL64o8wkOM/gpLUr2Hb7oB/DraMZLkoBj2jGHmKGFPjyxdoWyrLbd/6WyXGtmMO48w
         vp2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W95klwG+EWnuJlXqfneyIPG4bMJIpYFCGfgCPBAo/s4=;
        b=uKW/9CYTETkr6WX4DdZ5QftjV8CqAurAnWufxah55SgOhoPAR/1qhqD5SeZSMpwjMt
         RCQy4BgNKrtVKQGtgiltzpb6bP4Aan+f+sP+BNrpdDs29cN1Tx6DoLxO4vJcDxevIhOP
         XYxkzekzNXsaIoPNqzMUOe53KryNvGk2bbujMllRTU23ejvRHKXiKn2OeoQcGqjsujVQ
         VNLTIqPMbboOwUSa6pNMoPmlj1jVVKsCHsjulh1iyH1EYSkP3i1yHXoR9X6OBfTT7BMi
         GrX6juCmNMS/QtyoAB4uOE9woxfE9Aduo24WV3mggOsKSwjtonczdPxe99yjLH/pBXTd
         18xQ==
X-Gm-Message-State: AOAM533UbVj8c5QAWmfFaaX8gBwiVm+2TEHZZBkJPH7TCD2SenTxaIdB
        C4Vrr/3uLaKzwrlcAxf1KZp4WQ==
X-Google-Smtp-Source: ABdhPJwgYeUN7RS9hQRShRziePljKQd/1cMutSSEkk4MeQ2QRRtTjZSLz5QSndDd2pML49XlqkHAqw==
X-Received: by 2002:a5d:6d0d:0:b0:1e8:7b6a:38e7 with SMTP id e13-20020a5d6d0d000000b001e87b6a38e7mr26568054wrq.625.1646309908722;
        Thu, 03 Mar 2022 04:18:28 -0800 (PST)
Received: from maple.lan (cpc141216-aztw34-2-0-cust174.18-1.cable.virginm.net. [80.7.220.175])
        by smtp.gmail.com with ESMTPSA id p6-20020a5d4586000000b001f0436cb325sm1774600wrq.52.2022.03.03.04.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 04:18:28 -0800 (PST)
Date:   Thu, 3 Mar 2022 12:18:24 +0000
From:   Daniel Thompson <daniel.thompson@linaro.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     david.laight@aculab.com, alsa-devel@alsa-project.org,
        kvm@vger.kernel.org, gustavo@embeddedor.com,
        linux-iio@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        linux@rasmusvillemoes.dk, dri-devel@lists.freedesktop.org,
        c.giuffrida@vu.nl, amd-gfx@lists.freedesktop.org,
        torvalds@linux-foundation.org, samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-staging@lists.linux.dev,
        h.j.bos@vu.nl, jgg@ziepe.ca, intel-wired-lan@lists.osuosl.org,
        nouveau@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com, dan.carpenter@oracle.com,
        linux-media@vger.kernel.org, keescook@chromium.org, arnd@arndb.de,
        linux-pm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        bjohannesmeyer@gmail.com, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, christophe.jaillet@wanadoo.fr,
        jakobkoschel@gmail.com, v9fs-developer@lists.sourceforge.net,
        linux-tegra@vger.kernel.org, tglx@linutronix.de,
        andriy.shevchenko@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, linux-sgx@vger.kernel.org,
        nathan@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        tipc-discussion@lists.sourceforge.net,
        linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-mediatek@lists.infradead.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, christian.koenig@amd.com,
        rppt@kernel.org
Subject: Re: [Kgdb-bugreport] [PATCH 2/6] treewide: remove using list
 iterator after loop body as a ptr
Message-ID: <20220303121824.qdyrognluik74iph@maple.lan>
References: <39404befad5b44b385698ff65465abe5@AcuMS.aculab.com>
 <20220303072657.11124-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303072657.11124-1-xiam0nd.tong@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 03, 2022 at 03:26:57PM +0800, Xiaomeng Tong wrote:
> On Thu, 3 Mar 2022 04:58:23 +0000, David Laight wrote:
> > on 3 Mar 2022 10:27:29 +0800, Xiaomeng Tong wrote:
> > > The problem is the mis-use of iterator outside the loop on exit, and
> > > the iterator will be the HEAD's container_of pointer which pointers
> > > to a type-confused struct. Sidenote: The *mis-use* here refers to
> > > mistakely access to other members of the struct, instead of the
> > > list_head member which acutally is the valid HEAD.
> >
> > The problem is that the HEAD's container_of pointer should never
> > be calculated at all.
> > This is what is fundamentally broken about the current definition.
> 
> Yes, the rule is "the HEAD's container_of pointer should never be
> calculated at all outside the loop", but how do you make sure everyone
> follows this rule?

Your formulation of the rule is correct: never run container_of() on HEAD
pointer.

However the rule that is introduced by list_for_each_entry_inside() is
*not* this rule. The rule it introduces is: never access the iterator
variable outside the loop.

Making the iterator NULL on loop exit does follow the rule you proposed
but using a different technique: do not allow HEAD to be stored in the
iterator variable after loop exit. This also makes it impossible to run
container_of() on the HEAD pointer.


> Everyone makes mistakes, but we can eliminate them all from the beginning
> with the help of compiler which can catch such use-after-loop things.

Indeed but if we introduce new interfaces then we don't have to worry
about existing usages and silent regressions. Code will have been
written knowing the loop can exit with the iterator set to NULL.

Sure it is still possible for programmers to make mistakes and
dereference the NULL pointer but C programmers are well training w.r.t.
NULL pointer checking so such mistakes are much less likely than with
the current list_for_each_entry() macro. This risk must be offset
against the way a NULLify approach can lead to more elegant code when we
are doing a list search.


Daniel.
