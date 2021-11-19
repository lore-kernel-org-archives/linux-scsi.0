Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AF0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A02E6117A
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 02:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhKSCWN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 21:22:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229830AbhKSCWN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Nov 2021 21:22:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637288351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=G3vphndXa84gadtSR/MBQRGNnIZdeiOYY+1xED06sog=;
        b=Qam5Zzwjy/m7uJEopveYGiPBXiQUbzCLrcVPMJZi1TJlZbAt6p84UcjXiS66Thb0tCD5AX
        RcB33VX6UvTYzZEUJs43HYZuCL6AOqbBfVPrkPCSPhL/0zOfBIEF0+mUs8qMpONHprbB7D
        cmqbSYJAxn+B8TjvApseqeTBhBG+JIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-QGfrQ-zzN_-l3982l7SRMQ-1; Thu, 18 Nov 2021 21:19:06 -0500
X-MC-Unique: QGfrQ-zzN_-l3982l7SRMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E884C180831C;
        Fri, 19 Nov 2021 02:19:03 +0000 (UTC)
Received: from localhost (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C94D74ABA9;
        Fri, 19 Nov 2021 02:18:57 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/5] blk-mq: quiesce improvement
Date:   Fri, 19 Nov 2021 10:18:44 +0800
Message-Id: <20211119021849.2259254-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

The 1st two patches moves srcu from blk_mq_hw_ctx to request_queue.

The other patches add one new helper for supporting quiesce in parallel.


Ming Lei (5):
  blk-mq: move srcu from blk_mq_hw_ctx to request_queue
  blk-mq: rename hctx_lock & hctx_unlock
  blk-mq: add helper of blk_mq_global_quiesce_wait()
  nvme: quiesce namespace queue in parallel
  scsi: use blk-mq quiesce APIs to implement scsi_host_block

 block/blk-core.c         | 23 +++++++++---
 block/blk-mq-sysfs.c     |  2 --
 block/blk-mq.c           | 78 +++++++++++++++++-----------------------
 block/blk-sysfs.c        |  3 +-
 block/blk.h              | 10 +++++-
 block/genhd.c            |  2 +-
 drivers/nvme/host/core.c |  9 +++--
 drivers/scsi/scsi_lib.c  | 16 ++++-----
 include/linux/blk-mq.h   | 21 ++++++-----
 include/linux/blkdev.h   |  8 +++++
 10 files changed, 98 insertions(+), 74 deletions(-)

-- 
2.31.1

