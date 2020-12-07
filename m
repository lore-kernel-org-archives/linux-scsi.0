Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E04E6C4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:23:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1F05238EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgLGSXK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:23:10 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:43453 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726110AbgLGSXK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 13:23:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id CF1B6580254;
        Mon,  7 Dec 2020 13:22:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 07 Dec 2020 13:22:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=cx4RBmMNs+g2XixyfWd4xJR1Qm6
        CR1kfc/gqSZmjziU=; b=BNdwJrE1NLNAJfRyIEHVyNsghZNKGKEJTz3FTSwZ6SZ
        YcVD1U5vfydO6D3/jVPCUorQrkvIqv4QNNtJdry0R8cmVhh9I38VakjY0blBPOa/
        TvAJuQOT/sW3NHITmjua5WI56Y0G6R9avg9klnWZ5pwZTq2Tg1RG2w5EviHU56V5
        KQBomrBluXMysCrTtlmzQR6Nle+P+yYc3JalSZYJEakG8V4aUGVgtv7Mcbxr/bT/
        tRAheBMtKmUDqZdeNE9p4zPpXOMFHPhXWkSAfKHCcYgv92KKP3cuCrQN7tZMMXup
        QzXWzYO/cf9AbdRJztOpEYtBkvi04vWSXH5RvyfOI1w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cx4RBm
        MNs+g2XixyfWd4xJR1Qm6CR1kfc/gqSZmjziU=; b=PjuVyISfucX4IjZWzYkwYv
        w9leNZ+O69oyw2bLeEqQJeYy1Br1/dvrjehIqeweFboAjMvj4wtnrai3ZjQp6NNv
        5h+Tko893n4QxIiKg8rhWkQB6pfnLJ+aJ21988c1h0xR7q9kaZdeVDyiFjhiJA1E
        YXqJH5aPtj2gK9eob0c57dEmWqXWGbqcqplMo8x0+m40sTWyiifhi4N/25hcH2E/
        gKkLoFkxG6V4rNBjZuqNEaC+pfhoYsmjfO/GD60fauxE+pLDvH98mOHmEe/lh1Nl
        xfCOPJuz5Mopko8O9cxBHizKvqrePfn2Wi7Aa9+TGblxPoSWz26ESYQoqMggo9nQ
        ==
X-ME-Sender: <xms:yXLOX81WTMsXulGsLAtCweNkN4Vt2IaxxOUkJPHT2mhQklKFSOGlcQ>
    <xme:yXLOX3Ck7lhr3kwsKgtKDMvuCwM0HJcGDT0Nnjo4eKaBQVGNz-lpkUHUbkqEikuOl
    bLHSA_hNzRAuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejgedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ynLOXxyZvZ1qwRZMcOwPe65YVc39gYHUEOAO5Q2mY38qxX-Iu2ouBw>
    <xmx:ynLOX9lFxLCMd91SMSRz_7IT2JWVGJseI0u_Wh5CliuJaIqnIG8u2g>
    <xmx:ynLOX-G8XTuMzSC3JW9i2xiu8rmm7EECFp7jLGn32B2Dbn4oRajDUA>
    <xmx:y3LOX_FzmA4mFz2IhD72AIcEgrp6dl0UjA8Nm6yrXwCg29hmFMiecQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 85CB3240057;
        Mon,  7 Dec 2020 13:22:01 -0500 (EST)
Date:   Mon, 7 Dec 2020 19:23:12 +0100
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
Message-ID: <X85zEFduHeUr4YKR@kroah.com>
References: <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p8>
 <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
 <X85sxxgpdtFXiKsg@kroah.com>
 <20201207180655.GA30657@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207180655.GA30657@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 07, 2020 at 06:06:55PM +0000, Christoph Hellwig wrote:
> On Mon, Dec 07, 2020 at 06:56:23PM +0100, Greg KH wrote:
> > On Tue, Nov 03, 2020 at 01:40:21PM +0900, Daejun Park wrote:
> > > Changelog:
> > > 
> > > v12 -> v13
> > > 1. Cleanup codes by comments from Can Guo.
> > > 2. Add HPB related descriptor/flag/attributes in sysfs.
> > > 3. Change base commit from 5.10/scsi-queue to 5.11/scsi-queue.
> > 
> > What ever happened to this patchset?  Did it get merged into a scsi tree
> > for 5.11-rc1, or is there something still pending that needs to be done
> > on it to make it acceptable?
> 
> I think the problem here is not the code, but that the features is
> fundamentally a bad idea, and one that so far has not even shown
> to help real workloads vs the usual benchmarketing.

What "real workload" test can be run on this to help show if it is
useful or not?  These vendors seem to think it helps for some reason,
otherwise they wouldn't have added it to their silicon :)

Should they run fio?  If so, any hints on a config that would be good to
show any performance increases?

thanks,

greg k-h
