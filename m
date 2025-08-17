Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158231ACEDE;
	Sun, 17 Aug 2025 02:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755396908; cv=none; b=cORC6Mz2vbpKfxplfwAD/0hDh2NEQGqygrcHQmxJa6wYoC5IPcMcAsoOHuevNpuFSSaXu/ti+FcparkB70euLCrumyZc9L9OE34/uAmZwMeoMP/m2qHgQyLr0AdpXMSw1QWSApYO1PE1BjujfsQO7qLbESuheIp9WvuQKJpPmNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755396908; c=relaxed/simple;
	bh=PGXShczDSkWOB4nogHA5yNjnkFqteT/S6yPRKeISUi0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jKo4JK8Lh5vlpzhBAIGz4234dcHrT1g4sCRgT8+icHur+Rkowon35GXbTE6GhnKkWfp29rLmFSkJVYzzP9RCFpCpm27alup3S6zjLTyKjOV9I90m/dV825EeRLsjbApLUsAKrzUUVN49BNv8E+Bxed9UP3Wfexpbo2lDX8l5+L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c4K7Z68YpzPtNP;
	Sun, 17 Aug 2025 10:10:34 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D03818006C;
	Sun, 17 Aug 2025 10:14:56 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 17 Aug 2025 10:14:55 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 10/14] scsi: scsi_error: Add helper to handle scsi target's error command list
Date: Sun, 17 Aug 2025 10:46:06 +0800
Message-ID: <20250817024606.841343-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <202508170715.5Q0ZpgmO-lkp@intel.com>
References: <202508170715.5Q0ZpgmO-lkp@intel.com>
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

Add helper scsi_starget_eh() to handle scsi target's error command list,
it would perform some steps which can be done with target's IO blocked,
including check sense, start unit, reset lun and reset target.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@h-partners.com>
Signed-off-by: JiangJianJun <jiangjianjun3@h-partners.com>
---
 drivers/scsi/scsi_error.c | 130 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |   2 +
 2 files changed, 132 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 49344f30bab9..15be739135b7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2591,6 +2591,136 @@ int scsi_sdev_eh(struct scsi_device *sdev,
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
+			    "%s: Target reset success: rtn=%#x\n",
+				current->comm, rtn));
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
+		"%s:targeteh: reset LUN\n", current->comm));
+	ret = starget_eh_reset_lun(starget, work_q, done_q);
+	if (ret)
+		return ret;
+
+	SCSI_LOG_ERROR_RECOVERY(2, starget_printk(KERN_INFO, starget,
+		"%s:targeteh: reset target\n", current->comm));
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
index d8e4475ff004..cda0b962fc47 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -20,6 +20,8 @@ extern bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 extern enum scsi_disposition scsi_check_sense(struct scsi_cmnd *);
 extern int scsi_sdev_eh(struct scsi_device *sdev, struct list_head *workq,
 			struct list_head *doneq);
+extern int scsi_starget_eh(struct scsi_target *starget,
+			struct list_head *workq, struct list_head *doneq);
 extern int scsi_device_setup_eh(struct scsi_device *sdev);
 extern void scsi_device_clear_eh(struct scsi_device *sdev);
 
-- 
2.33.0

