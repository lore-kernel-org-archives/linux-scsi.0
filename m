Received: from alln-iport-2.cisco.com (alln-iport-2.cisco.com [173.37.142.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46EE3BBCC;
	Fri,  9 Aug 2024 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723222245; cv=none; b=sqRBOyYGwxAcOHARdZLaUQI+Vy2sZoin2xgZbTZcl3xTdS+YPSkPPECLMZMFMyuJtHdMWaPb4F2yC4MaY0eioj+z9UT0+bCXKUczAlBeEXcmitQagg0zVJ7q/NuNThT7F3HvdUruUGYyfACXBAZTB6TlAPqymT23e4RyTjZwkGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723222245; c=relaxed/simple;
	bh=qqHxdVa8AOy/JynSyllQqsgiiz6pJijMBs/U4Oi5gpE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ov9MSh/XJuSHngBhp06W5+ct9OEKPJNJhHnl3mfzMYUblZgdqPDcc0DnsyhlYDGFp9Tzjqy6lmr+T0twW+tJI/oxOwtbyZxT5P3e/v02KH47dcBP0PXp6tIGieck8H/U7R6ISifOW/feTdmM5bckW2Tr1IzkW/tl0qAOl2P3piY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=l0YPcpUW; arc=none smtp.client-ip=173.37.142.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="l0YPcpUW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=39608; q=dns/txt;
  s=iport; t=1723222242; x=1724431842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5GUtjUJIiXjSOcYEjZ96/+bmz9Cx5NvcnPNUYNqthHw=;
  b=l0YPcpUWsYtoBpeSd6L9k8Nrn/ol/LJiUzoMK+JaMpA8XfCPX5cLm4N2
   /LgxPokUfNE4thuGpfr06Cd0fSZO8gOO/TYOGcJYfXxg3NWchaxqysx0g
   CkGyn9TMA7LNhwM/pUN2OzNHNa4Huiw2qQ3LPrRQraYN6I3NirNpGJkk6
   k=;
X-CSE-ConnectionGUID: pfjDjiOxSViDweMHKorXJw==
X-CSE-MsgGUID: NkKv5oY1RyWpaMZEtzGnKg==
X-IronPort-AV: E=Sophos;i="6.09,276,1716249600"; 
   d="scan'208";a="327783668"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by alln-iport-2.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 16:49:34 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 479Ggo2f031305
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 9 Aug 2024 16:49:34 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 10/14] scsi: fnic: Modify fnic interfaces to use FDLS
Date: Fri,  9 Aug 2024 09:42:36 -0700
Message-Id: <20240809164240.47561-11-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240809164240.47561-1-kartilak@cisco.com>
References: <20240809164240.47561-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-5.cisco.com

Modify fnic driver interfaces to use FDLS and
supporting functions.
Refactor code in fnic_probe and fnic_remove.
Get fnic from shost_priv.
Add error handling in stats processing functions.
Modify some print statements.
Add support to do module unload cleanup.
Use placeholder functions/modify function declarations
to not break compilation.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v1 and v2:
    Incorporate review comments from Hannes from other patches:
	Replace pr_info with dev_info.
	Replace pr_err with dev_err.
---
 drivers/scsi/fnic/fnic.h         |  11 +-
 drivers/scsi/fnic/fnic_attrs.c   |  12 +-
 drivers/scsi/fnic/fnic_debugfs.c |  28 +-
 drivers/scsi/fnic/fnic_fcs.c     |  16 +
 drivers/scsi/fnic/fnic_main.c    | 489 +++++++++++++++++--------------
 drivers/scsi/fnic/fnic_res.c     |  30 +-
 drivers/scsi/fnic/fnic_scsi.c    |  34 +++
 drivers/scsi/fnic/fnic_trace.c   |   6 +
 8 files changed, 376 insertions(+), 250 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index c6fe9eec9a0c..0ae5530cb7c0 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -81,6 +81,7 @@
 #define IS_FNIC_FCP_INITIATOR(fnic) (fnic->role == FNIC_ROLE_FCP_INITIATOR)
 
 #define FNIC_FW_RESET_TIMEOUT        60000	/* mSec   */
+#define FNIC_FCOE_MAX_CMD_LEN        16
 /* Retry supported by rport (returned by PRLI service parameters) */
 #define FNIC_FC_RP_FLAGS_RETRY            0x1
 
@@ -340,6 +341,7 @@ struct fnic {
 	int fnic_num;
 	enum fnic_role_e role;
 	struct fnic_iport_s iport;
+	struct Scsi_Host *host;
 	struct fc_lport *lport;
 	struct fcoe_ctlr ctlr;		/* FIP FCoE controller structure */
 	struct vnic_dev_bar bar0;
@@ -458,11 +460,6 @@ struct fnic {
 	____cacheline_aligned struct vnic_intr intr[FNIC_MSIX_INTR_MAX];
 };
 
-static inline struct fnic *fnic_from_ctlr(struct fcoe_ctlr *fip)
-{
-	return container_of(fip, struct fnic, ctlr);
-}
-
 extern struct workqueue_struct *fnic_event_queue;
 extern struct workqueue_struct *fnic_fip_queue;
 extern const struct attribute_group *fnic_host_groups[];
@@ -491,6 +488,7 @@ int fnic_eh_host_reset_handler(struct scsi_cmnd *sc);
 int fnic_host_reset(struct Scsi_Host *shost);
 void fnic_reset(struct Scsi_Host *shost);
 int fnic_issue_fc_host_lip(struct Scsi_Host *shost);
+void fnic_get_host_port_state(struct Scsi_Host *shost);
 void fnic_scsi_fcpio_reset(struct fnic *fnic);
 int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do, unsigned int cq_index);
 int fnic_wq_cmpl_handler(struct fnic *fnic, int);
@@ -503,7 +501,7 @@ const char *fnic_state_to_str(unsigned int state);
 void fnic_mq_map_queues_cpus(struct Scsi_Host *host);
 void fnic_log_q_error(struct fnic *fnic);
 void fnic_handle_link_event(struct fnic *fnic);
-void fnic_stats_debugfs_init(struct fnic *fnic);
+int fnic_stats_debugfs_init(struct fnic *fnic);
 void fnic_stats_debugfs_remove(struct fnic *fnic);
 int fnic_is_abts_pending(struct fnic *, struct scsi_cmnd *);
 
@@ -532,5 +530,6 @@ unsigned int fnic_count_lun_ioreqs_wq(struct fnic *fnic, u32 hwq,
 						  struct scsi_device *device);
 unsigned int fnic_count_lun_ioreqs(struct fnic *fnic,
 					   struct scsi_device *device);
+void fnic_scsi_unload(struct fnic *fnic);
 
 #endif /* _FNIC_H_ */
diff --git a/drivers/scsi/fnic/fnic_attrs.c b/drivers/scsi/fnic/fnic_attrs.c
index 0c5e57c7e322..705718f0809b 100644
--- a/drivers/scsi/fnic/fnic_attrs.c
+++ b/drivers/scsi/fnic/fnic_attrs.c
@@ -11,8 +11,8 @@
 static ssize_t fnic_show_state(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
-	struct fc_lport *lp = shost_priv(class_to_shost(dev));
-	struct fnic *fnic = lport_priv(lp);
+	struct fnic *fnic =
+		*((struct fnic **) shost_priv(class_to_shost(dev)));
 
 	return sysfs_emit(buf, "%s\n", fnic_state_str[fnic->state]);
 }
@@ -26,9 +26,13 @@ static ssize_t fnic_show_drv_version(struct device *dev,
 static ssize_t fnic_show_link_state(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	struct fc_lport *lp = shost_priv(class_to_shost(dev));
+	struct fnic *fnic =
+		*((struct fnic **) shost_priv(class_to_shost(dev)));
 
-	return sysfs_emit(buf, "%s\n", (lp->link_up) ? "Link Up" : "Link Down");
+	return sysfs_emit(buf, "%s\n",
+					  ((fnic->iport.state != FNIC_IPORT_STATE_INIT) &&
+					   (fnic->iport.state != FNIC_IPORT_STATE_LINK_WAIT)) ?
+					  "Link Up" : "Link Down");
 }
 
 static DEVICE_ATTR(fnic_state, S_IRUGO, fnic_show_state, NULL);
diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 2619a2d4f5f1..3748bbe190f7 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -7,6 +7,9 @@
 #include <linux/vmalloc.h>
 #include "fnic.h"
 
+extern int fnic_get_debug_info(struct stats_debug_info *debug_buffer,
+							   struct fnic *fnic);
+
 static struct dentry *fnic_trace_debugfs_root;
 static struct dentry *fnic_trace_debugfs_file;
 static struct dentry *fnic_trace_enable;
@@ -593,6 +596,7 @@ static int fnic_stats_debugfs_open(struct inode *inode,
 	debug->buf_size = buf_size;
 	memset((void *)debug->debug_buffer, 0, buf_size);
 	debug->buffer_len = fnic_get_stats_data(debug, fnic_stats);
+	debug->buffer_len += fnic_get_debug_info(debug, fnic);
 
 	file->private_data = debug;
 
@@ -673,26 +677,48 @@ static const struct file_operations fnic_reset_debugfs_fops = {
  * It will create file stats and reset_stats under statistics/host# directory
  * to log per fnic stats.
  */
-void fnic_stats_debugfs_init(struct fnic *fnic)
+int fnic_stats_debugfs_init(struct fnic *fnic)
 {
+	int rc = -1;
 	char name[16];
 
 	snprintf(name, sizeof(name), "host%d", fnic->lport->host->host_no);
 
+	if (!fnic_stats_debugfs_root) {
+		pr_debug("fnic_stats root doesn't exist\n");
+		return rc;
+	}
+
 	fnic->fnic_stats_debugfs_host = debugfs_create_dir(name,
 						fnic_stats_debugfs_root);
 
+	if (!fnic->fnic_stats_debugfs_host) {
+		pr_debug("Cannot create host directory\n");
+		return rc;
+	}
+
 	fnic->fnic_stats_debugfs_file = debugfs_create_file("stats",
 						S_IFREG|S_IRUGO|S_IWUSR,
 						fnic->fnic_stats_debugfs_host,
 						fnic,
 						&fnic_stats_debugfs_fops);
 
+	if (!fnic->fnic_stats_debugfs_file) {
+		pr_debug("Cannot create host stats file\n");
+		return rc;
+	}
+
 	fnic->fnic_reset_debugfs_file = debugfs_create_file("reset_stats",
 						S_IFREG|S_IRUGO|S_IWUSR,
 						fnic->fnic_stats_debugfs_host,
 						fnic,
 						&fnic_reset_debugfs_fops);
+	if (!fnic->fnic_reset_debugfs_file) {
+		pr_debug("Cannot create host stats file\n");
+		return rc;
+	}
+	rc = 0;
+	return rc;
 }
 
 /*
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 0bc2099d0113..8cf7e4364114 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -80,6 +80,22 @@ static inline  void fnic_fdls_set_fcoe_dstmac(struct fnic *fnic,
 	memcpy(fnic->iport.fcfmac, dst_mac, 6);
 }
 
+void fnic_get_host_port_state(struct Scsi_Host *shost)
+{
+	struct fnic *fnic = *((struct fnic **) shost_priv(shost));
+	struct fnic_iport_s *iport = &fnic->iport;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if (!fnic->link_status)
+		fc_host_port_state(shost) = FC_PORTSTATE_LINKDOWN;
+	else if (iport->state == FNIC_IPORT_STATE_READY)
+		fc_host_port_state(shost) = FC_PORTSTATE_ONLINE;
+	else
+		fc_host_port_state(shost) = FC_PORTSTATE_OFFLINE;
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+}
+
 void fnic_fdls_link_status_change(struct fnic *fnic, int linkup)
 {
 	struct fnic_iport_s *iport = &fnic->iport;
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 4729edbba18c..644bdf7e7c76 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -66,6 +66,11 @@ unsigned int fnic_fdmi_support = 1;
 module_param(fnic_fdmi_support, int, 0644);
 MODULE_PARM_DESC(fnic_fdmi_support, "FDMI support");
 
+unsigned int fnic_tgt_id_binding = 1;
+module_param(fnic_tgt_id_binding, uint, 0644);
+MODULE_PARM_DESC(fnic_tgt_id_binding,
+		 "Target ID binding (0 for none. 1 for binding by WWPN (default))");
+
 unsigned int io_completions = FNIC_DFLT_IO_COMPLETIONS;
 module_param(io_completions, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(io_completions, "Max CQ entries to process at a time");
@@ -84,9 +89,6 @@ static unsigned int fnic_max_qdepth = FNIC_DFLT_QUEUE_DEPTH;
 module_param(fnic_max_qdepth, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(fnic_max_qdepth, "Queue depth to report for each LUN");
 
-static struct libfc_function_template fnic_transport_template = {
-};
-
 struct workqueue_struct *fnic_fip_queue;
 
 static int fnic_slave_alloc(struct scsi_device *sdev)
@@ -148,7 +150,7 @@ static struct fc_function_template fnic_fc_functions = {
 	.get_host_speed = fnic_get_host_speed,
 	.show_host_speed = 1,
 	.show_host_port_type = 1,
-	.get_host_port_state = fc_get_host_port_state,
+	.get_host_port_state = fnic_get_host_port_state,
 	.show_host_port_state = 1,
 	.show_host_symbolic_name = 1,
 	.show_rport_maxframe_size = 1,
@@ -160,79 +162,78 @@ static struct fc_function_template fnic_fc_functions = {
 	.show_rport_dev_loss_tmo = 1,
 	.set_rport_dev_loss_tmo = fnic_set_rport_dev_loss_tmo,
 	.issue_fc_host_lip = fnic_issue_fc_host_lip,
-	.get_fc_host_stats = fnic_get_stats,
+	.get_fc_host_stats = NULL,
 	.reset_fc_host_stats = fnic_reset_host_stats,
-	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
+	.dd_fcrport_size = sizeof(struct rport_dd_data_s),
 	.terminate_rport_io = fnic_terminate_rport_io,
-	.bsg_request = fc_lport_bsg_request,
+	.bsg_request = NULL,
 };
 
 static void fnic_get_host_speed(struct Scsi_Host *shost)
 {
-	struct fc_lport *lp = shost_priv(shost);
-	struct fnic *fnic = lport_priv(lp);
+	struct fnic *fnic = *((struct fnic **) shost_priv(shost));
 	u32 port_speed = vnic_dev_port_speed(fnic->vdev);
 
+	FNIC_MAIN_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				  "port_speed: %d Mbps", port_speed);
+
 	/* Add in other values as they get defined in fw */
 	switch (port_speed) {
+	case DCEM_PORTSPEED_1G:
+		fc_host_speed(shost) = FC_PORTSPEED_1GBIT;
+		break;
+	case DCEM_PORTSPEED_2G:
+		fc_host_speed(shost) = FC_PORTSPEED_2GBIT;
+		break;
+	case DCEM_PORTSPEED_4G:
+		fc_host_speed(shost) = FC_PORTSPEED_4GBIT;
+		break;
+	case DCEM_PORTSPEED_8G:
+		fc_host_speed(shost) = FC_PORTSPEED_8GBIT;
+		break;
 	case DCEM_PORTSPEED_10G:
 		fc_host_speed(shost) = FC_PORTSPEED_10GBIT;
 		break;
+	case DCEM_PORTSPEED_16G:
+		fc_host_speed(shost) = FC_PORTSPEED_16GBIT;
+		break;
 	case DCEM_PORTSPEED_20G:
 		fc_host_speed(shost) = FC_PORTSPEED_20GBIT;
 		break;
 	case DCEM_PORTSPEED_25G:
 		fc_host_speed(shost) = FC_PORTSPEED_25GBIT;
 		break;
+	case DCEM_PORTSPEED_32G:
+		fc_host_speed(shost) = FC_PORTSPEED_32GBIT;
+		break;
 	case DCEM_PORTSPEED_40G:
 	case DCEM_PORTSPEED_4x10G:
 		fc_host_speed(shost) = FC_PORTSPEED_40GBIT;
 		break;
+	case DCEM_PORTSPEED_50G:
+		fc_host_speed(shost) = FC_PORTSPEED_50GBIT;
+		break;
+	case DCEM_PORTSPEED_64G:
+		fc_host_speed(shost) = FC_PORTSPEED_64GBIT;
+		break;
 	case DCEM_PORTSPEED_100G:
 		fc_host_speed(shost) = FC_PORTSPEED_100GBIT;
 		break;
+	case DCEM_PORTSPEED_128G:
+		fc_host_speed(shost) = FC_PORTSPEED_128GBIT;
+		break;
 	default:
+		FNIC_MAIN_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+					  "Unknown FC speed: %d Mbps", port_speed);
 		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 		break;
 	}
 }
 
+/* Placeholder function */
 static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *host)
 {
-	int ret;
-	struct fc_lport *lp = shost_priv(host);
-	struct fnic *fnic = lport_priv(lp);
-	struct fc_host_statistics *stats = &lp->host_stats;
-	struct vnic_stats *vs;
-	unsigned long flags;
-
-	if (time_before(jiffies, fnic->stats_time + HZ / FNIC_STATS_RATE_LIMIT))
-		return stats;
-	fnic->stats_time = jiffies;
-
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	ret = vnic_dev_stats_dump(fnic->vdev, &fnic->stats);
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-	if (ret) {
-		FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
-			      "fnic: Get vnic stats failed"
-			      " 0x%x", ret);
-		return stats;
-	}
-	vs = fnic->stats;
-	stats->tx_frames = vs->tx.tx_unicast_frames_ok;
-	stats->tx_words  = vs->tx.tx_unicast_bytes_ok / 4;
-	stats->rx_frames = vs->rx.rx_unicast_frames_ok;
-	stats->rx_words  = vs->rx.rx_unicast_bytes_ok / 4;
-	stats->error_frames = vs->tx.tx_errors + vs->rx.rx_errors;
-	stats->dumped_frames = vs->tx.tx_drops + vs->rx.rx_drop;
-	stats->invalid_crc_count = vs->rx.rx_crc_errors;
-	stats->seconds_since_last_reset =
-			(jiffies - fnic->stats_reset_time) / HZ;
-	stats->fcp_input_megabytes = div_u64(fnic->fcp_input_bytes, 1000000);
-	stats->fcp_output_megabytes = div_u64(fnic->fcp_output_bytes, 1000000);
-
+	struct fc_host_statistics *stats;
 	return stats;
 }
 
@@ -313,8 +314,7 @@ void fnic_dump_fchost_stats(struct Scsi_Host *host,
 static void fnic_reset_host_stats(struct Scsi_Host *host)
 {
 	int ret;
-	struct fc_lport *lp = shost_priv(host);
-	struct fnic *fnic = lport_priv(lp);
+	struct fnic *fnic = *((struct fnic **) shost_priv(host));
 	struct fc_host_statistics *stats;
 	unsigned long flags;
 
@@ -527,9 +527,23 @@ static void fnic_set_vlan(struct fnic *fnic, u16 vlan_id)
 	vnic_dev_set_default_vlan(fnic->vdev, vlan_id);
 }
 
+static void fnic_scsi_init(struct fnic *fnic)
+{
+	struct Scsi_Host *host = fnic->host;
+
+	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
+			 host->host_no);
+
+	host->transportt = fnic_fc_transport;
+}
+
 static int fnic_scsi_drv_init(struct fnic *fnic)
 {
 	struct Scsi_Host *host = fnic->lport->host;
+	int err;
+	struct pci_dev *pdev = fnic->pdev;
+	struct fnic_iport_s *iport = &fnic->iport;
+	int hwq;
 
 	/* Configure maximum outstanding IO reqs*/
 	if (fnic->config.io_throttle_count != FNIC_UCSM_DFLT_THROTTLE_CNT_BLD)
@@ -540,7 +554,7 @@ static int fnic_scsi_drv_init(struct fnic *fnic)
 	fnic->fnic_max_tag_id = host->can_queue;
 	host->max_lun = fnic->config.luns_per_tgt;
 	host->max_id = FNIC_MAX_FCP_TARGET;
-	host->max_cmd_len = FCOE_MAX_CMD_LEN;
+	host->max_cmd_len = FNIC_FCOE_MAX_CMD_LEN;
 
 	host->nr_hw_queues = fnic->wq_copy_count;
 
@@ -550,13 +564,62 @@ static int fnic_scsi_drv_init(struct fnic *fnic)
 	dev_info(&fnic->pdev->dev, "fnic: max_id: %d max_cmd_len: %d nr_hw_queues: %d",
 			host->max_id, host->max_cmd_len, host->nr_hw_queues);
 
+	for (hwq = 0; hwq < fnic->wq_copy_count; hwq++) {
+		fnic->sw_copy_wq[hwq].ioreq_table_size = fnic->fnic_max_tag_id;
+		fnic->sw_copy_wq[hwq].io_req_table =
+			kzalloc((fnic->sw_copy_wq[hwq].ioreq_table_size + 1) *
+					sizeof(struct fnic_io_req *), GFP_KERNEL);
+	}
+
+	dev_info(&fnic->pdev->dev, "fnic copy wqs: %d, Q0 ioreq table size: %d\n",
+			fnic->wq_copy_count, fnic->sw_copy_wq[0].ioreq_table_size);
+
+	fnic_scsi_init(fnic);
+
+	err = scsi_add_host(fnic->host, &pdev->dev);
+	if (err) {
+		dev_err(&fnic->pdev->dev, "fnic: scsi add host failed: aborting\n");
+		return -1;
+	}
+	fc_host_maxframe_size(fnic->host) = iport->max_payload_size;
+	fc_host_dev_loss_tmo(fnic->host) =
+		fnic->config.port_down_timeout / 1000;
+	sprintf(fc_host_symbolic_name(fnic->host),
+			DRV_NAME " v" DRV_VERSION " over %s", fnic->name);
+	fc_host_port_type(fnic->host) = FC_PORTTYPE_NPORT;
+	fc_host_node_name(fnic->host) = iport->wwnn;
+	fc_host_port_name(fnic->host) = iport->wwpn;
+	fc_host_supported_classes(fnic->host) = FC_COS_CLASS3;
+	memset(fc_host_supported_fc4s(fnic->host), 0,
+		   sizeof(fc_host_supported_fc4s(fnic->host)));
+	fc_host_supported_fc4s(fnic->host)[2] = 1;
+	fc_host_supported_fc4s(fnic->host)[7] = 1;
+	fc_host_supported_speeds(fnic->host) = 0;
+	fc_host_supported_speeds(fnic->host) |= FC_PORTSPEED_8GBIT;
+
+	dev_info(&fnic->pdev->dev, "shost_data: 0x%p\n", fnic->host->shost_data);
+	if (fnic->host->shost_data != NULL) {
+		if (fnic_tgt_id_binding == 0) {
+			dev_info(&fnic->pdev->dev, "Setting target binding to NONE\n");
+			fc_host_tgtid_bind_type(fnic->host) = FC_TGTID_BIND_NONE;
+		} else {
+			dev_info(&fnic->pdev->dev, "Setting target binding to WWPN\n");
+			fc_host_tgtid_bind_type(fnic->host) = FC_TGTID_BIND_BY_WWPN;
+		}
+	}
+
+	fnic->io_req_pool = mempool_create_slab_pool(2, fnic_io_req_cache);
+	if (!fnic->io_req_pool) {
+		scsi_remove_host(fnic->host);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
 void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
 {
-	struct fc_lport *lp = shost_priv(host);
-	struct fnic *fnic = lport_priv(lp);
+	struct fnic *fnic = *((struct fnic **) shost_priv(host));
 	struct pci_dev *l_pdev = fnic->pdev;
 	int intr_mode = fnic->config.intr_mode;
 	struct blk_mq_queue_map *qmap = &host->tag_set.map[HCTX_TYPE_DEFAULT];
@@ -581,31 +644,27 @@ void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
 
 static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	struct Scsi_Host *host;
-	struct fc_lport *lp;
+	struct Scsi_Host *host = NULL;
 	struct fnic *fnic;
 	mempool_t *pool;
+	struct fnic_iport_s *iport;
 	int err = 0;
 	int fnic_id = 0;
 	int i;
 	unsigned long flags;
-	int hwq;
 	char *desc, *subsys_desc;
 	int len;
 
 	/*
-	 * Allocate SCSI Host and set up association between host,
-	 * local port, and fnic
+	 * Allocate fnic
 	 */
-	lp = libfc_host_alloc(&fnic_host_template, sizeof(struct fnic));
-	if (!lp) {
-		dev_err(&pdev->dev, "Unable to alloc libfc local port\n");
+	fnic = kzalloc(sizeof(struct fnic), GFP_KERNEL);
+	if (!fnic) {
 		err = -ENOMEM;
-		goto err_out;
+		goto err_out_fnic_alloc;
 	}
 
-	host = lp->host;
-	fnic = lport_priv(lp);
+	iport = &fnic->iport;
 
 	fnic_id = ida_alloc(&fnic_ida, GFP_KERNEL);
 	if (fnic_id < 0) {
@@ -613,17 +672,9 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		err = fnic_id;
 		goto err_out_ida_alloc;
 	}
-	fnic->lport = lp;
-	fnic->ctlr.lp = lp;
-	fnic->link_events = 0;
-	fnic->pdev = pdev;
-
-	snprintf(fnic->name, sizeof(fnic->name) - 1, "%s%d", DRV_NAME,
-		 host->host_no);
 
-	host->transportt = fnic_fc_transport;
+	fnic->pdev = pdev;
 	fnic->fnic_num = fnic_id;
-	fnic_stats_debugfs_init(fnic);
 
 	/* Find model name from PCIe subsys ID */
 	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0) {
@@ -645,13 +696,13 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Cannot enable PCI device, aborting.\n");
-		goto err_out_free_hba;
+		goto err_out_pci_enable_device;
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Cannot enable PCI resources, aborting\n");
-		goto err_out_disable_device;
+		goto err_out_pci_request_regions;
 	}
 
 	pci_set_master(pdev);
@@ -666,7 +717,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (err) {
 			dev_err(&fnic->pdev->dev, "No usable DMA configuration "
 				     "aborting\n");
-			goto err_out_release_regions;
+			goto err_out_set_dma_mask;
 		}
 	}
 
@@ -674,7 +725,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
 		dev_err(&fnic->pdev->dev, "BAR0 not memory-map'able, aborting.\n");
 		err = -ENODEV;
-		goto err_out_release_regions;
+		goto err_out_map_bar;
 	}
 
 	fnic->bar0.vaddr = pci_iomap(pdev, 0, 0);
@@ -685,7 +736,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&fnic->pdev->dev, "Cannot memory-map BAR0 res hdr, "
 			     "aborting.\n");
 		err = -ENODEV;
