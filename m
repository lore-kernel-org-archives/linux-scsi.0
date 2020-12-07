Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92163C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 19:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49FE02342C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 19:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgLGTIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 14:08:50 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:60393 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgLGTIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 14:08:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 2D168580420;
        Mon,  7 Dec 2020 14:07:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 07 Dec 2020 14:07:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=slDo1AYMceMUDPx2oG/rgi009ZU
        nahXrkGvRRX4QoI0=; b=Y4fNC3vE/PdXxdQkz/Z4nrTznAXdWo3cp4zporo9eGW
        7G8wI43NWQu0B/mlE1d5Vl0s006j6MrpycthYqtz/N501LvzD9fjn//VntV6DFvA
        kOXm6dmiHNp/Ip/ejQl17SwlnHP+ZzeEQQLr4JC8ok6oO/Z639w+2V75XNQdIa2D
        8vt0w76FvnZi6J9HQ5qA03P9CSTLrKpyklzLAcnkc/O8biu5rftPGPV6Da8g/nMJ
        9EMKTFZH8dl4f5qQOnJmjPgNse5BMvE40KWjrMkh2xa/9lUhdRfr8p4rowxMVfGd
        Ij+soshDFadQNKGNR90Fqa/dvqw0M3qhCmILr1UqsOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=slDo1A
        YMceMUDPx2oG/rgi009ZUnahXrkGvRRX4QoI0=; b=VwxNdjyYSLTFiHUPk2yhC+
        vMvqLCYZID8ELnJwjw5u97qNGKaZ+yw4ljHoUMyPk1uQEjVijPum3RIdtGihUVz/
        nF/kiCt33md5HXCTjqtp1TVxGvaCovqSldwIwQ4r/1UazpyWbFSJ8u8Bwb1PW+DT
        4D3+vKiwC3cOxuZ1P9P0GmGGMp3lBTLsv1d376Qw2Y30Ta2oQNSGh/+aJExXiNuy
        rofM90tF21JAqudZnxlpRnh/vsqgvdaLJwcoWN0xUt96BqTdHV7sWiu3kIA7prJP
        rF0oZWM4r95SpHLk0HXZkAGGrAPLYc2JXe4KwWt+jW1VXgGxu5ASBjy638Dm04rg
        ==
X-ME-Sender: <xms:fH3OX98aKD8cXjuO48KkjvoU1-LVtxh7MLfgB7OYsC3AiMJ5-mQrKw>
    <xme:fH3OXxvnwVuuMKkpuRI5Y5X6IwG0EcwMnjIVdzsrhDkpMBM4t_t_Mkft3Mm74LyMa
    6HYjH66gKEDDw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejgedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fH3OX7AAdrU8CvgsS6zafPGvt6xnq-7GCn8KmAhCctSTmpaKnJkPwA>
    <xmx:fH3OXxfX_87UhWAA240rinhU0YvqO6lXslDctJm-jJfJ4pFvRJZESA>
    <xmx:fH3OXyMDpXVf7jZBvax4RU7WM5pPugUSjr3zhIrwKpv5LNkFl3T47g>
    <xmx:f33OX7wWa09iZphyZDHar1q4pCX-VI8psrZAm8h6x45E993s-Gj-Xg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 79DB5108005B;
        Mon,  7 Dec 2020 14:07:40 -0500 (EST)
Date:   Mon, 7 Dec 2020 20:08:51 +0100
From:   Greg KH <greg@kroah.com>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
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
Message-ID: <X859wznB1peRtjp0@kroah.com>
References: <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p8>
 <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
 <X85sxxgpdtFXiKsg@kroah.com>
 <20201207180655.GA30657@infradead.org>
 <X85zEFduHeUr4YKR@kroah.com>
 <20201207182603.GA2499@infradead.org>
 <X85116BXkgTtRDKV@kroah.com>
 <fa89e2a960e98b016d4935490fa2905aab0868f7.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa89e2a960e98b016d4935490fa2905aab0868f7.camel@linux.ibm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 07, 2020 at 10:54:58AM -0800, James Bottomley wrote:
> On Mon, 2020-12-07 at 19:35 +0100, Greg KH wrote:
> > On Mon, Dec 07, 2020 at 06:26:03PM +0000, Christoph Hellwig wrote:
> > > On Mon, Dec 07, 2020 at 07:23:12PM +0100, Greg KH wrote:
> > > > What "real workload" test can be run on this to help show if it
> > > > is useful or not?  These vendors seem to think it helps for some
> > > > reason, otherwise they wouldn't have added it to their silicon :)
> > > > 
> > > > Should they run fio?  If so, any hints on a config that would be
> > > > good to show any performance increases?
> > > 
> > > A real actual workload that matters.  Then again that was Martins
> > > request to even justify it.  I don't think the broken addressing
> > > that breaks a whole in the SCSI addressing has absolutely not
> > > business being supported in Linux ever.  The vendors should have
> > > thought about the design before committing transistors to something
> > > that fundamentally does not make sense.
> 
> Actually, that's not the way it works: vendors add commands because
> standards mandate.  That's why people who want weird commands go and
> join standard committees.  Unfortunately this means that a lot of the
> commands the standard mandates end up not being very useful in
> practice.  For instance in SCSI we really only implement a fraction of
> the commands in the standard.
> 
> In this case, the industry already tried a very similar approach with
> GEN 1 hybrid drives and it turned into a complete disaster, which is
> why the mode became optional in shingle drives and much better modes,
> which didn't have the huge shared state problem, superseded it.  Plus
> truncating the LBA of a READ 16 to 4 bytes is asking for capacity
> problems down the line, so even the actual implementation seems to be
> problematic.
> 
> All in all, this looks like a short term fix which will go away when
> the drive capacity improves and thus all the effort changing the driver
> will eventually be wasted.

"short term" in the embedded world means "this device is stuck with this
chip for the next 8 years", it's not like a storage device you can
replace, so this might be different than the shingle drive mess.  Also,
I see many old SoCs still showing up in brand new devices many many
years after they were first introduced, on-chip storage controllers is
something we need to support well if we don't want to see huge
out-of-tree patchsets like UFS traditionally has been lugging around for
many years.

> > So "time to boot an android system with this enabled and disabled"
> > would be a valid workload, right?  I'm guessing that's what the
> > vendors here actually care about, otherwise there is no real stress-
> > test on a UFS system that I know of.
> 
> Um, does it?  I don't believe even the UFS people have claimed this. 
> The problem is that HPB creates a shared state between the driver and
> the device.  That shared state has to be populated, which has to happen
> at start of day, so it's entirely unclear if this is a win or a slow
> down for boot.

Ok, showing that this actually matters is a good rule, Daejun, can you
provide that if you resubmit this patchset?

thanks,

greg k-h
