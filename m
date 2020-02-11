Return-Path: <SRS0=dbdl=37=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0837FC3F68F
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7ECE20842
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Feb 2020 12:13:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H1/fens4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgBKMNT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Feb 2020 07:13:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21497 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728636AbgBKMNT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Feb 2020 07:13:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581423197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lGle8YviHhSqfj5xdMLkG7vOyz0cc/hmzCbeLPotykM=;
        b=H1/fens4YuC3EcXZA1pPAEMkaxRoZ6IQCYjIasABQM1SgE35Yv9Qf0tjZ5+Oqwzwavcjk3
        DPzQFslaqxnZW4U3ZUUiaVdPegc6L9fYseAvpyIDj8XFrkB0vUWx0M660sD8nCd/17hOFq
        YvBl/ZwfOOsMXS9HvGlClVAgwtUM9Mg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-dKqwSRh-Pu-xR3tACoSoAQ-1; Tue, 11 Feb 2020 07:13:13 -0500
X-MC-Unique: dKqwSRh-Pu-xR3tACoSoAQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEEBE96B07;
        Tue, 11 Feb 2020 12:13:10 +0000 (UTC)
Received: from localhost (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7277690063;
        Tue, 11 Feb 2020 12:13:07 +0000 (UTC)
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
Subject: [PATCH 10/10] scsi: replace sdev->device_busy with sbitmap
Date:   Tue, 11 Feb 2020 20:11:35 +0800
Message-Id: <20200211121135.30064-11-ming.lei@redhat.com>
In-Reply-To: <20200211121135.30064-1-ming.lei@redhat.com>
References: <20200211121135.30064-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi uses one global atomic variable to track queue depth for each
LUN/request queue.

This way doesn't scale well when there is lots of CPU cores and the
disk is very fast. It has been observed that IOPS is affected a lot
by tracking queue depth via sdev->device_busy in IO path.

So replace the atomic variable sdev->device_busy with sbitmap for
tracking scsi device queue depth.

Test shows that IOPS difference is just ~1% compared with bypassing
device queue depth on scsi_debug by applying patches [1]. Meantime
IOPS is improved > 20% compared with linus tree.

Follows test steps:

1) test machine(32 logical CPU cores)
	Thread(s) per core:  2
	Core(s) per socket:  8
	Socket(s):           2
	NUMA node(s):        2
	Model name:          Intel(R) Xeon(R) CPU E5-2630 v3 @ 2.40GHz

2) setup scsi_debug:
modprobe scsi_debug virtual_gb=3D128 max_luns=3D1 submit_queues=3D32 dela=
y=3D0 max_queue=3D256

3) fio script:
fio --rw=3Drandread --size=3D128G --direct=3D1 --ioengine=3Dlibaio --iode=
pth=3D2048 \
	--numjobs=3D32 --bs=3D4k --group_reporting=3D1 --group_reporting=3D1 --r=
untime=3D60 \
	--loops=3D10000 --name=3Djob1 --filename=3D/dev/sdN

[1] https://lore.kernel.org/linux-block/20200119071432.18558-6-ming.lei@r=
edhat.com/

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
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi.c        |  2 ++
 drivers/scsi/scsi_lib.c    | 37 ++++++++++++++++++-------------------
 drivers/scsi/scsi_priv.h   |  1 +
 drivers/scsi/scsi_scan.c   | 21 +++++++++++++++++++--
 drivers/scsi/scsi_sysfs.c  |  2 ++
 include/scsi/scsi_cmnd.h   |  2 ++
 include/scsi/scsi_device.h |  5 +++--
 7 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 930e4803d888..5a97e0967e52 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -245,6 +245,8 @@ int scsi_change_queue_depth(struct scsi_device *sdev,=
 int depth)
 	if (sdev->request_queue)
 		blk_set_queue_depth(sdev->request_queue, depth);