-		goto err_out_release_regions;
+		goto err_out_fnic_map_bar;
 	}
 
 	fnic->vdev = vnic_dev_register(NULL, fnic, pdev, &fnic->bar0);
@@ -693,43 +744,67 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&fnic->pdev->dev, "vNIC registration failed, "
 			     "aborting.\n");
 		err = -ENODEV;
-		goto err_out_iounmap;
+		goto err_out_dev_register;
 	}
 
 	err = vnic_dev_cmd_init(fnic->vdev);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "vnic_dev_cmd_init() returns %d, aborting\n",
 				err);
-		goto err_out_vnic_unregister;
+		goto err_out_dev_cmd_init;
 	}
 
 	err = fnic_dev_wait(fnic->vdev, vnic_dev_open,
 			    vnic_dev_open_done, CMD_OPENF_RQ_ENABLE_THEN_POST);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "vNIC dev open failed, aborting.\n");
-		goto err_out_dev_cmd_deinit;
+		goto err_out_dev_open;
 	}
 
 	err = vnic_dev_init(fnic->vdev, 0);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "vNIC dev init failed, aborting.\n");
-		goto err_out_dev_close;
+		goto err_out_dev_init;
 	}
 
-	err = vnic_dev_mac_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
+	err = vnic_dev_mac_addr(fnic->vdev, iport->hwmac);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "vNIC get MAC addr failed\n");
-		goto err_out_dev_close;
+		goto err_out_dev_mac_addr;
 	}
 	/* set data_src for point-to-point mode and to keep it non-zero */
