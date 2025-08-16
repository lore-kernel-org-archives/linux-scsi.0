Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CE229CB49;
	Sat, 16 Aug 2025 10:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755341597; cv=none; b=QYjHzpSc/KvA+lTscaKN2ecZm3IrtESXHVGPvJLVuQ6+BEQ2Ljaq5ccNfyiMsoJkOyPOMMsCF6CrNa+QzDbxO1yhi/03Z6DOnafQtWADtdBH+zAhdpyFrFkUS0henX1LOqdAGT2ZOtjbG0RkJMuFvQ6AuuGjPQ4O+7isNtyQ/18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755341597; c=relaxed/simple;
	bh=LTav2CwatPk4LMjhb4iLXtCnvRNyyA4z38N2bpsscdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZABhHQFcBZ2ZgaTkh+TWlz8adJmunTheCjmam5tMp1Mrgt/HRxBCgpzHwjIrhOwYnhrzC6BHxgbxKli3waCec+1guwNXuLspSH7ROxaToNkmJg51ngCEzSZ8vcW9I4fygxl3ykJNxdGO9oIApFcunuDBqC9kEveauFKvkuLmxWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c3wj45nKfz13NFP;
	Sat, 16 Aug 2025 18:49:44 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id EB8001402C8;
	Sat, 16 Aug 2025 18:53:12 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:53:11 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 08/14] scsi: scsi_error: Add a general LUN based error handler
Date: Sat, 16 Aug 2025 19:24:11 +0800
Message-ID: <20250816112417.3581253-9-jiangjianjun3@huawei.com>
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

Add a general LUN based error handler which can be used by drivers
directly. This error handler implements an scsi_device_eh, when handling
error commands, it would call helper function scsi_sdev_eh() added before
to try recover error commands.

The behavior if scsi_sdev_eh() can not recover all error commands
depends on fallback flag, which is initialized when scsi_device is
allocated. If fallback is set, it would fallback to further error
recover strategy like old host based error handle; else it would
mark this scsi device offline and flush all error commands. Add a
flag for controlling rollback in scsi_host_template.

Add interface sdev_setup_eh/sdev_clear_eh in scsi_host_template, used
for setup/clear LUN based error handler. Drivers can implements them
custom, or use inner implements:
  scsi_device_setup_eh/scsi_device_clear_eh.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@h-partners.com>
Signed-off-by: JiangJianJun <jiangjianjun3@h-partners.com>
---
 drivers/scsi/scsi_error.c | 179 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c  |   7 ++
 drivers/scsi/scsi_sysfs.c |   2 +
 include/scsi/scsi_eh.h    |   2 +
 include/scsi/scsi_host.h  |  16 ++++
 5 files changed, 206 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b09f721d4d93..49344f30bab9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2804,3 +2804,182 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+static inline void *scsi_eh_device_priv(struct scsi_device_eh *eh)
