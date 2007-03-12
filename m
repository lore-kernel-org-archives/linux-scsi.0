From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 1/6] qla2xxx: fix RSCN handling on big-endian systems
Date: Mon, 12 Mar 2007 10:41:26 -0700
Message-ID: <11737212912300-git-send-email-andrew.vasquez@qlogic.com>
References: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:25522 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbXCLRlc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Mar 2007 13:41:32 -0400
In-Reply-To: <20070312174019.GA1216@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: malahal@us.ibm.com <malahal@us.ibm.com>

qla2xxx driver fails to handle RSCN events affecting area or domain due
to an endian issue on big endian systems.  This fixes the port_id_t
structure on big endian systems.

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>
Acked-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 05f4f2a..e8948b6 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
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
-- 
1.5.0.3.382.g34572

