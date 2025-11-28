Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C807A13A;
	Fri, 28 Nov 2025 14:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764340327; cv=none; b=F6a+ZCi4WUA74/IwfiT7ZDxa1UM9yO7cd9jh31WhdBm7cPXngVyc16st+ak7t0mbrC7/jK4VxXiYebGDvJIrgeMsUgVr8V8BwgZDl9i7hdIN3rPKPq6OT6YaiUFRTxgVL0xw/84r6mMbFiN1bSGqysIOiCnx4LAqdii/sHsLMNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764340327; c=relaxed/simple;
	bh=jE9nCj01dRUOE/tubZpFXaPtoHtxruUGmyXjWm/AU80=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Ardk/vnHZhmIhfXz9iHp/zqLf/PRgbuDl1CZAqYnyz5t3HTGHA+QXMhdv5H3WSdYsCyfpvU4tQfqi72Sw1ejUMRgSuw/ioC+GEzhm0KI+nrPgg6AzBU3LIE391y/u3AoTYU/W65IRTVYFjY9b1XrJ0Ku/vXpoDXTgasQooIDd9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=HgSIF9tv; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="HgSIF9tv"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lz4O+NceCIJyDaW4VGi+s1XI2Zs4rnglF3Ib83Lj7sc=;
	b=HgSIF9tvhbnUqkNAwXLAO9be8bVIj+jl4ZQQy6AnXHCPQoKOgZhL0I3SsBg62yzc858yZfQML
	e8hDYsGvWLYE/7PfYW94opkT/+JZzWcs2CrATNK6W9tuOMGicWdc+JHwwaHNX2SCrVzhmegP560
	LFjUhY/Yphm6m6vvvQ75rk0=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dHwgM0fsFz1T4G3;
	Fri, 28 Nov 2025 22:30:07 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id E4EB6140278;
	Fri, 28 Nov 2025 22:31:52 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 28 Nov 2025 22:31:52 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <hare@suse.de>, <dlemoal@kernel.org>, <yangxingui@huawei.com>,
	<hewenliang4@huawei.com>, <yangyun50@huawei.com>, <wuyifeng10@huawei.com>,
	<wubo40@huawei.com>, <jiangjianjun3@huawei.com>
Subject: [PATCH] scsi: scsi_error: the Error Handler base on SCSI Device
Date: Fri, 28 Nov 2025 22:31:43 +0800
Message-ID: <20251128143143.1947791-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemk500001.china.huawei.com (7.202.194.86)

This change is used to downgrade the lock in SCSI Error Handler.

When a SCSI device fails, SCSI locks the host and enters an error handler,
which causes all I/O operations on the host to be locked. This performance
impact is even more pronounced when a large number of devices are connected
to the same host. So I believe it's necessary to downgrade the large lock.

This commit binds an Error Handler to the device, so that when a device
failure occurs, only the current device is locked. If the device fails to
recover, the default Error Handler will still be activated.

This mechanism is disabled by default. SCSI LLD should set the
`enable_sdev_eh` of `scsi_host_template` to 1 if needed.

Signed-off-by: JiangJianJun <jiangjianjun3@huawei.com>

References: https://lore.kernel.org/linux-scsi/20250816112417.3581253-1-jiangjianjun3@huawei.com/
References: https://lore.kernel.org/linux-scsi/20230901094127.2010873-1-haowenchao2@huawei.com/
References: https://lore.kernel.org/linux-scsi/b62930b3-9b80-4b06-b922-c38c7e309048@acm.org/

