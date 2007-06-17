From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/5] firewire: fw-sbp2: use sdev->hostdata
Date: Sun, 17 Jun 2007 23:53:24 +0200 (CEST)
Message-ID: <tkrat.d4dc501547d4ae77@s5r6.in-berlin.de>
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

to simplify a few pointer expressions.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -602,7 +602,7 @@ static void sbp2_login(struct work_struc
 
 	/* FIXME: Loop over luns here. */
 	lun = 0;
-	sdev = __scsi_add_device(host, 0, 0, lun, NULL);
+	sdev = __scsi_add_device(host, 0, 0, lun, sd);
 	if (IS_ERR(sdev)) {
 		sbp2_send_management_orb(unit, sd->node_id, sd->generation,
 					 SBP2_LOGOUT_REQUEST, sd->login_id,
@@ -897,8 +897,7 @@ complete_command_orb(struct sbp2_orb *ba
 
 static int sbp2_command_orb_map_scatterlist(struct sbp2_command_orb *orb)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)orb->cmd->device->host->hostdata;
+	struct sbp2_device *sd = orb->cmd->device->hostdata;
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct scatterlist *sg;
@@ -983,8 +982,7 @@ static int sbp2_command_orb_map_scatterl
 
 static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)cmd->device->host->hostdata;
+	struct sbp2_device *sd = cmd->device->hostdata;
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_command_orb *orb;
@@ -1065,7 +1063,7 @@ static int sbp2_scsi_queuecommand(struct
 
 static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
 {
-	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
+	struct sbp2_device *sd = sdev->hostdata;
 
 	sdev->allow_restart = 1;
 
@@ -1076,7 +1074,7 @@ static int sbp2_scsi_slave_alloc(struct 
 
 static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 {
-	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
+	struct sbp2_device *sd = sdev->hostdata;
 	struct fw_unit *unit = sd->unit;
 
 	sdev->use_10_for_rw = 1;
@@ -1101,8 +1099,7 @@ static int sbp2_scsi_slave_configure(str
  */
 static int sbp2_scsi_abort(struct scsi_cmnd *cmd)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)cmd->device->host->hostdata;
+	struct sbp2_device *sd = cmd->device->hostdata;
 	struct fw_unit *unit = sd->unit;
 
 	fw_notify("sbp2_scsi_abort\n");
@@ -1133,7 +1130,7 @@ sbp2_sysfs_ieee1394_id_show(struct devic
 
 	if (!sdev)
 		return 0;
-	sd = (struct sbp2_device *)sdev->host->hostdata;
+	sd = sdev->hostdata;
 	unit = sd->unit;
 	device = fw_device(unit->device.parent);
 

-- 
Stefan Richter
-=====-=-=== -==- =---=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by DB2 Express
Download DB2 Express C - the FREE version of DB2 express and take
control of your XML. No limits. Just data. Click to get it now.
http://sourceforge.net/powerbar/db2/
