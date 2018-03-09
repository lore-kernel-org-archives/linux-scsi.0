From: Stephen Kitt <steve@sk2.org>
Subject: [PATCH] scsi: resolve COMMAND_SIZE at compile time
Date: Fri,  9 Mar 2018 23:33:55 +0100
Message-ID: <20180309223355.21222-1-steve@sk2.org>
References: <20180309232933.14e39858@heffalump.sk2.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180309232933.14e39858@heffalump.sk2.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hare@suse.com, axboe@kernel.dk, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Stephen Kitt <steve@sk2.org>
List-Id: linux-scsi@vger.kernel.org

COMMAND_SIZE currently uses an array of values in block/scsi_ioctl.c.
A number of device_handler functions use this to initialise arrays,
and this is flagged by -Wvla.

This patch replaces COMMAND_SIZE with a variant using a formula which
can be resolved at compile time in cases where the opcode is fixed,
resolving the array size and avoiding the VLA. The downside is that
the code is less maintainable and that some call sites end up having
more complex generated code.

Since scsi_command_size_tbl is dropped, we can remove the dependency
on BLK_SCSI_REQUEST from drivers/target/Kconfig.

This was prompted by https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 block/scsi_ioctl.c         |  8 --------
 drivers/target/Kconfig     |  1 -
 include/scsi/scsi_common.h | 13 +++++++++++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 60b471f8621b..b9e176e537be 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -41,14 +41,6 @@ struct blk_cmd_filter {
 
 static struct blk_cmd_filter blk_default_cmd_filter;
 
-/* Command group 3 is reserved and should never be used.  */
-const unsigned char scsi_command_size_tbl[8] =
-{
-	6, 10, 10, 12,
-	16, 12, 10, 10
-};
-EXPORT_SYMBOL(scsi_command_size_tbl);
-
 #include <scsi/sg.h>
 
 static int sg_get_version(int __user *p)
diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 4c44d7bed01a..b5f05b60cf06 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -4,7 +4,6 @@ menuconfig TARGET_CORE
 	depends on SCSI && BLOCK
 	select CONFIGFS_FS
 	select CRC_T10DIF
-	select BLK_SCSI_REQUEST # only for scsi_command_size_tbl..
 	select SGL_ALLOC
 	default n
 	help
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 731ac09ed231..48d950666376 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -15,8 +15,17 @@ scsi_varlen_cdb_length(const void *hdr)
 	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
 }
 
-extern const unsigned char scsi_command_size_tbl[8];
-#define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
+/*
+ * SCSI command sizes are as follows, in bytes, for fixed size commands, per
+ * group: 6, 10, 10, 12, 16, 12, 10, 10. The top three bits of an opcode
+ * determine its group.
+ * The size table is encoded into a 32-bit value by subtracting each value
+ * from 16, resulting in a value of 1715488362
+ * (6 << 28 + 6 << 24 + 4 << 20 + 0 << 16 + 4 << 12 + 6 << 8 + 6 << 4 + 10).
+ * Command group 3 is reserved and should never be used.
+ */
+#define COMMAND_SIZE(opcode) \
+	(16 - (15 & (1715488362 >> (4 * (((opcode) >> 5) & 7)))))
 
 static inline unsigned
 scsi_command_size(const unsigned char *cmnd)
-- 
2.11.0
