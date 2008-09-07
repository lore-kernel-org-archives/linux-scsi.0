From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/3] lpfc 8.2.8 v2 : Add statistical reporting control and
	additional fc vendor events
Date: Sun, 07 Sep 2008 11:52:10 -0400
Message-ID: <1220802730.6747.15.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61725 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbYIGPxU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2008 11:53:20 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m87FrIMi026402
	for <linux-scsi@vger.kernel.org>; Sun, 7 Sep 2008 08:53:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A recut of:
  http://marc.info/?l=linux-scsi&m=121962905231381&w=2

Added support for new sysfs attributes: lpfc_stat_data_ctrl and
lpfc_max_scsicmpl_time. The attributes control statistical reporting
of io load.

Added support for new fc vendor events for error reporting.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h           |   27 ++--
 lpfc_attr.c      |  343 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lpfc_crtn.h      |    6 
 lpfc_ct.c        |    1 
 lpfc_debugfs.c   |    1 
 lpfc_disc.h      |   20 +++
 lpfc_els.c       |  114 ++++++++++++++++++
 lpfc_hbadisc.c   |  143 ++++++++++++++++++++++
 lpfc_init.c      |   22 +++
 lpfc_mbox.c      |    1 
 lpfc_mem.c       |    1 
 lpfc_nl.h        |  163 ++++++++++++++++++++++++++
 lpfc_nportdisc.c |    1 
 lpfc_scsi.c      |  279 ++++++++++++++++++++++++++++++++++++++++++++
 lpfc_scsi.h      |    4 
 lpfc_sli.c       |   12 +
 lpfc_vport.c     |   80 ++++++++++++
 lpfc_vport.h     |    4 
 18 files changed, 1207 insertions(+), 15 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-09-07 11:18:30.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-09-07 11:19:34.000000000 -0400
@@ -32,6 +32,7 @@
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
@@ -2183,6 +2184,335 @@ lpfc_param_store(topology)
 static DEVICE_ATTR(lpfc_topology, S_IRUGO | S_IWUSR,
 		lpfc_topology_show, lpfc_topology_store);
 
+
+/**
+ * lpfc_stat_data_ctrl_store: write call back for lpfc_stat_data_ctrl
+ *  sysfs file.
+ * @dev: Pointer to class device.
+ * @buf: Data buffer.
+ * @count: Size of the data buffer.
+ *
+ * This function get called when an user write to the lpfc_stat_data_ctrl
+ * sysfs file. This function parse the command written to the sysfs file
+ * and take appropriate action. These commands are used for controlling
+ * driver statistical data collection.
+ * Following are the command this function handles.
+ *
+ *    setbucket <bucket_type> <base> <step>
+ *			       = Set the latency buckets.
+ *    destroybucket            = destroy all the buckets.
+ *    start                    = start data collection
+ *    stop                     = stop data collection
+ *    reset                    = reset the collected data
+ **/
+static ssize_t
+lpfc_stat_data_ctrl_store(struct device *dev, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+#define LPFC_MAX_DATA_CTRL_LEN 1024
+	static char bucket_data[LPFC_MAX_DATA_CTRL_LEN];
+	unsigned long i;
+	char *str_ptr, *token;
+	struct lpfc_vport **vports;
+	struct Scsi_Host *v_shost;
+	char *bucket_type_str, *base_str, *step_str;
+	unsigned long base, step, bucket_type;
+
+	if (!strncmp(buf, "setbucket", strlen("setbucket"))) {
+		if (strlen(buf) > LPFC_MAX_DATA_CTRL_LEN)
+			return -EINVAL;
+
+		strcpy(bucket_data, buf);
+		str_ptr = &bucket_data[0];
+		/* Ignore this token - this is command token */
+		token = strsep(&str_ptr, "\t ");
+		if (!token)
+			return -EINVAL;
+
+		bucket_type_str = strsep(&str_ptr, "\t ");
+		if (!bucket_type_str)
+			return -EINVAL;
+
+		if (!strncmp(bucket_type_str, "linear", strlen("linear")))
+			bucket_type = LPFC_LINEAR_BUCKET;
+		else if (!strncmp(bucket_type_str, "power2", strlen("power2")))
+			bucket_type = LPFC_POWER2_BUCKET;
+		else
+			return -EINVAL;
+
+		base_str = strsep(&str_ptr, "\t ");
+		if (!base_str)
+			return -EINVAL;
+		base = simple_strtoul(base_str, NULL, 0);
+
+		step_str = strsep(&str_ptr, "\t ");
+		if (!step_str)
+			return -EINVAL;
+		step = simple_strtoul(step_str, NULL, 0);
+		if (!step)
+			return -EINVAL;
+
+		/* Block the data collection for every vport */
+		vports = lpfc_create_vport_work_array(phba);
+		if (vports == NULL)
+			return -ENOMEM;
+
+		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+			v_shost = lpfc_shost_from_vport(vports[i]);
+			spin_lock_irq(v_shost->host_lock);
+			/* Block and reset data collection */
+			vports[i]->stat_data_blocked = 1;
+			if (vports[i]->stat_data_enabled)
+				lpfc_vport_reset_stat_data(vports[i]);
+			spin_unlock_irq(v_shost->host_lock);
+		}
+
+		/* Set the bucket attributes */
+		phba->bucket_type = bucket_type;
+		phba->bucket_base = base;
+		phba->bucket_step = step;
+
+		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+			v_shost = lpfc_shost_from_vport(vports[i]);
+
+			/* Unblock data collection */
+			spin_lock_irq(v_shost->host_lock);
+			vports[i]->stat_data_blocked = 0;
+			spin_unlock_irq(v_shost->host_lock);
+		}
+		lpfc_destroy_vport_work_array(phba, vports);
+		return strlen(buf);
+	}
+
+	if (!strncmp(buf, "destroybucket", strlen("destroybucket"))) {
+		vports = lpfc_create_vport_work_array(phba);
+		if (vports == NULL)
+			return -ENOMEM;
+
+		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+			v_shost = lpfc_shost_from_vport(vports[i]);
+			spin_lock_irq(shost->host_lock);
+			vports[i]->stat_data_blocked = 1;
+			lpfc_free_bucket(vport);
+			vport->stat_data_enabled = 0;
+			vports[i]->stat_data_blocked = 0;
+			spin_unlock_irq(shost->host_lock);
+		}
+		lpfc_destroy_vport_work_array(phba, vports);
+		phba->bucket_type = LPFC_NO_BUCKET;
+		phba->bucket_base = 0;
+		phba->bucket_step = 0;
+		return strlen(buf);
+	}
+
+	if (!strncmp(buf, "start", strlen("start"))) {
+		/* If no buckets configured return error */
+		if (phba->bucket_type == LPFC_NO_BUCKET)
+			return -EINVAL;
+		spin_lock_irq(shost->host_lock);
+		if (vport->stat_data_enabled) {
+			spin_unlock_irq(shost->host_lock);
+			return strlen(buf);
+		}
+		lpfc_alloc_bucket(vport);
+		vport->stat_data_enabled = 1;
+		spin_unlock_irq(shost->host_lock);
+		return strlen(buf);
+	}
+
+	if (!strncmp(buf, "stop", strlen("stop"))) {
+		spin_lock_irq(shost->host_lock);
+		if (vport->stat_data_enabled == 0) {
+			spin_unlock_irq(shost->host_lock);
+			return strlen(buf);
+		}
+		lpfc_free_bucket(vport);
+		vport->stat_data_enabled = 0;
+		spin_unlock_irq(shost->host_lock);
+		return strlen(buf);
+	}
+
+	if (!strncmp(buf, "reset", strlen("reset"))) {
+		if ((phba->bucket_type == LPFC_NO_BUCKET)
+			|| !vport->stat_data_enabled)
+			return strlen(buf);
+		spin_lock_irq(shost->host_lock);
+		vport->stat_data_blocked = 1;
+		lpfc_vport_reset_stat_data(vport);
+		vport->stat_data_blocked = 0;
+		spin_unlock_irq(shost->host_lock);
+		return strlen(buf);
+	}
+	return -EINVAL;
+}
+
+
+/**
+ * lpfc_stat_data_ctrl_show: Read callback function for
+ *   lpfc_stat_data_ctrl sysfs file.
+ * @dev: Pointer to class device object.
+ * @buf: Data buffer.
+ *
+ * This function is the read call back function for
+ * lpfc_stat_data_ctrl sysfs file. This function report the
+ * current statistical data collection state.
+ **/
+static ssize_t
+lpfc_stat_data_ctrl_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	int index = 0;
+	int i;
+	char *bucket_type;
+	unsigned long bucket_value;
+
+	switch (phba->bucket_type) {
+	case LPFC_LINEAR_BUCKET:
+		bucket_type = "linear";
+		break;
+	case LPFC_POWER2_BUCKET:
+		bucket_type = "power2";
+		break;
+	default:
+		bucket_type = "No Bucket";
+		break;
+	}
+
+	sprintf(&buf[index], "Statistical Data enabled :%d, "
+		"blocked :%d, Bucket type :%s, Bucket base :%d,"
+		" Bucket step :%d\nLatency Ranges :",
+		vport->stat_data_enabled, vport->stat_data_blocked,
+		bucket_type, phba->bucket_base, phba->bucket_step);
+	index = strlen(buf);
+	if (phba->bucket_type != LPFC_NO_BUCKET) {
+		for (i = 0; i < LPFC_MAX_BUCKET_COUNT; i++) {
+			if (phba->bucket_type == LPFC_LINEAR_BUCKET)
+				bucket_value = phba->bucket_base +
+					phba->bucket_step * i;
+			else
+				bucket_value = phba->bucket_base +
+				(1 << i) * phba->bucket_step;
+
+			if (index + 10 > PAGE_SIZE)
+				break;
+			sprintf(&buf[index], "%08ld ", bucket_value);
+			index = strlen(buf);
+		}
+	}
+	sprintf(&buf[index], "\n");
+	return strlen(buf);
+}
+
+/*
+ * Sysfs attribute to control the statistical data collection.
+ */
+static DEVICE_ATTR(lpfc_stat_data_ctrl, S_IRUGO | S_IWUSR,
+		   lpfc_stat_data_ctrl_show, lpfc_stat_data_ctrl_store);
+
+/*
+ * lpfc_drvr_stat_data: sysfs attr to get driver statistical data.
+ */
+
+/*
+ * Each Bucket takes 11 characters and 1 new line + 17 bytes WWN
+ * for each target.
+ */
+#define STAT_DATA_SIZE_PER_TARGET(NUM_BUCKETS) ((NUM_BUCKETS) * 11 + 18)
+#define MAX_STAT_DATA_SIZE_PER_TARGET \
+	STAT_DATA_SIZE_PER_TARGET(LPFC_MAX_BUCKET_COUNT)
+
+
+/**
+ * sysfs_drvr_stat_data_read: Read callback function for lpfc_drvr_stat_data
+ *  sysfs attribute.
+ * @kobj: Pointer to the kernel object
+ * @bin_attr: Attribute object
+ * @buff: Buffer pointer
+ * @off: File offset
+ * @count: Buffer size
+ *
+ * This function is the read call back function for lpfc_drvr_stat_data
+ * sysfs file. This function export the statistical data to user
+ * applications.
+ **/
+static ssize_t
+sysfs_drvr_stat_data_read(struct kobject *kobj, struct bin_attribute *bin_attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device,
+		kobj);
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	int i = 0, index = 0;
+	unsigned long nport_index;
+	struct lpfc_nodelist *ndlp = NULL;
+	nport_index = (unsigned long)off /
+		MAX_STAT_DATA_SIZE_PER_TARGET;
+
+	if (!vport->stat_data_enabled || vport->stat_data_blocked
+		|| (phba->bucket_type == LPFC_NO_BUCKET))
+		return 0;
+
+	spin_lock_irq(shost->host_lock);
+	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp) || !ndlp->lat_data)
+			continue;
+
+		if (nport_index > 0) {
+			nport_index--;
+			continue;
+		}
+
+		if ((index + MAX_STAT_DATA_SIZE_PER_TARGET)
+			> count)
+			break;
+
+		if (!ndlp->lat_data)
+			continue;
+
+		/* Print the WWN */
+		sprintf(&buf[index], "%02x%02x%02x%02x%02x%02x%02x%02x:",
+			ndlp->nlp_portname.u.wwn[0],
+			ndlp->nlp_portname.u.wwn[1],
+			ndlp->nlp_portname.u.wwn[2],
+			ndlp->nlp_portname.u.wwn[3],
+			ndlp->nlp_portname.u.wwn[4],
+			ndlp->nlp_portname.u.wwn[5],
+			ndlp->nlp_portname.u.wwn[6],
+			ndlp->nlp_portname.u.wwn[7]);
+
+		index = strlen(buf);
+
+		for (i = 0; i < LPFC_MAX_BUCKET_COUNT; i++) {
+			sprintf(&buf[index], "%010u,",
+				ndlp->lat_data[i].cmd_count);
+			index = strlen(buf);
+		}
+		sprintf(&buf[index], "\n");
+		index = strlen(buf);
+	}
+	spin_unlock_irq(shost->host_lock);
+	return index;
+}
+
+static struct bin_attribute sysfs_drvr_stat_data_attr = {
+	.attr = {
+		.name = "lpfc_drvr_stat_data",
+		.mode = S_IRUSR,
+		.owner = THIS_MODULE,
+	},
+	.size = LPFC_MAX_TARGET * MAX_STAT_DATA_SIZE_PER_TARGET,
+	.read = sysfs_drvr_stat_data_read,
+	.write = NULL,
+};
+
 /*
 # lpfc_link_speed: Link speed selection for initializing the Fibre Channel
 # connection.
@@ -2502,6 +2832,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_enable_hba_heartbeat,
 	&dev_attr_lpfc_sg_seg_cnt,
 	&dev_attr_lpfc_max_scsicmpl_time,
+	&dev_attr_lpfc_stat_data_ctrl,
 	NULL,
 };
 
@@ -2524,6 +2855,8 @@ struct device_attribute *lpfc_vport_attr
 	&dev_attr_nport_evt_cnt,
 	&dev_attr_npiv_info,
 	&dev_attr_lpfc_enable_da_id,
+	&dev_attr_lpfc_max_scsicmpl_time,
+	&dev_attr_lpfc_stat_data_ctrl,
 	NULL,
 };
 
@@ -2958,7 +3291,14 @@ lpfc_alloc_sysfs_attr(struct lpfc_vport 
 	if (error)
 		goto out_remove_ctlreg_attr;
 
+	error = sysfs_create_bin_file(&shost->shost_dev.kobj,
+				      &sysfs_drvr_stat_data_attr);
+	if (error)
+		goto out_remove_mbox_attr;
+
 	return 0;
+out_remove_mbox_attr:
+	sysfs_remove_bin_file(&shost->shost_dev.kobj, &sysfs_mbox_attr);
 out_remove_ctlreg_attr:
 	sysfs_remove_bin_file(&shost->shost_dev.kobj, &sysfs_ctlreg_attr);
 out:
@@ -2973,7 +3313,8 @@ void
 lpfc_free_sysfs_attr(struct lpfc_vport *vport)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-
+	sysfs_remove_bin_file(&shost->shost_dev.kobj,
+		&sysfs_drvr_stat_data_attr);
 	sysfs_remove_bin_file(&shost->shost_dev.kobj, &sysfs_mbox_attr);
 	sysfs_remove_bin_file(&shost->shost_dev.kobj, &sysfs_ctlreg_attr);
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2008-09-07 11:19:34.000000000 -0400
@@ -294,6 +294,12 @@ void lpfc_ramp_down_queue_handler(struct
 void lpfc_ramp_up_queue_handler(struct lpfc_hba *);
 void lpfc_scsi_dev_block(struct lpfc_hba *);
 
+void
+lpfc_send_els_failure_event(struct lpfc_hba *, struct lpfc_iocbq *,
+				struct lpfc_iocbq *);
+struct lpfc_fast_path_event *lpfc_alloc_fast_evt(struct lpfc_hba *);
+void lpfc_free_fast_evt(struct lpfc_hba *, struct lpfc_fast_path_event *);
+
 #define ScsiResult(host_code, scsi_code) (((host_code) << 16) | scsi_code)
 #define HBA_EVENT_RSCN                   5
 #define HBA_EVENT_LINK_UP                2
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-09-07 11:19:34.000000000 -0400
@@ -34,6 +34,7 @@
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
diff -upNr a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
--- a/drivers/scsi/lpfc/lpfc_debugfs.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c	2008-09-07 11:19:34.000000000 -0400
@@ -35,6 +35,7 @@
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
diff -upNr a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
--- a/drivers/scsi/lpfc/lpfc_disc.h	2008-09-07 11:18:30.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_disc.h	2008-09-07 11:19:34.000000000 -0400
@@ -37,6 +37,7 @@ enum lpfc_work_type {
 	LPFC_EVT_KILL,
 	LPFC_EVT_ELS_RETRY,
 	LPFC_EVT_DEV_LOSS,
+	LPFC_EVT_FASTPATH_MGMT_EVT,
 };
 
 /* structure used to queue event to the discovery tasklet */
