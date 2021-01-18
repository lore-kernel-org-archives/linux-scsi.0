Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5CCC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 00:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCBE720758
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 00:51:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbhARAvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Jan 2021 19:51:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726785AbhARAvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Jan 2021 19:51:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610930974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uKTPKkbWKKs43FHOAwrPXpvzuXlilYeVA6FEjLjxVBY=;
        b=Br3NvHEW4tgllpY0FxdAKQd2kdSMdoyrmL9pLsrCdLOvS7JNhFZ2Vt1WXMzFB1EknExIUR
        DC300Sx7HYzTTsrpJVcu/MVE4fcfjdH3FMNkH0imXC+ynNSjHqK6yTMVszvkXQ3YXisShJ
        kNyVKZyalDvKQmyAUvAXwSf1WagIvnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-ksY0qSjlNzmAllCrH1juTg-1; Sun, 17 Jan 2021 19:49:32 -0500
X-MC-Unique: ksY0qSjlNzmAllCrH1juTg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B04A759;
        Mon, 18 Jan 2021 00:49:30 +0000 (UTC)
Received: from localhost (ovpn-12-73.pek2.redhat.com [10.72.12.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03E6C60BE2;
        Mon, 18 Jan 2021 00:49:26 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V6 00/13] blk-mq/scsi: tracking device queue depth via sbitmap
Date:   Mon, 18 Jan 2021 08:49:08 +0800
Message-Id: <20210118004921.202545-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

scsi uses one global atomic variable to track queue depth for each
LUN/request queue. This way can't scale well when there is lots of CPU
cores and the disk is very fast. Broadcom guys has complained that their
high end HBA can't reach top performance because .device_busy is
operated in IO path.

Replace the atomic variable sdev->device_busy with sbitmap for
tracking scsi device queue depth.

Test on scsi_debug shows this way improve IOPS > 20%. Meantime
the IOPS difference is just ~1% compared with bypassing .device_busy
on scsi_debug via patches[1]

The 1st 6 patches moves percpu allocation hint into sbitmap, since
the improvement by doing percpu allocation hint on sbitmap is observable.
Meantime export helpers for SCSI.

Patch 7 and 8 prepares for the conversion by returning budget token
from .get_budget callback, meantime passes the budget token to driver
via 'struct blk_mq_queue_data' in .queue_rq().

The last four patches changes SCSI for switching to track device queue
depth via sbitmap.

The patchset have been tested by Broadcom, and obvious performance boost
can be observed on megaraid_sas.

V6:
	- rebase on for-5.12/block

V5:
	- add comment on sbitmap_weight()
	- add patch 'megaraid_sas: v2 replace sdev_busy with local counter'
	  for fixing build failure

V4:
	- limit max sdev->queue_depth as max(1024, shost->can_queue)
	- simplify code for moving per-cpu allocation hint into sbitmap

V3:
	- rebase on both for-5.10/block and 5.10/scsi-queue.

V2:
	- fix one build failure


Kashyap Desai (1):
  megaraid_sas: v2 replace sdev_busy with local counter

Ming Lei (12):
  sbitmap: remove sbitmap_clear_bit_unlock
  sbitmap: maintain allocation round_robin in sbitmap
  sbitmap: add helpers for updating allocation hint
  sbitmap: move allocation hint into sbitmap
  sbitmap: export sbitmap_weight
  sbitmap: add helper of sbitmap_calculate_shift
  blk-mq: add callbacks for storing & retrieving budget token
  blk-mq: return budget token from .get_budget callback
  scsi: put hot fields of scsi_host_template into one cacheline
  scsi: add scsi_device_busy() to read sdev->device_busy
  scsi: make sure sdev->queue_depth is <= max(shost->can_queue, 1024)
  scsi: replace sdev->device_busy with sbitmap

 block/blk-mq-sched.c                        |  17 +-
 block/blk-mq.c                              |  38 ++--
 block/blk-mq.h                              |  25 ++-
 block/kyber-iosched.c                       |   3 +-
 drivers/message/fusion/mptsas.c             |   2 +-
 drivers/scsi/megaraid/megaraid_sas.h        |   2 +
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  44 +++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |   2 +-
 drivers/scsi/scsi.c                         |  13 ++
 drivers/scsi/scsi_lib.c                     |  67 ++++---
 drivers/scsi/scsi_priv.h                    |   3 +
 drivers/scsi/scsi_scan.c                    |  23 ++-
 drivers/scsi/scsi_sysfs.c                   |   4 +-
 drivers/scsi/sg.c                           |   2 +-
 include/linux/blk-mq.h                      |  13 +-
 include/linux/sbitmap.h                     |  85 +++++---
 include/scsi/scsi_cmnd.h                    |   2 +
 include/scsi/scsi_device.h                  |   8 +-
 include/scsi/scsi_host.h                    |  72 ++++---
 lib/sbitmap.c                               | 210 +++++++++++---------
 20 files changed, 426 insertions(+), 209 deletions(-)

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
-- 
2.28.0

