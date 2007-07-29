From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update 1/3] firewire: fw-sbp2: use one Scsi_Host for all
	targets
Date: Sun, 29 Jul 2007 03:03:07 +0200 (CEST)
Message-ID: <tkrat.b8bfd55a441e870f@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
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

This rework prepares support of multiple logical units per target.
Instead of one instance of struct Scsi_Host per target, only one
Scsi_Host global to fw-sbp2 is now used.  We could also use one
Scsi_Host per FireWire host, but that would add more overhead for no
real benefit.

The following user-visible changes result:

  - The generic device of the Scsi_Host is registered as a platform
    device.  Hence it and the target devices and logical unit devices
    will be sitting below /sys/devices/platform/host*/ rather than
    within the PCI devices tree.

  - In the SCSI stack's H:C:T:L tuple, the H is now constant for all
    fw-sbp2 devices but the T is unique.  We currently allocate T as
    stupidly as the H was allocated before:  It is simply increased
    whenever a target is added.

Neither of these changes should affect userspace, because none of the
mentioned device properties have been of any interest to userspace
before.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
requires patches
    "firewire: fw-sbp2: sanitize list handling" (update)
    http://marc.info/?l=linux1394-devel&m=118566666024249	
    "firewire: remove unused macros"
    http://marc.info/?l=linux1394-devel&m=118540673511987

update: fix memory leak in release_sbp2_device

 drivers/firewire/fw-sbp2.c |  118 +++++++++++++++++++++----------------
 1 file changed, 70 insertions(+), 48 deletions(-)

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
 #include <linux/moduleparam.h>
@@ -39,6 +40,8 @@
 #include <linux/string.h>
 #include <linux/timer.h>
 
