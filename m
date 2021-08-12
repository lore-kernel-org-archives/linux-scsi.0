Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18D5C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBB1660FC4
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234648AbhHLHss (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbhHLHss (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 03:48:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEA6C061765;
        Thu, 12 Aug 2021 00:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=B4RfsAuEaf/XY8TwrKDqgJkTJwlrQq1GUBTudpvyGbs=; b=CuF15s7J55bvbBZtk4F3Bj1I75
        tvhuMDSR3PEce6l3vQ3HaQcHl64Suzbnoc/mJHbRS5fMyACOEXLmrDHsy5kYALzvKFY0W/0Y6qM+B
        hRJI7qha0ruw9oObhmz3L/XDlWtNTrVSurH8Z20TST2NzBlvzU5y/4oV0lREaZPdBSLAzrrcYWXIk
        kuQMqTx1Xt4KLEeSNujUzqayatrevZMEz5is6+7dg4JzAYlbEKnh24zoqgKZqfM8XfHUyj2V/I6R8
        F2DQYufqV8ovxmlHFFtohA0ciX3XYJE6JaB3K+HFAPQwcDmDzLvqHoHQc7fMGX5WW32so2uzMnM/a
        ZX2csPtw==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE5QI-00EIjT-V7; Thu, 12 Aug 2021 07:47:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: ensure each gendisk always has a request_queue reference
Date:   Thu, 12 Aug 2021 09:46:34 +0200
Message-Id: <20210812074642.18592-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

this is the final batch of the gendisk interface cleanup series.  This
remove the last uses of the legacy alloc_disk interface and ensures we
always have a request_queue reference for a gendisk.

Diffstat:
 block/blk-mq.c                  |    6 ++--
 block/genhd.c                   |   31 ++++++++++---------------
 drivers/nvme/host/core.c        |   33 ++++++++++----------------
 drivers/s390/block/dasd_genhd.c |    7 ++++-
 drivers/scsi/sd.c               |    6 +++-
 drivers/scsi/sg.c               |   32 +++++++-------------------
 drivers/scsi/sr.c               |    7 ++++-
 drivers/scsi/st.c               |   49 +++++++++-------------------------------
 drivers/scsi/st.h               |    2 -
 include/linux/blk-mq.h          |   10 ++------
 include/linux/genhd.h           |   30 +++---------------------
 11 files changed, 72 insertions(+), 141 deletions(-)
