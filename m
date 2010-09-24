From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] scsi_dh_alua: Handle all states correctly
Date: Fri, 24 Sep 2010 15:57:04 +0200
Message-ID: <20100924135704.C60D4352FF@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756451Ab0IXN5F (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2010 09:57:05 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id D96E087D82
	for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2010 15:57:04 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


For ALUA we should be handling all states, independent of whether
the mode is explicit or implicit. For 'Transitioning' we should retry
for a certain amount of time; after that we're setting the port
to 'Standby' and return SCSI_DH_RETRY to signal upper layers
a retry is in order here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 1a970a7..6b72932 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1,7 +1,7 @@
 /*
  * Generic SCSI-3 ALUA SCSI Device Handler
  *
- * Copyright (C) 2007, 2008 Hannes Reinecke, SUSE Linux Products GmbH.
+ * Copyright (C) 2007-2010 Hannes Reinecke, SUSE Linux Products GmbH.
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -20,17 +20,19 @@
  *
  */
 #include <linux/slab.h>
+#include <linux/delay.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dh.h>
 
 #define ALUA_DH_NAME "alua"
-#define ALUA_DH_VER "1.2"
+#define ALUA_DH_VER "1.3"
 
 #define TPGS_STATE_OPTIMIZED		0x0
 #define TPGS_STATE_NONOPTIMIZED		0x1
 #define TPGS_STATE_STANDBY		0x2
 #define TPGS_STATE_UNAVAILABLE		0x3
+#define TPGS_STATE_LBA_DEPENDENT	0x4
 #define TPGS_STATE_OFFLINE		0xe
 #define TPGS_STATE_TRANSITIONING	0xf
 
@@ -39,6 +41,7 @@
 #define TPGS_SUPPORT_NONOPTIMIZED	0x02
 #define TPGS_SUPPORT_STANDBY		0x04
 #define TPGS_SUPPORT_UNAVAILABLE	0x08
+#define TPGS_SUPPORT_LBA_DEPENDENT	0x10
 #define TPGS_SUPPORT_OFFLINE		0x40
 #define TPGS_SUPPORT_TRANSITION		0x80
 
@@ -460,6 +463,8 @@ static char print_alua_state(int state)
 		return 'S';
 	case TPGS_STATE_UNAVAILABLE:
 		return 'U';
+	case TPGS_STATE_LBA_DEPENDENT:
+		return 'L';
 	case TPGS_STATE_OFFLINE:
 		return 'O';
 	case TPGS_STATE_TRANSITIONING:
@@ -542,7 +547,9 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	int len, k, off, valid_states = 0;
 	char *ucp;
 	unsigned err;
+	unsigned long expiry, interval = 10;
 
+	expiry = round_jiffies_up(jiffies + ALUA_FAILOVER_TIMEOUT);
  retry:
 	err = submit_rtpg(sdev, h);
 
@@ -553,7 +560,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 			return SCSI_DH_IO;
 
 		err = alua_check_sense(sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE)
+		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
 			goto retry;
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: rtpg sense code %02x/%02x/%02x\n",
@@ -587,38 +594,37 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
 	}
 
 	sdev_printk(KERN_INFO, sdev,
-		    "%s: port group %02x state %c supports %c%c%c%c%c%c\n",
+		    "%s: port group %02x state %c supports %c%c%c%c%c%c%c\n",
 		    ALUA_DH_NAME, h->group_id, print_alua_state(h->state),
 		    valid_states&TPGS_SUPPORT_TRANSITION?'T':'t',
 		    valid_states&TPGS_SUPPORT_OFFLINE?'O':'o',
+		    valid_states&TPGS_SUPPORT_LBA_DEPENDENT?'L':'l',
 		    valid_states&TPGS_SUPPORT_UNAVAILABLE?'U':'u',
 		    valid_states&TPGS_SUPPORT_STANDBY?'S':'s',
 		    valid_states&TPGS_SUPPORT_NONOPTIMIZED?'N':'n',
 		    valid_states&TPGS_SUPPORT_OPTIMIZED?'A':'a');
 
-	if (h->tpgs & TPGS_MODE_EXPLICIT) {
-		switch (h->state) {
-		case TPGS_STATE_TRANSITIONING:
+	switch (h->state) {
+	case TPGS_STATE_TRANSITIONING:
+		if (time_before(jiffies, expiry)) {
 			/* State transition, retry */
+			interval *= 10;
+			msleep(interval);
 			goto retry;
-			break;
-		case TPGS_STATE_OFFLINE:
-			/* Path is offline, fail */
-			err = SCSI_DH_DEV_OFFLINED;
-			break;
-		default:
-			break;
 		}
-	} else {
-		/* Only Implicit ALUA support */
-		if (h->state == TPGS_STATE_OPTIMIZED ||
-		    h->state == TPGS_STATE_NONOPTIMIZED ||
-		    h->state == TPGS_STATE_STANDBY)
-			/* Useable path if active */
-			err = SCSI_DH_OK;
-		else
-			/* Path unuseable for unavailable/offline */
-			err = SCSI_DH_DEV_OFFLINED;
+		/* Transitioning time exceeded, set port to standby */
+		err = SCSI_DH_RETRY;
+		h->state = TPGS_STATE_STANDBY;
+		break;
+	case TPGS_STATE_OFFLINE:
+	case TPGS_STATE_UNAVAILABLE:
+		/* Path unuseable for unavailable/offline */
+		err = SCSI_DH_DEV_OFFLINED;
+		break;
+	default:
+		/* Useable path if active */
+		err = SCSI_DH_OK;
+		break;
 	}
 	return err;
 }
@@ -672,7 +678,9 @@ static int alua_activate(struct scsi_device *sdev,
 			goto out;
 	}
 
-	if (h->tpgs & TPGS_MODE_EXPLICIT && h->state != TPGS_STATE_OPTIMIZED) {
+	if (h->tpgs & TPGS_MODE_EXPLICIT &&
+	    h->state != TPGS_STATE_OPTIMIZED &&
+	    h->state != TPGS_STATE_LBA_DEPENDENT) {
 		h->callback_fn = fn;
 		h->callback_data = data;
 		err = submit_stpg(h);
@@ -698,8 +706,11 @@ static int alua_prep_fn(struct scsi_device *sdev, struct request *req)
 	struct alua_dh_data *h = get_alua_data(sdev);
 	int ret = BLKPREP_OK;
 
-	if (h->state != TPGS_STATE_OPTIMIZED &&
-	    h->state != TPGS_STATE_NONOPTIMIZED) {
+	if (h->state == TPGS_STATE_TRANSITIONING)
+		ret = BLKPREP_DEFER;
+	else if (h->state != TPGS_STATE_OPTIMIZED &&
+		 h->state != TPGS_STATE_NONOPTIMIZED &&
+		 h->state != TPGS_STATE_LBA_DEPENDENT) {
 		ret = BLKPREP_KILL;
 		req->cmd_flags |= REQ_QUIET;
 	}
