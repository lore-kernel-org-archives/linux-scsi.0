Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BDBC4332E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 13:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C106B221FD
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 13:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbhAKNoM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 08:44:12 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:38844 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730854AbhAKNoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 08:44:10 -0500
Date:   Mon, 11 Jan 2021 14:43:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610372608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=XXEpb/1XA17ogo7lUTa7yQBilRqOhvGnHCcPc/kwuO8=;
        b=PEDDXpI5MGauU/Q3kUklds+LqI/JV1pzt3GgKFx/9HyVap0BD0Q70WJoeqfnTjUOGmrDKr
        qqL7Lgo+qv185OdGwFFOL4eDEL1x2EgazjlyNUsQvRiHWI2QhBMC/2s+yQ0dDEayWYQQmh
        8jxgAkclulG4NqyVFbU0Cn02bknmul/Uqbp8IdEXLermzcx2KrRWD9OkTqm8Fhgw9Wfojy
        LZjr/tyWZ7TlPLmty9kxuRgFwy8AsiEpohsq9lxTrdwhSVryDazXfNt2G6EY3z15w4UqiU
        GVJwmCRPTgPLc5CvTYnhibpqhU9JWrdyEi8bDmhsCL2SmStS0fHK0z3ER+zSeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610372608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=XXEpb/1XA17ogo7lUTa7yQBilRqOhvGnHCcPc/kwuO8=;
        b=TZPbDTl3OAvltlwmjetw+XJ5VlthKf6sYpPa++UsCnvjGoQy/F9kowe85hFsZ+CJKJBxbg
        keMX0W4Slxs0cWDQ==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>, Jason Yan <yanaijie@huawei.com>
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH 00/11] scsi: libsas: Remove in_interrupt() check
Message-ID: <X/xV/uR77a9JLZ4v@lx-t490>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2672812e-91bd-4c60-696d-4000b1914ac6@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John, Jason,

On Tue, Dec 22, 2020 at 12:54:58PM +0000, John Garry wrote:
> On 22/12/2020 12:30, Jason Yan wrote:
> > >      return event;
> > >
> > >
> > > So default for phy->ha->event_thres is 32, and I can't imagine that
> >
> > The default value is 1024.
>
> Ah, 32 is the minimum allowed set via sysfs.
>
> >
> > > anyone has ever reconfigured this via sysfs or even required a value
> > > that large. Maybe Jason (cc'ed) knows better. It's an arbitrary
> > > value to say that the PHY is malfunctioning. I do note that there is
> > > the circular path sas_alloc_event() -> sas_notify_phy_event() ->
> > > sas_alloc_event() there also.
> > >
> > > Anyway, if the 32x event memories were per-allocated, maybe there is
> > > a clean method to manage this memory, which even works in atomic
> > > context, so we could avoid this rework (ignoring the context bugs
> > > you reported for a moment). I do also note that the sas_event_cache
> > > size is not huge.
> > >
> >
> > Pre-allocated memory is an option.(Which we have tried at the very
> > beginnig by Wang Yijing.)
>
> Right, I remember this, but I think the concern was having a proper method
> to manage this pre-allocated memory then. And same problem now.
>
> >
> > Or directly use GFP_ATOMIC is maybe better than passing flags from lldds.
> >
>
> I think that if we don't really need this, then should not use it.
>

Kind reminder. Do we have any consensus here?

Thanks,

--
Ahmed S. Darwish
Linutronix GmbH
