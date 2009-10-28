From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] SCSI bug fixes for 2.6.32-rc5
Date: Wed, 28 Oct 2009 08:52:23 -0500
Message-ID: <1256737943.2989.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:45835 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbZJ1NwW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Oct 2009 09:52:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a SCSI memory leak fix (minor) and some zfcp fixes.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Christof Schmitt (4):
      zfcp: Flush SCSI registration work when adding unit
      zfcp: Fix timer initialization for ct and els requests
      zfcp: Warn about storage devices with broken PLOGI data
      zfcp: Handle WWPN mismatch in PLOGI payload

Heiko Carstens (1):
      zfcp: fix kfree handling in zfcp_init_device_setup

James Bottomley (1):
      fix memory leak in initialization


And the diffstat (full diff attached):

 drivers/s390/scsi/zfcp_aux.c   |   11 ++++++-----
 drivers/s390/scsi/zfcp_erp.c   |   22 ++++++++++------------
 drivers/s390/scsi/zfcp_ext.h   |    1 +
 drivers/s390/scsi/zfcp_fc.c    |   11 +++++++++++
 drivers/s390/scsi/zfcp_fsf.c   |   13 ++++++++++---
 drivers/s390/scsi/zfcp_sysfs.c |    1 +
 drivers/scsi/scsi_scan.c       |    2 ++
 drivers/scsi/scsi_sysfs.c      |    7 ++-----
 8 files changed, 43 insertions(+), 25 deletions(-)

James

---

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 0f79f3a..2889e5f 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -128,12 +128,13 @@ out_ccwdev:
 static void __init zfcp_init_device_setup(char *devstr)
 {
 	char *token;
-	char *str;
+	char *str, *str_saved;
 	char busid[ZFCP_BUS_ID_SIZE];
 	u64 wwpn, lun;
 
 	/* duplicate devstr and keep the original for sysfs presentation*/
-	str = kmalloc(strlen(devstr) + 1, GFP_KERNEL);
+	str_saved = kmalloc(strlen(devstr) + 1, GFP_KERNEL);
+	str = str_saved;
 	if (!str)
 		return;
 
@@ -152,12 +153,12 @@ static void __init zfcp_init_device_setup(char *devstr)
 	if (!token || strict_strtoull(token, 0, (unsigned long long *) &lun))
 		goto err_out;
 
-	kfree(str);
+	kfree(str_saved);
 	zfcp_init_device_configure(busid, wwpn, lun);
 	return;
 
- err_out:
-	kfree(str);
+err_out:
+	kfree(str_saved);
 	pr_err("%s is not a valid SCSI device\n", devstr);
 }
 
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 73d366b..f73e218 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -858,10 +858,7 @@ static int zfcp_erp_port_strategy_open_common(struct zfcp_erp_action *act)
 		if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
 			return zfcp_erp_open_ptp_port(act);
 		if (!port->d_id) {
-			zfcp_port_get(port);
-			if (!queue_work(adapter->work_queue,
-					&port->gid_pn_work))
-				zfcp_port_put(port);
+			zfcp_fc_trigger_did_lookup(port);
 			return ZFCP_ERP_EXIT;
 		}
 		return zfcp_erp_port_strategy_open_port(act);
@@ -869,12 +866,11 @@ static int zfcp_erp_port_strategy_open_common(struct zfcp_erp_action *act)
 	case ZFCP_ERP_STEP_PORT_OPENING:
 		/* D_ID might have changed during open */
 		if (p_status & ZFCP_STATUS_COMMON_OPEN) {
-			if (port->d_id)
-				return ZFCP_ERP_SUCCEEDED;
-			else {
-				act->step = ZFCP_ERP_STEP_PORT_CLOSING;
-				return ZFCP_ERP_CONTINUES;
+			if (!port->d_id) {
+				zfcp_fc_trigger_did_lookup(port);
+				return ZFCP_ERP_EXIT;
 			}
+			return ZFCP_ERP_SUCCEEDED;
 		}
 		if (port->d_id && !(p_status & ZFCP_STATUS_COMMON_NOESC)) {
 			port->d_id = 0;
@@ -889,19 +885,21 @@ static int zfcp_erp_port_strategy_open_common(struct zfcp_erp_action *act)
 static int zfcp_erp_port_strategy(struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_port *port = erp_action->port;
+	int p_status = atomic_read(&port->status);
 
-	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_NOESC)
+	if ((p_status & ZFCP_STATUS_COMMON_NOESC) &&
+	    !(p_status & ZFCP_STATUS_COMMON_OPEN))
 		goto close_init_done;
 
 	switch (erp_action->step) {
 	case ZFCP_ERP_STEP_UNINITIALIZED:
 		zfcp_erp_port_strategy_clearstati(port);
-		if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN)
+		if (p_status & ZFCP_STATUS_COMMON_OPEN)
 			return zfcp_erp_port_strategy_close(erp_action);
 		break;
 
 	case ZFCP_ERP_STEP_PORT_CLOSING:
-		if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN)
+		if (p_status & ZFCP_STATUS_COMMON_OPEN)
 			return ZFCP_ERP_FAILED;
 		break;
 	}
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 629edec..b3f28de 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -96,6 +96,7 @@ extern int zfcp_fc_scan_ports(struct zfcp_adapter *);
 extern void _zfcp_fc_scan_ports_later(struct work_struct *);
 extern void zfcp_fc_incoming_els(struct zfcp_fsf_req *);
 extern void zfcp_fc_port_did_lookup(struct work_struct *);
