Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6C68C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 15:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96C7420872
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 15:55:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oc+kgjLw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbgIOPzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 11:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbgIOPyI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 11:54:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30423C061355;
        Tue, 15 Sep 2020 08:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=2UlbGdiZDTOnbAr3xs1aHbeR9XTzI0Lit7D+l7hf2I4=; b=oc+kgjLwN6z7KfpzJBCa7G7OBj
        xMg3Fwxams8c4EpKokR8UZQx2ybyjDj6drc+aW/2LIv1O+PR2BmjXm+WhI4RUptwlI8TGWRoAeWLn
        tDzzTX6C7Wcaz+wjCgZzqB/SScThzcLyj8JgUrilV2pjnlwL2WrjnmkdPgkjiBopQKBs17NlwGyrT
        ONpkConNykQRC+jrpDpmqw3ajb1dphcelbcTILjH85oTRbiw7nNGsu7203+03im4y0uv272kq3shG
        s0VEBKB5Z/ya3O5D9oa/TJdMgnhrtizoC8G9P+/zAzkC5+arP3EQvUavmCF3BtD/B11AifbDQWTH6
        Z2mcOZcw==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIDGv-0003AQ-TI; Tue, 15 Sep 2020 15:53:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: a saner API for allocating DMA addressable pages v3
Date:   Tue, 15 Sep 2020 17:51:04 +0200
Message-Id: <20200915155122.1768241-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

this series replaced the DMA_ATTR_NON_CONSISTENT flag to dma_alloc_attrs
with a separate new dma_alloc_pages API, which is available on all
platforms.  In addition to cleaning up the convoluted code path, this
ensures that other drivers that have asked for better support for
non-coherent DMA to pages with incurring bounce buffering over can finally
be properly supported.

As a follow up I plan to move the implementation of the
DMA_ATTR_NO_KERNEL_MAPPING flag over to this framework as well, given
that is also is a fundamentally non coherent allocation.  The replacement
for that flag would then return a struct page, as it is allowed to
actually return pages without a kernel mapping as the name suggested
(although most of the time they will actually have a kernel mapping..)

In addition to the conversions of the existing non-coherent DMA users,
I've also added a patch to convert the firewire ohci driver to use
the new dma_alloc_pages API.

The first patch is queued up for 5.9 in the media tree, but included here
for completeness.


A git tree is available here:

    git://git.infradead.org/users/hch/misc.git dma_alloc_pages

Gitweb:

    http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma_alloc_pages


Changes since v2:
 - fix up the patch reshuffle which wasn't quite correct
 - fix up a few commit messages

Changes since v1:
 - rebased on the latests dma-mapping tree, which merged many of the
   cleanups
 - fix an argument passing typo in 53c700, caught by sparse
 - rename a few macro arguments in 53c700
 - pass the right device to the DMA API in the lib82596 drivers
 - fix memory ownershiptransfers in sgiseeq
 - better document what a page in the direct kernel mapping means
 - split into dma_alloc_pages that returns a struct page and is in the
   direct mapping vs dma_alloc_noncoherent that can be vmapped
 - conver the firewire ohci driver to dma_alloc_pages

Diffstat:
