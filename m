Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB4B238C0D;
	Sun, 14 Sep 2025 10:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757844687; cv=none; b=CCX1JyHopM1m57GabsIBE6LLjwZzTAL+R/XFYlocBc2JCcuZt8HMM72laBoZi9OzgrQ/VpMLKsPaMCeuNg14Eo8STIoi0916a4IHxH7HBGtOF/M170ylyFC7LSKzRBmQT3Qn2uyySeEHpY+eY86C4Ophgvwh7AhJ2WPzpg+4FCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757844687; c=relaxed/simple;
	bh=Z4FKAKyAGyU1IB9jcpQbKJ1PUYxMFhEnjWUtXfsR3L0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGnfoqDN0qfg26JjzPHql5cqaMLR2Q7/Qx2mDQfevHmzMZqbR1cz7vqWCLBMybxyLMCrqZERoX47YaAKsIdSsxnpEX+nDyj1/T1iYTwY7YVpEWvJ0mYd8X11hSiX7ogRUCA4C55N4qu6ozW1FLwF2bMRiit+0LcZJQWitOaBioE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cPkVf6tNxz27j0x;
	Sun, 14 Sep 2025 18:12:26 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 2A4781A0188;
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
Subject: [RFC PATCH v4 2/9] scsi: scsi_error: Move complete variable eh_action from shost to sdevice
Date: Sun, 14 Sep 2025 18:41:38 +0800
Message-ID: <20250914104145.2239901-3-jiangjianjun3@huawei.com>
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

eh_action is used to wait for error handle command's completion if scsi
command is send in error handle. Now the error handler might based on
scsi_device, so move it to scsi_device.

This is preparation for a genernal LUN based error handle strategy.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@huawei.com>
Signed-off-by: JiangJianJun <jiangjianjun3@huawei.com>
---
 drivers/scsi/scsi_error.c  | 6 +++---
 include/scsi/scsi_device.h | 2 ++
 include/scsi/scsi_host.h   | 2 --
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b5b04f2c5d62..d8b3f5b0fd47 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -917,7 +917,7 @@ void scsi_eh_done(struct scsi_cmnd *scmd)
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
 			"%s result: %x\n", __func__, scmd->result));
 
-	eh_action = scmd->device->host->eh_action;
+	eh_action = scmd->device->eh_action;
 	if (eh_action)
 		complete(eh_action);
 }
@@ -1206,7 +1206,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 
 retry:
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
-	shost->eh_action = &done;
+	sdev->eh_action = &done;
 
 	scsi_log_send(scmd);
 	scmd->submitter = SUBMITTED_BY_SCSI_ERROR_HANDLER;
@@ -1250,7 +1250,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 		rtn = SUCCESS;
 	}
 
-	shost->eh_action = NULL;
+	sdev->eh_action = NULL;
 
 	scsi_log_completion(scmd, rtn);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c21b0a84bbd2..9d42858035ed 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -318,6 +318,8 @@ struct scsi_device {
 	enum scsi_device_state sdev_state;
 	struct task_struct	*quiesced_by;
 	struct scsi_device_eh	*eh;
+	struct completion	*eh_action;	/* Wait for specific actions */
+						/* on the device. */
 	unsigned long		sdev_data[];
 } __attribute__((aligned(sizeof(unsigned long))));
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index c53812b9026f..46f57fe78505 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -558,8 +558,6 @@ struct Scsi_Host {
 	struct list_head	eh_abort_list;
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
-	struct completion     * eh_action; /* Wait for specific actions on the
-					      host. */
 	wait_queue_head_t       host_wait;
 	const struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
-- 
2.33.0