@@ -47,6 +48,24 @@ struct lpfc_work_evt {
 	enum lpfc_work_type   evt;
 };
 
+struct lpfc_scsi_check_condition_event;
+struct lpfc_scsi_varqueuedepth_event;
+struct lpfc_scsi_event_header;
+struct lpfc_fabric_event_header;
+struct lpfc_fcprdchkerr_event;
+
+/* structure used for sending events from fast path */
+struct lpfc_fast_path_event {
+	struct lpfc_work_evt work_evt;
+	struct lpfc_vport     *vport;
+	union {
+		struct lpfc_scsi_check_condition_event check_cond_evt;
+		struct lpfc_scsi_varqueuedepth_event queue_depth_evt;
+		struct lpfc_scsi_event_header scsi_evt;
+		struct lpfc_fabric_event_header fabric_evt;
+		struct lpfc_fcprdchkerr_event read_check_error;
+	} un;
+};
 
 struct lpfc_nodelist {
 	struct list_head nlp_listp;
@@ -91,6 +110,7 @@ struct lpfc_nodelist {
 	atomic_t cmd_pending;
 	uint32_t cmd_qdepth;
 	unsigned long last_change_time;
+	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
 };
 
 /* Defines for nlp_flag (uint32) */
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-09-07 11:19:34.000000000 -0400
@@ -30,6 +30,7 @@
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
@@ -5085,6 +5086,116 @@ lpfc_els_flush_all_cmd(struct lpfc_hba  
 }
 
 /**
+ * lpfc_send_els_failure_event: Posts an ELS command failure event.
+ * @phba: Pointer to hba context object.
+ * @cmdiocbp: Pointer to command iocb which reported error.
+ * @rspiocbp: Pointer to response iocb which reported error.
+ *
+ * This function sends an event when there is an ELS command
+ * failure.
+ **/
+void
+lpfc_send_els_failure_event(struct lpfc_hba *phba,
+			struct lpfc_iocbq *cmdiocbp,
+			struct lpfc_iocbq *rspiocbp)
+{
+	struct lpfc_vport *vport = cmdiocbp->vport;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+	struct lpfc_lsrjt_event lsrjt_event;
+	struct lpfc_fabric_event_header fabric_event;
+	struct ls_rjt stat;
+	struct lpfc_nodelist *ndlp;
+	uint32_t *pcmd;
+
+	ndlp = cmdiocbp->context1;
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		return;
+
+	if (rspiocbp->iocb.ulpStatus == IOSTAT_LS_RJT) {
+		lsrjt_event.header.event_type = FC_REG_ELS_EVENT;
+		lsrjt_event.header.subcategory = LPFC_EVENT_LSRJT_RCV;
+		memcpy(lsrjt_event.header.wwpn, &ndlp->nlp_portname,
+			sizeof(struct lpfc_name));
+		memcpy(lsrjt_event.header.wwnn, &ndlp->nlp_nodename,
+			sizeof(struct lpfc_name));
+		pcmd = (uint32_t *) (((struct lpfc_dmabuf *)
+			cmdiocbp->context2)->virt);
+		lsrjt_event.command = *pcmd;
+		stat.un.lsRjtError = be32_to_cpu(rspiocbp->iocb.un.ulpWord[4]);
+		lsrjt_event.reason_code = stat.un.b.lsRjtRsnCode;
+		lsrjt_event.explanation = stat.un.b.lsRjtRsnCodeExp;
+		fc_host_post_vendor_event(shost,
+			fc_get_event_number(),
+			sizeof(lsrjt_event),
+			(char *)&lsrjt_event,
+			SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+		return;
+	}
+	if ((rspiocbp->iocb.ulpStatus == IOSTAT_NPORT_BSY) ||
+		(rspiocbp->iocb.ulpStatus == IOSTAT_FABRIC_BSY)) {
+		fabric_event.event_type = FC_REG_FABRIC_EVENT;
+		if (rspiocbp->iocb.ulpStatus == IOSTAT_NPORT_BSY)
+			fabric_event.subcategory = LPFC_EVENT_PORT_BUSY;
+		else
+			fabric_event.subcategory = LPFC_EVENT_FABRIC_BUSY;
+		memcpy(fabric_event.wwpn, &ndlp->nlp_portname,
+			sizeof(struct lpfc_name));
+		memcpy(fabric_event.wwnn, &ndlp->nlp_nodename,
+			sizeof(struct lpfc_name));
+		fc_host_post_vendor_event(shost,
+			fc_get_event_number(),
+			sizeof(fabric_event),
+			(char *)&fabric_event,
+			SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+		return;
+	}
+
+}
+
+/**
+ * lpfc_send_els_event: Posts unsolicited els event.
+ * @vport: Pointer to vport object.
+ * @ndlp: Pointer FC node object.
+ * @cmd: ELS command code.
+ *
+ * This function posts an event when there is an incoming
+ * unsolicited ELS command.
+ **/
+static void
+lpfc_send_els_event(struct lpfc_vport *vport,
+		    struct lpfc_nodelist *ndlp,
+		    uint32_t cmd)
+{
+	struct lpfc_els_event_header els_data;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
+
+	els_data.event_type = FC_REG_ELS_EVENT;
+	switch (cmd) {
+	case ELS_CMD_PLOGI:
+		els_data.subcategory = LPFC_EVENT_PLOGI_RCV;
+		break;
+	case ELS_CMD_PRLO:
+		els_data.subcategory = LPFC_EVENT_PRLO_RCV;
+		break;
+	case ELS_CMD_ADISC:
+		els_data.subcategory = LPFC_EVENT_ADISC_RCV;
+		break;
+	default:
+		return;
+	}
+	memcpy(els_data.wwpn, &ndlp->nlp_portname, sizeof(struct lpfc_name));
+	memcpy(els_data.wwnn, &ndlp->nlp_nodename, sizeof(struct lpfc_name));
+	fc_host_post_vendor_event(shost,
+		fc_get_event_number(),
+		sizeof(els_data),
+		(char *)&els_data,
+		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+
+	return;
+}
+
+
+/**
  * lpfc_els_unsol_buffer: Process an unsolicited event data buffer.
  * @phba: pointer to lpfc hba data structure.
  * @pring: pointer to a SLI ring.
@@ -5185,6 +5296,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		phba->fc_stat.elsRcvPLOGI++;
 		ndlp = lpfc_plogi_confirm_nport(phba, payload, ndlp);
 
+		lpfc_send_els_event(vport, ndlp, cmd);
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			if (!(phba->pport->fc_flag & FC_PT2PT) ||
 				(phba->pport->fc_flag & FC_PT2PT_PLOGI)) {
@@ -5234,6 +5346,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 			did, vport->port_state, ndlp->nlp_flag);
 
 		phba->fc_stat.elsRcvPRLO++;
+		lpfc_send_els_event(vport, ndlp, cmd);
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			rjt_err = LSRJT_UNABLE_TPC;
 			break;
@@ -5251,6 +5364,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 			"RCV ADISC:       did:x%x/ste:x%x flg:x%x",
 			did, vport->port_state, ndlp->nlp_flag);
 
+		lpfc_send_els_event(vport, ndlp, cmd);
 		phba->fc_stat.elsRcvADISC++;
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			rjt_err = LSRJT_UNABLE_TPC;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-09-07 11:18:30.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2008-09-07 11:19:34.000000000 -0400
@@ -40,6 +40,8 @@ struct lpfc_sli2_slim;
 #define LPFC_MIN_TGT_QDEPTH	100
 #define LPFC_MAX_TGT_QDEPTH	0xFFFF
 
+#define  LPFC_MAX_BUCKET_COUNT 20	/* Maximum no. of buckets for stat data
+					   collection. */
 /*
  * Following time intervals are used of adjusting SCSI device
  * queue depths when there are driver resource error or Firmware
@@ -381,6 +383,8 @@ struct lpfc_vport {
 	struct lpfc_debugfs_trc *disc_trc;
 	atomic_t disc_trc_cnt;
 #endif
+	uint8_t stat_data_enabled;
+	uint8_t stat_data_blocked;
 };
 
 struct hbq_s {
@@ -641,6 +645,17 @@ struct lpfc_hba {
 	uint32_t buffer_tag_count;
 	int wait_4_mlo_maint_flg;
 	wait_queue_head_t wait_4_mlo_m_q;
+	/* data structure used for latency data collection */
+#define LPFC_NO_BUCKET	   0
+#define LPFC_LINEAR_BUCKET 1
+#define LPFC_POWER2_BUCKET 2
+	uint8_t  bucket_type;
+	uint32_t bucket_base;
+	uint32_t bucket_step;
+
+/* Maximum number of events that can be outstanding at any time*/
+#define LPFC_MAX_EVT_COUNT 512
+	atomic_t fast_event_count;
 };
 
 static inline struct Scsi_Host *
@@ -699,15 +714,3 @@ lpfc_sli_read_hs(struct lpfc_hba *phba)
 	return;
 }
 
-#define FC_REG_DUMP_EVENT		0x10	/* Register for Dump events */
-#define FC_REG_TEMPERATURE_EVENT	0x20    /* Register for temperature
-						   event */
-
-struct temp_event {
-	uint32_t event_type;
-	uint32_t event_code;
-	uint32_t data;
-};
-#define LPFC_CRIT_TEMP		0x1
-#define LPFC_THRESHOLD_TEMP	0x2
-#define LPFC_NORMAL_TEMP	0x3
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-09-07 11:18:30.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-09-07 11:19:34.000000000 -0400
@@ -30,6 +30,7 @@
 #include <scsi/scsi_transport_fc.h>
 
 #include "lpfc_hw.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_sli.h"
 #include "lpfc_scsi.h"
@@ -274,6 +275,124 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 }
 
+/**
+ * lpfc_alloc_fast_evt: Allocates data structure for posting event.
+ * @phba: Pointer to hba context object.
+ *
+ * This function is called from the functions which need to post
+ * events from interrupt context. This function allocates data
+ * structure required for posting event. It also keeps track of
+ * number of events pending and prevent event storm when there are
+ * too many events.
+ **/
+struct lpfc_fast_path_event *
+lpfc_alloc_fast_evt(struct lpfc_hba *phba) {
+	struct lpfc_fast_path_event *ret;
+
+	/* If there are lot of fast event do not exhaust memory due to this */
+	if (atomic_read(&phba->fast_event_count) > LPFC_MAX_EVT_COUNT)
+		return NULL;
+
+	ret = kzalloc(sizeof(struct lpfc_fast_path_event),
+			GFP_ATOMIC);
+	if (ret)
+		atomic_inc(&phba->fast_event_count);
+	INIT_LIST_HEAD(&ret->work_evt.evt_listp);
+	ret->work_evt.evt = LPFC_EVT_FASTPATH_MGMT_EVT;
+	return ret;
+}
+
+/**
+ * lpfc_free_fast_evt: Frees event data structure.
+ * @phba: Pointer to hba context object.
+ * @evt:  Event object which need to be freed.
+ *
+ * This function frees the data structure required for posting
+ * events.
+ **/
+void
+lpfc_free_fast_evt(struct lpfc_hba *phba,
+		struct lpfc_fast_path_event *evt) {
+
+	atomic_dec(&phba->fast_event_count);
+	kfree(evt);
+}
+
+/**
+ * lpfc_send_fastpath_evt: Posts events generated from fast path.
+ * @phba: Pointer to hba context object.
+ * @evtp: Event data structure.
+ *
+ * This function is called from worker thread, when the interrupt
+ * context need to post an event. This function posts the event
+ * to fc transport netlink interface.
+ **/
+static void
+lpfc_send_fastpath_evt(struct lpfc_hba *phba,
+		struct lpfc_work_evt *evtp)
+{
+	unsigned long evt_category, evt_sub_category;
+	struct lpfc_fast_path_event *fast_evt_data;
+	char *evt_data;
+	uint32_t evt_data_size;
+	struct Scsi_Host *shost;
+
+	fast_evt_data = container_of(evtp, struct lpfc_fast_path_event,
+		work_evt);
+
+	evt_category = (unsigned long) fast_evt_data->un.fabric_evt.event_type;
+	evt_sub_category = (unsigned long) fast_evt_data->un.
+			fabric_evt.subcategory;
+	shost = lpfc_shost_from_vport(fast_evt_data->vport);
+	if (evt_category == FC_REG_FABRIC_EVENT) {
+		if (evt_sub_category == LPFC_EVENT_FCPRDCHKERR) {
+			evt_data = (char *) &fast_evt_data->un.read_check_error;
+			evt_data_size = sizeof(fast_evt_data->un.
+				read_check_error);
+		} else if ((evt_sub_category == LPFC_EVENT_FABRIC_BUSY) ||
+			(evt_sub_category == IOSTAT_NPORT_BSY)) {
+			evt_data = (char *) &fast_evt_data->un.fabric_evt;
+			evt_data_size = sizeof(fast_evt_data->un.fabric_evt);
+		} else {
+			lpfc_free_fast_evt(phba, fast_evt_data);
+			return;
+		}
+	} else if (evt_category == FC_REG_SCSI_EVENT) {
+		switch (evt_sub_category) {
+		case LPFC_EVENT_QFULL:
+		case LPFC_EVENT_DEVBSY:
+			evt_data = (char *) &fast_evt_data->un.scsi_evt;
+			evt_data_size = sizeof(fast_evt_data->un.scsi_evt);
+			break;
+		case LPFC_EVENT_CHECK_COND:
+			evt_data = (char *) &fast_evt_data->un.check_cond_evt;
+			evt_data_size =  sizeof(fast_evt_data->un.
+				check_cond_evt);
+			break;
+		case LPFC_EVENT_VARQUEDEPTH:
+			evt_data = (char *) &fast_evt_data->un.queue_depth_evt;
+			evt_data_size = sizeof(fast_evt_data->un.
+				queue_depth_evt);
+			break;
+		default:
+			lpfc_free_fast_evt(phba, fast_evt_data);
+			return;
+		}
+	} else {
+		lpfc_free_fast_evt(phba, fast_evt_data);
+		return;
+	}
+
+	fc_host_post_vendor_event(shost,
+		fc_get_event_number(),
+		evt_data_size,
+		evt_data,
+		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+
+	lpfc_free_fast_evt(phba, fast_evt_data);
+	return;
+}
+
 static void
 lpfc_work_list_done(struct lpfc_hba *phba)
 {
@@ -345,6 +464,10 @@ lpfc_work_list_done(struct lpfc_hba *phb
 			lpfc_unblock_mgmt_io(phba);
 			complete((struct completion *)(evtp->evt_arg2));
 			break;
+		case LPFC_EVT_FASTPATH_MGMT_EVT:
+			lpfc_send_fastpath_evt(phba, evtp);
+			free_evt = 0;
+			break;
 		}
 		if (free_evt)
 			kfree(evtp);
@@ -1601,6 +1724,22 @@ lpfc_nlp_state_cleanup(struct lpfc_vport
 		 */
 		lpfc_register_remote_port(vport, ndlp);
 	}
+	if ((new_state ==  NLP_STE_MAPPED_NODE) &&
+		(vport->stat_data_enabled)) {
+		/*
+		 * A new target is discovered, if there is no buffer for
+		 * statistical data collection allocate buffer.
+		 */
+		ndlp->lat_data = kcalloc(LPFC_MAX_BUCKET_COUNT,
+					 sizeof(struct lpfc_scsicmd_bkt),
+					 GFP_KERNEL);
+
+		if (!ndlp->lat_data)
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
+				"0286 lpfc_nlp_state_cleanup failed to "
+				"allocate statistical data buffer DID "
+				"0x%x\n", ndlp->nlp_DID);
+	}
 	/*
 	 * if we added to Mapped list, but the remote port
 	 * registration failed or assigned a target id outside
@@ -3029,8 +3168,10 @@ lpfc_nlp_release(struct kref *kref)
 	spin_unlock_irqrestore(&phba->ndlp_lock, flags);
 
 	/* free ndlp memory for final ndlp release */
-	if (NLP_CHK_FREE_REQ(ndlp))
+	if (NLP_CHK_FREE_REQ(ndlp)) {
+		kfree(ndlp->lat_data);
 		mempool_free(ndlp, ndlp->vport->phba->nlp_mem_pool);
+	}
 }
 
 /* This routine bumps the reference count for a ndlp structure to ensure
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-09-07 11:19:34.000000000 -0400
@@ -36,6 +36,7 @@
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
@@ -815,6 +816,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 	unsigned long temperature;
 	struct temp_event temp_event_data;
 	struct Scsi_Host  *shost;
+	struct lpfc_board_event_header board_event;
 
 	/* If the pci channel is offline, ignore possible errors,
 	 * since we cannot communicate with the pci card anyway. */
@@ -824,6 +826,16 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 	if (!phba->cfg_enable_hba_reset)
 		return;
 
+	/* Send an internal error event to mgmt application */
+	board_event.event_type = FC_REG_BOARD_EVENT;
+	board_event.subcategory = LPFC_EVENT_PORTINTERR;
+	shost = lpfc_shost_from_vport(phba->pport);
+	fc_host_post_vendor_event(shost, fc_get_event_number(),
+				  sizeof(board_event),
+				  (char *) &board_event,
+				  SCSI_NL_VID_TYPE_PCI
+				  | PCI_VENDOR_ID_EMULEX);
+
 	if (phba->work_hs & HS_FFER6) {
 		/* Re-establishing Link */
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
@@ -2345,6 +2357,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	int  i, hbq_count;
 	uint16_t iotag;
 	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
+	struct lpfc_adapter_event_header adapter_event;
 
 	if (pci_enable_device_mem(pdev))
 		goto out;
@@ -2355,6 +2368,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	if (!phba)
 		goto out_release_regions;
 
+	atomic_set(&phba->fast_event_count, 0);
 	spin_lock_init(&phba->hbalock);
 
 	/* Initialize ndlp management spinlock */
@@ -2626,6 +2640,14 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"0428 Perform SCSI scan\n");
+	/* Send board arrival event to upper layer */
+	adapter_event.event_type = FC_REG_ADAPTER_EVENT;
+	adapter_event.subcategory = LPFC_EVENT_ARRIVAL;
+	fc_host_post_vendor_event(shost, fc_get_event_number(),
+		sizeof(adapter_event),
+		(char *) &adapter_event,
+		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+
 	scsi_scan_host(shost);
 
 	return 0;
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2008-09-07 11:19:34.000000000 -0400
@@ -30,6 +30,7 @@
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
diff -upNr a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
--- a/drivers/scsi/lpfc/lpfc_mem.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mem.c	2008-09-07 11:19:34.000000000 -0400
@@ -30,6 +30,7 @@
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
diff -upNr a/drivers/scsi/lpfc/lpfc_nl.h b/drivers/scsi/lpfc/lpfc_nl.h
--- a/drivers/scsi/lpfc/lpfc_nl.h	1969-12-31 19:00:00.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nl.h	2008-09-07 11:19:34.000000000 -0400
@@ -0,0 +1,163 @@
+/*******************************************************************
+ * This file is part of the Emulex Linux Device Driver for         *
+ * Fibre Channel Host Bus Adapters.                                *
+ * Copyright (C) 2008 Emulex.  All rights reserved.                *
+ * EMULEX and SLI are trademarks of Emulex.                        *
+ * www.emulex.com                                                  *
+ *                                                                 *
+ * This program is free software; you can redistribute it and/or   *
+ * modify it under the terms of version 2 of the GNU General       *
+ * Public License as published by the Free Software Foundation.    *
+ * This program is distributed in the hope that it will be useful. *
+ * ALL EXPRESS OR IMPLIED CONDITIONS, REPRESENTATIONS AND          *
+ * WARRANTIES, INCLUDING ANY IMPLIED WARRANTY OF MERCHANTABILITY,  *
+ * FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT, ARE      *
+ * DISCLAIMED, EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD *
+ * TO BE LEGALLY INVALID.  See the GNU General Public License for  *
+ * more details, a copy of which can be found in the file COPYING  *
+ * included with this package.                                     *
+ *******************************************************************/
+
+/* Event definitions for RegisterForEvent */
+#define FC_REG_LINK_EVENT		0x0001	/* link up / down events */
+#define FC_REG_RSCN_EVENT		0x0002	/* RSCN events */
+#define FC_REG_CT_EVENT			0x0004	/* CT request events */
+#define FC_REG_DUMP_EVENT		0x0008	/* Dump events */
+#define FC_REG_TEMPERATURE_EVENT	0x0010	/* temperature events */
+#define FC_REG_ELS_EVENT		0x0020	/* lpfc els events */
+#define FC_REG_FABRIC_EVENT		0x0040	/* lpfc fabric events */
+#define FC_REG_SCSI_EVENT		0x0080	/* lpfc scsi events */
+#define FC_REG_BOARD_EVENT		0x0100	/* lpfc board events */
+#define FC_REG_ADAPTER_EVENT		0x0200	/* lpfc adapter events */
+#define FC_REG_EVENT_MASK		(FC_REG_LINK_EVENT | \
+						FC_REG_RSCN_EVENT | \
+						FC_REG_CT_EVENT | \
+						FC_REG_DUMP_EVENT | \
+						FC_REG_TEMPERATURE_EVENT | \
+						FC_REG_ELS_EVENT | \
+						FC_REG_FABRIC_EVENT | \
+						FC_REG_SCSI_EVENT | \
+						FC_REG_BOARD_EVENT | \
+						FC_REG_ADAPTER_EVENT)
+/* Temperature events */
+#define LPFC_CRIT_TEMP		0x1
+#define LPFC_THRESHOLD_TEMP	0x2
+#define LPFC_NORMAL_TEMP	0x3
+/*
+ * All net link event payloads will begin with and event type
+ * and subcategory. The event type must come first.
+ * The subcategory further defines the data that follows in the rest
+ * of the payload. Each category will have its own unique header plus
+ * any addtional data unique to the subcategory.
+ * The payload sent via the fc transport is one-way driver->application.
+ */
+
+/* els event header */
+struct lpfc_els_event_header {
+	uint32_t event_type;
+	uint32_t subcategory;
+	uint8_t wwpn[8];
+	uint8_t wwnn[8];
+};
+
+/* subcategory codes for FC_REG_ELS_EVENT */
+#define LPFC_EVENT_PLOGI_RCV		0x01
+#define LPFC_EVENT_PRLO_RCV		0x02
+#define LPFC_EVENT_ADISC_RCV		0x04
+#define LPFC_EVENT_LSRJT_RCV		0x08
+
+/* special els lsrjt event */
+struct lpfc_lsrjt_event {
+	struct lpfc_els_event_header header;
+	uint32_t command;
+	uint32_t reason_code;
+	uint32_t explanation;
+};
+
+
+/* fabric event header */
+struct lpfc_fabric_event_header {
+	uint32_t event_type;
+	uint32_t subcategory;
+	uint8_t wwpn[8];
+	uint8_t wwnn[8];
+};
+
+/* subcategory codes for FC_REG_FABRIC_EVENT */
+#define LPFC_EVENT_FABRIC_BUSY		0x01
+#define LPFC_EVENT_PORT_BUSY		0x02
+#define LPFC_EVENT_FCPRDCHKERR		0x04
+
+/* special case fabric fcprdchkerr event */
+struct lpfc_fcprdchkerr_event {
+	struct lpfc_fabric_event_header header;
+	uint32_t lun;
+	uint32_t opcode;
+	uint32_t fcpiparam;
+};
+
+
+/* scsi event header */
+struct lpfc_scsi_event_header {
+	uint32_t event_type;
+	uint32_t subcategory;
+	uint32_t lun;
+	uint8_t wwpn[8];
+	uint8_t wwnn[8];
+};
+
+/* subcategory codes for FC_REG_SCSI_EVENT */
+#define LPFC_EVENT_QFULL	0x0001
+#define LPFC_EVENT_DEVBSY	0x0002
+#define LPFC_EVENT_CHECK_COND	0x0004
+#define LPFC_EVENT_LUNRESET	0x0008
+#define LPFC_EVENT_TGTRESET	0x0010
+#define LPFC_EVENT_BUSRESET	0x0020
+#define LPFC_EVENT_VARQUEDEPTH	0x0040
+
+/* special case scsi varqueuedepth event */
+struct lpfc_scsi_varqueuedepth_event {
+	struct lpfc_scsi_event_header scsi_event;
+	uint32_t oldval;
+	uint32_t newval;
+};
+
+/* special case scsi check condition event */
+struct lpfc_scsi_check_condition_event {
+	struct lpfc_scsi_event_header scsi_event;
+	uint8_t sense_key;
+	uint8_t asc;
+	uint8_t ascq;
+};
+
+/* event codes for FC_REG_BOARD_EVENT */
+#define LPFC_EVENT_PORTINTERR		0x01
+
+/* board event header */
+struct lpfc_board_event_header {
+	uint32_t event_type;
+	uint32_t subcategory;
+};
+
+
+/* event codes for FC_REG_ADAPTER_EVENT */
+#define LPFC_EVENT_ARRIVAL	0x01
+
+/* adapter event header */
+struct lpfc_adapter_event_header {
+	uint32_t event_type;
+	uint32_t subcategory;
+};
+
+
+/* event codes for temp_event */
+#define LPFC_CRIT_TEMP		0x1
+#define LPFC_THRESHOLD_TEMP	0x2
+#define LPFC_NORMAL_TEMP	0x3
+
+struct temp_event {
+	uint32_t event_type;
+	uint32_t event_code;
+	uint32_t data;
+};
+
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2008-09-07 11:19:34.000000000 -0400
@@ -30,6 +30,7 @@
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-09-07 11:18:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-09-07 11:19:34.000000000 -0400
@@ -32,6 +32,7 @@
 #include "lpfc_version.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
@@ -42,6 +43,111 @@
 #define LPFC_RESET_WAIT  2
 #define LPFC_ABORT_WAIT  2
 
+/**
+ * lpfc_update_stats: Update statistical data for the command completion.
+ * @phba: Pointer to HBA object.
+ * @lpfc_cmd: lpfc scsi command object pointer.
+ *
+ * This function is called when there is a command completion and this
+ * function updates the statistical data for the command completion.
+ **/
+static void
+lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
+{
+	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
+	struct lpfc_nodelist *pnode = rdata->pnode;
+	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
+	unsigned long flags;
+	struct Scsi_Host  *shost = cmd->device->host;
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	unsigned long latency;
+	int i;
+
+	if (cmd->result)
+		return;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (!vport->stat_data_enabled ||
+		vport->stat_data_blocked ||
+		!pnode->lat_data ||
+		(phba->bucket_type == LPFC_NO_BUCKET)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		return;
+	}
+	latency = jiffies_to_msecs(jiffies - lpfc_cmd->start_time);
+
+	if (phba->bucket_type == LPFC_LINEAR_BUCKET) {
+		i = (latency + phba->bucket_step - 1 - phba->bucket_base)/
+			phba->bucket_step;
+		if (i >= LPFC_MAX_BUCKET_COUNT)
+			i = LPFC_MAX_BUCKET_COUNT;
+	} else {
+		for (i = 0; i < LPFC_MAX_BUCKET_COUNT-1; i++)
+			if (latency <= (phba->bucket_base +
+				((1<<i)*phba->bucket_step)))
+				break;
+	}
+
+	pnode->lat_data[i].cmd_count++;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+
+
+/**
+ * lpfc_send_sdev_queuedepth_change_event: Posts a queuedepth change
+ *                   event.
+ * @phba: Pointer to HBA context object.
+ * @vport: Pointer to vport object.
+ * @ndlp: Pointer to FC node associated with the target.
+ * @lun: Lun number of the scsi device.
+ * @old_val: Old value of the queue depth.
+ * @new_val: New value of the queue depth.
+ *
+ * This function sends an event to the mgmt application indicating
+ * there is a change in the scsi device queue depth.
+ **/
+static void
+lpfc_send_sdev_queuedepth_change_event(struct lpfc_hba *phba,
+		struct lpfc_vport  *vport,
+		struct lpfc_nodelist *ndlp,
+		uint32_t lun,
+		uint32_t old_val,
+		uint32_t new_val)
+{
+	struct lpfc_fast_path_event *fast_path_evt;
+	unsigned long flags;
+
+	fast_path_evt = lpfc_alloc_fast_evt(phba);
+	if (!fast_path_evt)
+		return;
+
+	fast_path_evt->un.queue_depth_evt.scsi_event.event_type =
+		FC_REG_SCSI_EVENT;
+	fast_path_evt->un.queue_depth_evt.scsi_event.subcategory =
+		LPFC_EVENT_VARQUEDEPTH;
+
+	/* Report all luns with change in queue depth */
+	fast_path_evt->un.queue_depth_evt.scsi_event.lun = lun;
+	if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
+		memcpy(&fast_path_evt->un.queue_depth_evt.scsi_event.wwpn,
+			&ndlp->nlp_portname, sizeof(struct lpfc_name));
+		memcpy(&fast_path_evt->un.queue_depth_evt.scsi_event.wwnn,
+			&ndlp->nlp_nodename, sizeof(struct lpfc_name));
+	}
+
+	fast_path_evt->un.queue_depth_evt.oldval = old_val;
+	fast_path_evt->un.queue_depth_evt.newval = new_val;
+	fast_path_evt->vport = vport;
+
+	fast_path_evt->work_evt.evt = LPFC_EVT_FASTPATH_MGMT_EVT;
+	spin_lock_irqsave(&phba->hbalock, flags);
+	list_add_tail(&fast_path_evt->work_evt.evt_listp, &phba->work_list);
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+	lpfc_worker_wake_up(phba);
+
+	return;
+}
+
 /*
  * This function is called with no lock held when there is a resource
  * error in driver or in firmware.
@@ -117,9 +223,10 @@ lpfc_ramp_down_queue_handler(struct lpfc
 	struct lpfc_vport **vports;
 	struct Scsi_Host  *shost;
 	struct scsi_device *sdev;
-	unsigned long new_queue_depth;
+	unsigned long new_queue_depth, old_queue_depth;
 	unsigned long num_rsrc_err, num_cmd_success;
 	int i;
+	struct lpfc_rport_data *rdata;
 
 	num_rsrc_err = atomic_read(&phba->num_rsrc_err);
 	num_cmd_success = atomic_read(&phba->num_cmd_success);
@@ -137,6 +244,7 @@ lpfc_ramp_down_queue_handler(struct lpfc
 				else
 					new_queue_depth = sdev->queue_depth -
 								new_queue_depth;
+				old_queue_depth = sdev->queue_depth;
 				if (sdev->ordered_tags)
 					scsi_adjust_queue_depth(sdev,
 							MSG_ORDERED_TAG,
@@ -145,6 +253,13 @@ lpfc_ramp_down_queue_handler(struct lpfc
 					scsi_adjust_queue_depth(sdev,
 							MSG_SIMPLE_TAG,
 							new_queue_depth);
+				rdata = sdev->hostdata;
+				if (rdata)
+					lpfc_send_sdev_queuedepth_change_event(
+						phba, vports[i],
+						rdata->pnode,
+						sdev->lun, old_queue_depth,
+						new_queue_depth);
 			}
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -159,6 +274,7 @@ lpfc_ramp_up_queue_handler(struct lpfc_h
 	struct Scsi_Host  *shost;
 	struct scsi_device *sdev;
 	int i;
+	struct lpfc_rport_data *rdata;
 
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
@@ -176,6 +292,14 @@ lpfc_ramp_up_queue_handler(struct lpfc_h
 					scsi_adjust_queue_depth(sdev,
 							MSG_SIMPLE_TAG,
 							sdev->queue_depth+1);
+				rdata = sdev->hostdata;
+				if (rdata)
+					lpfc_send_sdev_queuedepth_change_event(
+						phba, vports[i],
+						rdata->pnode,
+						sdev->lun,
+						sdev->queue_depth - 1,
+						sdev->queue_depth);
 			}
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
@@ -466,6 +590,97 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 	return 0;
 }
 
+/**
+ * lpfc_send_scsi_error_event: Posts an event when there is SCSI error.
+ * @phba: Pointer to hba context object.
+ * @vport: Pointer to vport object.
+ * @lpfc_cmd: Pointer to lpfc scsi command which reported the error.
+ * @rsp_iocb: Pointer to response iocb object which reported error.
+ *
+ * This function posts an event when there is a SCSI command reporting
+ * error from the scsi device.
+ **/
+static void
+lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
+		struct lpfc_scsi_buf *lpfc_cmd, struct lpfc_iocbq *rsp_iocb) {
+	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
+	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
+	uint32_t resp_info = fcprsp->rspStatus2;
+	uint32_t scsi_status = fcprsp->rspStatus3;
+	uint32_t fcpi_parm = rsp_iocb->iocb.un.fcpi.fcpi_parm;
+	struct lpfc_fast_path_event *fast_path_evt = NULL;
+	struct lpfc_nodelist *pnode = lpfc_cmd->rdata->pnode;
+	unsigned long flags;
+
+	/* If there is queuefull or busy condition send a scsi event */
+	if ((cmnd->result == SAM_STAT_TASK_SET_FULL) ||
+		(cmnd->result == SAM_STAT_BUSY)) {
+		fast_path_evt = lpfc_alloc_fast_evt(phba);
+		if (!fast_path_evt)
+			return;
+		fast_path_evt->un.scsi_evt.event_type =
+			FC_REG_SCSI_EVENT;
+		fast_path_evt->un.scsi_evt.subcategory =
+		(cmnd->result == SAM_STAT_TASK_SET_FULL) ?
+		LPFC_EVENT_QFULL : LPFC_EVENT_DEVBSY;
+		fast_path_evt->un.scsi_evt.lun = cmnd->device->lun;
+		memcpy(&fast_path_evt->un.scsi_evt.wwpn,
+			&pnode->nlp_portname, sizeof(struct lpfc_name));
+		memcpy(&fast_path_evt->un.scsi_evt.wwnn,
+			&pnode->nlp_nodename, sizeof(struct lpfc_name));
+	} else if ((resp_info & SNS_LEN_VALID) && fcprsp->rspSnsLen &&
+		((cmnd->cmnd[0] == READ_10) || (cmnd->cmnd[0] == WRITE_10))) {
+		fast_path_evt = lpfc_alloc_fast_evt(phba);
+		if (!fast_path_evt)
+			return;
+		fast_path_evt->un.check_cond_evt.scsi_event.event_type =
+			FC_REG_SCSI_EVENT;
+		fast_path_evt->un.check_cond_evt.scsi_event.subcategory =
+			LPFC_EVENT_CHECK_COND;
+		fast_path_evt->un.check_cond_evt.scsi_event.lun =
+			cmnd->device->lun;
+		memcpy(&fast_path_evt->un.check_cond_evt.scsi_event.wwpn,
+			&pnode->nlp_portname, sizeof(struct lpfc_name));
+		memcpy(&fast_path_evt->un.check_cond_evt.scsi_event.wwnn,
+			&pnode->nlp_nodename, sizeof(struct lpfc_name));
+		fast_path_evt->un.check_cond_evt.sense_key =
+			cmnd->sense_buffer[2] & 0xf;
+		fast_path_evt->un.check_cond_evt.asc = cmnd->sense_buffer[12];
+		fast_path_evt->un.check_cond_evt.ascq = cmnd->sense_buffer[13];
+	} else if ((cmnd->sc_data_direction == DMA_FROM_DEVICE) &&
+		     fcpi_parm &&
+		     ((be32_to_cpu(fcprsp->rspResId) != fcpi_parm) ||
+			((scsi_status == SAM_STAT_GOOD) &&
+			!(resp_info & (RESID_UNDER | RESID_OVER))))) {
+		/*
+		 * If status is good or resid does not match with fcp_param and
+		 * there is valid fcpi_parm, then there is a read_check error
+		 */
+		fast_path_evt = lpfc_alloc_fast_evt(phba);
+		if (!fast_path_evt)
+			return;
+		fast_path_evt->un.read_check_error.header.event_type =
+			FC_REG_FABRIC_EVENT;
+		fast_path_evt->un.read_check_error.header.subcategory =
+			LPFC_EVENT_FCPRDCHKERR;
+		memcpy(&fast_path_evt->un.read_check_error.header.wwpn,
+			&pnode->nlp_portname, sizeof(struct lpfc_name));
+		memcpy(&fast_path_evt->un.read_check_error.header.wwnn,
+			&pnode->nlp_nodename, sizeof(struct lpfc_name));
+		fast_path_evt->un.read_check_error.lun = cmnd->device->lun;
+		fast_path_evt->un.read_check_error.opcode = cmnd->cmnd[0];
+		fast_path_evt->un.read_check_error.fcpiparam =
+			fcpi_parm;
+	} else
+		return;
+
+	fast_path_evt->vport = vport;
+	spin_lock_irqsave(&phba->hbalock, flags);
+	list_add_tail(&fast_path_evt->work_evt.evt_listp, &phba->work_list);
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+	lpfc_worker_wake_up(phba);
+	return;
+}
 static void
 lpfc_scsi_unprep_dma_buf(struct lpfc_hba * phba, struct lpfc_scsi_buf * psb)
 {
@@ -494,6 +709,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 	uint32_t rsplen = 0;
 	uint32_t logit = LOG_FCP | LOG_FCP_ERROR;
 
+
 	/*
 	 *  If this is a task management command, there is no
 	 *  scsi packet associated with this lpfc_cmd.  The driver
@@ -609,6 +825,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 
  out:
 	cmnd->result = ScsiResult(host_status, scsi_status);
+	lpfc_send_scsi_error_event(vport->phba, vport, lpfc_cmd, rsp_iocb);
 }
 
 static void
@@ -625,6 +842,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	struct scsi_device *sdev, *tmp_sdev;
 	int depth = 0;
 	unsigned long flags;
+	struct lpfc_fast_path_event *fast_path_evt;
 
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
@@ -655,6 +873,30 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		case IOSTAT_NPORT_BSY:
 		case IOSTAT_FABRIC_BSY:
 			cmd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
+			fast_path_evt = lpfc_alloc_fast_evt(phba);
+			if (!fast_path_evt)
+				break;
+			fast_path_evt->un.fabric_evt.event_type =
+				FC_REG_FABRIC_EVENT;
+			fast_path_evt->un.fabric_evt.subcategory =
+				(lpfc_cmd->status == IOSTAT_NPORT_BSY) ?
+				LPFC_EVENT_PORT_BUSY : LPFC_EVENT_FABRIC_BUSY;
+			if (pnode && NLP_CHK_NODE_ACT(pnode)) {
+				memcpy(&fast_path_evt->un.fabric_evt.wwpn,
+					&pnode->nlp_portname,
+					sizeof(struct lpfc_name));
+				memcpy(&fast_path_evt->un.fabric_evt.wwnn,
+					&pnode->nlp_nodename,
+					sizeof(struct lpfc_name));
+			}
+			fast_path_evt->vport = vport;
+			fast_path_evt->work_evt.evt =
+				LPFC_EVT_FASTPATH_MGMT_EVT;
+			spin_lock_irqsave(&phba->hbalock, flags);
+			list_add_tail(&fast_path_evt->work_evt.evt_listp,
+				&phba->work_list);
+			spin_unlock_irqrestore(&phba->hbalock, flags);
+			lpfc_worker_wake_up(phba);
 			break;
 		case IOSTAT_LOCAL_REJECT:
 			if (lpfc_cmd->result == IOERR_INVALID_RPI ||
@@ -687,6 +929,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 				 scsi_get_resid(cmd));
 	}
 
+	lpfc_update_stats(phba, lpfc_cmd);
 	result = cmd->result;
 	sdev = cmd->device;
 	if (vport->cfg_max_scsicmpl_time &&
@@ -755,6 +998,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 				pnode->last_ramp_up_time = jiffies;
 			}
 		}
+		lpfc_send_sdev_queuedepth_change_event(phba, vport, pnode,
+			0xFFFFFFFF,
+			sdev->queue_depth - 1, sdev->queue_depth);
 	}
 
 	/*
@@ -784,6 +1030,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 					 "0711 detected queue full - lun queue "
 					 "depth adjusted to %d.\n", depth);
+			lpfc_send_sdev_queuedepth_change_event(phba, vport,
+				pnode, 0xFFFFFFFF,
+				depth+1, depth);
 		}
 	}
 
@@ -1112,6 +1361,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 		goto out_host_busy;
 	}
 
+	lpfc_cmd->start_time = jiffies;
 	/*
 	 * Store the midlayer's command structure for the completion phase
 	 * and complete the command initialization.
@@ -1280,6 +1530,7 @@ lpfc_device_reset_handler(struct scsi_cm
 	int ret = SUCCESS;
 	int status;
 	int cnt;
+	struct lpfc_scsi_event_header scsi_event;
 
 	lpfc_block_error_handler(cmnd);
 	/*
@@ -1298,6 +1549,19 @@ lpfc_device_reset_handler(struct scsi_cm
 			break;
 		pnode = rdata->pnode;
 	}
+
+	scsi_event.event_type = FC_REG_SCSI_EVENT;
+	scsi_event.subcategory = LPFC_EVENT_TGTRESET;
+	scsi_event.lun = 0;
+	memcpy(scsi_event.wwpn, &pnode->nlp_portname, sizeof(struct lpfc_name));
+	memcpy(scsi_event.wwnn, &pnode->nlp_nodename, sizeof(struct lpfc_name));
+
+	fc_host_post_vendor_event(shost,
+		fc_get_event_number(),
+		sizeof(scsi_event),
+		(char *)&scsi_event,
+		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
+
 	if (!rdata || pnode->nlp_state != NLP_STE_MAPPED_NODE) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "0721 LUN Reset rport "
@@ -1381,6 +1645,19 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 	int cnt;
 	struct lpfc_scsi_buf * lpfc_cmd;
 	unsigned long later;
+	struct lpfc_scsi_event_header scsi_event;
+
+	scsi_event.event_type = FC_REG_SCSI_EVENT;
+	scsi_event.subcategory = LPFC_EVENT_BUSRESET;
+	scsi_event.lun = 0;
+	memcpy(scsi_event.wwpn, &vport->fc_portname, sizeof(struct lpfc_name));
+	memcpy(scsi_event.wwnn, &vport->fc_nodename, sizeof(struct lpfc_name));
+
+	fc_host_post_vendor_event(shost,
+		fc_get_event_number(),
+		sizeof(scsi_event),
+		(char *)&scsi_event,
+		SCSI_NL_VID_TYPE_PCI | PCI_VENDOR_ID_EMULEX);
 
 	lpfc_block_error_handler(cmnd);
 	/*
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
--- a/drivers/scsi/lpfc/lpfc_scsi.h	2008-09-07 11:18:30.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.h	2008-09-07 11:19:34.000000000 -0400
@@ -107,6 +107,10 @@ struct fcp_cmnd {
 
 };
 
+struct lpfc_scsicmd_bkt {
+	uint32_t cmd_count;
+};
+
 struct lpfc_scsi_buf {
 	struct list_head list;
 	struct scsi_cmnd *pCmd;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-09-07 11:19:34.000000000 -0400
@@ -32,6 +32,7 @@
 
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
@@ -1611,6 +1612,17 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 	if (cmdiocbp) {
 		if (cmdiocbp->iocb_cmpl) {
 			/*
+			 * If an ELS command failed send an event to mgmt
+			 * application.
+			 */
+			if (saveq->iocb.ulpStatus &&
+			     (pring->ringno == LPFC_ELS_RING) &&
+			     (cmdiocbp->iocb.ulpCommand ==
+				CMD_ELS_REQUEST64_CR))
+				lpfc_send_els_failure_event(phba,
+					cmdiocbp, saveq);
+
+			/*
 			 * Post all ELS completions to the worker thread.
 			 * All other are passed to the completion callback.
 			 */
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2008-09-07 11:19:34.000000000 -0400
@@ -34,6 +34,7 @@
 #include <scsi/scsi_transport_fc.h>
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
+#include "lpfc_nl.h"
 #include "lpfc_disc.h"
 #include "lpfc_scsi.h"
 #include "lpfc.h"
@@ -745,3 +746,82 @@ lpfc_destroy_vport_work_array(struct lpf
 		scsi_host_put(lpfc_shost_from_vport(vports[i]));
 	kfree(vports);
 }
+
+
+/**
+ * lpfc_vport_reset_stat_data: Reset the statistical data for the vport.
+ * @vport: Pointer to vport object.
+ *
+ * This function resets the statistical data for the vport. This function
+ * is called with the host_lock held
+ **/
+void
+lpfc_vport_reset_stat_data(struct lpfc_vport *vport)
+{
+	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
+
+	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			continue;
+		if (ndlp->lat_data)
+			memset(ndlp->lat_data, 0, LPFC_MAX_BUCKET_COUNT *
+				sizeof(struct lpfc_scsicmd_bkt));
+	}
+}
+
+
+/**
+ * lpfc_alloc_bucket: Allocate data buffer required for collecting
+ *  statistical data.
+ * @vport: Pointer to vport object.
+ *
+ * This function allocates data buffer required for all the FC
+ * nodes of the vport to collect statistical data.
+ **/
+void
+lpfc_alloc_bucket(struct lpfc_vport *vport)
+{
+	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
+
+	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			continue;
+
+		kfree(ndlp->lat_data);
+		ndlp->lat_data = NULL;
+
+		if (ndlp->nlp_state == NLP_STE_MAPPED_NODE) {
+			ndlp->lat_data = kcalloc(LPFC_MAX_BUCKET_COUNT,
+					 sizeof(struct lpfc_scsicmd_bkt),
+					 GFP_ATOMIC);
+
+			if (!ndlp->lat_data)
+				lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
+					"0287 lpfc_alloc_bucket failed to "
+					"allocate statistical data buffer DID "
+					"0x%x\n", ndlp->nlp_DID);
+		}
+	}
+}
+
+/**
+ * lpfc_free_bucket: Free data buffer required for collecting
+ *  statistical data.
+ * @vport: Pointer to vport object.
+ *
+ * Th function frees statistical data buffer of all the FC
+ * nodes of the vport.
+ **/
+void
+lpfc_free_bucket(struct lpfc_vport *vport)
+{
+	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
+
+	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (!NLP_CHK_NODE_ACT(ndlp))
+			continue;
+
+		kfree(ndlp->lat_data);
+		ndlp->lat_data = NULL;
+	}
+}
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.h b/drivers/scsi/lpfc/lpfc_vport.h
--- a/drivers/scsi/lpfc/lpfc_vport.h	2008-09-06 11:54:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.h	2008-09-07 11:19:34.000000000 -0400
@@ -112,4 +112,8 @@ struct vport_cmd_tag {
 void lpfc_vport_set_state(struct lpfc_vport *vport,
 			  enum fc_vport_state new_state);
 
+void lpfc_vport_reset_stat_data(struct lpfc_vport *);
+void lpfc_alloc_bucket(struct lpfc_vport *);
+void lpfc_free_bucket(struct lpfc_vport *);
+
 #endif /* H_LPFC_VPORT */


