Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C210DCA9EBC
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A11902166E
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 14:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502597AbfJXOLn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Oct 2019 10:11:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5161 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391409AbfJXOLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Oct 2019 10:11:43 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 60E745363B7315A47AA4;
        Thu, 24 Oct 2019 22:11:35 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 24 Oct 2019 22:11:29 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 18/18] scsi: hisi_sas: Record the phy down event in debugfs
Date:   Thu, 24 Oct 2019 22:08:25 +0800
Message-ID: <1571926105-74636-19-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1571926105-74636-1-git-send-email-john.garry@huawei.com>
References: <1571926105-74636-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

The number of phy down reflects the quality of the link between SAS
controller and disk. In order to allow the user to confirm the link quality
of the system, we record the number of phy down for each phy.

The user can check the current phy down count by reading the debugfs file
corresponding to the specific phy, or clear the phy down count by writing 0
to the debugfs file.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 63 ++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  2 +
 3 files changed, 66 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 72823222e08f..233c73e01246 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -169,6 +169,7 @@ struct hisi_sas_phy {
 	enum sas_linkrate	minimum_linkrate;
 	enum sas_linkrate	maximum_linkrate;
 	int enable;
+	atomic_t down_cnt;
 };
 
 struct hisi_sas_port {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 669ad7463615..18c95b33592b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -3705,6 +3705,52 @@ static const struct file_operations hisi_sas_debugfs_bist_enable_ops = {
 	.owner = THIS_MODULE,
 };
 
+static ssize_t hisi_sas_debugfs_phy_down_cnt_write(struct file *filp,
+						   const char __user *buf,
+						   size_t count, loff_t *ppos)
+{
+	struct seq_file *s = filp->private_data;
+	struct hisi_sas_phy *phy = s->private;
+	unsigned int set_val;
+	int res;
+
+	res = kstrtouint_from_user(buf, count, 0, &set_val);
+	if (res)
+		return res;
+
+	if (set_val > 0)
+		return -EINVAL;
+
+	atomic_set(&phy->down_cnt, 0);
+
+	return count;
+}
+
+static int hisi_sas_debugfs_phy_down_cnt_show(struct seq_file *s, void *p)
+{
+	struct hisi_sas_phy *phy = s->private;
+
+	seq_printf(s, "%d\n", atomic_read(&phy->down_cnt));
+
+	return 0;
+}
+
+static int hisi_sas_debugfs_phy_down_cnt_open(struct inode *inode,
+					      struct file *filp)
+{
+	return single_open(filp, hisi_sas_debugfs_phy_down_cnt_show,
+			   inode->i_private);
+}
+
+static const struct file_operations hisi_sas_debugfs_phy_down_cnt_ops = {
+	.open = hisi_sas_debugfs_phy_down_cnt_open,
+	.read = seq_read,
+	.write = hisi_sas_debugfs_phy_down_cnt_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 void hisi_sas_debugfs_work_handler(struct work_struct *work)
 {
 	struct hisi_hba *hisi_hba =
@@ -3839,6 +3885,21 @@ static int hisi_sas_debugfs_alloc(struct hisi_hba *hisi_hba, int dump_index)
 	return -ENOMEM;
 }
 
+static void hisi_sas_debugfs_phy_down_cnt_init(struct hisi_hba *hisi_hba)
+{
+	struct dentry *dir = debugfs_create_dir("phy_down_cnt",
+						hisi_hba->debugfs_dir);
+	char name[16];
+	int phy_no;
+
+	for (phy_no = 0; phy_no < hisi_hba->n_phy; phy_no++) {
+		snprintf(name, 16, "%d", phy_no);
+		debugfs_create_file(name, 0600, dir,
+				    &hisi_hba->phy[phy_no],
+				    &hisi_sas_debugfs_phy_down_cnt_ops);
+	}
+}
+
 static void hisi_sas_debugfs_bist_init(struct hisi_hba *hisi_hba)
 {
 	hisi_hba->debugfs_bist_dentry =
@@ -3885,6 +3946,8 @@ void hisi_sas_debugfs_init(struct hisi_hba *hisi_hba)
 	hisi_hba->debugfs_dump_dentry =
 			debugfs_create_dir("dump", hisi_hba->debugfs_dir);
 
+	hisi_sas_debugfs_phy_down_cnt_init(hisi_hba);
+
 	for (i = 0; i < hisi_sas_debugfs_dump_count; i++) {
 		if (hisi_sas_debugfs_alloc(hisi_hba, i)) {
 			debugfs_remove_recursive(hisi_hba->debugfs_dir);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index e4da309009c0..2ae7070db41a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1549,6 +1549,8 @@ static irqreturn_t phy_down_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	u32 phy_state, sl_ctrl, txid_auto;
 	struct device *dev = hisi_hba->dev;
 
+	atomic_inc(&phy->down_cnt);
+
 	del_timer(&phy->timer);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 1);
 
-- 
2.17.1

