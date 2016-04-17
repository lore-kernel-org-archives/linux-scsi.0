From: Sebastian Herbszt <herbszt@gmx.de>
Subject: [PATCH] lpfc: remove incorrect lockdep assertion
Date: Sun, 17 Apr 2016 13:27:27 +0200
Message-ID: <20160417132727.000026f3@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52345 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbcDQL1U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 17 Apr 2016 07:27:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Sebastian Herbszt <herbszt@gmx.de>

Remove incorrect lockdep assertion from lpfc_sli_hbqbuf_find() which acquires
the hbalock itself. Fix the comment which resulted in this mistake.

Fixes: 1c2ba475eb0e ("lpfc: Add lockdep assertions")
Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>

diff -uNr -U 5 a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2016-03-15 03:25:44.324554218 +0100
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2016-04-17 13:01:59.700182669 +0200
@@ -1998,24 +1998,21 @@
 /**
  * lpfc_sli_hbqbuf_find - Find the hbq buffer associated with a tag
  * @phba: Pointer to HBA context object.
  * @tag: Tag of the hbq buffer.
  *
- * This function is called with hbalock held. This function searches
- * for the hbq buffer associated with the given tag in the hbq buffer
- * list. If it finds the hbq buffer, it returns the hbq_buffer other wise
- * it returns NULL.
+ * This function searches for the hbq buffer associated with the given tag in
+ * the hbq buffer list. If it finds the hbq buffer, it returns the hbq_buffer
+ * otherwise it returns NULL.
  **/
 static struct hbq_dmabuf *
 lpfc_sli_hbqbuf_find(struct lpfc_hba *phba, uint32_t tag)
 {
 	struct lpfc_dmabuf *d_buf;
 	struct hbq_dmabuf *hbq_buf;
 	uint32_t hbqno;
 
-	lockdep_assert_held(&phba->hbalock);
-
 	hbqno = tag >> 16;
 	if (hbqno >= LPFC_MAX_HBQS)
 		return NULL;
 
 	spin_lock_irq(&phba->hbalock);
