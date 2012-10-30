From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch 09/10] lpfc: use scsi_host_alloc_node
Date: Tue, 30 Oct 2012 16:14:43 -0400
Message-ID: <1351628084-29358-12-git-send-email-jmoyer@redhat.com>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James Smart <james.smart@emulex.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/lpfc/lpfc_init.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7dc4218..65956d3 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3051,11 +3051,13 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	int error = 0;
 
 	if (dev != &phba->pcidev->dev)
-		shost = scsi_host_alloc(&lpfc_vport_template,
-					sizeof(struct lpfc_vport));
+		shost = scsi_host_alloc_node(&lpfc_vport_template,
+					     sizeof(struct lpfc_vport),
+					     dev_to_node(&phba->pcidev->dev));
 	else
-		shost = scsi_host_alloc(&lpfc_template,
-					sizeof(struct lpfc_vport));
+		shost = scsi_host_alloc_node(&lpfc_template,
+					     sizeof(struct lpfc_vport),
+					     dev_to_node(&phba->pcidev->dev));
 	if (!shost)
 		goto out;
 
-- 
1.7.1
