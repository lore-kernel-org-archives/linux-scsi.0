From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] convert cisco driver to use transport class
Date: Fri, 26 Mar 2004 12:50:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4064979F.4000800@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080801090706090808070006"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50188 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261252AbUCZUur (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 15:50:47 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net

This is a multi-part message in MIME format.
--------------080801090706090808070006
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

And, here is the conversion patch.


  iscsi-attr.c      |  201 +++++++++++++++---------------------------------------
  iscsi-attr.h      |    2
  iscsi-initiator.c |   72 +++++++++++--------
  3 files changed, 97 insertions(+), 178 deletions(-)

Mike Christie

--------------080801090706090808070006
Content-Type: text/plain;
 name="cisco-cls.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cisco-cls.patch"

diff -aurp linux-2.6.5-rc2/drivers/scsi/iscsi-sfnet/iscsi-attr.c linux-2.6.5-rc2-iscsi/drivers/scsi/iscsi-sfnet/iscsi-attr.c
--- linux-2.6.5-rc2/drivers/scsi/iscsi-sfnet/iscsi-attr.c	2004-03-26 12:26:55.168007402 -0800
+++ linux-2.6.5-rc2-iscsi/drivers/scsi/iscsi-sfnet/iscsi-attr.c	2004-03-26 12:21:05.000000000 -0800
@@ -20,6 +20,10 @@
  */
 
 #include <linux/device.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_iscsi.h>
 
 #include "iscsi-protocol.h"
 #include "iscsi-session.h"
@@ -597,143 +601,6 @@ iscsi_change_disk_command_timeout(struct
 	}
 }
 
