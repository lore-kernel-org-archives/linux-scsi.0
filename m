From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 09/20] lpfc: Fix crash in lpfc nvmet when fc port is reset
Date: Wed, 23 Aug 2017 16:55:38 -0700
Message-ID: <20170823235549.2883-10-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38905 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdHWX4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:18 -0400
Received: by mail-wm0-f68.google.com with SMTP id a70so1046370wmd.5
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:18 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

in adapter reset tests, an oops was seen with a NULL pointer in
lpfc_free_rq_buffer+0x20/0x60

The driver is failing to properly repost the nvmet sgl list when
recovering from the reset. Thus the driver eventually trys to
walk an errant buffer list.

Corrected the sgl buffer recovery as well as strengthening the
initialization of the bufferlist.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_init.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9294c89c7ccd..f82618a8918f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3226,6 +3226,13 @@ lpfc_offline(struct lpfc_hba *phba)
 
 	/* stop port and all timers associated with this hba */
 	lpfc_stop_port(phba);
+
+	/* Tear down the local and target port registrations.  The
+	 * nvme transports need to cleanup.
+	 */
+	lpfc_nvmet_destroy_targetport(phba);
+	lpfc_nvme_destroy_localport(phba->pport);
+
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++)
@@ -6516,6 +6523,12 @@ lpfc_free_nvmet_sgl_list(struct lpfc_hba *phba)
 		lpfc_nvmet_buf_free(phba, sglq_entry->virt, sglq_entry->phys);
 		kfree(sglq_entry);
 	}
+
+	/* Update the nvmet_xri_cnt to reflect no current sgls.
+	 * The next initialization cycle sets the count and allocates
+	 * the sgls over again.
+	 */
+	phba->sli4_hba.nvmet_xri_cnt = 0;
 }
 
 /**
@@ -8301,6 +8314,9 @@ lpfc_sli4_queue_create(struct lpfc_hba *phba)
 				goto out_error;
 			}
 
+			/* Put list in known state in case driver load fails. */
+			INIT_LIST_HEAD(&qdesc->rqbp->rqb_buffer_list);
+
 			/* Create NVMET Receive Queue for data */
 			qdesc = lpfc_sli4_queue_alloc(phba,
 						      phba->sli4_hba.rq_esize,
-- 
2.13.1
