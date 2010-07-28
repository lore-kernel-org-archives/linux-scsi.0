From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] hopefully final SCSI fixes for 2.6.35-rc6
Date: Wed, 28 Jul 2010 18:15:47 -0500
Message-ID: <1280358948.18534.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:47001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab0G1XP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jul 2010 19:15:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This just represents the five remaining bug fixes I know about, one in
ipr, one in the IBM vscsi driver and three in zfcp (so nothing x86
impacting).  The fix resource formatting actually fixes a buffer
overflow which causes an oops.

The patch is available from

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Anton Blanchard (1):
      ibmvscsi: Fix oops when an interrupt is pending during probe

Christof Schmitt (2):
      zfcp: Update status read mempool
      zfcp: Do not wait for SBALs on stopped queue

Swen Schillig (1):
      zfcp: Fix check whether unchained ct_els is possible

Wayne Boyer (1):
      ipr: fix resource path display and formatting

The diffstat:

 drivers/s390/scsi/zfcp_erp.c      |    8 +++++
 drivers/s390/scsi/zfcp_fsf.c      |   10 ++-----
 drivers/s390/scsi/zfcp_qdio.c     |   10 ++++++-
 drivers/scsi/ibmvscsi/rpa_vscsi.c |   13 +++++----
 drivers/scsi/ipr.c                |   51 ++++++++++++++++++++++++--------------
 drivers/scsi/ipr.h                |    5 ++-
 6 files changed, 63 insertions(+), 34 deletions(-)

the full diff is below.

James

---

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index e3dbeda..fd068bc 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -714,6 +714,14 @@ static int zfcp_erp_adapter_strategy_open_fsf(struct zfcp_erp_action *act)
 	if (zfcp_erp_adapter_strategy_open_fsf_xport(act) == ZFCP_ERP_FAILED)
 		return ZFCP_ERP_FAILED;
 
+	if (mempool_resize(act->adapter->pool.status_read_data,
+			   act->adapter->stat_read_buf_num, GFP_KERNEL))
+		return ZFCP_ERP_FAILED;
+
+	if (mempool_resize(act->adapter->pool.status_read_req,
+			   act->adapter->stat_read_buf_num, GFP_KERNEL))
+		return ZFCP_ERP_FAILED;
+
 	atomic_set(&act->adapter->stat_miss, act->adapter->stat_read_buf_num);
 	if (zfcp_status_read_refill(act->adapter))
 		return ZFCP_ERP_FAILED;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 9ac6a6e..71663fb 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -496,7 +496,8 @@ static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 
 	adapter->hydra_version = bottom->adapter_type;
 	adapter->timer_ticks = bottom->timer_interval;
-	adapter->stat_read_buf_num = max(bottom->status_read_buf_num, (u16)16);
+	adapter->stat_read_buf_num = max(bottom->status_read_buf_num,
+					 (u16)FSF_STATUS_READS_RECOM);
 
 	if (fc_host_permanent_port_name(shost) == -1)
 		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
@@ -719,11 +720,6 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_qdio *qdio,
 	zfcp_qdio_req_init(adapter->qdio, &req->qdio_req, req->req_id, sbtype,
 			   req->qtcb, sizeof(struct fsf_qtcb));
 
-	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)) {
-		zfcp_fsf_req_free(req);
-		return ERR_PTR(-EIO);
-	}
-
 	return req;
 }
 
@@ -981,7 +977,7 @@ static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
 	}
 
 	/* use single, unchained SBAL if it can hold the request */
