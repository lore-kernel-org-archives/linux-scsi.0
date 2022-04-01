Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FABC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 14:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348076AbiDAOhY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348216AbiDAOdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 10:33:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7901EA5F2;
        Fri,  1 Apr 2022 07:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E53A261CA5;
        Fri,  1 Apr 2022 14:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CF1C36AE2;
        Fri,  1 Apr 2022 14:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823476;
        bh=OENflkaK3Qs+EfOVFmDHxnNYCJErsU7L/iykIogJmXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcCN/f29jGSD/HBUqihCw35Ah5hA+4J8CuPiBY7s42wMc4Rhp8SQiqJrYW/A7dn5w
         E8GkLUM3PdcPFbRtwjeisG4FIeajEP6wwlzdb4W0WxoU+PItkwrzWBOHinjaxwpdvH
         SsoA5Qc/kB/vWNUshc1qrZOEEHl9mPqwb3jYTq0TODYn5ZQbwQd0xLYD3cuNFcFGr6
         uvKwlt7YIhgES0Aso434QB/vtn3CyKD2d+LxOf5Wafk4nMbxGGB8+n24Hzx0m8VjkP
         iRf/rcJL1S0LOVWwPdgngDL+pp+tc9ocertvsA//HMyz9tLYBA8j3Z05qjcGTd7Hg1
         xo3gHOvEC6yMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 108/149] scsi: hisi_sas: Limit users changing debugfs BIST count value
Date:   Fri,  1 Apr 2022 10:24:55 -0400
Message-Id: <20220401142536.1948161-108-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 286ce4c65fbdf5eb9d4d5f4e4997c4e32bf1b073 ]

Add a file operation for "cnt" file under bist directory, so users can only
read "cnt" or clear "cnt" to zero, but cannot randomly modify.

Link: https://lore.kernel.org/r/1645703489-87194-6-git-send-email-john.garry@huawei.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Qi Liu <liuqi115@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 52 +++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index ce0d4bfbe51e..ee7be7d51a21 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3976,6 +3976,54 @@ static const struct file_operations debugfs_bist_phy_v3_hw_fops = {
 	.owner = THIS_MODULE,
 };
 
+static ssize_t debugfs_bist_cnt_v3_hw_write(struct file *filp,
+					const char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct seq_file *m = filp->private_data;
+	struct hisi_hba *hisi_hba = m->private;
+	unsigned int cnt;
+	int val;
+
+	if (hisi_hba->debugfs_bist_enable)
+		return -EPERM;
+
+	val = kstrtouint_from_user(buf, count, 0, &cnt);
+	if (val)
+		return val;
+
+	if (cnt)
+		return -EINVAL;
+
+	hisi_hba->debugfs_bist_cnt = 0;
+	return count;
+}
+
+static int debugfs_bist_cnt_v3_hw_show(struct seq_file *s, void *p)
+{
+	struct hisi_hba *hisi_hba = s->private;
+
+	seq_printf(s, "%u\n", hisi_hba->debugfs_bist_cnt);
+
+	return 0;
+}
+
+static int debugfs_bist_cnt_v3_hw_open(struct inode *inode,
+					  struct file *filp)
+{
+	return single_open(filp, debugfs_bist_cnt_v3_hw_show,
+			   inode->i_private);
+}
+
+static const struct file_operations debugfs_bist_cnt_v3_hw_ops = {
+	.open = debugfs_bist_cnt_v3_hw_open,
+	.read = seq_read,
+	.write = debugfs_bist_cnt_v3_hw_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static const struct {
 	int		value;
 	char		*name;
@@ -4613,8 +4661,8 @@ static void debugfs_bist_init_v3_hw(struct hisi_hba *hisi_hba)
 	debugfs_create_file("phy_id", 0600, hisi_hba->debugfs_bist_dentry,
 			    hisi_hba, &debugfs_bist_phy_v3_hw_fops);
 
-	debugfs_create_u32("cnt", 0600, hisi_hba->debugfs_bist_dentry,
-			   &hisi_hba->debugfs_bist_cnt);
+	debugfs_create_file("cnt", 0600, hisi_hba->debugfs_bist_dentry,
+			    hisi_hba, &debugfs_bist_cnt_v3_hw_ops);
 
 	debugfs_create_file("loopback_mode", 0600,
 			    hisi_hba->debugfs_bist_dentry,
-- 
2.34.1