+{
+	return eh + 1;
+}
+
+struct scsi_lun_eh {
+	spinlock_t		eh_lock;
+	unsigned int		eh_num;
+	struct list_head	eh_cmd_q;
+	struct scsi_device	*sdev;
+	struct work_struct	eh_handle_work;
+	unsigned int		fallback:1;
+};
+
+/*
+ * error handle strategy based on LUN, following steps
+ * is applied to recovery error commands in list:
+ *    check sense data
+ *    send start unit
+ *    reset lun
+ * if there are still error commands, it would fallback to
+ * target based or host based error handle for further recovery.
+ */
+static void sdev_eh_work(struct work_struct *work)
+{
+	unsigned long flags;
+	struct scsi_lun_eh *luneh =
+			container_of(work, struct scsi_lun_eh, eh_handle_work);
+	struct scsi_device *sdev = luneh->sdev;
+	struct scsi_device_eh *eh = sdev->eh;
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_cmnd *scmd, *next;
+	LIST_HEAD(eh_work_q);
+	LIST_HEAD(eh_done_q);
+
+	spin_lock_irqsave(&luneh->eh_lock, flags);
+	list_splice_init(&luneh->eh_cmd_q, &eh_work_q);
+	spin_unlock_irqrestore(&luneh->eh_lock, flags);
+
+	if (scsi_sdev_eh(sdev, &eh_work_q, &eh_done_q))
+		goto out_flush_done;
+
+	if (!luneh->fallback) {
+		list_for_each_entry_safe(scmd, next, &eh_work_q, eh_entry)
+			scsi_eh_finish_cmd(scmd, &eh_done_q);
+
+		sdev_printk(KERN_INFO, sdev,
+			"%s:luneh: Device offlined - not ready after error recovery\n",
+			current->comm);
+
+		mutex_lock(&sdev->state_mutex);
+		scsi_device_set_state(sdev, SDEV_OFFLINE);
+		mutex_unlock(&sdev->state_mutex);
+
+		goto out_flush_done;
+	}
+
+	/*
+	 * fallback to target or host based error handle
+	 */
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh fallback to further recovery\n", current->comm));
+	list_for_each_entry_safe(scmd, next, &eh_work_q, eh_entry) {
+		list_del_init(&scmd->eh_entry);
+
+		if (scsi_host_in_recovery(shost) ||
+		    scsi_eh_scmd_add_starget(scmd))
+			scsi_eh_scmd_add_shost(scmd);
+	}
+
+	eh->get_sense_done = 1;
+	eh->stu_done = 1;
+	eh->reset_done = 1;
+
+out_flush_done:
+	scsi_eh_flush_done_q(&eh_done_q);
+	spin_lock_irqsave(&luneh->eh_lock, flags);
+	luneh->eh_num = 0;
+	spin_unlock_irqrestore(&luneh->eh_lock, flags);
+}
+static void sdev_eh_add_cmnd(struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	struct scsi_lun_eh *luneh;
+	struct scsi_device *sdev = scmd->device;
+
+	luneh = scsi_eh_device_priv(sdev->eh);
+
+	spin_lock_irqsave(&luneh->eh_lock, flags);
+	list_add_tail(&scmd->eh_entry, &luneh->eh_cmd_q);
+	luneh->eh_num++;
+	spin_unlock_irqrestore(&luneh->eh_lock, flags);
+}
+static bool sdev_eh_is_busy(struct scsi_device *sdev)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct scsi_lun_eh *luneh;
+
+	if (!sdev->eh)
+		return false;
+
+	luneh = scsi_eh_device_priv(sdev->eh);
+
+	spin_lock_irqsave(&luneh->eh_lock, flags);
+	ret = luneh->eh_num;
+	spin_unlock_irqrestore(&luneh->eh_lock, flags);
+
+	return ret != 0;
+}
+static void sdev_eh_wakeup(struct scsi_device *sdev)
+{
+	unsigned long flags;
+	unsigned int nr_error;
+	unsigned int nr_busy;
+	struct scsi_lun_eh *luneh;
+
+	luneh = scsi_eh_device_priv(sdev->eh);
+
+	spin_lock_irqsave(&luneh->eh_lock, flags);
+	nr_error = luneh->eh_num;
+	spin_unlock_irqrestore(&luneh->eh_lock, flags);
+
+	nr_busy = scsi_device_busy(sdev);
+
+	if (!nr_error || nr_busy != nr_error) {
+		SCSI_LOG_ERROR_RECOVERY(5, sdev_printk(KERN_INFO, sdev,
+			"%s:luneh: do not wake up, busy/error: %d/%d\n",
+			current->comm, nr_busy, nr_error));
+		return;
+	}
+
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh: waking up, busy/error: %d/%d\n",
+		current->comm, nr_busy, nr_error));
+
+	schedule_work(&luneh->eh_handle_work);
+}
+
+/*
+ * This is default implement of Scsi_Host.sdev_setup_eh.
+ */
+int scsi_device_setup_eh(struct scsi_device *sdev)
+{
+	struct scsi_device_eh *eh;
+	struct scsi_lun_eh *luneh;
+
+	eh = kzalloc(sizeof(struct scsi_device_eh) + sizeof(struct scsi_lun_eh),
+		GFP_KERNEL);
+	if (!eh)
+		return -ENOMEM;
+	luneh = scsi_eh_device_priv(eh);
+
+	eh->add_cmnd = sdev_eh_add_cmnd;
+	eh->is_busy  = sdev_eh_is_busy;
+	eh->wakeup   = sdev_eh_wakeup;
+
+	luneh->fallback  = sdev->host->hostt->sdev_eh_fallback;
+	luneh->sdev  = sdev;
+	spin_lock_init(&luneh->eh_lock);
+	INIT_LIST_HEAD(&luneh->eh_cmd_q);
+	INIT_WORK(&luneh->eh_handle_work, sdev_eh_work);
+
+	sdev->eh = eh;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_device_setup_eh);
+
+/*
+ * This is default implement of Scsi_Host.sdev_clear_eh.
+ */
+void scsi_device_clear_eh(struct scsi_device *sdev)
+{
+	kfree(sdev->eh);
+	sdev->eh = NULL;
+}
+EXPORT_SYMBOL_GPL(scsi_device_clear_eh);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3c6e089e80c3..1c5cb77dfb22 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -377,9 +377,16 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 			goto out_device_destroy;
 		}
 	}
