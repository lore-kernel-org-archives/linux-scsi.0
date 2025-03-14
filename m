Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBAE1BC3C;
	Fri, 14 Mar 2025 01:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914618; cv=none; b=IOhX7uePlPJkThzYGlN/VjPz7HB7BupmvuX+lG99owSk4sW76Esty56+y8AKB1/snIY4EATDGBVtTyrXKKn3m/0sqmVcNkeYUJxBeDe/ce0VuwvtMoq2+8GSdmDoNw6yBnifjjP0REmz5W0pibbjO/wvYO+T5pxM9Kx9r7WlhU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914618; c=relaxed/simple;
	bh=FA/bM8YrOrG7YN0tT8yx9kjvDbFL54SCRb8IgSF5WC4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qzWOt5+bNZkVa5txm7q0c31TxeqVA5ANvXgXCJwIxjR6GaCO0JRATkija0LUV/BBJvpPu4BB9BicONNnsOaxNKwgfo+x6tlbiIgm0cqZLjce8d1hTgahaE19/a3h0wx0Fx1HAnnuj5lDgzpYSSYUtilQCjwO2l+GWujLnWftE60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZDR4s5dNfz1ltZt;
	Fri, 14 Mar 2025 09:05:49 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 3D99A180069;
	Fri, 14 Mar 2025 09:10:13 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:12 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 02/19] scsi: scsi_error: Move complete variable eh_action from shost to sdevice
Date: Fri, 14 Mar 2025 09:29:10 +0800
Message-ID: <20250314012927.150860-3-jiangjianjun3@huawei.com>
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

eh_action is used to wait for error handle command's completion if scsi
command is send in error handle. Now the error handler might based on
scsi_device, so move it to scsi_device.

This is preparation for a genernal LUN/target based error handle
strategy.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c  | 6 +++---
 include/scsi/scsi_device.h | 2 ++
 include/scsi/scsi_host.h   | 2 --
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f89de23a6807..4f37af9e20b6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -916,7 +916,7 @@ void scsi_eh_done(struct scsi_cmnd *scmd)
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
 			"%s result: %x\n", __func__, scmd->result));
 
-	eh_action = scmd->device->host->eh_action;
+	eh_action = scmd->device->eh_action;
 	if (eh_action)
 		complete(eh_action);
 }
@@ -1205,7 +1205,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 
 retry:
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
-	shost->eh_action = &done;
+	sdev->eh_action = &done;
 
 	scsi_log_send(scmd);
 	scmd->submitter = SUBMITTED_BY_SCSI_ERROR_HANDLER;
@@ -1249,7 +1249,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 		rtn = SUCCESS;
 	}
 
-	shost->eh_action = NULL;
+	sdev->eh_action = NULL;
 
 	scsi_log_completion(scmd, rtn);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5911c82ca435..6388abb6c0d4 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -347,6 +347,8 @@ struct scsi_device {
 	enum scsi_device_state sdev_state;
 	struct task_struct	*quiesced_by;
 	struct scsi_device_eh	*eh;
+	struct completion	*eh_action;	/* Wait for specific actions */
+						/* on the device. */
 	unsigned long		sdev_data[];
 } __attribute__((aligned(sizeof(unsigned long))));
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 26bc23419cfd..de014c60746c 100644
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

