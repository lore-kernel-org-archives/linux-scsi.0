Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C2CC17441
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 10:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D960D214E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 10:22:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jWDUAfwS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfKKKW7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 05:22:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58938 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbfKKKW7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Nov 2019 05:22:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rsrc0hw15XFvUS1BF0cnd7QBR4nqLE43XWK8jb8pnzE=; b=jWDUAfwSsKiB0sckHhneGHYAj
        9OnETJBBXAfFSPzpdDJfeXV4WXPcmqdi5e1wBm5Szpjelrjnp8kPWC+XJwclLLzwj30ej4PaaImBm
        LiSV0zVnyKhPDlPe1CArH8J65tsP+xgbDrjRzdVr6+SQR2fJQjKunQG34NuP0GmwngqietPNezzvG
        scrPh0QEEe/Oc3tUIzAI0ojgTOOVvlcheInxaeMlTu27Fk6/APNgKpwiA3omvAtl31JvjNL3KFmxR
        oXnih/xP1XUO2YMOKlYG15xKFJwiUuTAvzKg5jbtdlQE07t1+TtOS8w0XaRa4g+yVyGCaQPB/nJ/X
        mRYp6VdZw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iU6qW-0000gA-Fm; Mon, 11 Nov 2019 10:22:56 +0000
Date:   Mon, 11 Nov 2019 02:22:55 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH v2 8/9] scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()
Message-ID: <20191111102255.GB727@infradead.org>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
 <20191111023930.638129-9-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111023930.638129-9-damien.lemoal@wdc.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 11, 2019 at 11:39:29AM +0900, Damien Le Moal wrote:
> There is no need to arbitrarily limit the size of a report zone to the
> number of zones defined by SD_ZBC_REPORT_MAX_ZONES. Rather, simply
> calculate the report buffer size needed for the requested number of
> zones without exceeding the device total number of zones. This buffer
> size limitation to the hardware maximum transfer size and page mapping
> capabilities is kept unchanged. Starting with this initial buffer size,
> the allocation is optimized by iterating over decreasing buffer size
> until the allocation succeeds (each iteration is allowed to fail fast
> using the __GFP_NORETRY flag). This ensures forward progress for zone
> reports and avoids failures of zones revalidation under memory pressure.
> 
> While at it, also replace the hard coded 512 B sector size with the
> SECTOR_SIZE macro.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Looks fine even with the __vmalloc usage:

Reviewed-by: Christoph Hellwig <hch@lst.de>
