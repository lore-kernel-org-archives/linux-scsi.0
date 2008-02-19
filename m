From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update] firewire: fw-sbp2: fix NULL pointer deref in
	scsi_remove_device
Date: Tue, 19 Feb 2008 09:05:49 +0100 (CET)
Message-ID: <tkrat.c814d52432988f28@s5r6.in-berlin.de>
References: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>
	<tkrat.9103805c20697161@s5r6.in-berlin.de>
	<tkrat.bc89a18c9ce7df0b@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.bc89a18c9ce7df0b@s5r6.in-berlin.de>
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
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Fix a kernel bug when unplugging an SBP-2 device after having its
scsi_device already removed via the "delete" sysfs attribute.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Update:  A _put was missing in a failure path.

 drivers/firewire/fw-sbp2.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -762,9 +762,10 @@ static void sbp2_release_target(struct k
 	sbp2_unblock(tgt);
 
 	list_for_each_entry_safe(lu, next, &tgt->lu_list, link) {
-		if (lu->sdev)
+		if (lu->sdev) {
 			scsi_remove_device(lu->sdev);
-
+			scsi_device_put(lu->sdev);
+		}
 		sbp2_send_management_orb(lu, tgt->node_id, lu->generation,
 				SBP2_LOGOUT_REQUEST, lu->login_id, NULL);
 
@@ -886,12 +887,11 @@ static void sbp2_login(struct work_struc
 	if (IS_ERR(sdev))
 		goto out_logout_login;
 
-	scsi_device_put(sdev);
-
 	/* Unreported error during __scsi_add_device() */
 	smp_rmb(); /* get current card generation */
 	if (generation != device->card->generation) {
 		scsi_remove_device(sdev);
+		scsi_device_put(sdev);
 		goto out_logout_login;
 	}
 

-- 
Stefan Richter
-=====-==--- --=- =--==
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
