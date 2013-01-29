From: yxlraid@gmail.com
Subject: [PATCH] mvsas: fixed timeout issue when removing module
Date: Wed, 30 Jan 2013 00:25:53 +0800
Message-ID: <1359476753-19361-1-git-send-email-yxlraid@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43943 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3A2Q0T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2013 11:26:19 -0500
Received: by mail-pa0-f46.google.com with SMTP id kp14so486109pab.33
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jan 2013 08:26:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>

From: Xiangliang Yu <yuxiangl@marvell.com>

- Root cause is libsas will clear asd_sas_port
  phy_mask value in sas_port_deform after triggering
  destruct workqueue, but the workqueue will send
  sync cmd and still need phy_mask value.
  Now, mvsas using asd_sas_phy setting instead of
  asd_sas_port setting.
---
 drivers/scsi/mvsas/mv_sas.c |   10 ++++++++--
 drivers/scsi/mvsas/mv_sas.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 078c639..532110f 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -316,10 +316,13 @@ static int mvs_task_prep_smp(struct mvs_info *mvi,
 			     struct mvs_task_exec_info *tei)
 {
 	int elem, rc, i;
+	struct sas_ha_struct *sha = mvi->sas;
 	struct sas_task *task = tei->task;
 	struct mvs_cmd_hdr *hdr = tei->hdr;
 	struct domain_device *dev = task->dev;
 	struct asd_sas_port *sas_port = dev->port;
+	struct sas_phy *sphy = dev->phy;
+	struct asd_sas_phy *sas_phy = sha->sas_phy[sphy->number];
 	struct scatterlist *sg_req, *sg_resp;
 	u32 req_len, resp_len, tag = tei->tag;
 	void *buf_tmp;
@@ -392,7 +395,7 @@ static int mvs_task_prep_smp(struct mvs_info *mvi,
 	slot->tx = mvi->tx_prod;
 	mvi->tx[mvi->tx_prod] = cpu_to_le32((TXQ_CMD_SMP << TXQ_CMD_SHIFT) |
 					TXQ_MODE_I | tag |
-					(sas_port->phy_mask << TXQ_PHY_SHIFT));
+					(MVS_PHY_ID << TXQ_PHY_SHIFT));
 
 	hdr->flags |= flags;
 	hdr->lens = cpu_to_le32(((resp_len / 4) << 16) | ((req_len - 4) / 4));
@@ -438,11 +441,14 @@ static u32 mvs_get_ncq_tag(struct sas_task *task, u32 *tag)
 static int mvs_task_prep_ata(struct mvs_info *mvi,
 			     struct mvs_task_exec_info *tei)
 {
+	struct sas_ha_struct *sha = mvi->sas;
 	struct sas_task *task = tei->task;
 	struct domain_device *dev = task->dev;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_cmd_hdr *hdr = tei->hdr;
 	struct asd_sas_port *sas_port = dev->port;
+	struct sas_phy *sphy = dev->phy;
+	struct asd_sas_phy *sas_phy = sha->sas_phy[sphy->number];
 	struct mvs_slot_info *slot;
 	void *buf_prd;
 	u32 tag = tei->tag, hdr_tag;
@@ -462,7 +468,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	slot->tx = mvi->tx_prod;
 	del_q = TXQ_MODE_I | tag |
 		(TXQ_CMD_STP << TXQ_CMD_SHIFT) |
-		(sas_port->phy_mask << TXQ_PHY_SHIFT) |
+		(MVS_PHY_ID << TXQ_PHY_SHIFT) |
 		(mvi_dev->taskfileset << TXQ_SRS_SHIFT);
 	mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);
 
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 2ae77a0..9f3cc13 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -76,6 +76,7 @@ extern struct kmem_cache *mvs_task_list_cache;
 					(__mc) != 0 ;		\
 					(++__lseq), (__mc) >>= 1)
 
+#define MVS_PHY_ID (1U << sas_phy->id)
 #define MV_INIT_DELAYED_WORK(w, f, d)	INIT_DELAYED_WORK(w, f)
 #define UNASSOC_D2H_FIS(id)		\
 	((void *) mvi->rx_fis + 0x100 * id)
-- 
1.7.5.4

