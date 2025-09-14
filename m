Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C1A234973;
	Sun, 14 Sep 2025 10:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757844689; cv=none; b=Q8v2AKBopM+HtUqr7ZNaXjdIbVBBDGNkojOaQD9IWbb2Z1B1PAb2JrrhYq//hPC2WfDSCyBePMaeYjKKOWil5gD9o9LqrR9c6FtcTMqUAk39fWUwOADhOrv4U/zhj5FEBXkULFzVDt6heqC2OGZ0H2vO2T6pzPqHebvGOWYJSzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757844689; c=relaxed/simple;
	bh=Lnr6tGUtlbXLP+Z/ARbSnGTNMadVel0cOI/IQcIzfJU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ldNti6EDLcHv37ddaFKZ1Buij0kWklXY0o2dWQimfq35ZZTlA+yyBo029Y3xVN7NOh6BfQjnXDuWbM4B9pnjoYSzfUtyuqwNcIhJmf9vQBN2u5mFX50E4gX87n1EDGUCsntPhLRthEjYy2vZJcbBdXQW4sqaBk0WzM9+xrWWN+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cPkSJ4jpTztTSW;
	Sun, 14 Sep 2025 18:10:24 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 1D954140275;
	Sun, 14 Sep 2025 18:11:19 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 14 Sep 2025 18:11:18 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <dlemoal@kernel.org>,
	<hewenliang4@huawei.com>, <yangyun50@huawei.com>, <wuyifeng10@huawei.com>,
	<yangxingui@h-partners.com>
Subject: [RFC PATCH v4 5/9] scsi: scsi_error: Add helper scsi_eh_sdev_reset to do lun reset
Date: Sun, 14 Sep 2025 18:41:41 +0800
Message-ID: <20250914104145.2239901-6-jiangjianjun3@huawei.com>
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

Add helper function scsi_eh_sdev_reset() to perform lun reset and check
if to finish some error commands.

This is preparation for a genernal LUN based error handle
strategy and did not change original logic.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@huawei.com>
Signed-off-by: JiangJianJun <jiangjianjun3@huawei.com>
---
 drivers/scsi/scsi_error.c | 54 +++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a1b700dbb0ec..f58aad351463 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1630,6 +1630,34 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
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
@@ -1647,9 +1675,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				    struct list_head *work_q,
 				    struct list_head *done_q)
 {
-	struct scsi_cmnd *scmd, *bdr_scmd, *next;
+	struct scsi_cmnd *scmd, *bdr_scmd;
 	struct scsi_device *sdev;
-	enum scsi_disposition rtn;
 
 	shost_for_each_device(sdev, shost) {
 		if (scsi_host_eh_past_deadline(shost)) {
@@ -1670,26 +1697,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
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

