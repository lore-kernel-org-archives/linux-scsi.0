From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] lpfc: Fix possible use-after-free and double free in lpfc_mbx_cmpl_rdp_page_a2()
Date: Mon, 17 Aug 2015 13:03:02 +0200
Message-ID: <1439809382-32419-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbbHQLDQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Aug 2015 07:03:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

If the bf_get() call in lpfc_mbx_cmpl_rdp_page_a2() does succeeds, execution
continues normally and mp gets kfree()d.

If the subsequent call to lpfc_sli_issue_mbox() fails execution jumps to the
error label where lpfc_mbuf_free() is called with mp->virt and mp->phys as
function arguments. This is the use after free. Following the use after free mp
gets kfree()d again which is a double free.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_mbox.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index eb62772..4abb93a 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2284,7 +2284,7 @@ lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 			(struct lpfc_rdp_context *)(mbox->context2);
 
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe))
-		goto error;
+		goto error_mbuf_free;
 
 	lpfc_sli_bemem_bcopy(mp->virt, &rdp_context->page_a2,
 				DMP_SFF_PAGE_A2_SIZE);
@@ -2299,13 +2299,14 @@ lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_link_stat;
 	mbox->context2 = (struct lpfc_rdp_context *) rdp_context;
 	if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) == MBX_NOT_FINISHED)
-		goto error;
+		goto error_cmd_free;
 
 	return;
 
-error:
+error_mbuf_free:
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
+error_cmd_free:
 	lpfc_sli4_mbox_cmd_free(phba, mbox);
 	rdp_context->cmpl(phba, rdp_context, FAILURE);
 }
-- 
2.5.0

