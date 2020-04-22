Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351D1C54FCB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD4A2063A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:34:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r0Ovii1Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgDVGeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgDVGea (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 02:34:30 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65916C03C1A6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 23:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ekg3AXjiHt8ufEKP4c6Qk1e3t6C40gZ5hahrBmalJlQ=; b=r0Ovii1Z2OwYhaRv46u1loL7Gr
        dFBX4+YrE3eejtCGGQ+wj7ywzlj50PJizkkRgO5pOmZY3kX4cMtyHY810FyQtDCFBlOkorCauQ9a6
        WoKJRXTDTJy+5Ii9cYjx0WaNWUFmuueCRMI5qPVCVqeimlWXfA+DXSKwCMxyIZgjHlv9SYoZcOrKy
        80W2/diPVixPDkdEemOhEPqeYnIRgdTG2pvxaWjsPS5ROkpPtmonZ5a55pVHrWmH7fjEr9ZSwut7e
        kk+Ag/rgvfaYPkhEpajDU+pGXOhjfU19hOesZJiidFanTDI0NCqQs3IlnqUTZFJ/ZmVbqUh5ceqt7
        wxdl46sw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jR8xn-0005io-DJ; Wed, 22 Apr 2020 06:34:27 +0000
Date:   Tue, 21 Apr 2020 23:34:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, hch@infradead.org,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [v1 1/5] mpt3sas: Don't change the dma coherent mask after
 allocations
Message-ID: <20200422063427.GB20318@infradead.org>
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1586957125-19460-2-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586957125-19460-2-git-send-email-suganath-prabu.subramani@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 15, 2020 at 09:25:21AM -0400, Suganath Prabu wrote:
> From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> 
> Currently driver is initially setting the dma coherent mask to 32 bit
> and then after allocating the Reply Descriptor Post Queues(RDPQ) pools
> it changes the dma coherent mask to 64/63 according to HBA generation.
> 
> But the DMA layer does not allow changing the DMA coherent mask after
> there are outstanding allocations.
> 
> So, updating the driver to stop changing the dma coherent mask after
> allocations.
> 
> Rename ioc variable "dma_mask" to "is_dma_32bit" and use it to set 32
> bit DMA.
> ---
> v1 Change log:
> 1) Incorporated the review comments from Christoph Hellwig
> 
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

I still don't see why you don't simply take my original patch instead.
