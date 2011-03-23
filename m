From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 02/14] iscsi: Add Serial Number Arithmetic LT and GT into iscsi_proto.h
Date: Tue, 22 Mar 2011 20:06:33 -0700
Message-ID: <1300849605-12651-3-git-send-email-nab@linux-iscsi.org>
References: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm22.bullet.mail.bf1.yahoo.com ([98.139.212.181]:23061 "HELO
	nm22.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751489Ab1CWDG6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2011 23:06:58 -0400
In-Reply-To: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the iscsi_sna_lt() and iscsi_sna_lte(), along with
iscsi_sna_gt() and iscsi_sna_gte() from iscsi_target_mod into
static inlines inside of include/scsi/iscsi_proto.h

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libiscsi.c    |   16 ----------------
 include/scsi/iscsi_proto.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9c3cb4e..3461a03 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -84,22 +84,6 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
 					     __func__, ##arg);		\
 	} while (0);
 
-/* Serial Number Arithmetic, 32 bits, less than, RFC1982 */
-#define SNA32_CHECK 2147483648UL
-
-static int iscsi_sna_lt(u32 n1, u32 n2)
-{
-	return n1 != n2 && ((n1 < n2 && (n2 - n1 < SNA32_CHECK)) ||
-			    (n1 > n2 && (n2 - n1 < SNA32_CHECK)));
-}
-
-/* Serial Number Arithmetic, 32 bits, less than, RFC1982 */
-static int iscsi_sna_lte(u32 n1, u32 n2)
-{
-	return n1 == n2 || ((n1 < n2 && (n2 - n1 < SNA32_CHECK)) ||
-			    (n1 > n2 && (n2 - n1 < SNA32_CHECK)));
-}
-
 inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
 {
 	struct Scsi_Host *shost = conn->session->host;
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index a9c9058..626b0344 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -33,6 +33,35 @@
 #define ISCSI_PAD_LEN		4
 
 /*
+ * Serial Number Arithmetic, 32 bits, RFC1982
+ */
+#define SNA32_CHECK 2147483648UL
+
+static inline int iscsi_sna_lt(u32 n1, u32 n2)
+{
+	return n1 != n2 && ((n1 < n2 && (n2 - n1 < SNA32_CHECK)) ||
+			(n1 > n2 && (n2 - n1 < SNA32_CHECK)));
+}
+
+static inline int iscsi_sna_lte(u32 n1, u32 n2)
+{
+	return n1 == n2 || ((n1 < n2 && (n2 - n1 < SNA32_CHECK)) ||
+			(n1 > n2 && (n2 - n1 < SNA32_CHECK)));
+}
+
+static inline int iscsi_sna_gt(u32 n1, u32 n2)
+{
+	return n1 != n2 && (((n1 < n2) && ((n2 - n1) > SNA32_CHECK)) ||
+			((n1 > n2) && ((n1 - n2) < SNA32_CHECK)));
+}
+
+static inline int iscsi_sna_gte(u32 n1, u32 n2)
+{
+	return n1 == n2 || (((n1 < n2) && ((n2 - n1) > SNA32_CHECK)) ||
+			((n1 > n2) && ((n1 - n2) < SNA32_CHECK)));
+}
+
+/*
  * useful common(control and data pathes) macro
  */
 #define ntoh24(p) (((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
-- 
1.7.4.1

