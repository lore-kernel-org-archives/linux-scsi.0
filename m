Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A59FC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F8DE207BB
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="j51CqFmc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgEOKcd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:32:33 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:37355 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728204AbgEOKcb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:32:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538769; x=1621074769;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=249ylVTA5bH8oLXhEXpijUuVobPZYY1rjtxs9s3RNyE=;
  b=j51CqFmc5deI5fBiSSy6uRJ8uxr3K5CyIqgNdfoe5SLkq6D7AIZLhkNh
   RMkBQ/yCJ0EPOt66n2HoDEwTzCgLaAWzQzhOcMFazw8B+UBmvdJUhko6p
   s5yxetlMfQGaE3ufesG/bIEpUCVR/hvsWfQflXjAmNT61v7nDfx5ZnjuJ
   6hPI1Nb57Exm+L15Sc6hX4sfXL9y5hYaSTcex21gkn13opeX8Y3gN1sbT
   VfxcgOXNWw4jgKF2/OqwmpH6E4ykvDmOAmQ0UdFpzbbnD5QH85nPVbHjp
   X5tTqCn/CljMenHSk4EeIXrBIZGKSPZLxSYeAvzrk9sHphZfJy6fnxlx8
   A==;
IronPort-SDR: 7eE/OADRVmKkBQCE2WVfPKqWces6ZpzepzZdNk1bKrayHYJ2CeliBbGSDrNyruMy5RITRx8a29
 33HTXPIZngsjWD4uJ+OgIVb/EZEP9+QamImzIhKekbSteuMbypZ594LIswU7UOdOei5fBvPdNU
 XPWPdChbRNrhxY020JJBEfGfkZzc316wTRamOXIyJRzbLxcp2MB75ZNwsAuax9wSyxilW7YKG1
 lvSulwxEuUSD2EukVjpvYgkHrCc4idvlWGmLhWMTvTY6fY5PFGXEwSFchcDkNGd0RCOOxS878u
 DVs=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="240483830"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:32:49 +0800
IronPort-SDR: tOlTiSK02y0h08JDRgPfG05bPTipZGRyhOayVbA8n/XdFOh8+ZmylLRBRsWOUwtYFVst3YP/GE
 PmVsJalCBYclSs41Wmt50JdauIklyRMTE=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:22:41 -0700
IronPort-SDR: hpuMYQ7/up5E208FevjWUcLVXvu+3sW5l1DEvqoLGekKM6hatLdFbSKURdeHN1Day2TTOirJIA
 FT+qa1363q3w==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:32:26 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        asutoshd@codeaurora.org, Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [RFC PATCH 09/13] scsi: ufshpb: Add response API
Date:   Fri, 15 May 2020 13:30:10 +0300
Message-Id: <1589538614-24048-10-git-send-email-avri.altman@wdc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
References: <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Here we've arrived to the second duty of the ufshpb module which mainly
concern the HPB cache management.  Once a HPB response is detected, the
information encapsulated within needs to be transferred to the cache
management engine in the scsi device handler.

Those upiu responses needs to be decoded and managed as a deferred work,
because it received as part of the completion interrupt context. Also,
as either command response may carry those, several responses needs to
be delivered concurrently.

To support the above, we've elaborated the ufshpb_lun structure as we
promised, to include whatever is needed to manage those HPB responses.
Basically we are using 2 linked list, a spinlock and a tasklet. We are
using a tasklet here instead of a worker to get a better responsiveness
because our response element resources are limited.
We are pre-allocating 32 response elements, because there can be up to
32 responses per completion interrupt.

Once the response is decoded we notify the device handler via its
"set_params" handler. Although the documentation specify a pre-defined
protocol, it is not enforced and is wide open to per-handler inner
implementation.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c     |   4 +
 drivers/scsi/ufs/ufshpb.c     | 202 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h     |   3 +
 include/scsi/scsi_dh_ufshpb.h |  17 ++++
 4 files changed, 226 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c2011bf..9adb743 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4779,6 +4779,10 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 				 */
 				pm_runtime_get_noresume(hba->dev);
 			}
