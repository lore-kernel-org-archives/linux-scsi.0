Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458B8C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 08:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D69A60D42
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 08:24:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbhILIZX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 04:25:23 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:36667 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231286AbhILIZW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Sep 2021 04:25:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A11B75C00CF;
        Sun, 12 Sep 2021 04:24:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 12 Sep 2021 04:24:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=nL9jNA
        mavBC4HbfglHRAjd/NKzEA9UpNyumbAXQQ1gw=; b=iHG/ky9Gp9WVbmqoOLQWBc
        AnIfiwsQkFmbAEFTe30bKHa/JAee2hcoIhIIRFHKzWTRxlRrp/p/VGszypPYtPOt
        aRJ6oz2xyNRI+d9liiGUQX+YplFKypFDU2duOWONNoqdtAMTkOUWXcwc6KgP6pX/
        tk1vUo/9rLTPkHuH1ikCFYqCp7QJPn7r1c0y5azJ0mSMZiX3KMQBSHKOtmmk83qW
        3b23Ww4A9osHr5L31iVkU31EOco0Xdkmkf1YZyZhw7f39QBqW66irXu5jMIcjy/y
        bIGy8ycwP9dU2HX4gycpjxqJxg1tLcArIsKumlqKVBqeLZi8hh1cFgfY4wFZD0iQ
        ==
X-ME-Sender: <xms:Jrk9YTRC5FKMatjwMCuS0kENllNN9_Q_lDb-RcOUALGnxmMeBbeR4Q>
    <xme:Jrk9YUwEkcZZnxQJqmmUxnR0KuBYb-KJYhdNr4l_E715xx_3-2zF0ngdRDnTA6PKM
    NaNGUT26mLyHyIwJYU>
X-ME-Received: <xmr:Jrk9YY10C6sEbY6RIB3CV0vOGSE54nHNOIVh8fuDIHBX4R8SvKqXF44rE0z6AT2CI79LnDuhk7127YTude-W7J5_OR1TvkWa5J778Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeghedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfv
    hhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrth
    htvghrnhepgfekhfetgedtffejtdehgfegieegjeeujedvueetgedvtdekfeefjeehtdeh
    vedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpthifihgssghlvgdrohhrghenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehfthhhrghi
    nheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:Jrk9YTC6dhvslTPguGXYKNxZqer8l2qyi7crb-cddMxV4_Uh7fipjA>
    <xmx:Jrk9YcgqWN1YijqO_SEo6jZDRuOxQBQ8NYXpCP23qr8SX17ktfns1A>
    <xmx:Jrk9YXqDQNZ8VTk33mHniWBppjWFN1kkTHp4uHHz0llYL33MxttFgg>
    <xmx:J7k9YVseRFxNj6vUo8Igp8VH09OfJ5dncp9ESgxN5XZGJOEJ44UZbg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 12 Sep 2021 04:24:03 -0400 (EDT)
Date:   Sun, 12 Sep 2021 18:23:56 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Ali Akcaagac <aliakc@web.de>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove obsolete e-mail addresses
In-Reply-To: <20210912094239.2fe068ed@web.de>
Message-ID: <ea4d6035-acf3-312a-921b-f427161ff7ee@linux-m68k.org>
References: <c9168d8e5595bdaa3a18d596f781b55e052af3fc.1631158421.git.fthain@linux-m68k.org> <20210912094239.2fe068ed@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 12 Sep 2021, Ali Akcaagac wrote:

> Hi,
> 
> sorry for not responding earlier. I've just started a new job at a 
> different location and things are a bit messy right now. The patch looks 
> good, considering for an old SCSI driver that probably isn't existing 
> anymore :)
> 

Assuming you're still doing patch review for this driver, would be 
willing to respond to this thread?
https://lore.kernel.org/linux-scsi/eb4f2f15-dab8-16da-4fe6-ae90638018e1@linux-m68k.org/T/#mad00ce650ac65c664ec64b98c054d16ceb7e79cb

If you're not still doing patch review, perhaps the patch below is 
incomplete (?)

> On Thu, 09 Sep 2021 13:33:41 +1000
> Finn Thain <fthain@linux-m68k.org> wrote:
> 
> > These e-mail addresses bounced.
> >
> > Signed-off-by: Finn Thain <fthain@linux-m68k.org>
> > ---
> >  MAINTAINERS | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index d7b4f32875a9..690539b2705c 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -5138,10 +5138,8 @@ S:	Maintained
> >  F:	drivers/scsi/am53c974.c
> >
> >  DC395x SCSI driver
> > -M:	Oliver Neukum <oliver@neukum.org>
> >  M:	Ali Akcaagac <aliakc@web.de>
> >  M:	Jamie Lenehan <lenehan@twibble.org>
> > -L:	dc395x@twibble.org
> >  S:	Maintained
> >  W:	http://twibble.org/dist/dc395x/
> >  W:	http://lists.twibble.org/mailman/listinfo/dc395x/
> >
> 
> 
