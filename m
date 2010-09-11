From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] lio-target: Add support for Intel Nehalem crc32-intel libcrypto offload
Date: Sat, 11 Sep 2010 03:31:37 -0700
Message-ID: <1284201097-22403-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>, Vasu Dev <vasu.dev@linux.intel.com>, Joe Eykholt <jeykholt@cisco.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for the Nehalem crc32-intel libcrypto offload instructions
available from arch/x86/crypto/crc32c-intel.c code.  This main part of this
patch moves struct conn->conn_rx_hash and struct conn->conn_tx_hash setup logic
into iscsi_login_setup_crypto(), which now gets called from iscsi_target_nego.c:
iscsi_target_locate_portal() in order to check the new configfs attribute located
at ISCSI_TPG_ATTRIB(tpg)->crc32c_x86_offload.

By default the crc32c_x86_offload attrib is currently disabled for LIO v4.0.0-rc
testing.  So far using crc32c_x86_offload=1 with crc32c-intel there are i686 and
x86_64 VMs connecting and successfully moving iSCSI I/O with existing Open-iSCSI
libcrc32c code.  However, using Open-iSCSI in RHEL 6 B2 x86_64 with HeaderDigest=CRC32C
currently results in reproducable HeaderDigest failures on the LIO-Target RX path
during the initial Linux/SCSI Initiator side LUN scan.  It is for this reason that
crc32c_x86_offload=0 is the current default, but as the crc32c-intel instructions
are validated with Initiators using legacy slicing by 1X CRC32C software algorithms,
the default will be changed to crc32c_x86_offload=1 on CPUs supporting this instruction.

Also note that this patch currently requires access to bare-metal in order to
function, as the required Intel SSE4.2 instruction are currently not emulated
/ directly available within QEMU-KVM guest.  So far this patch has been tested
with 1 Gb/sec iSCSI ports using v2.6.36-rc3 on 5520 CPUs to existing Open-iSCSI
libcrc32c clients.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/lio-target/iscsi_target_configfs.c |    6 +++
 drivers/target/lio-target/iscsi_target_core.h     |    4 ++
 drivers/target/lio-target/iscsi_target_login.c    |   43 ++++++++++++++++++++-
 drivers/target/lio-target/iscsi_target_login.h    |    1 +
 drivers/target/lio-target/iscsi_target_nego.c     |   17 ++++++++-
 drivers/target/lio-target/iscsi_target_tpg.c      |   19 +++++++++
 drivers/target/lio-target/iscsi_target_tpg.h      |    1 +
 7 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/drivers/target/lio-target/iscsi_target_configfs.c b/drivers/target/lio-target/iscsi_target_configfs.c
index 0877837..5eb04b4 100644
--- a/drivers/target/lio-target/iscsi_target_configfs.c
+++ b/drivers/target/lio-target/iscsi_target_configfs.c
@@ -927,6 +927,11 @@ TPG_ATTR(demo_mode_write_protect, S_IRUGO | S_IWUSR);
  */
 DEF_TPG_ATTRIB(prod_mode_write_protect);
 TPG_ATTR(prod_mode_write_protect, S_IRUGO | S_IWUSR);
+/*
+ * Define iscsi_tpg_attrib_s_crc32c_x86_offload
+ */
+DEF_TPG_ATTRIB(crc32c_x86_offload);
+TPG_ATTR(crc32c_x86_offload, S_IRUGO | S_IWUSR);
 
 static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_authentication.attr,
@@ -937,6 +942,7 @@ static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_cache_dynamic_acls.attr,
 	&iscsi_tpg_attrib_demo_mode_write_protect.attr,
 	&iscsi_tpg_attrib_prod_mode_write_protect.attr,
+	&iscsi_tpg_attrib_crc32c_x86_offload.attr,
 	NULL,
 };
 
diff --git a/drivers/target/lio-target/iscsi_target_core.h b/drivers/target/lio-target/iscsi_target_core.h
index 586e14e..0673d2c 100644
--- a/drivers/target/lio-target/iscsi_target_core.h
+++ b/drivers/target/lio-target/iscsi_target_core.h
@@ -83,6 +83,8 @@
 #define TA_DEMO_MODE_WRITE_PROTECT	1
 /* Disabled by default in production mode w/ explict ACLs */
 #define TA_PROD_MODE_WRITE_PROTECT	0
