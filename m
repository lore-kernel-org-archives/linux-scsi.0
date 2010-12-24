From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 7/8] fcoe: prepare fcoe for using fcoe transport
Date: Thu, 23 Dec 2010 21:18:32 -0800
Message-ID: <1293167912.4676.466.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3794 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab0LXFTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Dec 2010 00:19:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org, linux-scsi@vger.kernel.org
Cc: mchan@broadcom.com, yi.zou@intel.com, michaelc@cs.wisc.edu

From: Yi Zou <yi.zou@intel.com>

Prepare the fcoe to convert it to use the newly added fcoe transport, making
it as the default fcoe transport provider for libfcoe. This patch is to rename
some of the variables to avoid any confusing names later as now there are
several transports in the same file.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/fcoe/fcoe.c |   29 +++++++++++++++--------------
 1 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9f9600b..6f953d5 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -145,8 +145,8 @@ static struct notifier_block fcoe_cpu_notifier = {
 	.notifier_call = fcoe_cpu_callback,
 };
 
-static struct scsi_transport_template *fcoe_transport_template;
-static struct scsi_transport_template *fcoe_vport_transport_template;
+static struct scsi_transport_template *fcoe_nport_scsi_transport;
+static struct scsi_transport_template *fcoe_vport_scsi_transport;
 
 static int fcoe_vport_destroy(struct fc_vport *);
 static int fcoe_vport_create(struct fc_vport *, bool disabled);
@@ -163,7 +163,7 @@ static struct libfc_function_template fcoe_libfc_fcn_templ = {
 	.lport_set_port_id = fcoe_set_port_id,
 };
 
-struct fc_function_template fcoe_transport_function = {
+struct fc_function_template fcoe_nport_fc_functions = {
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_supported_classes = 1,
@@ -203,7 +203,7 @@ struct fc_function_template fcoe_transport_function = {
 	.bsg_request = fc_lport_bsg_request,
 };
 
-struct fc_function_template fcoe_vport_transport_function = {
+struct fc_function_template fcoe_vport_fc_functions = {
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_supported_classes = 1,
@@ -708,9 +708,9 @@ static int fcoe_shost_config(struct fc_lport *lport, struct device *dev)
 	lport->host->max_cmd_len = FCOE_MAX_CMD_LEN;
 
 	if (lport->vport)
-		lport->host->transportt = fcoe_vport_transport_template;
+		lport->host->transportt = fcoe_vport_scsi_transport;
 	else
-		lport->host->transportt = fcoe_transport_template;
+		lport->host->transportt = fcoe_nport_scsi_transport;
 
 	/* add the new host to the SCSI-ml */
 	rc = scsi_add_host(lport->host, dev);
@@ -1050,11 +1050,12 @@ out:
 static int __init fcoe_if_init(void)
 {
 	/* attach to scsi transport */
-	fcoe_transport_template = fc_attach_transport(&fcoe_transport_function);
-	fcoe_vport_transport_template =
-		fc_attach_transport(&fcoe_vport_transport_function);
+	fcoe_nport_scsi_transport =
+		fc_attach_transport(&fcoe_nport_fc_functions);
+	fcoe_vport_scsi_transport =
+		fc_attach_transport(&fcoe_vport_fc_functions);
 
-	if (!fcoe_transport_template) {
+	if (!fcoe_nport_scsi_transport) {
 		printk(KERN_ERR "fcoe: Failed to attach to the FC transport\n");
 		return -ENODEV;
 	}
@@ -1071,10 +1072,10 @@ static int __init fcoe_if_init(void)
  */
 int __exit fcoe_if_exit(void)
 {
-	fc_release_transport(fcoe_transport_template);
-	fc_release_transport(fcoe_vport_transport_template);
-	fcoe_transport_template = NULL;
-	fcoe_vport_transport_template = NULL;
+	fc_release_transport(fcoe_nport_scsi_transport);
+	fc_release_transport(fcoe_vport_scsi_transport);
+	fcoe_nport_scsi_transport = NULL;
+	fcoe_vport_scsi_transport = NULL;
 	return 0;
 }
 
-- 
1.7.0.6