=20
+	sbitmap_resize(&sdev->budget_map, sdev->queue_depth);
+
 	return sdev->queue_depth;
 }
 EXPORT_SYMBOL(scsi_change_queue_depth);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a3474b418602..e7fbf3a9a6aa 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -354,7 +354,7 @@ void scsi_device_unbusy(struct scsi_device *sdev, str=
uct scsi_cmnd *cmd)
 	if (starget->can_queue > 0)
 		atomic_dec(&starget->target_busy);
=20
-	atomic_dec(&sdev->device_busy);
+	sbitmap_put(&sdev->budget_map, cmd->budget_token);
 }
=20
 static void scsi_kick_queue(struct request_queue *q)
@@ -1274,19 +1274,17 @@ scsi_prep_state_check(struct scsi_device *sdev, s=
truct request *req)
 }
=20
 /*
- * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
- * return 0.
- *
- * Called with the queue_lock held.
+ * scsi_dev_queue_ready: if we can send requests to sdev, assign one tok=
en
+ * and return the token else return -1.
  */
 static inline int scsi_dev_queue_ready(struct request_queue *q,
 				  struct scsi_device *sdev)
 {
-	unsigned int busy;
+	int token;
=20
-	busy =3D atomic_inc_return(&sdev->device_busy) - 1;
+	token =3D sbitmap_get(&sdev->budget_map);
 	if (atomic_read(&sdev->device_blocked)) {
-		if (busy)
+		if (token >=3D 0)
 			goto out_dec;
=20
 		/*
@@ -1298,13 +1296,11 @@ static inline int scsi_dev_queue_ready(struct req=
uest_queue *q,
 				   "unblocking device at zero depth\n"));
 	}
=20
-	if (busy >=3D sdev->queue_depth)
-		goto out_dec;
-
-	return 1;
+	return token;
 out_dec:
-	atomic_dec(&sdev->device_busy);
-	return 0;
+	if (token >=3D 0)
+		sbitmap_put(&sdev->budget_map, token);
+	return -1;
 }
=20
 /*
@@ -1624,16 +1620,17 @@ static void scsi_mq_put_budget(struct blk_mq_hw_c=
tx *hctx, int budget_token)
 	struct request_queue *q =3D hctx->queue;
 	struct scsi_device *sdev =3D q->queuedata;
=20
-	atomic_dec(&sdev->device_busy);
+	sbitmap_put(&sdev->budget_map, budget_token);
 }
=20
 static int scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q =3D hctx->queue;
 	struct scsi_device *sdev =3D q->queuedata;
+	int token =3D scsi_dev_queue_ready(q, sdev);
=20
-	if (scsi_dev_queue_ready(q, sdev))
-		return 0;
+	if (token >=3D 0)
+		return token;
=20
 	if (scsi_device_busy(sdev) =3D=3D 0 && !scsi_device_blocked(sdev))
 		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
@@ -1677,6 +1674,8 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_=
ctx *hctx,
 		blk_mq_start_request(req);
 	}
=20
+	cmd->budget_token =3D bd->budget_token;
+
 	cmd->flags &=3D SCMD_PRESERVED_FLAGS;
 	if (sdev->simple_tags)
 		cmd->flags |=3D SCMD_TAGGED;
@@ -1701,12 +1700,12 @@ static blk_status_t scsi_queue_rq(struct blk_mq_h=
w_ctx *hctx,
 	if (scsi_target(sdev)->can_queue > 0)
 		atomic_dec(&scsi_target(sdev)->target_busy);
 out_put_budget:
-	scsi_mq_put_budget(hctx, 0);
+	scsi_mq_put_budget(hctx, bd->budget_token);
 	switch (ret) {
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-		if (atomic_read(&sdev->device_busy) ||
+		if (sbitmap_any_bit_set(&sdev->budget_map) ||
 		    scsi_device_blocked(sdev))
 			ret =3D BLK_STS_DEV_RESOURCE;
 		break;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 3bff9f7aa684..b934686aee32 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -5,6 +5,7 @@
 #include <linux/device.h>
 #include <linux/async.h>
 #include <scsi/scsi_device.h>
+#include <linux/sbitmap.h>
=20
 struct request_queue;
 struct request;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 058079f915f1..27b64c82d26b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -215,6 +215,7 @@ static void scsi_unlock_floptical(struct scsi_device =
*sdev,
 static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 					   u64 lun, void *hostdata)
 {
+	unsigned int depth;
 	struct scsi_device *sdev;
 	int display_failure_msg =3D 1, ret;
 	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
@@ -277,8 +278,23 @@ static struct scsi_device *scsi_alloc_sdev(struct sc=
si_target *starget,
 	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
 	sdev->request_queue->queuedata =3D sdev;
=20
-	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
-					sdev->host->cmd_per_lun : 1);
+	depth =3D sdev->host->cmd_per_lun ?: 1;
+
+	/*
+	 * Use .can_queue as budget map's depth because we have to
+	 * support adjusting queue depth from sysfs. Meantime use
+	 * default device queue depth to figure out sbitmap shift
+	 * since we use this queue depth most of times.
+	 */
+	if (sbitmap_init_node(&sdev->budget_map, sdev->host->can_queue,
+				sbitmap_calculate_shift(depth),
+				GFP_KERNEL, sdev->request_queue->node,
+				false, true)) {
+		put_device(&starget->dev);
+		kfree(sdev);
+	}
+
+	scsi_change_queue_depth(sdev, depth);
=20
 	scsi_sysfs_device_initialize(sdev);
=20
@@ -980,6 +996,7 @@ static int scsi_add_lun(struct scsi_device *sdev, uns=
igned char *inq_result,
 		scsi_attach_vpd(sdev);
=20
 	sdev->max_queue_depth =3D sdev->queue_depth;
+	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
 	sdev->sdev_bflags =3D *bflags;
=20
 	/*
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index d6cb5a0a03f2..835566b805fb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -466,6 +466,8 @@ static void scsi_device_dev_release_usercontext(struc=
t work_struct *work)
 	/* NULL queue means the device can't be used */
 	sdev->request_queue =3D NULL;
=20
+	sbitmap_free(&sdev->budget_map);
+
 	mutex_lock(&sdev->inquiry_mutex);
 	vpd_pg0 =3D rcu_replace_pointer(sdev->vpd_pg0, vpd_pg0,
 				       lockdep_is_held(&sdev->inquiry_mutex));
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a2849bb9cd19..e6f750f43889 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -76,6 +76,8 @@ struct scsi_cmnd {
=20
 	int eh_eflags;		/* Used by error handlr */
=20
+	int budget_token;
+
 	/*
 	 * This is set to jiffies as it was when the command was first
 	 * allocated.  It is used to time how long the command has
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 09caf6f2f528..cdc1f28ec57f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -8,6 +8,7 @@
 #include <linux/blkdev.h>
 #include <scsi/scsi.h>
 #include <linux/atomic.h>
+#include <linux/sbitmap.h>
=20
 struct device;
 struct request_queue;
@@ -106,7 +107,7 @@ struct scsi_device {
 	struct list_head    siblings;   /* list of all devices on this host */
 	struct list_head    same_target_siblings; /* just the devices sharing s=
ame target id */
=20
-	atomic_t device_busy;		/* commands actually active on LLDD */
+	struct sbitmap budget_map;
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
=20
 	spinlock_t list_lock;
@@ -586,7 +587,7 @@ static inline int scsi_device_supports_vpd(struct scs=
i_device *sdev)
=20
 static inline int scsi_device_busy(struct scsi_device *sdev)
 {
-	return atomic_read(&sdev->device_busy);
+	return sbitmap_weight(&sdev->budget_map);
 }
=20
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
--=20
2.20.1