-	memcpy(fnic->data_src_addr, fnic->ctlr.ctl_src_addr, ETH_ALEN);
+	memcpy(fnic->data_src_addr, iport->hwmac, ETH_ALEN);
 
 	/* Get vNIC configuration */
 	err = fnic_get_vnic_config(fnic);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Get vNIC configuration failed, "
 			     "aborting.\n");
-		goto err_out_dev_close;
+		goto err_out_fnic_get_config;
+	}
+
+	switch (fnic->config.flags & 0xff0) {
+	case VFCF_FC_INITIATOR:
+		{
+			host =
+				scsi_host_alloc(&fnic_host_template,
+								sizeof(struct fnic *));
+			if (!host) {
+				dev_err(&fnic->pdev->dev, "Unable to allocate scsi host\n");
+				err = -ENOMEM;
+				goto err_out_scsi_host_alloc;
+			}
+			*((struct fnic **) shost_priv(host)) = fnic;
+
+			fnic->host = host;
+			fnic->role = FNIC_ROLE_FCP_INITIATOR;
+			dev_info(&fnic->pdev->dev, "fnic: %d is scsi initiator\n",
+					fnic->fnic_num);
+		}
+		break;
+	default:
+		dev_info(&fnic->pdev->dev, "fnic: %d has no role defined\n", fnic->fnic_num);
+		goto err_out_fnic_role;
 	}
 
 	/* Setup PCI resources */
