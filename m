Return-Path: <SRS0=dnTk=4N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332CDC35E04
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 18:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F22332084E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Feb 2020 18:37:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y7aKTLYo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbgBYShG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:37:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731403AbgBYShG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Feb 2020 13:37:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JGbX06YcL04ZfjZ9m/R3pqX+f7+H6CYBOL2is2ajaRU=; b=Y7aKTLYo0buptR36jZ870KTwiP
        /lXGRPdxLPL7hpbxiKllPnjZ6pTPQazpZ81EjzK7fSI453oDBKpQN8Nju9rtplpkcq0AG+aD8TutN
        rZqAhoN1MPv+Z60k+THpAJU5BvvAtjU3UeaS0pBhmWoc4QDgA6mRFBXfiwpOwQ7pHT6taYfdMgHWq
        UzRDZN19ni06fYJ7KyqXyJDpyESqeILYf32+cK/kIVXk24SqjhZHoKco1Am8LvuSYJNEm081VRMaS
        QVu3gY2zmso3oSxBoDa3HS4AW1dn5VyTI3WqMK3uLydTC9N/D4AnrhQ0BtOHrkloE4C2BqyrnTyG+
        mJbPA5xw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6f4s-0003LR-30; Tue, 25 Feb 2020 18:37:06 +0000
Date:   Tue, 25 Feb 2020 10:37:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     suganath-prabu.subramani@broadcom.com
Cc:     linux-scsi@vger.kernel.org, sreekanth.reddy@broadcom.com,
        kashyap.desai@broadcom.com, sathya.prakash@broadcom.com,
        martin.petersen@oracle.com
Subject: Re: [PATCH 1/5] mpt3sas: Don't change the dma coherent mask after
 allocations
Message-ID: <20200225183706.GB6261@infradead.org>
References: <1581416293-41610-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1581416293-41610-2-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581416293-41610-2-git-send-email-suganath-prabu.subramani@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 11, 2020 at 05:18:09AM -0500, suganath-prabu.subramani@broadcom.com wrote:
> From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> 
> During driver load ioc->dma_mask is set to 0. Since this
> flag is not set, in _base_config_dma_addressing() driver
> always sets 32 bit DMA and later after allocating memory
> for RDPQ's the dma mask is set to 64/63 bit from
> _base_change_consistent_dma_mask.

Please use up 74 chars for your commit messages.

> +	u64 consistent_dma_mask = DMA_BIT_MASK(64);
>  	if (ioc->is_mcpu_endpoint)

Please keep an empty line after variable declarations.

> +	if (sizeof(dma_addr_t) > 4) {
> +		const u64 required_mask = dma_get_required_mask(&pdev->dev);
> +		if ((required_mask > DMA_BIT_MASK(32)) &&

No need for the braces.

> +		    !pci_set_dma_mask(pdev, consistent_dma_mask) &&
> +		    !pci_set_consistent_dma_mask(pdev,

Please do not use the pci_* functions in new code, but use the
generic DMA ones.

> +		    consistent_dma_mask)) {
> +			ioc->base_add_sg_single = &_base_add_sg_single_64;
> +			ioc->sge_size = sizeof(Mpi2SGESimple64_t);
> +			goto out;
> +		}
> +	}
> +try_32bit:
> +	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
> +	    && !pci_set_consistent_dma_mask(pdev,

Wrong coding style.  Also there is no need to fall back to a smaller
mask in modern kernels ever.

In other words: please drop this patch and use the one I submitted
weeks ago, as it gets all these things right.
