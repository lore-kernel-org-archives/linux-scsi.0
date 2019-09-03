Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC5FC3A5A7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 08:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A54FF22D6D
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 08:55:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kq8NT6o5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbfICIzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 04:55:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37986 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfICIzD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2019 04:55:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IWGI2E5Ifp9hmOtYsRRjCWqY6h5sbX5CDOHLjI6jqZ8=; b=Kq8NT6o5EDBPjCfF4pRcHINDS
        bwACib3udofn2XPqHt4Af2pKrLf61m4N/00XhlZM/W71THZocGrO3hszg9eScRxKa6ARr8afwsu1w
        clpCkaHvtD/xrChnB4euBoEc0WBSIcxjkaT6RTn6OduvZTW08akO9XATHMur74WJVuN3BZH5gijYN
        bmWe7GaOxd0bMaNwLoJhEobeY0UK5fBB+fnZT04rMvM6dXYfuUfxClwH7xFM9RH/bCRtTuAb22jFK
        br02v/s6RrF/4ywIB1rueQnhb4oVJA2AQfaynHdUeMoX/GKuG0DbLB/v8zia2hZvkXeQLu+9hyRvI
        3tqvgf41A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i54ac-0006Qs-Vb; Tue, 03 Sep 2019 08:55:02 +0000
Date:   Tue, 3 Sep 2019 01:55:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/7] block: Cleanup elevator_init_mq() use
Message-ID: <20190903085502.GA23783@infradead.org>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
 <20190828022947.23364-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828022947.23364-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2019 at 11:29:41AM +0900, Damien Le Moal wrote:
> Instead of checking a queue tag_set BLK_MQ_F_NO_SCHED flag before
> calling elevator_init_mq() to make sure that the queue supports IO
> scheduling, use the elevator.c function elv_support_iosched() in
> elevator_init_mq(). This does not introduce any functional change but
> ensure that elevator_init_mq() does the right thing based on the queue
> settings.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
