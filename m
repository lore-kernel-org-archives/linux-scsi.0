From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/5 v2] firewire: fw-sbp2: use sdev->hostdata
Date: Mon, 18 Jun 2007 18:47:46 +0200 (CEST)
Message-ID: <tkrat.a1e99d6be46bde93@s5r6.in-berlin.de>
References: <tkrat.b43f5b2b920f45c6@s5r6.in-berlin.de>
	<tkrat.86a8cf28dc784b39@s5r6.in-berlin.de>
	<1182180417.7928.13.camel@hinata.boston.redhat.com>
	<4676B3FD.9010604@s5r6.in-berlin.de>
	<tkrat.301a907417598815@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.301a907417598815@s5r6.in-berlin.de>
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
To: =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

to simplify a few pointer expressions.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:  adapt to changes in preceding patch

 drivers/firewire/fw-sbp2.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

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
@@ -541,10 +542,11 @@ static void sbp2_login(struct work_struc
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
@@ -594,8 +596,8 @@ static void sbp2_login(struct work_struc
 
 	/* FIXME: Loop over luns here. */
 	lun = 0;
-	retval = scsi_add_device(host, 0, 0, lun);
-	if (retval < 0) {
+	sdev = __scsi_add_device(host, 0, 0, lun, sd);
+	if (IS_ERR(sdev)) {
 		sbp2_send_management_orb(unit, sd->node_id, sd->generation,
 					 SBP2_LOGOUT_REQUEST, sd->login_id,
 					 NULL);
@@ -604,6 +606,8 @@ static void sbp2_login(struct work_struc
 		 * retry login on bus reset.
 		 */
 		PREPARE_DELAYED_WORK(&sd->work, sbp2_login);
+	} else {
+		scsi_device_put(sdev);
 	}
 	kref_put(&sd->kref, release_sbp2_device);
 }
@@ -886,8 +890,7 @@ complete_command_orb(struct sbp2_orb *ba
 
 static int sbp2_command_orb_map_scatterlist(struct sbp2_command_orb *orb)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)orb->cmd->device->host->hostdata;
+	struct sbp2_device *sd = orb->cmd->device->hostdata;
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct scatterlist *sg;
@@ -972,8 +975,7 @@ static int sbp2_command_orb_map_scatterl
 
 static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)cmd->device->host->hostdata;
+	struct sbp2_device *sd = cmd->device->hostdata;
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_command_orb *orb;
@@ -1054,7 +1056,7 @@ static int sbp2_scsi_queuecommand(struct
 
 static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
 {
-	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
+	struct sbp2_device *sd = sdev->hostdata;
 
 	sdev->allow_restart = 1;
 
@@ -1065,7 +1067,7 @@ static int sbp2_scsi_slave_alloc(struct 
 
 static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 {
-	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
+	struct sbp2_device *sd = sdev->hostdata;
 	struct fw_unit *unit = sd->unit;
 
 	sdev->use_10_for_rw = 1;
@@ -1090,8 +1092,7 @@ static int sbp2_scsi_slave_configure(str
  */
 static int sbp2_scsi_abort(struct scsi_cmnd *cmd)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)cmd->device->host->hostdata;
+	struct sbp2_device *sd = cmd->device->hostdata;
 	struct fw_unit *unit = sd->unit;
 
 	fw_notify("sbp2_scsi_abort\n");
@@ -1122,7 +1123,7 @@ sbp2_sysfs_ieee1394_id_show(struct devic
 
 	if (!sdev)
 		return 0;
-	sd = (struct sbp2_device *)sdev->host->hostdata;
+	sd = sdev->hostdata;
 	unit = sd->unit;
 	device = fw_device(unit->device.parent);
 

-- 
Stefan Richter
-=====-=-=== -==- =--=-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
