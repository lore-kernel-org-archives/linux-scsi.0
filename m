Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9C52D05E;
	Fri, 14 Mar 2025 01:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914620; cv=none; b=lJWgylQaxkOarZ2Lp1DZvf7kvZAr9IpRG6+prw5CbuIGvhpGsHHXe7w6l9GWBn6ReBjw7TijVphEm3wcIlbN1wLpKOOr4fdAUPQtDHA805hI2iBT4fNv524UEXaOZEx7VsFGH5lWbTG9zI9Kdfq42qO1cZiohUdT+Ig8fnASW10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914620; c=relaxed/simple;
	bh=EfssYDyJB1OHmxnmuyKOLIsm2nAgdczTKJiBdiYP48k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aKc3uq+2Ji9vUlOKOfb2UN19L+RnSC7+uLKMOZ3njEnwseXCBu3LbKK9oaH4zmmBWpgSbgVS5RGzGDfRzEVXjkoukS9l/PnYl+9eBfNEQKzVuJUdA6Rp1DB8/gyIyWlD2mxkGZB7j74fshIe6qCTYdZ799JJMOCx4Ksv1wPUl08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4ZDR9s1Nxqz1cyZ2;
	Fri, 14 Mar 2025 09:10:09 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id BEDA018006C;
	Fri, 14 Mar 2025 09:10:15 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:15 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 07/19] scsi: scsi_error: Add helper to handle scsi device's error command list
Date: Fri, 14 Mar 2025 09:29:15 +0800
Message-ID: <20250314012927.150860-8-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250314012927.150860-1-jiangjianjun3@huawei.com>
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500016.china.huawei.com (7.185.36.197)

From: Wenchao Hao <haowenchao2@huawei.com>

Add helper scsi_sdev_eh() to handle scsi device's error command list,
it would perform some steps which can be done with LUN's IO blocked,
including check sense, start unit and reset lun.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c | 37 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |  2 ++
 2 files changed, 39 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 628ecbfcfff2..21f72c075531 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2516,6 +2516,43 @@ int scsi_error_handler(void *data)
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
+		"%s:luneh reset LUN\n", current->comm));
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

