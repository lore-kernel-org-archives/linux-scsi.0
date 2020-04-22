Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCC1C55181
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 496D220706
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:46:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U6eAKM1P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgDVGqf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgDVGqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 02:46:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39478C03C1A6;
        Tue, 21 Apr 2020 23:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nO5S4Mem5T7AE8D4mNvpR/dKuA8HQ3I/M8cHAjY7mEY=; b=U6eAKM1P6raiQPKAXnGudvah86
        5gZxV3RZv7weXB3T5bcnf5Vff/nk95WpIrWBwL0wRbcBCWNQdxXk9JKaTQBP/ITpO/kCV7Lln3JEb
        KlsvzkxjkfHGyvnxBonxmkOE3NKRfBINQ9zkIHVWX4r0TRm5Si6BN6MTBJX3YHPhUsrTDVCPK2gfb
        Q/rBP8fcoSvOuyzcoEsK68mewrQDOoLyFZ8fMMJl9NPgv2Q3bXRp5hgObCjwsRCBoevCjA6vMUdEY
        7Wkwjdg1010GoY7qtTERi3sdWY1pymW2kvIe0vM15dFUaLD4/EnunTvcuh6kXqT0ZN/T7JIJhsdOE
        efUKkE/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jR99S-0007e0-R6; Wed, 22 Apr 2020 06:46:30 +0000
Date:   Tue, 21 Apr 2020 23:46:30 -0700
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "hch@infradead.org" <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>,
        Daniel Wagner <dwagner@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 04/11] block: Introduce REQ_OP_ZONE_APPEND
Message-ID: <20200422064630.GH20318@infradead.org>
References: <20200417121536.5393-1-johannes.thumshirn@wdc.com>
 <20200417121536.5393-5-johannes.thumshirn@wdc.com>
 <373bc820-95f2-5728-c102-c4ca9fa8eea5@acm.org>
 <BY5PR04MB6900E3323E8FB58C8AB42D24E7D40@BY5PR04MB6900.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY5PR04MB6900E3323E8FB58C8AB42D24E7D40@BY5PR04MB6900.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 20, 2020 at 12:30:25AM +0000, Damien Le Moal wrote:
> > 
> > Why the start sector instead of any sector in the target zone? Wouldn't
> > the latter make it easier to write software that uses REQ_OP_ZONE_APPEND?
> 
> We could do that, but we choose to have the interface match that of other zone
> operations (e.g. REQ_OP_ZONE_RESET/OPEN/CLOSE/FINISH) which also require the
> zone start sector.

It also would not simply anything.  The fs block allocator needs to pick
a zone, and the device picks the actual LBA,  So specifying any "random"
LBA in the zone would not actualy benefit the fs.
