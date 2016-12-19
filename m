From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v2 05/11] lpfc: Correct host name in symbolic_name field
Date: Mon, 19 Dec 2016 15:07:24 -0800
Message-ID: <5858682c.KSP+2UL8attjRczU%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvsmtp02.broadcom.com ([192.19.219.146]:42871 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754767AbcLSXH1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 18:07:27 -0500
Received: from flash (fx9xs32.lab.emulex.com [138.239.87.14])
        by relay.smtp.broadcom.com (Postfix) with SMTP id D9B67260002
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 15:07:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Correct host name in symbolic_name field of nameserver registrations

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 98c40a7..f3250ad 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4847,6 +4847,19 @@ lpfc_free_sysfs_attr(struct lpfc_vport *vport)
  */
 
 /**
+ * lpfc_get_host_symbolic_name - Copy symbolic name into the scsi host
+ * @shost: kernel scsi host pointer.
+ **/
+static void
+lpfc_get_host_symbolic_name(struct Scsi_Host *shost)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+
+	lpfc_vport_symbolic_node_name(vport, fc_host_symbolic_name(shost),
+				      sizeof fc_host_symbolic_name(shost));
+}
+
+/**
  * lpfc_get_host_port_id - Copy the vport DID into the scsi host port id
  * @shost: kernel scsi host pointer.
  **/
@@ -5383,6 +5396,8 @@ struct fc_function_template lpfc_transport_functions = {
 	.show_host_supported_fc4s = 1,
 	.show_host_supported_speeds = 1,
 	.show_host_maxframe_size = 1,
+
+	.get_host_symbolic_name = lpfc_get_host_symbolic_name,
 	.show_host_symbolic_name = 1,
 
 	/* dynamic attributes the driver supports */
@@ -5450,6 +5465,8 @@ struct fc_function_template lpfc_vport_transport_functions = {
 	.show_host_supported_fc4s = 1,
 	.show_host_supported_speeds = 1,
 	.show_host_maxframe_size = 1,
+
+	.get_host_symbolic_name = lpfc_get_host_symbolic_name,
 	.show_host_symbolic_name = 1,
 
 	/* dynamic attributes the driver supports */
-- 
2.5.0