+
+			if (ufshcd_is_hpb_supported(hba) &&
+			    scsi_status == SAM_STAT_GOOD)
+				ufshpb_rsp_upiu(hba, lrbp);
 			break;
 		case UPIU_TRANSACTION_REJECT_UPIU:
 			/* TODO: handle Reject UPIU Response */
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index be926cb..c3541f2 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -20,14 +20,38 @@
 #define GEO_DESC_HPB_SIZE (0x4D)
 #define UNIT_DESC_HPB_SIZE (0x29)
 
+/* hpb response */
+#define RSP_UPDATE_ALERT (0x20000)
+#define RSP_SENSE_DATA_LEN (0x12)
+#define RSP_DES_TYPE	 (0x80)
+#define MASK_RSP_UPIU_LUN (0xff)
+#define MASK_RSP_UPIU_DESC (0xff000000)
+#define MASK_RSP_UPIU_OPER (0xff00)
+#define MASK_RSP_ACTIVE_CNT (0xff00)
+#define MASK_RSP_INACTIVE_CNT (0xff)
+
 enum ufshpb_control_modes {
 	UFSHPB_HOST_CONTROL,
 	UFSHPB_DEVICE_CONTROL
 };
 
+#define RSP_DATA_SEG_LEN (sizeof(struct ufshpb_sense_data))
+
+struct ufshpb_rsp_element {
+	struct ufshpb_sense_data sense_data;
+	struct list_head list;
+};
+
 struct ufshpb_lun {
 	u8 lun;
 	struct scsi_device *sdev;
+
+	/* to manage hpb responses */
+	struct ufshpb_rsp_element *rsp_elements;
+	struct list_head lh_rsp;
+	struct list_head lh_rsp_free;
+	spinlock_t rsp_list_lock;
+	struct tasklet_struct rsp_tasklet;
 };
 
 
@@ -36,6 +60,157 @@ struct ufshpb_lun_config *ufshpb_luns_conf;
 struct ufshpb_lun *ufshpb_luns;
 static unsigned long ufshpb_lun_map[BITS_TO_LONGS(UFSHPB_MAX_LUNS)];
 static u8 ufshpb_lun_lookup[UFSHPB_MAX_LUNS];
