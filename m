From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v5 02/13] iscsi: Add Serial Number Arithmetic LT and GT into iscsi_proto.h
Date: Thu, 19 May 2011 20:37:47 -0700
Message-ID: <1305862678-30150-3-git-send-email-nab@linux-iscsi.org>
References: <1305862678-30150-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305862678-30150-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the iscsi_sna_lt() and iscsi_sna_lte(), along with
iscsi_sna_gt() and iscsi_sna_gte() from iscsi_target_mod into
static inlines inside of include/scsi/iscsi_proto.h

This patch also includes the ISCSI_HDR_LEN and ISCSI_CRC_LEN
definitions.

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libiscsi.c    |   16 ----------------
 include/scsi/iscsi_proto.h |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 16 deletions(-)

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
index a9c9058..455b03a 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -29,10 +29,48 @@
 /* default iSCSI listen port for incoming connections */
 #define ISCSI_LISTEN_PORT	3260
 
+/* iSCSI header length */
+#define ISCSI_HDR_LEN		48
+
+/* iSCSI CRC32C length */
+#define ISCSI_CRC_LEN		4
+
 /* Padding word length */
 #define ISCSI_PAD_LEN		4
 
 /*
+ * Serial Number Arithmetic, 32 bits, RFC1982
+ */
+
+static inline int iscsi_sna_lt(u32 n1, u32 n2)
+{
+	s32 diff = n1 - n2;
+
+	return diff < 0;
+}
+
+static inline int iscsi_sna_lte(u32 n1, u32 n2)
+{
+	s32 diff = n1 - n2;
+
+	return diff <= 0;
+}
+
+static inline int iscsi_sna_gt(u32 n1, u32 n2)
+{
+	s32 diff = n1 - n2;
+
+	return diff > 0;
+}
+
+static inline int iscsi_sna_gte(u32 n1, u32 n2)
+{
+	s32 diff = n1 - n2;
+
+	return diff >= 0;
+}
+
+/*
  * useful common(control and data pathes) macro
  */
 #define ntoh24(p) (((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
-- 
1.7.5.1
