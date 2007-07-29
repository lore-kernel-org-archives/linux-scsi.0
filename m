From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update 3/3] firewire: fw-sbp2: add support for multiple
	logical units per target
Date: Sun, 29 Jul 2007 03:05:24 +0200 (CEST)
Message-ID: <tkrat.79f0390686f53591@s5r6.in-berlin.de>
References: <tkrat.b8bfd55a441e870f@s5r6.in-berlin.de>
	<tkrat.1c43b4e95fa76945@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.1c43b4e95fa76945@s5r6.in-berlin.de>
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

This makes multiple logical units on a single target accessible to
fw-sbp2.  Successfully tested with the IOI FWB-IDE01AB dual LU bridge.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
update:
   - dynamically append logical units in a list
   - simplify config ROM parsing

 drivers/firewire/fw-sbp2.c |  195 ++++++++++++++++++++++++-------------
 1 file changed, 130 insertions(+), 65 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -71,6 +71,7 @@ static const char sbp2_driver_name[] = "
 
 struct sbp2_logical_unit {
 	struct sbp2_target *tgt;
+	struct list_head tgt_list;
 	struct scsi_device *sdev;
 	struct fw_address_handler address_handler;
 	struct list_head orb_list;
@@ -100,7 +101,7 @@ struct sbp2_target {
 
 	unsigned workarounds;
 	int starget_id;
-	struct sbp2_logical_unit lu[1];
+	struct list_head lu_list;
 };
 
 #define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
@@ -113,7 +114,9 @@ struct sbp2_target {
 #define SBP2_DIRECTION_FROM_MEDIA	0x1
 
 /* Unit directory keys */
-#define SBP2_FIRMWARE_REVISION		0x3c
+#define SBP2_CSR_FIRMWARE_REVISION	0x3c
+#define SBP2_CSR_LOGICAL_UNIT_NUMBER	0x14
+#define SBP2_CSR_LOGICAL_UNIT_DIRECTORY	0xd4
 
 /* Flags for detected oddities and brokeness */
 #define SBP2_WORKAROUND_128K_MAX_TRANS	0x1
@@ -531,18 +534,21 @@ static int sbp2_agent_reset(struct sbp2_
 	return 0;
 }
 
-/*  FIXME: Loop over logical units */
 static void release_sbp2_device(struct kref *kref)
 {
 	struct sbp2_target *tgt = container_of(kref, struct sbp2_target, kref);
-	struct sbp2_logical_unit *lu = tgt->lu;
+	struct sbp2_logical_unit *lu, *next;
 
-	if (lu->sdev)
-		scsi_remove_device(lu->sdev);
+	list_for_each_entry_safe(lu, next, &tgt->lu_list, tgt_list) {
+		if (lu->sdev)
+			scsi_remove_device(lu->sdev);
 
-	sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
-				 SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
-	fw_core_remove_address_handler(&lu->address_handler);
+		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
+				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
+		fw_core_remove_address_handler(&lu->address_handler);
+		list_del(&lu->tgt_list);
+		kfree(lu);
+	}
 	fw_notify("removed sbp2 unit %s\n", tgt->unit->device.bus_id);
 	put_device(&tgt->unit->device);
 	kfree(tgt);
@@ -623,70 +629,122 @@ static void sbp2_login(struct work_struc
 	kref_put(&lu->tgt->kref, release_sbp2_device);
 }
 
-static atomic_t sbp2_starget_id = ATOMIC_INIT(-1);
-
-/* FIXME: Loop over luns here. */
-static int sbp2_probe(struct device *dev)
+static int sbp2_add_logical_unit(struct sbp2_target *tgt, int lun_entry)
 {
-	struct fw_unit *unit = fw_unit(dev);
-	struct fw_device *device = fw_device(unit->device.parent);
-	struct sbp2_target *tgt;
 	struct sbp2_logical_unit *lu;
-	struct fw_csr_iterator ci;
-	int i, key, value, error;
-	u32 model, firmware_revision;
 
-	error = -ENOMEM;
-	tgt = kzalloc(sizeof(*tgt), GFP_KERNEL);
-	if (!tgt)
-		goto out_error;
+	lu = kmalloc(sizeof(*lu), GFP_KERNEL);
+	if (!lu)
+		return -ENOMEM;
 
-	unit->device.driver_data = tgt;
-	tgt->unit = unit;
-	kref_init(&tgt->kref);
-	tgt->starget_id = atomic_inc_return(&sbp2_starget_id);
+	lu->address_handler.length           = 0x100;
+	lu->address_handler.address_callback = sbp2_status_write;
+	lu->address_handler.callback_data    = lu;
+
+	if (fw_core_add_address_handler(&lu->address_handler,
+					&fw_high_memory_region) < 0) {
+		kfree(lu);
+		return -ENOMEM;
+	}
 
-	lu = tgt->lu;
-	lu->tgt = tgt;
-	lu->lun = 0;
+	lu->tgt  = tgt;
+	lu->sdev = NULL;
+	lu->lun  = lun_entry & 0xffff;
+	lu->retries = 0;
 	INIT_LIST_HEAD(&lu->orb_list);
+	INIT_DELAYED_WORK(&lu->work, sbp2_login);
 
-	lu->address_handler.length = 0x100;
-	lu->address_handler.address_callback = sbp2_status_write;
-	lu->address_handler.callback_data = lu;
+	list_add_tail(&lu->tgt_list, &tgt->lu_list);
+	return 0;
+}
 
-	error = fw_core_add_address_handler(&lu->address_handler,
-					    &fw_high_memory_region);
-	if (error < 0)
-		goto out_free;
+static int sbp2_scan_logical_unit_dir(struct sbp2_target *tgt, u32 *directory)
+{
+	struct fw_csr_iterator ci;
+	int key, value;
+
+	fw_csr_iterator_init(&ci, directory);
+	while (fw_csr_iterator_next(&ci, &key, &value))
+		if (key == SBP2_CSR_LOGICAL_UNIT_NUMBER &&
+		    sbp2_add_logical_unit(tgt, value) < 0)
+			return -ENOMEM;
+	return 0;
+}
 
-	error = fw_device_enable_phys_dma(device);
-	if (error < 0)
-		goto out_remove_address_handler;
+static int sbp2_scan_unit_dir(struct sbp2_target *tgt, u32 *directory,
+			      u32 *model, u32 *firmware_revision)
+{
+	struct fw_device *dev = fw_device(tgt->unit->device.parent);
+	struct fw_csr_iterator ci;
+	int key, value;
+	u32 *subdir;
 
-	/*
-	 * Scan unit directory to get management agent address,
-	 * firmware revison and model.  Initialize firmware_revision
-	 * and model to values that wont match anything in our table.
-	 */
-	firmware_revision = 0xff000000;
-	model = 0xff000000;
-	fw_csr_iterator_init(&ci, unit->directory);
+	fw_csr_iterator_init(&ci, directory);
 	while (fw_csr_iterator_next(&ci, &key, &value)) {
 		switch (key) {
+
 		case CSR_DEPENDENT_INFO | CSR_OFFSET:
-			tgt->management_agent_address =
-				0xfffff0000000ULL + 4 * value;
-			break;
-		case SBP2_FIRMWARE_REVISION:
-			firmware_revision = value;
+			tgt->management_agent_address
+					= 0xfffff0000000ULL + 4 * value;
 			break;
+
 		case CSR_MODEL:
-			model = value;
+			*model = value;
+			break;
+
+		case SBP2_CSR_FIRMWARE_REVISION:
+			*firmware_revision = value;
+			break;
+
+		case SBP2_CSR_LOGICAL_UNIT_NUMBER:
+			if (sbp2_add_logical_unit(tgt, value) < 0)
+				return -ENOMEM;
+			break;
+
+		case SBP2_CSR_LOGICAL_UNIT_DIRECTORY:
+			subdir = ci.p + value;
+			if (subdir <= dev->config_rom + 5 ||
+			    subdir >= dev->config_rom + dev->config_rom_length)
+				fw_error("logical unit dir out of bounds\n");
+			else if (sbp2_scan_logical_unit_dir(tgt, subdir) < 0)
+				return -ENOMEM;
 			break;
 		}
 	}
+	return 0;
+}
+
+static atomic_t sbp2_starget_id = ATOMIC_INIT(-1);
+
+static int sbp2_probe(struct device *dev)
+{
+	struct fw_unit *unit = fw_unit(dev);
+	struct fw_device *device = fw_device(unit->device.parent);
+	struct sbp2_target *tgt;
+	struct sbp2_logical_unit *lu, *next;
+	int i;
+	u32 model, firmware_revision;
+
+	tgt = kmalloc(sizeof(*tgt), GFP_KERNEL);
+	if (!tgt)
+		goto out_error;
+
+	unit->device.driver_data = tgt;
+	tgt->unit = unit;
+	kref_init(&tgt->kref);
+	INIT_LIST_HEAD(&tgt->lu_list);
+
+	/* Initialize to values that won't match anything in our table. */
+	model = ~0;
+	firmware_revision = ~0;
+	if (sbp2_scan_unit_dir(tgt, unit->directory, &model,
+			       &firmware_revision) < 0)
+		goto out_free;
+
+	if (fw_device_enable_phys_dma(device) < 0)
+		goto out_free;
 
+	tgt->workarounds = 0;
 	for (i = 0; i < ARRAY_SIZE(sbp2_workarounds_table); i++) {
 		if (sbp2_workarounds_table[i].firmware_revision !=
 		    (firmware_revision & 0xffffff00))
@@ -704,24 +762,29 @@ static int sbp2_probe(struct device *dev
 			  unit->device.bus_id,
 			  tgt->workarounds, firmware_revision, model);
 
+	tgt->starget_id = atomic_inc_return(&sbp2_starget_id);
 	get_device(&unit->device);
 
 	/*
 	 * We schedule work to do the login so we can easily reschedule retries.
 	 * Always get the ref when scheduling work.
 	 */
-	INIT_DELAYED_WORK(&lu->work, sbp2_login);
-	if (schedule_delayed_work(&lu->work, 0))
-		kref_get(&tgt->kref);
+	list_for_each_entry(lu, &tgt->lu_list, tgt_list)
+		if (schedule_delayed_work(&lu->work, 0))
+			kref_get(&tgt->kref);
 
 	return 0;
 
- out_remove_address_handler:
-	fw_core_remove_address_handler(&lu->address_handler);
  out_free:
+	list_for_each_entry_safe(lu, next, &tgt->lu_list, tgt_list) {
+		fw_core_remove_address_handler(&lu->address_handler);
+		list_del(&lu->tgt_list);
+		kfree(lu);
+	}
 	kfree(tgt);
+
  out_error:
-	return error;
+	return -ENOMEM;
 }
 
 static int sbp2_remove(struct device *dev)
@@ -771,17 +834,19 @@ static void sbp2_reconnect(struct work_s
 	kref_put(&lu->tgt->kref, release_sbp2_device);
 }
 
-/*  FIXME: Loop over logical units */
 static void sbp2_update(struct fw_unit *unit)
 {
 	struct fw_device *device = fw_device(unit->device.parent);
 	struct sbp2_target *tgt = unit->device.driver_data;
-	struct sbp2_logical_unit *lu = tgt->lu;
+	struct sbp2_logical_unit *lu;
 
-	lu->retries = 0;
 	fw_device_enable_phys_dma(device);
-	if (schedule_delayed_work(&lu->work, 0))
-		kref_get(&tgt->kref);
+
+	list_for_each_entry(lu, &tgt->lu_list, tgt_list) {
+		lu->retries = 0;
+		if (schedule_delayed_work(&lu->work, 0))
+			kref_get(&tgt->kref);
+	}
 }
 
 #define SBP2_UNIT_SPEC_ID_ENTRY	0x0000609e

-- 
Stefan Richter
-=====-=-=== -=== ===-=
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