+static u8 hba_nutrs;
+
+static void ufshpb_dh_notify(struct ufshpb_lun *hpb,
+			     struct ufshpb_sense_data *sense)
+{
+	struct ufs_hba *hba = shost_priv(hpb->sdev->host);
+
+	spin_lock(hba->host->host_lock);
+
+	if (scsi_device_get(hpb->sdev)) {
+		spin_unlock(hba->host->host_lock);
+		return;
+	}
+
+	scsi_dh_set_params(hpb->sdev->request_queue, (const char *)sense);
+
+	scsi_device_put(hpb->sdev);
+
+	spin_unlock(hba->host->host_lock);
+}
+
+static struct ufshpb_rsp_element *
+ufshpb_get_rsp_elem(struct ufshpb_lun *hpb, struct list_head *head)
+{
+	struct ufshpb_rsp_element *rsp_elem;
+
+	lockdep_assert_held(&hpb->rsp_list_lock);
+
+	rsp_elem = list_first_entry_or_null(head, struct ufshpb_rsp_element,
+					    list);
+	if (rsp_elem)
+		list_del_init(&rsp_elem->list);
+
+	return rsp_elem;
+}
+
+static void ufshpb_tasklet_fn(unsigned long priv)
+{
+	struct ufshpb_lun *hpb = (struct ufshpb_lun *)priv;
+	struct ufshpb_rsp_element *rsp_elem = NULL;
+	unsigned long flags;
+
+	while (1) {
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+		rsp_elem = ufshpb_get_rsp_elem(hpb, &hpb->lh_rsp);
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+
+		if (!rsp_elem)
+			return;
+
+		ufshpb_dh_notify(hpb, &rsp_elem->sense_data);
+
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+		list_add_tail(&rsp_elem->list, &hpb->lh_rsp_free);
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+	}
+}
+
+/* in host managed mode - ignore region inactivation hints */
+static bool ufshpb_need_to_respond(struct ufshpb_sense_data *hpb_sense,
+				   u8 *sense)
+{
+	hpb_sense->active_reg_cnt =
+		(get_unaligned_be16(sense + 4) & MASK_RSP_ACTIVE_CNT) >> 8;
+
+	if (!hpb_sense->active_reg_cnt)
+		return false;
+
+	/* read 1st region/sub-region to activate */
+	hpb_sense->active_reg_0 = get_unaligned_be16(sense + 6);
+	hpb_sense->active_subreg_0 = get_unaligned_be16(sense + 8);
+
+	if (hpb_sense->active_reg_cnt == 1)
+		return true;
+
+	/* read 2nd region/sub-region to activate */
+	hpb_sense->active_reg_1 = get_unaligned_be16(sense + 10);
+	hpb_sense->active_subreg_1 = get_unaligned_be16(sense + 12);
+
+	return true;
+}
+
+void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct ufshpb_lun *hpb;
+	struct ufshpb_rsp_element *rsp_elem;
+	u32 dword2 = get_unaligned_be32(&lrbp->ucd_rsp_ptr->header.dword_2);
+	u32 data_seg_len = dword2 & MASK_RSP_UPIU_DATA_SEG_LEN;
+	u16 sense_data_len;
+	u8 lun, desc_type, oper, i;
+
+	if (data_seg_len != RSP_DATA_SEG_LEN)
+		return;
+
+	if (!(dword2 & RSP_UPDATE_ALERT))
+		return;
+
+	sense_data_len =
+		get_unaligned_be16(&lrbp->ucd_rsp_ptr->sr.sense_data_len);
+	if (sense_data_len != RSP_SENSE_DATA_LEN)
+		return;
+
+	lun = get_unaligned_be32(lrbp->ucd_rsp_ptr->sr.sense_data) &
+				 MASK_RSP_UPIU_LUN;
+
+	if (lun >= UFSHPB_MAX_LUNS)
+		return;
+
+	if (!test_bit(lun, ufshpb_lun_map))
+		return;
+
+	i = READ_ONCE(ufshpb_lun_lookup[lun]);
+	if (i > ufshpb_conf->num_hpb_luns)
+		return;
+
+	desc_type = (get_unaligned_be32(lrbp->ucd_rsp_ptr->sr.sense_data) &
+		     MASK_RSP_UPIU_DESC) >> 24;
+	if (desc_type != RSP_DES_TYPE)
+		return;
+
+	oper = (get_unaligned_be32(lrbp->ucd_rsp_ptr->sr.sense_data) &
+		MASK_RSP_UPIU_OPER) >> 8;
+	if (!oper)
+		return;
+
+	hpb = ufshpb_luns + i;
+
+	spin_lock_irq(&hpb->rsp_list_lock);
+	rsp_elem = ufshpb_get_rsp_elem(hpb, &hpb->lh_rsp_free);
+	spin_unlock_irq(&hpb->rsp_list_lock);
+	if (!rsp_elem) {
+		dev_err(hba->dev, "no rsp element available\n");
+		return;
+	}
+
+	memset(&rsp_elem->sense_data, 0x00, data_seg_len);
+	rsp_elem->sense_data.lun = lun;
+	if (!ufshpb_need_to_respond(&rsp_elem->sense_data,
+				    lrbp->ucd_rsp_ptr->sr.sense_data)){
+		spin_lock_irq(&hpb->rsp_list_lock);
+		list_move_tail(&rsp_elem->list, &hpb->lh_rsp_free);
+		spin_unlock_irq(&hpb->rsp_list_lock);
+		return;
+	}
+
+	spin_lock_irq(&hpb->rsp_list_lock);
+	list_move_tail(&rsp_elem->list, &hpb->lh_rsp);
+	spin_unlock_irq(&hpb->rsp_list_lock);
+
+	tasklet_schedule(&hpb->rsp_tasklet);
+}
 
 void ufshpb_remove_lun(u8 lun)
 {
@@ -52,6 +227,8 @@ void ufshpb_remove_lun(u8 lun)
 		scsi_dh_release_device(hpb->sdev);
 		scsi_device_put(hpb->sdev);
 	}
