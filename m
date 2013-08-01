From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v4 09/10] scsi_debug: Add optional unit attention reporting
Date: Thu,  1 Aug 2013 16:57:38 -0400
Message-ID: <1375390659-12495-10-git-send-email-emilne@redhat.com>
References: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757271Ab3HAU5r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Aug 2013 16:57:47 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r71Kvlx8005116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:47 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r71Kvgvi031004
	for <linux-scsi@vger.kernel.org>; Thu, 1 Aug 2013 16:57:47 -0400
In-Reply-To: <1375390659-12495-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Added "report_ua" module parameter to control reporting
of unit attention conditions when the number of LUNs is
changed, or the virtual_gb size of the device is changed.

Also added capability to generate unit attention conditions:

   38 07 - THIN PROVISIONING SOFT THRESHOLD REACHED
   2A 01 - MODE PARAMETERS CHANGED

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 131 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 182d5a5..738b197 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -111,6 +111,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_PTYPE   0
 #define DEF_SCSI_LEVEL   5    /* INQUIRY, byte2 [5->SPC-3] */
 #define DEF_SECTOR_SIZE 512
+#define DEF_REPORT_UA 0
 #define DEF_UNMAP_ALIGNMENT 0
 #define DEF_UNMAP_GRANULARITY 1
 #define DEF_UNMAP_MAX_BLOCKS 0xFFFFFFFF
@@ -182,6 +183,7 @@ static int scsi_debug_physblk_exp = DEF_PHYSBLK_EXP;
 static int scsi_debug_ptype = DEF_PTYPE; /* SCSI peripheral type (0==disk) */
 static int scsi_debug_scsi_level = DEF_SCSI_LEVEL;
 static int scsi_debug_sector_size = DEF_SECTOR_SIZE;
+static int scsi_debug_report_ua = DEF_REPORT_UA;
 static int scsi_debug_virtual_gb = DEF_VIRTUAL_GB;
 static int scsi_debug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
 static unsigned int scsi_debug_lbpu = DEF_LBPU;
@@ -230,6 +232,8 @@ struct sdebug_dev_info {
 	char reset;
 	char stopped;
 	char used;
+	char luns_changed;
+	char sense_pending;
 };
 
 struct sdebug_host_info {
@@ -268,6 +272,7 @@ static int num_host_resets = 0;
 static int dix_writes;
 static int dix_reads;
 static int dif_errors;
+static int luns_changed;
 
 static DEFINE_SPINLOCK(queued_arr_lock);
 static DEFINE_RWLOCK(atomic_rw);
@@ -2756,6 +2761,7 @@ module_param_named(physblk_exp, scsi_debug_physblk_exp, int, S_IRUGO);
 module_param_named(ptype, scsi_debug_ptype, int, S_IRUGO | S_IWUSR);
 module_param_named(scsi_level, scsi_debug_scsi_level, int, S_IRUGO);
 module_param_named(sector_size, scsi_debug_sector_size, int, S_IRUGO);
+module_param_named(report_ua, scsi_debug_report_ua, int, S_IRUGO | S_IWUSR);
 module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
 module_param_named(unmap_granularity, scsi_debug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, scsi_debug_unmap_max_blocks, int, S_IRUGO);
@@ -2798,6 +2804,7 @@ MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=5[SPC-3])");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
+MODULE_PARM_DESC(report_ua, "report unit attentions when reconfigured (def=0)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
@@ -3050,10 +3057,37 @@ static ssize_t sdebug_max_luns_store(struct device_driver * ddp,
 				     const char * buf, size_t count)
 {
         int n;
+	struct sdebug_host_info *sdbg_host;
+	struct sdebug_dev_info *devip;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		scsi_debug_max_luns = n;
 		sdebug_max_tgts_luns();
+
+		if (!scsi_debug_report_ua)
+			return count;
+
+		/*
+		 * SPC-3 behavior is to report a UNIT ATTENTION with ASC/ASCQ
+		 * REPORTED LUNS DATA HAS CHANGED on every LUN on the target,
+		 * until a REPORT LUNS command is received.  SPC-4 behavior is
+		 * to report it only once.  NOTE:  scsi_debug_scsi_level does
+		 * not use the same values as struct scsi_device->scsi_level.
+		 */
+		if (scsi_debug_scsi_level == 5) {	/* SPC-3 */
+			spin_lock(&sdebug_host_list_lock);
+			list_for_each_entry(sdbg_host, &sdebug_host_list,
+					    host_list) {
+				list_for_each_entry(devip,
+						    &sdbg_host->dev_info_list,
+						    dev_list) {
+					devip->luns_changed = 1;
+				}
+			}
+			spin_unlock(&sdebug_host_list_lock);
+		} else if (scsi_debug_scsi_level > 5)
+			luns_changed = 1;
+
 		return count;
 	}
 	return -EINVAL;
@@ -3100,12 +3134,27 @@ static ssize_t sdebug_virtual_gb_store(struct device_driver * ddp,
 				       const char * buf, size_t count)
 {
         int n;
+	struct sdebug_host_info *sdbg_host;
+	struct sdebug_dev_info *devip;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		scsi_debug_virtual_gb = n;
 
 		sdebug_capacity = get_sdebug_capacity();
 
+		if (!scsi_debug_report_ua)
+			return count;
+
+		spin_lock(&sdebug_host_list_lock);
+		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+			list_for_each_entry(devip, &sdbg_host->dev_info_list,
+					    dev_list) {
+				mk_sense_buffer(devip, UNIT_ATTENTION,
+						0x2a, 0x09);
+				devip->sense_pending = 1;
+			}
+		}
+		spin_unlock(&sdebug_host_list_lock);
 		return count;
 	}
 	return -EINVAL;
