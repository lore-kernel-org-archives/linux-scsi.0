Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DC2C3A5A7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 09:03:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC4F021883
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 09:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Uk+PjGL0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfICJDE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 05:03:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41550 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfICJDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2019 05:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=imTZirzLZzR+/1QqlLRfVq+nXtz4v9nM/U066z2Q7q0=; b=Uk+PjGL0fFGDJgSLSnvob0dU5
        HnrzCrWfyEZu+Kg7qId9Iob9bQLj8ZH8FnLY/qIpCPZJg03pa/H3JFoJvAGheQwVldWNJeyaYIvYc
        RcqzwVauYLJaoOvxvBmyWOEIUHt11AlcIGLYZuTxnvex8260rmhe8R5abuio1du9DF8QR+Bwr9fen
        8Lm5PIlbtSa0UnYHZHPZKiovJjySenF2wYbpzEJ3cj3qmfaHV3P6crkUcRXGNvFW+ZyziRvYCA0FL
        TBD8J9hltpTJMb5iIcZuJoN8kpb+OPKyEA/aJowkbZTDQo24aCyPaY0YVwcfJztFzTRNMzWaE3Lq2
        easLc7TGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i54iN-0001P9-K3; Tue, 03 Sep 2019 09:03:03 +0000
Date:   Tue, 3 Sep 2019 02:03:03 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 6/7] block: Set ELEVATOR_F_ZBD_SEQ_WRITE for nullblk
 zoned disks
Message-ID: <20190903090303.GF23783@infradead.org>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
 <20190828022947.23364-7-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828022947.23364-7-damien.lemoal@wdc.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2019 at 11:29:46AM +0900, Damien Le Moal wrote:
> Using the helper blk_queue_required_elevator_features(), set the
> elevator feature ELEVATOR_F_ZBD_SEQ_WRITE as required for the request
> queue of null_blk devices created with zoned mode enabled.
> 
> This feature requirement can always be satisfied as the mq-deadline
> elevator is always selected for in-kernel compilation when
> CONFIG_BLK_DEV_ZONED (zoned block device support) is enabled.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
