From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/6] lpfc 8.1.4 : Two misc fixes
Date: Tue, 07 Mar 2006 15:04:19 -0500
Message-ID: <1141761860.25430.19.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:40908 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932315AbWCGUEY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 15:04:24 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k27K4Mrf021521
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 12:04:23 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Two misc fixes:
 - Fix deadlock caused by return with host_lock held in lpfc_findnode_did
 - Initialize all fields of the allocated mail box structure to zero.
   Was causing some sysfs mailbox commands to fail immediately after load.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1760,6 +1760,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
+				spin_unlock_irq(phba->host->host_lock);
 				return ndlp;
 			}
 		}
@@ -1805,6 +1806,7 @@ lpfc_findnode_did(struct lpfc_hba * phba
 						phba->brd_no,
 						ndlp, ndlp->nlp_DID,
 						ndlp->nlp_flag, data1);
+				spin_unlock_irq(phba->host->host_lock);
 				return ndlp;
 			}
 		}

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -856,7 +856,7 @@ sysfs_mbox_write(struct kobject *kobj, c
 		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 		if (!mbox)
 			return -ENOMEM;
-
+		memset(mbox, 0, sizeof (LPFC_MBOXQ_t));
 	}
 
 	spin_lock_irq(host->host_lock);


