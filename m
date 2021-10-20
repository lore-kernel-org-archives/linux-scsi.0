Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE43C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 22:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC5F61354
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 22:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhJTWwi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 18:52:38 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42995 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230123AbhJTWwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Oct 2021 18:52:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 722E55C0257;
        Wed, 20 Oct 2021 18:50:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 20 Oct 2021 18:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=lSsjbO
        QwefFnogmBYkQShNyvBodWyjPRyIlY4BZCdbY=; b=XTFPUQpIgFUb5/+zQnC3+q
        E7iOxXZPkaMDV1LZeLMZHcNWaAPPNFYwJArhDaxHz04DhUA8SWNsm8dI1fjXUkgo
        2soX9rJ7FjQLUmxi+xkJEsyrBs149cTEC9jikjMUNPsE8wF2gEZL8vJS7NftJADm
        heU+kExqUoInTXCuSLkwVKw26Kyj8tbG/GZi0cPRCatdUq55KdlqrDzW6THS6+v2
        6XBYAugsRB6Ko7srZzO5hi79sgj7nuzYlRwxtg7FzDrA2XFWqzDDmLcoPQSOEGqI
        Ex8CTizCH4Y3S9yAXbSIGIvvhCM8LzL1gjBQyNZ/i7lAzj3T7VrD6A0OhkrwifNQ
        ==
X-ME-Sender: <xms:K51wYZFewfi-AL5pGcvaYooQnbQruG7uh8zSvvgNPnuo-76Eao6KPA>
    <xme:K51wYeWl7djtgVf_Zr8AUhNqQugbl_XPOCON2FfCnXjxpGNWnWhJoUkwoH475B5WU
    GCg6vKb3ssCAT-mN-k>
X-ME-Received: <xmr:K51wYbK4t1wdd7x2RxraeXnIMIeJkaCJXKeqYyDIEOTvuXSg3oO8l_U9hO6mWri98jzRJOOc4caH977EWV0Rdgb42xGw51fIlms>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvhedguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfv
    hhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrth
    htvghrnhepffduhfegfedvieetudfgleeugeehkeekfeevfffhieevteelvdfhtdevffet
    uedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfh
    hthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:K51wYfH7JG_tsZcCvO-7-jwWBNyJ0m62pku7J5lc43Cxx9k0WAtGIA>
    <xmx:K51wYfWPiQnbtJ1qik-osTUwE-1UkDVKdX4euCyH-p86CapKUl5jzg>
    <xmx:K51wYaMFq1Mrf-siJAmOwrH52khfjKTXlKFUX8GGsfRej4SaJdM3Yw>
    <xmx:LJ1wYRKK95A2MlNqsylBLp9qGuHy1TeVawjzntlTvweGVmAUAtc0ag>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 20 Oct 2021 18:50:18 -0400 (EDT)
Date:   Thu, 21 Oct 2021 09:50:26 +1100 (AEDT)
From:   Finn Thain <fthain@linux-m68k.org>
To:     James Bottomley <jejb@linux.ibm.com>
cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_mbox: return -ENOMEM on megaraid_init_mbox()
 allocation failure
In-Reply-To: <670213ce9e6c3b625e9f8ed66b9fad8ea2843322.camel@linux.ibm.com>
Message-ID: <cf8da58-de8b-e171-5a40-2b10983d447@linux-m68k.org>
References: <1634640800-22502-1-git-send-email-jiapeng.chong@linux.alibaba.com>  <2482854e18365087266c2f0907c1bbfd42bd2731.camel@linux.ibm.com>  <c1a6e7f3-d62f-5c5e-b3ef-2320339e142a@linux-m68k.org>
 <670213ce9e6c3b625e9f8ed66b9fad8ea2843322.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 Oct 2021, James Bottomley wrote:

> > 
> > ... and arguably they would be correct.
> 
> Well, yes ... that's why I don't want one "fix" that generates a 
> cascading sequence of further "fixes".
> 

OTOH, if you don't "fix" it, it generates a cascading sequence of 
copy-and-paste antipatterns in new code, and poor training data for those 
of us reading old code.

Anyway, I agree that the churn would be too risky. But it sure would be 
nice if automatic tools were able to perform a program transformation of 
this kind at the source level, being that the compiler will surely do it 
anyway at a lower level.

There's a lot to be said for source code that reflects the compiler's 
understanding of the logic, rather than the human's.