@@ -741,23 +816,14 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Failed to set intr mode, "
 			     "aborting.\n");
-		goto err_out_dev_close;
+		goto err_out_fnic_set_intr_mode;
 	}
 
 	err = fnic_alloc_vnic_resources(fnic);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Failed to alloc vNIC resources, "
 			     "aborting.\n");
-		goto err_out_clear_intr;
-	}
-
-	fnic_scsi_drv_init(fnic);
-
-	for (hwq = 0; hwq < fnic->wq_copy_count; hwq++) {
-		fnic->sw_copy_wq[hwq].ioreq_table_size = fnic->fnic_max_tag_id;
-		fnic->sw_copy_wq[hwq].io_req_table =
-					kzalloc((fnic->sw_copy_wq[hwq].ioreq_table_size + 1) *
-					sizeof(struct fnic_io_req *), GFP_KERNEL);
+		goto err_out_fnic_alloc_vnic_res;
 	}
 	dev_info(&fnic->pdev->dev, "fnic copy wqs: %d, Q0 ioreq table size: %d\n",
 			fnic->wq_copy_count, fnic->sw_copy_wq[0].ioreq_table_size);
@@ -775,14 +841,9 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		fnic->fw_ack_index[i] = -1;
 	}
 
-	err = -ENOMEM;
-	fnic->io_req_pool = mempool_create_slab_pool(2, fnic_io_req_cache);
-	if (!fnic->io_req_pool)
-		goto err_out_free_resources;
-
 	pool = mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
 	if (!pool)
-		goto err_out_free_ioreq_pool;
+		goto err_out_free_resources;
 	fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT] = pool;
 
 	pool = mempool_create_slab_pool(2, fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
@@ -799,8 +860,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* enable directed and multicast */
 		vnic_dev_packet_filter(fnic->vdev, 1, 1, 0, 0, 0);
 		vnic_dev_add_addr(fnic->vdev, FIP_ALL_ENODE_MACS);
-		vnic_dev_add_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
-		fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_AUTO);
+		vnic_dev_add_addr(fnic->vdev, iport->hwmac);
 		spin_lock_init(&fnic->vlans_lock);
 		INIT_WORK(&fnic->fip_frame_work, fnic_handle_fip_frame);
 		INIT_WORK(&fnic->flush_work, fnic_flush_tx);
@@ -813,8 +873,6 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		fnic->set_vlan = fnic_set_vlan;
 	} else {
 		dev_info(&fnic->pdev->dev, "firmware uses non-FIP mode\n");
-		fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_NON_FIP);
-		fnic->ctlr.state = FIP_ST_NON_FIP;
 	}
 	fnic->state = FNIC_IN_FC_MODE;
 
@@ -828,7 +886,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = fnic_notify_set(fnic);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Failed to alloc notify buffer, aborting.\n");
-		goto err_out_free_max_pool;
+		goto err_out_fnic_notify_set;
 	}
 
 	/* Setup notify timer when using MSI interrupts */
