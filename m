From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/6] zfcp: Fix request queue locking
Date: Thu, 21 Aug 2008 13:43:32 +0200
Message-ID: <20080821114555.860812000@de.ibm.com>
References: <20080821114331.148204000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:38674 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474AbYHULqy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 07:46:54 -0400
Content-Disposition: inline; filename=701-zfcp-queue-lock.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Petermann <martin@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The request queue lock can be acquired from softirq context when the
SCSI midlayer issues commands. Disable softirqs for this lock when
commands are issued from zfcp.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c  |   56 +++++++++++++++++++++---------------------
 drivers/s390/scsi/zfcp_qdio.c |    4 +--
 2 files changed, 30 insertions(+), 30 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-08-20 16:49:53.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-08-20 16:52:49.000000000 +0200
@@ -710,10 +710,10 @@ static void zfcp_fsf_exchange_port_data_
 
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
 
@@ -722,13 +722,13 @@ static int zfcp_fsf_req_sbal_get(struct 
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
 
@@ -870,7 +870,7 @@ int zfcp_fsf_status_read(struct zfcp_ada
 	volatile struct qdio_buffer_element *sbale;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -910,7 +910,7 @@ failed_buf:
 	zfcp_fsf_req_free(req);
 	zfcp_hba_dbf_event_fsf_unsol("fail", adapter, NULL);
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1106,7 +1106,7 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 	struct zfcp_fsf_req *req;
 	int ret = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1148,7 +1148,7 @@ failed_send:
 	if (erp_action)
 		erp_action->fsf_req = NULL;
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return ret;
 }
 
@@ -1263,7 +1263,7 @@ int zfcp_fsf_exchange_config_data(struct
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (!atomic_read(&adapter->req_q.count))
 		goto out;
 	req = zfcp_fsf_req_create(adapter,
@@ -1295,7 +1295,7 @@ int zfcp_fsf_exchange_config_data(struct
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1306,7 +1306,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1334,7 +1334,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	if (!retval)
 		wait_event(req->completion_wq,
 			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
@@ -1359,7 +1359,7 @@ int zfcp_fsf_exchange_port_data(struct z
 	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (!atomic_read(&adapter->req_q.count))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
@@ -1385,7 +1385,7 @@ int zfcp_fsf_exchange_port_data(struct z
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1405,7 +1405,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (!atomic_read(&adapter->req_q.count))
 		goto out;
 
@@ -1427,7 +1427,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	if (!retval)
 		wait_event(req->completion_wq,
 			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
@@ -1531,7 +1531,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1562,7 +1562,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1603,7 +1603,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1633,7 +1633,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1700,7 +1700,7 @@ int zfcp_fsf_close_physical_port(struct 
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1731,7 +1731,7 @@ int zfcp_fsf_close_physical_port(struct 
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1875,7 +1875,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1910,7 +1910,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -1965,7 +1965,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_LUN,
@@ -1995,7 +1995,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 	return retval;
 }
 
@@ -2417,7 +2417,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 		return ERR_PTR(-EINVAL);
 	}
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q.lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -2447,7 +2447,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q.lock);
 
 	if (!retval) {
 		wait_event(req->completion_wq,
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-08-20 16:49:53.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-08-20 16:50:27.000000000 +0200
@@ -423,9 +423,9 @@ void zfcp_qdio_close(struct zfcp_adapter
 
 	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
 	req_q = &adapter->req_q;
-	spin_lock(&req_q->lock);
+	spin_lock_bh(&req_q->lock);
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
-	spin_unlock(&req_q->lock);
+	spin_unlock_bh(&req_q->lock);
 
 	qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR);
 

-- 
