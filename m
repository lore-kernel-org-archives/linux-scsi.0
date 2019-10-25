Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218A6CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 06:59:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7CFE20867
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 06:59:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W7Win6El"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405410AbfJYG7O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 02:59:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24011 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727595AbfJYG7O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 02:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571986751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rwsR/jQJT53gvOM2s5Cbzhtw3INeke6IGNbLJzNjgsk=;
        b=W7Win6EljEhesTe0WvYZMt3/MbiTXrpe6FPYcsRCJPnJF0SzYD3TVv4M4TAQMQWXwC17tR
        SJjQ9bCHYEyy/agMPU2+qbwkYzqGluLui1Ej5iy19uhQ8GskdkG5BQ6SUF/52aqgwCf8W1
        VvM23ly6r2ExOhx/CV2XegPXEfD0nRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-3Mubj1xZM-2vxTXBesLrmg-1; Fri, 25 Oct 2019 02:59:08 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 020C2107AD31;
        Fri, 25 Oct 2019 06:59:07 +0000 (UTC)
Received: from localhost (ovpn-8-32.pek2.redhat.com [10.72.8.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1AF2160BF3;
        Fri, 25 Oct 2019 06:59:02 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH V5] scsi: core: avoid host-wide host_busy counter for scsi_mq
Date:   Fri, 25 Oct 2019 14:58:55 +0800
Message-Id: <20191025065855.6309-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 3Mubj1xZM-2vxTXBesLrmg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It isn't necessary to check the host depth in scsi_queue_rq() any more
since it has been respected by blk-mq before calling scsi_queue_rq() via
getting driver tag.

Lots of LUNs may attach to same host and per-host IOPS may reach millions,
so we should avoid expensive atomic operations on the host-wide counter in
the IO path.

This patch implements scsi_host_busy() via blk_mq_tagset_busy_iter()
with one scsi command state for reading the count of busy IOs for scsi_mq.

It is observed that IOPS is increased by 15% in IO test on scsi_debug (32
LUNs, 32 submit queues, 1024 can_queue, libaio/dio) in a dual-socket
system.

V5:
=09- fix document on .can_queue, no code change

V4:
        - fix one build waring, just a line change in scsi_dev_queue_ready(=
)

V3:
        - use non-atomic set/clear bit operations as suggested by Bart
        - kill single field struct for storing count of in-flight requests
        - add patch to bypass the atomic LUN-wide counter of device_busy
        for fast SSD device

V2:
=09- introduce SCMD_STATE_INFLIGHT for getting accurate host busy
=09via blk_mq_tagset_busy_iter()
=09- verified that original Jens's report[1] is fixed
=09- verified that SCSI timeout/abort works fine

[1] https://www.spinics.net/lists/linux-scsi/msg122867.html
[2] V1 & its revert:

d772a65d8a6c Revert "scsi: core: avoid host-wide host_busy counter for scsi=
_mq"
23aa8e69f2c6 Revert "scsi: core: fix scsi_host_queue_ready"
265d59aacbce scsi: core: fix scsi_host_queue_ready
328728630d9f scsi: core: avoid host-wide host_busy counter for scsi_mq

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Omar Sandoval <osandov@fb.com>,
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hosts.c     | 19 ++++++++++++++++-
 drivers/scsi/scsi.c      |  2 +-
 drivers/scsi/scsi_lib.c  | 45 ++++++++++++++++++++--------------------
 drivers/scsi/scsi_priv.h |  2 +-
 include/scsi/scsi_cmnd.h |  1 +
 include/scsi/scsi_host.h |  3 +--
 6 files changed, 44 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 55522b7162d3..1d669e47b692 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -38,6 +38,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
+#include <scsi/scsi_cmnd.h>
=20
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -554,13 +555,29 @@ struct Scsi_Host *scsi_host_get(struct Scsi_Host *sho=
st)
 }
 EXPORT_SYMBOL(scsi_host_get);
=20
+static bool scsi_host_check_in_flight(struct request *rq, void *data,
+=09=09=09=09      bool reserved)
+{
+=09int *count =3D data;
+=09struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
+
+=09if (test_bit(SCMD_STATE_INFLIGHT, &cmd->state))
+=09=09(*count)++;
+
+=09return true;
+}
+
 /**
  * scsi_host_busy - Return the host busy counter
  * @shost:=09Pointer to Scsi_Host to inc.
  **/
 int scsi_host_busy(struct Scsi_Host *shost)
 {
-=09return atomic_read(&shost->host_busy);
+=09int cnt =3D 0;
+
+=09blk_mq_tagset_busy_iter(&shost->tag_set,
+=09=09=09=09scsi_host_check_in_flight, &cnt);
+=09return cnt;
 }
 EXPORT_SYMBOL(scsi_host_busy);
