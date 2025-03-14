Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742FF1A29A;
	Fri, 14 Mar 2025 01:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914618; cv=none; b=ms39lTlHctwr7nIqV8iN/T9adcyn4+meoYASks8ikNCSz7hKLORyHBc304kvM0QmiXdstr1VUIoV0GXxoweGhmMi5wj03+Q7FbdxgOH0gSQlVgC4qqkAtP68AKhA13kHWx81fHBUtLt46J0WdGJplL3Lr9AfU5HihQWntMFtdlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914618; c=relaxed/simple;
	bh=3FHW5eEqXzBmOUVv02+YImEYpFZuDeUJ3fjJpUMrVZg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IInym485Blgx4YRB6M235N9zWHYfycjn/qjrlQarwVETvXrImJcY6HcQdMCGDZNClGay//FtmUI5cEVZhVvT1lcS2KmCa01YPLZQjtjWowfPjVOPQTw39wy0D+JPMcEsJd2XxaBEVaENW7AEVZH5qmj/KGOG1wOmp8M5faME4TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZDR8C5b2GztQbZ;
	Fri, 14 Mar 2025 09:08:43 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id BBEDE1800E4;
	Fri, 14 Mar 2025 09:10:12 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:11 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 01/19] scsi: scsi_error: Define framework for LUN/target based error handle
Date: Fri, 14 Mar 2025 09:29:09 +0800
Message-ID: <20250314012927.150860-2-jiangjianjun3@huawei.com>
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

The old scsi error handle logic is based on host, once a scsi command
in one LUN of this host is classfied as failed, SCSI mid-level would
set the whole host to recovery state, and no IO can be submitted to
all LUNs of this host any more before recovery finished, while the
recovery process might take a long time to finish.
It's unreasonable when there are a lot of LUNs in one host.

This change introduce a way for driver to implement its own
error handle logic which can be based on scsi LUN or scsi target
as minimum unit.

scsi_device_eh is defined for error handle based on scsi LUN, and
pointer struct scsi_device_eh "eh" is added in scsi_device, which
is NULL by default.
LLDs can initialize the sdev->eh in hostt->slave_alloc to implement an
scsi LUN based error handle. If this member is not NULL, SCSI mid-level
would branch to drivers' error handler rather than the old one which
block whole host's IO.

scsi_target_eh is defined for error handle based on scsi target, and
pointer struct scsi_target_eh "eh" is added in scsi_target, which is NULL
by default.
LLDs can initialize the starget->eh in hostt->target_alloc to implement
an scsi target based error handle. If this member is not NULL, SCSI
mid-level would branch to drivers' error handler rather than the
old one which block whole host's IO.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c  | 57 +++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_lib.c    | 12 +++++++
 drivers/scsi/scsi_priv.h   | 18 ++++++++++
 include/scsi/scsi_device.h | 67 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 153 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 815e7d63f3e2..f89de23a6807 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -291,11 +291,48 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
+#define SCSI_EH_NO_HANDLER 1
+
+static int __scsi_eh_scmd_add_sdev(struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_device_eh *eh = sdev->eh;
+
+	if (!eh || !eh->add_cmnd)
+		return SCSI_EH_NO_HANDLER;
+
+	scsi_eh_reset(scmd);
+	eh->add_cmnd(scmd);
+
+	if (eh->wakeup)
+		eh->wakeup(sdev);
+
+	return 0;
+}
+
+static int __scsi_eh_scmd_add_starget(struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_target *starget = scsi_target(sdev);
+	struct scsi_target_eh *eh = starget->eh;
+
+	if (!eh || !eh->add_cmnd)
+		return SCSI_EH_NO_HANDLER;
+
+	scsi_eh_reset(scmd);
+	eh->add_cmnd(scmd);
+
+	if (eh->wakeup)
+		eh->wakeup(starget);
+
+	return 0;
+}
+
 /**
  * scsi_eh_scmd_add - add scsi cmd to error handling.
  * @scmd:	scmd to run eh on.
  */
-void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
+static void __scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 {
 	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
@@ -322,6 +359,24 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 	call_rcu_hurry(&scmd->rcu, scsi_eh_inc_host_failed);
 }
 
