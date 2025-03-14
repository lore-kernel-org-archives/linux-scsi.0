Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EB816F0FE;
	Fri, 14 Mar 2025 01:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914627; cv=none; b=qTDZK5lOQFrdTnGXi5Xv8/b53+DKuV254C+C+LbqkKA3iV+GY9WT0qK4hwrmCLwyXpZ3m8SoxBPf5oqRvV3coFRnk6T5X028+53NxNF5KNNtRvp25wXSRWb+Dm2kk80fPwjG6mhNSNKBDJ/ONwY18rkDM2Mv77iDZ2CEYpNY9XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914627; c=relaxed/simple;
	bh=GyJuYWKI/YW8xAyJzIpy80EXHqTTzIovG+xm9SLaNbQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdg+EaSMJ9QRUFIYTUiNid1gccA2wxIZdbH3Wv7J0LUi3sd4ZKuV7bEO7l8mBe1QgPkwJYd4nsz4w6W/RsSZvYI1Ark1nKyJsPL8HQcVW0w7dG5qUL+K+5pjGGfmaURACZBjVV+k3TWSL4i3TdalCF3Uc/fsyF871kgu2ZEMXa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZDR6K4jklzph0L;
	Fri, 14 Mar 2025 09:07:05 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 324DA1A016C;
	Fri, 14 Mar 2025 09:10:17 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:16 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 10/19] scsi: scsi_error: Add helper to handle scsi target's error command list
Date: Fri, 14 Mar 2025 09:29:18 +0800
Message-ID: <20250314012927.150860-11-jiangjianjun3@huawei.com>
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

Add helper scsi_starget_eh() to handle scsi target's error command list,
it would perform some steps which can be done with target's IO blocked,
including check sense, start unit, reset lun and reset target.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c | 129 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |   2 +
 2 files changed, 131 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7302536ba62a..46415db951ed 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2553,6 +2553,135 @@ int scsi_sdev_eh(struct scsi_device *sdev,
 }
 EXPORT_SYMBOL_GPL(scsi_sdev_eh);
 
+static int starget_eh_stu(struct scsi_target *starget,
+			  struct list_head *work_q,
+			  struct list_head *done_q)
+{
+	struct scsi_device *sdev;
+	struct scsi_cmnd *scmd, *stu_scmd;
+
+	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
+		if (sdev_stu_done(sdev))
+			continue;
+
+		stu_scmd = NULL;
+		list_for_each_entry(scmd, work_q, eh_entry)
+			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
+			    scsi_check_sense(scmd) == FAILED) {
+				stu_scmd = scmd;
+				break;
+			}
+		if (!stu_scmd)
+			continue;
+
+		if (scsi_eh_sdev_stu(stu_scmd, work_q, done_q))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int starget_eh_reset_lun(struct scsi_target *starget,
+				struct list_head *work_q,
+				struct list_head *done_q)
+{
+	struct scsi_device *sdev;
+	struct scsi_cmnd *scmd, *bdr_scmd;
+
+	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
+		if (sdev_reset_done(sdev))
+			continue;
+
+		bdr_scmd = NULL;
+		list_for_each_entry(scmd, work_q, eh_entry)
+			if (scmd->device) {
+				bdr_scmd = scmd;
+				break;
+			}
+		if (!bdr_scmd)
+			continue;
+
+		if (scsi_eh_sdev_reset(bdr_scmd, work_q, done_q))
+			return 1;
+	}
+
+	return 0;
+}
+
+static int starget_eh_reset_target(struct scsi_target *starget,
+				    struct list_head *work_q,
+				    struct list_head *done_q)
+{
+	enum scsi_disposition rtn;
+	struct scsi_cmnd *scmd, *next;
+	LIST_HEAD(check_list);
+
+	scmd = list_first_entry(work_q, struct scsi_cmnd, eh_entry);
+
+	SCSI_LOG_ERROR_RECOVERY(3, starget_printk(KERN_INFO, starget,
+			     "%s: Sending target reset\n", current->comm));
+
+	rtn = scsi_try_target_reset(scmd);
+	if (rtn != SUCCESS && rtn != FAST_IO_FAIL) {
+		SCSI_LOG_ERROR_RECOVERY(3, starget_printk(KERN_INFO, starget,
+				     "%s: Target reset failed\n",
+				     current->comm));
+		return 0;
+	}
+
+	SCSI_LOG_ERROR_RECOVERY(3, starget_printk(KERN_INFO, starget,
+			     "%s: Target reset success\n", current->comm));
+
+	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
+		if (rtn == SUCCESS)
+			list_move_tail(&scmd->eh_entry, &check_list);
+		else if (rtn == FAST_IO_FAIL)
+			scsi_eh_finish_cmd(scmd, done_q);
+	}
+
+	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
+}
+
+/*
+ * Target based error handle
+ *
+ * @work_q: list of scsi commands need to recovery
+ * @done_q: list of scsi commands handled
+ *
+ * return: return 1 if all commands in work_q is recoveryed, else 0 is returned
+ */
+int scsi_starget_eh(struct scsi_target *starget,
+		    struct list_head *work_q,
+		    struct list_head *done_q)
+{
+	int ret = 0;
+
+	SCSI_LOG_ERROR_RECOVERY(2, starget_printk(KERN_INFO, starget,
+		"%s:targeteh: checking sense\n", current->comm));
+	ret = scsi_eh_get_sense(work_q, done_q);
+	if (ret)
+		return ret;
+
+	SCSI_LOG_ERROR_RECOVERY(2, starget_printk(KERN_INFO, starget,
+		"%s:targeteh: start unit\n", current->comm));
+	ret = starget_eh_stu(starget, work_q, done_q);
+	if (ret)
+		return ret;
+
+	SCSI_LOG_ERROR_RECOVERY(2, starget_printk(KERN_INFO, starget,
+		"%s:targeteh reset LUN\n", current->comm));
+	ret = starget_eh_reset_lun(starget, work_q, done_q);
+	if (ret)
+		return ret;
+
+	SCSI_LOG_ERROR_RECOVERY(2, starget_printk(KERN_INFO, starget,
+		"%s:targeteh reset target\n", current->comm));
+	ret = starget_eh_reset_target(starget, work_q, done_q);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_starget_eh);
+
 /**
  * scsi_report_bus_reset() - report bus reset observed
  *
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 89b471aa484f..80e2f130e884 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -20,6 +20,8 @@ extern bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 extern enum scsi_disposition scsi_check_sense(struct scsi_cmnd *);
 extern int scsi_sdev_eh(struct scsi_device *sdev, struct list_head *workq,
 			struct list_head *doneq);
+extern int scsi_starget_eh(struct scsi_target *starget,
+			struct list_head *workq, struct list_head *doneq);
 extern int scsi_device_setup_eh(struct scsi_device *sdev, int fallback);
 extern void scsi_device_clear_eh(struct scsi_device *sdev);
 
-- 
2.33.0

