Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0516826FA6F;
	Sat, 16 Aug 2025 10:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755341593; cv=none; b=k7J9rez5ncK5Iq70Fxp/4GbiXPwPE6rc7oxvDr3/tw/b2gnh2JL64Y82uGZkjxp2S2qFfJx1DKZ4+9GmdPgQfuQiLjbEeFjhDmKLxLFWUWQa28JdiUXdQm4wE5/1rFRqPmhGcba/tye4rClaDTaGkBvA/E6K7jPQS5qXZZDp4dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755341593; c=relaxed/simple;
	bh=K/yI1lNvc7N80cU+T2iwSo88G6c8Owxd1eCKcjxLr6o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ACCpGW/uCvNKBv/O07q8DWaSd01kxss6sEQk09ipBLh0TnIBZBj+CJNmxjkvh9HLRN/Y9QReznNPGJYxs2ZRdCxegi2CK+v+JxEwFZlrR/utLV1gWQHnFMsQX4dU29KBTtkcLj3pBqicVlsFDbuDmr0KAXtigXusfCLmlLoPslg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c3wjj4ly6z2gKxN;
	Sat, 16 Aug 2025 18:50:17 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id F12F6140295;
	Sat, 16 Aug 2025 18:53:08 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:53:07 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 03/14] scsi: scsi_error: Check if to do reset in scsi_try_xxx_reset
Date: Sat, 16 Aug 2025 19:24:06 +0800
Message-ID: <20250816112417.3581253-4-jiangjianjun3@huawei.com>
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

This is preparation for a genernal LUN/target based error handle
strategy, the strategy would reuse some error handler APIs,
but some steps of these function should not be performed. For
example, we should not perform target reset if we just stop IOs
on one single LUN.

This change add checks in scsi_try_xxx_reset to make sure
the reset operations would not be performed only if the condition
is not satisfied.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@h-partners.com>
Signed-off-by: JiangJianJun <jiangjianjun3@h-partners.com>
---
 drivers/scsi/scsi_error.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6020f20c7f07..2da876a928c7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -963,7 +963,7 @@ void scsi_eh_done(struct scsi_cmnd *scmd)
  * scsi_try_host_reset - ask host adapter to reset itself
  * @scmd:	SCSI cmd to send host reset.
  */
-static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition __scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	enum scsi_disposition rtn;
@@ -989,11 +989,19 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
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
@@ -1019,6 +1027,14 @@ static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
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
@@ -1035,7 +1051,7 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
-static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition __scsi_try_target_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	enum scsi_disposition rtn;
@@ -1056,6 +1072,15 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
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
@@ -2579,17 +2604,17 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
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

