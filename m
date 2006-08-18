From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/5] lpfc 8.1.10 : Add support to return adapter symbolic
	name
Date: Fri, 18 Aug 2006 17:46:53 -0400
Message-ID: <1155937613.12933.29.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37830 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751495AbWHRVqx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Aug 2006 17:46:53 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k7ILkmMi024277
	for <linux-scsi@vger.kernel.org>; Fri, 18 Aug 2006 14:46:48 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add support to return adapter symbolic name (now that attribute is dynamic)

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1204,6 +1204,15 @@ lpfc_get_host_fabric_name (struct Scsi_H
 	fc_host_fabric_name(shost) = node_name;
 }
 
+static void
+lpfc_get_host_symbolic_name (struct Scsi_Host *shost)
+{
+	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata;
+
+	spin_lock_irq(shost->host_lock);
+	lpfc_get_hba_sym_node_name(phba, fc_host_symbolic_name(shost));
+	spin_unlock_irq(shost->host_lock);
+}
 
 static struct fc_host_statistics *
 lpfc_get_stats(struct Scsi_Host *shost)
@@ -1486,7 +1495,6 @@ struct fc_function_template lpfc_transpo
 	.show_host_port_name = 1,
 	.show_host_supported_classes = 1,
 	.show_host_supported_fc4s = 1,
-	.show_host_symbolic_name = 1,
 	.show_host_supported_speeds = 1,
 	.show_host_maxframe_size = 1,
 
@@ -1509,6 +1517,9 @@ struct fc_function_template lpfc_transpo
 	.get_host_fabric_name = lpfc_get_host_fabric_name,
 	.show_host_fabric_name = 1,
 
+	.get_host_symbolic_name = lpfc_get_host_symbolic_name,
+	.show_host_symbolic_name = 1,
+
 	/*
 	 * The LPFC driver treats linkdown handling as target loss events
 	 * so there are no sysfs handlers for link_down_tmo.


