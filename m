Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65DFC433E4
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 06:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87E0220787
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 06:40:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fzx1/hUg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgGVGkN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 02:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgGVGkM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 02:40:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8957AC061794;
        Tue, 21 Jul 2020 23:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=m06dMY8C1+OctIPfkwKshJveyuCGYqiBQURJOBQ19Sc=; b=Fzx1/hUg6z8v9yIJyc6Ha4szsO
        RVzRhT5F9kRm+he2KvuSJXT1BiWqrRfmkPUj2st988DYjND72lHB8iWcTCO5zntyo4FFm7Kq1Lqjd
        O4DmstLJKCycANbVFQGkVCkFVdASb8IHm/H5QVyFyksv0vSAcCp3xiFD7NRypuYsN34jJDECsRaQ3
        eCcffOYriv0uWHYtomNlEOvR+J4HZ4sGLVBRPx8+9xskL1ZGmjCnPCbLBxGeLqlBnr9q1Q3f5+Gnh
        8u/IF7yT34TR6kFa45zTD4G62s1OGPPGZMg/1FwN6LUS0cZKLQIor3Nt3Igoompc9VrY7vUtZKduZ
        PV1+C9oA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jy8Ph-0005Zt-L9; Wed, 22 Jul 2020 06:39:37 +0000
Date:   Wed, 22 Jul 2020 07:39:37 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v6 0/5] scsi: ufs: Add Host Performance Booster Support
Message-ID: <20200722063937.GA21117@infradead.org>
References: <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p8>
 <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As this monster seesm to come back again and again let me re-iterate
my statement:

I do not think Linux should support a broken standards extensions that
creates a huge share state between the Linux initator and the target
device like this with all its associated problems.

Nacked-by: Christoph Hellwig <hch@lst.de>
