From: Mark Knibbs <markk@clara.co.uk>
Subject: [PATCH] Fix off-by-one LUN check in scsi_scan_host_selected()
Date: Thu, 9 Oct 2014 12:39:48 +0100
Message-ID: <20141009123948.ed14b2f96456fecdb4af960b@clara.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [195.8.89.37] ([195.8.89.37]:57530 "EHLO
	claranet-outbound-smtp04.uk.clara.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbaJILlI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2014 07:41:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

The Scsi_Host structure max_lun field is the maximum allowed LUN plus 1. So
a LUN value is invalid if >= max_lun.

Signed-off-by: Mark Knibbs <markk@clara.co.uk>

---
diff -upN linux-3.17/drivers/scsi/scsi_scan.c.orig linux-3.17/drivers/scsi/scsi_scan.c
--- linux-3.17/drivers/scsi/scsi_scan.c.orig	2014-10-05 20:23:04.000000000 +0100
+++ linux-3.17/drivers/scsi/scsi_scan.c	2014-10-09 12:26:45.000000000 +0100
@@ -1704,7 +1704,7 @@ int scsi_scan_host_selected(struct Scsi_
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
-	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
+	    ((lun != SCAN_WILD_CARD) && (lun >= shost->max_lun)))
 		return -EINVAL;
 
 	mutex_lock(&shost->scan_mutex);
