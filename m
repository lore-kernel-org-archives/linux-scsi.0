Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDACC35E04
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 18:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 995572084E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 18:42:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="igLVcrUq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731596AbgBYSmD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:42:03 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34424 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728753AbgBYSmD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Feb 2020 13:42:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Qt0pXDSlMih3ZHC2SPc/nIat1l2Zp+FUXvtXs/TfGwg=; b=igLVcrUqDeIyjuYl2idruteUWa
        B+QI5JXqHoift3I0+yFbQQWquRfA0xZUvRHbsgnLmKNFEBQgx3bkvP0GEXPs9S38uo7+ZLqsWwW9d
        0YN2NrlMmLWeY2Gw4dsNrVNkRm/iyYz8pBpz8A+LlnuBjO6HldaNHy6rUDaDf/g9phnXQpJvWhyzv
        QQGrmFYBxcW5WbRk3oNuibtmdC2Ar0vHIlCazO5G0hh+VhrVW68nWY4pl7AeVDSR2pd59ioLG7A0O
        k4bt5WmBzZkVUcyXOJE+PH6xu9bVyC6ybu7x+f2ediw+BmuYY0pXfo9O1A3aQtvVFgsshMSP7naSq
        Qx1vrSDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6f9f-0004q0-0T; Tue, 25 Feb 2020 18:42:03 +0000
Date:   Tue, 25 Feb 2020 10:42:02 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     suganath-prabu.subramani@broadcom.com
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        kashyap.desai@broadcom.com, sathya.prakash@broadcom.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH 4/5] mpt3sas: Handle RDPQ DMA allocation in same 4g region
Message-ID: <20200225184202.GC6261@infradead.org>
References: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1581416293-41610-5-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581416293-41610-5-git-send-email-suganath-prabu.subramani@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 11, 2020 at 05:18:12AM -0500, suganath-prabu.subramani@broadcom.com wrote:
> From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> 
> For INVADER_SERIES each set of 8 reply queues (0 - 7, 8 - 15,..)and
> VENTURA_SERIES each set of 16 reply queues (0 - 15, 16 - 31,..)should
> be within 4 GB boundary.Driver uses limitation of VENTURA_SERIES
> to manage INVADER_SERIES as well. So here driver is allocating the DMA
> able memory for RDPQ's accordingly.
> 
> For RDPQ buffers, driver creates two separate pci pool.
> "reply_post_free_dma_pool" and "reply_post_free_dma_pool_align"
> First driver tries allocating memory from the pool
> "reply_post_free_dma_pool", if the requested allocation are
> within same 4gb region then proceeds for next allocations.
> If not, allocates from reply_post_free_dma_pool_align which is
> size aligned and if success, it will always meet same 4gb region
> requirement

I don't fully understand the changelog here, and how having two
dma pools including one aligned is all that good.

Why not do a single dma_alloc_coherent and then subdvide it given
that all the allocations from the DMA pool seem to happen at HBA
initialization time anyway, invalidating the need for the dynamic
nature of the dma pools.
