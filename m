Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3A8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 14:15:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbiBVOPX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiBVOPW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 09:15:22 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A12123BDD;
        Tue, 22 Feb 2022 06:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=IK87WZrhn0r3vKC5FCygifvVB6T195CFnv3iTlwTKtE=; b=2gynWaw4YmHZLcT8LSV26hHufl
        sF0T5webQKV+t4QT2miaGjDoo4+OOXZIXOEyY3zlS5Cu7r2EKmdrpc7zgg1G+kTnUjvDVWmiEaxWO
        8bpk/iBFxDLzvImTJsLX4qhri55WTeLXBsTlHtqt2pG8xEhwJF8VwdOeyCh7DjcjH2rlmyiyN4mJC
        q0zoWwpqf0o+JqfH0ves1XSBrkPjADGR1mA+9RWjGoGokw2W0UpVUivRgnQjM6fVbHGVZburmimQ1
        nZRE9MbtqQHaULGjor9TaAwbZXojJDuW+kYf164j5UGDuhcIQT9AdOT5LzB7oidvmNLDgcGiRjsO4
        9gcWY1tg==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMVwK-009qAw-43; Tue, 22 Feb 2022 14:14:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: move more work to disk_release
Date:   Tue, 22 Feb 2022 15:14:38 +0100
Message-Id: <20220222141450.591193-1-hch@lst.de>
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


Diffstat:
 block/blk-core.c           |    7 --
 block/blk-mq.c             |   10 +--
 block/blk-sysfs.c          |   25 --------
 block/blk.h                |    2 
 block/elevator.c           |    7 +-
 block/genhd.c              |   43 ++++++++++++++-
 drivers/scsi/sd.c          |   95 +++++----------------------------
 drivers/scsi/sd.h          |    3 -
 drivers/scsi/sr.c          |  129 +++++++++------------------------------------
 drivers/scsi/sr.h          |    5 -
 drivers/scsi/st.c          |    1 
 drivers/scsi/st.h          |    1 
 include/scsi/scsi_cmnd.h   |    9 ---
 include/scsi/scsi_driver.h |    9 ++-
 14 files changed, 104 insertions(+), 242 deletions(-)
