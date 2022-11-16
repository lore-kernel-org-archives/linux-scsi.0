Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36CAC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 05:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiKPF7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 00:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiKPF7J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 00:59:09 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929D222B09
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 21:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Z/N0GlZkuwEhzNgrivkqgWSeNff88PF63hR9M92nFvk=; b=Mwc/R1zb3I0ZGcQ7gyeFgNnSIc
        JoxEv0hE8Ia3MzY8CmsYVAiSLj2XttzJKONuTyq7KJNcJh8sAA38LTX/QFfiripVgwV01HHJDRhZq
        8tl5Rb472oXJFvUEVoKGs1wa3Z3znQL2Q/LnJg9M0d4tt06YMKdymQsPDZ9PYrVtpYw8xDWeqKGwS
        WXtDCGhtOKaB92mjgj6GFvJIDl58rsWj6Zwd7vb81JFOmFCwImVaYUNV3doV/N6d/5NejRKtsrPvV
        DD2LnDxpzRxawuyRqpYxCr/394DEb9R63q02uLbyomfT85nOGlQg9/myiGhni+lfFubpYyny6j0RM
        O8xuVMlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovBRz-0009Lx-6q; Wed, 16 Nov 2022 05:59:07 +0000
Date:   Tue, 15 Nov 2022 21:59:07 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org,
        bostroesser@gmail.com, jgg@ziepe.ca
Subject: Re: [PATCH v2 2/5] scatterlist: add sgl_copy_sgl() function
Message-ID: <Y3R8K1UZJN3TtDza@infradead.org>
References: <20221112194939.4823-1-dgilbert@interlog.com>
 <20221112194939.4823-3-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221112194939.4823-3-dgilbert@interlog.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 12, 2022 at 02:49:36PM -0500, Douglas Gilbert wrote:
> Both the SCSI and NVMe subsystems receive user data from the block
> layer in scatterlist_s

No, they don't.  For one thing there is no 'scatterlist_s', and
second no one receives it.  Block drivers need to generate it
using the blk_rq_map_sg helper.

> (aka scatter gather lists (sgl) which are
> often arrays). If drivers in those subsystems represent storage
> (e.g. a ramdisk) or cache "hot" user data then they may also
> choose to use scatterlist_s. Currently there are no sgl to sgl
> operations in the kernel. Start with a sgl to sgl copy. Stops
> when the first of the number of requested bytes to copy, or the
> source sgl, or the destination sgl is exhausted. So the
> destination sgl will _not_ grow.

No, the scatterlist is a bad data structure, but for now we have
to use it for dma-mapping non-contigous pieces of memory.  For
everything else it absolutely should not be used, and we should
not add helpers to facilitate that.

NAK for this and the other helpers.