=20
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1f5b5c8a7f72..ddc4ec6ea2a1 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -186,7 +186,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 =09struct scsi_driver *drv;
 =09unsigned int good_bytes;
=20
-=09scsi_device_unbusy(sdev);
+=09scsi_device_unbusy(sdev, cmd);
=20
 =09/*
 =09 * Clear the flags that say that the device/target/host is no longer
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index dc210b9d4896..2563b061f56b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -189,7 +189,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, =
int reason, bool unbusy)
 =09 * active on the host/device.
 =09 */
 =09if (unbusy)
-=09=09scsi_device_unbusy(device);
+=09=09scsi_device_unbusy(device, cmd);
=20
 =09/*
 =09 * Requeue this command.  It will go before all other commands
@@ -321,20 +321,20 @@ static void scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 }
=20
 /*
- * Decrement the host_busy counter and wake up the error handler if necess=
ary.
- * Avoid as follows that the error handler is not woken up if shost->host_=
busy
- * =3D=3D shost->host_failed: use call_rcu() in scsi_eh_scmd_add() in comb=
ination
- * with an RCU read lock in this function to ensure that this function in =
its
- * entirety either finishes before scsi_eh_scmd_add() increases the
+ * Wake up the error handler if necessary. Avoid as follows that the error
+ * handler is not woken up if host in-flight requests number =3D=3D
+ * shost->host_failed: use call_rcu() in scsi_eh_scmd_add() in combination
+ * with an RCU read lock in this function to ensure that this function in
+ * its entirety either finishes before scsi_eh_scmd_add() increases the
  * host_failed counter or that it notices the shost state change made by
  * scsi_eh_scmd_add().
  */
