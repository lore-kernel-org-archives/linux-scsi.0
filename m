From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] SCSI fixes for 2.6.27-rc6
Date: Wed, 10 Sep 2008 21:52:37 -0500
Message-ID: <1221101557.3343.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44686 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbYIKCwo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 22:52:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a large bunch of fixes for the s390 fibre driver plus a DIF
entanglement issue (permit DIF to be disabled) A WLUN scanning problem
(prevents disk detection on S390) and a couple of scsi_dh fixes that
prevent the device handler from wrongly failing to retry.

The fixes are available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Christof Schmitt (3):
      zfcp: Simplify ccw notify handler
      zfcp: Correctly query end flag in gpn_ft response
      zfcp: Fix request queue locking

Hirofumi Nakagawa (1):
      zfcp: Remove duplicated unlikely() macros.

James Bottomley (1):
      fix check of PQ and PDT bits for WLUNs

Mike Anderson (2):
      make scsi_check_sense HARDWARE_ERROR return ADD_TO_MLQUEUE on retry
      scsi_dh: make check_sense return ADD_TO_MLQUEUE

Stefan Richter (1):
      sd: select CRC_T10DIF only when necessary

Swen Schillig (2):
      zfcp: channel cannot be detached due to refcount imbalance
      zfcp: Fix reference counter for remote ports


The diffstat:

 drivers/s390/scsi/zfcp_ccw.c               |    6 -
 drivers/s390/scsi/zfcp_fc.c                |   33 +++-------
 drivers/s390/scsi/zfcp_fsf.c               |   88 ++++++++++++++---------------
 drivers/s390/scsi/zfcp_qdio.c              |    4 -
 drivers/scsi/Kconfig                       |    2 
 drivers/scsi/device_handler/scsi_dh_alua.c |   12 +--
 drivers/scsi/device_handler/scsi_dh_emc.c  |    4 -
 drivers/scsi/device_handler/scsi_dh_rdac.c |    4 -
 drivers/scsi/scsi_error.c                  |    2 
 drivers/scsi/scsi_scan.c                   |    3 
 include/scsi/scsi.h                        |   14 ++++
 11 files changed, 87 insertions(+), 85 deletions(-)

The full diff is appended below.

James

---

diff --git a/drivers/s390/scsi/zfcp_ccw.c b/drivers/s390/scsi/zfcp_ccw.c
index 391dd29..51b6a05 100644
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -152,10 +152,8 @@ static int zfcp_ccw_set_offline(struct ccw_device *ccw_device)
  */
 static int zfcp_ccw_notify(struct ccw_device *ccw_device, int event)
 {
-	struct zfcp_adapter *adapter;
+	struct zfcp_adapter *adapter = dev_get_drvdata(&ccw_device->dev);
 
-	down(&zfcp_data.config_sema);
-	adapter = dev_get_drvdata(&ccw_device->dev);
 	switch (event) {
 	case CIO_GONE:
 		dev_warn(&adapter->ccw_device->dev, "device gone\n");
@@ -174,8 +172,6 @@ static int zfcp_ccw_notify(struct ccw_device *ccw_device, int event)
 					89, NULL);
 		break;
 	}
-	zfcp_erp_wait(adapter);
-	up(&zfcp_data.config_sema);
 	return 1;
 }
 
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index e984469..56196c9 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -39,18 +39,6 @@ struct zfcp_gpn_ft {
 	struct scatterlist sg_resp[ZFCP_GPN_FT_BUFFERS];
 };
 
-static struct zfcp_port *zfcp_get_port_by_did(struct zfcp_adapter *adapter,
-					      u32 d_id)
-{
-	struct zfcp_port *port;
-
-	list_for_each_entry(port, &adapter->port_list_head, list)
-		if ((port->d_id == d_id) &&
-		    !atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status))
-			return port;
-	return NULL;
-}
-
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 				   struct fcp_rscn_element *elem)
 {
@@ -341,12 +329,13 @@ void zfcp_test_link(struct zfcp_port *port)
 
 	zfcp_port_get(port);
 	retval = zfcp_fc_adisc(port);
-	if (retval == 0 || retval == -EBUSY)
+	if (retval == 0)
 		return;
 
 	/* send of ADISC was not possible */
 	zfcp_port_put(port);
-	zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
+	if (retval != -EBUSY)
+		zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
 }
 
 static int zfcp_scan_get_nameserver(struct zfcp_adapter *adapter)
