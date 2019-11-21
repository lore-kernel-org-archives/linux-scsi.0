Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5869AC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 03:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C50D20721
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 03:26:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HTgUQf0X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfKUD0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 22:26:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:56681 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725819AbfKUD0r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Nov 2019 22:26:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574306807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cQo57OvllOj1Scw1RTZw9IIQS64qFwb9gLbMK5i9pC8=;
        b=HTgUQf0XcElO+p2rxtew7uHM9QmUl587OJNTkNRpkgOxyWcQnBvEtHqgzTkiSE++/ops3C
        V2w7oeOPjoZjTtsNgaAb8Nepl2mc2wFPZCLD2rZe2odHfeIRNt+3IhoS2pUsatyG7kmFz5
        SYLzGva8tAaPYNFsbzjabp1ngHHsANE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-cvUoLONnOHSjClRYX3PaSQ-1; Wed, 20 Nov 2019 22:26:43 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBF1C1005502;
        Thu, 21 Nov 2019 03:26:41 +0000 (UTC)
Received: from localhost (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81ED25D724;
        Thu, 21 Nov 2019 03:26:38 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Long Li <longli@microsoft.com>
Subject: [PATCH V3] scsi: core: only re-run queue in scsi_end_request() if device queue is busy
Date:   Thu, 21 Nov 2019 11:26:34 +0800
Message-Id: <20191121032634.32650-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: cvUoLONnOHSjClRYX3PaSQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now the request queue is run in scsi_end_request() unconditionally if both
target queue and host queue is ready. We should have re-run request queue
only after this device queue becomes busy for restarting this LUN only.

Recently Long Li reported that cost of run queue may be very heavy in
case of high queue depth. So improve this situation by only running
the request queue when this LUN is busy.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Long Li <longli@microsoft.com>
Reported-by: Long Li <longli@microsoft.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V3:
=09- add one smp_mb() in scsi_mq_get_budget() and comment

V2:
=09- commit log change, no any code change
=09- add reported-by tag


 drivers/scsi/scsi_lib.c    | 43 ++++++++++++++++++++++++++++++++++++--
 include/scsi/scsi_device.h |  1 +
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 379533ce8661..d3d237a09a78 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -607,12 +607,17 @@ static bool scsi_end_request(struct request *req, blk=
_status_t error,
 =09 */
 =09percpu_ref_get(&q->q_usage_counter);
=20
+=09/*
+=09 * One smp_mb() is implied by either rq->end_io or
+=09 * blk_mq_free_request for ordering writing .device_busy in
+=09 * scsi_device_unbusy() and reading sdev->restart.
+=09 */
 =09__blk_mq_end_request(req, error);
=20
 =09if (scsi_target(sdev)->single_lun ||
 =09    !list_empty(&sdev->host->starved_list))
 =09=09kblockd_schedule_work(&sdev->requeue_work);
-=09else
+=09else if (READ_ONCE(sdev->restart))
 =09=09blk_mq_run_hw_queues(q, true);
=20
 =09percpu_ref_put(&q->q_usage_counter);
@@ -1632,8 +1637,42 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx =
*hctx)
 =09struct request_queue *q =3D hctx->queue;
 =09struct scsi_device *sdev =3D q->queuedata;
=20
-=09if (scsi_dev_queue_ready(q, sdev))
+=09if (scsi_dev_queue_ready(q, sdev)) {
+=09=09WRITE_ONCE(sdev->restart, 0);
 =09=09return true;
+=09}
+
+=09/*
+=09 * If all in-flight requests originated from this LUN are completed
+=09 * before setting .restart, sdev->device_busy will be observed as
+=09 * zero, then blk_mq_delay_run_hw_queue() will dispatch this request
+=09 * soon. Otherwise, completion of one of these request will observe
+=09 * the .restart flag, and the request queue will be run for handling
+=09 * this request, see scsi_end_request().
+=09 *
+=09 * However, the .restart flag may be cleared from other dispatch code
+=09 * path after one inflight request is completed, then:
+=09 *
+=09 * 1) if this request is dispatched from scheduler queue or sw queue on=
e
+=09 * by one, this request will be handled in that dispatch path too given
+=09 * the request still stays at scheduler/sw queue when calling .get_budg=
et()
+=09 * callback.
+=09 *
+=09 * 2) if this request is dispatched from hctx->dispatch or
+=09 * blk_mq_flush_busy_ctxs(), this request will be put into hctx->dispat=
ch
+=09 * list soon, and blk-mq will be responsible for covering it, see
+=09 * blk_mq_dispatch_rq_list().
+=09 */
+=09WRITE_ONCE(sdev->restart, 1);
+
+=09/*
+=09 * Order writting .restart and reading .device_busy, and make sure
+=09 * .restart is visible to scsi_end_request(). Its pair is implied by
+=09 * __blk_mq_end_request() in scsi_end_request() for ordering
+=09 * writing .device_busy in scsi_device_unbusy() and reading .restart.
+=09 *
+=09 */
+=09smp_mb();
=20
 =09if (atomic_read(&sdev->device_busy) =3D=3D 0 && !scsi_device_blocked(sd=
ev))
 =09=09blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 202f4d6a4342..9d8ca662ae86 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -109,6 +109,7 @@ struct scsi_device {
 =09atomic_t device_busy;=09=09/* commands actually active on LLDD */
 =09atomic_t device_blocked;=09/* Device returned QUEUE_FULL. */
=20
+=09unsigned int restart;
 =09spinlock_t list_lock;
 =09struct list_head cmd_list;=09/* queue of in use SCSI Command structures=
 */
 =09struct list_head starved_entry;
--=20
2.20.1

