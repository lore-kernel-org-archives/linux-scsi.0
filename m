Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2E9C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 16:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD888221FE
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 16:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbhAOQlv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 11:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbhAOQlu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 11:41:50 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A5CC061757;
        Fri, 15 Jan 2021 08:41:10 -0800 (PST)
Date:   Fri, 15 Jan 2021 17:41:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610728868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d8mjyhjGfj4NiGEQSD0Bw/n6kHPpFmLv4qkOT4y+QB8=;
        b=U7BX1/kqOAVeXHrLPTZHULsGFqy/kAuFni5jhnoDwiDdp//c3Vtb2qMdce1ITECmtgpN4c
        g5hAkXSw3UBLG0VgUY2FjdkeGu+zgh10nW7bpaRP6xlX1VRCa6JyFjDhab6emjKZk+Wd7c
        So29CO1bX4HEsbbNjDVipjt4Lsmv/YBOayflxBADsxM//xtbNohanmn5XKGHA5Aco/8XUl
        xogjse2Ai/gJ7AwdtM2RwbrxrIF8t6IqVtf4NDewnse3IqEkrSujmTtlc48cC2Im18wYhV
        UiMrK5CoJ88IkKfPI7RW44heXwRE/T+QdEoXxgpa48Y3FZQulxzDEbswvVnAwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610728868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d8mjyhjGfj4NiGEQSD0Bw/n6kHPpFmLv4qkOT4y+QB8=;
        b=pfzm7LPZy4TJ5zs9xLjfo019l+cHtdaoixYxNxCNaxMDAQTKapiVdy9uZyS5WKW1gvTHsi
        uyvlXFysmkGJ5mCQ==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 00/19] scsi: libsas: Remove in_interrupt() check
Message-ID: <YAHFnk2r+islHd77@lx-t490>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <8683f401-29b6-4067-af51-7b518ad3a10f@huawei.com>
 <X/2h0yNqtmgoLIb+@lx-t490>
 <e9bc0c89-a4d6-1e5b-793d-3c246882210e@huawei.com>
 <X/3dUkPCC1SrLT4m@lx-t490>
 <20e1034c-98af-a000-65ed-ae5f0e7a758f@huawei.com>
 <YAHCbcNea47Zk+4w@lx-t490>
 <869c00f4-a9a6-e124-3104-906957754dc5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <869c00f4-a9a6-e124-3104-906957754dc5@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 15, 2021 at 04:29:51PM +0000, John Garry wrote:
> On 15/01/2021 16:27, Ahmed S. Darwish wrote:
> > Thanks!
> >
> > Shall I add you r-b tag to the whole series then, or only to the ones
> > which directly touch libsas (#3, #12, #16, and #19)?
>
> The whole series, if you like. But there was a nit about fitting some code
> on a single line still, and I think Christoph also had some issue on that
> related topic.
>

Nice. Then I'll send a v3 to fixing these 80 col issues -- including in
the intermediate patches.

> >
> > > As an aside, your analysis showed some quite poor usage of spinlocks in some
> > > drivers, specifically grabbing a lock and then calling into a depth of 3 or
> > > 4 functions.
> > >
> > Correct.
>
> BTW, testing report looked all good.
>

Oh, that's good to hear :)

Have a nice weekend,

--
Ahmed S. Darwish
Linutronix GmbH
