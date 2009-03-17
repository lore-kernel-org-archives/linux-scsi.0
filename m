From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/14] fcoe: moves common FCoE library API functions to
	libfcoe module
Date: Tue, 17 Mar 2009 11:42:18 -0700
Message-ID: <20090317184218.22987.4843.stgit@fritz>
References: <20090317184124.22987.65368.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:26928 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760173AbZCQSmU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 14:42:20 -0400
In-Reply-To: <20090317184124.22987.65368.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

From: Vasu Dev <vasu.dev@intel.com>

Moves these functions as-is from fcoe.c to libfcoe.c, since
they're are common routines:

	- fcoe_wwn_from_mac
	- fcoe_libfc_config

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c    |   64 -----------------------------------------
 drivers/scsi/fcoe/libfcoe.c |   67 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index af40410..e9c3d26 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1755,47 +1755,6 @@ int fcoe_reset(struct Scsi_Host *shost)
 EXPORT_SYMBOL_GPL(fcoe_reset);
 
 /**
- * fcoe_wwn_from_mac() - Converts 48-bit IEEE MAC address to 64-bit FC WWN.
- * @mac: mac address
- * @scheme: check port
- * @port: port indicator for converting
- *
- * Returns: u64 fc world wide name
- */
-u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
-		      unsigned int scheme, unsigned int port)
-{
-	u64 wwn;
-	u64 host_mac;
-
-	/* The MAC is in NO, so flip only the low 48 bits */
-	host_mac = ((u64) mac[0] << 40) |
-		((u64) mac[1] << 32) |
-		((u64) mac[2] << 24) |
-		((u64) mac[3] << 16) |
-		((u64) mac[4] << 8) |
-		(u64) mac[5];
-
-	WARN_ON(host_mac >= (1ULL << 48));
-	wwn = host_mac | ((u64) scheme << 60);
-	switch (scheme) {
-	case 1:
-		WARN_ON(port != 0);
-		break;
-	case 2:
-		WARN_ON(port >= 0xfff);
-		wwn |= (u64) port << 48;
-		break;
-	default:
-		WARN_ON(1);
-		break;
-	}
-
-	return wwn;
-}
-EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
-
-/**
  * fcoe_hostlist_lookup_softc() - find the corresponding lport by a given device
  * @device: this is currently ptr to net_device
  *
@@ -1875,29 +1834,6 @@ int fcoe_hostlist_remove(const struct fc_lport *lp)
 EXPORT_SYMBOL_GPL(fcoe_hostlist_remove);
 
 /**
- * fcoe_libfc_config() - sets up libfc related properties for lport
- * @lp: ptr to the fc_lport
- * @tt: libfc function template
- *
- * Returns : 0 for success
- */
-int fcoe_libfc_config(struct fc_lport *lp, struct libfc_function_template *tt)
-{
-	/* Set the function pointers set by the LLDD */
-	memcpy(&lp->tt, tt, sizeof(*tt));
-	if (fc_fcp_init(lp))
-		return -ENOMEM;
-	fc_exch_init(lp);
-	fc_elsct_init(lp);
-	fc_lport_init(lp);
-	fc_rport_init(lp);
-	fc_disc_init(lp);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(fcoe_libfc_config);
-
-/**
  * fcoe_init() - fcoe module loading initialization
  *
  * Returns 0 on success, negative on failure
diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 17acbcc..dff97fc 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -18,7 +18,74 @@
  */
 
 #include <linux/module.h>
+#include <linux/netdevice.h>
+
+#include <scsi/libfc.h>
 
 MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("FCoE");
 MODULE_LICENSE("GPL v2");
+
+/**
+ * fcoe_wwn_from_mac() - Converts 48-bit IEEE MAC address to 64-bit FC WWN.
+ * @mac: mac address
+ * @scheme: check port
+ * @port: port indicator for converting
+ *
+ * Returns: u64 fc world wide name
+ */
+u64 fcoe_wwn_from_mac(unsigned char mac[MAX_ADDR_LEN],
+		      unsigned int scheme, unsigned int port)
+{
+	u64 wwn;
+	u64 host_mac;
+
+	/* The MAC is in NO, so flip only the low 48 bits */
+	host_mac = ((u64) mac[0] << 40) |
+		((u64) mac[1] << 32) |
+		((u64) mac[2] << 24) |
+		((u64) mac[3] << 16) |
+		((u64) mac[4] << 8) |
+		(u64) mac[5];
+
+	WARN_ON(host_mac >= (1ULL << 48));
+	wwn = host_mac | ((u64) scheme << 60);
+	switch (scheme) {
+	case 1:
+		WARN_ON(port != 0);
+		break;
+	case 2:
+		WARN_ON(port >= 0xfff);
+		wwn |= (u64) port << 48;
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	return wwn;
+}
+EXPORT_SYMBOL_GPL(fcoe_wwn_from_mac);
+
+/**
+ * fcoe_libfc_config() - sets up libfc related properties for lport
+ * @lp: ptr to the fc_lport
+ * @tt: libfc function template
+ *
+ * Returns : 0 for success
+ */
+int fcoe_libfc_config(struct fc_lport *lp, struct libfc_function_template *tt)
+{
+	/* Set the function pointers set by the LLDD */
+	memcpy(&lp->tt, tt, sizeof(*tt));
+	if (fc_fcp_init(lp))
+		return -ENOMEM;
+	fc_exch_init(lp);
+	fc_elsct_init(lp);
+	fc_lport_init(lp);
+	fc_rport_init(lp);
+	fc_disc_init(lp);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fcoe_libfc_config);

