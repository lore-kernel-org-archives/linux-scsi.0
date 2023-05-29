Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F916C7EE2C
	for <linux-scsi@archiver.kernel.org>; Mon, 29 May 2023 00:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjE2A3Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 May 2023 20:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjE2A3X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 May 2023 20:29:23 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B5AB8;
        Sun, 28 May 2023 17:29:22 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 2C7A05C004F;
        Sun, 28 May 2023 20:29:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 28 May 2023 20:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1685320161; x=1685406561; bh=SZx4cakBbMjHF
        On5HrKK/oEaWaLT/+YkrOsFDE7B+tQ=; b=IWfhR2fiuNo4fquGdOQOQ+Ynk/kWZ
        wloqJwjlNBWOoIrk15hdU7vi94Xmx+no0jXYECNOgNoW8b+VN6yYBEHvuv1CyrfL
        QYOy/Tweqg1zBQgUQYpnlaUQCDNuguBmjQRYHNa+CzgHEL3mRUU8xlFVOzFaQ9Uh
        F6N1fDfjGfWEjXVpvzZGXXLR4NXJnfg0WVoL/omThtG8iRr452WoT5JtJhJW9VVA
        MnjJeX1vCwPuIwnoTMqHhhBxs46gnU1Vq3aQraPiuI5jMlvNUUIaO14mRrmOvzvi
        s/4/HxVOaTELB0mZ23FUmXy/AH/3xvOPR6n0neNTr8M1nigcqm9HaKBTQ==
X-ME-Sender: <xms:4PFzZCH97s_jnie5TetbsV5BHjyeQxXX9ZXMKsMsrPN8Nd9UozTEgA>
    <xme:4PFzZDWJj4BINF57QiYqc2ngotwJqTXzb2hJFvphZyJm4HyCmVsOmEBVoOMTXTah7
    KgVjxwjEnpUVVLEvbY>
X-ME-Received: <xmr:4PFzZMJhnxxPR8tFOi6GZqzUwWxxSg3oKllXgu8rz2g86XhO6A48k0TVK4FsJu5LhIkvT_INfzoP41LKV8bx5g9eF5a1GCgUZkE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekgedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcu
    vfhhrghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelueehleehkefgueevtdevteejkefhffekfeffffdtgfejveekgeefvdeu
    heeuleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hfthhhrghinheslhhinhhugidqmheikehkrdhorhhg
X-ME-Proxy: <xmx:4PFzZMFXbAGqy_tlTIQSuIjQOCX2r1VunREoBuc0hfqVBpb3KYhe8g>
    <xmx:4PFzZIWHKHIHm07_-D38YGkQyseEiCJ2PaQg3JIJ2mh3t-aCAmGbtA>
    <xmx:4PFzZPPNhcqVVBptrGhd8_F9UTE03wclvjdWA9WHXeHGRZFhJSmPgw>
    <xmx:4fFzZGzFYaTxSfnk7YjbJkOnBRR3ADtGSPmMt4G5JzvMYz5VsK4ETg>
Feedback-ID: i58a146ae:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 May 2023 20:29:19 -0400 (EDT)
Date:   Mon, 29 May 2023 10:29:34 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     Ben Hutchings <benh@debian.org>, Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-scsi <linux-scsi@vger.kernel.org>, security@kernel.org
Subject: Re: dpt_i2o fixes for stable
In-Reply-To: <2023052856-starfish-avoid-3dde@gregkh>
Message-ID: <129c9d5e-213a-80c9-092e-dc1dcf38ae3e@linux-m68k.org>
References: <b1d71ba992d0adab2519dff17f6d241279c0f5f1.camel@debian.org> <2023052823-uncoated-slimy-cbc7@gregkh> <5eb8dad50ac455513be8c93c2f0aa0b5b9627b3e.camel@debian.org> <2023052856-starfish-avoid-3dde@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 28 May 2023, Greg Kroah-Hartman wrote:

> 
> So what are we supposed to do here.  Take patches that even if the
> driver is added back upstream will not get merged there 
> (as it will not be obvious they are needed)?
> 

As long as there's no maintainer, I don't think you can accept the patch. 
If a maintainer volunteered themselves, I think b04e75a4a8a8 could be 
reverted. Perhaps Ben will apply for that position -- I'm unable to do so.