@@ -363,7 +352,6 @@ static int zfcp_scan_get_nameserver(struct zfcp_adapter *adapter)
 		if (ret)
 			return ret;
 		zfcp_erp_wait(adapter);
-		zfcp_port_put(adapter->nameserver_port);
 	}
 	return !atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 				  &adapter->nameserver_port->status);
@@ -475,7 +463,7 @@ static int zfcp_scan_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft)
 	struct zfcp_adapter *adapter = ct->port->adapter;
 	struct zfcp_port *port, *tmp;
 	u32 d_id;
-	int ret = 0, x;
+	int ret = 0, x, last = 0;
 
 	if (ct->status)
 		return -EIO;
@@ -492,19 +480,24 @@ static int zfcp_scan_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft)
 	down(&zfcp_data.config_sema);
 
 	/* first entry is the header */
-	for (x = 1; x < ZFCP_GPN_FT_MAX_ENTRIES; x++) {
+	for (x = 1; x < ZFCP_GPN_FT_MAX_ENTRIES && !last; x++) {
 		if (x % (ZFCP_GPN_FT_ENTRIES + 1))
 			acc++;
 		else
 			acc = sg_virt(++sg);
 
+		last = acc->control & 0x80;
 		d_id = acc->port_id[0] << 16 | acc->port_id[1] << 8 |
 		       acc->port_id[2];
 
 		/* skip the adapter's port and known remote ports */
-		if (acc->wwpn == fc_host_port_name(adapter->scsi_host) ||
-		     zfcp_get_port_by_did(adapter, d_id))
+		if (acc->wwpn == fc_host_port_name(adapter->scsi_host))
+			continue;
+		port = zfcp_get_port_by_wwpn(adapter, acc->wwpn);
+		if (port) {
+			zfcp_port_get(port);
 			continue;
+		}
 
 		port = zfcp_port_enqueue(adapter, acc->wwpn,
 					 ZFCP_STATUS_PORT_DID_DID |
@@ -513,8 +506,6 @@ static int zfcp_scan_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft)
 			ret = PTR_ERR(port);
 		else
 			zfcp_erp_port_reopen(port, 0, 149, NULL);
-		if (acc->control & 0x80) /* last entry */
-			break;
 	}
 
 	zfcp_erp_wait(adapter);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 19c1ca9..49dbeb7 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -710,10 +710,10 @@ static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *req)
 
 static int zfcp_fsf_sbal_check(struct zfcp_qdio_queue *queue)
 {
-	spin_lock(&queue->lock);
+	spin_lock_bh(&queue->lock);
 	if (atomic_read(&queue->count))
 		return 1;
-	spin_unlock(&queue->lock);
+	spin_unlock_bh(&queue->lock);
 	return 0;
 }
 
@@ -722,13 +722,13 @@ static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
 	long ret;
 	struct zfcp_qdio_queue *req_q = &adapter->req_q;
 
-	spin_unlock(&req_q->lock);
+	spin_unlock_bh(&req_q->lock);
 	ret = wait_event_interruptible_timeout(adapter->request_wq,
 					zfcp_fsf_sbal_check(req_q), 5 * HZ);
 	if (ret > 0)
 		return 0;
 
-	spin_lock(&req_q->lock);
+	spin_lock_bh(&req_q->lock);
 	return -EIO;
 }
 
@@ -870,14 +870,14 @@ int zfcp_fsf_status_read(struct zfcp_adapter *adapter)
 	volatile struct qdio_buffer_element *sbale;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_UNSOLICITED_STATUS,
 				  ZFCP_REQ_NO_QTCB,
 				  adapter->pool.fsf_req_status_read);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -910,7 +910,7 @@ failed_buf:
 	zfcp_fsf_req_free(req);
 	zfcp_hba_dbf_event_fsf_unsol("fail", adapter, NULL);
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -988,7 +988,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(unsigned long old_req_id,
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
 				  req_flags, adapter->pool.fsf_req_abort);