@@ -3205,6 +3254,57 @@ static ssize_t sdebug_map_show(struct device_driver *ddp, char *buf)
 }
 DRIVER_ATTR(map, S_IRUGO, sdebug_map_show, NULL);
 
+static ssize_t sdebug_soft_threshold_reached_store(struct device_driver *ddp,
+						   const char *buf,
+						   size_t count)
+{
+	int n;
+	struct sdebug_host_info *sdbg_host;
+	struct sdebug_dev_info *devip;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		spin_lock(&sdebug_host_list_lock);
+		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+			list_for_each_entry(devip, &sdbg_host->dev_info_list,
+					    dev_list) {
+				mk_sense_buffer(devip, UNIT_ATTENTION,
+						0x38, 0x07);
+				devip->sense_pending = 1;
+			}
+		}
+		spin_unlock(&sdebug_host_list_lock);
+		return count;
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(soft_threshold_reached, S_IWUSR, NULL,
+	    sdebug_soft_threshold_reached_store);
+
+static ssize_t sdebug_mode_parameters_changed_store(struct device_driver *ddp,
+						    const char *buf,
+						    size_t count)
+{
+	int n;
+	struct sdebug_host_info *sdbg_host;
+	struct sdebug_dev_info *devip;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		spin_lock(&sdebug_host_list_lock);
+		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+			list_for_each_entry(devip, &sdbg_host->dev_info_list,
+					    dev_list) {
+				mk_sense_buffer(devip, UNIT_ATTENTION,
+						0x2a, 0x01);
+				devip->sense_pending = 1;
+			}
+		}
+		spin_unlock(&sdebug_host_list_lock);
+		return count;
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(mode_parameters_changed, S_IWUSR, NULL,
+	    sdebug_mode_parameters_changed_store);
 
 /* Note: The following function creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
@@ -3239,11 +3339,19 @@ static int do_create_driverfs_files(void)
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_guard);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_ato);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_map);
+	ret |= driver_create_file(&sdebug_driverfs_driver,
+				  &driver_attr_soft_threshold_reached);
+	ret |= driver_create_file(&sdebug_driverfs_driver,
+				  &driver_attr_mode_parameters_changed);
 	return ret;
 }
 
 static void do_remove_driverfs_files(void)
 {
+	driver_remove_file(&sdebug_driverfs_driver,
+			   &driver_attr_mode_parameters_changed);
+	driver_remove_file(&sdebug_driverfs_driver,
+			   &driver_attr_soft_threshold_reached);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_map);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_ato);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_guard);
@@ -3597,6 +3705,8 @@ int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 	int inj_dix = 0;
 	int delay_override = 0;
 	int unmap = 0;
+	struct sdebug_host_info *sdbg_host;
+	struct sdebug_dev_info *tmpdevip;
 
 	scsi_set_resid(SCpnt, 0);
 	if ((SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) && cmd) {
@@ -3774,6 +3884,15 @@ read:
 		}
 		break;
 	case REPORT_LUNS:	/* mandatory, ignore unit attention */
+		luns_changed = 0;
+		spin_lock(&sdebug_host_list_lock);
+		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+			list_for_each_entry(tmpdevip, &sdbg_host->dev_info_list,
+					    dev_list) {
+				tmpdevip->luns_changed = 0;
+			}
+		}
+		spin_unlock(&sdebug_host_list_lock);
 		delay_override = 1;
 		errsts = resp_report_luns(SCpnt, devip);
 		break;
@@ -3926,6 +4045,18 @@ write:
 		errsts = check_condition_result;
 		break;
 	}
+	if (!errsts && (*cmd != INQUIRY) && (*cmd != REPORT_LUNS)) {
+		if (!devip->sense_pending &&
+		    (luns_changed || devip->luns_changed)) {
+			luns_changed = 0;
+			devip->luns_changed = 0;
+			mk_sense_buffer(devip, UNIT_ATTENTION, 0x3f, 0x0e);
+			errsts = check_condition_result;
+		} else if (devip->sense_pending) {
+			devip->sense_pending = 0;
+			errsts = check_condition_result;
+		}
+	}
 	return schedule_resp(SCpnt, devip, done, errsts,
 			     (delay_override ? 0 : scsi_debug_delay));
 }
-- 
1.7.11.7

