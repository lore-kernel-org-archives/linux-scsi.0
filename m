Return-Path: <SRS0=SJ7r=DA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3734FC4727D
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 01:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0A422395C
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Sep 2020 01:33:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wokdz69e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgIWBd7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 21:33:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726685AbgIWBd6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Sep 2020 21:33:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600824837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WZsa2J1lbITIf4ZEunkyJeKTHGH9lL5atd3ZfUlUbVE=;
        b=Wokdz69ep7ZlMKp6YJ7zRaMwV5UL5WbVH+kFfNwB3Uyd7qw8totpmDPE0rYCsIuIRH+nRI
        vB0HAnywTK4EqPXsVCDHK+ogNDCXLpSIfAkTkTcAKr6JxEHjaFdtJ67gn8ZXu6LNmOq3DJ
        nyan/2Yw5nXFBP/UjZIoAuEYzo0RP7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-raePR-ECPwe0fp_E-AQzfQ-1; Tue, 22 Sep 2020 21:33:53 -0400
X-MC-Unique: raePR-ECPwe0fp_E-AQzfQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 792A81074641;
        Wed, 23 Sep 2020 01:33:51 +0000 (UTC)
Received: from localhost (ovpn-12-168.pek2.redhat.com [10.72.12.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F234F614F5;
        Wed, 23 Sep 2020 01:33:46 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH V3 for 5.11 00/12] blk-mq/scsi: tracking device queue depth via sbitmap
Date:   Wed, 23 Sep 2020 09:33:27 +0800
Message-Id: <20200923013339.1621784-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
can be observed.

Given it is based on both for-5.10/block and 5.10/scsi-queue, the target
is for v5.11. And it is posted out just for getting full/enough review.

Please comment and review!

V3:
	- rebase on both for-5.10/block and 5.10/scsi-queue.

V2:
	- fix one build failure


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
  scsi: make sure sdev->queue_depth is <= shost->can_queue
  scsi: replace sdev->device_busy with sbitmap

 block/blk-mq-sched.c                 |  17 ++-
 block/blk-mq.c                       |  38 +++--
 block/blk-mq.h                       |  25 +++-
 block/kyber-iosched.c                |   3 +-
 drivers/message/fusion/mptsas.c      |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   2 +-
 drivers/scsi/scsi.c                  |   4 +
 drivers/scsi/scsi_lib.c              |  69 ++++++---
 drivers/scsi/scsi_priv.h             |   1 +
 drivers/scsi/scsi_scan.c             |  22 ++-
 drivers/scsi/scsi_sysfs.c            |   4 +-
 drivers/scsi/sg.c                    |   2 +-
 include/linux/blk-mq.h               |  13 +-
 include/linux/sbitmap.h              |  84 +++++++----
 include/scsi/scsi_cmnd.h             |   2 +
 include/scsi/scsi_device.h           |   8 +-
 include/scsi/scsi_host.h             |  72 ++++-----
 lib/sbitmap.c                        | 213 +++++++++++++++------------
 18 files changed, 376 insertions(+), 205 deletions(-)

Cc: Omar Sandoval <osandov@fb.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>

-- 
2.25.2

