Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BA423C8AE;
	Sun, 14 Sep 2025 10:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757844689; cv=none; b=EODcJ1mmyvB9OVUq1Fn0Q+AH/XgUuw3qHb6gl7g9UN0+kX8iXjSLYYztx8VC7iE/rH/CRUWsM+2dMGW8e1uvandhyvqJg6QPCJ6LcjheLO8E+buatfT9Gm4R5rF6kfciVlekkvBfm/0NbtF+mlubTYPqt+DpiUtdzdjNFYJyfqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757844689; c=relaxed/simple;
	bh=bOuxSEJpCFPZ22gagljLYxEievhn979D7a2mhkiEWQw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hzFfOwPo1JBfWxdss3YKuh07KjTqWnW/I/YZqmtRVcuB/Snig/bosFFe789N+SQYzowEMl4jbuRdeRiHuSy1VwZGA4bbdCeodP690FqmS2Q9uIpoVyXtgNkxO5skzwBSXD2MFLWoEBizpocBt99UsiEZWA/LBpZgbt1+QY27Gm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cPkN31Nk1z5vMb;
	Sun, 14 Sep 2025 18:06:43 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 67FB318006C;
	Sun, 14 Sep 2025 18:11:20 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 14 Sep 2025 18:11:19 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <dlemoal@kernel.org>,
	<hewenliang4@huawei.com>, <yangyun50@huawei.com>, <wuyifeng10@huawei.com>,
	<yangxingui@h-partners.com>
Subject: [RFC PATCH v4 7/9] scsi: scsi_error: Add helper to handle scsi device's error command list
Date: Sun, 14 Sep 2025 18:41:43 +0800
Message-ID: <20250914104145.2239901-8-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250914104145.2239901-1-jiangjianjun3@huawei.com>
References: <17230842-0a7a-403e-abc7-a15e3aa5d424@suse.de>
 <20250914104145.2239901-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk500001.china.huawei.com (7.202.194.86)

From: Wenchao Hao <haowenchao2@huawei.com>

Add helper scsi_sdev_eh() to handle scsi device's error command list,
it would perform some steps which can be done with LUN's IO blocked,
including check sense, start unit and reset lun.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@huawei.com>
Signed-off-by: JiangJianJun <jiangjianjun3@huawei.com>
---
 drivers/scsi/scsi_error.c | 37 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |  2 ++
 2 files changed, 39 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 239f8231c3ff..1f2b3deace32 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2486,6 +2486,43 @@ int scsi_error_handler(void *data)
 	return 0;
 }
 
+/*
+ * Single LUN error handle
+ *
+ * @work_q: list of scsi commands need to recovery
+ * @done_q: list of scsi commands handled
+ *
+ * return: return 1 if all commands in work_q is recoveryed, else 0 is returned
+ */
+int scsi_sdev_eh(struct scsi_device *sdev,
+		 struct list_head *work_q,
+		 struct list_head *done_q)
+{
+	int ret = 0;
+	struct scsi_cmnd *scmd;
+
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh: checking sense\n", current->comm));
+	ret = scsi_eh_get_sense(work_q, done_q);
+	if (ret)
+		return ret;
+
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh: start unit\n", current->comm));
+	scmd = list_first_entry(work_q, struct scsi_cmnd, eh_entry);
+	ret = scsi_eh_sdev_stu(scmd, work_q, done_q);
+	if (ret)
+		return ret;
+
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh: reset LUN\n", current->comm));
+	scmd = list_first_entry(work_q, struct scsi_cmnd, eh_entry);
+	ret = scsi_eh_sdev_reset(scmd, work_q, done_q);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_sdev_eh);
+
 /**
  * scsi_report_bus_reset() - report bus reset observed
  *
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 1ae08e81339f..5ce791063baf 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -18,6 +18,8 @@ extern int scsi_block_when_processing_errors(struct scsi_device *);
 extern bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 					 struct scsi_sense_hdr *sshdr);
 extern enum scsi_disposition scsi_check_sense(struct scsi_cmnd *);
+extern int scsi_sdev_eh(struct scsi_device *sdev, struct list_head *workq,
+			struct list_head *doneq);
 
 static inline bool scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
 {
-- 
2.33.0

