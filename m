Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4FC1F95E
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 02:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728353914; cv=none; b=qnDo+GveikisVWlaqsxlT8xJu47am68byWytbZuMMc+0TSagIlb8FZgrNwBTmZxwkejUdN6KfK/7tTWgzi0AOODtohFa7CjynWrDDtMZ9zg2AE4VdJ/WLPSe0PpAkpNnG2ZsMCEzQrdVh96fAMC9Mg1qYygTPDzESzSchRBqblg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728353914; c=relaxed/simple;
	bh=BLl+1LQCXTCeMlsN9UCInpisKwT9FJpbLvyHpJ7Kv6s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZhYqrF8zqnEfdCi9t6PFYfPdPgNVXcnRiT72Zn+OuFhefchxOKA80UFXcZOx9gT2Jj9945wpWmwEGzvTlSOIqd0HSNdZCaT3SSAmcsTVkSAoqsabt6DOn70UaRbEWE6mJZNaH7dkGmbEwatAyHDUIOUBROQP9ykrvfVjpE84nRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4XN02T208Rz1HKL1;
	Tue,  8 Oct 2024 10:14:25 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 8917614013B;
	Tue,  8 Oct 2024 10:18:29 +0800 (CST)
Received: from localhost.huawei.com (10.50.165.33) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 8 Oct 2024 10:18:29 +0800
From: Yihang Li <liyihang9@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liyihang9@huawei.com>
Subject: [PATCH v2 13/13] scsi: hisi_sas: Add latest_dump for the debugfs dump
Date: Tue, 8 Oct 2024 10:18:22 +0800
Message-ID: <20241008021822.2617339-14-liyihang9@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20241008021822.2617339-1-liyihang9@huawei.com>
References: <20241008021822.2617339-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