---
 drivers/scsi/scsi_debug.c  |   1 +
 drivers/scsi/scsi_error.c  | 318 +++++++++++++++++++++++++++++++------
 drivers/scsi/scsi_lib.c    |   7 +
 drivers/scsi/scsi_priv.h   |   3 +
 drivers/scsi/scsi_scan.c   |   1 +
 include/scsi/scsi_device.h |  19 +++
 include/scsi/scsi_eh.h     |   2 +
 include/scsi/scsi_host.h   |   5 +-
 8 files changed, 302 insertions(+), 54 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 353cb60e1abe..37f891c11b29 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9467,6 +9467,7 @@ static const struct scsi_host_template sdebug_driver_template = {
 	.init_cmd_priv = sdebug_init_cmd_priv,
 	.target_alloc =		sdebug_target_alloc,
 	.target_destroy =	sdebug_target_destroy,
+	.enable_sdev_eh = 1,
 };
 
 static int sdebug_driver_probe(struct device *dev)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 746ff6a1f309..b682680d0139 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -57,9 +57,26 @@
 #define BUS_RESET_SETTLE_TIME   (10)
 #define HOST_RESET_SETTLE_TIME  (10)
 
+enum {
+	SDEV_EH_STOP = 0,
+	SDEV_EH_START,
+	SDEV_EH_DONE,
+};
+
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
 static enum scsi_disposition scsi_try_to_abort_cmd(const struct scsi_host_template *,
 						   struct scsi_cmnd *);
+static void sdev_eh_add_cmnd(struct scsi_cmnd *scmd);
+static void sdev_eh_wakeup(struct scsi_device *sdev);
+
+static inline void shost_clear_eh_done(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost) {
+		atomic_set(&sdev->eh.state, SDEV_EH_STOP);
+	}
+}
 
 void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy)
 {
@@ -292,10 +309,21 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
 }
 
 /**
- * scsi_eh_scmd_add - add scsi cmd to error handling.
- * @scmd:	scmd to run eh on.
+ * scsi_eh_scmd_add_shost - Add cmd to error handling of scsi_device.
+ * @scmd:    scmd to run eh on.
  */
-void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
+static void scsi_eh_scmd_add_sdev(struct scsi_cmnd *scmd)
+{
+	scsi_eh_reset(scmd);
+	sdev_eh_add_cmnd(scmd);
+	sdev_eh_wakeup(scmd->device);
+}
+
+/**
+ * scsi_eh_scmd_add_shost - Add cmd to error handling of Scsi_Host.
+ * @scmd:    scmd to run eh on.
+ */
+static void scsi_eh_scmd_add_shost(struct scsi_cmnd *scmd)
 {
 	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
@@ -322,6 +350,21 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 	call_rcu_hurry(&scmd->rcu, scsi_eh_inc_host_failed);
 }
 
+/**
+ * scsi_eh_scmd_add - add scsi cmd to error handling.
+ * @scmd:	scmd to run eh on.
+ */
+void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
+{
+	struct Scsi_Host *shost = scmd->device->host;
+	const struct scsi_host_template *sht = shost->hostt;
+
+	if (!sht->enable_sdev_eh || unlikely(scsi_host_in_recovery(shost)))
+		scsi_eh_scmd_add_shost(scmd);
+	else
+		scsi_eh_scmd_add_sdev(scmd);
+}
+
 /**
  * scsi_timeout - Timeout function for normal scsi commands.
  * @req:	request that is timing out.
@@ -881,7 +924,7 @@ void scsi_eh_done(struct scsi_cmnd *scmd)
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
 			"%s result: %x\n", __func__, scmd->result));
 
-	eh_action = scmd->device->host->eh_action;
+	eh_action = scmd->device->eh.action;
 	if (eh_action)
 		complete(eh_action);
 }
@@ -890,7 +933,7 @@ void scsi_eh_done(struct scsi_cmnd *scmd)
  * scsi_try_host_reset - ask host adapter to reset itself
  * @scmd:	SCSI cmd to send host reset.
  */
-static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition __scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	enum scsi_disposition rtn;
@@ -916,11 +959,19 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
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
@@ -946,6 +997,14 @@ static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
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
@@ -1170,7 +1229,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 
 retry:
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
-	shost->eh_action = &done;
+	sdev->eh.action = &done;
 
 	scsi_log_send(scmd);
 	scmd->submitter = SUBMITTED_BY_SCSI_ERROR_HANDLER;
