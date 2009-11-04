From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -2nd repost 3/4] SCSI: lpfc, fix memory leak
Date: Wed,  4 Nov 2009 17:15:20 +0100
Message-ID: <1257351321-8281-3-git-send-email-jirislaby@gmail.com>
References: <1257351321-8281-1-git-send-email-jirislaby@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server1.wserver.cz ([82.113.45.157]:34206 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbZKDQPR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2009 11:15:17 -0500
In-Reply-To: <1257351321-8281-1-git-send-email-jirislaby@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: aacraid@adaptec.com, james.smart@emulex.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>

Stanse found a memory leak on one fail path in lpfc_sli4_read_rev.

Add there kfree.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James Smart <james.smart@emulex.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/lpfc/lpfc_sli.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 43cbe33..7750868 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4211,6 +4211,7 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	if (rc) {
 		dma_free_coherent(&phba->pcidev->dev, dma_size,
 				  dmabuf->virt, dmabuf->phys);
+		kfree(dmabuf);
 		return -EIO;
 	}
 
-- 
1.6.4.2

