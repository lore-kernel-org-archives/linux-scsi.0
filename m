Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E68DC41514
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 09:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04F5E22DBF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 09:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sBac7K0B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfICJCs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 05:02:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41526 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfICJCs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Sep 2019 05:02:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=UlTNZU2MPdvFF85ti7y0SjiEEuIQm/g2TlsVbK6S+c8=; b=sBac7K0BPZjAH8tuRsgva63CZ
        YYCIBfOVBmaqIvpBlX1B1tcxEjGfxBkqhAEGXeWmjp9vs7zDyHkB+bcTffmGfp3PpsA/CfaOuWDlE
        rFUS5N3WpRlmFDllyXDqKBSMGZ1L2mgoen4/hVES+xdfnJiJFopyqQvtf0BSKIaNTBgbdx23saiJc
        VSz7V/t2ZVZMfzZEgV4LQB6Z3lclxldKvtbyln5np7UCrdSqbSWSajoYcn8KCKDPaZ5HXp35007a6
        QkMW/Afo6LXYkvcicZjndnLg9VNppx0Yuy+ymZoZ6rlXSSj8UapaEk8oPwG/u12MdP8uR9qC0JFdS
        h384023WQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i54i7-0001Nt-Mp; Tue, 03 Sep 2019 09:02:47 +0000
Date:   Tue, 3 Sep 2019 02:02:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 5/7] block: Delay default elevator initialization
Message-ID: <20190903090247.GE23783@infradead.org>
References: <20190828022947.23364-1-damien.lemoal@wdc.com>
 <20190828022947.23364-6-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828022947.23364-6-damien.lemoal@wdc.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2019 at 11:29:45AM +0900, Damien Le Moal wrote:
> When elevator_init_mq() is called from blk_mq_init_allocated_queue(),
> the only information known about the device is the number of hardware
> queues as the block device scan by the device driver is not completed
> yet. The device type and the device required features are not set yet,
> preventing to correctly choose the default elevator most suitable for
> the device.
> 
> This currently affects all multi-queue zoned block devices which default
> to the "none" elevator instead of the required "mq-deadline" elevator.
> These drives currently include host-managed SMR disks connected to a
> smartpqi HBA and null_blk block devices with zoned mode enabled.
> Upcoming NVMe Zoned Namespace devices will also be affected.
> 
> Fix this by moving the execution of elevator_init_mq() from
> blk_mq_init_allocated_queue() into __device_add_disk() to allow for the
> device driver to probe the device characteristics and set attributes
> of the device request queue prior to the elevator initialization.
> 
> Also to make sure that the elevator initialization is never done while
> requests are in-flight (there should be none when the device driver
> calls device_add_disk()), freeze and quiesce the device request queue
> before executing blk_mq_init_sched().

So the disk can be accessed from userspace or partition probing once we
registered the region.  Based on that I think it would be better if
we set the elevator a little earlier before that happens.  With that
we shouldn't have to freeze the queue.
