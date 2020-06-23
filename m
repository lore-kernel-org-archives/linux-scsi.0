Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCA4C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 20:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF6DB20738
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 20:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=hmh.eng.br header.i=@hmh.eng.br header.b="tIFfEnSH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Wbzgfng6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393051AbgFWU50 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 16:57:26 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:37163 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390565AbgFWUmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 16:42:42 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id DBA919C0;
        Tue, 23 Jun 2020 16:42:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Tue, 23 Jun 2020 16:42:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hmh.eng.br; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=vrxA/FSkZCHAfFyeVNWgnBioSC9
        BNFdUmNULPJc7l+s=; b=tIFfEnSH0ux8hs3mBttZhNV/H7Tp3TmuoALl+TSfHMn
        llrOlKQVwfQAZqCEfEMTsu52DnOFzpAxvM4JbBVl2cHNEEkjBX81uTdVPwH5Z5sc
        kY44YfkgsKvPV8ao+5qPKZPdK0JfNA7ohBc8P11SlojcAmQ/m+L1GRGcc0u+ZtWr
        lSwzpRgDzpWxoq83DaOi4QvtU4B90QNnplKJLyTqj83WjVD6eBYfoLSh5FP8jycQ
        MK8M7Efkttb5tYTCkivm+ok+Q+bJNMKs8acZUj/iALcxtzl00wMpdCECL7eFjMk4
        JKKUkgU76lmUWpap4+TNQ8JwgOn8ecBtyRjA0PFHoJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vrxA/F
        SkZCHAfFyeVNWgnBioSC9BNFdUmNULPJc7l+s=; b=Wbzgfng60nrVvHeYrxCYLB
        OTPbQdXCMlK0K6IkgencEN1GUguzmGHfqf5ibhalM7lgubN1DPcXg0GfrPqGqJEI
        fFPAsjbMv9Yb3SjARNvecNPRahL0zMobbGrhvYxp2bSJBZAJxbPmJ1X5hYnyn2cU
        89VWYwP4MhRk0wIMlDrTAObVg9XUkIH/IWF9/RAlHNFJPoWc3hGFBjJvYTcnnPsq
        oaGzMg6mLRLot4y8Q98lhqiHRANivbUNDtHms0fOQZRHV/xPZLe9Z7N13Yriskco
        t/JBFR2g8paGgmlb4Qn43EiirDx4khBAP7fR51kEZrZfrPWzEuMLWIzzheVDfuzw
        ==
X-ME-Sender: <xms:P2nyXpZfhuVA-rtlpQmjeIKkkUWk0vaPF-p5CpZ1MnnD_Cg_2KtYGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttddttddtredvnecuhfhrohhmpefjvghn
    rhhiqhhuvgcuuggvucfoohhrrggvshcujfholhhstghhuhhhuceohhhmhheshhhmhhdrvg
    hnghdrsghrqeenucggtffrrghtthgvrhhnpedtfeefvdffkeevjeeuffdvvdevveetjefg
    vdfhffeuteefvdevgeeuueejtddutdenucffohhmrghinheplhhkmhhlrdhorhhgnecukf
    hppedujeejrdduleegrdejrdefvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehhmhhhsehhmhhhrdgvnhhgrdgsrh
X-ME-Proxy: <xmx:P2nyXgaTVe7lgaOYLMJ5TCvw3rOKBQXfgT_Hs1NOv8zR06bZS8tgQg>
    <xmx:P2nyXr9VbxH5uIew4iuHlNZ3K3D4dOI1zE8sIkNTZpJOHvmDeZb2Zg>
    <xmx:P2nyXnqIaGal6PHvEwtnSVqnBOXQKIt4q1PhoMtuMoPJFeUg3EsQ_w>
    <xmx:QGnyXvWPipUrpgRFO-LUEZHJt8qMJBIAX21kOM4Sp71v_uRgaOgX_g>
Received: from khazad-dum.debian.net (unknown [177.194.7.32])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C812328005A;
        Tue, 23 Jun 2020 16:42:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by localhost.khazad-dum.debian.net (Postfix) with ESMTP id CE85F340321E;
        Tue, 23 Jun 2020 17:42:36 -0300 (-03)
X-Virus-Scanned: Debian amavisd-new at khazad-dum.debian.net
Received: from khazad-dum.debian.net ([127.0.0.1])
        by localhost (khazad-dum2.khazad-dum.debian.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 0ml-J_XkXns1; Tue, 23 Jun 2020 17:42:34 -0300 (-03)
Received: by khazad-dum.debian.net (Postfix, from userid 1000)
        id 4B208340321D; Tue, 23 Jun 2020 17:42:34 -0300 (-03)
Date:   Tue, 23 Jun 2020 17:42:34 -0300
From:   Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Message-ID: <20200623204234.GA16156@khazad-dum.debian.net>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
X-GPG-Fingerprint1: 4096R/0x0BD9E81139CB4807: C467 A717 507B BAFE D3C1  6092
 0BD9 E811 39CB 4807
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Jun 2020, Damien Le Moal wrote:
> Are you experiencing data loss or corruption ? If yes, since a clean reboot or
> shutdown issues a synchronize cache to all devices, a corruption would mean that
> your SSD is probably not correctly processing flush cache commands.

Cache flushes do not matter that much when SSDs and sudden power cuts
are involved.  Power cuts at the wrong time harm the FLASH itself, it is
not about still-in-flight data.

Keep in mind that SSDs do a _lot_ of background writing, and power cuts
during a FLASH write or erase can cause from weakened cells, to much
larger damage.  It is possible to harden the chip or the design against
this, but it is *expensive*.  And even if warded off by hardening and no
FLASH damage happens, an erase/program cycle must be done on the whole
erase block to clean up the incomplete program cycle.

Due to this background activity, an unexpected power cut could damage
data *anywhere* in an SSD: it could hit some filesystem area that was
being scrubbed in background by the SSD, or internal SSD metadata.

So, you want that SSD to know it must be quiescent-for-poweroff for
*real* before you allow the system to do anything that could power it
off.

And, as I have found out the hard way years ago, you also want to give
the SSD enough *extra* time to actually quiesce, even if it claims to be
already prepared for poweroff [1].

When you do not follow these rules, well, excellent datacenter-class
SSDs have super-capacitor power banks that actually work.  Most SSDs do
not, although they hopefully came a long way and hopefully modern SSDs
are not as easily to brick as they were reported to be three or four
years ago.


[1] I have long lost the will and energy to pursue this, so *this* is a
throw-away anecdote for anyone that cares: I reported here a few years
ago that many models of *SATA* based SSDs from Crucial/Micron, Samsung
and Intel were complaining (through their SMART attributes) that Linux
was causing unsafe shutdowns.

https://lkml.org/lkml/2017/4/10/1181

TL;DR: wait one *extra* second after the SSD acknowleged the STOP
command as complete before you trust the SSD device is safe to be
powered down (i.e. before reboot, suspend, poweroff/shutdown, and device
removal/detach).  This worked around the issue for every vendor and
model of SSD we tested.

-- 
  Henrique Holschuh
