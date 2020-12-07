Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268DDC0018C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC403238E5
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 18:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgLGS1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgLGS1M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 13:27:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0709DC061749;
        Mon,  7 Dec 2020 10:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=plmldp0jMUbXn4RHhveXniPRGIKOxbNYBpy4Qnxa4iU=; b=ETlnj0o86z0HzG7k/Ffy4FpKV+
        RxD8HXZnMz7KUNPRGl7hUGWACsCjXPKCHTT8HfIIfvZqkOU8rDDB3ZJJ5RV3SFZuLv5drFrL5TcUp
        6NmXC9XhlQjgBHmScaJOHYmXBPwS4BWhjHb7TTbLkx9R9Nir0+TSuabkb/Pz1VUXRtBICsXR3t/LF
        w1IJIcurUZehi4FKxZ20tfFPQHPEWwYQp7nwNo2E2HQ0DU3at6SLTaoDz9hPQR5kNXiEQIZRU0WO9
        +R8MM5ljxy4Qqyq3A3/CPAX4z74PdAYi/Bjxar4zvAo94ARI2YcMNLiK1R9r6F8Utlq0xgLEolvys
        LSajCCqw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmLD1-0000sh-TN; Mon, 07 Dec 2020 18:26:03 +0000
Date:   Mon, 7 Dec 2020 18:26:03 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Greg KH <greg@kroah.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Daejun Park <daejun7.park@samsung.com>,
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
Message-ID: <20201207182603.GA2499@infradead.org>
References: <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p8>
 <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
 <X85sxxgpdtFXiKsg@kroah.com>
 <20201207180655.GA30657@infradead.org>
 <X85zEFduHeUr4YKR@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X85zEFduHeUr4YKR@kroah.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 07, 2020 at 07:23:12PM +0100, Greg KH wrote:
> What "real workload" test can be run on this to help show if it is
> useful or not?  These vendors seem to think it helps for some reason,
> otherwise they wouldn't have added it to their silicon :)
> 
> Should they run fio?  If so, any hints on a config that would be good to
> show any performance increases?

A real actual workload that matters.  Then again that was Martins
request to even justify it.  I don't think the broken addressing that
breaks a whole in the SCSI addressing has absolutely not business being
supported in Linux ever.  The vendors should have thought about the
design before committing transistors to something that fundamentally
does not make sense.
