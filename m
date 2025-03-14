Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28DF12E5D;
	Fri, 14 Mar 2025 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914624; cv=none; b=RouuFew+a7ivx3tmQDo4ZHraxe098sBhd+gsJBR8CA94GCvWsZsGo1vTAW1MQ0BUHPPs8u9FhfQa7wO4uhF0H8ZCXO3mNilJhJFduN5kJnLq6S10695cX4iQ4RSqverNjikZwzI+TWcxa9ofnf0p2x9wyODVhS6aa5vDBt7EYfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914624; c=relaxed/simple;
	bh=Q/dwwbC1eHY4Zi6jqCUK1bren11pNwo6AThHBStMBu0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hb5anrg/LTqatU3OKaOgcAW5AhhOuyZFp1ET9FfxI8LHMvhSZbQwK89YU4j5/DiiYAeALP2Ft1fkbzfWpoMSiHC/aGR639nHr62OL4mYoFtZt1dlAM/IaVYTrEOlluRBrqcRuaVTbAK67nIQp0xPhhn3peWgGiVxBotSF0WUNVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZDR5V2wtFzvWqS;
	Fri, 14 Mar 2025 09:06:22 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id B559A18006C;
	Fri, 14 Mar 2025 09:10:13 +0800 (CST)
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
Subject: [RFC PATCH v3 03/19] scsi: scsi_error: Check if to do reset in scsi_try_xxx_reset
Date: Fri, 14 Mar 2025 09:29:11 +0800
Message-ID: <20250314012927.150860-4-jiangjianjun3@huawei.com>
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

This is preparation for a genernal LUN/target based error handle
strategy, the strategy would reuse some error handler APIs,
but some steps of these function should not be performed. For
example, we should not perform target reset if we just stop IOs
on one single LUN.

This change add checks in scsi_try_xxx_reset to make sure
the reset operations would not be performed only if the condition
is not satisfied.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 4f37af9e20b6..cc3a5adb9daa 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -925,7 +925,7 @@ void scsi_eh_done(struct scsi_cmnd *scmd)
  * scsi_try_host_reset - ask host adapter to reset itself
  * @scmd:	SCSI cmd to send host reset.
  */
-static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition __scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	enum scsi_disposition rtn;
@@ -951,11 +951,19 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
 	return rtn;
 }
 
+static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
+{
+	if (!scsi_host_in_recovery(scmd->device->host))
+		return FAILED;
+
+	return __scsi_try_host_reset(scmd);
+}
+
 /**
  * scsi_try_bus_reset - ask host to perform a bus reset
  * @scmd:	SCSI cmd to send bus reset.
  */
-static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition __scsi_try_bus_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	enum scsi_disposition rtn;
@@ -981,6 +989,14 @@ static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	return rtn;
 }
 
+static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
+{
+	if (!scsi_host_in_recovery(scmd->device->host))
+		return FAILED;
+
+	return __scsi_try_bus_reset(scmd);
+}
+
 static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
 {
 	sdev->was_reset = 1;
@@ -997,7 +1013,7 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
-static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition __scsi_try_target_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	enum scsi_disposition rtn;
@@ -1018,6 +1034,15 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 	return rtn;
 }
 
+static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
+{
+	if (!(scsi_target_in_recovery(scsi_target(scmd->device)) ||
+	      scsi_host_in_recovery(scmd->device->host)))
+		return FAILED;
+
+	return __scsi_try_target_reset(scmd);
+}
+
 /**
  * scsi_try_bus_device_reset - Ask host to perform a BDR on a dev
  * @scmd:	SCSI cmd used to send BDR
@@ -2541,17 +2566,17 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 			break;
 		fallthrough;
 	case SG_SCSI_RESET_TARGET:
-		rtn = scsi_try_target_reset(scmd);
+		rtn = __scsi_try_target_reset(scmd);
 		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		fallthrough;
 	case SG_SCSI_RESET_BUS:
-		rtn = scsi_try_bus_reset(scmd);
+		rtn = __scsi_try_bus_reset(scmd);
 		if (rtn == SUCCESS || (val & SG_SCSI_RESET_NO_ESCALATE))
 			break;
 		fallthrough;
 	case SG_SCSI_RESET_HOST:
-		rtn = scsi_try_host_reset(scmd);
+		rtn = __scsi_try_host_reset(scmd);
 		if (rtn == SUCCESS)
 			break;
 		fallthrough;
-- 
2.33.0