-	if (unlikely(IS_ERR(req)))
+	if (IS_ERR(req))
 		goto out;
 
 	if (unlikely(!(atomic_read(&unit->status) &
@@ -1106,13 +1106,13 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct *ct, mempool_t *pool,
 	struct zfcp_fsf_req *req;
 	int ret = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_GENERIC,
 				  ZFCP_REQ_AUTO_CLEANUP, pool);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
 		goto out;
 	}
@@ -1148,7 +1148,7 @@ failed_send:
 	if (erp_action)
 		erp_action->fsf_req = NULL;
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return ret;
 }
 
@@ -1223,7 +1223,7 @@ int zfcp_fsf_send_els(struct zfcp_send_els *els)
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_ELS,
 				  ZFCP_REQ_AUTO_CLEANUP, NULL);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
 		goto out;
 	}
@@ -1263,14 +1263,14 @@ int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (!atomic_read(&adapter->req_q.count))
 		goto out;
 	req = zfcp_fsf_req_create(adapter,
 				  FSF_QTCB_EXCHANGE_CONFIG_DATA,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1295,7 +1295,7 @@ int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1306,13 +1306,13 @@ int zfcp_fsf_exchange_config_data_sync(struct zfcp_adapter *adapter,
 	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA,
 				  0, NULL);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1334,7 +1334,7 @@ int zfcp_fsf_exchange_config_data_sync(struct zfcp_adapter *adapter,
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	if (!retval)
 		wait_event(req->completion_wq,
 			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
@@ -1359,13 +1359,13 @@ int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
 	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (!atomic_read(&adapter->req_q.count))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1385,7 +1385,7 @@ int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1405,13 +1405,13 @@ int zfcp_fsf_exchange_port_data_sync(struct zfcp_adapter *adapter,
 	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (!atomic_read(&adapter->req_q.count))
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA, 0,
 				  NULL);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1427,7 +1427,7 @@ int zfcp_fsf_exchange_port_data_sync(struct zfcp_adapter *adapter,
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	if (!retval)
 		wait_event(req->completion_wq,
 			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
@@ -1531,7 +1531,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1539,7 +1539,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 				  FSF_QTCB_OPEN_PORT_WITH_DID,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1562,7 +1562,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1603,14 +1603,14 @@ int zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PORT,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1633,7 +1633,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1700,14 +1700,14 @@ int zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PHYSICAL_PORT,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1731,7 +1731,7 @@ int zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1875,14 +1875,14 @@ int zfcp_fsf_open_unit(struct zfcp_erp_action *erp_action)
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_OPEN_LUN,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1910,7 +1910,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_action *erp_action)
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1965,13 +1965,13 @@ int zfcp_fsf_close_unit(struct zfcp_erp_action *erp_action)
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_LUN,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1995,7 +1995,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_action *erp_action)
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -2228,7 +2228,7 @@ int zfcp_fsf_send_fcp_command_task(struct zfcp_adapter *adapter,
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
 				  adapter->pool.fsf_req_scsi);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -2351,7 +2351,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_adapter *adapter,
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
 				  adapter->pool.fsf_req_scsi);
-	if (unlikely(IS_ERR(req)))
+	if (IS_ERR(req))
 		goto out;
 
 	req->status |= ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT;
@@ -2417,12 +2417,12 @@ struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
 		return ERR_PTR(-EINVAL);
 	}
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, fsf_cfdc->command, 0, NULL);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = -EPERM;
 		goto out;
 	}
