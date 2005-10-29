From: James.Smart@Emulex.Com
Subject: [PATCH 4/15]  lpfc 8.1.0 : Add range checking for attributes passed as options at load time.
Date: Fri, 28 Oct 2005 20:29:13 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A53@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:65488 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750913AbVJ2A3P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:15 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0TEDp018509
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:14 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add range checking for attributes passed as options at load time.


Fix: Reuse macros defined for sysfs store callbacks in the
initialization code in order to enforce the same range checking. 


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -292,45 +292,69 @@ lpfc_##attr##_show(struct class_device *
 	struct Scsi_Host *host = class_to_shost(cdev);\
 	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];\
 	int val = 0;\
-	if (phba){\
-		val = phba->cfg_##attr;\
-		return snprintf(buf, PAGE_SIZE, "%d\n",\
-				phba->cfg_##attr);\
+	val = phba->cfg_##attr;\
+	return snprintf(buf, PAGE_SIZE, "%d\n",\
+			phba->cfg_##attr);\
+}
+
+#define lpfc_param_init(attr, default, minval, maxval)	\
+static int \
+lpfc_##attr##_init(struct lpfc_hba *phba, int val) \
+{ \
+	if (val >= minval && val <= maxval) {\
+		phba->cfg_##attr = val;\
+		return 0;\
 	}\
-	return -EPERM;\
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT, \
+			"%d:0449 lpfc_"#attr" attribute cannot be set to %d, "\
+			"allowed range is ["#minval", "#maxval"]\n", \
+			phba->brd_no, val); \
+	phba->cfg_##attr = default;\
+	return -EINVAL;\
 }
 
-#define lpfc_param_store(attr, minval, maxval)	\
+#define lpfc_param_set(attr, default, minval, maxval)	\
+static int \
+lpfc_##attr##_set(struct lpfc_hba *phba, int val) \
+{ \
+	if (val >= minval && val <= maxval) {\
+		phba->cfg_##attr = val;\
+		return 0;\
+	}\
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT, \
+			"%d:0450 lpfc_"#attr" attribute cannot be set to %d, "\
+			"allowed range is ["#minval", "#maxval"]\n", \
+			phba->brd_no, val); \
+	return -EINVAL;\
+}
+
+#define lpfc_param_store(attr)	\
 static ssize_t \
 lpfc_##attr##_store(struct class_device *cdev, const char *buf, size_t count) \
 { \
 	struct Scsi_Host *host = class_to_shost(cdev);\
 	struct lpfc_hba *phba = (struct lpfc_hba*)host->hostdata[0];\
-	int val = 0;\
-	if (!isdigit(buf[0]))\
-		return -EINVAL;\
-	if (sscanf(buf, "0x%x", &val) != 1)\
-		if (sscanf(buf, "%d", &val) != 1)\
-			return -EINVAL;\
-	if (val >= minval && val <= maxval) {\
-		phba->cfg_##attr = val;\
+	int val=0;\
+	if (sscanf(buf, "%d", &val) != 1)\
+	return -EPERM;\
+	if (lpfc_##attr##_set(phba, val) == 0) \
 		return strlen(buf);\
-	}\
-	return -EINVAL;\
+	else \
+		return -EINVAL;\
 }
 
-#define LPFC_ATTR_R_NOINIT(name, desc) \
-extern int lpfc_##name;\
+#define LPFC_ATTR(name, defval, minval, maxval, desc) \
+static int lpfc_##name = defval;\
 module_param(lpfc_##name, int, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
-lpfc_param_show(name)\
-static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
+lpfc_param_init(name, defval, minval, maxval)
 
 #define LPFC_ATTR_R(name, defval, minval, maxval, desc) \
 static int lpfc_##name = defval;\
 module_param(lpfc_##name, int, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_show(name)\
+lpfc_param_init(name, defval, minval, maxval)\
 static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
 
 #define LPFC_ATTR_RW(name, defval, minval, maxval, desc) \
@@ -338,7 +362,9 @@ static int lpfc_##name = defval;\
 module_param(lpfc_##name, int, 0);\
 MODULE_PARM_DESC(lpfc_##name, desc);\
 lpfc_param_show(name)\
-lpfc_param_store(name, minval, maxval)\
+lpfc_param_init(name, defval, minval, maxval)\
+lpfc_param_set(name, defval, minval, maxval)\
+lpfc_param_store(name)\
 static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
 			 lpfc_##name##_show, lpfc_##name##_store)
 
@@ -471,14 +497,10 @@ LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0 
 # is 0. Default value of cr_count is 1. The cr_count feature is disabled if
 # cr_delay is set to 0.
 */
-static int lpfc_cr_delay = 0;
-module_param(lpfc_cr_delay, int , 0);
-MODULE_PARM_DESC(lpfc_cr_delay, "A count of milliseconds after which an "
+LPFC_ATTR(cr_delay, 0, 0, 63, "A count of milliseconds after which an"
 		"interrupt response is generated");
 
-static int lpfc_cr_count = 1;
-module_param(lpfc_cr_count, int, 0);
-MODULE_PARM_DESC(lpfc_cr_count, "A count of I/O completions after which an "
+LPFC_ATTR(cr_count, 1, 1, 255, "A count of I/O completions after which an"
 		"interrupt response is generated");
 
 /*
@@ -494,9 +516,7 @@ LPFC_ATTR_RW(fdmi_on, 0, 0, 2, "Enable F
 # Specifies the maximum number of ELS cmds we can have outstanding (for
 # discovery). Value range is [1,64]. Default value = 32.
 */
-static int lpfc_discovery_threads = 32;
-module_param(lpfc_discovery_threads, int, 0);
-MODULE_PARM_DESC(lpfc_discovery_threads, "Maximum number of ELS commands "
+LPFC_ATTR(discovery_threads, 32, 1, 64, "Maximum number of ELS commands"
 		 "during discovery");
 
 /*
@@ -1233,20 +1253,20 @@ struct fc_function_template lpfc_transpo
 void
 lpfc_get_cfgparam(struct lpfc_hba *phba)
 {
-	phba->cfg_log_verbose = lpfc_log_verbose;
-	phba->cfg_cr_delay = lpfc_cr_delay;
-	phba->cfg_cr_count = lpfc_cr_count;
-	phba->cfg_lun_queue_depth = lpfc_lun_queue_depth;
-	phba->cfg_fcp_class = lpfc_fcp_class;
-	phba->cfg_use_adisc = lpfc_use_adisc;
-	phba->cfg_ack0 = lpfc_ack0;
-	phba->cfg_topology = lpfc_topology;
-	phba->cfg_scan_down = lpfc_scan_down;
-	phba->cfg_nodev_tmo = lpfc_nodev_tmo;
-	phba->cfg_link_speed = lpfc_link_speed;
-	phba->cfg_fdmi_on = lpfc_fdmi_on;
-	phba->cfg_discovery_threads = lpfc_discovery_threads;
-	phba->cfg_max_luns = lpfc_max_luns;
+	lpfc_log_verbose_init(phba, lpfc_log_verbose);
+	lpfc_cr_delay_init(phba, lpfc_cr_delay);
+	lpfc_cr_count_init(phba, lpfc_cr_count);
+	lpfc_lun_queue_depth_init(phba, lpfc_lun_queue_depth);
+	lpfc_fcp_class_init(phba, lpfc_fcp_class);
+	lpfc_use_adisc_init(phba, lpfc_use_adisc);
+	lpfc_ack0_init(phba, lpfc_ack0);
+	lpfc_topology_init(phba, lpfc_topology);
+	lpfc_scan_down_init(phba, lpfc_scan_down);
+	lpfc_nodev_tmo_init(phba, lpfc_nodev_tmo);
+	lpfc_link_speed_init(phba, lpfc_link_speed);
+	lpfc_fdmi_on_init(phba, lpfc_fdmi_on);
+	lpfc_discovery_threads_init(phba, lpfc_discovery_threads);
+	lpfc_max_luns_init(phba, lpfc_max_luns);
 
 	/*
 	 * The total number of segments is the configuration value plus 2