-	if (zfcp_qdio_sg_one_sbale(sg_req) || zfcp_qdio_sg_one_sbale(sg_resp)) {
+	if (zfcp_qdio_sg_one_sbale(sg_req) && zfcp_qdio_sg_one_sbale(sg_resp)) {
 		zfcp_fsf_setup_ct_els_unchained(adapter->qdio, &req->qdio_req,
 						sg_req, sg_resp);
 		return 0;
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 28117e1..6fa5e04 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -251,7 +251,8 @@ static int zfcp_qdio_sbal_check(struct zfcp_qdio *qdio)
 	struct zfcp_qdio_queue *req_q = &qdio->req_q;
 
 	spin_lock_bh(&qdio->req_q_lock);
-	if (atomic_read(&req_q->count))
+	if (atomic_read(&req_q->count) ||
+	    !(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
 		return 1;
 	spin_unlock_bh(&qdio->req_q_lock);
 	return 0;
@@ -274,8 +275,13 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
 	spin_unlock_bh(&qdio->req_q_lock);
 	ret = wait_event_interruptible_timeout(qdio->req_q_wq,
 			       zfcp_qdio_sbal_check(qdio), 5 * HZ);
+
+	if (!(atomic_read(&qdio->adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP))
+		return -EIO;
+
 	if (ret > 0)
 		return 0;
+
 	if (!ret) {
 		atomic_inc(&qdio->req_q_full);
 		/* assume hanging outbound queue, try queue recovery */
@@ -375,6 +381,8 @@ void zfcp_qdio_close(struct zfcp_qdio *qdio)
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &qdio->adapter->status);
 	spin_unlock_bh(&qdio->req_q_lock);
 
+	wake_up(&qdio->req_q_wq);
+
 	qdio_shutdown(qdio->adapter->ccw_device,
 		      QDIO_FLAG_CLEANUP_USING_CLEAR);
 
diff --git a/drivers/scsi/ibmvscsi/rpa_vscsi.c b/drivers/scsi/ibmvscsi/rpa_vscsi.c
index a864ccc..989b9a8 100644
--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c
+++ b/drivers/scsi/ibmvscsi/rpa_vscsi.c
@@ -277,6 +277,12 @@ static int rpavscsi_init_crq_queue(struct crq_queue *queue,
 		goto reg_crq_failed;
 	}
 
+	queue->cur = 0;
+	spin_lock_init(&queue->lock);
+
+	tasklet_init(&hostdata->srp_task, (void *)rpavscsi_task,
+		     (unsigned long)hostdata);
+
 	if (request_irq(vdev->irq,
 			rpavscsi_handle_event,
 			0, "ibmvscsi", (void *)hostdata) != 0) {
@@ -291,15 +297,10 @@ static int rpavscsi_init_crq_queue(struct crq_queue *queue,
 		goto req_irq_failed;
 	}
 
-	queue->cur = 0;
-	spin_lock_init(&queue->lock);
-
-	tasklet_init(&hostdata->srp_task, (void *)rpavscsi_task,
-		     (unsigned long)hostdata);
-
 	return retrc;
 
       req_irq_failed:
+	tasklet_kill(&hostdata->srp_task);
 	do {
 		rc = plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
 	} while ((rc == H_BUSY) || (H_IS_LONG_BUSY(rc)));
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 82ea4a8..f820cff 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1129,20 +1129,22 @@ static int ipr_is_same_device(struct ipr_resource_entry *res,
 }
 
 /**
- * ipr_format_resource_path - Format the resource path for printing.
+ * ipr_format_res_path - Format the resource path for printing.
  * @res_path:	resource path
  * @buf:	buffer
  *
  * Return value:
  * 	pointer to buffer
  **/
-static char *ipr_format_resource_path(u8 *res_path, char *buffer)
+static char *ipr_format_res_path(u8 *res_path, char *buffer, int len)
 {
 	int i;
+	char *p = buffer;
 
-	sprintf(buffer, "%02X", res_path[0]);
-	for (i=1; res_path[i] != 0xff; i++)
-		sprintf(buffer, "%s-%02X", buffer, res_path[i]);
+	res_path[0] = '\0';
+	p += snprintf(p, buffer + len - p, "%02X", res_path[0]);
+	for (i = 1; res_path[i] != 0xff && ((i * 3) < len); i++)
+		p += snprintf(p, buffer + len - p, "-%02X", res_path[i]);
 
 	return buffer;
 }
@@ -1187,7 +1189,8 @@ static void ipr_update_res_entry(struct ipr_resource_entry *res,
 
 		if (res->sdev && new_path)
 			sdev_printk(KERN_INFO, res->sdev, "Resource path: %s\n",
-				    ipr_format_resource_path(&res->res_path[0], &buffer[0]));
+				    ipr_format_res_path(res->res_path, buffer,
+							sizeof(buffer)));
 	} else {
 		res->flags = cfgtew->u.cfgte->flags;
 		if (res->flags & IPR_IS_IOA_RESOURCE)
@@ -1573,7 +1576,8 @@ static void ipr_log_sis64_config_error(struct ipr_ioa_cfg *ioa_cfg,
 		ipr_err_separator;
 
 		ipr_err("Device %d : %s", i + 1,
-			 ipr_format_resource_path(&dev_entry->res_path[0], &buffer[0]));
+			 ipr_format_res_path(dev_entry->res_path, buffer,
+					     sizeof(buffer)));
 		ipr_log_ext_vpd(&dev_entry->vpd);
 
 		ipr_err("-----New Device Information-----\n");
@@ -1919,13 +1923,14 @@ static void ipr_log64_fabric_path(struct ipr_hostrcb *hostrcb,
 
 			ipr_hcam_err(hostrcb, "%s %s: Resource Path=%s\n",
 				     path_active_desc[i].desc, path_state_desc[j].desc,
-				     ipr_format_resource_path(&fabric->res_path[0], &buffer[0]));
+				     ipr_format_res_path(fabric->res_path, buffer,
+							 sizeof(buffer)));
 			return;
 		}
 	}
 
 	ipr_err("Path state=%02X Resource Path=%s\n", path_state,
-		ipr_format_resource_path(&fabric->res_path[0], &buffer[0]));
+		ipr_format_res_path(fabric->res_path, buffer, sizeof(buffer)));
 }
 
 static const struct {
@@ -2066,7 +2071,8 @@ static void ipr_log64_path_elem(struct ipr_hostrcb *hostrcb,
 
 			ipr_hcam_err(hostrcb, "%s %s: Resource Path=%s, Link rate=%s, WWN=%08X%08X\n",
 				     path_status_desc[j].desc, path_type_desc[i].desc,
-				     ipr_format_resource_path(&cfg->res_path[0], &buffer[0]),
+				     ipr_format_res_path(cfg->res_path, buffer,
+							 sizeof(buffer)),
 				     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
 				     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
 			return;
@@ -2074,7 +2080,7 @@ static void ipr_log64_path_elem(struct ipr_hostrcb *hostrcb,
 	}
 	ipr_hcam_err(hostrcb, "Path element=%02X: Resource Path=%s, Link rate=%s "
 		     "WWN=%08X%08X\n", cfg->type_status,
-		     ipr_format_resource_path(&cfg->res_path[0], &buffer[0]),
+		     ipr_format_res_path(cfg->res_path, buffer, sizeof(buffer)),
 		     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
 		     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
 }
@@ -2139,7 +2145,7 @@ static void ipr_log_sis64_array_error(struct ipr_ioa_cfg *ioa_cfg,
 
 	ipr_err("RAID %s Array Configuration: %s\n",
 		error->protection_level,
-		ipr_format_resource_path(&error->last_res_path[0], &buffer[0]));
+		ipr_format_res_path(error->last_res_path, buffer, sizeof(buffer)));
 
 	ipr_err_separator;
 
@@ -2160,9 +2166,11 @@ static void ipr_log_sis64_array_error(struct ipr_ioa_cfg *ioa_cfg,
 		ipr_err("Array Member %d:\n", i);
 		ipr_log_ext_vpd(&array_entry->vpd);
 		ipr_err("Current Location: %s",
-			 ipr_format_resource_path(&array_entry->res_path[0], &buffer[0]));
+			 ipr_format_res_path(array_entry->res_path, buffer,
+					     sizeof(buffer)));
 		ipr_err("Expected Location: %s",
-			 ipr_format_resource_path(&array_entry->expected_res_path[0], &buffer[0]));
+			 ipr_format_res_path(array_entry->expected_res_path,
+					     buffer, sizeof(buffer)));
 
 		ipr_err_separator;
 	}
@@ -4079,7 +4087,8 @@ static struct device_attribute ipr_adapter_handle_attr = {
 };
 
 /**
- * ipr_show_resource_path - Show the resource path for this device.
+ * ipr_show_resource_path - Show the resource path or the resource address for
+ *			    this device.
  * @dev:	device struct
  * @buf:	buffer
  *
@@ -4097,9 +4106,14 @@ static ssize_t ipr_show_resource_path(struct device *dev, struct device_attribut
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
-	if (res)
+	if (res && ioa_cfg->sis64)
 		len = snprintf(buf, PAGE_SIZE, "%s\n",
-			       ipr_format_resource_path(&res->res_path[0], &buffer[0]));
+			       ipr_format_res_path(res->res_path, buffer,
+						   sizeof(buffer)));
+	else if (res)
+		len = snprintf(buf, PAGE_SIZE, "%d:%d:%d:%d\n", ioa_cfg->host->host_no,
+			       res->bus, res->target, res->lun);
+
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 	return len;
 }
@@ -4351,7 +4365,8 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 			scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
 		if (ioa_cfg->sis64)
 			sdev_printk(KERN_INFO, sdev, "Resource path: %s\n",
-			            ipr_format_resource_path(&res->res_path[0], &buffer[0]));
+				    ipr_format_res_path(res->res_path, buffer,
+							sizeof(buffer)));
 		return 0;
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 9ecd225..b965f35 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1684,8 +1684,9 @@ struct ipr_ucode_image_header {
 	if (ipr_is_device(hostrcb)) {					\
 		if ((hostrcb)->ioa_cfg->sis64) {			\
 			printk(KERN_ERR IPR_NAME ": %s: " fmt, 		\
-				ipr_format_resource_path(&hostrcb->hcam.u.error64.fd_res_path[0], \
-					&hostrcb->rp_buffer[0]),	\
+				ipr_format_res_path(hostrcb->hcam.u.error64.fd_res_path, \
+					hostrcb->rp_buffer,		\
+					sizeof(hostrcb->rp_buffer)),	\
 				__VA_ARGS__);				\
 		} else {						\
 			ipr_ra_err((hostrcb)->ioa_cfg,			\


