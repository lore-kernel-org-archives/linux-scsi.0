Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2799929A9E1;
	Sat, 16 Aug 2025 10:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755341595; cv=none; b=pqrEQBxG4fx5EeH3obPi6l3VAa5aOMNCQ7hL9+/AyVMe15JyyIROMVTBsIFoPPcUUReSEzX+kOqoLtE1Dpo+A/Q1SvRNgD0Sinn75mnSmzosiWTt9qPBla+A35C9suXpaSOpc9mo3jq9+vhDpcaG+RWAO4CQNVZTY9cqRTcjDvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755341595; c=relaxed/simple;
	bh=TKofgrDP115WrtIqX39g/FOcMKIypFZ8qKFs/HvZR2Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U0YTJlZH6+8YYIavKq9Yb341p8shA/OCikr0s8kLlCCqarZ/TChk3Vtr8uyRWBBvGpEE6qhUYLXegojfaHtNmHM71fRbDDnqf8g6Qb3EdrQSKkbkF/iHut8MXmRv4Dqm48MZFJbNAQ8LPNm/I6GGOXKsUXmvrzjcbu6MhhOtMG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c3wh12Vx6zPtHS;
	Sat, 16 Aug 2025 18:48:49 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A1A3180087;
	Sat, 16 Aug 2025 18:53:10 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:53:09 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 05/14] scsi: scsi_error: Add helper scsi_eh_sdev_reset to do lun reset
Date: Sat, 16 Aug 2025 19:24:08 +0800
Message-ID: <20250816112417.3581253-6-jiangjianjun3@huawei.com>
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

Add helper function scsi_eh_sdev_reset() to perform lun reset and check
if to finish some error commands.

This is preparation for a genernal LUN/target based error handle
strategy and did not change original logic.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@h-partners.com>
Signed-off-by: JiangJianJun <jiangjianjun3@h-partners.com>
---
 drivers/scsi/scsi_error.c | 54 +++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 24c695a36a76..02f6ef6393ed 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1676,6 +1676,34 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 	return list_empty(work_q);
 }
 
+static int scsi_eh_sdev_reset(struct scsi_cmnd *scmd,
+			      struct list_head *work_q,
+			      struct list_head *done_q)
+{
+	struct scsi_cmnd *next;
+	struct scsi_device *sdev = scmd->device;
+	enum scsi_disposition rtn;
+
+	SCSI_LOG_ERROR_RECOVERY(3, sdev_printk(KERN_INFO, sdev,
+			     "%s: Sending BDR\n", current->comm));
+
+	rtn = scsi_try_bus_device_reset(scmd);
+	if (rtn != SUCCESS && rtn != FAST_IO_FAIL) {
+		SCSI_LOG_ERROR_RECOVERY(3,
+			sdev_printk(KERN_INFO, sdev,
+				    "%s: BDR failed\n", current->comm));
+		return 0;
+	}
+
+	if (!scsi_device_online(sdev) || rtn == FAST_IO_FAIL ||
+	    !scsi_eh_tur(scmd))
+		list_for_each_entry_safe(scmd, next, work_q, eh_entry)
+			if (scmd->device == sdev &&
+			    scsi_eh_action(scmd, rtn) != FAILED)
+				scsi_eh_finish_cmd(scmd, done_q);
+
+	return list_empty(work_q);
+}
 
 /**
  * scsi_eh_bus_device_reset - send bdr if needed
@@ -1693,9 +1721,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				    struct list_head *work_q,
 				    struct list_head *done_q)
 {
-	struct scsi_cmnd *scmd, *bdr_scmd, *next;
+	struct scsi_cmnd *scmd, *bdr_scmd;
 	struct scsi_device *sdev;
-	enum scsi_disposition rtn;
 
 	shost_for_each_device(sdev, shost) {
 		if (scsi_host_eh_past_deadline(shost)) {
@@ -1716,26 +1743,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 		if (!bdr_scmd)
 			continue;
 
-		SCSI_LOG_ERROR_RECOVERY(3,
-			sdev_printk(KERN_INFO, sdev,
-				     "%s: Sending BDR\n", current->comm));
-		rtn = scsi_try_bus_device_reset(bdr_scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
-			if (!scsi_device_online(sdev) ||
-			    rtn == FAST_IO_FAIL ||
-			    !scsi_eh_tur(bdr_scmd)) {
-				list_for_each_entry_safe(scmd, next,
-							 work_q, eh_entry) {
-					if (scmd->device == sdev &&
-					    scsi_eh_action(scmd, rtn) != FAILED)
-						scsi_eh_finish_cmd(scmd,
-								   done_q);
-				}
-			}
-		} else {
-			SCSI_LOG_ERROR_RECOVERY(3,
-				sdev_printk(KERN_INFO, sdev,
-					    "%s: BDR failed\n", current->comm));
+		if (scsi_eh_sdev_reset(bdr_scmd, work_q, done_q)) {
+			scsi_device_put(sdev);
+			break;
 		}
 	}
 
-- 
2.33.0

