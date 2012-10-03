From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] scsi_transport_fc: Add sysfs entry for HBA API management
 library
Date: Wed, 03 Oct 2012 13:12:37 -0700
Message-ID: <20121003201237.28626.15887.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:39730 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab2JCUMq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2012 16:12:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, james.smart@emulex.com
Cc: devel@open-fcoe.org

The user space HBA API vendor libraries need to know which HBA/CNAs
hosts to manage. Currently, libhbalinux is used to manage a few drivers
that use libfcoe and libfc. Right now libhbalinux keys off of the
string " over " in the FC Host's symbolic_name attribute to determine
if it should manage a given host. fnic, bnx2fc and fcoe/netdev based
hosts all use " over " in their symboic_names and that is currently
what libhbalinux looks for to determine if it should manage hosts
created by those drivers.

Clearly using " over " in the symbolic_name isn't descriptive
and it is an awkward way to determine whether libhbalinux should
manage a host. Also, drivers may wish to use more descriptive
and accurate symbolic_names because these strings are displayed
in fabric management applications; forcing them to use " over "
in their symbolic_name is unnecessarily restrictive.

This patch adds a read-only attribute to the FC Host that will expose
which management library should be used to manage it.

This attribute will not be present in sysfs for drivers that
do no implement the .show_hbaapi_lib routine.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    4 ++++
 drivers/scsi/fcoe/fcoe.c          |    4 ++++
 drivers/scsi/fnic/fnic_main.c     |    4 ++++
 drivers/scsi/scsi_transport_fc.c  |    5 ++++-
 include/scsi/libfc.h              |    2 ++
 include/scsi/scsi_transport_fc.h  |    4 ++++
 6 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index ae1cb76..97f60d8 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -731,6 +731,9 @@ static int bnx2fc_shost_config(struct fc_lport *lport, struct device *dev)
 		BNX2FC_NAME, BNX2FC_VERSION,
 		interface->netdev->name);
 
+	strncpy(fc_host_hbaapi_library(lport->host), FC_LIBHBALINUX_NAME,
+		FC_SYMBOLIC_NAME_SIZE);
+
 	return 0;
 }
 