+extern void zfcp_fc_trigger_did_lookup(struct zfcp_port *);
 extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 extern void zfcp_fc_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 722f22d..df23bce 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -361,6 +361,17 @@ out:
 }
 
 /**
+ * zfcp_fc_trigger_did_lookup - trigger the d_id lookup using a GID_PN request
+ * @port: The zfcp_port to lookup the d_id for.
+ */
+void zfcp_fc_trigger_did_lookup(struct zfcp_port *port)
+{
+	zfcp_port_get(port);
+	if (!queue_work(port->adapter->work_queue, &port->gid_pn_work))
+		zfcp_port_put(port);
+}
+
+/**
  * zfcp_fc_plogi_evaluate - evaluate PLOGI playload
  * @port: zfcp_port structure
  * @plogi: plogi payload
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 38a7e4a..4e41baa 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1079,7 +1079,7 @@ static int zfcp_fsf_setup_ct_els(struct zfcp_fsf_req *req,
 	/* common settings for ct/gs and els requests */
 	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
 	req->qtcb->bottom.support.timeout = 2 * R_A_TOV;
-	zfcp_fsf_start_timer(req, 2 * R_A_TOV + 10);
+	zfcp_fsf_start_timer(req, (2 * R_A_TOV + 10) * HZ);
 
 	return 0;
 }
@@ -1475,9 +1475,16 @@ static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 		plogi = (struct fsf_plogi *) req->qtcb->bottom.support.els;
 		if (req->qtcb->bottom.support.els1_length >=
 		    FSF_PLOGI_MIN_LEN) {
-			if (plogi->serv_param.wwpn != port->wwpn)
+			if (plogi->serv_param.wwpn != port->wwpn) {
 				port->d_id = 0;
-			else {
+				dev_warn(&port->adapter->ccw_device->dev,
+					 "A port opened with WWPN 0x%016Lx "
+					 "returned data that identifies it as "
+					 "WWPN 0x%016Lx\n",
+					 (unsigned long long) port->wwpn,
+					 (unsigned long long)
+					  plogi->serv_param.wwpn);
+			} else {
 				port->wwnn = plogi->serv_param.wwnn;
 				zfcp_fc_plogi_evaluate(port, plogi);
 			}
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 079a8cf..d310008 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -224,6 +224,7 @@ static ssize_t zfcp_sysfs_unit_add_store(struct device *dev,
 
 	zfcp_erp_unit_reopen(unit, 0, "syuas_1", NULL);
 	zfcp_erp_wait(unit->port->adapter);
+	flush_work(&unit->scsi_work);
 	zfcp_unit_put(unit);
 out:
 	mutex_unlock(&zfcp_data.config_mutex);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c447838..0547a7f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -317,6 +317,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 out_device_destroy:
 	scsi_device_set_state(sdev, SDEV_DEL);
 	transport_destroy_device(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_dev);
 	put_device(&sdev->sdev_gendev);
 out:
 	if (display_failure_msg)
@@ -957,6 +958,7 @@ static inline void scsi_destroy_sdev(struct scsi_device *sdev)
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_dev);
 	put_device(&sdev->sdev_gendev);
 }
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fde5453..5c7eb63 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -864,10 +864,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		goto clean_device;
 	}
 
-	/* take a reference for the sdev_dev; this is
-	 * released by the sdev_class .release */
-	get_device(&sdev->sdev_gendev);
-
 	/* create queue files, which may be writable, depending on the host */
 	if (sdev->host->hostt->change_queue_depth)
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_depth_rw);
@@ -917,6 +913,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 
 	device_del(&sdev->sdev_gendev);
 	transport_destroy_device(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_dev);
 	put_device(&sdev->sdev_gendev);
 
 	return error;
@@ -1065,7 +1062,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 
 	device_initialize(&sdev->sdev_dev);
-	sdev->sdev_dev.parent = &sdev->sdev_gendev;
+	sdev->sdev_dev.parent = get_device(&sdev->sdev_gendev);
 	sdev->sdev_dev.class = &sdev_class;
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);


