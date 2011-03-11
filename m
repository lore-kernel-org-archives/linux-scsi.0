From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 09/10] fc: Add a hbaapi_lib attribute to the fcport
	structure
Date: Fri, 11 Mar 2011 13:55:16 -0800
Message-ID: <20110311215516.18760.39185.stgit@localhost6.localdomain6>
References: <20110311215428.18760.80632.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8627 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655Ab1CKVz1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Mar 2011 16:55:27 -0500
In-Reply-To: <20110311215428.18760.80632.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, giridhar.malavali@qlogic.com, james.smart@emulex.com, bprakash@broadcom.com

Currently, libhbalinux, a LGPL implementation of the
HBAAPI interface relies on the sub-string " over " in
the host's symbolic_name to determine if the library
is responsible for the driver. This is obviously error
prone, so this patch adds a new attribute so the LLD
can specify it's HBAAPI library.

Since both fcoe and fnic use libhbalinux I've update
those drivers to use this new attribute.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/fc/fcport.c      |    2 ++
 drivers/scsi/fcoe/fcoe.c |    4 ++++
 include/fc/fc.h          |   10 +++++++++-
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/fc/fcport.c b/drivers/fc/fcport.c
index 299f220..2a6cd5d 100644
--- a/drivers/fc/fcport.c
+++ b/drivers/fc/fcport.c
@@ -113,6 +113,7 @@ static FC_DEVICE_ATTR(fcport, speed, S_IRUGO, show_port_speed, NULL);
 
 fc_port_rd_attr(maxframe_size, "%u bytes\n", 20);
 fc_port_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE + 1));
+fc_port_rd_attr(hbaapi_lib, "%s\n", (FC_HBAAPI_LIB_SIZE + 1));
 
 /* used by supported_speeds */
 static ssize_t show_port_supported_speeds(struct device *dev,
@@ -312,6 +313,7 @@ struct fc_port *fc_port_add(struct device *pdev,
 	FC_SETUP_COND_ATTR_RD(fcport, supported_classes);
 	FC_SETUP_COND_ATTR_RD(fcport, serial_number);
 	FC_SETUP_COND_ATTR_RD(fcport, speed);
+	FC_SETUP_COND_ATTR_RD(fcport, hbaapi_lib);
 
 	BUG_ON(count > FC_PORT_NUM_ATTRS);
 	FC_CREATE_ATTRS(fcport, count);
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 8603b8c..230f047 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -195,6 +195,7 @@ struct fc_port_function_template fcoe_fcport_fcn_tmpl = {
 	.show_fcport_supported_fc4s = 1,
 	.show_fcport_active_fc4s = 1,
 	.show_fcport_serial_number = 1,
+	.show_fcport_hbaapi_lib = 1,
 
 	.dd_fcport_size = sizeof(struct fcoe_interface),
 
@@ -442,6 +443,9 @@ static struct fcoe_interface *fcoe_interface_create(struct net_device *netdev,
 		goto out;
  	}
 
+	strncpy(fc_port_hbaapi_lib(fcport), LIBHBALINUX,
+		strlen(LIBHBALINUX));
+
 	fcoe = fc_port_priv(fcport);
 
 	dev_hold(netdev);
diff --git a/include/fc/fc.h b/include/fc/fc.h
index 6158095..270be37 100644
--- a/include/fc/fc.h
+++ b/include/fc/fc.h
@@ -359,7 +359,7 @@ struct _fc_cos_names {
 #define	dev_to_fcrport(d)			\
 	container_of((d), struct fc_rport, dev)
 
-#define FC_PORT_NUM_ATTRS    9
+#define FC_PORT_NUM_ATTRS   10
 #define FC_VPORT_NUM_ATTRS  16
 #define FC_RPORT_NUM_ATTRS   9
 #define FC_FABRIC_NUM_ATTRS  6
@@ -591,6 +591,9 @@ static inline void *fc_fabric_priv(const struct fc_fabric *fcfabric)
 #define fcfabric_to_fcport(x)			\
 	dev_to_fcport((x)->dev.parent)
 
+#define FC_HBAAPI_LIB_SIZE 80
+#define LIBHBALINUX        "libhbalinux"
+
 struct fc_port_function_template {
 	void (*get_fcport_speed)(struct fc_port *);
 	void (*get_fcport_active_fc4s)(struct fc_port *);
@@ -605,6 +608,7 @@ struct fc_port_function_template {
 	unsigned long show_fcport_active_fc4s:1;
 	unsigned long show_fcport_supported_classes:1;
 	unsigned long show_fcport_serial_number:1;
+	unsigned long show_fcport_hbaapi_lib:1;
 
 	u32 dd_fcport_size;
 
@@ -640,6 +644,8 @@ struct fc_port {
 	u32  maxframe_size;
 	u32  supported_classes;
 	char serial_number[FC_SERIAL_NUMBER_SIZE];
+	char hbaapi_lib[FC_HBAAPI_LIB_SIZE];
+
 
 	/* Dynamic Attributes*/
 	u8 active_fc4s[FC_FC4_LIST_SIZE];
@@ -690,6 +696,8 @@ static inline void *fc_port_priv(const struct fc_port *fcport)
 	((x)->supported_classes)
 #define fc_port_serial_number(x)		\
 	((x)->serial_number)
+#define fc_port_hbaapi_lib(x)			\
+	((x)->hbaapi_lib)
 
 /*
  * FC Virtual Port Attributes

