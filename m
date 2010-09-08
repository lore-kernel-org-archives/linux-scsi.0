From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/12] zfcp: Change spin_lock_bh to spin_lock_irq to fix lockdep warning
Date: Wed, 08 Sep 2010 14:39:57 +0200
Message-ID: <20100908124353.750309742@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:44872 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758715Ab0IHMn4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:56 -0400
Content-Disposition: inline; filename=707-zfcp-spin-lock-irq.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

With the change to use the data on the SCSI device, iterating through
all LUNs/scsi_devices takes the SCSI host_lock. This triggers warnings
from the lock dependency checker:

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.34.1 #97
---------------------------------------------------------
chchp/3224 just changed the state of lock:
 (&(shost->host_lock)->rlock){-.-...}, at: [<00000000003a73f4>] __scsi_iterate_devices+0x38/0xbc
but this lock took another, HARDIRQ-unsafe lock in the past:
 (&(&qdio->req_q_lock)->rlock){+.-...}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this: [   24.972394] 2 locks held by chchp/3224:
 #0:  (&(sch->lock)->rlock){-.-...}, at: [<0000000000401efa>] do_IRQ+0xb2/0x1e4
 #1:  (&adapter->port_list_lock){.-....}, at: [<0000000000490302>] zfcp_erp_modify_adapter_status+0x9e/0x16c
[...]

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.34.1 #98
---------------------------------------------------------
chchp/3235 just changed the state of lock:
 (&(shost->host_lock)->rlock){-.-...}, at: [<00000000003a73f4>] __scsi_iterate_devices+0x38/0xbc
but this lock took another, HARDIRQ-unsafe lock in the past:
 (&(&qdio->stat_lock)->rlock){+.-...}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
2 locks held by chchp/3235:
 #0:  (&(sch->lock)->rlock){-.-...}, at: [<0000000000401efa>] do_IRQ+0xb2/0x1e4
 #1:  (&adapter->port_list_lock){.-.-..}, at: [<00000000004902f6>] zfcp_erp_modify_adapter_status+0x9e/0x16c
[...]

To stop this warning, change the request queue lock to disable irqs,
not only softirq. The changes are required only outside of the
critical "send fcp command" path.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c  |   72 +++++++++++++++++++++---------------------
 drivers/s390/scsi/zfcp_qdio.c |   18 +++++-----
 2 files changed, 46 insertions(+), 44 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -773,7 +773,7 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 	struct fsf_status_read_buffer *sr_buf;
 	int retval = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -807,7 +807,7 @@ failed_buf:
 	zfcp_fsf_req_free(req);
 	zfcp_dbf_hba_fsf_unsol("fail", adapter->dbf, NULL);
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -876,7 +876,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 	struct zfcp_qdio *qdio = zfcp_sdev->port->adapter->qdio;
 	unsigned long old_req_id = (unsigned long) scmnd->host_scribble;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_ABORT_FCP_CMND,
@@ -907,7 +907,7 @@ out_error_free:
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return req;
 }
 
@@ -1046,7 +1046,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_
 	struct zfcp_fsf_req *req;
 	int ret = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -1078,7 +1078,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_
 failed_send:
 	zfcp_fsf_req_free(req);
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return ret;
 }
 
