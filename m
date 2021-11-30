Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBE6C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 07:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbhK3Hld (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 02:41:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26719 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234337AbhK3Hld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Nov 2021 02:41:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638257893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=e/1Mag+F8KQJ58f082A5Q8YVtXiGqmrSDPEb2mtXctk=;
        b=Qfd+XoErVK0YS+rJBgrqJWzXaoV3a9CkXLTTW7UWn0VBHQXmL8dgQTsccfHSFvnuz9QPjf
        o+A2jib9TTjMMdEaH1xQAYdAOCkkRutHIRupdnr4UDwjrzyIfb4cUCp/abFW7ixtK9Sqhv
        DM69LLKhd9H4HAeqr2wiW210EuPCTck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-2QBow9tzOKCXWAL9RKdBxw-1; Tue, 30 Nov 2021 02:38:10 -0500
X-MC-Unique: 2QBow9tzOKCXWAL9RKdBxw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1D3B94EE0;
        Tue, 30 Nov 2021 07:38:08 +0000 (UTC)
Received: from localhost (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51B9A7944B;
        Tue, 30 Nov 2021 07:37:59 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>, Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 0/5] blk-mq: quiesce improvement
Date:   Tue, 30 Nov 2021 15:37:47 +0800
Message-Id: <20211130073752.3005936-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Guys,

The 1st patch removes hctx_lock and hctx_unlock, and optimize dispatch
code path a bit.

The 2nd patch moves srcu from blk_mq_hw_ctx to request_queue.

The other patches add one new helper for supporting quiesce in parallel.

V2:
	- add patch of 'remove hctx_lock and hctx_unlock'
	- replace ->alloc_srcu with queue flag, as suggested by Sagi

Ming Lei (5):
  blk-mq: remove hctx_lock and hctx_unlock
  blk-mq: move srcu from blk_mq_hw_ctx to request_queue
  blk-mq: add helper of blk_mq_shared_quiesce_wait()
  nvme: quiesce namespace queue in parallel
  scsi: use blk-mq quiesce APIs to implement scsi_host_block

 block/blk-core.c         |  27 +++++++--
 block/blk-mq-sysfs.c     |   2 -
 block/blk-mq.c           | 116 +++++++++++++--------------------------
 block/blk-sysfs.c        |   3 +-
 block/blk.h              |  10 +++-
 block/genhd.c            |   2 +-
 drivers/nvme/host/core.c |   9 ++-
 drivers/scsi/scsi_lib.c  |  16 +++---
 include/linux/blk-mq.h   |  21 ++++---
 include/linux/blkdev.h   |   9 +++
 10 files changed, 109 insertions(+), 106 deletions(-)

-- 
2.31.1