@@ -841,10 +899,52 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		if (err) {
 			dev_err(&fnic->pdev->dev, "fnic_alloc_rq_frame can't alloc "
 				     "frame\n");
-			goto err_out_rq_buf;
+			goto err_out_alloc_rq_buf;
 		}
 	}
 
+	init_completion(&fnic->reset_completion_wait);
+
+	/* Start local port initialization */
+	iport->max_flogi_retries = fnic->config.flogi_retries;
+	iport->max_plogi_retries = fnic->config.plogi_retries;
+	iport->plogi_timeout = fnic->config.plogi_timeout;
+	iport->service_params =
+		(FNIC_FCP_SP_INITIATOR | FNIC_FCP_SP_RD_XRDY_DIS |
+		 FNIC_FCP_SP_CONF_CMPL);
+	if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
+		iport->service_params |= FNIC_FCP_SP_RETRY;
+
+	iport->boot_time = jiffies;
+	iport->e_d_tov = fnic->config.ed_tov;
+	iport->r_a_tov = fnic->config.ra_tov;
+	iport->link_supported_speeds = FNIC_PORTSPEED_10GBIT;
+	iport->wwpn = fnic->config.port_wwn;
+	iport->wwnn = fnic->config.node_wwn;
+
+	iport->max_payload_size = fnic->config.maxdatafieldsize;
+
+	if ((iport->max_payload_size < FNIC_MIN_DATA_FIELD_SIZE) ||
+		(iport->max_payload_size > FNIC_FC_MAX_PAYLOAD_LEN) ||
+		((iport->max_payload_size % 4) != 0)) {
+		iport->max_payload_size = FNIC_FC_MAX_PAYLOAD_LEN;
+	}
+
+	iport->flags |= FNIC_FIRST_LINK_UP;
+
+	timer_setup(&(iport->fabric.retry_timer), fdls_fabric_timer_callback,
+				0);
+
+	fnic->stats_reset_time = jiffies;
+
+	INIT_WORK(&fnic->link_work, fnic_handle_link);
+	INIT_WORK(&fnic->frame_work, fnic_handle_frame);
+	INIT_WORK(&fnic->tport_work, fnic_tport_event_handler);
+
+	INIT_LIST_HEAD(&fnic->frame_queue);
+	INIT_LIST_HEAD(&fnic->tx_queue);
+	INIT_LIST_HEAD(&fnic->tport_event_list);
+
 	/* Enable all queues */
 	for (i = 0; i < fnic->raw_wq_count; i++)
 		vnic_wq_enable(&fnic->wq[i]);
@@ -855,158 +955,105 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < fnic->wq_copy_count; i++)
 		vnic_wq_copy_enable(&fnic->hw_copy_wq[i]);
 
+	vnic_dev_enable(fnic->vdev);
+
 	err = fnic_request_intr(fnic);
 	if (err) {
 		dev_err(&fnic->pdev->dev, "Unable to request irq.\n");
-		goto err_out_request_intr;
+		goto err_out_fnic_request_intr;
 	}
 
-	/*
-	 * Initialization done with PCI system, hardware, firmware.
-	 * Add host to SCSI
-	 */
-	err = scsi_add_host(lp->host, &pdev->dev);
-	if (err) {
-		dev_err(&fnic->pdev->dev, "fnic: scsi_add_host failed...exiting\n");
-		goto err_out_scsi_add_host;
-	}
-
-
-	/* Start local port initiatialization */
-
-	lp->link_up = 0;
-
-	lp->max_retry_count = fnic->config.flogi_retries;
-	lp->max_rport_retry_count = fnic->config.plogi_retries;
-	lp->service_params = (FCP_SPPF_INIT_FCN | FCP_SPPF_RD_XRDY_DIS |
-			      FCP_SPPF_CONF_COMPL);
-	if (fnic->config.flags & VFCF_FCP_SEQ_LVL_ERR)
-		lp->service_params |= FCP_SPPF_RETRY;
-
-	lp->boot_time = jiffies;
-	lp->e_d_tov = fnic->config.ed_tov;
-	lp->r_a_tov = fnic->config.ra_tov;
-	lp->link_supported_speeds = FC_PORTSPEED_10GBIT;
-	fc_set_wwnn(lp, fnic->config.node_wwn);
-	fc_set_wwpn(lp, fnic->config.port_wwn);
-
-	fcoe_libfc_config(lp, &fnic->ctlr, &fnic_transport_template, 0);
-
-	if (!fc_exch_mgr_alloc(lp, FC_CLASS_3, FCPIO_HOST_EXCH_RANGE_START,
-			       FCPIO_HOST_EXCH_RANGE_END, NULL)) {
-		err = -ENOMEM;
-		goto err_out_fc_exch_mgr_alloc;
-	}
+	fnic_notify_timer_start(fnic);
 
-	fc_lport_init_stats(lp);
-	fnic->stats_reset_time = jiffies;
+	fnic_fdls_init(fnic, (fnic->config.flags & VFCF_FIP_CAPABLE));
 
-	fc_lport_config(lp);
+	if (IS_FNIC_FCP_INITIATOR(fnic) && fnic_scsi_drv_init(fnic))
+		goto err_out_scsi_drv_init;
 
