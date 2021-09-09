Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CEB0C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 03:47:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D6F61184
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 03:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbhIIDsd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 23:48:33 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:57967 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230153AbhIIDsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 23:48:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 66DCE320025E;
        Wed,  8 Sep 2021 23:47:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 08 Sep 2021 23:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iBT825
        z+NyUW7N7rDllP1vENTbXXnYYWdNX40tkfrqM=; b=ZzxB0ie4DZAwQo4qTXTzz4
        /cincDRVzMkm0iJ0FQ5nE/IGsgzJDJAdHD+hqtNRngdUeDdIf+zkTsQ76YpeaeAQ
        qeBxNFua+36/zJzxd/5ZWfbyd0cBhtkbPlb3syujTWxQ4JXUq1ld2nuvxltFmaVw
        bm+tZa2qQrRYRestoHzzxSOTqiWV/VJfRqUCmfB4rnhmSJVblO7ggBCVdTBBBWDL
        aevVhjOKsWzU4WbcljLa/bA69BJj8wPJ6kGYTvbGQH6yaDk4Ak7upnTwKh0ZzMDg
        85rBaWzcQM6Vg/A2Ssa4hq6Kf/5REQseXXXBvV7Ow3nJqxDdxvNsskBvRnQn4YFg
        ==
X-ME-Sender: <xms:yoM5YdVCS3n6YSIMU5qRmotZj7l2KcUEw4rq5ku4u2enbXeo8KEZOQ>
    <xme:yoM5YdnuaN0bZZE4rF2SiGWiCX_nfLq3aMarFAHtz0KZ5WA6I-1FQHrjv3u-AEE4l
    Gy_OY5HthayWRiNr-g>
X-ME-Received: <xmr:yoM5YZYAseHxyGIB2-mu-oak0aUXRyBxDdQKhoJaVdasrwGKU7Jhg737dk9ZZ93x2ISuN6yvyDyi1q8EXHgX8sV8DmdvcXN_RyAFsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudefkedgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfv
    hhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrth
    htvghrnhepieeuffduudejueehteefgfevgeejtddvveekvdehfefgvefhteehudekhffg
    fedtnecuffhomhgrihhnpehtfihisggslhgvrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepfhhthhgrihhnsehlihhnuhigqdhmieek
    khdrohhrgh
X-ME-Proxy: <xmx:yoM5YQVwDwJD2lTGh-rX1mjTTtbgFn5k1mv2lLY_Hce6npRlCA-0YQ>
    <xmx:yoM5YXn0FpYo5v0NDp1CoeTma23dw2WqGwn058t6rOrsaKcqGeX15Q>
    <xmx:yoM5Yddp3VWUfeRQthHC0XMla75YTAomidUY0PUflYFAHBz3r7vUkw>
    <xmx:y4M5YQBsLczEsaI7Ounl5pcb4wP-_JD-gLqhG5IlTr1k3Fb6ZPE22Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Sep 2021 23:47:20 -0400 (EDT)
Date:   Thu, 9 Sep 2021 13:47:12 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Oliver Neukum <oneukum@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>
cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove obsolete e-mail addresses
In-Reply-To: <c9168d8e5595bdaa3a18d596f781b55e052af3fc.1631158421.git.fthain@linux-m68k.org>
Message-ID: <b270d7a-10d4-810-3027-eeb824e646c8@linux-m68k.org>
References: <c9168d8e5595bdaa3a18d596f781b55e052af3fc.1631158421.git.fthain@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


[I just found Oliver Neukum <oneukum@suse.com> in 'git log'. I've now 
added that address to recipients.]

On Thu, 9 Sep 2021, Finn Thain wrote:

> These e-mail addresses bounced.
> 
> Signed-off-by: Finn Thain <fthain@linux-m68k.org>
> ---
>  MAINTAINERS | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d7b4f32875a9..690539b2705c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5138,10 +5138,8 @@ S:	Maintained
>  F:	drivers/scsi/am53c974.c
>  
>  DC395x SCSI driver
> -M:	Oliver Neukum <oliver@neukum.org>
>  M:	Ali Akcaagac <aliakc@web.de>
>  M:	Jamie Lenehan <lenehan@twibble.org>
> -L:	dc395x@twibble.org
>  S:	Maintained
>  W:	http://twibble.org/dist/dc395x/
>  W:	http://lists.twibble.org/mailman/listinfo/dc395x/
>  
> 
