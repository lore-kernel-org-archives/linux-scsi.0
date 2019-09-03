Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A212DC3A5A7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 08:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A31322DBF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 08:55:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gahg0rTR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfICIz3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 04:55:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38022 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbfICIz3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2019 04:55:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tPZ4VR9jwGGVkex83aEsFXDxR7dc9Z/AufhUpmj0UHY=; b=Gahg0rTRTSQR9+rw3BThXzqGz
        GVYjCuzCOqTj8zTmPjzuC5ehYK6Hjw6SNUrA/eha6UIXKegYWPZ27Ss3uo6H3ErwsU6Lj77/tf6mS
        5f9KfExKwj81hT3apR3ND0aA1hpSdci9oETilA9EcAwZ0uVXg18mTGWWVmsp3CkOGvVLm/77GAkZv
        Hl83mXh583+HakunuHe32mXji0FnggGv5nMo3y846DiowCLrpNSiQmG5Ir6Xqhl1zQaljzdqySdqU
        fmxn7XRW3vczU//FFt/7V0FIJ5XtdnQ9HC6ZicwO1M7+DTfbU8BGrrpil7w6t6cGb4/vnH0N+XmOW
        liz55JxaQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i54b3-0007Ug-BG; Tue, 03 Sep 2019 08:55:29 +0000
Date:   Tue, 3 Sep 2019 01:55:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/7] block: Change elevator_init_mq() to always succeed
Message-ID: <20190903085529.GB23783@infradead.org>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
 <20190828022947.23364-3-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828022947.23364-3-damien.lemoal@wdc.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2019 at 11:29:42AM +0900, Damien Le Moal wrote:
> If the default elevator chosen is mq-deadline, elevator_init_mq() may
> return an error if mq-deadline initialization fails, leading to
> blk_mq_init_allocated_queue() returning an error, which in turn will
> cause the block device initialization to fail and the device not being
> exposed.
> 
> Instead of taking such extreme measure, handle mq-deadline
> initialization failures in the same manner as when mq-deadline is not
> available (no module to load), that is, default to the "none" scheduler.
> With this change, elevator_init_mq() return type can be changed to void.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
