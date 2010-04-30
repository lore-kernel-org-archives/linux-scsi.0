From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/5] zfcp: Move sbal_get function to zfcp_qdio.c
Date: Fri, 30 Apr 2010 18:09:35 +0200
Message-ID: <20100430161020.306241000@de.ibm.com>
References: <20100430160932.658896000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:35005 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab0D3TcN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 15:32:13 -0400
Content-Disposition: inline; filename=703-zfcp-sbal_get-function.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Waiting for a free sbal is a operation on the qdio queue. Move the
code implementing the wait to zfcp_qdio.c and rename the functions
accordingly.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_ext.h  |    1 
 drivers/s390/scsi/zfcp_fsf.c  |   65 ++++++++++--------------------------------
 drivers/s390/scsi/zfcp_qdio.c |   40 +++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 48 deletions(-)

--- a/drivers/s390/scsi/zfcp_ext.h	2010-04-30 16:00:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2010-04-30 16:00:48.000000000 +0200
@@ -143,6 +143,7 @@ extern void zfcp_fsf_reqid_check(struct 
 /* zfcp_qdio.c */
 extern int zfcp_qdio_setup(struct zfcp_adapter *);
 extern void zfcp_qdio_destroy(struct zfcp_qdio *);
+extern int zfcp_qdio_sbal_get(struct zfcp_qdio *);
 extern int zfcp_qdio_send(struct zfcp_qdio *, struct zfcp_qdio_req *);
 extern int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *, struct zfcp_qdio_req *,
 				   struct scatterlist *, int);
--- a/drivers/s390/scsi/zfcp_fsf.c	2010-04-30 16:00:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2010-04-30 16:00:48.000000000 +0200
@@ -640,37 +640,6 @@ static void zfcp_fsf_exchange_port_data_
 	}
 }
 
-static int zfcp_fsf_sbal_check(struct zfcp_qdio *qdio)
-{
-	struct zfcp_qdio_queue *req_q = &qdio->req_q;
-
-	spin_lock_bh(&qdio->req_q_lock);
-	if (atomic_read(&req_q->count))
-		return 1;
-	spin_unlock_bh(&qdio->req_q_lock);
-	return 0;
-}
-
-static int zfcp_fsf_req_sbal_get(struct zfcp_qdio *qdio)
-{
-	struct zfcp_adapter *adapter = qdio->adapter;
-	long ret;
-
-	spin_unlock_bh(&qdio->req_q_lock);
-	ret = wait_event_interruptible_timeout(qdio->req_q_wq,
-			       zfcp_fsf_sbal_check(qdio), 5 * HZ);
-	if (ret > 0)
-		return 0;
-	if (!ret) {
-		atomic_inc(&qdio->req_q_full);
-		/* assume hanging outbound queue, try queue recovery */
-		zfcp_erp_adapter_reopen(adapter, 0, "fsrsg_1", NULL);
-	}
-
-	spin_lock_bh(&qdio->req_q_lock);
-	return -EIO;
-}
-
 static struct zfcp_fsf_req *zfcp_fsf_alloc(mempool_t *pool)
 {
 	struct zfcp_fsf_req *req;
@@ -798,7 +767,7 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_UNSOLICITED_STATUS, 0,
@@ -898,7 +867,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 	struct zfcp_qdio *qdio = unit->port->adapter->qdio;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_ABORT_FCP_CMND,
 				  SBAL_FLAGS0_TYPE_READ,
@@ -1068,7 +1037,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_
 	int ret = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_SEND_GENERIC,
@@ -1165,7 +1134,7 @@ int zfcp_fsf_send_els(struct zfcp_adapte
 	int ret = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_SEND_ELS,
@@ -1208,7 +1177,7 @@ int zfcp_fsf_exchange_config_data(struct
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_CONFIG_DATA,
@@ -1250,7 +1219,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out_unlock;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_CONFIG_DATA,
@@ -1302,7 +1271,7 @@ int zfcp_fsf_exchange_port_data(struct z
 		return -EOPNOTSUPP;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_PORT_DATA,
@@ -1348,7 +1317,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 		return -EOPNOTSUPP;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out_unlock;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_PORT_DATA,
@@ -1462,7 +1431,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_PORT_WITH_DID,
@@ -1530,7 +1499,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PORT,
@@ -1605,7 +1574,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_PORT_WITH_DID,
@@ -1658,7 +1627,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PORT,
@@ -1750,7 +1719,7 @@ int zfcp_fsf_close_physical_port(struct 
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PHYSICAL_PORT,
@@ -1921,7 +1890,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_LUN,
@@ -2005,7 +1974,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_LUN,
@@ -2340,7 +2309,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 		return NULL;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_FCP_CMND,
@@ -2410,7 +2379,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 	}
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (zfcp_fsf_req_sbal_get(qdio))
+	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, fsf_cfdc->command, direction, NULL);
--- a/drivers/s390/scsi/zfcp_qdio.c	2010-04-30 16:00:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2010-04-30 16:00:48.000000000 +0200
@@ -246,6 +246,46 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 	return bytes;
 }
 
+static int zfcp_qdio_sbal_check(struct zfcp_qdio *qdio)
+{
+	struct zfcp_qdio_queue *req_q = &qdio->req_q;
+
+	spin_lock_bh(&qdio->req_q_lock);
+	if (atomic_read(&req_q->count))
+		return 1;
+	spin_unlock_bh(&qdio->req_q_lock);
+	return 0;
+}
+
+/**
+ * zfcp_qdio_sbal_get - get free sbal in request queue, wait if necessary
+ * @qdio: pointer to struct zfcp_qdio
+ *
+ * The req_q_lock must be held by the caller of this function, and
+ * this function may only be called from process context; it will
+ * sleep when waiting for a free sbal.
+ *
+ * Returns: 0 on success, -EIO if there is no free sbal after waiting.
+ */
+int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
+{
+	long ret;
+
+	spin_unlock_bh(&qdio->req_q_lock);
+	ret = wait_event_interruptible_timeout(qdio->req_q_wq,
+			       zfcp_qdio_sbal_check(qdio), 5 * HZ);
+	if (ret > 0)
+		return 0;
+	if (!ret) {
+		atomic_inc(&qdio->req_q_full);
+		/* assume hanging outbound queue, try queue recovery */
+		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdsbg_1", NULL);
+	}
+
+	spin_lock_bh(&qdio->req_q_lock);
+	return -EIO;
+}
+
 /**
  * zfcp_qdio_send - set PCI flag in first SBALE and send req to QDIO
  * @qdio: pointer to struct zfcp_qdio