-	if (fc_set_mfs(lp, fnic->config.maxdatafieldsize +
-		       sizeof(struct fc_frame_header))) {
-		err = -EINVAL;
-		goto err_out_free_exch_mgr;
+	err = fnic_stats_debugfs_init(fnic);
+	if (err) {
+		dev_err(&fnic->pdev->dev, "Failed to initialize debugfs for stats\n");
+		goto err_out_free_stats_debugfs;
 	}
-	fc_host_maxframe_size(lp->host) = lp->mfs;
-	fc_host_dev_loss_tmo(lp->host) = fnic->config.port_down_timeout / 1000;
 
-	sprintf(fc_host_symbolic_name(lp->host),
-		DRV_NAME " v" DRV_VERSION " over %s", fnic->name);
+	for (i = 0; i < fnic->intr_count; i++)
+		vnic_intr_unmask(&fnic->intr[i]);
 
 	spin_lock_irqsave(&fnic_list_lock, flags);
 	list_add_tail(&fnic->list, &fnic_list);
 	spin_unlock_irqrestore(&fnic_list_lock, flags);
 
-	INIT_WORK(&fnic->link_work, fnic_handle_link);
-	INIT_WORK(&fnic->frame_work, fnic_handle_frame);
-	INIT_WORK(&fnic->tport_work, fnic_tport_event_handler);
-	INIT_LIST_HEAD(&fnic->frame_queue);
-	INIT_LIST_HEAD(&fnic->tx_queue);
-	INIT_LIST_HEAD(&fnic->tport_event_list);
-
-	fc_fabric_login(lp);
-
-	vnic_dev_enable(fnic->vdev);
-
-	for (i = 0; i < fnic->intr_count; i++)
-		vnic_intr_unmask(&fnic->intr[i]);
-
-	fnic_notify_timer_start(fnic);
-
 	return 0;
 
-err_out_free_exch_mgr:
-	fc_exch_mgr_free(lp);
-err_out_fc_exch_mgr_alloc:
-	fc_remove_host(lp->host);
-	scsi_remove_host(lp->host);
-err_out_scsi_add_host:
+err_out_free_stats_debugfs:
+	fnic_stats_debugfs_remove(fnic);
+	scsi_remove_host(fnic->host);
+err_out_scsi_drv_init:
 	fnic_free_intr(fnic);
-err_out_request_intr:
-	for (i = 0; i < fnic->rq_count; i++)
+err_out_fnic_request_intr:
+err_out_alloc_rq_buf:
+	for (i = 0; i < fnic->rq_count; i++) {
+		if (ioread32(&fnic->rq[i].ctrl->enable))
+			vnic_rq_disable(&fnic->rq[i]);
 		vnic_rq_clean(&fnic->rq[i], fnic_free_rq_buf);
-err_out_rq_buf:
+	}
 	vnic_dev_notify_unset(fnic->vdev);
-err_out_free_max_pool:
+err_out_fnic_notify_set:
 	mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_MAX]);
 err_out_free_dflt_pool:
 	mempool_destroy(fnic->io_sgl_pool[FNIC_SGL_CACHE_DFLT]);
-err_out_free_ioreq_pool:
-	mempool_destroy(fnic->io_req_pool);
 err_out_free_resources:
-	for (hwq = 0; hwq < fnic->wq_copy_count; hwq++)
-		kfree(fnic->sw_copy_wq[hwq].io_req_table);
 	fnic_free_vnic_resources(fnic);
-err_out_clear_intr:
+err_out_fnic_alloc_vnic_res:
 	fnic_clear_intr_mode(fnic);
-err_out_dev_close:
+err_out_fnic_set_intr_mode:
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		scsi_host_put(fnic->host);
+err_out_fnic_role:
+err_out_scsi_host_alloc:
+err_out_fnic_get_config:
+err_out_dev_mac_addr:
+err_out_dev_init:
 	vnic_dev_close(fnic->vdev);
-err_out_dev_cmd_deinit:
-err_out_vnic_unregister:
+err_out_dev_open:
+err_out_dev_cmd_init:
 	vnic_dev_unregister(fnic->vdev);
-err_out_iounmap:
+err_out_dev_register:
 	fnic_iounmap(fnic);
-err_out_release_regions:
+err_out_fnic_map_bar:
+err_out_map_bar:
+err_out_set_dma_mask:
 	pci_release_regions(pdev);
-err_out_disable_device:
+err_out_pci_request_regions:
 	pci_disable_device(pdev);
-err_out_free_hba:
-	fnic_stats_debugfs_remove(fnic);
+err_out_pci_enable_device:
 	ida_free(&fnic_ida, fnic->fnic_num);
 err_out_ida_alloc:
