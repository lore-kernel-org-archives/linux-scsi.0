Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB02C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 06:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A01F60C41
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Oct 2021 06:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhJKGqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Oct 2021 02:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbhJKGqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Oct 2021 02:46:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35A0C061570;
        Sun, 10 Oct 2021 23:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=itmTim8I8t0MywMgjw5ukf6bQm80r6xY66lzHRGBkrU=; b=JaADK9WMrPpNoBBHBl9idRMMuD
        BYqj3G7RrDho83bp87br+1sUORGJ+B66XPhavXtKJhRBH53kPDL10sxYORJ510EH72BCXUB3MfrrP
        v6PWIYIV5lMVSharrgDeJrRKyDrl8BAXI2aSz9dCmIhjMP5b/OrleQ3qT16i4YS+gCZ35wX7iJeKD
        x+MO9qlQF60UZOViG0m1Bq5lbjoJH1LGWIgMSHDhr6TJCUFfzqDQOzb4/2/0f90jBkHnZDNugIPc0
        zOdxKyyxHwOsX1AH2Q4iHill4U++SnwwQLytWAX2mvAnF2zlxb62+zVUREYvXF7GEMcuVSsB9kgHW
        fn8Px/YQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mZp12-005Iw5-IR; Mon, 11 Oct 2021 06:42:47 +0000
Date:   Mon, 11 Oct 2021 07:42:28 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     Michael Cyr <mikecyr@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Use dma_alloc_coherent() instead of
 get_zeroed_page/dma_map_single()
Message-ID: <YWPc1GxFiOloHveI@infradead.org>
References: <20211010160055.488-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010160055.488-1-caihuoqing@baidu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 11, 2021 at 12:00:53AM +0800, Cai Huoqing wrote:
> Replacing get_zeroed_page/free_page/dma_map_single/dma_unmap_single()
> with dma_alloc_coherent/dma_free_coherent() helps to reduce
> code size, and simplify the code, and coherent DMA will not
> clear the cache every time.

This explanation does not make any sense whatsoever.  Please explain
why it would an show numbers.
