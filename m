Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41EB9C0018C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA40238E7
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgLGSfr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:35:47 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:35219 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725774AbgLGSfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 13:35:47 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id D349E580435;
        Mon,  7 Dec 2020 13:35:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 07 Dec 2020 13:35:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=MMoL+7Vo89gfdNW52sHVKG4ci93
        SoqztpidHbQF37jU=; b=xBEwNUUB7f5RPCLV2gNG9xYqBKptTLkBbyCXG3MFhWE
        k09aDaujn5/HwI5SlhVlnaiMawBxFRSmzKXdd6j5OQQJj2lW7kLRi7737Hz8KjZG
        2IEZGeB71xcd+qWD9kqw3ykAuyjFcr/l+ZNdx+OOxF7VPzEpVL8m892wAivtrZLr
        m1GLz/vJZ0ff50m0BqcuK2nCy9yXiP1GBOnTO386riF+om+HZqQPcKhBhXf5KPF6
        FgOQ60y2q3OUW49uhZ+Q9QehOKjRz9XenjkHaSUtnPpqydGntGsaqwHiPlxTQQ53
        KJGobbAM+DOG7BPkIjpTtpfyDLS1IxT/mV4fRnIuIjw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=MMoL+7
        Vo89gfdNW52sHVKG4ci93SoqztpidHbQF37jU=; b=LYDNo1/zKgdOfcI//+3YTC
        VzfxaCpMbcR69TNC8Jt0ZgSjfyi7iGTA14tr9J0CEfVJCMh1HhQCEHFJdomlWGUb
        Y6KjVGQ5g/yTuQXGd9pSAvsZEfv1gaqYh5gv0KtqlZTQY9PIDZ3KPn1Q0WwFYeGA
        VFfTYtnv4wML4Mue3X+vPj7wEVZTD/uyU4U37NO4Pm3L45xTQw7j8weLaId9wAJN
        Ha16IwLHZkquD14RW6jUbtQzz5lc9HMlGLwZ4RGz/1cFe6ebCDDRbsKB5w6KwEvk
        Ibys2B+QIU276cH+yBNf7F2AiELPVt5baYxlZKaVA6L033RhWaj/wyWMGj26cccA
        ==
X-ME-Sender: <xms:0nXOX1Zzp4yyWqRVdWkKpYsXpJOmHYunQ7dPDyu-PUM0r6PH2mgnXg>
    <xme:0nXOX8Z7KYTiimyyZzuI-bgk-W1yJQ_se10_92WyXbk9JPdSeUg6zNlg25gIm9QPt
    4hHPRDxBBnEIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejgedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:03XOX3_vxVBYOT_5ByKTz-Crc8Q4ERZgJPrGEfy2oUQtEBdtptx9Zg>
    <xmx:03XOXzp_amkLugxaZ8sWaWKD87cEwTtPOo8aLrursr18by5JQRjN7Q>
    <xmx:03XOXwoMYmIW12S_bRlMnNO4888aXnbS1Tjkf2MkYBj3sfPNuD-1Gg>
    <xmx:1HXOXzcgkHT0yG_t5VUnpVT7ULG2G_z3SwHVElvVgbADZv7Th82jCw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89F1D24005B;
        Mon,  7 Dec 2020 13:34:58 -0500 (EST)
Date:   Mon, 7 Dec 2020 19:36:09 +0100
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
Message-ID: <X852GfT/Ar62C/Iz@kroah.com>
References: <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p8>
 <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
 <X85sxxgpdtFXiKsg@kroah.com>
 <20201207180655.GA30657@infradead.org>
 <X85zEFduHeUr4YKR@kroah.com>
 <20201207182603.GA2499@infradead.org>
 <X85116BXkgTtRDKV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X85116BXkgTtRDKV@kroah.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 07, 2020 at 07:35:03PM +0100, Greg KH wrote:
> On Mon, Dec 07, 2020 at 06:26:03PM +0000, Christoph Hellwig wrote:
> > On Mon, Dec 07, 2020 at 07:23:12PM +0100, Greg KH wrote:
> > > What "real workload" test can be run on this to help show if it is
> > > useful or not?  These vendors seem to think it helps for some reason,
> > > otherwise they wouldn't have added it to their silicon :)
> > > 
> > > Should they run fio?  If so, any hints on a config that would be good to
> > > show any performance increases?
> > 
> > A real actual workload that matters.  Then again that was Martins
> > request to even justify it.  I don't think the broken addressing that
> > breaks a whole in the SCSI addressing has absolutely not business being
> > supported in Linux ever.  The vendors should have thought about the
> > design before committing transistors to something that fundamentally
> > does not make sense.
> 
> So "time to boot an android system with this enabled and disabled" would
> be a valid workload, right?  I'm guessing that's what the vendors here
> actually care about, otherwise there is no real stress-test on a UFS
> system that I know of.

Oh, and "supporting stupid hardware specs" is what we do here all the
time, you know that :)

If someone is foolish enough to build it, we usually have to support the
thing, especially if someone else here is willing to do that.  I don't
see where the addressing is "broken", which patch causes that to happen?

thanks,

greg k-h
