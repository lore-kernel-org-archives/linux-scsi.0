Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D57C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 06:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B8B9207BB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 06:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j/H04Sbn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgGVGld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 02:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbgGVGld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jul 2020 02:41:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6833DC061794;
        Tue, 21 Jul 2020 23:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QBlT0rHy766TwjM3WcKRo2rpVMbBP9MM+KvXAGU8B1U=; b=j/H04SbnJSgNEzPiUMiUaBgDbK
        0qYuXCf5XchuQ3KQWNP+I2RRJdOTDs/ci0ecLLjA+FOHXIlT/TWuC0YcdnmbjzYbG2ggKEKYFvYfC
        suWD0aVodyFljngeBigiglu4KK5XeN4klkCbfTE/lQsFHhsFQhFoUOkc56R6QHyCZ1WEd4VDA+ZWl
        yf8zweSeVZzdizInaTNxn0gXnpWrlbRi8f9VWvYhF2JakKSqY8jDhkQy07JRmRfMMYi+AHVWC4Jbp
        l9Mo0O+VkhRfTm9vd1pAI5XzkuoRtafEHmbLZXXiASAEXrxN9SYWKtNgHfsKzVs0y2BWyctFLrHnT
        ZjTIpL8Q==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jy8RE-0005hr-Dv; Wed, 22 Jul 2020 06:41:12 +0000
Date:   Wed, 22 Jul 2020 07:41:12 +0100
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
Subject: Re: [PATCH v6 2/5] scsi: ufs: Add UFS-feature layer
Message-ID: <20200722064112.GB21117@infradead.org>
References: <231786897.01594636801601.JavaMail.epsvc@epcpadp1>
 <963815509.21594636682161.JavaMail.epsvc@epcpadp2>
 <CGME20200713103423epcms2p8442ee7cc22395e4a4cedf224f95c45e8@epcms2p4>
 <231786897.01594637401708.JavaMail.epsvc@epcpadp1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <231786897.01594637401708.JavaMail.epsvc@epcpadp1>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 13, 2020 at 07:40:40PM +0900, Daejun Park wrote:
> This patch is adding UFS feature layer to UFS core driver.
> 
> UFS Driver data structure (struct ufs_hba)

Independent of the problems with the concept of HPB, this patch is
just really bad software architecture.  Don't just add random
indirection layers that do represent an actual real abstraction.
As-is it is just another crap hook layer without a proper absteaction.

Nacked^2-by: Christoph Hellwig <hch@lst.de>