+	kfree(hpb->rsp_elements);
+	tasklet_kill(&hpb->rsp_tasklet);
 }
 
 /**
@@ -162,8 +339,31 @@ static int ufshpb_hpb_init(void)
 
 	for (i = 0; i < num_hpb_luns; i++) {
 		struct ufshpb_lun *hpb = ufshpb_luns + i;
+		struct ufshpb_rsp_element *rsp_elements;
+		u8 num_rsp_elements = hba_nutrs;
+		int j;
 
 		hpb->lun = (ufshpb_luns_conf + i)->lun;
+
+		INIT_LIST_HEAD(&hpb->lh_rsp_free);
+		INIT_LIST_HEAD(&hpb->lh_rsp);
+		spin_lock_init(&hpb->rsp_list_lock);
+		tasklet_init(&hpb->rsp_tasklet, ufshpb_tasklet_fn,
+			     (unsigned long)hpb);
+
+		rsp_elements = kcalloc(num_rsp_elements, sizeof(*rsp_elements),
+				       GFP_KERNEL);
+		if (!rsp_elements)
+			return -ENOMEM;
+
+		for (j = 0; j < num_rsp_elements; j++) {
+			struct ufshpb_rsp_element *rsp_elem = rsp_elements + j;
+
+			INIT_LIST_HEAD(&rsp_elem->list);
+			list_add_tail(&rsp_elem->list, &hpb->lh_rsp_free);
+		}
+
+		hpb->rsp_elements = rsp_elements;
 	}
 
 	return 0;
@@ -386,6 +586,8 @@ int ufshpb_probe(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	hba_nutrs = hba->nutrs;
+
 	ret = ufshpb_hpb_init();
 	if (ret)
 		goto out;
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 276a749..52e7994 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -15,11 +15,14 @@ struct ufs_hba;
 void ufshpb_remove(struct ufs_hba *hba);
 int ufshpb_probe(struct ufs_hba *hba);
 void ufshpb_attach_sdev(struct ufs_hba *hba, struct scsi_device *sdev);
+void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
 #else
 static inline void ufshpb_remove(struct ufs_hba *hba) {}
 static inline int ufshpb_probe(struct ufs_hba *hba) { return 0; }
 static inline void
 ufshpb_attach_sdev(struct ufs_hba *hba, struct scsi_device *sdev) {}
+static inline
+void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {};
 #endif
 
 #endif /* _UFSHPB_H */
diff --git a/include/scsi/scsi_dh_ufshpb.h b/include/scsi/scsi_dh_ufshpb.h
index 3dcb442..bb6ea44 100644
--- a/include/scsi/scsi_dh_ufshpb.h
+++ b/include/scsi/scsi_dh_ufshpb.h
@@ -46,5 +46,22 @@ struct ufshpb_config {
 	u16 max_active_regions;
 	u8 num_hpb_luns;
 };
+
+/* per JEDEC spec JESD220-3 Table 6.7 — HPB Sense Data */
+struct ufshpb_sense_data {
+	u16 sense_data_len;
+	u8 desc_type;
+	u8 additional_len;
+	u8 oper;
+	u8 lun;
+	u8 active_reg_cnt;
+	u8 inactive_reg_cnt;
+	u16 active_reg_0;
+	u16 active_subreg_0;
+	u16 active_reg_1;
+	u16 active_subreg_1;
+	u16 inactive_reg_0;
+	u16 inactive_reg_1;
+};
 #endif /* _SCSI_DH_UFSHPB_H */
 
-- 
2.7.4

