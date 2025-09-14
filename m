Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15516235063;
	Sun, 14 Sep 2025 10:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757844688; cv=none; b=eQCGNBW1In8W+67d2IGZxUpzXGVyY4Kc+G3vJgmUff7TSJl9vxN3aa18RwJfBw0vOond0IttvLyotyhdTbhUzxaVKyhqu/g+L5RiEQ8fkVVSpvorFxgDx778RxB/0PeGxPAnkLLzpotEYrAqf8v2+gJrshih1JcHSP+yAJ31S+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757844688; c=relaxed/simple;
	bh=dGMhuHtWhO6mFY5j8wH09YxCtZDEgNPiyFnCcKgMkaM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r3KRktsDl6uSyscUgJNl35Px4aqP+0ZDNzbpBX9N06hIpRKQDwRUJqE9SQsIPF4XGFY2XgPayvoAbeYBtkq896yePMF95LYoeYUVHOKIPmnOiN8+6CUIp+QZKigHNVBoDH/OvSGj+JQTdvuWFKXfhMxnk1KNUiCgvMKZVVL6IiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cPkT13HQRz14MbG;
	Sun, 14 Sep 2025 18:11:01 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 7E71418006C;
	Sun, 14 Sep 2025 18:11:16 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 14 Sep 2025 18:11:15 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <dlemoal@kernel.org>,
	<hewenliang4@huawei.com>, <yangyun50@huawei.com>, <wuyifeng10@huawei.com>,
	<yangxingui@h-partners.com>
Subject: [RFC PATCH v4 1/9] scsi: scsi_error: Define framework for LUN based error handle
Date: Sun, 14 Sep 2025 18:41:37 +0800
Message-ID: <20250914104145.2239901-2-jiangjianjun3@huawei.com>
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

The old scsi error handle logic is based on host, once a scsi command
in one LUN of this host is classfied as failed, SCSI mid-level would
set the whole host to recovery state, and no IO can be submitted to
all LUNs of this host any more before recovery finished, while the
recovery process might take a long time to finish.
It's unreasonable when there are a lot of LUNs in one host.

This change introduce a way for driver to implement its own
error handle logic which can be based on scsi LUN as minimum unit.

scsi_device_eh is defined for error handle based on scsi LUN, and
pointer struct scsi_device_eh "eh" is added in scsi_device, which
is NULL by default.
LLDs can initialize the sdev->eh in hostt->slave_alloc to implement an
scsi LUN based error handle. If this member is not NULL, SCSI mid-level
would branch to drivers' error handler rather than the old one which
block whole host's IO.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@huawei.com>
Signed-off-by: JiangJianJun <jiangjianjun3@huawei.com>
---
 drivers/scsi/scsi_error.c  | 42 +++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_lib.c    |  7 +++++++
 drivers/scsi/scsi_priv.h   |  8 ++++++++
 include/scsi/scsi_device.h | 29 ++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 746ff6a1f309..b5b04f2c5d62 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -291,11 +291,28 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
+static bool scsi_eh_scmd_add_sdev(struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_device_eh *eh = sdev->eh;
+
+	if (!eh || !eh->add_cmnd)
+		return true;
+
+	scsi_eh_reset(scmd);
+	eh->add_cmnd(scmd);
+
+	if (eh->wakeup)
+		eh->wakeup(sdev);
+
+	return false;
+}
+
 /**
- * scsi_eh_scmd_add - add scsi cmd to error handling.
- * @scmd:	scmd to run eh on.
+ * Add scsi cmd to error handling of Scsi_Host.
+ * This is default action of error handle.
  */
-void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
+static void scsi_eh_scmd_add_shost(struct scsi_cmnd *scmd)
 {
 	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
@@ -322,6 +339,25 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 	call_rcu_hurry(&scmd->rcu, scsi_eh_inc_host_failed);
 }
 
