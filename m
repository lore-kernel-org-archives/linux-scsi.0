Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE84C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:32:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C59D2074D
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 10:32:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qtGO+2TK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgEOKcs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 06:32:48 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:36752 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbgEOKcr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 06:32:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589538767; x=1621074767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YgmgQBI3/QOUUTeCa2aJQTp6WmYN/FH1qGXjVQdlCU8=;
  b=qtGO+2TKLVwN80xW4xDdQ25n3NtTUjrBt47rDMipiJAlIbLO3Wb0BFhl
   0yEWkNoIspNVxMs3TRmjWrNYYtXVMMNYezXHqACJJiPTP7l0iNnColpeK
   m5zY1f4MKRBafLXqLivzl5DXbVEkLRAl2Vgjstm3xC3xVHZ8ZT2T1RjsF
   XK0U6Vr408DUCLeA39vHp8CDDe/OURni+xGipiO214NICZdPae5YPG0xU
   VYk6aFSxXoY0Wt9r8vJGqph7bf+/9RPYE9aoK42NaHC/eVF+Cr+xSW9xE
   PBnfaylTW2ciZ8Gv9PW78JBu8Inl456R/qIwRVLHgsGbPGnC4Lsx6yHLD
   A==;
IronPort-SDR: RIsqRjoIt4dYtwcN3gW0nuJ8n8OApAsgXB8rH5a4qGDqciDIbxILyi9nHavnJnAQt3W5RlEITN
 f79g6OVOVXmG50ujplCR1jODw3DGGVMUpSWWomhzCxURz4GtRPgUXbbNQiwf4OLm3umSgW8Hhz
 02xAV7SDxFI8I6G0iq42Z+C3yIUSgOcCyVQxmkK+OuvdSDafAWrKKYiqVFVzpfGqFDh2tdFNYX
 LdqDDUunO84XpNAuZNVZcNBQPRPKjJdqNDh+tYuhTY61dZhRcb0i94uAE+6Uj7Z1wUsZP2OLwV
 ZNk=
X-IronPort-AV: E=Sophos;i="5.73,394,1583164800"; 
   d="scan'208";a="139202571"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 May 2020 18:32:46 +0800
IronPort-SDR: K1AZXNbqKmZ7eNZZDMGZhGVCm0xmNO/SBfHJBwDRo+xV+rnSyy0T0zrVOwfiL21a470F8NrbOU
 M1av7OxQST8ppxu3XAZFD7JUQ1VNY0B+w=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 03:22:24 -0700
IronPort-SDR: S2n9p/KgrAq/sat6iEph12Y/KvxUz350O0yTO0Y64SSde2jlIwHJgME3f2bfvsK3hAzJbsbxO5
 MDQPdQcw6pNw==
WDCIronportException: Internal
Received: from ile422988.sdcorp.global.sandisk.com ([10.0.231.246])
  by uls-op-cesaip01.wdc.com with ESMTP; 15 May 2020 03:32:42 -0700
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
Subject: [RFC PATCH 10/13] scsi: dh: ufshpb: Add ufshpb_set_params
Date:   Fri, 15 May 2020 13:30:11 +0300
Message-Id: <1589538614-24048-11-git-send-email-avri.altman@wdc.com>
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

The ufshpb LLD intercepted a response from the device indicating that
some subregion(s) should be activated, or some region(s) should be
inactivated.  Each such message may carry info of up to 2 subregions to
activate, and up to 2 regions to inactivate.

Set the appropriate triggering events to those regions/subregions and
schedule the state machine handler.

In case the device lost the LUN’s HPB information for whatever reason,
it can signal to the host through HPB Sense data. On LUN reset, all of
its active subregions are being updated.

None of the above applies for pinned regions which are not affected by
any of this and stay active.

Inactivation of the entire LUN barriers heavy implications, both with
respect of performance: sending READ_10 instead of HPB_READ, as well as
with respect of overhead – re-activating the entire LUN.  One might
expect that a proper protection against frequent resets and / or
irrational device behavior should be in place.  However, it is out of
scope of the driver to cover for this.  Instead, issue a proper info
message.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/device_handler/scsi_dh_ufshpb.c | 131 +++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/scsi/device_handler/scsi_dh_ufshpb.c b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
index 8f85933..affc143 100644
--- a/drivers/scsi/device_handler/scsi_dh_ufshpb.c
+++ b/drivers/scsi/device_handler/scsi_dh_ufshpb.c
@@ -68,6 +68,16 @@ enum ufshpb_subregion_events {
 	SUBREGION_EVENT_MAX
 };
 
