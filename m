From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: offer SAM-conforming target port ID in sysfs
Date: Sun, 27 May 2007 13:17:15 +0200 (CEST)
Message-ID: <tkrat.7981156a8f9611cc@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:35895 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXE0LRW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 May 2007 07:17:22 -0400
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

With "modprobe sbp2 long_ieee1394_id=y", the format of
/sys/bus/scsi/devices/*:*:*:*/ieee1394_id is changed from e.g.
0001041010004beb:0:0 to 0001041010004beb:00042c:0000.

The longer format fully conforms to object identifier sizes as per
SAM(-2...4) and reflects what the SAM target port identifier is meant to
contain:  A Discovery ID allegedly specified by ISO/IEC 13213:1994 ---
however there is no such thing; the authors of SAM probably meant
Directory ID).  Especially target nodes with multiple dynamically added
targets may use Directory IDs to persistently identify target ports.

The new format is independent of implementation details of nodemgr.
Thus the same ieee1394_id attribute format can be implemented in the new
firewire stack.

The ieee1394_id is typically used to create persistently named links in
/dev/disk/by-id.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Requires patch 'ieee1394: fix calculation of sysfs attribute "address"'.

 drivers/ieee1394/nodemgr.c |    5 +++++
 drivers/ieee1394/nodemgr.h |    1 +
 drivers/ieee1394/sbp2.c    |   32 ++++++++++++++++++++++++++++++--
 3 files changed, 36 insertions(+), 2 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -194,6 +194,28 @@ MODULE_PARM_DESC(workarounds, "Work arou
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
+/*
+ * This influences the format of the sysfs attribute
+ * /sys/bus/scsi/devices/.../ieee1394_id.
+ *
+ * The default format is like in older kernels:  %016Lx:%d:%d
+ * It contains the target's EUI-64, a number given to the logical unit by
+ * the ieee1394 driver's nodemgr (starting at 0), and the LUN.
+ *
+ * The long format is:  %016Lx:%06x:%04x
+ * It contains the target's EUI-64, the unit directory's directory_ID as per
+ * IEEE 1212 clause 7.7.19, and the LUN.  This format comes closest to the
+ * format of SBP(-3) target port and logical unit identifier as per SAM (SCSI
+ * Architecture Model) rev.2 to 4 annex A.  Therefore and because it is
+ * independent of the implementation of the ieee1394 nodemgr, the longer format
+ * is recommended for future use.
+ *
+ */
+static int sbp2_long_sysfs_ieee1394_id;
+module_param_named(long_ieee1394_id, sbp2_long_sysfs_ieee1394_id, bool, 0644);
+MODULE_PARM_DESC(long_ieee1394_id, "8+3+2 bytes format of ieee1394_id in sysfs "
+		 "(default = backwards-compatible = N, SAM-conforming = Y)");
+
 
 #define SBP2_INFO(fmt, args...)	HPSB_INFO("sbp2: "fmt, ## args)
 #define SBP2_ERR(fmt, args...)	HPSB_ERR("sbp2: "fmt, ## args)
@@ -2100,8 +2122,14 @@ static ssize_t sbp2_sysfs_ieee1394_id_sh
 	if (!(lu = (struct sbp2_lu *)sdev->host->hostdata[0]))
 		return 0;
 
-	return sprintf(buf, "%016Lx:%d:%d\n", (unsigned long long)lu->ne->guid,
-		       lu->ud->id, ORB_SET_LUN(lu->lun));
+	if (sbp2_long_sysfs_ieee1394_id)
+		return sprintf(buf, "%016Lx:%06x:%04x\n",
+				(unsigned long long)lu->ne->guid,
+				lu->ud->directory_id, ORB_SET_LUN(lu->lun));
+	else
+		return sprintf(buf, "%016Lx:%d:%d\n",
+				(unsigned long long)lu->ne->guid,
+				lu->ud->id, ORB_SET_LUN(lu->lun));
 }
 
 MODULE_AUTHOR("Ben Collins <bcollins@debian.org>");
Index: linux/drivers/ieee1394/nodemgr.c
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.c
+++ linux/drivers/ieee1394/nodemgr.c
@@ -977,6 +977,7 @@ static struct unit_directory *nodemgr_pr
 	ud->ne = ne;
 	ud->ignore_driver = ignore_drivers;
 	ud->address = ud_kv->offset + CSR1212_REGISTER_SPACE_BASE;
+	ud->directory_id = ud->address & 0xffffff;
 	ud->ud_kv = ud_kv;
 	ud->id = (*id)++;
 
@@ -1085,6 +1086,10 @@ static struct unit_directory *nodemgr_pr
 
 			break;
 
+		case CSR1212_KV_ID_DIRECTORY_ID:
+			ud->directory_id = kv->value.immediate;
+			break;
+
 		default:
 			break;
 		}
Index: linux/drivers/ieee1394/nodemgr.h
===================================================================
--- linux.orig/drivers/ieee1394/nodemgr.h
+++ linux/drivers/ieee1394/nodemgr.h
@@ -75,6 +75,7 @@ struct unit_directory {
 	struct csr1212_keyval *model_name_kv;
 	quadlet_t specifier_id;
 	quadlet_t version;
+	quadlet_t directory_id;
 
 	unsigned int id;
 

-- 
Stefan Richter
-=====-=-=== -=-= ==-==
http://arcgraph.de/sr/