+/* Disabled by default for the moment for testing... */
+#define TA_CRC32C_X86_OFFLOAD		0
 #define TA_CACHE_CORE_NPS		0
 
 /* struct iscsi_data_count->type */
@@ -777,6 +779,8 @@ struct iscsi_tpg_attrib {
 	u32			default_cmdsn_depth;
 	u32			demo_mode_write_protect;
 	u32			prod_mode_write_protect;
+	/* Used to signal libcrypto crc32-intel offload instruction usage */
+	u32			crc32c_x86_offload;
 	u32			cache_core_nps;
 	struct iscsi_portal_group *tpg;
 }  ____cacheline_aligned;
diff --git a/drivers/target/lio-target/iscsi_target_login.c b/drivers/target/lio-target/iscsi_target_login.c
index a51296d..7c8500d 100644
--- a/drivers/target/lio-target/iscsi_target_login.c
+++ b/drivers/target/lio-target/iscsi_target_login.c
@@ -79,8 +79,49 @@ static int iscsi_login_init_conn(struct iscsi_conn *conn)
 	spin_lock_init(&conn->nopin_timer_lock);
 	spin_lock_init(&conn->response_queue_lock);
 	spin_lock_init(&conn->state_lock);
+
+	return 0;
+}
+
+/*
+ * Used by iscsi_target_nego.c:iscsi_target_locate_portal() to setup
+ * per struct iscsi_conn libcrypto contexts for crc32c and crc32-intel
+ */
+int iscsi_login_setup_crypto(struct iscsi_conn *conn)
+{
+	struct iscsi_portal_group *tpg = conn->tpg;
+#ifdef CONFIG_X86
+	/*
+	 * Check for the Nehalem optimized crc32c-intel instructions
+	 * This is only currently available while running on bare-metal,
+	 * and is not yet available with QEMU-KVM guests.
+	 */
+	if (cpu_has_xmm4_2 && ISCSI_TPG_ATTRIB(tpg)->crc32c_x86_offload) {
+		conn->conn_rx_hash.flags = 0;
+		conn->conn_rx_hash.tfm = crypto_alloc_hash("crc32c-intel", 0,
+						CRYPTO_ALG_ASYNC);
+		if (IS_ERR(conn->conn_rx_hash.tfm)) {
+			printk(KERN_ERR "crypto_alloc_hash() failed for conn_rx_tfm\n");
+			goto check_crc32c;
+		}
+
+		conn->conn_tx_hash.flags = 0;
+		conn->conn_tx_hash.tfm = crypto_alloc_hash("crc32c-intel", 0,
+						CRYPTO_ALG_ASYNC);
+		if (IS_ERR(conn->conn_tx_hash.tfm)) {   
+			printk(KERN_ERR "crypto_alloc_hash() failed for conn_tx_tfm\n");
+			crypto_free_hash(conn->conn_rx_hash.tfm);
+			goto check_crc32c;
+		}
+
+		printk(KERN_INFO "LIO-Target[0]: Using Nehalem crc32c-intel"
+					" offload instructions\n");
+		return 0;
+	}
+check_crc32c:
+#endif /* CONFIG_X86 */
 	/*
-	 * Setup the RX and TX libcrypto contexts
+	 * Setup slicing by 1x CRC32C algorithm for RX and TX libcrypto contexts
 	 */
 	conn->conn_rx_hash.flags = 0;
 	conn->conn_rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
diff --git a/drivers/target/lio-target/iscsi_target_login.h b/drivers/target/lio-target/iscsi_target_login.h
index 1227fd0..c6d56c2 100644
--- a/drivers/target/lio-target/iscsi_target_login.h
+++ b/drivers/target/lio-target/iscsi_target_login.h
@@ -1,6 +1,7 @@
 #ifndef ISCSI_TARGET_LOGIN_H
 #define ISCSI_TARGET_LOGIN_H
 
+extern int iscsi_login_setup_crypto(struct iscsi_conn *);
 extern int iscsi_check_for_session_reinstatement(struct iscsi_conn *);
 extern int iscsi_login_post_auth_non_zero_tsih(struct iscsi_conn *, u16, u32);
 extern int iscsi_target_login_thread(void *);
diff --git a/drivers/target/lio-target/iscsi_target_nego.c b/drivers/target/lio-target/iscsi_target_nego.c
index 8f28993..64185e6 100644
--- a/drivers/target/lio-target/iscsi_target_nego.c
+++ b/drivers/target/lio-target/iscsi_target_nego.c
@@ -753,6 +753,14 @@ static int iscsi_target_locate_portal(
 
 		SESS_OPS(sess)->SessionType = 1;
 		/*
+ 		 * Setup crc32c modules from libcrypto
+		 */
+		if (iscsi_login_setup_crypto(conn) < 0) {
+			printk(KERN_ERR "iscsi_login_setup_crypto() failed\n");
+			ret = -1;
+			goto out;
+		}
+		/*
 		 * Serialize access across the discovery struct iscsi_portal_group to
 		 * process login attempt.
 		 */
@@ -805,7 +813,14 @@ get_target:
 		goto out;
 	}
 	printk(KERN_INFO "Located Portal Group Object: %hu\n", conn->tpg->tpgt);
-
+	/*
+	 * Setup crc32c modules from libcrypto
+	 */
+	if (iscsi_login_setup_crypto(conn) < 0) {
+		printk(KERN_ERR "iscsi_login_setup_crypto() failed\n");
+		ret = -1;
+		goto out;
+	}
 	/*
 	 * Serialize access across the struct iscsi_portal_group to
 	 * process login attempt.
diff --git a/drivers/target/lio-target/iscsi_target_tpg.c b/drivers/target/lio-target/iscsi_target_tpg.c
index 7dd38f8..13fab0e 100644
--- a/drivers/target/lio-target/iscsi_target_tpg.c
+++ b/drivers/target/lio-target/iscsi_target_tpg.c
@@ -465,6 +465,7 @@ static void iscsi_set_default_tpg_attribs(struct iscsi_portal_group *tpg)
 	a->cache_dynamic_acls = TA_CACHE_DYNAMIC_ACLS;
 	a->demo_mode_write_protect = TA_DEMO_MODE_WRITE_PROTECT;
 	a->prod_mode_write_protect = TA_PROD_MODE_WRITE_PROTECT;
+	a->crc32c_x86_offload = TA_CRC32C_X86_OFFLOAD;
 	a->cache_core_nps = TA_CACHE_CORE_NPS;
 }
 
@@ -1102,6 +1103,24 @@ int iscsi_ta_prod_mode_write_protect(
 	return 0;
 }
 
+int iscsi_ta_crc32c_x86_offload(
+	struct iscsi_portal_group *tpg,
+	u32 flag)
+{
+	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
+
+	if ((flag != 0) && (flag != 1)) {
+		printk(KERN_ERR "Illegal value %d\n", flag);
+		return -EINVAL;
+	}
+
+	a->crc32c_x86_offload = flag;
+	printk(KERN_INFO "iSCSI_TPG[%hu] - CRC32C x86 Offload: %s\n",
+		tpg->tpgt, (a->crc32c_x86_offload) ? "ON" : "OFF");
+
+	return 0;
+}
+
 void iscsi_disable_tpgs(struct iscsi_tiqn *tiqn)
 {
 	struct iscsi_portal_group *tpg;
diff --git a/drivers/target/lio-target/iscsi_target_tpg.h b/drivers/target/lio-target/iscsi_target_tpg.h
index 2553707..bcdfacb 100644
--- a/drivers/target/lio-target/iscsi_target_tpg.h
+++ b/drivers/target/lio-target/iscsi_target_tpg.h
@@ -53,6 +53,7 @@ extern int iscsi_ta_default_cmdsn_depth(struct iscsi_portal_group *, u32);
 extern int iscsi_ta_cache_dynamic_acls(struct iscsi_portal_group *, u32);
 extern int iscsi_ta_demo_mode_write_protect(struct iscsi_portal_group *, u32);
 extern int iscsi_ta_prod_mode_write_protect(struct iscsi_portal_group *, u32);
+extern int iscsi_ta_crc32c_x86_offload(struct iscsi_portal_group *, u32);
 extern void iscsi_disable_tpgs(struct iscsi_tiqn *);
 extern void iscsi_disable_all_tpgs(void);
 extern void iscsi_remove_tpgs(struct iscsi_tiqn *);
-- 
1.5.6.5