-static int
-add_lun_line_info(struct iscsi_session *session, int lun, char **buffer)
-{
-	DEBUG_FLOW("iSCSI: add_lun_line iscsi bus %d target id %d, %d \n",
-		session->iscsi_bus, session->target_id, lun);
-
-	/* 2 spaces + (4 * (3-digit field + space)) + 4 spaces = 22 chars */
-	if (lun >= 0)
-		*buffer += sprintf(*buffer, " %3.1u %3.1u %3.1u    ",
-			session->iscsi_bus, session->target_id, lun);
-	else
-		*buffer += sprintf(*buffer, " %3.1u %3.1u   ?    ",
-			session->iscsi_bus, session->target_id);
-
-	if (test_bit(SESSION_ESTABLISHED, &session->control_bits)) {
-		/* up to 15 char IP address + 2 spaces = 17 chars */
-		*buffer += sprintf(*buffer, "   %u.%u.%u.%u  ",
-			session->ip_address[0], session->ip_address[1],
-			session->ip_address[2], session->ip_address[3]);
-		/* right_justify(*buffer, 17); */
-
-		/* 5-digit port + 2 spaces = 7 chars */
-		*buffer += sprintf(*buffer, " %d  ", session->port);
-
-	} else {
-		/* fill in '?' for each empty field, so that
-		 * it is easier for processing by tools such as awk and perl.
-		 */
-		*buffer += sprintf(*buffer, "              ?      ?  ");
-
-	}
-	*buffer += sprintf(*buffer, "%s ", session->TargetName);
-	 /* and a newline */
-	*buffer += sprintf(*buffer, "\n");
-	return 1;
-}
-
-static int
-show_session_lun_info(struct iscsi_session *session, char **buffer)
-{
-	/* if we've already found LUNs, show them all */
-	int lfound = 0;
-	int l;
-
-	/* FIXME: IPv6 */
-	if (session->ip_length != 4)
-		return 1;
-
-	for (l = 0; l < ISCSI_MAX_LUN; l++) {
-		if (test_bit(l, session->luns_activated)) {
-			lfound += 1;
-			if (!add_lun_line_info(session, l, buffer)) {
-				DEBUG_FLOW("iSCSI: show session luns"
-					" returning 0 ");
-				return 0;
-			}
-		}
-	}
-
-	/* if we haven't found any LUNs, use ? for a LUN number */
-	if (!lfound) {
-		if (!add_lun_line_info(session, -1, buffer)) {
-			DEBUG_FLOW("iSCSI: show session luns returning 0 \n");
-			return 0;
-		}
-	} else {
-		DEBUG_FLOW("iSCSI: show session luns returning 1 ");
-	}
-	return 1;
-}
-
-static ssize_t
-iscsi_print_info(struct class_device *class_dev, char *buf)
-{
-	struct Scsi_Host *host = class_to_shost(class_dev);
-	struct iscsi_session *session;
-	unsigned long noqueue_flags_;
-	char *build_str = BUILD_STR;
-	char *bp;
-
-	bp = buf;
-
-	/* comment header with version number */
-	/* FIXME: we assume the buffer length is always large 
-	 * enough for our header 
-	 */
-	if (build_str) {
-		/* developer-built variant of a 4-digit internal 
-		 * release 
-		 */
-		bp +=
-		    sprintf(bp,
-			    "# iSCSI driver version: %d.%d.%d.%d%s "
-			    "variant (%s)\n#\n",
-			    DRIVER_MAJOR_VERSION, DRIVER_MINOR_VERSION,
-			    DRIVER_PATCH_VERSION,
-			    DRIVER_INTERNAL_VERSION,
-			    DRIVER_EXTRAVERSION, ISCSI_DATE);
-	} else if (DRIVER_INTERNAL_VERSION > 0) {
-		/* 4-digit release */
-		bp +=
-		    sprintf(bp,
-			    "# iSCSI driver version: %d.%d.%d.%d%s "
-			    "(%s)\n#\n",
-			    DRIVER_MAJOR_VERSION, DRIVER_MINOR_VERSION,
-			    DRIVER_PATCH_VERSION,
-			    DRIVER_INTERNAL_VERSION,
-			    DRIVER_EXTRAVERSION, ISCSI_DATE);
-	} else {
-		/* 3-digit release */
-		bp +=
-		    sprintf(bp,
-			    "# iSCSI driver version: %d.%d.%d%s "
-			    "(%s)\n#\n",
-			    DRIVER_MAJOR_VERSION, DRIVER_MINOR_VERSION,
-			    DRIVER_PATCH_VERSION, DRIVER_EXTRAVERSION,
-			    ISCSI_DATE);
-	}
-	bp += sprintf(bp, "# SCSI:               iSCSI:\n");
-	bp += sprintf(bp, "# Bus Tgt LUN         IP address   Port  "
-		    "TargetName\n");
-
-	if (iscsi_hba) {
-		spin_lock_irqsave(&iscsi_hba->session_lock, noqueue_flags_);
-		list_for_each_entry(session, &iscsi_hba->session_head,
-				    session_link) {
-			if (!show_session_lun_info(session, &bp))
-				break;
-		}
-		spin_unlock_irqrestore(&iscsi_hba->session_lock,
-					noqueue_flags_);
-	} else {
-		printk("iSCSI: couldn't find HBA %p\n", host);
-	}
-	return (bp - buf);
-}
-
 static ssize_t 
 iscsi_host_id(struct class_device *class_dev, char *buf)
 {
@@ -802,14 +669,6 @@ struct class_device_attribute shutdown =
 	.store = do_iscsi_shutdown,
 };
 
-struct class_device_attribute print_info = {
-	.attr = {
-		.name =		"print_info",
-		.mode =		S_IRUGO,
-	},
-	.show = iscsi_print_info,
-};
-
 struct class_device_attribute host_id = {
 	.attr = {
 		.name = "host_no",
@@ -825,3 +684,55 @@ struct class_device_attribute network_bo
 	},
 	.show = iscsi_network_boot,
 };