-static void scsi_dec_host_busy(struct Scsi_Host *shost)
+static void scsi_dec_host_busy(struct Scsi_Host *shost, struct scsi_cmnd *=
cmd)
 {
 =09unsigned long flags;
=20
 =09rcu_read_lock();
-=09atomic_dec(&shost->host_busy);
+=09__clear_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 =09if (unlikely(scsi_host_in_recovery(shost))) {
 =09=09spin_lock_irqsave(shost->host_lock, flags);
 =09=09if (shost->host_failed || shost->host_eh_scheduled)
@@ -344,12 +344,12 @@ static void scsi_dec_host_busy(struct Scsi_Host *shos=
t)
 =09rcu_read_unlock();
 }
=20
-void scsi_device_unbusy(struct scsi_device *sdev)
+void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 {
 =09struct Scsi_Host *shost =3D sdev->host;
 =09struct scsi_target *starget =3D scsi_target(sdev);
=20
-=09scsi_dec_host_busy(shost);
+=09scsi_dec_host_busy(shost, cmd);
=20
 =09if (starget->can_queue > 0)
 =09=09atomic_dec(&starget->target_busy);
@@ -430,9 +430,6 @@ static inline bool scsi_target_is_busy(struct scsi_targ=
et *starget)
=20
 static inline bool scsi_host_is_busy(struct Scsi_Host *shost)
 {
-=09if (shost->can_queue > 0 &&
-=09    atomic_read(&shost->host_busy) >=3D shost->can_queue)
-=09=09return true;
 =09if (atomic_read(&shost->host_blocked) > 0)
 =09=09return true;
 =09if (shost->host_self_blocked)
@@ -1139,6 +1136,7 @@ void scsi_init_command(struct scsi_device *dev, struc=
t scsi_cmnd *cmd)
 =09unsigned int flags =3D cmd->flags & SCMD_PRESERVED_FLAGS;
 =09unsigned long jiffies_at_alloc;
 =09int retries;
+=09bool in_flight;
=20
 =09if (!blk_rq_is_scsi(rq) && !(flags & SCMD_INITIALIZED)) {
 =09=09flags |=3D SCMD_INITIALIZED;
@@ -1147,6 +1145,7 @@ void scsi_init_command(struct scsi_device *dev, struc=
t scsi_cmnd *cmd)
=20
 =09jiffies_at_alloc =3D cmd->jiffies_at_alloc;
 =09retries =3D cmd->retries;
+=09in_flight =3D test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 =09/* zero out the cmd, except for the embedded scsi_request */
 =09memset((char *)cmd + sizeof(cmd->req), 0,
 =09=09sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
@@ -1158,6 +1157,8 @@ void scsi_init_command(struct scsi_device *dev, struc=
t scsi_cmnd *cmd)
 =09INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 =09cmd->jiffies_at_alloc =3D jiffies_at_alloc;
 =09cmd->retries =3D retries;
+=09if (in_flight)
+=09=09__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
=20
 =09scsi_add_cmd_to_list(cmd);
 }
@@ -1367,16 +1368,14 @@ static inline int scsi_target_queue_ready(struct Sc=
si_Host *shost,
  */
 static inline int scsi_host_queue_ready(struct request_queue *q,
 =09=09=09=09   struct Scsi_Host *shost,
-=09=09=09=09   struct scsi_device *sdev)
+=09=09=09=09   struct scsi_device *sdev,
+=09=09=09=09   struct scsi_cmnd *cmd)
 {
-=09unsigned int busy;
-
 =09if (scsi_host_in_recovery(shost))
 =09=09return 0;
=20
-=09busy =3D atomic_inc_return(&shost->host_busy) - 1;
 =09if (atomic_read(&shost->host_blocked) > 0) {
-=09=09if (busy)
+=09=09if (scsi_host_busy(shost) > 0)
 =09=09=09goto starved;
=20
 =09=09/*
@@ -1390,8 +1389,6 @@ static inline int scsi_host_queue_ready(struct reques=
t_queue *q,
 =09=09=09=09     "unblocking host at zero depth\n"));
 =09}
=20
-=09if (shost->can_queue > 0 && busy >=3D shost->can_queue)
-=09=09goto starved;
 =09if (shost->host_self_blocked)
 =09=09goto starved;
=20
@@ -1403,6 +1400,8 @@ static inline int scsi_host_queue_ready(struct reques=
t_queue *q,
 =09=09spin_unlock_irq(shost->host_lock);
 =09}
=20
+=09__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
+
 =09return 1;
=20
 starved:
@@ -1411,7 +1410,7 @@ static inline int scsi_host_queue_ready(struct reques=
t_queue *q,
 =09=09list_add_tail(&sdev->starved_entry, &shost->starved_list);
 =09spin_unlock_irq(shost->host_lock);
 out_dec:
-=09scsi_dec_host_busy(shost);
+=09scsi_dec_host_busy(shost, cmd);
 =09return 0;
 }
=20
@@ -1665,7 +1664,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ct=
x *hctx,
 =09ret =3D BLK_STS_RESOURCE;
 =09if (!scsi_target_queue_ready(shost, sdev))
 =09=09goto out_put_budget;
-=09if (!scsi_host_queue_ready(q, shost, sdev))
+=09if (!scsi_host_queue_ready(q, shost, sdev, cmd))
 =09=09goto out_dec_target_busy;
=20
 =09if (!(req->rq_flags & RQF_DONTPREP)) {
@@ -1697,7 +1696,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ct=
x *hctx,
 =09return BLK_STS_OK;
=20
 out_dec_host_busy:
-=09scsi_dec_host_busy(shost);
+=09scsi_dec_host_busy(shost, cmd);
 out_dec_target_busy:
 =09if (scsi_target(sdev)->can_queue > 0)
 =09=09atomic_dec(&scsi_target(sdev)->target_busy);
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index cc2859d76d81..3bff9f7aa684 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -87,7 +87,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd);
 extern void scsi_add_cmd_to_list(struct scsi_cmnd *cmd);
 extern void scsi_del_cmd_from_list(struct scsi_cmnd *cmd);
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
-extern void scsi_device_unbusy(struct scsi_device *sdev);
+extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd =
*cmd);
 extern void scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 91bd749a02f7..9c22e85902ec 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -63,6 +63,7 @@ struct scsi_pointer {
=20
 /* for scmd->state */
 #define SCMD_STATE_COMPLETE=090
+#define SCMD_STATE_INFLIGHT=091
=20
 struct scsi_cmnd {
 =09struct scsi_request req;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 31e0d6ca1eba..d4452d0ea3c7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -345,7 +345,7 @@ struct scsi_host_template {
 =09/*
 =09 * This determines if we will use a non-interrupt driven
 =09 * or an interrupt driven scheme.  It is set to the maximum number
-=09 * of simultaneous commands a given host adapter will accept.
+=09 * of simultaneous commands a single hw queue in HBA will accept.
 =09 */
 =09int can_queue;
=20
@@ -551,7 +551,6 @@ struct Scsi_Host {
 =09/* Area to keep a shared tag map */
 =09struct blk_mq_tag_set=09tag_set;
=20
-=09atomic_t host_busy;=09=09   /* commands actually active on low-level */
 =09atomic_t host_blocked;
=20
 =09unsigned int host_failed;=09   /* commands that failed.
--=20
2.20.1

