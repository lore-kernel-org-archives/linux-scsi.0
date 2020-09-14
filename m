Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE30C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 14:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 543D8206A5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 14:20:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UsnAEsCe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgINOUa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Sep 2020 10:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgINOUP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Sep 2020 10:20:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88160C06174A;
        Mon, 14 Sep 2020 07:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9YKXruRD1GIGI2F0NMKyLvaAHDHfv6h+lQaAljDhid8=; b=UsnAEsCe93yuk5c3QewEY3LcSl
        c3SrZ7WE8/sGqb4cVrjgBnRp2H9lJL4WTsWBv/seDYieRvaPydti1y4IWZi4/rNiMqOGKnocZD+WN
        EIjbTjp/JhdHoCmj4VSf7jIpdJp4cdbgT4y7uoIHy9QGA+JwH67t6kr+aYWJ4B+wikhpGyVaOGVxE
        k1bd226UB4ciP7baY/351tLVFiW+ph+QroxMPEn46IZXniT7La2xuNE/ZMjPJEC+/gLFdz3X5kl23
        epLc4c4zuCyZ3cJQGhb+TIFvvPjonHPMv9X1WzhF2hwAlH9kdK9V1dTpc45jcccQs6pmQft5V9enR
        S+qi2n7Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHpL1-0007y3-Qt; Mon, 14 Sep 2020 14:20:11 +0000
Date:   Mon, 14 Sep 2020 15:20:11 +0100
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Subject: Re: [PATCH v2 1/2] scsi: Fix handling of host-aware ZBC disks
Message-ID: <20200914142011.GA30097@infradead.org>
References: <20200914003448.471624-1-damien.lemoal@wdc.com>
 <20200914003448.471624-2-damien.lemoal@wdc.com>
 <20200914072034.GA25808@infradead.org>
 <CY4PR04MB3751877C568C7F8B3E458960E7230@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR04MB3751877C568C7F8B3E458960E7230@CY4PR04MB3751.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 14, 2020 at 09:03:49AM +0000, Damien Le Moal wrote:
> Yes, that's nice. Will send something along these lines. But since this is a bug
> fix for the current cycle & stable, we probably should keep the patch as is and
> add the improvement on top for 5.10, no ?

I'd much rather also add the trivial helper for 5.9 - otherwise we'll
need to pull current mainline into the for-5.10 tree and create
all kinds of mess.  And just adding the helper and using it for sd
only will have no side effects elsewhere.