-	scsi_host_put(lp->host);
-err_out:
+	kfree(fnic);
+err_out_fnic_alloc:
 	return err;
 }
 
 static void fnic_remove(struct pci_dev *pdev)
 {
 	struct fnic *fnic = pci_get_drvdata(pdev);
-	struct fc_lport *lp = fnic->lport;
 	unsigned long flags;
-	int hwq;
 
-	/*
-	 * Mark state so that the workqueue thread stops forwarding
-	 * received frames and link events to the local port. ISR and
-	 * other threads that can queue work items will also stop
-	 * creating work items on the fnic workqueue
-	 */
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	fnic->stop_rx_link_events = 1;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
-	if (vnic_dev_get_intr_mode(fnic->vdev) == VNIC_DEV_INTR_MODE_MSI)
-		del_timer_sync(&fnic->notify_timer);
-
 	/*
 	 * Flush the fnic event queue. After this call, there should
 	 * be no event queued for this fnic device in the workqueue
 	 */
 	flush_workqueue(fnic_event_queue);
-	fnic_free_txq(&fnic->frame_queue);
-	fnic_free_txq(&fnic->tx_queue);
+
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		fnic_scsi_unload(fnic);
+
+	if (vnic_dev_get_intr_mode(fnic->vdev) == VNIC_DEV_INTR_MODE_MSI)
+		del_timer_sync(&fnic->notify_timer);
 
 	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
 		del_timer_sync(&fnic->retry_fip_timer);
@@ -1021,19 +1068,6 @@ static void fnic_remove(struct pci_dev *pdev)
 	if ((fnic_fdmi_support == 1) && (fnic->iport.fabric.fdmi_pending > 0))
 		del_timer_sync(&fnic->iport.fabric.fdmi_timer);
 
-	/*
-	 * Log off the fabric. This stops all remote ports, dns port,
-	 * logs off the fabric. This flushes all rport, disc, lport work
-	 * before returning
-	 */
-	fc_fabric_logoff(fnic->lport);
-
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	fnic->in_remove = 1;
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-	fcoe_ctlr_destroy(&fnic->ctlr);
-	fc_lport_destroy(lp);
 	fnic_stats_debugfs_remove(fnic);
 
 	/*
@@ -1047,11 +1081,9 @@ static void fnic_remove(struct pci_dev *pdev)
 	list_del(&fnic->list);
 	spin_unlock_irqrestore(&fnic_list_lock, flags);
 
-	fc_remove_host(fnic->lport->host);
-	scsi_remove_host(fnic->lport->host);
-	for (hwq = 0; hwq < fnic->wq_copy_count; hwq++)
-		kfree(fnic->sw_copy_wq[hwq].io_req_table);
-	fc_exch_mgr_free(fnic->lport);
+	fnic_free_txq(&fnic->frame_queue);
+	fnic_free_txq(&fnic->tx_queue);
+
 	vnic_dev_notify_unset(fnic->vdev);
 	fnic_free_intr(fnic);
 	fnic_free_vnic_resources(fnic);
@@ -1061,8 +1093,11 @@ static void fnic_remove(struct pci_dev *pdev)
 	fnic_iounmap(fnic);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
+	pci_set_drvdata(pdev, NULL);
 	ida_free(&fnic_ida, fnic->fnic_num);
-	scsi_host_put(lp->host);
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		scsi_host_put(fnic->host);
+	kfree(fnic);
 }
 
 static struct pci_driver fnic_driver = {
@@ -1190,8 +1225,10 @@ static void __exit fnic_cleanup_module(void)
 {
 	pci_unregister_driver(&fnic_driver);
 	destroy_workqueue(fnic_event_queue);
-	if (fnic_fip_queue)
+	if (fnic_fip_queue) {
+		flush_workqueue(fnic_fip_queue);
 		destroy_workqueue(fnic_fip_queue);
+	}
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_MAX]);
 	kmem_cache_destroy(fnic_sgl_cache[FNIC_SGL_CACHE_DFLT]);
 	kmem_cache_destroy(fnic_io_req_cache);
diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
index dd24e25574db..763475587b7f 100644
--- a/drivers/scsi/fnic/fnic_res.c
+++ b/drivers/scsi/fnic/fnic_res.c
@@ -58,6 +58,11 @@ int fnic_get_vnic_config(struct fnic *fnic)
 	GET_CONFIG(intr_mode);
 	GET_CONFIG(wq_copy_count);
 
+	if ((c->flags & (VFCF_FC_INITIATOR)) == 0) {
+		dev_info(&fnic->pdev->dev, "vNIC role not defined (def role: FC Init)\n");
+		c->flags |= VFCF_FC_INITIATOR;
+	}
+
 	c->wq_enet_desc_count =
 		min_t(u32, VNIC_FNIC_WQ_DESCS_MAX,
 		      max_t(u32, VNIC_FNIC_WQ_DESCS_MIN,
@@ -137,29 +142,28 @@ int fnic_get_vnic_config(struct fnic *fnic)
 
 	c->wq_copy_count = min_t(u16, FNIC_WQ_COPY_MAX, c->wq_copy_count);
 
-	dev_info(&fnic->pdev->dev, "vNIC MAC addr %pM "
-		     "wq/wq_copy/rq %d/%d/%d\n",
-		     fnic->ctlr.ctl_src_addr,
+	dev_info(&fnic->pdev->dev, "fNIC MAC addr %p wq/wq_copy/rq %d/%d/%d\n",
+			fnic->data_src_addr,
 		     c->wq_enet_desc_count, c->wq_copy_desc_count,
 		     c->rq_desc_count);
-	dev_info(&fnic->pdev->dev, "vNIC node wwn %llx port wwn %llx\n",
+	dev_info(&fnic->pdev->dev, "fNIC node wwn 0x%llx port wwn 0x%llx\n",
 		     c->node_wwn, c->port_wwn);
-	dev_info(&fnic->pdev->dev, "vNIC ed_tov %d ra_tov %d\n",
+	dev_info(&fnic->pdev->dev, "fNIC ed_tov %d ra_tov %d\n",
 		     c->ed_tov, c->ra_tov);
-	dev_info(&fnic->pdev->dev, "vNIC mtu %d intr timer %d\n",
+	dev_info(&fnic->pdev->dev, "fNIC mtu %d intr timer %d\n",
 		     c->maxdatafieldsize, c->intr_timer);
-	dev_info(&fnic->pdev->dev, "vNIC flags 0x%x luns per tgt %d\n",
+	dev_info(&fnic->pdev->dev, "fNIC flags 0x%x luns per tgt %d\n",
 		     c->flags, c->luns_per_tgt);
-	dev_info(&fnic->pdev->dev, "vNIC flogi_retries %d flogi timeout %d\n",
+	dev_info(&fnic->pdev->dev, "fNIC flogi_retries %d flogi timeout %d\n",
 		     c->flogi_retries, c->flogi_timeout);
-	dev_info(&fnic->pdev->dev, "vNIC plogi retries %d plogi timeout %d\n",
+	dev_info(&fnic->pdev->dev, "fNIC plogi retries %d plogi timeout %d\n",
 		     c->plogi_retries, c->plogi_timeout);
-	dev_info(&fnic->pdev->dev, "vNIC io throttle count %d link dn timeout %d\n",
+	dev_info(&fnic->pdev->dev, "fNIC io throttle count %d link dn timeout %d\n",
 		     c->io_throttle_count, c->link_down_timeout);
-	dev_info(&fnic->pdev->dev, "vNIC port dn io retries %d port dn timeout %d\n",
+	dev_info(&fnic->pdev->dev, "fNIC port dn io retries %d port dn timeout %d\n",
 		     c->port_down_io_retries, c->port_down_timeout);
-	dev_info(&fnic->pdev->dev, "vNIC wq_copy_count: %d\n", c->wq_copy_count);
-	dev_info(&fnic->pdev->dev, "vNIC intr mode: %d\n", c->intr_mode);
+	dev_info(&fnic->pdev->dev, "fNIC wq_copy_count: %d\n", c->wq_copy_count);
+	dev_info(&fnic->pdev->dev, "fNIC intr mode: %d\n", c->intr_mode);
 
 	return 0;
 }
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 149af9f82ae0..020da21dbc35 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1953,6 +1953,40 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 	}
 }
 
+/*
+ * FCP-SCSI specific handling for module unload
+ *
+ */
+void fnic_scsi_unload(struct fnic *fnic)
+{
+	int hwq = 0;
+	unsigned long flags;
+
+	/*
+	 * Mark state so that the workqueue thread stops forwarding
+	 * received frames and link events to the local port. ISR and
+	 * other threads that can queue work items will also stop
+	 * creating work items on the fnic workqueue
+	 */
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	fnic->iport.state = FNIC_IPORT_STATE_LINK_WAIT;
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	if (fdls_get_state(&fnic->iport.fabric) != FDLS_STATE_INIT)
+		fnic_scsi_fcpio_reset(fnic);
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	fnic->in_remove = 1;
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	fnic_flush_tport_event_list(fnic);
+	fnic_delete_fcp_tports(fnic);
+	fc_remove_host(fnic->host);
+	scsi_remove_host(fnic->host);
+	for (hwq = 0; hwq < fnic->wq_copy_count; hwq++)
+		kfree(fnic->sw_copy_wq[hwq].io_req_table);
+}
+
 /*
  * This function is exported to SCSI for sending abort cmnds.
  * A SCSI IO is represented by a io_req in the driver.
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index aaa4ea02fb7c..d717886808df 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -458,6 +458,12 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 
 }
 
+int fnic_get_debug_info(struct stats_debug_info *info, struct fnic *fnic)
+{
+	/* Placeholder function */
+	return 0;
+}
+
 /*
  * fnic_trace_buf_init - Initialize fnic trace buffer logging facility
  *
-- 
2.31.1

