From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -3rd repost 3/3] SCSI: lpfc, fix memory leak
Date: Thu, 10 Dec 2009 14:37:04 +0100
Message-ID: <1260452224-31760-3-git-send-email-jslaby@suse.cz>
References: <1260452224-31760-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760748AbZLJNhS@vger.kernel.org>
In-Reply-To: <1260452224-31760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Stanse found a memory leak on one fail path in lpfc_sli4_read_rev.

Add there kfree.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: James Smart <james.smart@emulex.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/lpfc/lpfc_sli.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7935667..487cf8e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4110,6 +4110,7 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	if (rc) {
 		dma_free_coherent(&phba->pcidev->dev, dma_size,
 				  dmabuf->virt, dmabuf->phys);
+		kfree(dmabuf);
 		return -EIO;
 	}
 
-- 
1.6.5.5