+/**
+ * scsi_eh_scmd_add - add scsi cmd to error handling.
+ * @scmd:	scmd to run eh on.
+ */
+void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
+{
+	struct Scsi_Host *shost = scmd->device->host;
+
+	if (unlikely(scsi_host_in_recovery(shost)) ||
+		scsi_eh_scmd_add_sdev(scmd))
+		scsi_eh_scmd_add_shost(scmd);
+}
+
+void scsi_eh_try_wakeup_sdev(struct scsi_device *sdev)
+{
+	if (sdev->eh && sdev->eh->wakeup)
+		sdev->eh->wakeup(sdev);
+}
+
 /**
  * scsi_timeout - Timeout function for normal scsi commands.
  * @req:	request that is timing out.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0c65ecfedfbd..ac8fb801aa82 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -398,6 +398,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 
 	sbitmap_put(&sdev->budget_map, cmd->budget_token);
 	cmd->budget_token = -1;
+
+	scsi_eh_try_wakeup_sdev(sdev);
 }
 
 /*
@@ -1360,6 +1362,9 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 {
 	int token;
 
+	if (scsi_device_in_recovery(sdev))
+		return -1;
+
 	token = sbitmap_get(&sdev->budget_map);
 	if (token < 0)
 		return -1;
@@ -1374,6 +1379,7 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 	if (scsi_device_busy(sdev) > 1 ||
 	    atomic_dec_return(&sdev->device_blocked) > 0) {
 		sbitmap_put(&sdev->budget_map, token);
+		scsi_eh_try_wakeup_sdev(sdev);
 		return -1;
 	}
 
@@ -1882,6 +1888,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 out_put_budget:
 	scsi_mq_put_budget(q, cmd->budget_token);
 	cmd->budget_token = -1;
+	scsi_eh_try_wakeup_sdev(sdev);
 	switch (ret) {
 	case BLK_STS_OK:
 		break;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 5b2b19f5e8ec..906f090d917c 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -92,6 +92,7 @@ extern int scsi_error_handler(void *host);
 extern enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy);
 extern void scsi_eh_scmd_add(struct scsi_cmnd *);
+extern void scsi_eh_try_wakeup_sdev(struct scsi_device *sdev);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
 			struct list_head *done_q);
@@ -191,6 +192,13 @@ static inline void scsi_dh_add_device(struct scsi_device *sdev) { }
 static inline void scsi_dh_release_device(struct scsi_device *sdev) { }
 #endif
 
+static inline bool scsi_device_in_recovery(struct scsi_device *sdev)
+{
+	struct scsi_device_eh *eh = sdev->eh;
+
+	return eh && eh->is_busy && eh->is_busy(sdev);
+}
+
 struct bsg_device *scsi_bsg_register_queue(struct scsi_device *sdev);
 
 extern int scsi_device_max_queue_depth(struct scsi_device *sdev);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6d6500148c4b..c21b0a84bbd2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -100,6 +100,34 @@ struct scsi_vpd {
 	unsigned char	data[];
 };
 
+struct scsi_device;
+
+struct scsi_device_eh {
+	/*
+	 * add scsi command to error handler so it would be handuled by
+	 * driver's error handle strategy
+	 */
+	void (*add_cmnd)(struct scsi_cmnd *scmd);
+
+	/*
+	 * to judge if the device is busy handling errors, called before
+	 * dispatch scsi cmnd
+	 *
+	 * return 0 if it's ready to accepy scsi cmnd
+	 * return 1 if it's in error handle, command's would not be dispatched
+	 */
+	bool (*is_busy)(struct scsi_device *sdev);
+
+	/*
+	 * wakeup device's error handle
+	 *
+	 * usually the error handler strategy would not run at once when
+	 * error command is added. This function would be called when any
+	 * scsi cmnd is finished or when scsi cmnd is added.
+	 */
+	void (*wakeup)(struct scsi_device *sdev);
+};
+
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -289,6 +317,7 @@ struct scsi_device {
 	struct mutex		state_mutex;
 	enum scsi_device_state sdev_state;
 	struct task_struct	*quiesced_by;
+	struct scsi_device_eh	*eh;
 	unsigned long		sdev_data[];
 } __attribute__((aligned(sizeof(unsigned long))));
 
-- 
2.33.0