+#include <asm/atomic.h>
+
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
@@ -71,6 +74,7 @@ struct sbp2_device {
 	struct fw_unit *unit;
 	struct fw_address_handler address_handler;
 	struct list_head orb_list;
+	struct scsi_device *sdev;
 	u64 management_agent_address;
 	u64 command_block_agent_address;
 	u32 workarounds;
@@ -522,34 +526,35 @@ static int sbp2_agent_reset(struct fw_un
 	return 0;
 }
 
-static void sbp2_reconnect(struct work_struct *work);
-static struct scsi_host_template scsi_driver_template;
-
 static void release_sbp2_device(struct kref *kref)
 {
 	struct sbp2_device *sd = container_of(kref, struct sbp2_device, kref);
-	struct Scsi_Host *host =
-		container_of((void *)sd, struct Scsi_Host, hostdata[0]);
 
-	scsi_remove_host(host);
+	if (sd->sdev)
+		scsi_remove_device(sd->sdev);
+
 	sbp2_send_management_orb(sd->unit, sd->node_id, sd->generation,
 				 SBP2_LOGOUT_REQUEST, sd->login_id, NULL);
 	fw_core_remove_address_handler(&sd->address_handler);
 	fw_notify("removed sbp2 unit %s\n", sd->unit->device.bus_id);
 	put_device(&sd->unit->device);
-	scsi_host_put(host);
+	kfree(sd);
 }
 
+static void sbp2_reconnect(struct work_struct *work);
+
+static struct Scsi_Host *sbp2_shost;
+static atomic_t sbp2_starget_id = ATOMIC_INIT(-1);
+
 static void sbp2_login(struct work_struct *work)
 {
 	struct sbp2_device *sd =
 		container_of(work, struct sbp2_device, work.work);
-	struct Scsi_Host *host =
-		container_of((void *)sd, struct Scsi_Host, hostdata[0]);
+	struct scsi_device *sdev;
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_login_response response;
-	int generation, node_id, local_node_id, lun, retval;
+	int generation, node_id, local_node_id, lun;
 
 	/* FIXME: Make this work for multi-lun devices. */
 	lun = 0;
@@ -597,10 +602,9 @@ static void sbp2_login(struct work_struc
 	PREPARE_DELAYED_WORK(&sd->work, sbp2_reconnect);
 	sbp2_agent_reset(unit);
 
-	/* FIXME: Loop over luns here. */
-	lun = 0;
-	retval = scsi_add_device(host, 0, 0, lun);
-	if (retval < 0) {
+	sdev = __scsi_add_device(sbp2_shost, 0,
+				 atomic_inc_return(&sbp2_starget_id), lun, sd);
+	if (IS_ERR(sdev)) {
 		sbp2_send_management_orb(unit, sd->node_id, sd->generation,
 					 SBP2_LOGOUT_REQUEST, sd->login_id,
 					 NULL);
@@ -609,26 +613,28 @@ static void sbp2_login(struct work_struc
 		 * retry login on bus reset.
 		 */
 		PREPARE_DELAYED_WORK(&sd->work, sbp2_login);
+	} else {
+		sd->sdev = sdev;
+		scsi_device_put(sdev);
 	}
 	kref_put(&sd->kref, release_sbp2_device);
 }
 
+/* FIXME: Loop over luns here. */
 static int sbp2_probe(struct device *dev)
 {
 	struct fw_unit *unit = fw_unit(dev);
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_device *sd;
 	struct fw_csr_iterator ci;
-	struct Scsi_Host *host;
-	int i, key, value, err;
+	int i, key, value, error;
 	u32 model, firmware_revision;
 
-	err = -ENOMEM;
-	host = scsi_host_alloc(&scsi_driver_template, sizeof(*sd));
-	if (host == NULL)
-		goto fail;
+	error = -ENOMEM;
+	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
+	if (!sd)
+		goto out_error;
 
-	sd = (struct sbp2_device *) host->hostdata;
 	unit->device.driver_data = sd;
 	sd->unit = unit;
 	INIT_LIST_HEAD(&sd->orb_list);
@@ -638,18 +644,14 @@ static int sbp2_probe(struct device *dev
 	sd->address_handler.address_callback = sbp2_status_write;
 	sd->address_handler.callback_data = sd;
 
-	err = fw_core_add_address_handler(&sd->address_handler,
-					  &fw_high_memory_region);
-	if (err < 0)
-		goto fail_host;
-
-	err = fw_device_enable_phys_dma(device);
-	if (err < 0)
-		goto fail_address_handler;
-
-	err = scsi_add_host(host, &unit->device);
-	if (err < 0)
-		goto fail_address_handler;
+	error = fw_core_add_address_handler(&sd->address_handler,
+					    &fw_high_memory_region);
+	if (error < 0)
+		goto out_free;
+
+	error = fw_device_enable_phys_dma(device);
+	if (error < 0)
+		goto out_remove_address_handler;
 
 	/*
 	 * Scan unit directory to get management agent address,
@@ -704,12 +706,12 @@ static int sbp2_probe(struct device *dev
 
 	return 0;
 
- fail_address_handler:
+ out_remove_address_handler:
 	fw_core_remove_address_handler(&sd->address_handler);
- fail_host:
-	scsi_host_put(host);
- fail:
-	return err;
+ out_free:
+	kfree(sd);
+ out_error:
+	return error;
 }
 
 static int sbp2_remove(struct device *dev)
@@ -890,8 +892,7 @@ complete_command_orb(struct sbp2_orb *ba
 
 static int sbp2_command_orb_map_scatterlist(struct sbp2_command_orb *orb)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)orb->cmd->device->host->hostdata;
+	struct sbp2_device *sd = orb->cmd->device->hostdata;
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct scatterlist *sg;
@@ -978,8 +979,7 @@ static int sbp2_command_orb_map_scatterl
 
 static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)cmd->device->host->hostdata;
+	struct sbp2_device *sd = cmd->device->hostdata;
 	struct fw_unit *unit = sd->unit;
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_command_orb *orb;
@@ -1060,7 +1060,7 @@ static int sbp2_scsi_queuecommand(struct
 
 static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
 {
-	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
+	struct sbp2_device *sd = sdev->hostdata;
 
 	sdev->allow_restart = 1;
 
@@ -1071,7 +1071,7 @@ static int sbp2_scsi_slave_alloc(struct 
 
 static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 {
-	struct sbp2_device *sd = (struct sbp2_device *)sdev->host->hostdata;
+	struct sbp2_device *sd = sdev->hostdata;
 	struct fw_unit *unit = sd->unit;
 
 	sdev->use_10_for_rw = 1;
@@ -1096,8 +1096,7 @@ static int sbp2_scsi_slave_configure(str
  */
 static int sbp2_scsi_abort(struct scsi_cmnd *cmd)
 {
-	struct sbp2_device *sd =
-		(struct sbp2_device *)cmd->device->host->hostdata;
+	struct sbp2_device *sd = cmd->device->hostdata;
 	struct fw_unit *unit = sd->unit;
 
 	fw_notify("sbp2_scsi_abort\n");
@@ -1128,7 +1127,7 @@ sbp2_sysfs_ieee1394_id_show(struct devic
 
 	if (!sdev)
 		return 0;
-	sd = (struct sbp2_device *)sdev->host->hostdata;
+	sd = sdev->hostdata;
 	unit = sd->unit;
 	device = fw_device(unit->device.parent);
 
@@ -1187,12 +1186,35 @@ MODULE_ALIAS("sbp2");
 
 static int __init sbp2_init(void)
 {
-	return driver_register(&sbp2_driver.driver);
+	int error = -ENOMEM;
+
+	sbp2_shost = scsi_host_alloc(&scsi_driver_template, 0);
+	if (!sbp2_shost)
+		goto out_error;
+
+	error = scsi_add_host(sbp2_shost, NULL);
+	if (error)
+		goto out_host_put;
+
+	error = driver_register(&sbp2_driver.driver);
+	if (error)
+		goto out_remove_host;
+
+	return 0;
+
+ out_remove_host:
+	scsi_remove_host(sbp2_shost);
+ out_host_put:
+	scsi_host_put(sbp2_shost);
+ out_error:
+	return error;
 }
 
 static void __exit sbp2_cleanup(void)
 {
 	driver_unregister(&sbp2_driver.driver);
+	scsi_remove_host(sbp2_shost);
+	scsi_host_put(sbp2_shost);
 }
 
 module_init(sbp2_init);

-- 
Stefan Richter
-=====-=-=== -=== ===-=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
