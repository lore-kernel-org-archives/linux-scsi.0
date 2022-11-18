Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF7DC43217
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 21:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiKRVhi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 16:37:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiKRVhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 16:37:37 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A23A317D
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 13:37:35 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 939085C02B6;
        Fri, 18 Nov 2022 16:34:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 18 Nov 2022 16:34:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1668807253; x=1668893653; bh=zy9zfSxGgygHU3QKXELj5gWny0p3
        j9DJBoAoG1+XBFI=; b=MtRLXpefJ+alywWKWXEspuM4omh9vNKVgudrGJFOrccG
        Wi+d6CYBxKox/R/C/YHbzVIOYhjp0o1Sil4FItWbpQZt8bAxOcOhJ1tg1hAEBuVa
        mBGswF/4PmgpXBX8+FSrBOFku/3ODq2NRbE85TPzufKCSDTvGTflzFqo9Dw5A/GX
        pgniozyqHLgj2vdMWinmJgqrKeELZQ2OUqhe1c1RED1nioqq+N8KOMnBsEEf5lNX
        1Es0MGJoeHf8EJGj54zg83vD2T0PCa2QMVhurqgEYQt2LgDkLU/bhWx3/qQqipw3
        HtvJLD3HY44R2WKuIWV77SDMTSQA9lI4PUW9abzAzw==
X-ME-Sender: <xms:VPp3Y5wDOeASLt2uqFhcrxxrUJzlk40wz0HTuyPuIQ7LDQWxzdr0Gg>
    <xme:VPp3Y5TNSpWhp3M7fUE963PcVzUPL_1Ddq69REjAnBoQvHkCPAmN4NSzLU4ngezgI
    guk4oRDrBtbF44eeG8>
X-ME-Received: <xmr:VPp3YzXYXJluBYDZDxBDnyYB_iYrMKmO4l-KX6s7JoIMqoGYmbZDlRsm7JWjjWNasFcpQEeEb_WxgkenAcQ5TGboY2a5Fu1qlSQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrhedtgdduheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcu
    vfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeu
    heeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:VPp3Y7gYh0LK5BPOhR84I8si6E0s5e__V-qeIg4URIa6xV8qn6EFMA>
    <xmx:VPp3Y7CanklhUSWZ0rGWAJkDFP9qqlA-zUnzLhhEH9Y4jrhJ2plBAQ>
    <xmx:VPp3Y0KZqJLDrZpAUfs81tP5GxX-QrFYsuzVjMu8yGL4-bFYnCvENA>
    <xmx:Vfp3Y26syCETOIUWTbL8xDYskIg9cFHtg4jasmik2zvFieT8Yo1G1w>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Nov 2022 16:34:10 -0500 (EST)
Date:   Sat, 19 Nov 2022 08:34:43 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Bart Van Assche <bvanassche@acm.org>
cc:     Chanwoo Lee <cw9316.lee@samsung.com>, stanley.chu@mediatek.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        matthias.bgg@gmail.com, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Modify the return value
In-Reply-To: <db25901b-8537-ca16-aaac-0daaa636d84d@acm.org>
Message-ID: <c561e1ca-7739-efe7-5c36-952b01634a26@linux-m68k.org>
References: <CGME20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c@epcas1p4.samsung.com> <20221118045242.2770-1-cw9316.lee@samsung.com> <db25901b-8537-ca16-aaac-0daaa636d84d@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Fri, 18 Nov 2022, Bart Van Assche wrote:

> There is more Linux kernel code that [...] than code that [...]. 

Thus mediocrity prevails.
