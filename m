Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F7F9C4167B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E724423380
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgLGNfw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgLGNfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 08:35:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F84EC0613D3;
        Mon,  7 Dec 2020 05:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5RIcVmn+VlPFWSCbSt5RtCZGa3ACRCnuBrYV8N2U96c=; b=r9tKNRRXMLtUme0fQ06bXerFZI
        NXV5kiRHTTxTnca/6p4Pa1FFoz+9JDIkQh0csm7AgGuxFLpXcUBvq8idFLHN0QK7xUjiZQhd35f4o
        A/kVH8pEEiPc0fb3XPhmrkIif9lrddKgBCAGEh6SN8WMyFGd+COpA01W7PREHKjn0rsC2Aa5z/mXs
        92Lnwcml0koldOrGVHotlvR1Bkv0OEoeK7UC66AGKQ4Puz3iVB6uFYAe4hjdSYlirABEOEJmqly+O
        H4Rema3YnwygRHoqKMvhwHpySZpwg7IJ5KSyVqFh84dAq6jIw15vSJ3wL9uq0ABVj5mGkih7WS1k8
        KhlcpmnA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmGfW-0007ce-SE; Mon, 07 Dec 2020 13:35:10 +0000
Date:   Mon, 7 Dec 2020 13:35:10 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] block: set REQ_PREFLUSH to the final bio from
 __blkdev_issue_zero_pages()
Message-ID: <20201207133510.GB28592@infradead.org>
References: <20201206055332.3144-1-tom.ty89@gmail.com>
 <20201206055332.3144-3-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206055332.3144-3-tom.ty89@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Dec 06, 2020 at 01:53:32PM +0800, Tom Yan wrote:
> Mimicking blkdev_issue_flush(). Seems like a right thing to do, as
> they are a bunch of REQ_OP_WRITE.

Huh?  Zeroing out is in no way a data integrity operation that needs a
reflush.
