Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3F2C2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DC6B2082D
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 15:58:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QDlUXGZR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbgDHP6M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 11:58:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50630 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729171AbgDHP6L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 11:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=60oJrRI41WouG8jHcJPPwQzZQTB+wJaffRgLmxVO0ak=; b=QDlUXGZRGn4j3SvuWXqW4Pk2mj
        QF8mY+t1y4QAM/7yUmUOMUz5rRsowwjsFnRNsp505rseKcCq0za0IwZlM6/Kcti7tyraTRlAlwbk2
        Ri9JAOh46l0yRSqUXQeO80RBr84S/MUOQRV7VvViD9XsJTtcAwUsxa1FBHxTd/T4s5MPFAGB2jYr6
        IXRXJd7mrEd5W9/JRh8y+A+1dh5Td1DQNHRnxC0r2up+rtzw+CRrKZ6k5/59ZA2Z4GfCpGyQ4v0h1
        q4+m8HvROPPpal5fIS69LuZHtpzIbMyjybSZ/Do0+EDSfMu2Dj8a+CaJ0s4PxN/Ip9DUz82JVnZWI
        tGSER1Fw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMD5d-00078t-T1; Wed, 08 Apr 2020 15:58:09 +0000
Date:   Wed, 8 Apr 2020 08:58:09 -0700
From:   "hch@infradead.org" <hch@infradead.org>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     "hch@infradead.org" <hch@infradead.org>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-block <linux-block@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 04/10] block: Modify revalidate zones
Message-ID: <20200408155809.GB29029@infradead.org>
References: <20200403101250.33245-1-johannes.thumshirn@wdc.com>
 <20200403101250.33245-4-johannes.thumshirn@wdc.com>
 <20200407165350.GC13893@infradead.org>
 <CH2PR04MB690293BBEA93CAFDB769E6ADE7C00@CH2PR04MB6902.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH2PR04MB690293BBEA93CAFDB769E6ADE7C00@CH2PR04MB6902.namprd04.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 08, 2020 at 08:29:13AM +0000, Damien Le Moal wrote:
> (Changed the subject to point to the correct patch)
> 
> Yes. Indeed we can do that. A flag will keep the interface of the report_zones
> method simpler.
> 
> But the second call to the revalidate callback done after the zone report is
> done is still needed so that the wp_ofst array can be updated under the queue
> freeze and avoid races with number of zones, bitmaps etc updates. I have not
> found any good way to avoid that one if we want to preserve
> blk_revalidate_disk_zones() as a generic helper. Of course if we reimplement
> this in sd_zbc, things are simple, but then we will have a lot of code repeated.

True, I missed the second call.  But given that it does something
entirely different multiplexing it to the same interface does indeed seem
rather odd.  So I think we can pass a 'finish' or so callback to
blk_revalidate_disk_zones.  I'm not even sure we need the args or a
flag. Ithink we can just make sure calls to blk_revalidate_disk_zones
are synchronized and then have a pending_wps pointer int the scsi_disk
structure.  If that is set, sd_zbc_report_zones updates it, and then
the finish callback puts it into the real place.
