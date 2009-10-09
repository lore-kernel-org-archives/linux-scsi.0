From: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH -repost 3/4] SCSI: lpfc, fix memory leak
Date: Fri,  9 Oct 2009 15:58:07 +0200
Message-ID: <1255096688-23399-3-git-send-email-jirislaby@gmail.com>
References: <1255096688-23399-1-git-send-email-jirislaby@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933140AbZJIN7A@vger.kernel.org>
In-Reply-To: <1255096688-23399-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>, James Smart <james.smart@emulex.com>
List-Id: linux-scsi@vger.kernel.org

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
