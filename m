From: Martin Hicks <mort@wildopensource.com>
Subject: [PATCH] Add FC transport attributes support to qla2xxx
Date: Mon, 22 Mar 2004 13:40:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040322184005.GT19428@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Pk6IbRAofICFmK5e"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:38850 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S262220AbUCVSkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2004 13:40:07 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


Hi Andrew,

Here is a patch that adds FC transport attributes to the qla2xxx driver.
The patch should apply cleanly to a recent 2.6 kernel with the FC
attributes update that I just sent to linux-scsi.

There are two patches.  The first one contains the driver changes and
the second one contains a Kconfig update.

thanks
mh

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qla2xxx-trans-attrs.patch"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1814  -> 1.1815 
#	drivers/scsi/qla2xxx/qla_os.h	1.2     -> 1.3    
#	drivers/scsi/qla2xxx/qla_os.c	1.6     -> 1.7    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/03/22	mort@tomahawk.engr.sgi.com	1.1815
# Update qla2xxx to export a few attributes to sysfs using
# the Transport attributes API
# --------------------------------------------
#
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	Mon Mar 22 09:13:23 2004
+++ b/drivers/scsi/qla2xxx/qla_os.c	Mon Mar 22 09:13:23 2004
@@ -175,6 +175,8 @@
 	.max_sectors		= 0xFFFF,
 };
 
+static struct scsi_transport_template *qla2xxx_transport_template = NULL;
+
 static void qla2x00_display_fc_names(scsi_qla_host_t *);
 
 void qla2x00_blink_led(scsi_qla_host_t *);
@@ -1766,7 +1768,7 @@
 }
 
 /**************************************************************************
-* qla2x00_slave_configure
+* qla2xxx_slave_configure
 *
 * Description:
 **************************************************************************/
@@ -2061,6 +2063,8 @@
 	host->max_cmd_len = MAX_CMDSZ;
 	host->max_channel = ha->ports - 1;
 	host->max_lun = ha->max_luns;
+	BUG_ON(qla2xxx_transport_template == NULL);
+	host->transportt = qla2xxx_transport_template;
 	host->unique_id = ha->instance;
 	host->max_id = ha->max_targets;
 
@@ -4448,6 +4452,64 @@
 	return -ETIMEDOUT;
 }
 
+static void
+qla2xxx_get_port_id(struct scsi_device *sdev)
+{
+	scsi_qla_host_t *ha = to_qla_host(sdev->host);
+	struct fc_port *fc;
+
+	list_for_each_entry(fc, &ha->fcports, list) {
+		if (fc->os_target_id == sdev->id) {
+			fc_port_id(sdev) = fc->d_id.b.domain << 16 |
+				fc->d_id.b.area << 8 | 
+				fc->d_id.b.al_pa;
+			return;
+		}
+	}
+	fc_port_id(sdev) = -1;
+}
+
+static void
+qla2xxx_get_port_name(struct scsi_device *sdev)
+{
+	scsi_qla_host_t *ha = to_qla_host(sdev->host);
+	struct fc_port *fc;
+
+	list_for_each_entry(fc, &ha->fcports, list) {
+		if (fc->os_target_id == sdev->id) {
+			fc_port_name(sdev) =
+				__be64_to_cpu(*(uint64_t *)fc->port_name);
+			return;
+		}
+	}
+	fc_port_name(sdev) = -1;
+}
+
+static void
+qla2xxx_get_node_name(struct scsi_device *sdev)
+{
+	scsi_qla_host_t *ha = to_qla_host(sdev->host);
+	struct fc_port *fc;
+
+	list_for_each_entry(fc, &ha->fcports, list) {
+		if (fc->os_target_id == sdev->id) {
+			fc_node_name(sdev) =
+				__be64_to_cpu(*(uint64_t *)fc->node_name);
+			return;
+		}
+	}
+	fc_node_name(sdev) = -1;
+}
+
+static struct fc_function_template qla2xxx_transport_functions = {
+	.get_port_id = qla2xxx_get_port_id,
+	.show_port_id = 1,
+	.get_port_name = qla2xxx_get_port_name,
+	.show_port_name = 1,
+	.get_node_name = qla2xxx_get_node_name,
+	.show_node_name = 1,
+};
+
 /**
  * qla2x00_module_init - Module initialization.
  **/
@@ -4470,6 +4532,10 @@
 		return -ENOMEM;
 	}
 
+	qla2xxx_transport_template = fc_attach_transport(&qla2xxx_transport_functions);
+	if (!qla2xxx_transport_template)
+		return -ENODEV;
+
 	printk(KERN_INFO
 	    "QLogic Fibre Channel HBA Driver (%p)\n", qla2x00_set_info);
 
@@ -4491,6 +4557,8 @@
 		}
 		srb_cachep = NULL;
 	}
+
+	fc_release_transport(qla2xxx_transport_template);
 }
 
 module_init(qla2x00_module_init);
diff -Nru a/drivers/scsi/qla2xxx/qla_os.h b/drivers/scsi/qla2xxx/qla_os.h
--- a/drivers/scsi/qla2xxx/qla_os.h	Mon Mar 22 09:13:23 2004
+++ b/drivers/scsi/qla2xxx/qla_os.h	Mon Mar 22 09:13:23 2004
@@ -45,6 +45,7 @@
 #include <linux/bio.h>
 #include <linux/moduleparam.h>
 #include <linux/capability.h>
+#include <linux/list.h>
 
 #include <asm/system.h>
 
@@ -62,6 +63,8 @@
 
 #include <scsi/scsicam.h>
 #include <scsi/scsi_ioctl.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_fc.h>
 
 //TODO Fix this!!!
 /*

--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qla2xxx-trans-attrs-Kconfig.patch"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1832  -> 1.1833 
#	drivers/scsi/qla2xxx/Kconfig	1.5     -> 1.6    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/03/22	mort@tomahawk.engr.sgi.com	1.1833
# Make all qla2xxx drivers require FC transport attributes
# --------------------------------------------
#
diff -Nru a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/Kconfig
--- a/drivers/scsi/qla2xxx/Kconfig	Mon Mar 22 10:29:07 2004
+++ b/drivers/scsi/qla2xxx/Kconfig	Mon Mar 22 10:29:07 2004
@@ -6,18 +6,21 @@
 config SCSI_QLA21XX
 	tristate "QLogic ISP2100 host adapter family support"
 	depends on SCSI_QLA2XXX
+        select SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 21xx (ISP2100) host adapter family.
 
 config SCSI_QLA22XX
 	tristate "QLogic ISP2200 host adapter family support"
 	depends on SCSI_QLA2XXX
+        select SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 22xx (ISP2200) host adapter family.
 
 config SCSI_QLA2300
 	tristate "QLogic ISP2300 host adapter family support"
 	depends on SCSI_QLA2XXX
+        select SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 2300 (ISP2300, and ISP2312) host
 	adapter family.
@@ -25,17 +28,20 @@
 config SCSI_QLA2322
 	tristate "QLogic ISP2322 host adapter family support"
 	depends on SCSI_QLA2XXX
+        select SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 2322 (ISP2322) host adapter family.
 
 config SCSI_QLA6312
 	tristate "QLogic ISP6312 host adapter family support"
 	depends on SCSI_QLA2XXX
+        select SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 6312 (ISP6312) host adapter family.
 
 config SCSI_QLA6322
 	tristate "QLogic ISP6322 host adapter family support"
 	depends on SCSI_QLA2XXX
+        select SCSI_FC_ATTRS
 	---help---
 	This driver supports the QLogic 6322 (ISP6322) host adapter family.

--Pk6IbRAofICFmK5e--
