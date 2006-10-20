From: akpm@osdl.org
Subject: [patch 26/45] Dereference in drivers/scsi/lpfc/lpfc_ct.c
Date: Fri, 20 Oct 2006 14:48:25 -0700
Message-ID: <200610202148.k9KLmPJ6004150@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:60038 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992788AbWJTVsu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:48:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, snakebyte@gmx.de, James.Smart@Emulex.Com

From: Eric Sesterhenn <snakebyte@gmx.de>

If we fail to allocate mp->virt during the first while loop iteration,
mlist is still uninitialized, therefore we should check if before
dereferencing.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Acked-by: James Smart <James.Smart@Emulex.Com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/lpfc/lpfc_ct.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_ct.c~dereference-in-drivers-scsi-lpfc-lpfc_ctc drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c~dereference-in-drivers-scsi-lpfc-lpfc_ctc
+++ a/drivers/scsi/lpfc/lpfc_ct.c
@@ -188,7 +188,8 @@ lpfc_alloc_ct_rsp(struct lpfc_hba * phba
 
 		if (!mp->virt) {
 			kfree(mp);
-			lpfc_free_ct_rsp(phba, mlist);
+			if (mlist)
+				lpfc_free_ct_rsp(phba, mlist);
 			return NULL;
 		}
 
_