+enum ufshpb_response_opers {
+	OPER_TYPE_ACTIVATE	= 1,
+	OPER_TYPE_RESET		= 2,
+};
+
+enum ufshpb_work_locks {
+	LUN_RESET_WORK = BIT(0),
+};
+
+
 /**
  * struct map_ctx - a mapping context
  * @pages - array of pages
@@ -158,11 +168,13 @@ struct ufshpb_dh_lun {
 	unsigned int last_subregion_size;
 	unsigned int max_active_regions;
 
+	struct work_struct lun_reset_work;
 	atomic_t active_regions;
 
 	struct mutex eviction_lock;
 
 	struct workqueue_struct *wq;
+	unsigned long work_lock;
 };
 
 struct ufshpb_dh_data {
@@ -285,6 +297,9 @@ static bool ufshpb_read_buf_cmd_need_retry(struct ufshpb_dh_lun *hpb,
 	if (atomic_read(&hpb->active_regions) >= hpb->max_active_regions)
 		return false;
 
+	if (test_bit(LUN_RESET_WORK, &hpb->work_lock))
+		return false;
+
 	/* UFS3.1 spec says: "...
 	 * If the device is performing internal maintenance work, for example
 	 * Garbage collection, the device may terminate the HPB READ BUFFER
@@ -667,6 +682,43 @@ static int ufshpb_activate_pinned_regions(struct ufshpb_dh_data *h, bool init)
 	return ret;
 }
 
+static void __region_reset(struct ufshpb_dh_lun *hpb,
+			   struct ufshpb_region *r)
+{
+	struct ufshpb_subregion *subregions = r->subregion_tbl;
+	int j;
+
+	for (j = 0; j < subregions_per_region; j++) {
+		struct ufshpb_subregion *s = subregions + j;
+		int k;
+
+		mutex_lock(&s->state_lock);
+		ufshpb_subregion_update(hpb, r, s, true);
+		for (k = 0; k < SUBREGION_EVENT_MAX; k++)
+			clear_bit(k, &s->event);
+		mutex_unlock(&s->state_lock);
+	}
+}
+
+static void ufshpb_lun_reset_work_handler(struct work_struct *work)
+{
+	struct ufshpb_dh_lun *hpb = container_of(work, struct ufshpb_dh_lun,
+			lun_reset_work);
+	struct ufshpb_region *regions = hpb->region_tbl;
+	int i;
+
+	for (i = 0; i < hpb->regions_per_lun; i++) {
+		struct ufshpb_region *r = regions + i;
+
+		__region_reset(hpb, r);
+	}
+
+	clear_bit(LUN_RESET_WORK, &hpb->work_lock);
+
+	sdev_printk(KERN_INFO, hpb->sdev, "%s: lun reset [%llu]\n",
+		    UFSHPB_NAME, hpb->sdev->lun);
+}
+
 static int ufshpb_mempool_init(struct ufshpb_dh_lun *hpb)
 {
 	unsigned int max_active_subregions = hpb->max_active_regions *
@@ -736,6 +788,7 @@ static int ufshpb_region_tbl_init(struct ufshpb_dh_lun *hpb)
 
 	hpb->region_tbl = regions;
 	mutex_init(&hpb->eviction_lock);
+	INIT_WORK(&hpb->lun_reset_work, ufshpb_lun_reset_work_handler);
 
 	return 0;
 
@@ -826,6 +879,83 @@ static void ufshpb_get_config(const struct ufshpb_config *c)
 	is_configured = true;
 }
 
+/*
+ * ufshpb_set_params - obtain response from the device
+ * @sdev: scsi device of the hpb lun
+ * params - a hpb sense data buffer copied from the device
+ *
+ * set the appropriate triggers for the various regions/subregions
+ * each hpb sense buffer carries the information of up to 2 subregions to
+ * activate.
+ */
+static int ufshpb_set_params(struct scsi_device *sdev, const char *params)
+{
+	struct ufshpb_dh_data *h = sdev->handler_data;
+	struct ufshpb_dh_lun *hpb = h->hpb;
+	struct ufshpb_region *r;
+	struct ufshpb_subregion *s;
+	struct ufshpb_sense_data sense = {};
+	enum ufshpb_state s_state;
+	u16 *pos;
+	u16 region, subregion;
+	int ret;
+	u8 active_reg_cnt = 0;
+
+	memcpy(&sense, params, sizeof(sense));
+
+	if (sense.oper == OPER_TYPE_RESET) {
+		struct ufshpb_dh_lun *rst_hpb;
+
+		list_for_each_entry(rst_hpb, &lh_hpb_lunp, list) {
+			set_bit(LUN_RESET_WORK, &rst_hpb->work_lock);
+			queue_work(rst_hpb->wq, &rst_hpb->lun_reset_work);
+		}
+		return 0;
+	}
+
+	/* is there any subregions to activate? */
+	if (!sense.active_reg_cnt)
+		return -EINVAL;
+
+	active_reg_cnt = sense.active_reg_cnt;
+	if (active_reg_cnt > 2) {
+		/* HPB1.0 allows the device to signal up to 2 subregions */
+		return -EINVAL;
+	}
+
+	ret = 0;
+
+	pos = &sense.active_reg_0;
+
+	do {
+		region = *pos++;
+		subregion = *pos;
+
+		if (region >= hpb->regions_per_lun ||
+				subregion >= subregions_per_region)
+			return -EINVAL;
+
+		r = hpb->region_tbl + region;
+		s = r->subregion_tbl + subregion;
+
+		rcu_read_lock();
+		s_state = s->state;
+		rcu_read_unlock();
+
+		if (s_state == HPB_STATE_ACTIVE)
+			set_bit(SUBREGION_EVENT_UPDATE, &s->event);
+		else
+			set_bit(SUBREGION_EVENT_ACTIVATE, &s->event);
+
+		queue_work(hpb->wq, &s->hpb_work);
+
+		pos++;
+
+	} while (--active_reg_cnt);
+
+	return ret;
+}
+
 static int ufshpb_activate(struct scsi_device *sdev, activate_complete fn,
 			   void *data)
 {
@@ -939,6 +1069,7 @@ static struct scsi_device_handler ufshpb_dh = {
 	.attach		= ufshpb_attach,
 	.detach		= ufshpb_detach,
 	.activate	= ufshpb_activate,
+	.set_params     = ufshpb_set_params,
 };
 
 static int __init ufshpb_init(void)
-- 
2.7.4

