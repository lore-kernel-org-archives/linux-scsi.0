From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: better fix for NULL pointer dereference in
	scsi_remove_device
Date: Tue, 26 Feb 2008 23:30:02 +0100 (CET)
Message-ID: <tkrat.43f73e8c841b3161@s5r6.in-berlin.de>
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
To: Jarod Wilson <jwilson@redhat.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Patch "firewire: fw-sbp2: fix NULL pointer deref. in scsi_remove_device"
had the unintended effect that firewire-sbp2 could not be unloaded
anymore until all SBP-2 devices were unplugged.

We now fix the NULL pointer bug by reacquiring a reference to the sdev
instead of holding a reference to the sdev (and to the module) all the
time.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This applies on top of current linux-2.6.git master as well as on top of
linux1394-2.6.git master.


 drivers/firewire/fw-sbp2.c |   46 +++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 19 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -122,7 +122,6 @@ static const char sbp2_driver_name[] = "
 struct sbp2_logical_unit {
 	struct sbp2_target *tgt;
 	struct list_head link;
-	struct scsi_device *sdev;
 	struct fw_address_handler address_handler;
 	struct list_head orb_list;
 
@@ -139,6 +138,7 @@ struct sbp2_logical_unit {
 	int generation;
 	int retries;
 	struct delayed_work work;
+	bool has_sdev;
 	bool blocked;
 };
 
@@ -751,20 +751,33 @@ static void sbp2_unblock(struct sbp2_tar
 	scsi_unblock_requests(shost);
 }
 
+static int sbp2_lun2int(u16 lun)
+{
+	struct scsi_lun eight_bytes_lun;
+
+	memset(&eight_bytes_lun, 0, sizeof(eight_bytes_lun));
+	eight_bytes_lun.scsi_lun[0] = (lun >> 8) & 0xff;
+	eight_bytes_lun.scsi_lun[1] = lun & 0xff;
+
+	return scsilun_to_int(&eight_bytes_lun);
+}
+
 static void sbp2_release_target(struct kref *kref)
 {
 	struct sbp2_target *tgt = container_of(kref, struct sbp2_target, kref);
 	struct sbp2_logical_unit *lu, *next;
 	struct Scsi_Host *shost =
 		container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
+	struct scsi_device *sdev;
 
 	/* prevent deadlocks */
 	sbp2_unblock(tgt);
 
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
-		if (lu->sdev) {
-			scsi_remove_device(lu->sdev);
-			scsi_device_put(lu->sdev);
+		sdev = scsi_device_lookup(shost, 0, 0, sbp2_lun2int(lu->lun));
+		if (sdev) {
+			scsi_remove_device(sdev);
+			scsi_device_put(sdev);
 		}
 		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
 				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
@@ -807,7 +820,6 @@ static void sbp2_login(struct work_struc
 	struct fw_device *device = fw_device(tgt->unit->device.parent);
 	struct Scsi_Host *shost;
 	struct scsi_device *sdev;
-	struct scsi_lun eight_bytes_lun;
 	struct sbp2_login_response response;
 	int generation, node_id, local_node_id;
 
@@ -820,7 +832,7 @@ static void sbp2_login(struct work_struc
 	local_node_id = device->card->node_id;
 
 	/* If this is a re-login attempt, log out, or we might be rejected. */
-	if (lu->sdev)
+	if (lu->has_sdev)
 		sbp2_send_management_orb(lu, device->node_id, generation,
 				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 
@@ -859,7 +871,7 @@ static void sbp2_login(struct work_struc
 	sbp2_agent_reset(lu);
 
 	/* This was a re-login. */
-	if (lu->sdev) {
+	if (lu->has_sdev) {
 		sbp2_cancel_orbs(lu);
 		sbp2_conditionally_unblock(lu);
 		goto out;
@@ -868,13 +880,8 @@ static void sbp2_login(struct work_struc
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_DELAY_INQUIRY)
 		ssleep(SBP2_INQUIRY_DELAY);
 
-	memset(&eight_bytes_lun, 0, sizeof(eight_bytes_lun));
-	eight_bytes_lun.scsi_lun[0] = (lu->lun >> 8) & 0xff;
-	eight_bytes_lun.scsi_lun[1] = lu->lun & 0xff;
 	shost = container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
-
-	sdev = __scsi_add_device(shost, 0, 0,
-				 scsilun_to_int(&eight_bytes_lun), lu);
+	sdev = __scsi_add_device(shost, 0, 0, sbp2_lun2int(lu->lun), lu);
 	/*
 	 * FIXME:  We are unable to perform reconnects while in sbp2_login().
 	 * Therefore __scsi_add_device() will get into trouble if a bus reset
@@ -896,7 +903,8 @@ static void sbp2_login(struct work_struc
 	}
 
 	/* No error during __scsi_add_device() */
-	lu->sdev = sdev;
+	lu->has_sdev = true;
+	scsi_device_put(sdev);
 	sbp2_allow_block(lu);
 	goto out;
 
@@ -934,11 +942,11 @@ static int sbp2_add_logical_unit(struct 
 		return -ENOMEM;
 	}
 
-	lu->tgt  = tgt;
-	lu->sdev = NULL;
-	lu->lun  = lun_entry & 0xffff;
-	lu->retries = 0;
-	lu->blocked = false;
+	lu->tgt      = tgt;
+	lu->lun      = lun_entry & 0xffff;
+	lu->retries  = 0;
+	lu->has_sdev = false;
+	lu->blocked  = false;
 	++tgt->dont_block;
 	INIT_LIST_HEAD(&lu->orb_list);
 	INIT_DELAYED_WORK(&lu->work, sbp2_login);

-- 
Stefan Richter
-=====-==--- --=- ==-=-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
