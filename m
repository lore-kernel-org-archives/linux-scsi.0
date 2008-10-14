From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: fw-sbp2: extend failure check after SCSI probe
Date: Wed, 15 Oct 2008 00:10:53 +0200 (CEST)
Message-ID: <tkrat.35d7de3b2ee2ecfc@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53652 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbYJNWLE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 18:11:04 -0400
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

https://bugzilla.redhat.com/show_bug.cgi?id=466679 indicates that the
SCSI stack's probe may fail (with the sdev offlined) even if no 1394 bus
generation update happened.  It's cheap to check for offline status,
hence add this check to initiate a logout/ login/ SCSI probe retry.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-sbp2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -930,7 +930,8 @@ static void sbp2_login(struct work_struc
 
 	/* Unreported error during __scsi_add_device() */
 	smp_rmb(); /* get current card generation */
-	if (generation != device->card->generation) {
+	if (generation != device->card->generation ||
+	    !scsi_device_online(sdev)) {
 		scsi_remove_device(sdev);
 		scsi_device_put(sdev);
 		goto out_logout_login;

-- 
Stefan Richter
-=====-==--- =-=- -====
http://arcgraph.de/sr/