+	if (shost->hostt->sdev_setup_eh) {
+		ret = shost->hostt->sdev_setup_eh(sdev);
+		if (ret)
+			goto out_device_eh;
+	}
 
 	return sdev;
 
+out_device_eh:
+	shost->hostt->sdev_destroy(sdev);
 out_device_destroy:
 	__scsi_remove_device(sdev);
 out:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 169af7d47ce7..d859371c01bb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1513,6 +1513,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 	cancel_work_sync(&sdev->requeue_work);
 
+	if (sdev->host->hostt->sdev_clear_eh)
+		sdev->host->hostt->sdev_clear_eh(sdev);
 	if (sdev->host->hostt->sdev_destroy)
 		sdev->host->hostt->sdev_destroy(sdev);
 	transport_destroy_device(dev);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 5ce791063baf..d8e4475ff004 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -20,6 +20,8 @@ extern bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 extern enum scsi_disposition scsi_check_sense(struct scsi_cmnd *);
 extern int scsi_sdev_eh(struct scsi_device *sdev, struct list_head *workq,
 			struct list_head *doneq);
+extern int scsi_device_setup_eh(struct scsi_device *sdev);
+extern void scsi_device_clear_eh(struct scsi_device *sdev);
 
 static inline bool scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
 {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 46f57fe78505..9cc34bfff3f7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -225,6 +225,19 @@ struct scsi_host_template {
 	 */
 	void (* sdev_destroy)(struct scsi_device *);
 
+	/*
+	 * Setup or clear error handler field scsi_device.eh.
+	 * This error handler is working on designated device, it will only
+	 * operate the designated device, do not affect other devices.
+	 * If not set, error handle will fallback.
+	 * LLDD can use custom error handler, or use inner defined:
+	 *   scsi_device_setup_eh/scsi_device_clear_eh
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (*sdev_setup_eh)(struct scsi_device *sdev);
+	void (*sdev_clear_eh)(struct scsi_device *sdev);
+
 	/*
 	 * Before the mid layer attempts to scan for a new device attached
 	 * to a target where no target currently exists, it will call this
@@ -468,6 +481,9 @@ struct scsi_host_template {
 	/* The queuecommand callback may block. See also BLK_MQ_F_BLOCKING. */
 	unsigned queuecommand_may_block:1;
 
+	/* The error handle of scsi_device will fallback when failed. */
+	unsigned sdev_eh_fallback:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
-- 
2.33.0

