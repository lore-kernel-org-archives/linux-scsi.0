From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: fix NULL pointer deref in
 scsi_remove_device
Date: Sun, 17 Feb 2008 19:17:04 +0100 (CET)
Message-ID: <tkrat.bc89a18c9ce7df0b@s5r6.in-berlin.de>
References: <tkrat.e8f3d31fb5f9fe01@s5r6.in-berlin.de>
 <tkrat.9103805c20697161@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:58734 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbYBQSRS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Feb 2008 13:17:18 -0500
In-Reply-To: <tkrat.9103805c20697161@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

I wrote:
> There is unfortunately another bug.  If the user manually removes the
> scsi_device by writing into its "delete" sysfs attribute, the following
> will happen when the SBP-2 device is plugged out:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000000000b8
> IP: [<ffffffff804188c6>] mutex_lock_nested+0x7b/0x270
...
> Call Trace:
>  [<ffffffff8041a305>] ? _spin_unlock_irqrestore+0x49/0x68
>  [<ffffffff8036a670>] ? scsi_remove_device+0x1e/0x33
>  [<ffffffff880ef799>] ? :firewire_sbp2:sbp2_release_target+0x33/0xca
>  [<ffffffff880ef766>] ? :firewire_sbp2:sbp2_release_target+0x0/0xca
>  [<ffffffff802ec6df>] ? kref_put+0x41/0x4c
>  [<ffffffff880ef117>] ? :firewire_sbp2:sbp2_remove+0x10/0x14
...
> ---[ end trace 2a9c61e9883e29d2 ]---
> 

Fix a kernel bug when unplugging an SBP-2 device after having its
scsi_device already removed via the "delete" sysfs attribute.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.25-rc2/drivers/firewire/fw-sbp2.c
===================================================================
--- linux-2.6.25-rc2.orig/drivers/firewire/fw-sbp2.c
+++ linux-2.6.25-rc2/drivers/firewire/fw-sbp2.c
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
 
@@ -886,8 +887,6 @@ static void sbp2_login(struct work_struc
 	if (IS_ERR(sdev))
 		goto out_logout_login;
 
-	scsi_device_put(sdev);
-
 	/* Unreported error during __scsi_add_device() */
 	smp_rmb(); /* get current card generation */
 	if (generation != device->card->generation) {

-- 
Stefan Richter
-=====-==--- --=- =---=
http://arcgraph.de/sr/

