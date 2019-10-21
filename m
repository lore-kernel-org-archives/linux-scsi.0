Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536D6CA9EAF
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:25:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 301B020873
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 16:25:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfJUQZm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:25:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36526 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729723AbfJUQZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 12:25:40 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1C956FB40DD4E597079D;
        Tue, 22 Oct 2019 00:25:30 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 22 Oct 2019 00:25:19 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH 09/18] scsi: hisi_sas: Add debugfs file structure for port
Date:   Tue, 22 Oct 2019 00:22:06 +0800
Message-ID: <1571674935-108326-10-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
References: <1571674935-108326-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Create a file structure which was used to save the memory address and
phy pointer for port at debugfs. This structure is bound to the
corresponding debugfs file, it can help callback function of debugfs file
to get what it need.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  7 ++++++-
 drivers/scsi/hisi_sas/hisi_sas_main.c | 21 ++++++++++++---------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 1c01e0e76a0e..af5f836e5807 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -338,6 +338,11 @@ struct hisi_sas_debugfs_regs {
 	u32 *data;
 };
 
+struct hisi_sas_debugfs_port {
+	struct hisi_sas_phy *phy;
+	u32 *data;
+};
+
 struct hisi_hba {
 	/* This must be the first element, used by SHOST_TO_SAS_HA */
 	struct sas_ha_struct *p;
@@ -420,7 +425,7 @@ struct hisi_hba {
 	/* debugfs memories */
 	/* Put Global AXI and RAS Register into register array */
 	struct hisi_sas_debugfs_regs debugfs_regs[DEBUGFS_REGS_NUM];
-	u32 *debugfs_port_reg[HISI_SAS_MAX_PHYS];
+	struct hisi_sas_debugfs_port debugfs_port_reg[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_debugfs_cq debugfs_cq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_debugfs_dq debugfs_dq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_iost *debugfs_iost;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2553fb75c2ca..b225717a6b0a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2732,7 +2732,7 @@ static void hisi_sas_debugfs_snapshot_port_reg(struct hisi_hba *hisi_hba)
 	u32 *databuf;
 
 	for (phy_cnt = 0; phy_cnt < hisi_hba->n_phy; phy_cnt++) {
-		databuf = (u32 *)hisi_hba->debugfs_port_reg[phy_cnt];
+		databuf = hisi_hba->debugfs_port_reg[phy_cnt].data;
 		for (i = 0; i < port->count; i++, databuf++) {
 			offset = port->base_off + 4 * i;
 			*databuf = port->read_port_reg(hisi_hba, phy_cnt,
@@ -2933,13 +2933,13 @@ static const struct file_operations hisi_sas_debugfs_ras_fops = {
 
 static int hisi_sas_debugfs_port_show(struct seq_file *s, void *p)
 {
-	struct hisi_sas_phy *phy = s->private;
+	struct hisi_sas_debugfs_port *port = s->private;
+	struct hisi_sas_phy *phy = port->phy;
 	struct hisi_hba *hisi_hba = phy->hisi_hba;
 	const struct hisi_sas_hw *hw = hisi_hba->hw;
 	const struct hisi_sas_debugfs_reg *reg_port = hw->debugfs_reg_port;
-	u32 *databuf = hisi_hba->debugfs_port_reg[phy->sas_phy.id];
 
-	hisi_sas_debugfs_print_reg(databuf, reg_port, s);
+	hisi_sas_debugfs_print_reg(port->data, reg_port, s);
 
 	return 0;
 }
@@ -3221,7 +3221,8 @@ static void hisi_sas_debugfs_create_files(struct hisi_hba *hisi_hba)
 	for (p = 0; p < hisi_hba->n_phy; p++) {
 		snprintf(name, 256, "%d", p);
 
-		debugfs_create_file(name, 0400, dentry, &hisi_hba->phy[p],
+		debugfs_create_file(name, 0400, dentry,
+				    &hisi_hba->debugfs_port_reg[p],
 				    &hisi_sas_debugfs_port_fops);
 	}
 
@@ -3726,7 +3727,7 @@ static void hisi_sas_debugfs_release(struct hisi_hba *hisi_hba)
 		devm_kfree(dev, hisi_hba->debugfs_regs[i].data);
 
 	for (i = 0; i < hisi_hba->n_phy; i++)
-		devm_kfree(dev, hisi_hba->debugfs_port_reg[i]);
+		devm_kfree(dev, hisi_hba->debugfs_port_reg[i].data);
 }
 
 static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
@@ -3749,11 +3750,13 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba)
 
 	sz = hw->debugfs_reg_port->count * 4;
 	for (p = 0; p < hisi_hba->n_phy; p++) {
-		hisi_hba->debugfs_port_reg[p] =
-			devm_kmalloc(dev, sz, GFP_KERNEL);
+		struct hisi_sas_debugfs_port *port =
+				&hisi_hba->debugfs_port_reg[p];
 
-		if (!hisi_hba->debugfs_port_reg[p])
+		port->data = devm_kmalloc(dev, sz, GFP_KERNEL);
+		if (!port->data)
 			goto fail;
+		port->phy = &hisi_hba->phy[p];
 	}
 
 	sz = hw->complete_hdr_size * HISI_SAS_QUEUE_SLOTS;
-- 
2.17.1