@@ -1214,7 +1273,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 		rtn = SUCCESS;
 	}
 
-	shost->eh_action = NULL;
+	sdev->eh.action = NULL;
 
 	scsi_log_completion(scmd, rtn);
 
@@ -1345,6 +1404,8 @@ int scsi_eh_get_sense(struct list_head *work_q,
 					     current->comm));
 			break;
 		}
+		if (atomic_read(&scmd->device->eh.state) == SDEV_EH_DONE)
+			continue;
 		if (!scsi_status_is_check_condition(scmd->result))
 			/*
 			 * don't request sense if there's no check condition
@@ -1507,6 +1568,31 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
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
@@ -1521,7 +1607,7 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			      struct list_head *work_q,
 			      struct list_head *done_q)
 {
-	struct scsi_cmnd *scmd, *stu_scmd, *next;
+	struct scsi_cmnd *scmd, *stu_scmd;
 	struct scsi_device *sdev;
 
 	shost_for_each_device(sdev, shost) {
@@ -1533,6 +1619,8 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			scsi_device_put(sdev);
 			break;
 		}
+		if (atomic_read(&scmd->device->eh.state) == SDEV_EH_DONE)
+			continue;
 		stu_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
@@ -1544,29 +1632,41 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 		if (!stu_scmd)
 			continue;
 
+		if (scsi_eh_sdev_stu(stu_scmd, work_q, done_q)) {
+			scsi_device_put(sdev);
+			break;
+		}
+	}
+
+	return list_empty(work_q);
+}
+
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
 		SCSI_LOG_ERROR_RECOVERY(3,
 			sdev_printk(KERN_INFO, sdev,
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
-		}
+				    "%s: BDR failed\n", current->comm));
+		return 0;
 	}
 
+	if (!scsi_device_online(sdev) || rtn == FAST_IO_FAIL ||
+	    !scsi_eh_tur(scmd))
+		list_for_each_entry_safe(scmd, next, work_q, eh_entry)
+			if (scmd->device == sdev &&
+			    scsi_eh_action(scmd, rtn) != FAILED)
+				scsi_eh_finish_cmd(scmd, done_q);
+
 	return list_empty(work_q);
 }
 
@@ -1587,9 +1687,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				    struct list_head *work_q,
 				    struct list_head *done_q)
 {
-	struct scsi_cmnd *scmd, *bdr_scmd, *next;
+	struct scsi_cmnd *scmd, *bdr_scmd;
 	struct scsi_device *sdev;
-	enum scsi_disposition rtn;
 
 	shost_for_each_device(sdev, shost) {
 		if (scsi_host_eh_past_deadline(shost)) {
@@ -1606,30 +1705,15 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				bdr_scmd = scmd;
 				break;
 			}
+		if (atomic_read(&scmd->device->eh.state) == SDEV_EH_DONE)
+			continue;
 
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
 
@@ -2361,6 +2445,7 @@ int scsi_error_handler(void *data)
 
 		/* All scmds have been handled */
 		shost->host_failed = 0;
