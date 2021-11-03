Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98054C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A22B6103B
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 16:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232802AbhKCQaj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbhKCQai (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 12:30:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FCFC061714
        for <linux-scsi@vger.kernel.org>; Wed,  3 Nov 2021 09:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JM2kDV/KB2C6mdQlMYWiAoR2nX1pUHoTjZNVt+jQ18E=; b=Z1iKa0GJAP9sTJck/AilVJLmqQ
        E8E8rrhANHjGixgrfEVFTK8Ts4L+CG0PmN9vgWlTr4grQrjxELaYroZqfaaZvwDiXfJ6WrLYRj6J5
        Yocycg64geTrGLF1Fi7iyEcTcW3yx1KRQ7pN15SERUTob+IztXujxvxr0TUeOq8OqdlicAhqgvEyr
        vdmenA5qaEiQuJgXo0ciXp0quVjYI4t2mCHR756T++j87hDY/Pj4aph87wy4At1igcsh7YqTHEoVL
        EvQ7pSuE4pOSlR8ivWAlYpda/95QcNKZGHWdn+55GjXx70YZislOnHjsNcSZLEv6L9V9a2vx+Ru+n
        wUgiO2CA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miJ7D-005lcB-Pc; Wed, 03 Nov 2021 16:27:55 +0000
Date:   Wed, 3 Nov 2021 09:27:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
Message-ID: <YYK4i6ak6Dqe1JeG@infradead.org>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
 <YYI9BLBhrFbgridf@infradead.org>
 <700f0463-23a9-8465-f712-1188cb884dea@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <700f0463-23a9-8465-f712-1188cb884dea@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 06:45:34AM -0700, Bart Van Assche wrote:
> > But more importantly: SCSI LLDDs have absolutel no business calling
> > blk_get_request or blk_mq_alloc_request directly, but as usual UFS is
> > completely fucked up here.
> 
> As explained by Adrian, the UFS protocol uses a single tag space for SCSI
> commands and UFS device commands. blk_mq_alloc_request() is used in this
> context to allocate a tag only from the shared tag space only. I think using
> blk_mq_alloc_request() for that purpose is fine.

The problem is not the shared tag space, the problem is that it is
poking through layers.  IFF we have good use cases for just allocating
a tag (and we don't want to reserve it, which does make sense for many
things like task management) we need a SCSI layer API that returns just
the tag (and preferably also poisons the request in some way).
