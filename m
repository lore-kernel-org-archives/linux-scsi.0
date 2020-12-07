Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB37FC4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7CE23888
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725918AbgLGSek (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:34:40 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:34535 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725823AbgLGSek (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 13:34:40 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3B3AF580431;
        Mon,  7 Dec 2020 13:33:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 07 Dec 2020 13:33:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=8eMJJZfPnahQnBppOBsMYWZPTB0
        a0mgU5dabPZbXDoA=; b=wDahHh7/pzz4DlVIpxYKY5L3w8rkNTDu615Byin9hAs
        ZoUwOxOcGJjTHD3j2Npi97WdhSQkNs8MZr2C953YEpD0NpIHMkgOAVZ1rHvSLzF8
        fzrGkyz6Ln0nxab8D5rfWvwoXAnkDk3gZC8WrxYTbsfP7qs1qB3n0NtwiAcc3Njl
        yf4SEfhmYN5eP03I6slws9iYl385cJfOXM3FvWx0G/QBfYNGuXJiqtY1IUw0Eiq8
        zVNLe2A6/ACrctoz9uHmuOp9gjhQ7L4C8pZXk8bLg6LXj7HYhjOxm/wzDLRtGnSa
        Fgotv/+JV5sEqvLIE7LAUlGM2at1JpbqFc9vPAJVpJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=8eMJJZ
        fPnahQnBppOBsMYWZPTB0a0mgU5dabPZbXDoA=; b=UXgPmrTSP8STkKuQeeB/tE
        r+Of+9nWrJEWtMV8SF/zmNLR19AdN2KDxqWP+4Yz7DPO0+/dfZrYUExuLKrSgMc1
        WCNGI/X68pw6VEfUMhITZ6VXWgR+2hjGDocAYaw7qsKlnMrdZApdHnjj2gYv2sSb
        QMG79SupBOcO9ScoDXcxBbdbQKATv1Zv6ZUilIy5ofyNSTvhhGKWjFbXpC42YuX3
        WbeRnSNhLOn3tmGm2fmtxMzsHiK5CaxrzHszcHeJ0gqziBgmuvzafv0dcous1R1R
        Jq/mvn60sDuDRUmr/Ubd1p2CkiwpTqFJkbvi0nqf4K7mREtZhWapCBRjMyuJ02ZA
        ==
X-ME-Sender: <xms:kHXOX_SjQSlyojLFucC9doyMcLh-mt1RVKmoGzUWO8yN8pxBkPxEWQ>
    <xme:kHXOXwwjJo-BS0f87wZW9UeZRauZ1GbH-tlR8pb5SBC3AQTrLZqtJEO0ciCCxclAg
    F7NJaDPR2Yu3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejgedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kHXOX00MKuW0UKjc-lT0yY1tgZQZy-REdCw9fla1JNudCJaDWHHxeA>
    <xmx:kHXOX_DW07uC1nv95z1JGSlV8QG5MzusadhENtFZkd50dqYg3wmEuA>
    <xmx:kHXOX4jo0c34rQOH91Qq8MBN4sA6TjwrjMfrHST9-iIkU8AxotiprA>
    <xmx:knXOXx3qXgvA4TIjZd69RVfVbYaZ8yvtn2J-bh1pxEyb8DAS7Jkn9Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C496108005B;
        Mon,  7 Dec 2020 13:33:52 -0500 (EST)
Date:   Mon, 7 Dec 2020 19:35:03 +0100
From:   Greg KH <greg@kroah.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "gregkh@google.com" <gregkh@google.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v13 0/3] scsi: ufs: Add Host Performance Booster Support
Message-ID: <X85116BXkgTtRDKV@kroah.com>
References: <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p8>
 <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
 <X85sxxgpdtFXiKsg@kroah.com>
 <20201207180655.GA30657@infradead.org>
 <X85zEFduHeUr4YKR@kroah.com>
 <20201207182603.GA2499@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207182603.GA2499@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 07, 2020 at 06:26:03PM +0000, Christoph Hellwig wrote:
> On Mon, Dec 07, 2020 at 07:23:12PM +0100, Greg KH wrote:
> > What "real workload" test can be run on this to help show if it is
> > useful or not?  These vendors seem to think it helps for some reason,
> > otherwise they wouldn't have added it to their silicon :)
> > 
> > Should they run fio?  If so, any hints on a config that would be good to
> > show any performance increases?
> 
> A real actual workload that matters.  Then again that was Martins
> request to even justify it.  I don't think the broken addressing that
> breaks a whole in the SCSI addressing has absolutely not business being
> supported in Linux ever.  The vendors should have thought about the
> design before committing transistors to something that fundamentally
> does not make sense.

So "time to boot an android system with this enabled and disabled" would
be a valid workload, right?  I'm guessing that's what the vendors here
actually care about, otherwise there is no real stress-test on a UFS
system that I know of.

thanks,

greg k-h
