From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH V2 01/20] qla2xxx: Add mutex around optrom calls to serialize accesses.
Date: Mon, 16 Dec 2013 22:28:24 -0500
Message-ID: <1387250923-1041-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:1482 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207Ab3LQEBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 23:01:34 -0500
In-Reply-To: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   61 ++++++++++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_bsg.c  |   12 ++++++-
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_os.c   |    1 +
 4 files changed, 54 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 570c7fc..aafc92f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -241,12 +241,17 @@ qla2x00_sysfs_read_optrom(struct file *filp, struct kobject *kobj,
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
+	ssize_t rval = 0;
 
 	if (ha->optrom_state != QLA_SREADING)
 		return 0;
 
-	return memory_read_from_buffer(buf, count, &off, ha->optrom_buffer,
-					ha->optrom_region_size);
+	mutex_lock(&ha->optrom_mutex);
+	rval = memory_read_from_buffer(buf, count, &off, ha->optrom_buffer,
+	    ha->optrom_region_size);
+	mutex_unlock(&ha->optrom_mutex);
+
+	return rval;
 }
 
 static ssize_t
@@ -265,7 +270,9 @@ qla2x00_sysfs_write_optrom(struct file *filp, struct kobject *kobj,
 	if (off + count > ha->optrom_region_size)
 		count = ha->optrom_region_size - off;
 
+	mutex_lock(&ha->optrom_mutex);
 	memcpy(&ha->optrom_buffer[off], buf, count);
+	mutex_unlock(&ha->optrom_mutex);
 
 	return count;
 }
@@ -288,10 +295,10 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
-
 	uint32_t start = 0;
 	uint32_t size = ha->optrom_size;
 	int val, valid;
+	ssize_t rval = count;
 
 	if (off)
 		return -EINVAL;
@@ -304,12 +311,14 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 	if (start > ha->optrom_size)
 		return -EINVAL;
 
+	mutex_lock(&ha->optrom_mutex);
 	switch (val) {
 	case 0:
 		if (ha->optrom_state != QLA_SREADING &&
-		    ha->optrom_state != QLA_SWRITING)
-			return -EINVAL;
-
+		    ha->optrom_state != QLA_SWRITING) {
+			rval =  -EINVAL;
+			goto out;
+		}
 		ha->optrom_state = QLA_SWAITING;
 
 		ql_dbg(ql_dbg_user, vha, 0x7061,
@@ -320,8 +329,10 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		ha->optrom_buffer = NULL;
 		break;
 	case 1:
-		if (ha->optrom_state != QLA_SWAITING)
-			return -EINVAL;
+		if (ha->optrom_state != QLA_SWAITING) {
+			rval = -EINVAL;
+			goto out;
+		}
 
 		ha->optrom_region_start = start;
 		ha->optrom_region_size = start + size > ha->optrom_size ?
@@ -335,13 +346,15 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 			    "(%x).\n", ha->optrom_region_size);
 
 			ha->optrom_state = QLA_SWAITING;
-			return -ENOMEM;
+			rval = -ENOMEM;
+			goto out;
 		}
 
 		if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0x7063,
 			    "HBA not online, failing NVRAM update.\n");
-			return -EAGAIN;
+			rval = -EAGAIN;
+			goto out;
 		}
 
 		ql_dbg(ql_dbg_user, vha, 0x7064,
@@ -353,8 +366,10 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		    ha->optrom_region_start, ha->optrom_region_size);
 		break;
 	case 2:
