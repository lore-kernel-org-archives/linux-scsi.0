Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E1A29B226;
	Sat, 16 Aug 2025 10:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755341596; cv=none; b=aEHuIXuHbtmLbzFtYbO1r5UdfN2rz4ueXuTv8rEuqfhk7BFO3CI4/znkgY6WhnCEYQiGkmtYbh9pDcX26UKXNXB2S/AQQwlUnoEfXu8q7UVVF1iT/TMvm66g0PCERn3FeoK5wN5AcHIilbXsDgalewpb4M6YYDKKc3UxZyzNKuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755341596; c=relaxed/simple;
	bh=RMPQPSn+mUHzHLpI8ljyTbmSs7mJn2hwNRgFCjB/Gyk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fyiHLl4XElnkAgr8WbIC0z/6jNBnJKmQLMWhoQSNtCPxzrryZPQXl+BB1BFRAdyE1ofy9gOyzdiAAblTcSzviql9zTliD8dShhAIB2zXejH7aEqw6Go1+HkhZ+Si1uxKR4/R80F9ON7LhL4IbtkdUYJ+SVzRnScQDT0zu3RWMNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c3wn214dwzvX78;
	Sat, 16 Aug 2025 18:53:10 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 28CA21402DF;
	Sat, 16 Aug 2025 18:53:12 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:53:11 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 07/14] scsi: scsi_error: Add helper to handle scsi device's error command list
Date: Sat, 16 Aug 2025 19:24:10 +0800
Message-ID: <20250816112417.3581253-8-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
References: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk500001.china.huawei.com (7.202.194.86)

From: Wenchao Hao <haowenchao2@huawei.com>

Add helper scsi_sdev_eh() to handle scsi device's error command list,
it would perform some steps which can be done with LUN's IO blocked,
including check sense, start unit and reset lun.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@h-partners.com>
Signed-off-by: JiangJianJun <jiangjianjun3@h-partners.com>
---
 drivers/scsi/scsi_error.c | 37 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |  2 ++
 2 files changed, 39 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cd53e2744a4f..b09f721d4d93 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2554,6 +2554,43 @@ int scsi_error_handler(void *data)
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

