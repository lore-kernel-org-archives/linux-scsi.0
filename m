Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 582DFC43217
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 13:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiJRN5l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 09:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiJRN5j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 09:57:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F69CF87C;
        Tue, 18 Oct 2022 06:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Mr4DfIpBvotAuVVudNix3c7JoZHD1w7ur0X4aAHNKkg=; b=L9c5nDxaeDoStiR7rMP73Bq/Rr
        Wt6tUxRAudutAV0nsdsaD0lWZQtG/lYF4pLAbQJfzw/aAtl5/O4CzLBS2F/RaI60TSSMeylHqlUU/
        6mnHbNnP1AxnaYdzAemCBrpMk4039egEZZbysA2dWff6ODT3CjfGZVrMWMp/zsJ4Gt22eetoHhkdP
        2bmmgMV/gN0snq/xvJLZyfbUKkZywlvE4yHeIvI5ABcmUdDeve2U7dgBojdNDUHtJ8pWmdMcJO2Ee
        Qzwp2tdP1s+SEYZ82cGEKwNXlACfVWUOqGq/lxdQR7Vx0lDHIkMDYzUmDdyZfLzZOq6r9JLmaFDIs
        dd+UwUjw==;
Received: from [2001:4bb8:199:ad84:3a05:173d:d0f5:e725] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okn5y-007C4y-Ef; Tue, 18 Oct 2022 13:57:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: don't drop the queue reference in blk_mq_destroy_queue
Date:   Tue, 18 Oct 2022 15:57:16 +0200
Message-Id: <20221018135720.670094-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

currently blk_mq_destroy_queue not only shuts down the queue, but also
drops a queue references, which leads to the NVMe PCIe/Apple drivers and
scsi grabbing an extra references. Fix this to help with unifying more
code between the various NVMe drivers (and to make the code a little saner
even on it's own).

Diffstat:
 block/blk-mq.c            |    4 +---
 block/bsg-lib.c           |    2 ++
 drivers/nvme/host/apple.c |    8 --------
 drivers/nvme/host/core.c  |   10 ++++++++--
 drivers/nvme/host/pci.c   |    5 -----
 drivers/scsi/scsi_scan.c  |    1 -
 drivers/ufs/core/ufshcd.c |    2 ++
 7 files changed, 13 insertions(+), 19 deletions(-)
