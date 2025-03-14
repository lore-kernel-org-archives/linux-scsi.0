Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2926146D57;
	Fri, 14 Mar 2025 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914623; cv=none; b=Q74ww2pupi4P8BLyACZkdC0RaG67fd14IPhHw/h1hLWPt8aETdWphtH29FR8Pt05Hj5cagKxhZrXDSQ3IjHIorCCII8Kv0b5vONKxh+WyyZOMeEOKrqB7JpYipJuDVCeUnApCcp7c9K4eDSULzqlK9lirx1SYu+9d6ycv/9bVWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914623; c=relaxed/simple;
	bh=NrbH2jA5dfQRKEuR+ftka6mcnaeS1IrqYubeKYKyXHE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L0hu8UZO+4xy93w4iW+2XTyuWs7/3gUcUNJbxQyKg0s04vYRgh+vSmMlLCvNAQDcWECol8VCwI/FgesLuK7q2Ad0yb3IGhGpmcooMdaa7C2tJA+NfhX1XuzT8OgdV9vEg0QR58U0Nl4Z8BDhVMDpND0W7rHIzJAdHKt3qIvKPJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZDR9q3gQnzyS0S;
	Fri, 14 Mar 2025 09:10:07 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 3AFF4140414;
	Fri, 14 Mar 2025 09:10:14 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:13 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 04/19] scsi: scsi_error: Add helper scsi_eh_sdev_stu to do START_UNIT
Date: Fri, 14 Mar 2025 09:29:12 +0800
Message-ID: <20250314012927.150860-5-jiangjianjun3@huawei.com>
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

Add helper function scsi_eh_sdev_stu() to perform START_UNIT and check
if to finish some error commands.

This is preparation for a genernal LUN/target based error handle
strategy and did not change original logic.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c | 50 +++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cc3a5adb9daa..3b55642fb585 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1567,6 +1567,31 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 	return 1;
 }
 
+static int scsi_eh_sdev_stu(struct scsi_cmnd *scmd,
+			      struct list_head *work_q,
+			      struct list_head *done_q)
+{
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_cmnd *next;
+
+	SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, sdev,
+				"%s: Sending START_UNIT\n", current->comm));
+
+	if (scsi_eh_try_stu(scmd)) {
+		SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, sdev,
+				    "%s: START_UNIT failed\n", current->comm));
+		return 0;
+	}
+
+	if (!scsi_device_online(sdev) || !scsi_eh_tur(scmd))
+		list_for_each_entry_safe(scmd, next, work_q, eh_entry)
+			if (scmd->device == sdev &&
+			    scsi_eh_action(scmd, SUCCESS) == SUCCESS)
+				scsi_eh_finish_cmd(scmd, done_q);
+
+	return list_empty(work_q);
+}
+
  /**
  * scsi_eh_stu - send START_UNIT if needed
  * @shost:	&scsi host being recovered.
@@ -1581,7 +1606,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			      struct list_head *work_q,
 			      struct list_head *done_q)
 {
-	struct scsi_cmnd *scmd, *stu_scmd, *next;
+	struct scsi_cmnd *scmd, *stu_scmd;
 	struct scsi_device *sdev;
 
 	shost_for_each_device(sdev, shost) {
@@ -1604,26 +1629,9 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 		if (!stu_scmd)
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(3,
-			sdev_printk(KERN_INFO, sdev,
-				     "%s: Sending START_UNIT\n",
-				    current->comm));
-
-		if (!scsi_eh_try_stu(stu_scmd)) {
-			if (!scsi_device_online(sdev) ||
-			    !scsi_eh_tur(stu_scmd)) {
-				list_for_each_entry_safe(scmd, next,
-							  work_q, eh_entry) {
-					if (scmd->device == sdev &&
-					    scsi_eh_action(scmd, SUCCESS) == SUCCESS)
-						scsi_eh_finish_cmd(scmd, done_q);
-				}
-			}
-		} else {
-			SCSI_LOG_ERROR_RECOVERY(3,
-				sdev_printk(KERN_INFO, sdev,
-					    "%s: START_UNIT failed\n",
-					    current->comm));
+		if (scsi_eh_sdev_stu(stu_scmd, work_q, done_q)) {
+			scsi_device_put(sdev);
+			break;
 		}
 	}
 
-- 
2.33.0

