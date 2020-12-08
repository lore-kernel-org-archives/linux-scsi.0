Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A774C4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03B3B239EB
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 04:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgLHESq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 23:18:46 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49121 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgLHESp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 23:18:45 -0500
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20201208041802epoutp025e17b8def6d1d9102043f0aaa3811cfd~OosSaYUKK2715427154epoutp02S
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 04:18:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20201208041802epoutp025e17b8def6d1d9102043f0aaa3811cfd~OosSaYUKK2715427154epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1607401082;
        bh=bNcO0L7f6HW9trLGLjRuh+5Y5IE2mspFwgJfTwfn9TU=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=ofVhsodbZafGyPcVg8JESrOUpcPdsheMxt+MTmnPYPKcR/1IqhBSRawijnvZuJSx/
         NIhPr9dbu8M4e07GyMl/4kleqqegF/IdTUvqQhzLu2NWfXtwUhnqSCH1ucwDlKPYYU
         5lxfh1EBZipFebpNsNjvn4rFdg2Hkejro8zoVBKI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p3.samsung.com (KnoxPortal) with ESMTP id
        20201208041801epcas3p3d9219a9d0c1a572936a60e062cead918~OosR3HcpY2756127561epcas3p3k;
        Tue,  8 Dec 2020 04:18:01 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4Cqn3F4nxHzMqYkW; Tue,  8 Dec 2020 04:18:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v13 0/3] scsi: ufs: Add Host Performance Booster
 Support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Greg KH <greg@kroah.com>, James Bottomley <jejb@linux.ibm.com>
CC:     Christoph Hellwig <hch@infradead.org>,
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
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <X859wznB1peRtjp0@kroah.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01607401081656.JavaMail.epsvc@epcpadp4>
Date:   Tue, 08 Dec 2020 13:12:31 +0900
X-CMS-MailID: 20201208041231epcms2p225d2c155e42f4d45aa86a4ffbd0b2e6e
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20201103044021epcms2p8f1556853fc23414442b9e958f20781ce
References: <X859wznB1peRtjp0@kroah.com>
        <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
        <X85sxxgpdtFXiKsg@kroah.com> <20201207180655.GA30657@infradead.org>
        <X85zEFduHeUr4YKR@kroah.com> <20201207182603.GA2499@infradead.org>
        <X85116BXkgTtRDKV@kroah.com>
        <fa89e2a960e98b016d4935490fa2905aab0868f7.camel@linux.ibm.com>
        <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p2>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > On Mon, 2020-12-07 at 19:35 +0100, Greg KH wrote:
> > > On Mon, Dec 07, 2020 at 06:26:03PM +0000, Christoph Hellwig wrote:
> > > > On Mon, Dec 07, 2020 at 07:23:12PM +0100, Greg KH wrote:
> > > > > What "real workload" test can be run on this to help show if it
> > > > > is useful or not?  These vendors seem to think it helps for some
> > > > > reason, otherwise they wouldn't have added it to their silicon :)
> > > > > 
> > > > > Should they run fio?  If so, any hints on a config that would be
> > > > > good to show any performance increases?
> > > > 
> > > > A real actual workload that matters.  Then again that was Martins
> > > > request to even justify it.  I don't think the broken addressing
> > > > that breaks a whole in the SCSI addressing has absolutely not
> > > > business being supported in Linux ever.  The vendors should have
> > > > thought about the design before committing transistors to something
> > > > that fundamentally does not make sense.
> > 
> > Actually, that's not the way it works: vendors add commands because
> > standards mandate.  That's why people who want weird commands go and
> > join standard committees.  Unfortunately this means that a lot of the
> > commands the standard mandates end up not being very useful in
> > practice.  For instance in SCSI we really only implement a fraction of
> > the commands in the standard.
> > 
> > In this case, the industry already tried a very similar approach with
> > GEN 1 hybrid drives and it turned into a complete disaster, which is
> > why the mode became optional in shingle drives and much better modes,
> > which didn't have the huge shared state problem, superseded it.  Plus
> > truncating the LBA of a READ 16 to 4 bytes is asking for capacity
> > problems down the line, so even the actual implementation seems to be
> > problematic.
> > 
> > All in all, this looks like a short term fix which will go away when
> > the drive capacity improves and thus all the effort changing the driver
> > will eventually be wasted.
> 
> "short term" in the embedded world means "this device is stuck with this
> chip for the next 8 years", it's not like a storage device you can
> replace, so this might be different than the shingle drive mess.  Also,
> I see many old SoCs still showing up in brand new devices many many
> years after they were first introduced, on-chip storage controllers is
> something we need to support well if we don't want to see huge
> out-of-tree patchsets like UFS traditionally has been lugging around for
> many years.
> 
> > > So "time to boot an android system with this enabled and disabled"
> > > would be a valid workload, right?  I'm guessing that's what the
> > > vendors here actually care about, otherwise there is no real stress-
> > > test on a UFS system that I know of.
> > 
> > Um, does it?  I don't believe even the UFS people have claimed this. 
> > The problem is that HPB creates a shared state between the driver and
> > the device.  That shared state has to be populated, which has to happen
> > at start of day, so it's entirely unclear if this is a win or a slow
> > down for boot.
> 
> Ok, showing that this actually matters is a good rule, Daejun, can you
> provide that if you resubmit this patchset?
> 

Sure, I will find out the case which has performance benefit by HPB.

Thanks,
Daejun
