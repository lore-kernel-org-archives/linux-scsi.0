Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4E5C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 13:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C00063250
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 13:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238532AbhHPNkX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 09:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238345AbhHPNkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 09:40:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B08EC0A891A;
        Mon, 16 Aug 2021 06:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=WrmoQ8Kp3XO7sv0E/Vt68M24WtgLki2ksIFJXIBFGrE=; b=sKevCjd4WMSoqB+bP3aS+IEo7d
        nSLie8iOwyZEVhvTLgmVIGfcbxq2+KZbHtbvhKQCVaCX5t5IVbmowLoyzLOYEu5NrRX3gtAomlfyj
        PMTMFUuGH9lvbNOxrMVkLvoWR11oZN37yPhVRsh5M6jdVAOu6QSb3klEfGYwOlhtIQHUYndIdAoei
        WwvVAE1gUZgz+Wz4Q4jlAxMORhgriM8G0XubGpA516e06UzoOK73UrFvHmDPsT2cSRBZADcBAj7e7
        5+PFktdSB6e9MyiLZD6YHkM6E/nOPseaUzhmWZEP6nwpbJRmypdh66FCcZciU+NLCksusRDnwB4+O
        D/EolM0A==;
Received: from [2001:4bb8:188:1b1:3731:604a:a6cd:dc60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFcWG-001OSC-41; Mon, 16 Aug 2021 13:19:23 +0000
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
Subject: ensure each gendisk always has a request_queue reference v2
Date:   Mon, 16 Aug 2021 15:19:01 +0200
Message-Id: <20210816131910.615153-1-hch@lst.de>
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

Changes since v1:
 - rebased to the latest for-5.15/block tree to fix minor conflicts
 - add a new patch to fix to fix a queue to disk look issue exposed
   by the bdi move

Diffstat:
 block/bfq-iosched.c             |    2 -
 block/blk-cgroup.c              |    4 +--
 block/blk-mq.c                  |    8 +++---
 block/blk-settings.c            |    8 +++---
 block/blk-sysfs.c               |   13 ++++------
 block/blk-wbt.c                 |   10 ++++----
 block/genhd.c                   |   32 ++++++++++++--------------
 drivers/nvme/host/core.c        |   33 ++++++++++----------------
 drivers/s390/block/dasd_genhd.c |    7 ++++-
 drivers/scsi/sd.c               |    6 +++-
 drivers/scsi/sg.c               |   32 +++++++-------------------
 drivers/scsi/sr.c               |    7 ++++-
 drivers/scsi/st.c               |   49 +++++++++-------------------------------
 drivers/scsi/st.h               |    2 -
 include/linux/blk-mq.h          |   10 ++------
 include/linux/blkdev.h          |    5 +---
 include/linux/genhd.h           |   30 +++---------------------
 include/trace/events/kyber.h    |    6 ++--
 18 files changed, 98 insertions(+), 166 deletions(-)