@@ -2583,6 +2586,7 @@ static struct fc_function_template bnx2fc_transport_function = {
 	.get_host_port_state = fc_get_host_port_state,
 	.show_host_port_state = 1,
 	.show_host_symbolic_name = 1,
+	.show_host_hbaapi_library = 1,
 
 	.dd_fcrport_size = (sizeof(struct fc_rport_libfc_priv) +
 				sizeof(struct bnx2fc_rport)),
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 078d262..812876f 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -201,6 +201,7 @@ static struct fc_function_template fcoe_nport_fc_functions = {
 	.get_host_port_state = fc_get_host_port_state,
 	.show_host_port_state = 1,
 	.show_host_symbolic_name = 1,
+	.show_host_hbaapi_library = 1,
 
 	.dd_fcrport_size = sizeof(struct fc_rport_libfc_priv),
 	.show_rport_maxframe_size = 1,
@@ -755,6 +756,9 @@ static int fcoe_shost_config(struct fc_lport *lport, struct device *dev)
 		 "%s v%s over %s", FCOE_NAME, FCOE_VERSION,
 		 fcoe_netdev(lport)->name);
 
+	strncpy(fc_host_hbaapi_library(lport->host), FC_LIBHBALINUX_NAME,
+		FC_SYMBOLIC_NAME_SIZE);
+
 	return 0;
 }
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index fc98eb6..783bd3d 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -138,6 +138,7 @@ static struct fc_function_template fnic_fc_functions = {
 	.get_host_port_state = fc_get_host_port_state,
 	.show_host_port_state = 1,
 	.show_host_symbolic_name = 1,
+	.show_host_hbaapi_library = 1,
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
 	.show_host_fabric_name = 1,
@@ -704,6 +705,9 @@ static int __devinit fnic_probe(struct pci_dev *pdev,
 	sprintf(fc_host_symbolic_name(lp->host),
 		DRV_NAME " v" DRV_VERSION " over %s", fnic->name);
 
+	strncpy(fc_host_hbaapi_library(lp->host), FC_LIBHBALINUX_NAME,
+		FC_SYMBOLIC_NAME_SIZE);
+
 	spin_lock_irqsave(&fnic_list_lock, flags);
 	list_add_tail(&fnic->list, &fnic_list);
 	spin_unlock_irqrestore(&fnic_list_lock, flags);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e894ca7..ed19b42 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -313,7 +313,7 @@ static void fc_scsi_scan_rport(struct work_struct *work);
 #define FC_STARGET_NUM_ATTRS 	3
 #define FC_RPORT_NUM_ATTRS	10
 #define FC_VPORT_NUM_ATTRS	9
-#define FC_HOST_NUM_ATTRS	29
+#define FC_HOST_NUM_ATTRS	30
 
 struct fc_internal {
 	struct scsi_transport_template t;
@@ -422,6 +422,7 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 	fc_host->speed = FC_PORTSPEED_UNKNOWN;
 	fc_host->fabric_name = -1;
 	memset(fc_host->symbolic_name, 0, sizeof(fc_host->symbolic_name));
+	memset(fc_host->hbaapi_library, 0, sizeof(fc_host->hbaapi_library));
 	memset(fc_host->system_hostname, 0, sizeof(fc_host->system_hostname));
 
 	fc_host->tgtid_bind_type = FC_TGTID_BIND_BY_WWPN;
@@ -1529,6 +1530,7 @@ fc_private_host_rd_attr(max_npiv_vports, "%u\n", 20);
 fc_private_host_rd_attr(serial_number, "%s\n", (FC_SERIAL_NUMBER_SIZE +1));
 fc_private_host_rd_attr(manufacturer, "%s\n", FC_SERIAL_NUMBER_SIZE + 1);
 fc_private_host_rd_attr(model, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);
+fc_private_host_rd_attr(hbaapi_library, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);
 fc_private_host_rd_attr(model_description, "%s\n", FC_SYMBOLIC_NAME_SIZE + 1);
 fc_private_host_rd_attr(hardware_version, "%s\n", FC_VERSION_STRING_SIZE + 1);
 fc_private_host_rd_attr(driver_version, "%s\n", FC_VERSION_STRING_SIZE + 1);
@@ -2262,6 +2264,7 @@ fc_attach_transport(struct fc_function_template *ft)
 	SETUP_HOST_ATTRIBUTE_RD(speed);
 	SETUP_HOST_ATTRIBUTE_RD(fabric_name);
 	SETUP_HOST_ATTRIBUTE_RD(symbolic_name);
+	SETUP_HOST_ATTRIBUTE_RD(hbaapi_library);
 	SETUP_HOST_ATTRIBUTE_RW(system_hostname);
 
 	/* Transport-managed attributes */
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 399162b..89630cf 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -36,6 +36,8 @@
 
 #include <scsi/fc_frame.h>
 
+#define FC_LIBHBALINUX_NAME "libhbalinux"
+
 #define	FC_FC4_PROV_SIZE	(FC_TYPE_FCP + 1)	/* size of tables */
 
 /*
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index b797e8f..218de08 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -514,6 +514,7 @@ struct fc_host_attrs {
 	u32 speed;
 	u64 fabric_name;
 	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
+	char hbaapi_library[FC_SYMBOLIC_NAME_SIZE];
 	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
 	u32 dev_loss_tmo;
 
@@ -588,6 +589,8 @@ struct fc_host_attrs {
 	(((struct fc_host_attrs *)(x)->shost_data)->fabric_name)
 #define fc_host_symbolic_name(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->symbolic_name)
+#define fc_host_hbaapi_library(x)	\
+	(((struct fc_host_attrs *)(x)->shost_data)->hbaapi_library)
 #define fc_host_system_hostname(x)	\
 	(((struct fc_host_attrs *)(x)->shost_data)->system_hostname)
 #define fc_host_tgtid_bind_type(x) \
@@ -748,6 +751,7 @@ struct fc_function_template {
 	unsigned long	show_host_speed:1;
 	unsigned long	show_host_fabric_name:1;
 	unsigned long	show_host_symbolic_name:1;
+	unsigned long   show_host_hbaapi_library:1;
 	unsigned long	show_host_system_hostname:1;
 
 	unsigned long	disable_target_scan:1;