+		shost_clear_eh_done(shost);
 
 		/*
 		 * Note - if the above fails completely, the action is to take
@@ -2511,12 +2596,12 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
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
@@ -2596,3 +2681,132 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+static int scsi_sdev_eh(struct scsi_device *sdev,
+		 struct list_head *work_q,
+		 struct list_head *done_q)
+{
+	int ret = 0;
+	struct scsi_cmnd *scmd;
+
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh: checking sense\n", current->comm));
+	ret = scsi_eh_get_sense(work_q, done_q);
+	if (ret)
+		return ret;
+
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh: start unit\n", current->comm));
+	scmd = list_first_entry(work_q, struct scsi_cmnd, eh_entry);
+	ret = scsi_eh_sdev_stu(scmd, work_q, done_q);
+	if (ret)
+		return ret;
+
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh: reset LUN\n", current->comm));
+	scmd = list_first_entry(work_q, struct scsi_cmnd, eh_entry);
+	ret = scsi_eh_sdev_reset(scmd, work_q, done_q);
+
+	return ret;
+}
+static void sdev_eh_work(struct work_struct *work)
+{
+	int ret;
+	unsigned long flags;
+	struct scsi_device_eh *eh =
+		container_of(work, struct scsi_device_eh, work);
+	struct scsi_device *sdev =
+		container_of(eh, struct scsi_device, eh);
+	struct scsi_cmnd *scmd, *next;
+	LIST_HEAD(eh_work_q);
+	LIST_HEAD(eh_done_q);
+
+	spin_lock_irqsave(&eh->lock, flags);
+	list_splice_init(&eh->cmd_q, &eh_work_q);
+	spin_unlock_irqrestore(&eh->lock, flags);
+
+	ret = scsi_sdev_eh(sdev, &eh_work_q, &eh_done_q);
+	atomic_cmpxchg(&eh->state, SDEV_EH_START,
+		ret ? SDEV_EH_STOP : SDEV_EH_DONE);
+	if (ret)
+		goto out_flush_done;
+
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh fallback to host recovery\n", current->comm));
+	list_for_each_entry_safe(scmd, next, &eh_work_q, eh_entry) {
+		list_del_init(&scmd->eh_entry);
+		scsi_eh_scmd_add_shost(scmd);
+	}
+
+out_flush_done:
+	scsi_eh_flush_done_q(&eh_done_q);
+	atomic_set(&eh->fail_cnt, 0);
+}
+static void sdev_eh_add_cmnd(struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	struct scsi_device_eh *eh = &scmd->device->eh;
+
+	atomic_inc(&eh->fail_cnt);
+	spin_lock_irqsave(&eh->lock, flags);
+	list_add_tail(&scmd->eh_entry, &eh->cmd_q);
+	spin_unlock_irqrestore(&eh->lock, flags);
+}
+bool scsi_device_in_recovery(struct scsi_device *sdev)
+{
+	return atomic_read(&sdev->eh.fail_cnt) != 0;
+}
+static void sdev_eh_wakeup(struct scsi_device *sdev)
+{
+	unsigned int fail_cnt;
+	unsigned int busy_cnt;
+	struct scsi_device_eh *eh = &sdev->eh;
+	int state;
+
+	fail_cnt = atomic_read(&eh->fail_cnt);
+	if (!fail_cnt) {
+		SCSI_LOG_ERROR_RECOVERY(6, sdev_printk(KERN_INFO, sdev,
+			"%s:luneh: no failed cmd\n", current->comm));
+		return;
+	}
+
+	busy_cnt = scsi_device_busy(sdev);
+	if (busy_cnt != fail_cnt) {
+		SCSI_LOG_ERROR_RECOVERY(5, sdev_printk(KERN_INFO, sdev,
+			"%s:luneh: do not wake up, busy/fail: %d/%d\n",
+			current->comm, busy_cnt, fail_cnt));
+		return;
+	}
+
+	state = atomic_cmpxchg(&eh->state, SDEV_EH_STOP, SDEV_EH_START);
+	if (state != SDEV_EH_STOP) {
+		SCSI_LOG_ERROR_RECOVERY(5, sdev_printk(KERN_INFO, sdev,
+			"%s:luneh: is waken up, busy/fail: %d/%d\n",
+			current->comm, busy_cnt, fail_cnt));
+		return;
+	}
+
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh: waking up, busy/fail: %d/%d\n",
+		current->comm, busy_cnt, fail_cnt));
+	schedule_work(&eh->work);
+}
+void sdev_eh_try_wakeup(struct scsi_device *sdev)
+{
+	const struct scsi_host_template *sht = sdev->host->hostt;
+
+	if (sht->enable_sdev_eh)
+		sdev_eh_wakeup(sdev);
+}
+
+void scsi_device_init_eh(struct scsi_device *sdev)
+{
+	struct scsi_device_eh *eh = &sdev->eh;
+
+	INIT_WORK(&eh->work, sdev_eh_work);
+	spin_lock_init(&eh->lock);
+	INIT_LIST_HEAD(&eh->cmd_q);
+	eh->action = NULL;
+	atomic_set(&eh->fail_cnt, 0);
+	atomic_set(&eh->state, SDEV_EH_STOP);
+}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0c65ecfedfbd..84c92716fa2b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -398,6 +398,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
 
 	sbitmap_put(&sdev->budget_map, cmd->budget_token);
 	cmd->budget_token = -1;
+
+	sdev_eh_try_wakeup(sdev);
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
+		sdev_eh_try_wakeup(sdev);
 		return -1;
 	}
 
@@ -1882,6 +1888,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 out_put_budget:
 	scsi_mq_put_budget(q, cmd->budget_token);
 	cmd->budget_token = -1;
+	sdev_eh_try_wakeup(sdev);
 	switch (ret) {
 	case BLK_STS_OK:
 		break;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 5b2b19f5e8ec..ae2a23f4cdd3 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -92,6 +92,9 @@ extern int scsi_error_handler(void *host);
 extern enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy);
 extern void scsi_eh_scmd_add(struct scsi_cmnd *);
+extern void sdev_eh_try_wakeup(struct scsi_device *sdev);
+extern bool scsi_device_in_recovery(struct scsi_device *sdev);
+extern void scsi_device_init_eh(struct scsi_device *sdev);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
 			struct list_head *work_q,
 			struct list_head *done_q);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3c6e089e80c3..1e73bd869a25 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -362,6 +362,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	}
 
 	scsi_change_queue_depth(sdev, depth);
+	scsi_device_init_eh(sdev);
 
 	scsi_sysfs_device_initialize(sdev);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6d6500148c4b..f3fc1906db45 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -100,6 +100,24 @@ struct scsi_vpd {
 	unsigned char	data[];
 };
 
+/**
+ * struct scsi_device_eh - SCSI Device Error Handler
+ * @work: For schedule_work
+ * @lock: protect cmd_q
+ * @cmd_q: queue of failed scmd
+ * @action: error handle command's completion
+ * @fail_cnt: count of cmd_q
+ * @state: state of Error Handler working
+ */
+struct scsi_device_eh {
+	struct work_struct	work;
+	spinlock_t			lock;
+	struct list_head	cmd_q;
+	struct completion	*action;
+	atomic_t			fail_cnt;
+	atomic_t			state;
+};
+
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -289,6 +307,7 @@ struct scsi_device {
 	struct mutex		state_mutex;
 	enum scsi_device_state sdev_state;
 	struct task_struct	*quiesced_by;
+	struct scsi_device_eh eh;
 	unsigned long		sdev_data[];
 } __attribute__((aligned(sizeof(unsigned long))));
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 1ae08e81339f..f12fe46c7373 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -18,6 +18,8 @@ extern int scsi_block_when_processing_errors(struct scsi_device *);
 extern bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 					 struct scsi_sense_hdr *sshdr);
 extern enum scsi_disposition scsi_check_sense(struct scsi_cmnd *);
+extern int scsi_device_setup_eh(struct scsi_device *sdev);
+extern void scsi_device_clear_eh(struct scsi_device *sdev);
 
 static inline bool scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
 {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index c53812b9026f..416353f565fb 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -468,6 +468,9 @@ struct scsi_host_template {
 	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
 	unsigned queuecommand_may_block:1;
 
+	/* Enable error handler on scsi device */
+	unsigned enable_sdev_eh:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -558,8 +561,6 @@ struct Scsi_Host {
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

