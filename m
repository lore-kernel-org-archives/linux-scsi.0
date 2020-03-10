Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3931DC18E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:43:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088B32253D
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:43:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qP91Ipcw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgCJQnQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:43:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53422 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgCJQnQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 12:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0nljRlHrjvdOM2v9X4Hj4F1MOzaRzMQY06OyCXA3da4=; b=qP91IpcwTcuDEladNSsdKeJKPr
        7ER8bl5yErSUdgnFzBnmzJZ6JDO78AveYC/yiPJ3nE4jrNf/uth/wJS64KjqZzeLE7bZbE9VAVXDG
        YPQ1TysWmU/G9CN9NDh/k4/4u5/5wkLoskzmVAYUzITMkWhY6Iw9jFYNE9AgPZ3k+Ysf81QQI0srJ
        /2rRL3nGJV7kd7s7uNoas8MRDj6buR8ltSUhYfkUJLbbzChnCj/whaV/20GpkCtQsG4X33J7ZBGMo
        miI+DrNuO9KEYn+TfKn8+6VOf/9BrE1bwCbpo+XXFW+QAOAkHA8/1EqbLdBCj927Ak0nvVvwYSr9p
        w0M8vhzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBhyN-0004Sw-Dp; Tue, 10 Mar 2020 16:43:15 +0000
Date:   Tue, 10 Mar 2020 09:43:15 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 03/11] block: introduce bio_add_append_page
Message-ID: <20200310164315.GB15878@infradead.org>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
 <20200310094653.33257-4-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310094653.33257-4-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 10, 2020 at 06:46:45PM +0900, Johannes Thumshirn wrote:
> For REQ_OP_ZONE_APPEND we cannot add unlimited amounts of pages to a bio,
> as the bio cannot be split later on.
> 
> This is similar to what we have to do for passthrough pages as well, just
> with a different limit.
> 
> Introduce bio_add_append_page() which can used by file-systems add pages for
> a REQ_OP_ZONE_APPEND bio.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

This should go into the previous patch.
