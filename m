Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7218CC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 22:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiKRW2s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 17:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiKRW2q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 17:28:46 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456EA10A6
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 14:28:45 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id AB6825C0463;
        Fri, 18 Nov 2022 17:28:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 18 Nov 2022 17:28:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668810524; x=1668896924; bh=PGlGMNxfEsSdRlQmz2whXX91TCgc
        LHymG+LAv6YWqus=; b=d2MbhRJ91UTUKAkzKA8x+XiaeGb8bIUOy1HnKDkqP3FF
        NfsLGye7q15QqSQzZZ1envw4N90D01i42bxrd9M8idvO1rhzRuqqjFJhGxc0zn8V
        538UJcNblYINPUhq5d5NXwNu7VnkrKkHKp92jC3l9cWuxcWnL/P57eF7wufVyqcv
        UutPjeqJiqql1bbRxM9ItcBsDnKMT2IwEcrBc0v/7/0J5C/PoHvRtf2sCNFV5+qr
        D96zVuFfVMPE9KenkJxTFrbXZHiOCN/1gSam0awW8jCsblp6owBl9EB09ZYdOhx4
        2PYOpNrJ12DCYQ20tTOLOfvYiDXcbKg4CRffAs11DA==
X-ME-Sender: <xms:Gwd4Y48duWpBvMi40xCGtxTQNx5wItq-Gjr2P8n33MFEnwYb2_Uffg>
    <xme:Gwd4YwssKktfP9BikE-KXKvIyNvGdadxFhC3bD5cQuAvPWWMHdy-nOzeTEFQHkQPQ
    NwrOzn4yOwtLj2AbO8>
X-ME-Received: <xmr:Gwd4Y-D6CgCdCJG34dTAgG3CX-BPR-W935Cpe-kARjUSKrNj7UNTQgVJD_szJ376Wi6W6hfgfRWuDXeBCkY-MxM9erx1F9W7pXs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrhedtgdduieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcu
    vfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeu
    heeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:Gwd4Y4d9da0vKH_MTHGeU594SCGKDpn3hcJ5sH4JJ2lOZ7GNWwcbYA>
    <xmx:Gwd4Y9OAhXBCRdbhsXpRu8BbZS-iNVE40tLqdY1hJwLBW0ThJU772Q>
    <xmx:Gwd4YykIABiUCppxvwOCkP21p-1_op6DAOHtELy4djZyl16Xh-KgdA>
    <xmx:HAd4Yw0omqBB9RUxeBW_nci-vFlU-sTqFSvVeDysEaDOnevUDFT1PQ>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Nov 2022 17:28:42 -0500 (EST)
Date:   Sat, 19 Nov 2022 09:29:20 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     Chanwoo Lee <cw9316.lee@samsung.com>, stanley.chu@mediatek.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        matthias.bgg@gmail.com, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Modify the return value
In-Reply-To: <5379c0ec-8dd3-f1bf-0a08-a621c68a3b6d@acm.org>
Message-ID: <2e713ae2-d328-5e2f-a88c-032b6b0a0b17@linux-m68k.org>
References: <CGME20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c@epcas1p4.samsung.com> <20221118045242.2770-1-cw9316.lee@samsung.com> <db25901b-8537-ca16-aaac-0daaa636d84d@acm.org> <c561e1ca-7739-efe7-5c36-952b01634a26@linux-m68k.org>
 <5379c0ec-8dd3-f1bf-0a08-a621c68a3b6d@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Fri, 18 Nov 2022, Bart Van Assche wrote:

> On 11/18/22 13:34, Finn Thain wrote:
> > On Fri, 18 Nov 2022, Bart Van Assche wrote:
> > 
> >> There is more Linux kernel code that [...] than code that [...].
> > 
> > Thus mediocrity prevails.
> 
> Mediocrity? I don't understand the above comment. 

I'm afraid it was poorly expressed.

> Personally I prefer the style without !! and I don't think that it's a 
> mediocre style.
> 

My comment goes to the rationale you gave not the decision you made.

Regarding the decision, it's a choice between "explicit is better than 
implicit" and "brevity is better than redundancy". The patch opted for the 
former, you opted for the latter. I also have an opinion, but I'm not the 
maintainer so I'll keep it to myself.

Regarding the rationale, a maintainer who merely follows the majority is 
not actually doing code review. This will lead to mediocrity.
