Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A6A174EDF
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 01:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727315018; cv=none; b=eZc7LH2+K/lZNSpdGeUFujHFMknhJGlIanz1xV46bz5Xl2IF4cW9CMUQF3eHSrnpKLNLEZS1kCHnqk1XFve1PCEtlE+YevSJsDelO98Iqcv3mVkKZC79WCfDu7cD1yc/22w8d5mMSeQytV6jsxBsczvqwnfQtaOQUN0lM6KjVp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727315018; c=relaxed/simple;
	bh=BLl+1LQCXTCeMlsN9UCInpisKwT9FJpbLvyHpJ7Kv6s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MZPf/uks9BzKpwQwndY+jjKVPyrPf5fzwt3i2N61iRdIfw/V2Cp4QVC++vfsXNsVzMN6J7BvsDdoSqu7wsx1LdmD1TQpxvbyFiAc8HZZIFXm9RPKIzx/4gBb87cElwbj/s8jYp9GNTvF3WUU5vcNxa6RmNIJ6zpnLQEUxYCwj9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4XDbtm6wRvz10MfM;
	Thu, 26 Sep 2024 09:42:08 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 146891401E0;
	Thu, 26 Sep 2024 09:43:35 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Sep 2024 09:43:34 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH 13/13] scsi: hisi_sas: Add latest_dump for the debugfs dump
Date: Thu, 26 Sep 2024 09:43:32 +0800
Message-ID: <20240926014332.3905399-14-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240926014332.3905399-1-liyihang9@huawei.com>
References: <20240926014332.3905399-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)

Before that, after the user triggers the dump, the latest dump information
can be viewed in the directory with the maximum number in the dump
directory.

After this series patch, the driver creates all debugfs directories and
files during initialization. Therefore, users cannot know the directory
where the latest dump information is stored. So, add latest_dump file to
notify users where the latest dump information is stored.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Reviewed-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 8250d44f0b3e..5db931663ae4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -4814,6 +4814,19 @@ static void debugfs_bist_init_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->debugfs_bist_linkrate = SAS_LINK_RATE_1_5_GBPS;
 }
 
+static int debugfs_dump_index_v3_hw_show(struct seq_file *s, void *p)
+{
+	int *debugfs_dump_index = s->private;
+
+	if (*debugfs_dump_index > 0)
+		seq_printf(s, "%d\n", *debugfs_dump_index - 1);
+	else
+		seq_puts(s, "dump not triggered\n");
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(debugfs_dump_index_v3_hw);
+
 static void debugfs_dump_init_v3_hw(struct hisi_hba *hisi_hba)
 {
 	int i;
@@ -4821,6 +4834,10 @@ static void debugfs_dump_init_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->debugfs_dump_dentry =
 			debugfs_create_dir("dump", hisi_hba->debugfs_dir);
 
+	debugfs_create_file("latest_dump", 0400, hisi_hba->debugfs_dump_dentry,
+			    &hisi_hba->debugfs_dump_index,
+			    &debugfs_dump_index_v3_hw_fops);
+
 	for (i = 0; i < hisi_sas_debugfs_dump_count; i++)
 		debugfs_create_files_v3_hw(hisi_hba, i);
 }
-- 
2.33.0

