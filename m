From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 05/23] be2iscsi: Fix locking mechanism in Unsol Path
Date: Sat, 28 Sep 2013 15:35:42 -0700
Message-ID: <1380407761-2949-5-git-send-email-jayamohan.kallickal@emulex.com>
References: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49742 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3I1WgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Sep 2013 18:36:22 -0400
Received: by mail-pb0-f53.google.com with SMTP id up15so3963930pbc.40
        for <linux-scsi@vger.kernel.org>; Sat, 28 Sep 2013 15:36:22 -0700 (PDT)
In-Reply-To: <1380407761-2949-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

	The default pdu is a common resource and needs to be protected
while manipulating it.

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |    7 +++++++
 drivers/scsi/be2iscsi/be_main.h |    1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 5ba575f..9918582 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2072,8 +2072,10 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				    "BM_%d : Received %s[%d] on CID : %d\n",
 				    cqe_desc[code], code, cid);
 
+			spin_lock_bh(&phba->async_pdu_lock);
 			hwi_process_default_pdu_ring(beiscsi_conn, phba,
 					     (struct i_t_dpdu_cqe *)sol);
+			spin_unlock_bh(&phba->async_pdu_lock);
 			break;
 		case UNSOL_DATA_NOTIFY:
 			beiscsi_log(phba, KERN_INFO,
@@ -2081,8 +2083,10 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				    "BM_%d : Received %s[%d] on CID : %d\n",
 				    cqe_desc[code], code, cid);
 
+			spin_lock_bh(&phba->async_pdu_lock);
 			hwi_process_default_pdu_ring(beiscsi_conn, phba,
 					     (struct i_t_dpdu_cqe *)sol);
+			spin_unlock_bh(&phba->async_pdu_lock);
 			break;
 		case CXN_INVALIDATE_INDEX_NOTIFY:
 		case CMD_INVALIDATED_NOTIFY:
@@ -2110,8 +2114,10 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
 				    "BM_%d :  Dropping %s[%d] on DPDU ring on CID : %d\n",
 				    cqe_desc[code], code, cid);
+			spin_lock_bh(&phba->async_pdu_lock);
 			hwi_flush_default_pdu_buffer(phba, beiscsi_conn,
 					     (struct i_t_dpdu_cqe *) sol);
+			spin_unlock_bh(&phba->async_pdu_lock);
 			break;
 		case CXN_KILLED_PDU_SIZE_EXCEEDS_DSL:
 		case CXN_KILLED_BURST_LEN_MISMATCH:
@@ -5010,6 +5016,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 	spin_lock_init(&phba->io_sgl_lock);
 	spin_lock_init(&phba->mgmt_sgl_lock);
 	spin_lock_init(&phba->isr_lock);
+	spin_lock_init(&phba->async_pdu_lock);
 	ret = mgmt_get_fw_config(&phba->ctrl, phba);
 	if (ret != 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index ec75c53..6ac4f2f 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -305,6 +305,7 @@ struct beiscsi_hba {
 	spinlock_t io_sgl_lock;
 	spinlock_t mgmt_sgl_lock;
 	spinlock_t isr_lock;
+	spinlock_t async_pdu_lock;
 	unsigned int age;
 	unsigned short avlbl_cids;
 	unsigned short cid_alloc;
-- 
1.7.10.4

