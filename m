From: Vasily Averin <vvs@parallels.com>
Subject: [SCSI] lpfc: possible memory leak in lpfc_sli4_bsg_diag_loopback_mode()
Date: Mon, 06 Jun 2011 11:30:39 +0400
Message-ID: <4DEC821F.8080409@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:45997 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050Ab1FFHar (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2011 03:30:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Smart <james.smart@emulex.com>
Cc: James Bottomley <jbottomley@parallels.com>

error path after lpfc_sli4_config() failure uses uninitialized
variable mbxstatus and can forget to free allocated memory

Signed-off-by: Vasily Averin <vvs@sw.ru>
---
 drivers/scsi/lpfc/lpfc_bsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7fb0ba4..9620327 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1741,7 +1741,7 @@ lpfc_sli4_bsg_diag_loopback_mode(struct lpfc_hba *phba,
struct fc_bsg_job *job)
 	uint32_t link_flags, timeout, req_len, alloc_len;
 	struct lpfc_mbx_set_link_diag_loopback *link_diag_loopback;
 	LPFC_MBOXQ_t *pmboxq = NULL;
-	int mbxstatus, i, rc = 0;
+	int mbxstatus = MBX_SUCCESS, i, rc = 0;

 	/* no data to return just the return code */
 	job->reply->reply_payload_rcv_len = 0;
-- 
1.7.4.1

