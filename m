Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57BA2C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A2FC611C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:34:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhFGJgH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 05:36:07 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3158 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbhFGJgG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 05:36:06 -0400
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Fz7Ht4nRTz6G7h5;
        Mon,  7 Jun 2021 17:24:58 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 11:34:14 +0200
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 10:34:11 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 1/5] scsi: hisi_sas: Put a limit of link reset retries
Date:   Mon, 7 Jun 2021 17:29:35 +0800
Message-ID: <1623058179-80434-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623058179-80434-1-git-send-email-john.garry@huawei.com>
References: <1623058179-80434-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

If an OOB event is received but the phy still fails to come up, a link
reset will be issued repeatedly at an interval of 20s until the phy comes
up.

Set a limit for link reset issue retries to avoid printing the timeout
message endlessly.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c | 15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index cf879cc59e4c..8e36ede12cf1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -185,6 +185,7 @@ struct hisi_sas_phy {
 	enum sas_linkrate	minimum_linkrate;
 	enum sas_linkrate	maximum_linkrate;
 	int enable;
+	int wait_phyup_cnt;
 	atomic_t down_cnt;
 
 	/* Trace FIFO */
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 5a204074099c..50420741fc81 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -857,6 +857,7 @@ static void hisi_sas_phyup_work(struct work_struct *work)
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	int phy_no = sas_phy->id;
 
+	phy->wait_phyup_cnt = 0;
 	if (phy->identify.target_port_protocols == SAS_PROTOCOL_SSP)
 		hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
 	hisi_sas_bytes_dmaed(hisi_hba, phy_no, GFP_KERNEL);
@@ -899,6 +900,8 @@ static void hisi_sas_wait_phyup_timedout(struct timer_list *t)
 	hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
 }
 
+#define HISI_SAS_WAIT_PHYUP_RETRIES	10
+
 void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
@@ -909,8 +912,16 @@ void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no)
 		return;
 
 	if (!timer_pending(&phy->timer)) {
-		phy->timer.expires = jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT * HZ;
-		add_timer(&phy->timer);
+		if (phy->wait_phyup_cnt < HISI_SAS_WAIT_PHYUP_RETRIES) {
+			phy->wait_phyup_cnt++;
+			phy->timer.expires = jiffies +
+					     HISI_SAS_WAIT_PHYUP_TIMEOUT * HZ;
+			add_timer(&phy->timer);
+		} else {
+			dev_warn(dev, "phy%d failed to come up %d times, giving up\n",
+				 phy_no, phy->wait_phyup_cnt);
+			phy->wait_phyup_cnt = 0;
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(hisi_sas_phy_oob_ready);
-- 
2.26.2

