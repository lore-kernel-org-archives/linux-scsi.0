Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE48C7EE2A
	for <linux-scsi@archiver.kernel.org>; Fri, 19 May 2023 04:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjESEpz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 May 2023 00:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjESEpz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2023 00:45:55 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE143E69;
        Thu, 18 May 2023 21:45:53 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 2AC365C00A8;
        Fri, 19 May 2023 00:45:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 19 May 2023 00:45:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1684471553; x=1684557953; bh=XLrXiNNLQNu84
        D+iEJjCzmForwetyAbrQ/LuR0+SG18=; b=m+cg2tmdj2vZ7GXyDSUs448aw+flv
        lhzhNs+1D75nENnPmaGn9sAp/PjE1yHrCGfrWBMK39SJJO4+B+oAjNXwDCcabu8V
        qtq21yruVay6Dp6H2Hbwr0uPQhfgUI+TRasdA1zaPRBKVV8YIhLVP7h9jsUTpUvy
        M7YiABzD6k1ClLYbkE+UQQ2li3qjOGswLjN1LujzyoWfCPR+2YgN4GhLW9xwkXjS
        P4Op68geo4mkAQONrlwNE6zLiU0+4q1gy7ROh4ClzV9rIsSy/4WPK7f5IVC3sMnY
        5kFhRGw2jCcCLDpwdewfUbPDQW4cZNWq4jQdm9BINGRbxk9W1RYwPy0og==
X-ME-Sender: <xms:AP9mZNo-iHN-NXM4UHO58MOvtn8aIhp3Jfuubst1YvFQ5CCTJVnt2A>
    <xme:AP9mZPq6aN7nxKGgaEOJZNCqOzUFtyfo5W9JbpSXHWI37AvcnOuK3DDCW0jbuJ7QC
    7GPjIcNU3ST3SjMFFQ>
X-ME-Received: <xmr:AP9mZKOQbOzzbm2g0ihrvWbeCfayMCqYmoKo1Bwkqy3ZTEryL9UqU-UXVlltCGfZ-h0bBgl5AVSOyeidjKFG9qGT5a7J8fUHPUo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeigedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcu
    vfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeu
    heeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:AP9mZI5zUykTBazpN5XMPw-HpgslN0lgZaHSHKf9xFDkBB_YkQdFqQ>
    <xmx:AP9mZM6LhXk_RUwivG6k82aLbkDwEVR3yzEehRd7inWp4Ps9tK5fYQ>
    <xmx:AP9mZAg3RsDcM5hVS2qPQHEi9BPJjVzbVSS3K7QgEUwgMLJt8wRSSQ>
    <xmx:Af9mZGTvgwfO60awR8kcU-J-ia7g8bL6QfR61TQlfUKbYV0BgxrG5g>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 May 2023 00:45:51 -0400 (EDT)
Date:   Fri, 19 May 2023 14:45:52 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Randy Dunlap <rdunlap@infradead.org>
cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 08/11] Docs/scsi: g_NCR5380: shorten chapter heading
In-Reply-To: <20230518212749.18266-9-rdunlap@infradead.org>
Message-ID: <5c569351-25c1-1a2b-e506-05f503944656@linux-m68k.org>
References: <20230518212749.18266-1-rdunlap@infradead.org> <20230518212749.18266-9-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Thu, 18 May 2023, Randy Dunlap wrote:

> Make the chapter heading be concise yet still descriptive.
> This makes the subsystem table of contents more readable (IMO).
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: Finn Thain <fthain@linux-m68k.org>
> Cc: Michael Schmitz <schmitzmic@gmail.com>

Acked-by: Finn Thain <fthain@linux-m68k.org>

> ---
>  Documentation/scsi/g_NCR5380.rst |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff -- a/Documentation/scsi/g_NCR5380.rst b/Documentation/scsi/g_NCR5380.rst
> --- a/Documentation/scsi/g_NCR5380.rst
> +++ b/Documentation/scsi/g_NCR5380.rst
> @@ -1,9 +1,9 @@
>  .. SPDX-License-Identifier: GPL-2.0
>  .. include:: <isonum.txt>
>  
> -==========================================
> -README file for the Linux g_NCR5380 driver
> -==========================================
> +================
> +g_NCR5380 driver
> +================
>  
>  Copyright |copy| 1993 Drew Eckhard
>  
> 
