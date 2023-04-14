Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F08C77B70
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Apr 2023 08:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjDNI6P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Apr 2023 04:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229673AbjDNI6O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Apr 2023 04:58:14 -0400
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566631984;
        Fri, 14 Apr 2023 01:58:13 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id BA0C95821D1;
        Fri, 14 Apr 2023 04:58:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 14 Apr 2023 04:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1681462692; x=1681463292; bh=z9
        fI6flsniMESwlS/oyoGAx8Z8tukxDoFa/ouV9jXT0=; b=BeVr8Z+4QK1IHwzzSq
        BYZLsxTPjd41nQ7NZkp6mpn+bAxIkjXNcm1HslKC0zEWmhPRIMb/1wac8lA5KS39
        Gl3vnqJgkz+Zl47lyPMYN9ukaVe/V1FoLy8hG6Ol4A+ECpO5+jADfUZ8S8TOVkMn
        bh9dxWKip2K/XgzMZcJStmSrUIjCtGP1N/s9bCKMqNwGvADm17AVu6yYXGEdAJHC
        +PivNo5YqZJrF5100Rnuv3dmX/mPb21V38W6dloXv9ktFfPmY7G4D7fcrOWEYjBX
        VzI+mU76HY9X5u5WAC8bVOqFbo2LV2/hjzJq0Qn9fPpaDRWDwuBUeHRRdc5qS1Ap
        aWcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=ie1e949a3.fm3; t=1681462692; x=1681463292; bh=z9f
        I6flsniMESwlS/oyoGAx8Z8tukxDoFa/ouV9jXT0=; b=XVPMjLQio2rI+ZPhD3r
        emkvelZ+489Gu3W4rfuHhQhatNUDXw+I+Kw4Bv9kFAkG3BXBNcd0U59ykz40sZ5l
        aidsEaepSvd/EoK8OFXVbp8TTCCYyhsbArDG93qzXjZnKifgi3rKrVXGnlwBcWAv
        AY+CeZvdhlS9OayMydaKFbB8JLkrVFrnZV74sax8ZwbRoc2JiiBtIeD0SC34QAzi
        rn6i5mx5w0yKqU2QNYhpybHffvcErbE7rEYlGkcLtUmyw/MfSeHLDfia7Z4oxwQz
        I1ioidEnptkQhfhab69xY4SDPlP/t5mLBdTdm7jpL/WAYMPNmxve2/E0499b2G8t
        Q/w==
X-ME-Sender: <xms:pBU5ZH0B0qWvYH2vNYQlZp7reW2MJxlSrqJ4DjOP7L28x0s6J9ttQA>
    <xme:pBU5ZGEM81TLrq_6EDUVSICpEvlHL4wMoY3iQqLhyuaeCqviXTsKiUvLWZDiKV4Of
    yDv8fgHfO6qB_uC5KI>
X-ME-Received: <xmr:pBU5ZH7DZwfnBr_QR3Jv_NqsEm0-HpAIjF-be1V4C25PG3P49YrLqj9cbWosjGu0rJ15ARIb9QvnCd3Oa7VnMw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeltddguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepufhhihhn
    kdhitghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrg
    hilhdrtghomheqnecuggftrfgrthhtvghrnhepffehffetgfdugeffffelvdfgjefgkedv
    hfehgeefveffgfffvedtueekgeevvefhnecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhi
    nhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:pBU5ZM3c3CHSc3q2z_XVOys11LAg8cQ0OaMTmBhBMFUKnLzzuerk1A>
    <xmx:pBU5ZKH1qWiNQl-qodiv2rNnPAvjkH8siNlNJ846R__4OJ2kdEt3FA>
    <xmx:pBU5ZN_XXtLh-Uqq0kV8Fp1Igkwc_rfN2kgcTM88358O6UL3cea68w>
    <xmx:pBU5ZPS1h0l08-HoQSauXcwiutGMacVxsPVeNvMG622lnV67XG34i3MTWgM>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Apr 2023 04:58:11 -0400 (EDT)
Date:   Fri, 14 Apr 2023 17:58:09 +0900
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     John Garry <john.g.garry@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: blktests scsi/007 failure
Message-ID: <3xwglpdpmit2obtf5p475gojdoqe42rmteki5hvoavzwle6kqr@bl7xginwaeli>
References: <725nkvuvvbf4qwiylarw5r56tjt3r6nrvy5sijk6affzqv2s3e@6xapeviellsp>
 <5ebd61e0-0835-94cd-b55b-942a9c72b5b5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ebd61e0-0835-94cd-b55b-942a9c72b5b5@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Apr 14, 2023 / 09:33, John Garry wrote:
> On 14/04/2023 08:36, Shin'ichiro Kawasaki wrote:
> > Hello Bart,
> > 
> > Recently, I built a new blktests trial environment on QEMU. With this
> > environment, I observe scsi/007 failure. FYI, let me share blktests output [1]
> > and kernel message [2].
> > 
> 
> I did not notice which kernel you are using - did you mention it somewhere?

I forgot to mention it. Sorry. I observe the failure with kernel versions 6.2
and 6.3-rcX.

> 
> > I found the failure depends on kernel configs for debug such as KASAN. When I
> > enable KASAN, the test case fails. When I disable KASAN, the test case passes.
> > It looks that the failure depends on the slow kernel (and/or slow machine).
> > 
> > The test case sets 1 second to the block layer timeout to trigger the SCSI error
> > handler. It also sets 3 seconds to scsi_debug delay assuming the error handler
> > completes before the 3 seconds. From the kernel message, it looks that the error
> > handler takes longer than the 3 seconds delay, so I/O completes as success
> > before the error handler completion. This I/O success is not expected then the
> > test case fails. As a trial, I extended the scsi_debug delay time to 10 seconds,
> > then I observed the test case passes.
> > 
> > Do you expect the I/O success by slow SCSI error handler? If so, the test case
> > needs improvement by extending the scsi_debug delay time.
> 
> The failure may be due to one of my changes. Please see
> https://lore.kernel.org/lkml/5bdbfbbc-bac1-84a1-5f50-33a443e3292a@oracle.com/

Thanks for the notice. I think your changes were applied to 6.4/scsi-queue,
which I've not yet tried. Then it should not be related to your changes.
