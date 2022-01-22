Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242F3C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Jan 2022 11:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbiAVLLZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Jan 2022 06:11:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31132 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233972AbiAVLLZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Jan 2022 06:11:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642849884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=I3fIAsh23COYRzIAM+F+V2r54E6dpD4KEWjdqwp1PRo=;
        b=GAwLzuC5QPRmwOSZKneh2SMIgMYgtpQRGx7cxmu2ZmgTgHaW9J19N12p8p3H5yy3+0I58Y
        5Q/F9Y8G38suOOsEqfGO5etGCw7E+3E4YNv37SpC8ImFDl7SDzN2i+5TxaPnrU8oNg3Ifh
        2LmcKjMnoczN+K9/AQyyg2/SvlXeDJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-zLwqckbUNIeaNMQHoMkZdw-1; Sat, 22 Jan 2022 06:11:21 -0500
X-MC-Unique: zLwqckbUNIeaNMQHoMkZdw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E12141083F62;
        Sat, 22 Jan 2022 11:11:19 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E74F6D03F;
        Sat, 22 Jan 2022 11:11:06 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 00/13] block: don't drain file system I/O on del_gendisk
Date:   Sat, 22 Jan 2022 19:10:41 +0800
Message-Id: <20220122111054.1126146-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Draining FS I/O on del_gendisk() is added for just avoiding to refer to
recently added q->disk in IO path, and it isn't actually reliable:

1) queue freezing can't drain FS I/O for bio based driver, so blk-cgroup
shutdown can't be moved into del_gendisk()

2) freezing queue can't drain in-progress IO issue/dispatch activities,
so elevator shutdown can't be moved into del_gendisk()

3) the added flag of GD_DEAD may not be observed reliably in
__bio_queue_enter() because queue freezing might not imply rcu grace
period.

4) passthrough IO accounting code can refer to q->disk after disk is
released

When releasing disk, all FS IOs are guaranteed to be done, so this
patchset tries to shutdown elevator/blk-cgroup/rq qos there, then
referring to q->disk can be avoided after disk is released.

Also add flag of BLK_MQ_REQ_USER_IO for accounting passthrough IO
only if the IO is from userspace, since disk is live for user
passthrough IO.

V2:
	- take new approach to make current referring to q->disk reliable


Laibin Qiu (1):
  block/wbt: fix negative inflight counter when remove scsi device

Ming Lei (12):
  block: declare blkcg_[init|exit]_queue in private header
  block: move initialization of q->blkg_list into blkcg_init_queue
  block: move blkcg initialization/destroy into disk allocation/release
    handler
  block: only account passthrough IO from userspace
  block: don't remove hctx debugfs dir from blk_mq_exit_queue
  block: move q_usage_counter release into blk_queue_release
  block: export __blk_mq_unfreeze_queue
  scsi: force unfreezing queue into atomic mode
  block: add helper of disk_release_queue for release queue data for
    disk
  block: move blk_exit_queue into disk_release
  block: move rq_qos_exit() into disk_release()
  block: don't drain file system I/O on del_gendisk

 block/bfq-iosched.c        |  2 +
 block/blk-cgroup.c         |  2 +
 block/blk-core.c           | 31 ++++----------
 block/blk-mq.c             | 27 ++++++++++--
 block/blk-sysfs.c          | 25 +-----------
 block/blk.h                | 10 ++++-
 block/elevator.c           |  2 -
 block/genhd.c              | 84 +++++++++++++++++++++++++++-----------
 drivers/nvme/host/ioctl.c  |  2 +-
 drivers/scsi/scsi_ioctl.c  |  3 +-
 drivers/scsi/sd.c          |  2 +-
 include/linux/blk-cgroup.h |  4 --
 include/linux/blk-mq.h     |  3 ++
 include/linux/genhd.h      |  1 -
 14 files changed, 114 insertions(+), 84 deletions(-)

-- 
2.31.1

