From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 15/15] Staging: hv: storvsc: Consolidate all the wire protocol definitions
Date: Thu, 12 Jan 2012 12:38:08 -0800
Message-ID: <1326400688-13544-15-git-send-email-kys@microsoft.com>
References: <1326400637-13494-1-git-send-email-kys@microsoft.com>
 <1326400688-13544-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1326400688-13544-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Consolidate all definitions that support communication with the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   83 +++++++++++++++++++++----------------
 1 files changed, 47 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 9ccc1c4..695ffc3 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -42,33 +42,13 @@
 #include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_dbg.h>
 
-
-/*
- * We setup a mempool to allocate request structures for this driver
- * on a per-lun basis. The following define specifies the number of
- * elements in the pool.
- */
-
-#define STORVSC_MIN_BUF_NR				64
-static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
-
-module_param(storvsc_ringbuffer_size, int, S_IRUGO);
-MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
-
-
 /*
- * Major/minor macros.  Minor version is in LSB, meaning that earlier flat
- * version numbers will be interpreted as "0.x" (i.e., 1 becomes 0.1).
+ * All wire protocol details (storage protocol between the guest and the host)
+ * are consolidated here.
+ *
+ * Begin protocol definitions.
  */
 
-static inline u16 storvsc_get_version(u8 major, u8 minor)
-{
-	u16 version;
-
-	version = ((major << 8) | minor);
-	return version;
-}
-
 /*
  * Version history:
  * V1 Beta: 0.1
@@ -207,18 +187,6 @@ struct vstor_packet {
 
 #define REQUEST_COMPLETION_FLAG	0x1
 
-#define STORVSC_MAX_IO_REQUESTS				128
-
-/*
- * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In
- * reality, the path/target is not used (ie always set to 0) so our
- * scsi host adapter essentially has 1 bus with 1 target that contains
- * up to 256 luns.
- */
-#define STORVSC_MAX_LUNS_PER_TARGET			64
-#define STORVSC_MAX_TARGETS				1
-#define STORVSC_MAX_CHANNELS				1
-
 /* Matches Windows-end */
 enum storvsc_request_type {
 	WRITE_TYPE = 0,
@@ -235,6 +203,36 @@ enum storvsc_request_type {
 #define SRB_STATUS_SUCCESS	0x01
 #define SRB_STATUS_ERROR	0x04
 
+/*
+ * This is the end of Protocol specific defines.
+ */
+
+
+/*
+ * We setup a mempool to allocate request structures for this driver
+ * on a per-lun basis. The following define specifies the number of
+ * elements in the pool.
+ */
+
+#define STORVSC_MIN_BUF_NR				64
+static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
+
+module_param(storvsc_ringbuffer_size, int, S_IRUGO);
+MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
+
+#define STORVSC_MAX_IO_REQUESTS				128
+
+/*
+ * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In
+ * reality, the path/target is not used (ie always set to 0) so our
+ * scsi host adapter essentially has 1 bus with 1 target that contains
+ * up to 256 luns.
+ */
+#define STORVSC_MAX_LUNS_PER_TARGET			64
+#define STORVSC_MAX_TARGETS				1
+#define STORVSC_MAX_CHANNELS				1
+
+
 
 struct storvsc_cmd_request {
 	struct list_head entry;
@@ -337,6 +335,19 @@ done:
 }
 
 /*
+ * Major/minor macros.  Minor version is in LSB, meaning that earlier flat
+ * version numbers will be interpreted as "0.x" (i.e., 1 becomes 0.1).
+ */
+
+static inline u16 storvsc_get_version(u8 major, u8 minor)
+{
+	u16 version;
+
+	version = ((major << 8) | minor);
+	return version;
+}
+
+/*
  * We can get incoming messages from the host that are not in response to
  * messages that we have sent out. An example of this would be messages
  * received by the guest to notify dynamic addition/removal of LUNs. To
-- 
1.7.4.1
