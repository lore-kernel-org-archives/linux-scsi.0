Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E45C352A3
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644922082F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:12:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="afLGfgzi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgBKMMA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 07:12:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58367 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728294AbgBKML7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Feb 2020 07:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581423118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=V+9xBTZc7bbwJTMVnkz3jGlnFUdab8OBec7wzgQHg/M=;
        b=afLGfgzihNLaK7LNqB83JWyZg5WottUzJTRo/mxBNJCtw/JeRdd57AeYxx79QIlIaWFrqf
        rXjCKDjL1yWwp7mVnN9UgckbrmvKnI0TaSw5ichZsbZ1gQsleEepstnItz0PPFSgCinYp/
        7I8WA1W+R5LcsoGSElDnezg+ZtMnNZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-gxJknGH-PsSc104LB1CEug-1; Tue, 11 Feb 2020 07:11:52 -0500
X-MC-Unique: gxJknGH-PsSc104LB1CEug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD3FB8017CC;
        Tue, 11 Feb 2020 12:11:49 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E2E05C1D6;
        Tue, 11 Feb 2020 12:11:45 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@fb.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 00/10] scsi: tracking device queue depth via sbitmap
Date:   Tue, 11 Feb 2020 20:11:25 +0800
Message-Id: <20200211121135.30064-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
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

The last two patches changes SCSI for switching to track device queue
depth via sbitmap.

Broadcom Guys, please test this patchset and see if expected performance
can be reached.

Please comment and review!

thanks,
Ming


[1] https://lore.kernel.org/linux-block/20200119071432.18558-6-ming.lei@r=
edhat.com/

Ming Lei (10):
  sbitmap: maintain allocation round_robin in sbitmap
  sbitmap: add helpers for updating allocation hint
  sbitmap: remove sbitmap_clear_bit_unlock
  sbitmap: move allocation hint into sbitmap
  sbitmap: export sbitmap_weight
  sbitmap: add helper of sbitmap_calculate_shift
  blk-mq: return budget token from .get_budget callback
  blk-mq: pass budget token to dirver via blk_mq_queue_data
  scsi: add scsi_device_busy() to read sdev->device_busy
  scsi: replace sdev->device_busy with sbitmap

 block/blk-mq-sched.c                 |  20 ++-
 block/blk-mq.c                       |  37 +++--
 block/blk-mq.h                       |  11 +-
 block/kyber-iosched.c                |   3 +-
 drivers/dma/idxd/device.c            |   2 +-
 drivers/dma/idxd/submit.c            |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   2 +-
 drivers/scsi/scsi.c                  |   2 +
 drivers/scsi/scsi_lib.c              |  47 +++---
 drivers/scsi/scsi_priv.h             |   1 +
 drivers/scsi/scsi_scan.c             |  21 ++-
 drivers/scsi/scsi_sysfs.c            |   4 +-
 drivers/scsi/sg.c                    |   2 +-
 include/linux/blk-mq.h               |   5 +-
 include/linux/sbitmap.h              |  84 +++++++----
 include/scsi/scsi_cmnd.h             |   2 +
 include/scsi/scsi_device.h           |   8 +-
 lib/sbitmap.c                        | 213 +++++++++++++++------------
 18 files changed, 285 insertions(+), 181 deletions(-)

Cc: Omar Sandoval <osandov@fb.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
--=20
2.20.1