+void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdev = scmd->device;
+	struct scsi_target *starget = scsi_target(sdev);
+	struct Scsi_Host *shost = sdev->host;
+
+	if (unlikely(scsi_host_in_recovery(shost)))
+		__scsi_eh_scmd_add(scmd);
+
+	if (unlikely(scsi_target_in_recovery(starget)))
+		if (__scsi_eh_scmd_add_starget(scmd))
+			__scsi_eh_scmd_add(scmd);
+
+	if (__scsi_eh_scmd_add_sdev(scmd))
+		if (__scsi_eh_scmd_add_starget(scmd))
+			__scsi_eh_scmd_add(scmd);
+}
+
 /**
  * scsi_timeout - Timeout function for normal scsi commands.
  * @req:	request that is timing out.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f1cfe0bb89b2..8cdab7ac5980 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -399,6 +399,12 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 
 	sbitmap_put(&sdev->budget_map, cmd->budget_token);
 	cmd->budget_token = -1;
+
+	if (sdev->eh && sdev->eh->wakeup)
+		sdev->eh->wakeup(sdev);
+
+	if (starget->eh && starget->eh->wakeup)
+		starget->eh->wakeup(starget);
 }
 
 /*
@@ -1357,6 +1363,9 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 {
 	int token;
 
+	if (scsi_device_in_recovery(sdev))
+		return -1;
+
 	token = sbitmap_get(&sdev->budget_map);
 	if (token < 0)
 		return -1;
@@ -1390,6 +1399,9 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 	struct scsi_target *starget = scsi_target(sdev);
 	unsigned int busy;
 
+	if (scsi_target_in_recovery(starget))
+		return 0;
+
 	if (starget->single_lun) {
 		spin_lock_irq(shost->host_lock);
 		if (starget->starget_sdev_user &&
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 9fc397a9ce7a..90e1e6d80265 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -193,6 +193,24 @@ static inline void scsi_dh_add_device(struct scsi_device *sdev) { }
 static inline void scsi_dh_release_device(struct scsi_device *sdev) { }
 #endif
 
+static inline int scsi_device_in_recovery(struct scsi_device *sdev)
+{
+	struct scsi_device_eh *eh = sdev->eh;
+
+	if (eh && eh->is_busy)
+		return eh->is_busy(sdev);
+	return 0;
+}
+
+static inline int scsi_target_in_recovery(struct scsi_target *starget)
+{
+	struct scsi_target_eh *eh = starget->eh;
+
+	if (eh && eh->is_busy)
+		return eh->is_busy(starget);
+	return 0;
+}
+
 struct bsg_device *scsi_bsg_register_queue(struct scsi_device *sdev);
 
 extern int scsi_device_max_queue_depth(struct scsi_device *sdev);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7acd0ec82bb0..5911c82ca435 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -100,6 +100,71 @@ struct scsi_vpd {
 	unsigned char	data[];
 };
 
+struct scsi_device;
+struct scsi_target;
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
+	 * return 0 if it's in error handle, command's would not be dispatched
+	 */
+	int (*is_busy)(struct scsi_device *sdev);
+
+	/*
+	 * wakeup device's error handle
+	 *
+	 * usually the error handler strategy would not run at once when
+	 * error command is added. This function would be called when any
+	 * scsi cmnd is finished or when scsi cmnd is added.
+	 */
+	int (*wakeup)(struct scsi_device *sdev);
+
+	/*
+	 * data entity for device specific error handler
+	 */
+	unsigned long driver_data[];
+};
+
+struct scsi_target_eh {
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
+	 * return 0 if it's in error handle, command's would not be dispatched
+	 */
+	int (*is_busy)(struct scsi_target *starget);
+
+	/*
+	 * wakeup device's error handle
+	 *
+	 * usually the error handler strategy would not run at once when
+	 * error command is added. This function would be called when any
+	 * scsi cmnd is finished or when scsi cmnd is added.
+	 */
+	int (*wakeup)(struct scsi_target *starget);
+
+	/*
+	 * data entity for device specific error handler
+	 */
+	unsigned long driver_data[];
+};
+
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -281,6 +346,7 @@ struct scsi_device {
 	struct mutex		state_mutex;
 	enum scsi_device_state sdev_state;
 	struct task_struct	*quiesced_by;
+	struct scsi_device_eh	*eh;
 	unsigned long		sdev_data[];
 } __attribute__((aligned(sizeof(unsigned long))));
 
@@ -367,6 +433,7 @@ struct scsi_target {
 	char			scsi_level;
 	enum scsi_target_state	state;
 	void 			*hostdata; /* available to low-level driver */
+	struct scsi_target_eh	*eh;
 	unsigned long		starget_data[]; /* for the transport */
 	/* starget_data must be the last element!!!! */
 } __attribute__((aligned(sizeof(unsigned long))));
-- 
2.33.0

