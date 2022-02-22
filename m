Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C962C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiBVPji (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiBVPjh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:39:37 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AFE9EB94
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 07:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8Nbi9a5RvSyQyKc3pYEpOI+oOpkr+iDe9VICBGioQH4=; b=LtKBtr0dOxgECwoPQ/UoiZCfCw
        CQAOY9oPt2WpQbdwo6YL4juhoIe2pLMRrC2Yi2z4IH6x340AaZjrBUnUOQ3OBQ6SPIjO9+wpTtXOV
        O31OZnOoucDnJfR1M7nvdmXi94SexYzREroSGcCiBGyJDWg1Ptj/VJM0ZJhwwU1+oPuzrAYvrUFWQ
        +88VKjumeBT1bGMnQc+DDsv7Fm9Er829MAT8CQtXr9lcQls1JmtMJho9qcRXVGoFgsVkaHgS8lbfE
        NmEv3AfJ7257HSqtcQiDSQQGv/oajrB6zToCiIe9rnv8+bmPMWdBKBXxcOSkH86HlFP1eTMkA41j4
        M22gBRww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMXFq-00AJAc-FZ; Tue, 22 Feb 2022 15:39:06 +0000
Date:   Tue, 22 Feb 2022 07:39:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     John Pittman <jpittman@redhat.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        suganath-prabu.subramani@broadcom.com,
        sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        loberman@redhat.com, djeffery@redhat.com
Subject: Re: [PATCH] scsi: mpt3sas: decrease potential frequency of
 scsi_dma_map errors
Message-ID: <YhUDms8sUkaKPvyw@infradead.org>
References: <20220222150319.28397-1-jpittman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222150319.28397-1-jpittman@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 22, 2022 at 10:03:19AM -0500, John Pittman wrote:
> When scsi_dma_map() fails by returning a sges_left value less than
> zero, the amount of logging can be extremely high.  In a recent
> end-user environment, 1200 messages per second were being sent to
> the log buffer.  This eventually overwhelmed the system and it
> stalled.  As the messages are almost all identical, use
> pr_err_ratelimited() instead of sdev_printk() to print the
> scsi_dma_map failure messages.

I'd remove the message entirely.
