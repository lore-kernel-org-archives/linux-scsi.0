Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB07FC3A5A7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 09:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89A1921883
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 09:03:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nagbhuKL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbfICJDV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 05:03:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41572 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfICJDV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2019 05:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6CYJCVOARtkXvfJoeTBjFJScvq3/f/7wy/jpy7pKVAc=; b=nagbhuKLdzgC/ctiEqCO+LsYN
        NjM1kmf9src0sfas7DcR2I3q12EaGkDYMofIo09QqOB2xVNulFROmuGZIwFnyMeVUGJB0gjlVvMIs
        EYrronPSR9XL5yshrl7yYkUr5agA+mnfWqxrAUEeHB7TzUrtKt7JsAnnF/etTJayvSA5+dGPF9+ac
        Ik77sDM+U1qOVbAiRMf6H1aSbFo0+azBBTeJKemRq8CWQoHzEx/a3ArJ+NFdvX8BR2Gx3mEHWAzyF
        0/zJL+jbapiHRLD42xvwxWCkV4R2Z5JS0fOYhXoDTJodujPLUOHE/0hDWLYvtuaFrh5og3U6TeA1U
        2gX5KAN4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i54if-0001Qo-Ay; Tue, 03 Sep 2019 09:03:21 +0000
Date:   Tue, 3 Sep 2019 02:03:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 7/7] scsi: Set ELEVATOR_F_ZBD_SEQ_WRITE for ZBC disks
Message-ID: <20190903090321.GG23783@infradead.org>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
 <20190828022947.23364-8-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828022947.23364-8-damien.lemoal@wdc.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2019 at 11:29:47AM +0900, Damien Le Moal wrote:
> Using the helper blk_queue_required_elevator_features(), set the
> elevator feature ELEVATOR_F_ZBD_SEQ_WRITE as required for the request
> queue of SCSI ZBC disks.
> 
> This feature requirement can always be satisfied as the mq-deadline
> elevator is always selected for in-kernel compilation when
> CONFIG_BLK_DEV_ZONED (zoned block device support) is enabled.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Maybe s/scsi/sd/ in the subject?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
