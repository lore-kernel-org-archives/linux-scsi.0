Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A049C237713;
	Sun, 14 Sep 2025 10:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757844687; cv=none; b=R5WAKnmNML3BBD1B6rRI4L9bvHyDxPB/bvLFtgXlaO24bg5lhvRzaR8huy0x3xBjCJxisju3IhP0w0LagYZ33tPLKAUrJpDqCUwIurpYgcrKARaVdYapB1YXBOf7km+URJrO97JNZQlCYgopRiHpakKDo7tLR17MfeGO7NtcxlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757844687; c=relaxed/simple;
	bh=vL+au5akwb6Zlvmhtnpk9H6gQNiqpw3WdYDKasAzjRA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a5EewklItlVXji7NIekwdiD7EyOh/Dn4Pi4KWZy6XHFzQhjKJwegQ9m8DIT2ps+6JkaXvcbqAT3y5wXoOUwINKR1wBg/elJ/TmhSQ3ENIM+aZNn0aPgWVpRv1CbE5ZVPimi/VFewWDBn5/+41m4PxvQ3sdrgbj5PAtAr+7z1iZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cPkN35ch4z2CgCX;
	Sun, 14 Sep 2025 18:06:43 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id C5C4C180043;
	Sun, 14 Sep 2025 18:11:17 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 14 Sep 2025 18:11:16 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <dlemoal@kernel.org>,
	<hewenliang4@huawei.com>, <yangyun50@huawei.com>, <wuyifeng10@huawei.com>,
	<yangxingui@h-partners.com>
Subject: [RFC PATCH v4 3/9] scsi: scsi_error: Check if to do reset in scsi_try_xxx_reset
Date: Sun, 14 Sep 2025 18:41:39 +0800
Message-ID: <20250914104145.2239901-4-jiangjianjun3@huawei.com>
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

This is preparation for a genernal LUN based error handle
strategy, the strategy would reuse some error handler APIs,
but some steps of these function should not be performed. For
example, we should not perform bus/host reset if we just stop IOs
on one single LUN.

This change add checks in scsi_try_xxx_reset to make sure
the reset operations would not be performed only if the condition
is not satisfied.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@huawei.com>
Signed-off-by: JiangJianJun <jiangjianjun3@huawei.com>
---
 drivers/scsi/scsi_error.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d8b3f5b0fd47..80a85b387068 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -926,7 +926,7 @@ void scsi_eh_done(struct scsi_cmnd *scmd)
  * scsi_try_host_reset - ask host adapter to reset itself
  * @scmd:	SCSI cmd to send host reset.
  */
-static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition __scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	enum scsi_disposition rtn;
@@ -952,11 +952,19 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
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
@@ -982,6 +990,14 @@ static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
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
@@ -2547,12 +2563,12 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
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

