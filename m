Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD25C2BA80
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 16:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C6342083E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 16:54:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V37nCWQb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgDGQyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 12:54:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:42440 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgDGQyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2020 12:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xyvC0zHB9QmZ9Gh+rPLMD8+WbkHV9x5ewqL8s/T8/mI=; b=V37nCWQbGr6w7MZg0X96KWeXpx
        LJXSRc8J2WYkKuqWj/RyGZl0uNrNQJxryUBpfZ2A1fq/Rgm6KSsLGuzQ6mb8YkjDN2et7eQ6ihNoK
        zLMgGrDR+qzRIpmPGDldEi6Z1lQl6TCrzgk7mx/0SZGmUCam+tkunQlfc36spfaX7l9cqVddwBwjx
        OLzwOW3aqPL+1c5WN/YbODSJzglEg30k+HgqSakKi4D0vepTEK8meAa4PAXz/kmOsH/AdiV3D+LCC
        ietfoy6x2zYgqqj/hvS4mnN5muvghIzz6+reZx09pGsb1l8VUStqhqr5eAY8diS6z1BisTBq1crGm
        SCyQLY6A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLrUR-0008LT-Ux; Tue, 07 Apr 2020 16:54:19 +0000
Date:   Tue, 7 Apr 2020 09:54:19 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 03/10] block: introduce blk_req_zone_write_trylock
Message-ID: <20200407165419.GD13893@infradead.org>
References: <20200403101250.33245-1-johannes.thumshirn@wdc.com>
 <20200403101250.33245-4-johannes.thumshirn@wdc.com>
 <20200407165350.GC13893@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407165350.GC13893@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 07, 2020 at 09:53:50AM -0700, Christoph Hellwig wrote:
> So this new callback is exectured just before blk_revalidate_zone_cb
> returns and thus control is transferred back to the driver.  What
> speaks against just implementing this logic after the callback returns?
> ->report_zones is not just called for validation, but does that matter?
> If yes we can pass a flag, which still seems a bit better than a
> code flow with multiple callbacks.

Sorry, that reply should have been for the next patch.