+
+static ssize_t iscsi_get_tgt_port(struct scsi_device *sdev, char *buf)
+{
+	struct iscsi_session *session;
+
+	if (!sdev->hostdata)
+		return 0;
+
+	session = ((struct iscsi_dev_data *)sdev->hostdata)->session;
+	if (!test_bit(SESSION_ESTABLISHED, &session->control_bits))
+		return 0;
+
+	return sprintf(buf, "%d\n", session->port);
+}
+
+static ssize_t iscsi_get_tgt_addr(struct scsi_device *sdev, char *buf)
+{
+	struct iscsi_session *session;
+
+	if (!sdev->hostdata)
+		return 0;
+
+	session = ((struct iscsi_dev_data *)sdev->hostdata)->session;
+	if (!test_bit(SESSION_ESTABLISHED, &session->control_bits))
+		return 0;
+
+	if (session->ip_length == 4)
+		return sprintf(buf, "%u.%u.%u.%u",
+			       NIPQUAD(session->ip_address));
+	else
+		return 0;
+}
+
+static ssize_t iscsi_get_tgt_name(struct scsi_device *sdev, char *buf)
+{
+	struct iscsi_session *session;
+
+	if (!sdev->hostdata)
+		return 0;
+
+	session = ((struct iscsi_dev_data *)sdev->hostdata)->session;
+	if (!test_bit(SESSION_ESTABLISHED, &session->control_bits))
+		return 0;
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", session->TargetName);
+}
+
+struct iscsi_function_template iscsi_transport_functions = {
+	.get_target_port = iscsi_get_tgt_port,
+	.get_target_addr = iscsi_get_tgt_addr,
+	.get_target_name = iscsi_get_tgt_name,
+};
diff -aurp linux-2.6.5-rc2/drivers/scsi/iscsi-sfnet/iscsi-attr.h linux-2.6.5-rc2-iscsi/drivers/scsi/iscsi-sfnet/iscsi-attr.h
--- linux-2.6.5-rc2/drivers/scsi/iscsi-sfnet/iscsi-attr.h	2004-03-26 12:26:55.168007402 -0800
+++ linux-2.6.5-rc2-iscsi/drivers/scsi/iscsi-sfnet/iscsi-attr.h	2004-03-26 12:21:08.000000000 -0800
@@ -67,7 +67,6 @@ extern struct class_device_attribute tar
 extern struct class_device_attribute log_status;
 extern struct class_device_attribute shutdown;
 extern struct class_device_attribute change_portal;
-extern struct class_device_attribute print_info;
 extern struct class_device_attribute host_id;
 extern struct class_device_attribute network_boot;
 extern struct class_device_attribute connfailtimeout;
@@ -77,7 +76,6 @@ struct class_device_attribute *iscsi_hos
 	&log_status,
 	&shutdown,
 	&change_portal,
-	&print_info,
 	&host_id,
 	&network_boot,
 	&connfailtimeout,
diff -aurp linux-2.6.5-rc2/drivers/scsi/iscsi-sfnet/iscsi-initiator.c linux-2.6.5-rc2-iscsi/drivers/scsi/iscsi-sfnet/iscsi-initiator.c
--- linux-2.6.5-rc2/drivers/scsi/iscsi-sfnet/iscsi-initiator.c	2004-03-26 12:26:55.197003735 -0800
+++ linux-2.6.5-rc2-iscsi/drivers/scsi/iscsi-sfnet/iscsi-initiator.c	2004-03-26 12:21:15.000000000 -0800
@@ -24,6 +24,10 @@
 #include <linux/blkdev.h>
 #include <net/sock.h>
 #include <linux/inet.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_iscsi.h>
 
 /* if non-zero, do a TCP Abort when a session drops, 
  * instead of (attempting) a graceful TCP Close 
@@ -123,6 +127,7 @@ static struct file_operations control_fo
 };
 
 struct iscsi_hba *iscsi_hba;
+extern struct iscsi_function_template iscsi_transport_functions;
 extern struct class_device_attribute *iscsi_host_attrs[];
 unsigned long init_module_complete;
 unsigned long iscsi_timer_running;
@@ -4034,11 +4039,8 @@ iscsi_init(void)
 	control_major = register_chrdev(0, control_name, &control_fops);
 	if (control_major < 0) {
 		printk("iSCSI: failed to register the control device\n");
-		if (kmem_cache_destroy(task_cache)) {
-			printk("iSCSI: kmem_cache_destroy failed for task "
-			       "cache %p at %lu\n", task_cache, jiffies);
-		}
-		return control_major;
+		ret = control_major;
+		goto free_cache;
 	}
 	printk("iSCSI: control device major number %d\n", control_major);
 
@@ -4047,31 +4049,31 @@ iscsi_init(void)
 	 */
 	iscsictl_sysfs_class = class_simple_create(THIS_MODULE, "iscsi_control");
 	if (!iscsictl_sysfs_class) {
-		kmem_cache_destroy(task_cache);
-		return control_major;
+		ret = control_major;
+		goto unreg_chrdev;
 	}
 	if (!class_simple_device_add(iscsictl_sysfs_class, MKDEV(control_major, 0),
 					NULL, "iscsictl")) {
-		kmem_cache_destroy(task_cache);
-		class_simple_destroy(iscsictl_sysfs_class);
-		return control_major;
+		ret = control_major;
+		goto destroy_iscsictl_cls;
 	}
 
 	shost = scsi_host_alloc(&iscsi_driver_template,
 				sizeof(struct iscsi_hba));
 	if (!shost) {
-		if (kmem_cache_destroy(task_cache)) {
-			printk("iSCSI: kmem_cache_destroy failed for task "
-			       "cache %p at %lu\n", task_cache, jiffies);
-		}
-		class_simple_device_remove(MKDEV(control_major, 0));
-		class_simple_destroy(iscsictl_sysfs_class);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto remove_iscsictl_cls;
 	}
 
 	if (shost->hostt->shost_attrs == NULL)
 		shost->hostt->shost_attrs = iscsi_host_attrs;
 
