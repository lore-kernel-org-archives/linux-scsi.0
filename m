From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: ufs: fix integer type usage in uapi header
Date: Fri, 12 Oct 2018 12:41:28 +0200
Message-ID: <20181012104143.1931393-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Avri Altman <avri.altman@wdc.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We get a warning from 'make headers_check' about a newly introduced
usage of integer types in the scsi/scsi_bsg_ufs.h uapi header:

usr/include/scsi/scsi_bsg_ufs.h:18: found __[us]{8,16,32,64} type without #include <linux/types.h>

Aside from the missing linux/types.h inclusion, I also noticed that it
uses the wrong types: 'u32' is not available at all in user space,
and 'uint32_t' depends on the inclusion of a standard header that
we should not include from kernel headers.

Change the all to __u32 and similar types here.

I also note the usage of '__be32' and '__be16' that seems unfortunate
for a user space API. I wonder if it would be better to define the
interface in terms of a CPU-endian structure and convert it in kernel
space.

Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in ufs_bsg_request()")
Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/uapi/scsi/scsi_bsg_ufs.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
index 1b25930688bc..17c7abd0803a 100644
--- a/include/uapi/scsi/scsi_bsg_ufs.h
+++ b/include/uapi/scsi/scsi_bsg_ufs.h
@@ -8,6 +8,7 @@
 #ifndef SCSI_BSG_UFS_H
 #define SCSI_BSG_UFS_H
 
+#include <linux/types.h>
 /*
  * This file intended to be included by both kernel and user space
  */
@@ -15,7 +16,7 @@
 #define UFS_CDB_SIZE	16
 #define UPIU_TRANSACTION_UIC_CMD 0x1F
 /* uic commands are 4DW long, per UFSHCI V2.1 paragraph 5.6.1 */
-#define UIC_CMD_SIZE (sizeof(u32) * 4)
+#define UIC_CMD_SIZE (sizeof(__u32) * 4)
 
 /**
  * struct utp_upiu_header - UPIU header structure
@@ -59,7 +60,7 @@ struct utp_upiu_query {
  */
 struct utp_upiu_cmd {
 	__be32 exp_data_transfer_len;
-	u8 cdb[UFS_CDB_SIZE];
+	__u8 cdb[UFS_CDB_SIZE];
 };
 
 /**
@@ -81,7 +82,7 @@ struct utp_upiu_req {
 
 /* request (CDB) structure of the sg_io_v4 */
 struct ufs_bsg_request {
-	uint32_t msgcode;
+	__u32 msgcode;
 	struct utp_upiu_req upiu_req;
 };
 
@@ -95,10 +96,10 @@ struct ufs_bsg_reply {
 	 * msg and status fields. The per-msgcode reply structure
 	 * will contain valid data.
 	 */
-	uint32_t result;
+	__u32 result;
 
 	/* If there was reply_payload, how much was received? */
-	uint32_t reply_payload_rcv_len;
+	__u32 reply_payload_rcv_len;
 
 	struct utp_upiu_req upiu_rsp;
 };
-- 
2.18.0
