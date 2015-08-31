From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 08/14] lpfc: Fix possible use-after-free and double free
 in lpfc_mbx_cmpl_rdp_page_a2()
Date: Mon, 31 Aug 2015 16:48:15 -0400
Message-ID: <55e4bd8f.66pL9YWWXA/xjdG0%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35073 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbbHaUsb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:31 -0400
Received: by qkcj187 with SMTP id j187so16803854qkc.2
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:31 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id a73sm9521084qkj.27.2015.08.31.13.48.30
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


From: Johannes Thumshirn <jthumshirn@suse.de>

If the bf_get() call in lpfc_mbx_cmpl_rdp_page_a2() does succeeds, execution
continues normally and mp gets kfree()d.

If the subsequent call to lpfc_sli_issue_mbox() fails execution jumps to the
error label where lpfc_mbuf_free() is called with mp->virt and mp->phys as
function arguments. This is the use after free. Following the use after free mp
gets kfree()d again which is a double free.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_mbox.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 723e110..18838ea 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2276,7 +2276,7 @@ lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 			(struct lpfc_rdp_context *)(mbox->context2);
 
 	if (bf_get(lpfc_mqe_status, &mbox->u.mqe))
-		goto error;
+		goto error_mbuf_free;
 
 	lpfc_sli_bemem_bcopy(mp->virt, &rdp_context->page_a2,
 				DMP_SFF_PAGE_A2_SIZE);
@@ -2291,13 +2291,14 @@ lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
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
1.7.11.7

