Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F6226CE2F;
	Sat, 16 Aug 2025 10:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755341594; cv=none; b=K9NCXmXUsREEDyKkD6AmXdAnMdWQG/SjMWvQumjjjgh7o8EMB4UH9dYWdVWQ2kGv7OABjs0BsCbi8fyliVHHpSnsvjklsywkQAM+NBbyI1t/Xo4EEfU1yuMXaSH/C02Gw+s7fS9eDTxmjNv6HWdBZlABpXtnmyRogyi54cAkFMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755341594; c=relaxed/simple;
	bh=2CvrmPGixM7+DZb2SWRSYs9qJScsP9WPi5xYCGgEu2Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=npe+uRiNq4ScLs/0v2R33VQ9FFJmzKEhfuLl8TxI7GUcr9mX0/mciVZHgUkvI3e43Rtn6+8Hb2JPZ/bDhu0cYEWXIWjYfJ8o4njLcftNU/WWKfR/zhN7+QSElPY1gfcrFG5ltzIPbIuc8CbDWlE7FE6NsPTIkEtpM2Ry74/Cd7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c3wh05l9qz2Cg4H;
	Sat, 16 Aug 2025 18:48:48 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id C1779140259;
	Sat, 16 Aug 2025 18:53:09 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:53:08 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 04/14] scsi: scsi_error: Add helper scsi_eh_sdev_stu to do START_UNIT
Date: Sat, 16 Aug 2025 19:24:07 +0800
Message-ID: <20250816112417.3581253-5-jiangjianjun3@huawei.com>
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

Add helper function scsi_eh_sdev_stu() to perform START_UNIT and check
if to finish some error commands.

This is preparation for a genernal LUN/target based error handle
strategy and did not change original logic.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@h-partners.com>
Signed-off-by: JiangJianJun <jiangjianjun3@h-partners.com>
---
 drivers/scsi/scsi_error.c | 50 +++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2da876a928c7..24c695a36a76 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1605,6 +1605,31 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
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
@@ -1619,7 +1644,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			      struct list_head *work_q,
 			      struct list_head *done_q)
 {
-	struct scsi_cmnd *scmd, *stu_scmd, *next;
+	struct scsi_cmnd *scmd, *stu_scmd;
 	struct scsi_device *sdev;
 
 	shost_for_each_device(sdev, shost) {
@@ -1642,26 +1667,9 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
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