@@ -1142,7 +1142,7 @@ int zfcp_fsf_send_els(struct zfcp_adapte
 	struct zfcp_qdio *qdio = adapter->qdio;
 	int ret = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -1178,7 +1178,7 @@ int zfcp_fsf_send_els(struct zfcp_adapte
 failed_send:
 	zfcp_fsf_req_free(req);
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return ret;
 }
 
@@ -1188,7 +1188,7 @@ int zfcp_fsf_exchange_config_data(struct
 	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	int retval = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -1220,7 +1220,7 @@ int zfcp_fsf_exchange_config_data(struct
 		erp_action->fsf_req_id = 0;
 	}
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1230,7 +1230,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out_unlock;
 
@@ -1256,7 +1256,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	if (!retval)
 		wait_for_completion(&req->completion);
 
@@ -1264,7 +1264,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 	return retval;
 
 out_unlock:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1282,7 +1282,7 @@ int zfcp_fsf_exchange_port_data(struct z
 	if (!(qdio->adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -1309,7 +1309,7 @@ int zfcp_fsf_exchange_port_data(struct z
 		erp_action->fsf_req_id = 0;
 	}
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1328,7 +1328,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	if (!(qdio->adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out_unlock;
 
@@ -1348,7 +1348,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	req->handler = zfcp_fsf_exchange_port_data_handler;
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 
 	if (!retval)
 		wait_for_completion(&req->completion);
@@ -1358,7 +1358,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	return retval;
 
 out_unlock:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1442,7 +1442,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -1473,7 +1473,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 		put_device(&port->dev);
 	}
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1510,7 +1510,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -1539,7 +1539,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 		erp_action->fsf_req_id = 0;
 	}
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1585,7 +1585,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -1610,7 +1610,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 	if (retval)
 		zfcp_fsf_req_free(req);
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1638,7 +1638,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -1663,7 +1663,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	if (retval)
 		zfcp_fsf_req_free(req);
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1728,7 +1728,7 @@ int zfcp_fsf_close_physical_port(struct
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -1757,7 +1757,7 @@ int zfcp_fsf_close_physical_port(struct
 		erp_action->fsf_req_id = 0;
 	}
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1900,7 +1900,7 @@ int zfcp_fsf_open_lun(struct zfcp_erp_ac
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -1933,7 +1933,7 @@ int zfcp_fsf_open_lun(struct zfcp_erp_ac
 		erp_action->fsf_req_id = 0;
 	}
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -1987,7 +1987,7 @@ int zfcp_fsf_close_lun(struct zfcp_erp_a
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -2017,7 +2017,7 @@ int zfcp_fsf_close_lun(struct zfcp_erp_a
 		erp_action->fsf_req_id = 0;
 	}
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return retval;
 }
 
@@ -2363,7 +2363,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_m
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return NULL;
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -2397,7 +2397,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_m
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return req;
 }
 
@@ -2433,7 +2433,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 		return ERR_PTR(-EINVAL);
 	}
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
 
@@ -2460,7 +2460,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 
 	if (!retval) {
 		wait_for_completion(&req->completion);
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -60,13 +60,11 @@ static inline void zfcp_qdio_account(str
 	unsigned long long now, span;
 	int used;
 
-	spin_lock(&qdio->stat_lock);
 	now = get_clock_monotonic();
 	span = (now - qdio->req_q_time) >> 12;
 	used = QDIO_MAX_BUFFERS_PER_Q - atomic_read(&qdio->req_q_free);
 	qdio->req_q_util += used * span;
 	qdio->req_q_time = now;
-	spin_unlock(&qdio->stat_lock);
 }
 
 static void zfcp_qdio_int_req(struct ccw_device *cdev, unsigned int qdio_err,
@@ -84,7 +82,9 @@ static void zfcp_qdio_int_req(struct ccw
 	/* cleanup all SBALs being program-owned now */
 	zfcp_qdio_zero_sbals(qdio->req_q, idx, count);
 
+	spin_lock_irq(&qdio->stat_lock);
 	zfcp_qdio_account(qdio);
+	spin_unlock_irq(&qdio->stat_lock);
 	atomic_add(count, &qdio->req_q_free);
 	wake_up(&qdio->req_q_wq);
 }
@@ -201,11 +201,11 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 
 static int zfcp_qdio_sbal_check(struct zfcp_qdio *qdio)
 {
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	if (atomic_read(&qdio->req_q_free) ||
 	    !(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return 1;
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	return 0;
 }
 
@@ -223,7 +223,7 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio
 {
 	long ret;
 
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 	ret = wait_event_interruptible_timeout(qdio->req_q_wq,
 			       zfcp_qdio_sbal_check(qdio), 5 * HZ);
 
@@ -239,7 +239,7 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio
 		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdsbg_1", NULL);
 	}
 
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	return -EIO;
 }
 
@@ -254,7 +254,9 @@ int zfcp_qdio_send(struct zfcp_qdio *qdi
 	int retval;
 	u8 sbal_number = q_req->sbal_number;
 
+	spin_lock(&qdio->stat_lock);
 	zfcp_qdio_account(qdio);
+	spin_unlock(&qdio->stat_lock);
 
 	retval = do_QDIO(qdio->adapter->ccw_device, QDIO_FLAG_SYNC_OUTPUT, 0,
 			 q_req->sbal_first, sbal_number);
@@ -328,9 +330,9 @@ void zfcp_qdio_close(struct zfcp_qdio *q
 		return;
 
 	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
-	spin_lock_bh(&qdio->req_q_lock);
+	spin_lock_irq(&qdio->req_q_lock);
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
-	spin_unlock_bh(&qdio->req_q_lock);
+	spin_unlock_irq(&qdio->req_q_lock);
 
 	wake_up(&qdio->req_q_wq);
 

