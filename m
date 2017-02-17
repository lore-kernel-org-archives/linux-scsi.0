From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 06/11] mpt3sas: Introduce mpt3sas_get_st_from_smid()
Date: Fri, 17 Feb 2017 09:23:05 +0100
Message-ID: <1487319790-97340-7-git-send-email-hare@suse.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34693 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754276AbdBQIXW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:23:22 -0500
In-Reply-To: <1487319790-97340-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Abstract accesses to the scsi_lookup array by introducing
mpt3sas_get_st_from_smid().

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 20 ++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  2 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  4 +++-
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6e0fc06..9b7273b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -862,6 +862,14 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	return 1;
 }
 
+struct scsiio_tracker *
+mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	WARN_ON(!smid);
+	WARN_ON(smid >= ioc->hi_priority_smid);
+	return &ioc->scsi_lookup[smid - 1];
+}
+
 /**
  * _base_get_cb_idx - obtain the callback index
  * @ioc: per adapter object
@@ -876,8 +884,11 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
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
@@ -1268,6 +1279,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 _base_get_chain_buffer_tracker(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 {
 	struct chain_tracker *chain_req;
+	struct scsiio_tracker *st;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
@@ -1280,8 +1292,8 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	chain_req = list_entry(ioc->free_chain_list.next,
 	    struct chain_tracker, tracker_list);
 	list_del_init(&chain_req->tracker_list);
-	list_add_tail(&chain_req->tracker_list,
-	    &ioc->scsi_lookup[smid - 1].chain_list);
+	st = mpt3sas_get_st_from_smid(ioc, smid);
+	list_add_tail(&chain_req->tracker_list, &st->chain_list);
 	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 	return chain_req;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 1f460f2..74186e3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1247,6 +1247,8 @@ __le32 mpt3sas_base_get_sense_buffer_dma(struct MPT3SAS_ADAPTER *ioc,
 u16 mpt3sas_base_get_smid_hpr(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 u16 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
 	struct scsi_cmnd *scmd);
+struct scsiio_tracker * mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc,
+	u16 smid);
 
 u16 mpt3sas_base_get_smid(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx);
 void mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 52de355..a88f2ac 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2269,7 +2269,7 @@ struct _sas_node *
 	}
 
 	if (type == MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK)
-		scsi_lookup = &ioc->scsi_lookup[smid_task - 1];
+		scsi_lookup = mpt3sas_get_st_from_smid(ioc, smid_task);
 
 	dtmprintk(ioc, pr_info(MPT3SAS_FMT
 		"sending tm: handle(0x%04x), task_type(0x%02x), smid(%d)\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
index 540bd50..06e3f7d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_warpdrive.c
@@ -270,7 +270,9 @@
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
1.8.5.6
