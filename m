From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 05/11] mpt3sas: Introduce mpt3sas_get_st_from_smid()
Date: Thu, 21 Dec 2017 23:31:41 -0800
Message-ID: <1513927907-19735-6-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:39629 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754106AbdLVHcd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 02:32:33 -0500
Received: by mail-wr0-f193.google.com with SMTP id a41so27096695wra.6
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2017 23:32:33 -0800 (PST)
In-Reply-To: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Hannes Reinecke <hare@suse.de>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>

From: Hannes Reinecke <hare@suse.de>

Abstract accesses to the scsi_lookup array by introducing
mpt3sas_get_st_from_smid().

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 22 ++++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     |  7 ++++---
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  4 +++-
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 35d36a9..afe42a8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -888,6 +888,15 @@ _base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 	return 1;
 }
 
+struct scsiio_tracker *
+mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	if (WARN_ON(!smid) ||
+	    WARN_ON(smid >= ioc->hi_priority_smid))
+		return NULL;
+	return &ioc->scsi_lookup[smid - 1];
+}
+
 /**
  * _base_get_cb_idx - obtain the callback index
  * @ioc: per adapter object
@@ -902,8 +911,11 @@ _base_get_cb_idx(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 	u8 cb_idx = 0xFF;
 
 	if (smid < ioc->hi_priority_smid) {
-		i = smid - 1;
-		cb_idx = ioc->scsi_lookup[i].cb_idx;
+		struct scsiio_tracker *st;
+
+		st = mpt3sas_get_st_from_smid(ioc, smid);
+		if (st)
+			cb_idx = st->cb_idx;
 	} else if (smid < ioc->internal_smid) {
 		i = smid - ioc->hi_priority_smid;
 		cb_idx = ioc->hpr_lookup[i].cb_idx;
@@ -1294,6 +1306,7 @@ static struct chain_tracker *
 _base_get_chain_buffer_tracker(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	struct chain_tracker *chain_req;
+	struct scsiio_tracker *st;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
@@ -1306,8 +1319,9 @@ _base_get_chain_buffer_tracker(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 	chain_req = list_entry(ioc->free_chain_list.next,
 	    struct chain_tracker, tracker_list);
 	list_del_init(&chain_req->tracker_list);
-	list_add_tail(&chain_req->tracker_list,
-	    &ioc->scsi_lookup[smid - 1].chain_list);
+	st = mpt3sas_get_st_from_smid(ioc, smid);
+	if (st)
+		list_add_tail(&chain_req->tracker_list, &st->chain_list);
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 	return chain_req;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 60f42ca..23e9af5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1402,6 +1402,8 @@ void mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc);
 u16 mpt3sas_base_get_smid_hpr(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 u16 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsi_cmnd *scmd);
+struct scsiio_tracker *mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc,
+	u16 smid);
 
 u16 mpt3sas_base_get_smid(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 7d76e8f..aae7396 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2779,7 +2779,7 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 	}
 
 	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
-		scsi_lookup = &ioc->scsi_lookup[smid_task - 1];
+		scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
 
 	dtmprintk(ioc, pr_info(MPT3SAS_FMT
 		"sending tm: handle(0x%04x), task_type(0x%02x), smid(%d)\n",
@@ -2797,7 +2797,8 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 	mpt3sas_scsih_set_tm_flag(ioc, handle);
 	init_completion(&ioc->tm_cmds.done);
 	if ((type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK) &&
-			(scsi_lookup->msix_io < ioc->reply_queue_count))
+	    scsi_lookup &&
+	    (scsi_lookup->msix_io < ioc->reply_queue_count))
 		msix_task = scsi_lookup->msix_io;
 	else
 		msix_task = 0;
@@ -2838,7 +2839,7 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 	switch (type) {
 	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
 		rc = SUCCESS;
-		if (scsi_lookup->scmd == NULL)
+		if (scsi_lookup && scsi_lookup->scmd == NULL)
 			break;
 		rc = FAILED;
 		break;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
index ced7d9f..890d6a9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
@@ -270,7 +270,9 @@ out_error:
 inline u8
 mpt3sas_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
-	return ioc->scsi_lookup[smid - 1].direct_io;
+	struct scsiio_tracker *st = mpt3sas_get_st_from_smid(ioc, smid);
+
+	return st ? st->direct_io : 0;
 }
 
 /**
-- 
2.5.5
