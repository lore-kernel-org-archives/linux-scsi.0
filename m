Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F266AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 16:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbiCDQEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 11:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiCDQEe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 11:04:34 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61A013D90F;
        Fri,  4 Mar 2022 08:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=lA+6ePXKiQ9floEuIP5ejvrnMT+UHuJ0JLlo/pBvA4I=; b=gnnEDakvzDp7H1xOPMA/na6RFx
        0eHNYmjS+RLvVGki0i/Mre0qAqmHkwQ+ExKEhp4+MA0pA6OOc1zrIoAAMXyOnl5nRtXVbpYKr/Oqr
        1u/fjLmzn1fl3zf2EWIM5z1A3E30CVb/be9FMAIKEmId+8EwIkOwq8ILMYFAt9k0OSCWhjKryzF+u
        oe2lifJBr7uOAEJ85Vq9NqNmi23Ce3cKrSlDDhEy4eyeEkaSjFQ4N3JRrBMDXARSqurVjRukdEwd/
        GbvO/GSxYrN8xc0WhUoRn5PIJ0dJUtXIKnEoWHG347XJFHVfe/hzIQpUnFmSsmsdJvoQaxhcGMMMz
        V9kOMZcA==;
Received: from [2001:4bb8:180:5296:7360:567:acd5:aaa2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nQAOz-00Atyj-QQ; Fri, 04 Mar 2022 16:03:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: move more work to disk_release v3
Date:   Fri,  4 Mar 2022 17:03:17 +0100
Message-Id: <20220304160331.399757-1-hch@lst.de>
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

Changes since v2:
 - handle the weird dm-multipath flush sequence corner case when
   assinging rq->part

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
