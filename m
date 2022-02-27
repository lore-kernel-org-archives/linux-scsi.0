Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73101C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Feb 2022 17:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiB0RW3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Feb 2022 12:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiB0RW2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Feb 2022 12:22:28 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62396C958;
        Sun, 27 Feb 2022 09:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=yvww6d8BmZb4do2L6Ohh8xyQjsnEZblD8cgs2zIraRw=; b=KLJ3tT23aPRViqtDTZBvy8cVYg
        +iEvRHSKb+UtCFu73ZWQ+7lv2YARvpLXrF+OALgcWPO6LqT0leZqwCfRZvJyi+pxjk9iMhOmZJcqV
        UuuSzSS9rDJyrjlyQZxn2a7S9lPZX+I1/n3wx/c0d4smE3LlYUD4+YbEgKua4iobtljbso5hBOyqQ
        wIx8a/cbdbszF6YkfxVs49OYU6+C7tBl90by9UbsF/n06ZFNWTQFUgwfGY80oL1WCJU4b5DUV3R5e
        Ekam5BjcBBbwuybcJnb97C5DhDnEPd4mk12GWvrhU7ijONm0uUj6CkgPpRcqQoiH9MZtEPcd2rWlb
        4bYur0vw==;
Received: from 91-118-163-82.static.upcbusiness.at ([91.118.163.82] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nONEy-009rxo-Pd; Sun, 27 Feb 2022 17:21:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: move more work to disk_release v2
Date:   Sun, 27 Feb 2022 18:21:30 +0100
Message-Id: <20220227172144.508118-1-hch@lst.de>
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

Git branch:

    git://git.infradead.org/users/hch/block.git freeze-5.18

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/freeze-5.18

Changes since v1:
 - fix a refcounting bug in sd
 - rename a function

Diffstat:
 block/blk-core.c           |    7 --
 block/blk-mq.c             |   10 +--
 block/blk-sysfs.c          |   25 --------
 block/blk.h                |    2 
 block/elevator.c           |    7 +-
 block/genhd.c              |   38 ++++++++++++-
 drivers/scsi/sd.c          |  114 +++++++++------------------------------
 drivers/scsi/sd.h          |   13 +++-
 drivers/scsi/sr.c          |  129 +++++++++------------------------------------
 drivers/scsi/sr.h          |    5 -
 drivers/scsi/st.c          |    1 
 drivers/scsi/st.h          |    1 
 include/scsi/scsi_cmnd.h   |    9 ---
 include/scsi/scsi_driver.h |    9 ++-
 14 files changed, 117 insertions(+), 253 deletions(-)