-		if (ha->optrom_state != QLA_SWAITING)
-			return -EINVAL;
+		if (ha->optrom_state != QLA_SWAITING) {
+			rval = -EINVAL;
+			goto out;
+		}
 
 		/*
 		 * We need to be more restrictive on which FLASH regions are
@@ -388,7 +403,8 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		if (!valid) {
 			ql_log(ql_log_warn, vha, 0x7065,
 			    "Invalid start region 0x%x/0x%x.\n", start, size);
-			return -EINVAL;
+			rval = -EINVAL;
+			goto out;
 		}
 
 		ha->optrom_region_start = start;
@@ -403,7 +419,8 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 			    "(%x)\n", ha->optrom_region_size);
 
 			ha->optrom_state = QLA_SWAITING;
-			return -ENOMEM;
+			rval = -ENOMEM;
+			goto out;
 		}
 
 		ql_dbg(ql_dbg_user, vha, 0x7067,
@@ -413,13 +430,16 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		memset(ha->optrom_buffer, 0, ha->optrom_region_size);
 		break;
 	case 3:
-		if (ha->optrom_state != QLA_SWRITING)
-			return -EINVAL;
+		if (ha->optrom_state != QLA_SWRITING) {
+			rval = -EINVAL;
+			goto out;
+		}
 
 		if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 			ql_log(ql_log_warn, vha, 0x7068,
 			    "HBA not online, failing flash update.\n");
-			return -EAGAIN;
+			rval = -EAGAIN;
+			goto out;
 		}
 
 		ql_dbg(ql_dbg_user, vha, 0x7069,
@@ -430,9 +450,12 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		    ha->optrom_region_start, ha->optrom_region_size);
 		break;
 	default:
-		return -EINVAL;
+		rval = -EINVAL;
 	}
-	return count;
+
+out:
+	mutex_unlock(&ha->optrom_mutex);
+	return rval;
 }
 
 static struct bin_attribute sysfs_optrom_ctl_attr = {
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index f15d03e..71ff340 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1437,9 +1437,12 @@ qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 	if (ha->flags.nic_core_reset_hdlr_active)
 		return -EBUSY;
 
+	mutex_lock(&ha->optrom_mutex);
 	rval = qla2x00_optrom_setup(bsg_job, vha, 0);
-	if (rval)
+	if (rval) {
+		mutex_unlock(&ha->optrom_mutex);
 		return rval;
+	}
 
 	ha->isp_ops->read_optrom(vha, ha->optrom_buffer,
 	    ha->optrom_region_start, ha->optrom_region_size);
@@ -1453,6 +1456,7 @@ qla2x00_read_optrom(struct fc_bsg_job *bsg_job)
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
+	mutex_unlock(&ha->optrom_mutex);
 	bsg_job->job_done(bsg_job);
 	return rval;
 }
@@ -1465,9 +1469,12 @@ qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 	struct qla_hw_data *ha = vha->hw;
 	int rval = 0;
 
+	mutex_lock(&ha->optrom_mutex);
 	rval = qla2x00_optrom_setup(bsg_job, vha, 1);
-	if (rval)
+	if (rval) {
+		mutex_unlock(&ha->optrom_mutex);
 		return rval;
+	}
 
 	/* Set the isp82xx_no_md_cap not to capture minidump */
 	ha->flags.isp82xx_no_md_cap = 1;
@@ -1483,6 +1490,7 @@ qla2x00_update_optrom(struct fc_bsg_job *bsg_job)
 	vfree(ha->optrom_buffer);
 	ha->optrom_buffer = NULL;
 	ha->optrom_state = QLA_SWAITING;
+	mutex_unlock(&ha->optrom_mutex);
 	bsg_job->job_done(bsg_job);
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 41d6491..859c63a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3181,6 +3181,7 @@ struct qla_hw_data {
 #define QLA_SWRITING	2
 	uint32_t	optrom_region_start;
 	uint32_t	optrom_region_size;
+	struct mutex	optrom_mutex;
 
 /* PCI expansion ROM image information. */
 #define ROM_CODE_TYPE_BIOS	0
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 89a5300..53edc4b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2334,6 +2334,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ha->hardware_lock);
 	spin_lock_init(&ha->vport_slock);
 	mutex_init(&ha->selflogin_lock);
+	mutex_init(&ha->optrom_mutex);
 
 	/* Set ISP-type information. */
 	qla2x00_set_isp_flags(ha);
-- 
1.7.7

