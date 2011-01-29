From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 19/28] libfcoe: add fcoe_transport structure defines to
	include/scsi/libfcoe.h
Date: Fri, 28 Jan 2011 16:04:50 -0800
Message-ID: <20110129000450.1784.73372.stgit@localhost6.localdomain6>
References: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10889 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab1A2AEu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:04:50 -0500
In-Reply-To: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

add the fcoe_transport struct to the common libfcoe.h header so all fcoe
transport provides can use it to attach itself as an fcoe transport. This
is the header part, and the next patch will be the transport code itself.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 include/scsi/libfcoe.h |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index feb6a94..efb6ae5 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -231,5 +231,53 @@ static inline bool is_fip_mode(struct fcoe_ctlr *fip)
 	return fip->state == FIP_ST_ENABLED;
 }
 
+/* helper for FCoE SW HBA drivers, can include subven and subdev if needed. The
+ * modpost would use pci_device_id table to auto-generate formatted module alias
+ * into the corresponding .mod.c file, but there may or may not be a pci device
+ * id table for FCoE drivers so we use the following helper for build the fcoe
+ * driver module alias.
+ */
+#define MODULE_ALIAS_FCOE_PCI(ven, dev) \
+	MODULE_ALIAS("fcoe-pci:"	\
+		"v" __stringify(ven)	\
+		"d" __stringify(dev) "sv*sd*bc*sc*i*")
+
+/* the name of the default FCoE transport driver fcoe.ko */
+#define FCOE_TRANSPORT_DEFAULT	"fcoe"
+
+/* struct fcoe_transport - The FCoE transport interface
+ * @name:	a vendor specific name for their FCoE transport driver
+ * @attached:	whether this transport is already attached
+ * @list:	list linkage to all attached transports
+ * @match:	handler to allow the transport driver to match up a given netdev
+ * @create:	handler to sysfs entry of create for FCoE instances
+ * @destroy:	handler to sysfs entry of destroy for FCoE instances
+ * @enable:	handler to sysfs entry of enable for FCoE instances
+ * @disable:	handler to sysfs entry of disable for FCoE instances
+ */
+struct fcoe_transport {
+	char name[IFNAMSIZ];
+	bool attached;
+	struct list_head list;
+	bool (*match) (struct net_device *device);
+	int (*create) (struct net_device *device, enum fip_state fip_mode);
+	int (*destroy) (struct net_device *device);
+	int (*enable) (struct net_device *device);
+	int (*disable) (struct net_device *device);
+};
+
+/**
+ * struct netdev_list
+ * A mapping from netdevice to fcoe_transport
+ */
+struct fcoe_netdev_mapping {
+	struct list_head list;
+	struct net_device *netdev;
+	struct fcoe_transport *ft;
+};
+
+/* fcoe transports registration and deregistration */
+int fcoe_transport_attach(struct fcoe_transport *ft);
+int fcoe_transport_detach(struct fcoe_transport *ft);
 
 #endif /* _LIBFCOE_H */

