Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3872C41513
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 10:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjGWKYH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 06:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjGWKX1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 06:23:27 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11BC2D6D;
        Sun, 23 Jul 2023 03:23:07 -0700 (PDT)
Received: from kwepemm600012.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R7zmq5ZqZzNmLw;
        Sun, 23 Jul 2023 18:19:39 +0800 (CST)
Received: from build.huawei.com (10.175.101.6) by
 kwepemm600012.china.huawei.com (7.193.23.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 23 Jul 2023 18:23:00 +0800
From:   Wenchao Hao <haowenchao2@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Dan Carpenter <error27@gmail.com>, <louhongxiang@huawei.com>,
        Wenchao Hao <haowenchao2@huawei.com>
Subject: [PATCH 10/13] scsi:scsi_error: Define helper to perform target based error handle
Date:   Mon, 24 Jul 2023 07:44:19 +0800
Message-ID: <20230723234422.1629194-11-haowenchao2@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230723234422.1629194-1-haowenchao2@huawei.com>
References: <20230723234422.1629194-1-haowenchao2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600012.china.huawei.com (7.193.23.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is an simple target based error handle strategy, it try
target based recovery first, including check sense, start unit,
reset lun and reset target.

This is an simple error handle strategy which can be used by drivers
or other target based error handlers.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c | 129 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |   2 +
 2 files changed, 131 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index bb6f05ba199b..6ebf62f9817a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2531,6 +2531,135 @@ int scsi_sdev_eh(struct scsi_device *sdev,
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
 /*
  * Function:    scsi_report_bus_reset()
  *
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 030b22a8c164..f8f3a143d848 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -20,6 +20,8 @@ extern bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 extern enum scsi_disposition scsi_check_sense(struct scsi_cmnd *);
 extern int scsi_sdev_eh(struct scsi_device *, struct list_head *,
 			struct list_head *);
+extern int scsi_starget_eh(struct scsi_target *, struct list_head *,
+			struct list_head *);
 
 static inline bool scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
 {
-- 
2.35.3

