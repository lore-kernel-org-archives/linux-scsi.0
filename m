From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 09/12] SRP transport: Move queuecommand() wait code to SCSI
 core
Date: Wed, 26 Oct 2016 15:55:00 -0700
Message-ID: <e86cdaf9-6305-d2cb-6068-0a050c023d73@sandisk.com>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Additionally, rename srp_wait_for_queuecommand() into
scsi_wait_for_queuecommand() and add a comment about the
queuecommand() call from scsi_send_eh_cmnd().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Doug Ledford <dledford@redhat.com>
---
 drivers/scsi/scsi_lib.c           | 41 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_transport_srp.c | 35 ++-------------------------------
 include/scsi/scsi_host.h          |  1 +
 3 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ab5b06f..c1561e7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2722,6 +2722,47 @@ void sdev_evt_send_simple(struct scsi_device *sdev,
 EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
 
 /**
+ * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
+ * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
+ *
+ * To do: add support for scsi-mq in this function.
+ */
+static int scsi_request_fn_active(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	struct request_queue *q;
+	int request_fn_active = 0;
+
+	shost_for_each_device(sdev, shost) {
+		q = sdev->request_queue;
+
+		spin_lock_irq(q->queue_lock);
+		request_fn_active += q->request_fn_active;
+		spin_unlock_irq(q->queue_lock);
+	}
+
+	return request_fn_active;
+}
+
+/**
+ * scsi_wait_for_queuecommand() - wait for ongoing queuecommand() calls
+ * @shost: SCSI host pointer.
+ *
+ * Wait until the ongoing shost->hostt->queuecommand() calls that are
+ * invoked from scsi_request_fn() have finished.
+ *
+ * To do: avoid that scsi_send_eh_cmnd() calls queuecommand() after
+ * scsi_internal_device_block() has blocked a SCSI device and remove and also
+ * remove the rport mutex lock and unlock calls from srp_queuecommand().
+ */
+void scsi_wait_for_queuecommand(struct Scsi_Host *shost)
+{
+	while (scsi_request_fn_active(shost))
+		msleep(20);
+}
+EXPORT_SYMBOL(scsi_wait_for_queuecommand);
+
+/**
  *	scsi_device_quiesce - Block user issued commands.
  *	@sdev:	scsi device to quiesce.
  *
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index e3cd3ec..8b190dc 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -24,7 +24,6 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -402,36 +401,6 @@ static void srp_reconnect_work(struct work_struct *work)
 	}
 }
 
-/**
- * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
- * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
- *
- * To do: add support for scsi-mq in this function.
- */
-static int scsi_request_fn_active(struct Scsi_Host *shost)
-{
-	struct scsi_device *sdev;
-	struct request_queue *q;
-	int request_fn_active = 0;
-
-	shost_for_each_device(sdev, shost) {
-		q = sdev->request_queue;
-
-		spin_lock_irq(q->queue_lock);
-		request_fn_active += q->request_fn_active;
-		spin_unlock_irq(q->queue_lock);
-	}
-
-	return request_fn_active;
-}
-
-/* Wait until ongoing shost->hostt->queuecommand() calls have finished. */
-static void srp_wait_for_queuecommand(struct Scsi_Host *shost)
-{
-	while (scsi_request_fn_active(shost))
-		msleep(20);
-}
-
 static void __rport_fail_io_fast(struct srp_rport *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
@@ -446,7 +415,7 @@ static void __rport_fail_io_fast(struct srp_rport *rport)
 	/* Involve the LLD if possible to terminate all I/O on the rport. */
 	i = to_srp_internal(shost->transportt);
 	if (i->f->terminate_rport_io) {
-		srp_wait_for_queuecommand(shost);
+		scsi_wait_for_queuecommand(shost);
 		i->f->terminate_rport_io(rport);
 	}
 }
@@ -576,7 +545,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	if (res)
 		goto out;
 	scsi_target_block(&shost->shost_gendev);
-	srp_wait_for_queuecommand(shost);
+	scsi_wait_for_queuecommand(shost);
 	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
 	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
 		 dev_name(&shost->shost_gendev), rport->state, res);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e4cd53..0e2c361 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -789,6 +789,7 @@ extern void scsi_remove_host(struct Scsi_Host *);
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
+extern void scsi_wait_for_queuecommand(struct Scsi_Host *shost);
 extern const char *scsi_host_state_name(enum scsi_host_state);
 extern void scsi_cmd_get_serial(struct Scsi_Host *, struct scsi_cmnd *);
 
-- 
2.10.1

