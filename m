Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23D07C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 05:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbiCHFxG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 00:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiCHFxF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 00:53:05 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24641F68;
        Mon,  7 Mar 2022 21:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=xEoFMegp285+3kushkDTVGTV0J/N3oc85CKotN1+dMM=; b=vkoij6mllVAu9+rHziXTsjXB76
        dTNA4TgP/kD/V+XGr7XmY8VLNxPMWG+EvQhFIHYl65Qv9lmkJMvPsjisOB4BglLPIE9urY/CSk7SP
        2DsIkd2Dre0tCT4UE+tV8DHuOOIdqhrpHGcpXUiPWxX7fpBzVfWwMXpywmDZNzo+O1LPVTrhTyrkN
        /h0hfGf/VDFY9cmVMbRwqy8z/y7bzhNEXb7+lqeWY0cetX8G9T8DcoCrD1UrSYBQab3FMiEJN8eLO
        5a0pTaOtv8IKq5AFmx+8vbV1wRGhEM34n5sBdO5a1FpPzZIZgA+2404gClt/LSzR+/3Nr1k4xmhnw
        /ep4nZbg==;
Received: from [2001:4bb8:184:7746:6f50:7a98:3141:c37b] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nRSlO-002ikW-DP; Tue, 08 Mar 2022 05:52:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: move more work to disk_release v4
Date:   Tue,  8 Mar 2022 06:51:46 +0100
Message-Id: <20220308055200.735835-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

this series resurrects and forward ports ports larger parts of the
"block: don't drain file system I/O on del_gendisk" series from Ming,
but does not remove the draining in del_gendisk, but instead the one
in the sd driver, which always was a bit ad-hoc.  As part of that sd
and sr are switched to use the new ->free_disk method to avoid having
to clear disk->private_data and the way to lookup the SCSI ULP is
cleaned up as well.

The latest version only has cosmetic changes and plenty of rewiews and
should be ready to merge now.

Git branch:

    git://git.infradead.org/users/hch/block.git freeze-5.18

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/freeze-5.18

Changes since v3:
 - make use of existing local variables and helpers
 - update a few commit logs
 - better document the disk_dev in the sd driver

Changes since v2:
 - handle the weird dm-multipath flush sequence corner case when
   assinging rq->part

Changes since v1:
 - fix a refcounting bug in sd
 - rename a function

Diffstat:
 block/blk-core.c           |    7 --
 block/blk-mq.c             |   15 +++--
 block/blk-sysfs.c          |   25 --------
 block/blk.h                |    2 
 block/elevator.c           |    6 +-
 block/genhd.c              |   38 ++++++++++++-
 drivers/scsi/sd.c          |  114 +++++++++------------------------------
 drivers/scsi/sd.h          |   13 +++-
 drivers/scsi/sr.c          |  129 +++++++++------------------------------------
 drivers/scsi/sr.h          |    5 -
 drivers/scsi/st.c          |    1 
 drivers/scsi/st.h          |    1 
 include/scsi/scsi_cmnd.h   |    9 ---
 include/scsi/scsi_driver.h |    9 ++-
 14 files changed, 124 insertions(+), 250 deletions(-)
