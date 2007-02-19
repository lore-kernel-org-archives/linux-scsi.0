From: malahal@us.ibm.com
Subject: [PATCH] qla2xxx: fix RSCN handling on big-endian systems
Date: Mon, 19 Feb 2007 10:18:32 -0800
Message-ID: <20070219181832.GA18043@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34883 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932442AbXBSSTW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Feb 2007 13:19:22 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1JIJLLa015339
	for <linux-scsi@vger.kernel.org>; Mon, 19 Feb 2007 13:19:21 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1JIJJHU303844
	for <linux-scsi@vger.kernel.org>; Mon, 19 Feb 2007 13:19:19 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1JIJIat019207
	for <linux-scsi@vger.kernel.org>; Mon, 19 Feb 2007 13:19:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com

qla2xxx driver fails to handle RSCN events affecting area or domain due
to an endian issue on big endian systems.  This fixes the port_id_t
structure on big endian systems.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r c860739bb0f4 drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	Fri Feb 16 14:19:34 2007 -0800
+++ b/drivers/scsi/qla2xxx/qla_def.h	Fri Feb 16 14:21:29 2007 -0800
@@ -1478,14 +1478,17 @@ typedef union {
 	uint32_t b24 : 24;
 
 	struct {
-		uint8_t d_id[3];
-		uint8_t rsvd_1;
-	} r;
-
-	struct {
+#ifdef __BIG_ENDIAN
+		uint8_t domain;
+		uint8_t area;
+		uint8_t al_pa;
+#elif __LITTLE_ENDIAN
 		uint8_t al_pa;
 		uint8_t area;
 		uint8_t domain;
+#else
+#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
+#endif
 		uint8_t rsvd_1;
 	} b;
 } port_id_t;
