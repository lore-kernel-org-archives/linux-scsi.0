Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7D2C10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA020222C3
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:42:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r/icAaHd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgCJQmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:42:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53386 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726395AbgCJQmc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 12:42:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OD+nprfZaFcbxeG2a36sbeRwNh3eux46qu3CwbbPO8U=; b=r/icAaHdh7hJTNlYV4K6ua85UV
        zKOM+Hg/UnCozR3fliYS+ntqvzcA72vxzsYG1kRT9eIdtpVMqvZrCeZAW7sRsOOagdJhe8beI95S9
        voGuiWK3X8nDO9xvmL5hcsE/LG2WaLT9/aqHP17BK32nqU4uXbAMX1yW1kHaqR3PclFjRyKCB/fzo
        99xcCk477K0YNml20BgXo38WTe1tsJ6Cs06j0AMPnXeSucf9Su/UA4GTXZ+TPiYRBrPtI/36lQ0b7
        pjnZj/swKU+2gc/ivOHkSfBmnGfvSUGNO6QzGxHPWtPu/8x5FZ4Tn4Xzwec1227b33A2W49Bv473y
        JTBALVIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jBhxd-0004Em-KL; Tue, 10 Mar 2020 16:42:29 +0000
Date:   Tue, 10 Mar 2020 09:42:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 00/11] Introduce Zone Append for writing to zoned block
 devices
Message-ID: <20200310164229.GA15878@infradead.org>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 10, 2020 at 06:46:42PM +0900, Johannes Thumshirn wrote:
> For null_blk the emulation is way simpler, as null_blk's zoned block
> device emulation support already caches the write pointer position, so we
> only need to report the position back to the upper layers. Additional
> caching is not needed here.
> 
> Testing has been conducted by translating RWF_APPEND DIOs into
> REQ_OP_ZONE_APPEND commands in the block device's direct I/O function and
> injecting errors by bypassing the block layer interface and directly
> writing to the disc via the SCSI generic interface.

We really need a user of this to be useful upstream.  Didn't you plan
to look into converting zonefs/iomap to use it?  Without that it is
at best a RFC.  Even better would be converting zonefs and the f2fs
zoned code so that can get rid of the old per-zone serialization in
the I/O scheduler entirely.
