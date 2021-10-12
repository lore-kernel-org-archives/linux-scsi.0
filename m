Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADDBC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 05:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5B6560241
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 05:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhJLFYI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 01:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhJLFYH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 01:24:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AF8C061570;
        Mon, 11 Oct 2021 22:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XAz8rVhhb14wB+TibMDkEqhtITE0PMmuAuXWrjIvzRE=; b=nP8WXylCSX4cMJHGeoDA1pQ048
        pt3n9WkaswMXiIPFewA/CCeygsP2e/0U9jJFaUdQS5+ACk8U8QAeVkTmcoDeB/tmEDjr2k+VVgk+0
        Jy6M+oGSW4t5mnR7veeXHXfokjYnwphfYNF0j3fU3uDGbK6cl/Wlos3a4T9FlE+8qmwTlj9+BxhMP
        O0CYzPF60mqNKH2z4hXPNJ8oVTW/+vsPNaWLe4yk1QXxi7F8ICeysJ2RPz421hSWyQ3dYBWb2fdQv
        aMh1+H1QsWbQIiZC0ktbeBz3Sk+PFCvgDRSEZ92lHHKjx/1i9NMQfGmQfobzUb7mSW54UM0U5/2E4
        5t5BdtSA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1maADI-006EV4-UB; Tue, 12 Oct 2021 05:20:45 +0000
Date:   Tue, 12 Oct 2021 06:20:32 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     hch@infradead.org, Michael Cyr <mikecyr@linux.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ibmvscsi_tgt: Use dma_alloc_noncoherent()
 instead of get_zeroed_page/dma_map_single()
Message-ID: <YWUbIBna0NAOJu62@infradead.org>
References: <20211012032110.2224-1-caihuoqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012032110.2224-1-caihuoqing@baidu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 12, 2021 at 11:21:09AM +0800, Cai Huoqing wrote:
> Replacing get_zeroed_page/free_page/dma_map_single/dma_unmap_single()
> with dma_alloc_noncoherent/dma_free_noncoherent() helps to reduce
> code size, and simplify the code, and the hardware keep DMA coherent
> itself.

It might also be worth to mention that this also avoids potential
bounce buffering.  Although for pseries vio devices this probably can't
happen anyway.

> +	vscsi->cmd_q.base_addr = dma_alloc_noncoherent(&vdev->dev, PAGE_SIZE,
> +						       &vscsi->cmd_q.crq_token,
> +						       DMA_BIDIRECTIONAL, GFP_KERNEL);

Please avoid the overly long line.

The same comments also apply to the other patch.
