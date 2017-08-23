From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 16/20] lpfc: Fix bad sgl reposting after 2nd adapter reset
Date: Wed, 23 Aug 2017 16:55:45 -0700
Message-ID: <20170823235549.2883-17-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34920 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751947AbdHWX4c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:32 -0400
Received: by mail-wr0-f193.google.com with SMTP id n53so590394wrb.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:32 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Fix bad sgl reposting after 2nd adapter reset

port issue was fixed, the hbacmd reset would take
more than 8 minutes to complete.

There were conflicting NVME SGL posting/reposting responsibilities
between lpfc_online()/lpfc_sli4_hba_setup() and
lpfc_nvme_create_localport().  The lpfc_online() causes a REPOST
on existing NVME SGLs which is not released during the fc port reset.
However, lpfc_nvme_create_localport() wants to allocate new NVME
buffers and post them. Both cancelled out each other which had a side
effect of hosing the mailbox handling that was used to remove the sgl
lists - causing multiple 60s mbx timeouts.

Fix by preserving all SGL lists over the fc port reset.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 24dc69de6023..bb9ede2521b9 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2181,8 +2181,15 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 		vport->localport = localport;
 		lport->vport = vport;
 		vport->nvmei_support = 1;
-		len  = lpfc_new_nvme_buf(vport, phba->sli4_hba.nvme_xri_max);
-		vport->phba->total_nvme_bufs += len;
+
+		/* Don't post more new bufs if repost already recovered
+		 * the nvme sgls.
+		 */
+		if (phba->sli4_hba.nvme_xri_cnt == 0) {
+			len  = lpfc_new_nvme_buf(vport,
+						 phba->sli4_hba.nvme_xri_max);
+			vport->phba->total_nvme_bufs += len;
+		}
 	}
 
 	return ret;
-- 
2.13.1
