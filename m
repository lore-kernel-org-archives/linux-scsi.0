From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/8] lpfc 8.2.2 : Attribute and Parameter splits for vport
	and physical port
Date: Tue, 31 Jul 2007 21:27:17 +0000 (UTC)
Message-ID: <1186067399.14374.18.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50133 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765455AbXGaV0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jul 2007 17:26:55 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l6VLQnii028958
	for <linux-scsi@vger.kernel.org>; Tue, 31 Jul 2007 14:26:54 -0700 (PDT)
Date: Thu, 02 Aug 2007 11:09:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Attribute and Parameter splits for vport and physical port
 - Split attributes up into vport and non-vport attributes.
 - Move vport specific cfg params to vport

Many of the vport-specific behaviors were still global attributes
on the physical port. Move them to the vport itself. 

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 09:26:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-08-02 09:28:15.000000000 -0400
@@ -734,6 +734,77 @@ lpfc_##attr##_store(struct class_device 
 		return -EINVAL;\
 }
 
+#define lpfc_vport_param_show(attr)	\
+static ssize_t \
+lpfc_##attr##_show(struct class_device *cdev, char *buf) \
+{ \
+	struct Scsi_Host  *shost = class_to_shost(cdev);\
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
+	int val = 0;\
+	val = vport->cfg_##attr;\
+	return snprintf(buf, PAGE_SIZE, "%d\n", vport->cfg_##attr);\
+}
+
+#define lpfc_vport_param_hex_show(attr)	\
+static ssize_t \
+lpfc_##attr##_show(struct class_device *cdev, char *buf) \
+{ \
+	struct Scsi_Host  *shost = class_to_shost(cdev);\
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
+	int val = 0;\
+	val = vport->cfg_##attr;\
+	return snprintf(buf, PAGE_SIZE, "%#x\n", vport->cfg_##attr);\
+}
+
+#define lpfc_vport_param_init(attr, default, minval, maxval)	\
+static int \
+lpfc_##attr##_init(struct lpfc_vport *vport, int val) \
+{ \
+	if (val >= minval && val <= maxval) {\
+		vport->cfg_##attr = val;\
+		return 0;\
+	}\
+	lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT, \
+			"%d:0449 lpfc_"#attr" attribute cannot be set to %d, "\
+			"allowed range is ["#minval", "#maxval"]\n", \
+			vport->phba->brd_no, val); \
+	vport->cfg_##attr = default;\
+	return -EINVAL;\
+}
+
+#define lpfc_vport_param_set(attr, default, minval, maxval)	\
+static int \
+lpfc_##attr##_set(struct lpfc_vport *vport, int val) \
+{ \
+	if (val >= minval && val <= maxval) {\
+		vport->cfg_##attr = val;\
+		return 0;\
+	}\
+	lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT, \
+			"%d:0450 lpfc_"#attr" attribute cannot be set to %d, "\
+			"allowed range is ["#minval", "#maxval"]\n", \
+			vport->phba->brd_no, val); \
+	return -EINVAL;\
+}
+
+#define lpfc_vport_param_store(attr)	\
+static ssize_t \
+lpfc_##attr##_store(struct class_device *cdev, const char *buf, size_t count) \
+{ \
+	struct Scsi_Host  *shost = class_to_shost(cdev);\
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;\
+	int val=0;\
+	if (!isdigit(buf[0]))\
+		return -EINVAL;\
+	if (sscanf(buf, "%i", &val) != 1)\
+		return -EINVAL;\
+	if (lpfc_##attr##_set(vport, val) == 0) \
+		return strlen(buf);\
+	else \
+		return -EINVAL;\
+}
+
+
 #define LPFC_ATTR(name, defval, minval, maxval, desc) \
 static int lpfc_##name = defval;\
 module_param(lpfc_##name, int, 0);\
@@ -778,6 +849,50 @@ lpfc_param_store(name)\
 static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
 			 lpfc_##name##_show, lpfc_##name##_store)
 
+#define LPFC_VPORT_ATTR(name, defval, minval, maxval, desc) \
+static int lpfc_##name = defval;\
+module_param(lpfc_##name, int, 0);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_init(name, defval, minval, maxval)
+
+#define LPFC_VPORT_ATTR_R(name, defval, minval, maxval, desc) \
+static int lpfc_##name = defval;\
+module_param(lpfc_##name, int, 0);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_show(name)\
+lpfc_vport_param_init(name, defval, minval, maxval)\
+static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
+
+#define LPFC_VPORT_ATTR_RW(name, defval, minval, maxval, desc) \
+static int lpfc_##name = defval;\
+module_param(lpfc_##name, int, 0);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_show(name)\
+lpfc_vport_param_init(name, defval, minval, maxval)\
+lpfc_vport_param_set(name, defval, minval, maxval)\
+lpfc_vport_param_store(name)\
+static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
+			 lpfc_##name##_show, lpfc_##name##_store)
+
+#define LPFC_VPORT_ATTR_HEX_R(name, defval, minval, maxval, desc) \
+static int lpfc_##name = defval;\
+module_param(lpfc_##name, int, 0);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_hex_show(name)\
+lpfc_vport_param_init(name, defval, minval, maxval)\
+static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO , lpfc_##name##_show, NULL)
+
+#define LPFC_VPORT_ATTR_HEX_RW(name, defval, minval, maxval, desc) \
+static int lpfc_##name = defval;\
+module_param(lpfc_##name, int, 0);\
+MODULE_PARM_DESC(lpfc_##name, desc);\
+lpfc_vport_param_hex_show(name)\
+lpfc_vport_param_init(name, defval, minval, maxval)\
+lpfc_vport_param_set(name, defval, minval, maxval)\
+lpfc_vport_param_store(name)\
+static CLASS_DEVICE_ATTR(lpfc_##name, S_IRUGO | S_IWUSR,\
+			 lpfc_##name##_show, lpfc_##name##_store)
+
 static CLASS_DEVICE_ATTR(info, S_IRUGO, lpfc_info_show, NULL);
 static CLASS_DEVICE_ATTR(serialnum, S_IRUGO, lpfc_serialnum_show, NULL);
 static CLASS_DEVICE_ATTR(modeldesc, S_IRUGO, lpfc_modeldesc_show, NULL);
@@ -1019,53 +1134,48 @@ lpfc_nodev_tmo_show(struct class_device 
 {
 	struct Scsi_Host  *shost = class_to_shost(cdev);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_hba   *phba = vport->phba;
 	int val = 0;
-	val = phba->cfg_devloss_tmo;
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-			phba->cfg_devloss_tmo);
+	val = vport->cfg_devloss_tmo;
+	return snprintf(buf, PAGE_SIZE, "%d\n",	vport->cfg_devloss_tmo);
 }
 
 static int
-lpfc_nodev_tmo_init(struct lpfc_hba *phba, int val)
+lpfc_nodev_tmo_init(struct lpfc_vport *vport, int val)
 {
-	static int warned;
-	if (phba->cfg_devloss_tmo !=  LPFC_DEF_DEVLOSS_TMO) {
-		phba->cfg_nodev_tmo = phba->cfg_devloss_tmo;
-		if (!warned && val != LPFC_DEF_DEVLOSS_TMO) {
-			warned = 1;
-			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-					"%d:0402 Ignoring nodev_tmo module "
-					"parameter because devloss_tmo is"
+	if (vport->cfg_devloss_tmo != LPFC_DEF_DEVLOSS_TMO) {
+		vport->cfg_nodev_tmo = vport->cfg_devloss_tmo;
+		if (val != LPFC_DEF_DEVLOSS_TMO)
+			lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
+					"%d (%d):0402 Ignoring nodev_tmo module"
+					" parameter because devloss_tmo is"
 					" set.\n",
-					phba->brd_no);
-		}
+					vport->phba->brd_no, vport->vpi);
 		return 0;
 	}
 
 	if (val >= LPFC_MIN_DEVLOSS_TMO && val <= LPFC_MAX_DEVLOSS_TMO) {
-		phba->cfg_nodev_tmo = val;
-		phba->cfg_devloss_tmo = val;
+		vport->cfg_nodev_tmo = val;
+		vport->cfg_devloss_tmo = val;
 		return 0;
 	}
-	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"%d:0400 lpfc_nodev_tmo attribute cannot be set to %d, "
-			"allowed range is [%d, %d]\n",
-			phba->brd_no, val,
+	lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
+			"%d (%d):0400 lpfc_nodev_tmo attribute cannot be set to"
+			" %d, allowed range is [%d, %d]\n",
+			vport->phba->brd_no, vport->vpi, val,
 			LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
-	phba->cfg_nodev_tmo = LPFC_DEF_DEVLOSS_TMO;
+	vport->cfg_nodev_tmo = LPFC_DEF_DEVLOSS_TMO;
 	return -EINVAL;
 }
 
 static void
-lpfc_update_rport_devloss_tmo(struct lpfc_hba *phba)
+lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
 {
 	struct lpfc_vport **vports;
 	struct Scsi_Host  *shost;
 	struct lpfc_nodelist  *ndlp;
 	int i;
 
-	vports = lpfc_create_vport_work_array(phba);
+	vports = lpfc_create_vport_work_array(vport->phba);
 	if (vports != NULL)
 		for(i = 0; i < LPFC_MAX_VPORTS && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
@@ -1074,40 +1184,38 @@ lpfc_update_rport_devloss_tmo(struct lpf
 					    nlp_listp)
 			if (ndlp->rport)
 				ndlp->rport->dev_loss_tmo =
-						phba->cfg_devloss_tmo;
+						vport->cfg_devloss_tmo;
 			spin_unlock_irq(shost->host_lock);
 		}
 	lpfc_destroy_vport_work_array(vports);
 }
 
 static int
-lpfc_nodev_tmo_set(struct lpfc_hba *phba, int val)
+lpfc_nodev_tmo_set(struct lpfc_vport *vport, int val)
 {
-	if (phba->dev_loss_tmo_changed ||
-		(lpfc_devloss_tmo != LPFC_DEF_DEVLOSS_TMO)) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"%d:0401 Ignoring change to nodev_tmo "
+	if (vport->dev_loss_tmo_changed ||
+	    (lpfc_devloss_tmo != LPFC_DEF_DEVLOSS_TMO)) {
+		lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
+				"%d (%d):0401 Ignoring change to nodev_tmo "
 				"because devloss_tmo is set.\n",
-				phba->brd_no);
+				vport->phba->brd_no, vport->vpi);
 		return 0;
 	}
-
 	if (val >= LPFC_MIN_DEVLOSS_TMO && val <= LPFC_MAX_DEVLOSS_TMO) {
-		phba->cfg_nodev_tmo = val;
-		phba->cfg_devloss_tmo = val;
-		lpfc_update_rport_devloss_tmo(phba);
+		vport->cfg_nodev_tmo = val;
+		vport->cfg_devloss_tmo = val;
+		lpfc_update_rport_devloss_tmo(vport);
 		return 0;
 	}
-
-	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"%d:0403 lpfc_nodev_tmo attribute cannot be set to %d, "
-			"allowed range is [%d, %d]\n",
-			phba->brd_no, val, LPFC_MIN_DEVLOSS_TMO,
-			LPFC_MAX_DEVLOSS_TMO);
+	lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
+			"%d (%d):0403 lpfc_nodev_tmo attribute cannot be set to"
+			"%d, allowed range is [%d, %d]\n",
+			vport->phba->brd_no, vport->vpi, val,
+			LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO);
 	return -EINVAL;
 }
 
-lpfc_param_store(nodev_tmo)
+lpfc_vport_param_store(nodev_tmo)
 
 static CLASS_DEVICE_ATTR(lpfc_nodev_tmo, S_IRUGO | S_IWUSR,
 			 lpfc_nodev_tmo_show, lpfc_nodev_tmo_store);
@@ -1121,29 +1229,29 @@ module_param(lpfc_devloss_tmo, int, 0);
 MODULE_PARM_DESC(lpfc_devloss_tmo,
 		 "Seconds driver will hold I/O waiting "
 		 "for a device to come back");
-lpfc_param_init(devloss_tmo, LPFC_DEF_DEVLOSS_TMO,
-		LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO)
-lpfc_param_show(devloss_tmo)
+lpfc_vport_param_init(devloss_tmo, LPFC_DEF_DEVLOSS_TMO,
+		      LPFC_MIN_DEVLOSS_TMO, LPFC_MAX_DEVLOSS_TMO)
+lpfc_vport_param_show(devloss_tmo)
 static int
-lpfc_devloss_tmo_set(struct lpfc_hba *phba, int val)
+lpfc_devloss_tmo_set(struct lpfc_vport *vport, int val)
 {
 	if (val >= LPFC_MIN_DEVLOSS_TMO && val <= LPFC_MAX_DEVLOSS_TMO) {
-		phba->cfg_nodev_tmo = val;
-		phba->cfg_devloss_tmo = val;
-		phba->dev_loss_tmo_changed = 1;
-		lpfc_update_rport_devloss_tmo(phba);
+		vport->cfg_nodev_tmo = val;
+		vport->cfg_devloss_tmo = val;
+		vport->dev_loss_tmo_changed = 1;
+		lpfc_update_rport_devloss_tmo(vport);
 		return 0;
 	}
 
-	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+	lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
 			"%d:0404 lpfc_devloss_tmo attribute cannot be set to"
 			" %d, allowed range is [%d, %d]\n",
-			phba->brd_no, val, LPFC_MIN_DEVLOSS_TMO,
+			vport->phba->brd_no, val, LPFC_MIN_DEVLOSS_TMO,
 			LPFC_MAX_DEVLOSS_TMO);
 	return -EINVAL;
 }
 
-lpfc_param_store(devloss_tmo)
+lpfc_vport_param_store(devloss_tmo)
 static CLASS_DEVICE_ATTR(lpfc_devloss_tmo, S_IRUGO | S_IWUSR,
 	lpfc_devloss_tmo_show, lpfc_devloss_tmo_store);
 
@@ -1171,8 +1279,8 @@ LPFC_ATTR_HEX_RW(log_verbose, 0x0, 0x0, 
 # lun_queue_depth:  This parameter is used to limit the number of outstanding
 # commands per FCP LUN. Value range is [1,128]. Default value is 30.
 */
-LPFC_ATTR_R(lun_queue_depth, 30, 1, 128,
-	    "Max number of FCP commands we can queue to a specific LUN");
+LPFC_VPORT_ATTR_R(lun_queue_depth, 30, 1, 128,
+		  "Max number of FCP commands we can queue to a specific LUN");
 
 /*
 # hba_queue_depth:  This parameter is used to limit the number of outstanding
@@ -1193,12 +1301,12 @@ LPFC_ATTR_R(hba_queue_depth, 8192, 32, 8
 # are allowed to login to each other.
 # Default value of this parameter is 0.
 */
-LPFC_ATTR_R(peer_port_login, 0, 0, 1,
-	    "Allow peer ports on the same physical port to login to each "
-	    "other.");
+LPFC_VPORT_ATTR_R(peer_port_login, 0, 0, 1,
+		  "Allow peer ports on the same physical port to login to each "
+		  "other.");
 
 /*
-# vport_restrict_login:  This parameter allows/prevents logins
+# restrict_login:  This parameter allows/prevents logins
 # between Virtual Ports and remote initiators.
 # When this parameter is not set (0) Virtual Ports will accept PLOGIs from
 # other initiators and will attempt to PLOGI all remote ports.
@@ -1208,8 +1316,56 @@ LPFC_ATTR_R(peer_port_login, 0, 0, 1,
 # This parameter does not restrict logins to Fabric resident remote ports.
 # Default value of this parameter is 1.
 */
-LPFC_ATTR_RW(vport_restrict_login, 1, 0, 1,
-	    "Restrict virtual ports login to remote initiators.");
+static int lpfc_restrict_login = 1;
+module_param(lpfc_restrict_login, int, 0);
+MODULE_PARM_DESC(lpfc_restrict_login,
+		 "Restrict virtual ports login to remote initiators.");
+lpfc_vport_param_show(restrict_login);
+
+static int
+lpfc_restrict_login_init(struct lpfc_vport *vport, int val)
+{
+	if (val < 0 || val > 1) {
+		lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
+				"%d:0449 lpfc_restrict_login attribute cannot "
+				"be set to %d, allowed range is [0, 1]\n",
+				vport->phba->brd_no, val);
+		vport->cfg_restrict_login = 1;
+		return -EINVAL;
+	}
+	if (vport->port_type == LPFC_PHYSICAL_PORT) {
+		vport->cfg_restrict_login = 0;
+		return 0;
+	}
+	vport->cfg_restrict_login = val;
+	return 0;
+}
+
+static int
+lpfc_restrict_login_set(struct lpfc_vport *vport, int val)
+{
+	if (val < 0 || val > 1) {
+		lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
+				"%d:0450 lpfc_restrict_login attribute cannot "
+				"be set to %d, allowed range is [0, 1]\n",
+				vport->phba->brd_no, val);
+		vport->cfg_restrict_login = 1;
+		return -EINVAL;
+	}
+	if (vport->port_type == LPFC_PHYSICAL_PORT && val != 0) {
+		lpfc_printf_log(vport->phba, KERN_ERR, LOG_INIT,
+				"%d:0468 lpfc_restrict_login must be 0 for "
+				"Physical ports.\n",
+				vport->phba->brd_no);
+		vport->cfg_restrict_login = 0;
+		return 0;
+	}
+	vport->cfg_restrict_login = val;
+	return 0;
+}
+lpfc_vport_param_store(restrict_login);
+static CLASS_DEVICE_ATTR(lpfc_restrict_login, S_IRUGO | S_IWUSR,
+			 lpfc_restrict_login_show, lpfc_restrict_login_store);
 
 /*
 # Some disk devices have a "select ID" or "select Target" capability.
@@ -1228,8 +1384,8 @@ LPFC_ATTR_RW(vport_restrict_login, 1, 0,
 # and will not work across a fabric. Also this parameter will take
 # effect only in the case when ALPA map is not available.)
 */
-LPFC_ATTR_R(scan_down, 1, 0, 1,
-	     "Start scanning for devices from highest ALPA to lowest");
+LPFC_VPORT_ATTR_R(scan_down, 1, 0, 1,
+		  "Start scanning for devices from highest ALPA to lowest");
 
 /*
 # lpfc_topology:  link topology for init link
@@ -1260,15 +1416,15 @@ LPFC_ATTR_R(link_speed, 0, 0, 8, "Select
 # lpfc_fcp_class:  Determines FC class to use for the FCP protocol.
 # Value range is [2,3]. Default value is 3.
 */
-LPFC_ATTR_R(fcp_class, 3, 2, 3,
-	     "Select Fibre Channel class of service for FCP sequences");
+LPFC_VPORT_ATTR_R(fcp_class, 3, 2, 3,
+		  "Select Fibre Channel class of service for FCP sequences");
 
 /*
 # lpfc_use_adisc: Use ADISC for FCP rediscovery instead of PLOGI. Value range
 # is [0,1]. Default value is 0.
 */
-LPFC_ATTR_RW(use_adisc, 0, 0, 1,
-	     "Use ADISC on rediscovery to authenticate FCP devices");
+LPFC_VPORT_ATTR_RW(use_adisc, 0, 0, 1,
+		   "Use ADISC on rediscovery to authenticate FCP devices");
 
 /*
 # lpfc_ack0: Use ACK0, instead of ACK1 for class 2 acknowledgement. Value
@@ -1320,13 +1476,13 @@ LPFC_ATTR_R(multi_ring_type, FC_LLC_SNAP
 #       2 = support FDMI with attribute of hostname
 # Value range [0,2]. Default value is 0.
 */
-LPFC_ATTR_RW(fdmi_on, 0, 0, 2, "Enable FDMI support");
+LPFC_VPORT_ATTR_RW(fdmi_on, 0, 0, 2, "Enable FDMI support");
 
 /*
 # Specifies the maximum number of ELS cmds we can have outstanding (for
 # discovery). Value range is [1,64]. Default value = 32.
 */
-LPFC_ATTR(discovery_threads, 32, 1, 64, "Maximum number of ELS commands "
+LPFC_VPORT_ATTR(discovery_threads, 32, 1, 64, "Maximum number of ELS commands "
 		 "during discovery");
 
 /*
@@ -1334,8 +1490,7 @@ LPFC_ATTR(discovery_threads, 32, 1, 64, 
 # Value range is [0,65535]. Default value is 255.
 # NOTE: The SCSI layer might probe all allowed LUN on some old targets.
 */
-LPFC_ATTR_R(max_luns, 255, 0, 65535,
-	     "Maximum allowed LUN");
+LPFC_VPORT_ATTR_R(max_luns, 255, 0, 65535, "Maximum allowed LUN");
 
 /*
 # lpfc_poll_tmo: .Milliseconds driver will wait between polling FCP ring.
@@ -1372,7 +1527,6 @@ struct class_device_attribute *lpfc_hba_
 	&class_device_attr_lpfc_lun_queue_depth,
 	&class_device_attr_lpfc_hba_queue_depth,
 	&class_device_attr_lpfc_peer_port_login,
-	&class_device_attr_lpfc_vport_restrict_login,
 	&class_device_attr_lpfc_nodev_tmo,
 	&class_device_attr_lpfc_devloss_tmo,
 	&class_device_attr_lpfc_fcp_class,
@@ -1409,6 +1563,29 @@ struct class_device_attribute *lpfc_hba_
 	NULL,
 };
 
+struct class_device_attribute *lpfc_vport_attrs[] = {
+	&class_device_attr_info,
+	&class_device_attr_state,
+	&class_device_attr_num_discovered_ports,
+	&class_device_attr_lpfc_drvr_version,
+
+	&class_device_attr_lpfc_log_verbose,
+	&class_device_attr_lpfc_lun_queue_depth,
+	&class_device_attr_lpfc_nodev_tmo,
+	&class_device_attr_lpfc_devloss_tmo,
+	&class_device_attr_lpfc_hba_queue_depth,
+	&class_device_attr_lpfc_peer_port_login,
+	&class_device_attr_lpfc_restrict_login,
+	&class_device_attr_lpfc_fcp_class,
+	&class_device_attr_lpfc_use_adisc,
+	&class_device_attr_lpfc_fdmi_on,
+	&class_device_attr_lpfc_max_luns,
+	&class_device_attr_nport_evt_cnt,
+	&class_device_attr_management_version,
+	&class_device_attr_npiv_info,
+	NULL,
+};
+
 static ssize_t
 sysfs_ctlreg_write(struct kobject *kobj, struct bin_attribute *bin_attr,
 		   char *buf, loff_t off, size_t count)
@@ -2264,33 +2441,20 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_multi_ring_support_init(phba, lpfc_multi_ring_support);
 	lpfc_multi_ring_rctl_init(phba, lpfc_multi_ring_rctl);
 	lpfc_multi_ring_type_init(phba, lpfc_multi_ring_type);
-	lpfc_lun_queue_depth_init(phba, lpfc_lun_queue_depth);
-	lpfc_fcp_class_init(phba, lpfc_fcp_class);
-	lpfc_use_adisc_init(phba, lpfc_use_adisc);
 	lpfc_ack0_init(phba, lpfc_ack0);
 	lpfc_topology_init(phba, lpfc_topology);
-	lpfc_scan_down_init(phba, lpfc_scan_down);
 	lpfc_link_speed_init(phba, lpfc_link_speed);
-	lpfc_fdmi_on_init(phba, lpfc_fdmi_on);
-	lpfc_discovery_threads_init(phba, lpfc_discovery_threads);
-	lpfc_max_luns_init(phba, lpfc_max_luns);
 	lpfc_poll_tmo_init(phba, lpfc_poll_tmo);
-	lpfc_peer_port_login_init(phba, lpfc_peer_port_login);
 	lpfc_npiv_enable_init(phba, lpfc_npiv_enable);
-	lpfc_vport_restrict_login_init(phba, lpfc_vport_restrict_login);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
-	lpfc_devloss_tmo_init(phba, lpfc_devloss_tmo);
-	lpfc_nodev_tmo_init(phba, lpfc_nodev_tmo);
 	phba->cfg_poll = lpfc_poll;
 	phba->cfg_soft_wwnn = 0L;
 	phba->cfg_soft_wwpn = 0L;
-
 	/*
 	 * The total number of segments is the configuration value plus 2
 	 * since the IOCB need a command and response bde.
 	 */
 	phba->cfg_sg_seg_cnt = LPFC_SG_SEG_CNT + 2;
-
 	/*
 	 * Since the sg_tablesize is module parameter, the sg_dma_buf_size
 	 * used to create the sg_dma_buf_pool must be dynamically calculated
@@ -2298,9 +2462,23 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd) +
 			sizeof(struct fcp_rsp) +
 			(phba->cfg_sg_seg_cnt * sizeof(struct ulp_bde64));
-
-
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
+	return;
+}
 
+void
+lpfc_get_vport_cfgparam(struct lpfc_vport *vport)
+{
+	lpfc_lun_queue_depth_init(vport, lpfc_lun_queue_depth);
+	lpfc_devloss_tmo_init(vport, lpfc_devloss_tmo);
+	lpfc_nodev_tmo_init(vport, lpfc_nodev_tmo);
+	lpfc_peer_port_login_init(vport, lpfc_peer_port_login);
+	lpfc_restrict_login_init(vport, lpfc_restrict_login);
+	lpfc_fcp_class_init(vport, lpfc_fcp_class);
+	lpfc_use_adisc_init(vport, lpfc_use_adisc);
+	lpfc_fdmi_on_init(vport, lpfc_fdmi_on);
+	lpfc_discovery_threads_init(vport, lpfc_discovery_threads);
+	lpfc_max_luns_init(vport, lpfc_max_luns);
+	lpfc_scan_down_init(vport, lpfc_scan_down);
 	return;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2007-08-02 09:26:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2007-08-02 09:27:04.000000000 -0400
@@ -250,10 +250,13 @@ const char* lpfc_info(struct Scsi_Host *
 int lpfc_scan_finished(struct Scsi_Host *, unsigned long);
 
 void lpfc_get_cfgparam(struct lpfc_hba *);
+void lpfc_get_vport_cfgparam(struct lpfc_vport *);
 int lpfc_alloc_sysfs_attr(struct lpfc_vport *);
 void lpfc_free_sysfs_attr(struct lpfc_vport *);
 extern struct class_device_attribute *lpfc_hba_attrs[];
+extern struct class_device_attribute *lpfc_vport_attrs[];
 extern struct scsi_host_template lpfc_template;
+extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
 extern int lpfc_sli_mode;
@@ -262,7 +265,7 @@ int  lpfc_vport_symbolic_node_name(struc
 void lpfc_terminate_rport_io(struct fc_rport *);
 void lpfc_dev_loss_tmo_callbk(struct fc_rport *rport);
 
-struct lpfc_vport *lpfc_create_port(struct lpfc_hba *, int, struct fc_vport *);
+struct lpfc_vport *lpfc_create_port(struct lpfc_hba *, int, struct device *);
 int  lpfc_vport_disable(struct fc_vport *fc_vport, bool disable);
 void lpfc_mbx_unreg_vpi(struct lpfc_vport *);
 void destroy_port(struct lpfc_vport *);
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 09:26:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2007-08-02 09:27:04.000000000 -0400
@@ -451,10 +451,10 @@ lpfc_ns_rsp(struct lpfc_vport *vport, st
 			 */
 			if ((Did != vport->fc_myDID) &&
 			    ((lpfc_find_vport_by_did(phba, Did) == NULL) ||
-			     phba->cfg_peer_port_login)) {
+			     vport->cfg_peer_port_login)) {
 				if ((vport->port_type != LPFC_NPIV_PORT) ||
 				    (vport->fc_flag & FC_RFF_NOT_SUPPORTED) ||
-				    (!phba->cfg_vport_restrict_login)) {
+				    (!vport->cfg_restrict_login)) {
 					ndlp = lpfc_setup_disc_node(vport, Did);
 					if (ndlp) {
 						lpfc_debugfs_disc_trc(vport,
@@ -1471,7 +1471,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, 
 			pab->ab.EntryCnt++;
 			size += FOURBYTES + len;
 
-			if (phba->cfg_fdmi_on == 2) {
+			if (vport->cfg_fdmi_on == 2) {
 				/* #6 Port attribute entry */
 				ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) pab +
 							  size);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-08-02 09:26:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-08-02 09:27:04.000000000 -0400
@@ -518,7 +518,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		 * alpa map would take too long otherwise.
 		 */
 		if (phba->alpa_map[0] == 0) {
-			phba->cfg_discovery_threads = LPFC_MAX_DISC_THREADS;
+			vport->cfg_discovery_threads = LPFC_MAX_DISC_THREADS;
 		}
 
 		/* FLOGI failure */
@@ -2640,7 +2640,7 @@ lpfc_els_disc_adisc(struct lpfc_vport *v
 			sentadisc++;
 			vport->num_disc_nodes++;
 			if (vport->num_disc_nodes >=
-			    vport->phba->cfg_discovery_threads) {
+			    vport->cfg_discovery_threads) {
 				spin_lock_irq(shost->host_lock);
 				vport->fc_flag |= FC_NLP_MORE;
 				spin_unlock_irq(shost->host_lock);
@@ -2675,7 +2675,7 @@ lpfc_els_disc_plogi(struct lpfc_vport *v
 			sentplogi++;
 			vport->num_disc_nodes++;
 			if (vport->num_disc_nodes >=
-			    vport->phba->cfg_discovery_threads) {
+			    vport->cfg_discovery_threads) {
 				spin_lock_irq(shost->host_lock);
 				vport->fc_flag |= FC_NLP_MORE;
 				spin_unlock_irq(shost->host_lock);
@@ -2841,7 +2841,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vpo
 	 * just ACC and ignore it.
 	 */
 	if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
-		!(phba->cfg_peer_port_login)) {
+		!(vport->cfg_peer_port_login)) {
 		i = payload_len;
 		datap = lp;
 		while (i > 0) {
@@ -4170,7 +4170,7 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *ph
 		return;
 	}
 
-	if (phba->cfg_fdmi_on) {
+	if (vport->cfg_fdmi_on) {
 		ndlp_fdmi = mempool_alloc(phba->nlp_mem_pool,
 					  GFP_KERNEL);
 		if (ndlp_fdmi) {
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-08-02 09:26:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-08-02 09:27:04.000000000 -0400
@@ -338,6 +338,20 @@ struct lpfc_vport {
 	struct lpfc_debugfs_trc *disc_trc;
 	atomic_t disc_trc_cnt;
 #endif
+	/* Vport Config Parameters */
+	uint32_t cfg_scan_down;
+	uint32_t cfg_lun_queue_depth;
+	uint32_t cfg_nodev_tmo;
+	uint32_t cfg_devloss_tmo;
+	uint32_t cfg_restrict_login;
+	uint32_t cfg_peer_port_login;
+	uint32_t cfg_fcp_class;
+	uint32_t cfg_use_adisc;
+	uint32_t cfg_fdmi_on;
+	uint32_t cfg_discovery_threads;
+	uint32_t cfg_max_luns;
+
+	uint32_t dev_loss_tmo_changed;
 };
 
 struct hbq_s {
@@ -413,28 +427,16 @@ struct lpfc_hba {
 	uint8_t  wwpn[8];
 	uint32_t RandomData[7];
 
-	uint32_t cfg_log_verbose;
-	uint32_t cfg_lun_queue_depth;
-	uint32_t cfg_nodev_tmo;
-	uint32_t cfg_devloss_tmo;
-	uint32_t cfg_hba_queue_depth;
-	uint32_t cfg_peer_port_login;
-	uint32_t cfg_vport_restrict_login;
-	uint32_t cfg_npiv_enable;
-	uint32_t cfg_fcp_class;
-	uint32_t cfg_use_adisc;
+	/* HBA Config Parameters */
 	uint32_t cfg_ack0;
+	uint32_t cfg_npiv_enable;
 	uint32_t cfg_topology;
-	uint32_t cfg_scan_down;
 	uint32_t cfg_link_speed;
 	uint32_t cfg_cr_delay;
 	uint32_t cfg_cr_count;
 	uint32_t cfg_multi_ring_support;
 	uint32_t cfg_multi_ring_rctl;
 	uint32_t cfg_multi_ring_type;
-	uint32_t cfg_fdmi_on;
-	uint32_t cfg_discovery_threads;
-	uint32_t cfg_max_luns;
 	uint32_t cfg_poll;
 	uint32_t cfg_poll_tmo;
 	uint32_t cfg_use_msi;
@@ -442,8 +444,10 @@ struct lpfc_hba {
 	uint32_t cfg_sg_dma_buf_size;
 	uint64_t cfg_soft_wwnn;
 	uint64_t cfg_soft_wwpn;
+	uint32_t cfg_hba_queue_depth;
 
-	uint32_t dev_loss_tmo_changed;
+	/* Config paramters that should be in the vport */
+	uint32_t cfg_log_verbose;
 
 	lpfc_vpd_t vpd;		/* vital product data */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 09:26:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-08-02 09:27:04.000000000 -0400
@@ -2200,7 +2200,7 @@ lpfc_disc_list_loopmap(struct lpfc_vport
 			/* If cfg_scan_down is set, start from highest
 			 * ALPA (0xef) to lowest (0x1).
 			 */
-			if (phba->cfg_scan_down)
+			if (vport->cfg_scan_down)
 				index = j;
 			else
 				index = FC_MAXLOOP - j - 1;
@@ -2749,7 +2749,7 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 	 * fdmi-on=2 (supporting RPA/hostnmae)
 	 */
 
-	if (phba->cfg_fdmi_on == 1)
+	if (vport->cfg_fdmi_on == 1)
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA);
 	else
 		mod_timer(&vport->fc_fdmitmo, jiffies + HZ * 60);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-08-02 09:26:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-08-02 09:27:04.000000000 -0400
@@ -1524,13 +1524,18 @@ lpfc_scsi_free(struct lpfc_hba *phba)
 }
 
 struct lpfc_vport *
-lpfc_create_port(struct lpfc_hba *phba, int instance, struct fc_vport *fc_vport)
+lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 {
 	struct lpfc_vport *vport;
 	struct Scsi_Host  *shost;
 	int error = 0;
 
-	shost = scsi_host_alloc(&lpfc_template, sizeof(struct lpfc_vport));
+	if (dev != &phba->pcidev->dev)
+		shost = scsi_host_alloc(&lpfc_vport_template,
+					sizeof(struct lpfc_vport));
+	else
+		shost = scsi_host_alloc(&lpfc_template,
+					sizeof(struct lpfc_vport));
 	if (!shost)
 		goto out;
 
@@ -1540,9 +1545,10 @@ lpfc_create_port(struct lpfc_hba *phba, 
 	vport->load_flag |= FC_LOADING;
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 
+	lpfc_get_vport_cfgparam(vport);
 	shost->unique_id = instance;
 	shost->max_id = LPFC_MAX_TARGET;
-	shost->max_lun = phba->cfg_max_luns;
+	shost->max_lun = vport->cfg_max_luns;
 	shost->this_id = -1;
 	shost->max_cmd_len = 16;
 	/*
@@ -1551,7 +1557,7 @@ lpfc_create_port(struct lpfc_hba *phba, 
 	 * max xri value determined in hba setup.
 	 */
 	shost->can_queue = phba->cfg_hba_queue_depth - 10;
-	if (fc_vport != NULL) {
+	if (dev != &phba->pcidev->dev) {
 		shost->transportt = lpfc_vport_transport_template;
 		vport->port_type = LPFC_NPIV_PORT;
 	} else {
@@ -1575,11 +1581,7 @@ lpfc_create_port(struct lpfc_hba *phba, 
 	vport->els_tmofunc.function = lpfc_els_timeout;
 	vport->els_tmofunc.data = (unsigned long)vport;
 
-	if (fc_vport != NULL) {
-		error = scsi_add_host(shost, &fc_vport->dev);
-	} else {
-		error = scsi_add_host(shost, &phba->pcidev->dev);
-	}
+	error = scsi_add_host(shost, dev);
 	if (error)
 		goto out_put_shost;
 
@@ -1896,7 +1898,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	/* Initialize list of fabric iocbs */
 	INIT_LIST_HEAD(&phba->fabric_iocb_list);
 
-	vport = lpfc_create_port(phba, phba->brd_no, NULL);
+	vport = lpfc_create_port(phba, phba->brd_no, &phba->pcidev->dev);
 	if (!vport)
 		goto out_kthread_stop;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-07-20 13:38:28.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2007-08-02 09:27:04.000000000 -0400
@@ -304,7 +304,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 			ndlp->nlp_DID, ndlp->nlp_state, ndlp->nlp_flag,
 			ndlp->nlp_rpi);
 
-	if (phba->cfg_fcp_class == 2 && sp->cls2.classValid)
+	if (vport->cfg_fcp_class == 2 && sp->cls2.classValid)
 		ndlp->nlp_fcp_info |= CLASS2;
 	else
 		ndlp->nlp_fcp_info |= CLASS3;
@@ -392,7 +392,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport,
 	}
 
 	if ((vport->port_type == LPFC_NPIV_PORT &&
-	      phba->cfg_vport_restrict_login)) {
+	     vport->cfg_restrict_login)) {
 
 		/* In order to preserve RPIs, we want to cleanup
 		 * the default RPI the firmware created to rcv
@@ -564,10 +564,9 @@ static uint32_t
 lpfc_disc_set_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_hba  *phba = vport->phba;
 
 	/* Check config parameter use-adisc or FCP-2 */
-	if ((phba->cfg_use_adisc && (vport->fc_flag & FC_RSCN_MODE)) ||
+	if ((vport->cfg_use_adisc && (vport->fc_flag & FC_RSCN_MODE)) ||
 	    ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) {
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_NPR_ADISC;
@@ -787,7 +786,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 			ndlp->nlp_DID, ndlp->nlp_state,
 			ndlp->nlp_flag, ndlp->nlp_rpi);
 
-	if (phba->cfg_fcp_class == 2 && (sp->cls2.classValid))
+	if (vport->cfg_fcp_class == 2 && (sp->cls2.classValid))
 		ndlp->nlp_fcp_info |= CLASS2;
 	else
 		ndlp->nlp_fcp_info |= CLASS3;
@@ -1358,7 +1357,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vp
 	irsp = &rspiocb->iocb;
 	if (irsp->ulpStatus) {
 		if ((vport->port_type == LPFC_NPIV_PORT) &&
-			phba->cfg_vport_restrict_login) {
+		    vport->cfg_restrict_login) {
 			goto out;
 		}
 		ndlp->nlp_prev_state = NLP_STE_PRLI_ISSUE;
@@ -1380,7 +1379,7 @@ lpfc_cmpl_prli_prli_issue(struct lpfc_vp
 	}
 	if (!(ndlp->nlp_type & NLP_FCP_TARGET) &&
 	    (vport->port_type == LPFC_NPIV_PORT) &&
-	     phba->cfg_vport_restrict_login) {
+	     vport->cfg_restrict_login) {
 out:
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag |= NLP_TARGET_REMOVE;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2007-08-02 09:26:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2007-08-02 09:27:04.000000000 -0400
@@ -84,22 +84,21 @@ lpfc_adjust_queue_depth(struct lpfc_hba 
  * SCSI command completion.
  */
 static inline void
-lpfc_rampup_queue_depth(struct lpfc_hba *phba,
+lpfc_rampup_queue_depth(struct lpfc_vport  *vport,
 			struct scsi_device *sdev)
 {
 	unsigned long flags;
+	struct lpfc_hba *phba = vport->phba;
 	atomic_inc(&phba->num_cmd_success);
 
-	if (phba->cfg_lun_queue_depth <= sdev->queue_depth)
+	if (vport->cfg_lun_queue_depth <= sdev->queue_depth)
 		return;
-
 	spin_lock_irqsave(&phba->hbalock, flags);
 	if (((phba->last_ramp_up_time + QUEUE_RAMP_UP_INTERVAL) > jiffies) ||
 	 ((phba->last_rsrc_error_time + QUEUE_RAMP_UP_INTERVAL ) > jiffies)) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return;
 	}
-
 	phba->last_ramp_up_time = jiffies;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
@@ -627,16 +626,16 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 

 	if (!result)
-		lpfc_rampup_queue_depth(phba, sdev);
+		lpfc_rampup_queue_depth(vport, sdev);
 
 	if (!result && pnode != NULL &&
 	   ((jiffies - pnode->last_ramp_up_time) >
 		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
 	   ((jiffies - pnode->last_q_full_time) >
 		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
-	   (phba->cfg_lun_queue_depth > sdev->queue_depth)) {
+	   (vport->cfg_lun_queue_depth > sdev->queue_depth)) {
 		shost_for_each_device(tmp_sdev, sdev->host) {
-			if (phba->cfg_lun_queue_depth > tmp_sdev->queue_depth) {
+			if (vport->cfg_lun_queue_depth > tmp_sdev->queue_depth){
 				if (tmp_sdev->id != sdev->id)
 					continue;
 				if (tmp_sdev->ordered_tags)
@@ -1099,7 +1098,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 
 		schedule_timeout_uninterruptible(LPFC_ABORT_WAIT * HZ);
 		if (++loop_count
-		    > (2 * phba->cfg_devloss_tmo)/LPFC_ABORT_WAIT)
+		    > (2 * vport->cfg_devloss_tmo)/LPFC_ABORT_WAIT)
 			break;
 	}
 
@@ -1154,7 +1153,7 @@ lpfc_device_reset_handler(struct scsi_cm
 			loopcnt++;
 			rdata = cmnd->device->hostdata;
 			if (!rdata ||
-				(loopcnt > ((phba->cfg_devloss_tmo * 2) + 1))) {
+				(loopcnt > ((vport->cfg_devloss_tmo * 2) + 1))){
 				lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 						"%d (%d):0721 LUN Reset rport "
 						"failure: cnt x%x rdata x%p\n",
@@ -1230,7 +1229,7 @@ lpfc_device_reset_handler(struct scsi_cm
 		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
 
 		if (++loopcnt
-		    > (2 * phba->cfg_devloss_tmo)/LPFC_RESET_WAIT)
+		    > (2 * vport->cfg_devloss_tmo)/LPFC_RESET_WAIT)
 			break;
 
 		cnt = lpfc_sli_sum_iocb(phba,
@@ -1339,7 +1338,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 		schedule_timeout_uninterruptible(LPFC_RESET_WAIT*HZ);
 
 		if (++loopcnt
-		    > (2 * phba->cfg_devloss_tmo)/LPFC_RESET_WAIT)
+		    > (2 * vport->cfg_devloss_tmo)/LPFC_RESET_WAIT)
 			break;
 
 		cnt = lpfc_sli_sum_iocb(phba,
@@ -1386,7 +1385,7 @@ lpfc_slave_alloc(struct scsi_device *sde
 	 * extra.  This list of scsi bufs exists for the lifetime of the driver.
 	 */
 	total = phba->total_scsi_bufs;
-	num_to_alloc = phba->cfg_lun_queue_depth + 2;
+	num_to_alloc = vport->cfg_lun_queue_depth + 2;
 
 	/* Allow some exchanges to be available always to complete discovery */
 	if (total >= phba->cfg_hba_queue_depth - LPFC_DISC_IOCB_BUFF_COUNT ) {
@@ -1435,9 +1434,9 @@ lpfc_slave_configure(struct scsi_device 
 	struct fc_rport   *rport = starget_to_rport(sdev->sdev_target);
 
 	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, phba->cfg_lun_queue_depth);
+		scsi_activate_tcq(sdev, vport->cfg_lun_queue_depth);
 	else
-		scsi_deactivate_tcq(sdev, phba->cfg_lun_queue_depth);
+		scsi_deactivate_tcq(sdev, vport->cfg_lun_queue_depth);
 
 	/*
 	 * Initialize the fc transport attributes for the target
@@ -1445,7 +1444,7 @@ lpfc_slave_configure(struct scsi_device 
 	 * target pointer is stored in the starget_data for the
 	 * driver's sysfs entry point functions.
 	 */
-	rport->dev_loss_tmo = phba->cfg_devloss_tmo;
+	rport->dev_loss_tmo = vport->cfg_devloss_tmo;
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
 		lpfc_sli_poll_fcp_ring(phba);
@@ -1483,3 +1482,23 @@ struct scsi_host_template lpfc_template 
 	.shost_attrs		= lpfc_hba_attrs,
 	.max_sectors		= 0xFFFF,
 };
+
+struct scsi_host_template lpfc_vport_template = {
+	.module			= THIS_MODULE,
+	.name			= LPFC_DRIVER_NAME,
+	.info			= lpfc_info,
+	.queuecommand		= lpfc_queuecommand,
+	.eh_abort_handler	= lpfc_abort_handler,
+	.eh_device_reset_handler= lpfc_device_reset_handler,
+	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.slave_alloc		= lpfc_slave_alloc,
+	.slave_configure	= lpfc_slave_configure,
+	.slave_destroy		= lpfc_slave_destroy,
+	.scan_finished		= lpfc_scan_finished,
+	.this_id		= -1,
+	.sg_tablesize		= LPFC_SG_SEG_CNT,
+	.cmd_per_lun		= LPFC_CMD_PER_LUN,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.shost_attrs		= lpfc_vport_attrs,
+	.max_sectors		= 0xFFFF,
+};
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 09:26:46.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2007-08-02 09:27:04.000000000 -0400
@@ -198,8 +198,8 @@ int
 lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 {
 	struct lpfc_nodelist *ndlp;
-	struct lpfc_vport *pport =
-		(struct lpfc_vport *) fc_vport->shost->hostdata;
+	struct Scsi_Host *shost = fc_vport->shost;
+	struct lpfc_vport *pport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = pport->phba;
 	struct lpfc_vport *vport = NULL;
 	int instance;
@@ -237,7 +237,7 @@ lpfc_vport_create(struct fc_vport *fc_vp
 		goto error_out;
 	}
 
-	vport = lpfc_create_port(phba, instance, fc_vport);
+	vport = lpfc_create_port(phba, instance, &fc_vport->dev);
 	if (!vport) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
 				"%d:1811 Create VPORT failed: vpi x%x\n",


