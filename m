From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2/5] firewire: fw-sbp2: let SCSI shutdown commands through
	before logout
Date: Sun, 17 Jun 2007 23:52:52 +0200 (CEST)
Message-ID: <tkrat.86a8cf28dc784b39@s5r6.in-berlin.de>
References: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This affects of course only the "soft shutdown" case, e.g. "modprobe -r
firewire-sbp2", while it doesn't matter for hot unplug.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -28,6 +28,7 @@
  * and many others.
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -54,6 +55,7 @@ static const char sbp2_driver_name[] = "
 
 struct sbp2_device {
 	struct kref kref;
+	struct scsi_device *sdev;
 	struct fw_unit *unit;
 	struct fw_address_handler address_handler;
 	struct list_head orb_list;
@@ -520,13 +522,16 @@ static int sbp2_agent_reset(struct fw_un
 static void sbp2_reconnect(struct work_struct *work);
 static struct scsi_host_template scsi_driver_template;
 
-static void
-release_sbp2_device(struct kref *kref)
+static void release_sbp2_device(struct kref *kref)
 {
 	struct sbp2_device *sd = container_of(kref, struct sbp2_device, kref);
 	struct Scsi_Host *host =
 		container_of((void *)sd, struct Scsi_Host, hostdata[0]);
 
+	/* Let SCSI command set drivers shut down now. */
+	if (sd->sdev)
+		scsi_remove_device(sd->sdev);
+
 	sbp2_send_management_orb(sd->unit, sd->node_id, sd->generation,
 				 SBP2_LOGOUT_REQUEST, sd->login_id, NULL);
 
@@ -543,10 +548,11 @@ static void sbp2_login(struct work_struc
 		container_of(work, struct sbp2_device, work.work);
 	struct Scsi_Host *host =
 		container_of((void *)sd, struct Scsi_Host, hostdata[0]);
+	struct scsi_device *sdev;
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_login_response response;
-	int generation, node_id, local_node_id, lun, retval;
+	int generation, node_id, local_node_id, lun;
 
 	/* FIXME: Make this work for multi-lun devices. */
 	lun = 0;
@@ -596,8 +602,8 @@ static void sbp2_login(struct work_struc
 
 	/* FIXME: Loop over luns here. */
 	lun = 0;
-	retval = scsi_add_device(host, 0, 0, lun);
-	if (retval < 0) {
+	sdev = __scsi_add_device(host, 0, 0, lun, NULL);
+	if (IS_ERR(sdev)) {
 		sbp2_send_management_orb(unit, sd->node_id, sd->generation,
 					 SBP2_LOGOUT_REQUEST, sd->login_id,
 					 NULL);
@@ -606,6 +612,9 @@ static void sbp2_login(struct work_struc
 		 * retry login on bus reset.
 		 */
 		PREPARE_DELAYED_WORK(&sd->work, sbp2_login);
+	} else {
+		sd->sdev = sdev;
+		scsi_device_put(sdev);
 	}
 	kref_put(&sd->kref, release_sbp2_device);
 }
@@ -1120,7 +1129,7 @@ sbp2_sysfs_ieee1394_id_show(struct devic
 	struct fw_device *device;
 	u32 directory_id;
 	struct fw_csr_iterator ci;
-	int key, value, lun;
+	int key, value;
 
 	if (!sdev)
 		return 0;
@@ -1140,12 +1149,9 @@ sbp2_sysfs_ieee1394_id_show(struct devic
 			break;
 		}
 
-	/* FIXME: Make this work for multi-lun devices. */
-	lun = 0;
-
 	return sprintf(buf, "%08x%08x:%06x:%04x\n",
 			device->config_rom[3], device->config_rom[4],
-			directory_id, lun);
+			directory_id, sdev->lun);
 }
 
 static DEVICE_ATTR(ieee1394_id, S_IRUGO, sbp2_sysfs_ieee1394_id_show, NULL);

-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
