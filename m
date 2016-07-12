From: tom.ty89@gmail.com
Subject: [PATCH v2 2/2] libata-scsi: rename ata_msense_ctl_mode() to ata_msense_control()
Date: Wed, 13 Jul 2016 02:54:12 +0800
Message-ID: <57853cf8.c193420a.83221.11de@mx.google.com>
References: <20160712185412.4462-1-me>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34845 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcGLSyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 14:54:54 -0400
In-Reply-To: <20160712185412.4462-1-me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, hare@suse.de
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

To make it consistent with the recently added ata_mselect_control().
We probably shouldn't have the word "mode" in its name anyway, since
that's not the case for other ata_msense_*() / ata_mselect_*() either.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7e24f0a..bf4cb21 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2432,7 +2432,7 @@ static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
 }
 
 /**
- *	ata_msense_ctl_mode - Simulate MODE SENSE control mode page
+ *	ata_msense_control - Simulate MODE SENSE control mode page
  *	@dev: ATA device of interest
  *	@buf: output buffer
  *	@changeable: whether changeable parameters are requested
@@ -2442,7 +2442,7 @@ static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
  *	LOCKING:
  *	None.
  */
-static unsigned int ata_msense_ctl_mode(struct ata_device *dev, u8 *buf,
+static unsigned int ata_msense_control(struct ata_device *dev, u8 *buf,
 					bool changeable)
 {
 	modecpy(buf, def_control_mpage, sizeof(def_control_mpage), changeable);
@@ -2566,13 +2566,13 @@ static unsigned int ata_scsiop_mode_sense(struct ata_scsi_args *args, u8 *rbuf)
 		break;
 
 	case CONTROL_MPAGE:
-		p += ata_msense_ctl_mode(args->dev, p, page_control == 1);
+		p += ata_msense_control(args->dev, p, page_control == 1);
 		break;
 
 	case ALL_MPAGES:
 		p += ata_msense_rw_recovery(p, page_control == 1);
 		p += ata_msense_caching(args->id, p, page_control == 1);
-		p += ata_msense_ctl_mode(args->dev, p, page_control == 1);
+		p += ata_msense_control(args->dev, p, page_control == 1);
 		break;
 
 	default:		/* invalid page code */
@@ -3667,7 +3667,7 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
 	/*
 	 * Check that read-only bits are not modified.
 	 */
-	ata_msense_ctl_mode(dev, mpage, false);
+	ata_msense_control(dev, mpage, false);
 	for (i = 0; i < CONTROL_MPAGE_LEN - 2; i++) {
 		if (i == 0)
 			continue;
-- 
2.9.0

