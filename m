From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/2] scsi: target: remove custom hex2bin() implementation
Date: Mon, 18 Jul 2011 11:27:57 +0300
Message-ID: <db7c7ad036769bcc0cd737e0b74136a05e57fc85.1310977653.git.andriy.shevchenko@linux.intel.com>
References: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
References: <f051412fa68688dea6d9445d66fbd8085a07bdb7.1310977653.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c        |   16 ++++------------
 drivers/target/target_core_fabric_lib.c |   17 +++++++----------
 drivers/target/target_core_transport.c  |   28 ----------------------------
 include/target/target_core_transport.h  |    1 -
 4 files changed, 11 insertions(+), 51 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 4dab9f5..a79645e 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -23,6 +23,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include <linux/kernel.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 
@@ -183,11 +184,9 @@ target_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	struct t10_alua_lu_gp_member *lu_gp_mem;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
-	unsigned char binary, binary_new;
 	unsigned char *prod = &DEV_T10_WWN(dev)->model[0];
 	u32 prod_len;
 	u32 unit_serial_len, off = 0;
-	int i;
 	u16 len = 0, id_len;
 
 	buf[1] = 0x83;
@@ -237,16 +236,9 @@ target_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	 * VENDOR_SPECIFIC_IDENTIFIER and
 	 * VENDOR_SPECIFIC_IDENTIFIER_EXTENTION
 	 */
-	binary = transport_asciihex_to_binaryhex(
-				&DEV_T10_WWN(dev)->unit_serial[0]);
-	buf[off++] |= (binary & 0xf0) >> 4;
-	for (i = 0; i < 24; i += 2) {
-		binary_new = transport_asciihex_to_binaryhex(
-			&DEV_T10_WWN(dev)->unit_serial[i+2]);
-		buf[off] = (binary & 0x0f) << 4;
-		buf[off++] |= (binary_new & 0xf0) >> 4;
-		binary = binary_new;
-	}
+	buf[off++] |= hex_to_bin(DEV_T10_WWN(dev)->unit_serial[0]);
+	hex2bin(&buf[off], &DEV_T10_WWN(dev)->unit_serial[1], 12);
+
 	len = 20;
 	off = (len + 4);
 
diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 1e193f3..01d0af0 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -25,6 +25,7 @@
  *
  ******************************************************************************/
 
+#include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
@@ -61,9 +62,8 @@ u32 sas_get_pr_transport_id(
 	int *format_code,
 	unsigned char *buf)
 {
-	unsigned char binary, *ptr;
-	int i;
-	u32 off = 4;
+	unsigned char *ptr;
+
 	/*
 	 * Set PROTOCOL IDENTIFIER to 6h for SAS
 	 */
@@ -74,10 +74,8 @@ u32 sas_get_pr_transport_id(
 	 */
 	ptr = &se_nacl->initiatorname[4]; /* Skip over 'naa. prefix */
 
-	for (i = 0; i < 16; i += 2) {
-		binary = transport_asciihex_to_binaryhex(&ptr[i]);
-		buf[off++] = binary;
-	}
+	hex2bin(&buf[4], ptr, 8);
+
 	/*
 	 * The SAS Transport ID is a hardcoded 24-byte length
 	 */
@@ -157,7 +155,7 @@ u32 fc_get_pr_transport_id(
 	int *format_code,
 	unsigned char *buf)
 {
-	unsigned char binary, *ptr;
+	unsigned char *ptr;
 	int i;
 	u32 off = 8;
 	/*
@@ -176,8 +174,7 @@ u32 fc_get_pr_transport_id(
 			i++;
 			continue;
 		}
-		binary = transport_asciihex_to_binaryhex(&ptr[i]);
-		buf[off++] = binary;
+		hex2bin(&buf[off++], &ptr[i], 1);
 		i += 2;
 	}
 	/*
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4b9b716..20232a6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2907,34 +2907,6 @@ static inline u32 transport_get_size(
 	return DEV_ATTRIB(dev)->block_size * sectors;
 }
 
-unsigned char transport_asciihex_to_binaryhex(unsigned char val[2])
-{
-	unsigned char result = 0;
-	/*
-	 * MSB
-	 */
-	if ((val[0] >= 'a') && (val[0] <= 'f'))
-		result = ((val[0] - 'a' + 10) & 0xf) << 4;
-	else
-		if ((val[0] >= 'A') && (val[0] <= 'F'))
-			result = ((val[0] - 'A' + 10) & 0xf) << 4;
-		else /* digit */
-			result = ((val[0] - '0') & 0xf) << 4;
-	/*
-	 * LSB
-	 */
-	if ((val[1] >= 'a') && (val[1] <= 'f'))
-		result |= ((val[1] - 'a' + 10) & 0xf);
-	else
-		if ((val[1] >= 'A') && (val[1] <= 'F'))
-			result |= ((val[1] - 'A' + 10) & 0xf);
-		else /* digit */
-			result |= ((val[1] - '0') & 0xf);
-
-	return result;
-}
-EXPORT_SYMBOL(transport_asciihex_to_binaryhex);
-
 static void transport_xor_callback(struct se_cmd *cmd)
 {
 	unsigned char *buf, *addr;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 24a1c6c..829ca19 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -174,7 +174,6 @@ extern void transport_new_cmd_failure(struct se_cmd *);
 extern int transport_generic_handle_tmr(struct se_cmd *);
 extern void transport_generic_free_cmd_intr(struct se_cmd *);
 extern void __transport_stop_task_timer(struct se_task *, unsigned long *);
-extern unsigned char transport_asciihex_to_binaryhex(unsigned char val[2]);
 extern int transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *, u32,
 				struct scatterlist *, u32);
 extern int transport_clear_lun_from_sessions(struct se_lun *);
-- 
1.7.5.4