+	shost->transportt = iscsi_attach_transport(&iscsi_transport_functions);
+	if (!shost->transportt) {
+		ret = -ENODEV;
+		goto dec_host_cnt;
+	}
+
 	snprintf(shost->shost_gendev.bus_id, BUS_ID_SIZE, "iscsi");
 	snprintf(shost->shost_classdev.class_id, BUS_ID_SIZE, "iscsi");
 
@@ -4097,21 +4099,28 @@ iscsi_init(void)
 	/* for now,there's just one iSCSI HBA */
 	iscsi_hba = hba;
 	INIT_LIST_HEAD(&hba->session_head);
-	
-	ret = scsi_add_host(shost,NULL);
-	if (ret) {
-		if (kmem_cache_destroy(task_cache)) {
-			printk("iSCSI: kmem_cache_destroy failed for task "
-			       "cache %p at %lu\n", task_cache, jiffies);
-		}
-		class_simple_device_remove(MKDEV(control_major, 0));
-		class_simple_destroy(iscsictl_sysfs_class);
-		scsi_host_put(shost);
-		printk("iSCSI: failed to register SCSI HBA driver\n");
-	} else {
+
+	if (!scsi_add_host(shost, NULL)) {
 		printk("iSCSI:detected HBA host #%d\n",shost->host_no);
+		set_bit(0, &init_module_complete);
+		return 0;
 	}
-	set_bit(0, &init_module_complete);
+
+	printk("iSCSI: failed to register SCSI HBA driver\n");
+ dec_host_cnt:
+	scsi_host_put(shost);
+ remove_iscsictl_cls:
+	class_simple_device_remove(MKDEV(control_major, 0));
+ destroy_iscsictl_cls:
+	class_simple_destroy(iscsictl_sysfs_class);
+ unreg_chrdev:
+	unregister_chrdev(control_major, control_name);
+ free_cache:
+	if (kmem_cache_destroy(task_cache)) {
+		printk("iSCSI: kmem_cache_destroy failed for task "
+		       "cache %p at %lu\n", task_cache, jiffies);
+	}
+
 	return ret;
 }
 
@@ -4148,7 +4157,8 @@ iscsi_cleanup(void)
 		/* remove all sessions on this HBA, and prevent any from
 		 * being added.
 		 */
-		
+		iscsi_release_transport(shost->transportt);
+
 		if (!iscsi_shutdown_hba(hba)) {
 			printk("iSCSI:can't release HBA host #%u failed to"
 			       "shutdown\n",shost->host_no);

--------------080801090706090808070006--

