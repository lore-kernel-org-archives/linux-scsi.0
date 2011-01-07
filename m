From: Yi Zou <yi.zou@intel.com>
Subject: [RFC PATCH v2 2/8] libfcoe: add fcoe_transport structure defines to
	include/scsi/libfcoe.h
Date: Fri, 07 Jan 2011 09:42:45 -0800
Message-ID: <20110107174242.14631.21930.stg.yi.zou@intel.com>
References: <20110107174027.14631.47077.stg.yi.zou@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31867 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab1AGRpb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jan 2011 12:45:31 -0500
In-Reply-To: <20110107174027.14631.47077.stg.yi.zou@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: bprakash@broadcom.com, linux-scsi@vger.kernel.org

add the fcoe_transport struct to the common libfcoe.h header so all fcoe
transport provides can use it to attach itself as an fcoe transport. This
is the header part, and the next patch will be the transport code itself.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---

 include/scsi/libfcoe.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index feb6a94..c0bf07c 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -231,5 +231,48 @@ static inline bool is_fip_mode(struct fcoe_ctlr *fip)
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
+/* struct fcoe_transport - The FCoE transport interface
+ * @name:	a vendor specific name for their FCoE transport driver
+ * @attached:	whether this transport is already attached
+ * @list:	list linkage to all attached transports
+ * @create:	handler to sysfs entry of create for FCoE instances
+ * @destroy:	handler to sysfs entry of destroy for FCoE instances
+ * @enable:	handler to sysfs entry of enable for FCoE instances
+ * @disable:	handler to sysfs entry of disable for FCoE instances
+ */
+struct fcoe_transport {
+	char name[IFNAMSIZ];
+	bool attached;
+	struct list_head list;
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

