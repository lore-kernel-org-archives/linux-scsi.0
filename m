From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 03/15] lpfc: Fix nvme port role handling in sysfs and debugfs handlers.
Date: Tue, 30 May 2017 23:04:27 -0700
Message-ID: <20170531060439.2073-4-jsmart2021@gmail.com>
References: <20170531060439.2073-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34523 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbdEaGEy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 02:04:54 -0400
Received: by mail-qt0-f195.google.com with SMTP id l39so810931qtb.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2017 23:04:54 -0700 (PDT)
In-Reply-To: <20170531060439.2073-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

While debugging Devloss and recovery, debugfs and sysfs
were found to not show the NVME port roles consistently.

The port role FC_PORT_ROLE_NVME_DISCOVERY was added with
the devloss bringup and the other issues were just oversight.

Add NVME Target and DISCSRVC to debugfs nodeinfo and sysfs
nvme info handlers. The full port role was added to the NVME
data only not the generic nodelist.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c    | 22 ++++++++++------------
 drivers/scsi/lpfc/lpfc_debugfs.c | 32 ++++++++++++++++++--------------
 2 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 6d9b83cd82a2..200a614bb540 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -312,25 +312,23 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		len += snprintf(buf + len, PAGE_SIZE - len, "DID x%06x ",
 				nrport->port_id);
 
-		switch (nrport->port_role) {
-		case FC_PORT_ROLE_NVME_INITIATOR:
+		/* An NVME rport can have multiple roles. */
+		if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR)
 			len +=  snprintf(buf + len, PAGE_SIZE - len,
 					 "INITIATOR ");
-			break;
-		case FC_PORT_ROLE_NVME_TARGET:
+		if (nrport->port_role & FC_PORT_ROLE_NVME_TARGET)
 			len +=  snprintf(buf + len, PAGE_SIZE - len,
 					 "TARGET ");
-			break;
-		case FC_PORT_ROLE_NVME_DISCOVERY:
+		if (nrport->port_role & FC_PORT_ROLE_NVME_DISCOVERY)
 			len +=  snprintf(buf + len, PAGE_SIZE - len,
-					 "DISCOVERY ");
-			break;
-		default:
+					 "DISCSRVC ");
+		if (nrport->port_role & ~(FC_PORT_ROLE_NVME_INITIATOR |
+					  FC_PORT_ROLE_NVME_TARGET |
+					  FC_PORT_ROLE_NVME_DISCOVERY))
 			len +=  snprintf(buf + len, PAGE_SIZE - len,
-					 "UNKNOWN_ROLE x%x",
+					 "UNKNOWN ROLE x%x",
 					 nrport->port_role);
-			break;
-		}
+
 		len +=  snprintf(buf + len, PAGE_SIZE - len, "%s  ", statep);
 		/* Terminate the string. */
 		len +=  snprintf(buf + len, PAGE_SIZE - len, "\n");
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index d71bda24b08e..dd8598bc50f3 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -621,6 +621,13 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 				ndlp->nlp_sid);
 		if (ndlp->nlp_type & NLP_FCP_INITIATOR)
 			len += snprintf(buf+len, size-len, "FCP_INITIATOR ");
+		if (ndlp->nlp_type & NLP_NVME_TARGET)
+			len += snprintf(buf + len,
+					size - len, "NVME_TGT sid:%d ",
+					NLP_NO_SID);
+		if (ndlp->nlp_type & NLP_NVME_INITIATOR)
+			len += snprintf(buf + len,
+					size - len, "NVME_INITIATOR ");
 		len += snprintf(buf+len, size-len, "usgmap:%x ",
 			ndlp->nlp_usg_map);
 		len += snprintf(buf+len, size-len, "refcnt:%x",
@@ -698,26 +705,23 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
 				nrport->port_name);
 		len += snprintf(buf + len, size - len, "WWNN x%llx ",
 				nrport->node_name);
-		switch (nrport->port_role) {
-		case FC_PORT_ROLE_NVME_INITIATOR:
+
+		/* An NVME rport can have multiple roles. */
+		if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR)
 			len +=  snprintf(buf + len, size - len,
-					 "NVME INITIATOR ");
-			break;
-		case FC_PORT_ROLE_NVME_TARGET:
+					 "INITIATOR ");
+		if (nrport->port_role & FC_PORT_ROLE_NVME_TARGET)
 			len +=  snprintf(buf + len, size - len,
-					 "NVME TARGET ");
-			break;
-		case FC_PORT_ROLE_NVME_DISCOVERY:
+					 "TARGET ");
+		if (nrport->port_role & FC_PORT_ROLE_NVME_DISCOVERY)
 			len +=  snprintf(buf + len, size - len,
-					 "NVME DISCOVERY ");
-			break;
-		default:
+					 "DISCSRVC ");
+		if (nrport->port_role & ~(FC_PORT_ROLE_NVME_INITIATOR |
+					  FC_PORT_ROLE_NVME_TARGET |
+					  FC_PORT_ROLE_NVME_DISCOVERY))
 			len +=  snprintf(buf + len, size - len,
 					 "UNKNOWN ROLE x%x",
 					 nrport->port_role);
-			break;
-		}
-
 		/* Terminate the string. */
 		len +=  snprintf(buf + len, size - len, "\n");
 	}
-- 
2.11.0
