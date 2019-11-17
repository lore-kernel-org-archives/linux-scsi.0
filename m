Return-Path: <SRS0=Zq1p=ZJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11F9C432C3
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 08:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7BD320730
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Nov 2019 08:10:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HswZZWrO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfKQIIh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 03:08:37 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52265 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725926AbfKQIIg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Nov 2019 03:08:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573978115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DR8HMY8/XR4MzGh5KVx73elVo86Kh5fuaikXaJJ4HH4=;
        b=HswZZWrOZxrfBAaV8M9XIrMif7CjD1bBZi+PiUx65oKHvC3WWeanURecEfe40xlIeUyL8f
        Nu8atx8i8LvYebReyyIGE2Xai1EVUcS82IBEI1qZ8Mo0TDWOV3o5+/Jsus34Vo5hPeka5Q
        F9NOZGFbjsMaopPtO5zei+TZbScgBTA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-KRpy08WHMs-fw3w-H9c_eA-1; Sun, 17 Nov 2019 03:08:31 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E37E801E76;
        Sun, 17 Nov 2019 08:08:29 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01E38100EBAA;
        Sun, 17 Nov 2019 08:08:25 +0000 (UTC)
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
        Long Li <longli@microsoft.com>, linux-block@vger.kernel.org
Subject: [PATCH] scsi: core: only re-run queue in scsi_end_request() if device queue is busy
Date:   Sun, 17 Nov 2019 16:08:18 +0800
Message-Id: <20191117080818.2664-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: KRpy08WHMs-fw3w-H9c_eA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now the requeue queue is run in scsi_end_request() unconditionally if both
target queue and host queue is ready. We should have re-run request queue
only after this device queue becomes busy for restarting this LUN only.

Recently Long Li reported that cost of run queue may be very heavy in
case of high queue depth. So improve this situation by only running
requesut queue when this LUN is busy.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-block@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 29 +++++++++++++++++++++++++++--
 include/scsi/scsi_device.h |  1 +
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 379533ce8661..212903d5f43c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -612,7 +612,7 @@ static bool scsi_end_request(struct request *req, blk_s=
tatus_t error,
 =09if (scsi_target(sdev)->single_lun ||
 =09    !list_empty(&sdev->host->starved_list))
 =09=09kblockd_schedule_work(&sdev->requeue_work);
-=09else
+=09else if (READ_ONCE(sdev->restart))
 =09=09blk_mq_run_hw_queues(q, true);
=20
 =09percpu_ref_put(&q->q_usage_counter);
@@ -1632,8 +1632,33 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx =
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
+=09 * 1) if this reqquest is dispatched from scheduler queue or sw queue o=
ne
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

