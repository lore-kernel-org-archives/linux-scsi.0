From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v2 7/8] [SCSI] Add sense and Unit Attention generation to scsi_debug
Date: Fri,  1 Feb 2013 12:53:14 -0500
Message-ID: <1359741195-2641-8-git-send-email-emilne@redhat.com>
References: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293Ab3BARxU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Feb 2013 12:53:20 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r11HrKL9000901
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:20 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r11HrGRk011917
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:19 -0500
In-Reply-To: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Added capability to scsi_debug to generate sense and Unit Attention
conditions to exercise the enhanced sense and Unit Attention handling.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 138 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 182d5a5..8a6bf31 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -230,6 +230,7 @@ struct sdebug_dev_info {
 	char reset;
 	char stopped;
 	char used;
+	char sense_pending;
 };
 
 struct sdebug_host_info {
@@ -3050,10 +3051,27 @@ static ssize_t sdebug_max_luns_store(struct device_driver * ddp,
 				     const char * buf, size_t count)
 {
         int n;
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	struct sdebug_host_info *sdbg_host;
+	struct sdebug_dev_info *devip;
+#endif
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		scsi_debug_max_luns = n;
 		sdebug_max_tgts_luns();
+
+#ifdef CONFIG_SCSI_ENHANCED_UA
+		spin_lock(&sdebug_host_list_lock);
+		list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+			list_for_each_entry(devip, &sdbg_host->dev_info_list,
+					    dev_list) {
+				mk_sense_buffer(devip, UNIT_ATTENTION,
+						0x3f, 0x0e);
+				devip->sense_pending = 1;
+			}
+		}
+		spin_unlock(&sdebug_host_list_lock);
+#endif
 		return count;
 	}
 	return -EINVAL;
@@ -3100,12 +3118,28 @@ static ssize_t sdebug_virtual_gb_store(struct device_driver * ddp,
 				       const char * buf, size_t count)
 {
         int n;
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	struct sdebug_host_info *sdbg_host;
+	struct sdebug_dev_info *devip;
+#endif
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		scsi_debug_virtual_gb = n;
 
 		sdebug_capacity = get_sdebug_capacity();
 
+#ifdef CONFIG_SCSI_ENHANCED_UA
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
+#endif
 		return count;
 	}
 	return -EINVAL;
@@ -3206,6 +3240,90 @@ static ssize_t sdebug_map_show(struct device_driver *ddp, char *buf)
 DRIVER_ATTR(map, S_IRUGO, sdebug_map_show, NULL);
 
 
+#ifdef CONFIG_SCSI_ENHANCED_UA
+static ssize_t sdebug_ua_overflow_store(struct device_driver *ddp,
+					const char *buf, size_t count)
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
+				if (scsi_debug_dsense) {
+					mk_sense_buffer(devip, UNIT_ATTENTION,
+							0, 0);
+					devip->sense_buff[7] = 8;
+					devip->sense_buff[8] = 0x02;
+					devip->sense_buff[9] = 0x06;
+					devip->sense_buff[12] = 0x01;
+				}
+				devip->sense_pending = 1;
+			}
+		}
+		spin_unlock(&sdebug_host_list_lock);
+		return count;
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(ua_overflow, S_IWUSR, NULL, sdebug_ua_overflow_store);
+
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
+#endif
+
 /* Note: The following function creates attribute files in the
    /sys/bus/pseudo/drivers/scsi_debug directory. The advantage of these
    files (over those found in the /sys/module/scsi_debug/parameters
@@ -3239,11 +3357,27 @@ static int do_create_driverfs_files(void)
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_guard);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_ato);
 	ret |= driver_create_file(&sdebug_driverfs_driver, &driver_attr_map);
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	ret |= driver_create_file(&sdebug_driverfs_driver,
+				  &driver_attr_ua_overflow);
+	ret |= driver_create_file(&sdebug_driverfs_driver,
+				  &driver_attr_soft_threshold_reached);
+	ret |= driver_create_file(&sdebug_driverfs_driver,
+				  &driver_attr_mode_parameters_changed);
+#endif
 	return ret;
 }
 
 static void do_remove_driverfs_files(void)
 {
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	driver_remove_file(&sdebug_driverfs_driver,
+			   &driver_attr_mode_parameters_changed);
+	driver_remove_file(&sdebug_driverfs_driver,
+			   &driver_attr_soft_threshold_reached);
+	driver_remove_file(&sdebug_driverfs_driver,
+			   &driver_attr_ua_overflow);
+#endif
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_map);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_ato);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_guard);
@@ -3926,6 +4060,10 @@ write:
 		errsts = check_condition_result;
 		break;
 	}
+	if (!errsts && devip->sense_pending) {
+		devip->sense_pending = 0;
+		errsts = check_condition_result;
+	}
 	return schedule_resp(SCpnt, devip, done, errsts,
 			     (delay_override ? 0 : scsi_debug_delay));
 }
-- 
1.7.11.7

