Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48835C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 07:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1239D60EFE
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 07:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhJKHbF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 03:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhJKHbE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 03:31:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494F2C061570;
        Mon, 11 Oct 2021 00:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mGfht1UBsrZ6UvqcMv5Eu2bpjh1jOOi8jBo+//3ydJs=; b=K7bn7LTL9gKXJSTNyy3bQ6DhsQ
        ywyR+DXdblSEowwb0Hj2rJ0gBh/okn2c1ODysK6uwJQzOh+ixJZyiZSCnaPjmE40/kRwHkA2dMraC
        q22Zewe7J5HaB89XenhzCexsVv0aniVyT49UUQ0bpBGF6pitSRU6KEIuYP30x/Eo2GUfpSitLQ6oD
        h5e3xinKiCJrohTG6MqxUHrqWewpfcV4R0j2/qT+yC/ncsLZ2t5wv6otljwfGSJBQTN3aQGkcQQQU
        QxppPZNIySwGfHHgD1qUlSG0ucEGJ/XYj6gSyULl9/SNFtsILF5ynXNnBx0fokdaCpAcBBoGf1FhA
        f8xtqLCQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mZphE-005KVJ-53; Mon, 11 Oct 2021 07:26:26 +0000
Date:   Mon, 11 Oct 2021 08:26:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Use dma_alloc_coherent() instead of
 get_zeroed_page/dma_map_single()
Message-ID: <YWPnDHvEVHS0JqUl@infradead.org>
References: <20211010160055.488-1-caihuoqing@baidu.com>
 <YWPc1GxFiOloHveI@infradead.org>
 <20211011070405.GA173@LAPTOP-UKSR4ENP.internal.baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011070405.GA173@LAPTOP-UKSR4ENP.internal.baidu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 11, 2021 at 03:04:05PM +0800, Cai Huoqing wrote:
> dma_sync_ API is not called, I think the hardware may keep cache coherent
> directly or is a no cache system. No need to make perfermance compare.

On a device that is not attached in a cache coherent way (and that is
the only one that matters here), dma_alloc_coherent will force every
access to the memory to be uncached, while using dma_sync will only
do a cache maintainance operation for each dma submission and
completion.  So yes, it matters.  And Bart who has actually looked into
the number has seen the sync case to be faster consistently for a SCSI
ULP.

Note that you can simplify and improve this case by using
dma_alloc_noncoherent instead of a kernel allocator + dma_map_*.
