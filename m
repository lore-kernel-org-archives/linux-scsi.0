Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F95AC77B70
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Apr 2023 08:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbjDNIxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Apr 2023 04:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDNIxn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Apr 2023 04:53:43 -0400
Received: from new3-smtp.messagingengine.com (new3-smtp.messagingengine.com [66.111.4.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967A75FDB;
        Fri, 14 Apr 2023 01:53:42 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id CC27B582314;
        Fri, 14 Apr 2023 04:53:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 14 Apr 2023 04:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1681462421; x=1681463021; bh=xx
        MUPiuha58jutCU1j4BdfX/BYUAocQhJKarQ7Lpi9Q=; b=ZhMiv/LG/u+WBdrdQB
        KwSw5kEoXq9wWkhqY1mogYc7CfTrjwq6WQuASCx+4+W8RCMyXj+kN28qtFkiEOLW
        ICzKmRil5qaTqEDqHg7KcrLEK4VjNHlLeDYCQUX6xNeUqyuauYa8kFVe9MLI4HiZ
        vcJvZ8DmTjpM85zlmcqND13qDYLCZhrEOKPJ2w2/3nnomMjitxtOdMIVApuYKI5n
        9oGHdkgirkMZXm0gpgb4w09QjuUeP/VJ6VPAfLQeV+BTT1ysywLmJwpvT5aVN/sA
        W0U/RhIWA8SB9rhV276SGtMu7b5s3eGRzrFh3GF7dzIE0/6XIcaUQUhOPxOsHfaA
        MjPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=ie1e949a3.fm3; t=1681462421; x=1681463021; bh=xxM
        UPiuha58jutCU1j4BdfX/BYUAocQhJKarQ7Lpi9Q=; b=NMnNs3/dbiRw8UX4zTN
        /r7iwYmUS3UtMCMgPzohu3mjKD3GXAUzANokBoYEivT8HQEbRWFsPakcUhv1qhhd
        l7yXXQKdJd03AnqmCp4hsUcsTCyz1aW/lZwOGoSwsefvdNokCkHqlZK5pKgmrU/2
        F+5ARKLaFNqS/+C8SWALzU0vnDrBEysQQhDDi/oauAmPe3oX76F/Qj6oz8O8l7oe
        7vVL1h9QE9eFjWVoYoi2NGuMf/GQk/olxzZTElFhLp6CH6IqvWERZrnAIiPzlwUI
        KsG4WT512piys3caLZz+Rg8PqPSh/FoSLMler7pSGVJQgacGW0V25sn+KGlekJpr
        0xQ==
X-ME-Sender: <xms:lRQ5ZIhGXdFCz8jWVgwH7s4p2yn2AqvNjQHeiNJXYECX1lto20V3qQ>
    <xme:lRQ5ZBBUay_160hxfOInL-ls5NUUvUUUcKN4520bwQp1JnVMkJEk7v4g9Hl0-4TBh
    XG5s-1gFkHJ97N6YWc>
X-ME-Received: <xmr:lRQ5ZAGDWfQGkKEj9LfztoT1O3kzdWCLto3R3jGis0NFGUZYUe7z7eLPybEZO4Oql6kFBEpq70OpAoo_ju2qTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeltddgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepufhhihhn
    kdhitghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrg
    hilhdrtghomheqnecuggftrfgrthhtvghrnhepvdegtdfgvdfhgfekvdektdfgfeeljeel
    gefgkedujeeiteehgefhgeethffgheehnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshhhihhnihgthhhirhhosehfrghsthhmrghilhdrtgho
    mh
X-ME-Proxy: <xmx:lRQ5ZJQZn13r-kLNYqpcaJC3qtQV1lqu9km4gYtlXoJP6qEjAZdwhg>
    <xmx:lRQ5ZFygbPYr-qQ2wfpyUQkYChcuW5Z6v37-qGGTJOdJpi-T30xtqg>
    <xmx:lRQ5ZH6LCaINl1kRVYrUp6e9vWFfWtNm6C8YtzUak-saZ8K_vHWFeQ>
    <xmx:lRQ5ZA_dsElmYp0p7exeD26ytSpZT1Uwd-UAGO1-B8nY62i7BmvnLJ-WXWI>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Apr 2023 04:53:40 -0400 (EDT)
Date:   Fri, 14 Apr 2023 17:53:37 +0900
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: blktests scsi/007 failure
Message-ID: <pdj4fz6ega2cvfpzila7cgw3sunkkmswln4rtbt2lsqfvlfx64@owwc36bxvgaw>
References: <725nkvuvvbf4qwiylarw5r56tjt3r6nrvy5sijk6affzqv2s3e@6xapeviellsp>
 <06f976f7-84fe-2994-4632-c23aaff568bb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06f976f7-84fe-2994-4632-c23aaff568bb@nvidia.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Apr 14, 2023 / 08:09, Chaitanya Kulkarni wrote:
> On 4/14/2023 12:36 AM, Shin'ichiro Kawasaki wrote:
> > Hello Bart,
> > 
> > Recently, I built a new blktests trial environment on QEMU. With this
> > environment, I observe scsi/007 failure. FYI, let me share blktests output [1]
> > and kernel message [2].
> > 
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
> > 
> > 
> 
> I faced the same problem, but increased timeout it is passing :-

Good to know that I'm not the only one seeing this issue :)

[snip]

> 
> echo "I/O timeout = $(<"/sys/class/block/$dev/queue/io_timeout")" 
>  >>"$FULL"                                                   # Change 
> the scsi_debug delay to 3 seconds. 
>                                    -       delay_s=3 
>  
>                 +       delay_s=10 

Yes, I did similar trial and observed the test case passes. While I tried it, I
observed that longer delay time is required when I add more kernel debug options
(KASAN, lock related options, etc). So, delay extension to 10 seconds may not be
enough to cover slower kernels or slower systems. I guess the test case will
need some time measurement to decide the delay time good for the system. But
before discussing such test case fix, I wanted to confirm that the delay time
extension is the right fix approach.

