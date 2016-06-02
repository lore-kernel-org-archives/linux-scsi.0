From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/14] lpfc: display manual queue assignment
Date: Thu,  2 Jun 2016 16:39:08 +0200
Message-ID: <1464878356-42407-7-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54604 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932995AbcFBOjW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:22 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If no interrupt affinity is requested the driver should still
list the queue-to-interrupt mapping so that userspace tools
can setup the correct interrupt affinity.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 241bbd6..801b2b0 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4306,7 +4306,7 @@ lpfc_fcp_cpu_map_show(struct device *dev, struct device_attribute *attr,
 	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_vector_map_info *cpup;
-	int  len = 0;
+	int  len = 0, idx;
 
 	if ((phba->sli_rev != LPFC_SLI_REV4) ||
 	    (phba->intr_type != MSIX))
@@ -4315,8 +4315,14 @@ lpfc_fcp_cpu_map_show(struct device *dev, struct device_attribute *attr,
 	switch (phba->cfg_fcp_cpu_map) {
 	case 0:
 		len += snprintf(buf + len, PAGE_SIZE-len,
-				"fcp_cpu_map: No mapping (%d)\n",
+				"fcp_cpu_map: Manual mapping (%d)\n",
 				phba->cfg_fcp_cpu_map);
+		for (idx = 0; idx < phba->cfg_fcp_io_channel; idx++) {
+			len += snprintf(buf + len, PAGE_SIZE-len,
+					"io_chan %02d IRQ %d\n",
+					phba->sli4_hba.msix_entries[idx].entry,
+					phba->sli4_hba.msix_entries[idx].vector);
+		}
 		return len;
 	case 1:
 		len += snprintf(buf + len, PAGE_SIZE-len,
-- 
1.8.5.6