@@ -2447,7 +2447,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 
 	if (!retval) {
 		wait_event(req->completion_wq,
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index d6dbd65..69d632d 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -423,9 +423,9 @@ void zfcp_qdio_close(struct zfcp_adapter *adapter)
 
 	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
 	req_q = &adapter->req_q;
-	spin_lock(&req_q->lock);
+	spin_lock_bh(&req_q->lock);
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
-	spin_unlock(&req_q->lock);
+	spin_unlock_bh(&req_q->lock);
 
 	qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR);
 
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c7f0629..4e0322b 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -63,7 +63,7 @@ comment "SCSI support type (disk, tape, CD-ROM)"
 config BLK_DEV_SD
 	tristate "SCSI disk support"
 	depends on SCSI
-	select CRC_T10DIF
+	select CRC_T10DIF if BLK_DEV_INTEGRITY
 	---help---
 	  If you want to use SCSI hard disks, Fibre Channel disks,
 	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 994da56..708e475 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -425,7 +425,7 @@ static int alua_check_sense(struct scsi_device *sdev,
 			/*
 			 * LUN Not Accessible - ALUA state transition
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0b)
 			/*
 			 * LUN Not Accessible -- Target port in standby state
@@ -447,18 +447,18 @@ static int alua_check_sense(struct scsi_device *sdev,
 			/*
 			 * Power On, Reset, or Bus Device Reset, just retry.
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
 			/*
 			 * ALUA state changed
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		}
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
 			/*
 			 * Implicit ALUA state transition failed
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		}
 		break;
 	}
@@ -490,7 +490,7 @@ static int alua_stpg(struct scsi_device *sdev, int state,
 		if (!err)
 			return SCSI_DH_IO;
 		err = alua_check_sense(sdev, &sense_hdr);
-		if (retry > 0 && err == NEEDS_RETRY) {
+		if (retry > 0 && err == ADD_TO_MLQUEUE) {
 			retry--;
 			goto retry;
 		}
@@ -535,7 +535,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 			return SCSI_DH_IO;
 
 		err = alua_check_sense(sdev, &sense_hdr);
-		if (err == NEEDS_RETRY)
+		if (err == ADD_TO_MLQUEUE)
 			goto retry;
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: rtpg sense code %02x/%02x/%02x\n",
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index b9d23e9..ef693e8 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -439,7 +439,7 @@ static int clariion_check_sense(struct scsi_device *sdev,
 			 * Unit Attention Code. This is the first IO
 			 * to the new path, so just retry.
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		break;
 	}
 
@@ -514,7 +514,7 @@ retry:
 			return SCSI_DH_IO;
 
 		err = clariion_check_sense(sdev, &sshdr);
-		if (retry > 0 && err == NEEDS_RETRY) {
+		if (retry > 0 && err == ADD_TO_MLQUEUE) {
 			retry--;
 			goto retry;
 		}
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 2dee69d..6e2f130 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -551,7 +551,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
 			 *
 			 * Just retry and wait.
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		break;
 	case ILLEGAL_REQUEST:
 		if (sense_hdr->asc == 0x94 && sense_hdr->ascq == 0x01) {
@@ -568,7 +568,7 @@ static int rdac_check_sense(struct scsi_device *sdev,
 			/*
 			 * Power On, Reset, or Bus Device Reset, just retry.
 			 */
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		break;
 	}
 	/* success just means we do not care what scsi-ml does */
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 880051c..39ce3ab 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -391,7 +391,7 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 
 	case HARDWARE_ERROR:
 		if (scmd->device->retry_hwerror)
-			return NEEDS_RETRY;
+			return ADD_TO_MLQUEUE;
 		else
 			return SUCCESS;
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 84b4879..34d0de6 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1080,7 +1080,8 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 * PDT=1Fh none (no FDD connected to the requested logical unit)
 	 */
 	if (((result[0] >> 5) == 1 || starget->pdt_1f_for_no_lun) &&
-	     (result[0] & 0x1f) == 0x1f) {
+	    (result[0] & 0x1f) == 0x1f &&
+	    !scsi_is_wlun(lun)) {
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 					"scsi scan: peripheral device type"
 					" of 31, no device added\n"));
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5c40cc5..192f871 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -309,6 +309,20 @@ struct scsi_lun {
 };
 
 /*
+ * The Well Known LUNS (SAM-3) in our int representation of a LUN
+ */
+#define SCSI_W_LUN_BASE 0xc100
+#define SCSI_W_LUN_REPORT_LUNS (SCSI_W_LUN_BASE + 1)
+#define SCSI_W_LUN_ACCESS_CONTROL (SCSI_W_LUN_BASE + 2)
+#define SCSI_W_LUN_TARGET_LOG_PAGE (SCSI_W_LUN_BASE + 3)
+
+static inline int scsi_is_wlun(unsigned int lun)
+{
+	return (lun & 0xff00) == SCSI_W_LUN_BASE;
+}
+
+
+/*
  *  MESSAGE CODES
  */
 


