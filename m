From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 2/8] libfcoe: add fcoe_transport structure defines to
 include/scsi/libfcoe.h
Date: Thu, 23 Dec 2010 21:18:23 -0800
Message-ID: <1293167903.4676.461.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4561 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab0LXFSu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 00:18:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, yi.zou@intel.com, michaelc@cs.wisc.edu


From: Yi Zou <yi.zou@intel.com>

add the fcoe_transport struct to the common libfcoe.h header so all fcoe
transport provides can use it to attach itself as an fcoe transport.
This
is the header part, and the next patch will be the transport code
itself.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 include/scsi/libfcoe.h |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index feb6a94..79a64ec 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -231,5 +231,42 @@ static inline bool is_fip_mode(struct fcoe_ctlr
*fip)
 	return fip->state == FIP_ST_ENABLED;
 }
 
+/* helper for FCoE SW HBA drivers, can include subven and subdev if
needed. The
+ * modpost would use pci_device_id table to auto-generate formatted
module alias
+ * into the corresponding .mod.c file, but there may or may not be a
pci device
+ * id table for FCoE drivers so we use the following helper for build
the fcoe
+ * driver module alias.
+ */
+#define MODULE_ALIAS_FCOE_PCI(ven, dev) \
+	MODULE_ALIAS("fcoe-pci:"	\
+		"v" __stringify(ven)	\
+		"d" __stringify(dev) "sv*sd*bc*sc*i*")
+
+/* struct fcoe_transport - The FCoE transport interface
+ * @name:	a vendor specific name for their FCoE transport driver
+ * @attached:	whether this transport is already attached
+ * @is_vendor:	whether from vendor or the default Open-FCoE fcoe driver
+ * @list:	list linkage to all attached transports
+ * @match:	handler to allow the transport to match up a given netdev
+ * @create:	handler to sysfs entry of create for FCoE instances
+ * @destroy:	handler to sysfs entry of destory for FCoE instances
+ * @enable:	handler to sysfs entry of enable for FCoE instances
+ * @disable:	handler to sysfs entry of disable for FCoE instances
+ */
+struct fcoe_transport {
+	char name[IFNAMSIZ];
+	bool attached;
+	bool is_vendor;
+	struct list_head list;
+	bool (*match) (struct net_device *device);
+	int (*create) (struct net_device *device, enum fip_state fip_mode);
+	int (*destroy) (struct net_device *device);
+	int (*enable) (struct net_device *device);
+	int (*disable) (struct net_device *device);
+};
+
+/* fcoe transports registration and deregistration */
+int fcoe_transport_attach(struct fcoe_transport *ft);
+int fcoe_transport_detach(struct fcoe_transport *ft);
 
 #endif /* _LIBFCOE_H */
-- 
1.7.0.6




