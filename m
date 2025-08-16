Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B586D2BCF45;
	Sat, 16 Aug 2025 10:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755341600; cv=none; b=WxqNMpNDvW+jXIu8vvJ+5tTvmHHe7FqDCJdiqSWtvbMm+bKR2HZcMOjEtopPyTR9NAGqNL3GqdeEXTCFiqQErarpSKAydpfztVdbr9WvFVsDAkrFidKFs2aC74EOfEU16WT4u0qy+fXV4MmNvqiEyP4sJ9Ii86lha8yO0bXGfAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755341600; c=relaxed/simple;
	bh=P8/cPqr04hLQ7CWOtn4WK3IZ4WkYBFpOdvn6A0a3zdQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FNnAjVf7hksghp+gOE84n7IE4iIG+S8sOhSh72PTbkOV0lfZspILRMGRKg8TGlo3en/POqw3aotualAWH5xGzqZLPc/1mgXDL0OlbXFMRKU1R/j1/UTfX/HhNpRKMg65ho/r/JmKY8tAphOWw9ShTWY0Ql9O7eKUvk5jrisxvNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c3wh60mPmzPtHD;
	Sat, 16 Aug 2025 18:48:54 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id 51392180087;
	Sat, 16 Aug 2025 18:53:15 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:53:14 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 11/14] scsi: scsi_error: Add a general target based error handler
Date: Sat, 16 Aug 2025 19:24:14 +0800
Message-ID: <20250816112417.3581253-12-jiangjianjun3@huawei.com>
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

Add a general target based error handler which can be used by drivers
directly. This error handler implements an scsi_target_eh, when handling
error commands, it would call helper function scsi_starget_eh() added
before to try recover error commands.

The behavior if scsi_starget_eh() can not recover all error commands
depends on fallback flag, which is initialized when scsi_target is
allocated. If fallback is set, it would fallback to further error
recover strategy like old host based error handle; else it would
mark this scsi devices of this target  offline and flush all error
commands. Add a flag for controlling rollback in scsi_host_template.

Add interface target_setup_eh/target_clear_eh in scsi_host_template,
used for setup/clear target based error handler. Drivers can
implements them custom, or use inner implements:
  scsi_target_setup_eh/scsi_target_clear_eh.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@h-partners.com>
Signed-off-by: JiangJianJun <jiangjianjun3@h-partners.com>
---
 drivers/scsi/scsi_error.c | 171 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_scan.c  |  12 +++
 include/scsi/scsi_eh.h    |   2 +
 include/scsi/scsi_host.h  |  15 ++++
 4 files changed, 200 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index bc9ca7f38580..e2adf0349f81 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -3113,3 +3113,174 @@ void scsi_device_clear_eh(struct scsi_device *sdev)
 	sdev->eh = NULL;
 }
 EXPORT_SYMBOL_GPL(scsi_device_clear_eh);
+
+static inline void starget_clear_eh_done(struct scsi_target *starget)
+{
+	struct scsi_device *sdev;
+
+	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
+		if (!sdev->eh)
+			continue;
+		sdev->eh->get_sense_done = 0;
+		sdev->eh->stu_done   = 0;
+		sdev->eh->reset_done = 0;
+	}
+}
+
+static inline void *scsi_eh_starget_priv(struct scsi_target_eh *eh)
+{
+	return eh + 1;
+}
+
+struct starget_eh {
+	spinlock_t		eh_lock;
+	unsigned int		eh_num;
+	struct list_head	eh_cmd_q;
+	struct scsi_target	*starget;
+	struct work_struct	eh_handle_work;
+	unsigned int		fallback:1;
+};
+
+static void starget_eh_work(struct work_struct *work)
+{
+	struct scsi_cmnd *scmd, *next;
+	unsigned long flags;
+	LIST_HEAD(eh_work_q);
+	LIST_HEAD(eh_done_q);
+	struct starget_eh *stargeteh =
+			container_of(work, struct starget_eh, eh_handle_work);
+	struct scsi_target *starget = stargeteh->starget;
+	struct scsi_target_eh *eh = starget->eh;
+
+	spin_lock_irqsave(&stargeteh->eh_lock, flags);
+	list_splice_init(&stargeteh->eh_cmd_q, &eh_work_q);
+	spin_unlock_irqrestore(&stargeteh->eh_lock, flags);
+
+	if (scsi_starget_eh(starget, &eh_work_q, &eh_done_q))
+		goto out_clear_flag;
+
+	if (!stargeteh->fallback) {
+		scsi_eh_offline_sdevs(&eh_work_q, &eh_done_q);
+		goto out_clear_flag;
+	}
+
+	/*
+	 * fallback to host based error handle
+	 */
+	SCSI_LOG_ERROR_RECOVERY(2, starget_printk(KERN_INFO, starget,
+		"%s:targeteh fallback to further recovery\n", current->comm));
+	eh->reset_done = 1;
+	list_for_each_entry_safe(scmd, next, &eh_work_q, eh_entry) {
+		list_del_init(&scmd->eh_entry);
+		scsi_eh_scmd_add_shost(scmd);
+	}
+	goto out_flush_done;
+
+out_clear_flag:
+	starget_clear_eh_done(starget);
+
+out_flush_done:
+	scsi_eh_flush_done_q(&eh_done_q);
+	spin_lock_irqsave(&stargeteh->eh_lock, flags);
+	stargeteh->eh_num = 0;
+	spin_unlock_irqrestore(&stargeteh->eh_lock, flags);
+}
+
+static void starget_eh_add_cmnd(struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	struct scsi_target *starget = scmd->device->sdev_target;
+	struct starget_eh *eh;
+
+	eh = scsi_eh_starget_priv(starget->eh);
+
+	spin_lock_irqsave(&eh->eh_lock, flags);
+	list_add_tail(&scmd->eh_entry, &eh->eh_cmd_q);
+	eh->eh_num++;
+	spin_unlock_irqrestore(&eh->eh_lock, flags);
+}
+
+static bool starget_eh_is_busy(struct scsi_target *starget)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct starget_eh *eh;
+
+	eh = scsi_eh_starget_priv(starget->eh);
+
+	spin_lock_irqsave(&eh->eh_lock, flags);
+	ret = eh->eh_num;
+	spin_unlock_irqrestore(&eh->eh_lock, flags);
+
+	return ret != 0;
+}
+
+static void starget_eh_wakeup(struct scsi_target *starget)
+{
+	unsigned long flags;
+	unsigned int nr_error;
+	unsigned int nr_busy;
+	struct starget_eh *eh;
+
+	eh = scsi_eh_starget_priv(starget->eh);
+
+	spin_lock_irqsave(&eh->eh_lock, flags);
+	nr_error = eh->eh_num;
+	spin_unlock_irqrestore(&eh->eh_lock, flags);
+
+	nr_busy = atomic_read(&starget->target_busy);
+
+	if (!nr_error || nr_busy != nr_error) {
+		SCSI_LOG_ERROR_RECOVERY(5, starget_printk(KERN_INFO, starget,
+			"%s:targeteh: do not wake up, busy/error is %d/%d\n",
+			current->comm, nr_busy, nr_error));
+		return;
+	}
+
+	SCSI_LOG_ERROR_RECOVERY(2, starget_printk(KERN_INFO, starget,
+		"%s:targeteh: waking up, busy/error is %d/%d\n",
+		current->comm, nr_busy, nr_error));
+
+	schedule_work(&eh->eh_handle_work);
+}
+
+/*
+ * This is default implement of Scsi_Host.target_setup_eh.
+ */
+int scsi_target_setup_eh(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	struct scsi_target_eh *eh;
+	struct starget_eh *stargeteh;
+
+	eh = kzalloc(sizeof(struct scsi_target_eh) + sizeof(struct starget_eh),
+		GFP_KERNEL);
+	if (!eh)
+		return -ENOMEM;
+	stargeteh = scsi_eh_starget_priv(eh);
+
+	eh->add_cmnd = starget_eh_add_cmnd;
+	eh->is_busy  = starget_eh_is_busy;
+	eh->wakeup   = starget_eh_wakeup;
+	stargeteh->starget = starget;
+	stargeteh->fallback = shost->hostt->target_eh_fallback;
+
+	spin_lock_init(&stargeteh->eh_lock);
+	INIT_LIST_HEAD(&stargeteh->eh_cmd_q);
+	INIT_WORK(&stargeteh->eh_handle_work, starget_eh_work);
+
+	starget->eh = eh;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_target_setup_eh);
+
+/*
+ * This is default implement of Scsi_Host.target_clear_eh.
+ */
+void scsi_target_clear_eh(struct scsi_target *starget)
+{
+	kfree(starget->eh);
+	starget->eh = NULL;
+}
+EXPORT_SYMBOL_GPL(scsi_target_clear_eh);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1c5cb77dfb22..15848beb2b93 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -405,6 +405,8 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	starget->state = STARGET_DEL;
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
+	if (shost->hostt->target_clear_eh)
+		shost->hostt->target_clear_eh(starget);
 	if (shost->hostt->target_destroy)
 		shost->hostt->target_destroy(starget);
 	list_del_init(&starget->siblings);
@@ -553,6 +555,16 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 			return NULL;
 		}
 	}
+	if (shost->hostt->target_setup_eh) {
+		error = shost->hostt->target_setup_eh(starget);
+		if (error) {
+			dev_err(dev, "target setup error handler failed, error %d\n",
+				error);
+			scsi_target_destroy(starget);
+			return NULL;
+		}
+	}
+
 	get_device(dev);
 
 	return starget;
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index cda0b962fc47..4d302be8d6d8 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -24,6 +24,8 @@ extern int scsi_starget_eh(struct scsi_target *starget,
 			struct list_head *workq, struct list_head *doneq);
 extern int scsi_device_setup_eh(struct scsi_device *sdev);
 extern void scsi_device_clear_eh(struct scsi_device *sdev);
+extern int scsi_target_setup_eh(struct scsi_target *starget);
+extern void scsi_target_clear_eh(struct scsi_target *starget);
 
 static inline bool scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
 {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 9cc34bfff3f7..cac661cd9b5b 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -265,6 +265,19 @@ struct scsi_host_template {
 	 */
 	void (* target_destroy)(struct scsi_target *);
 
+	/*
+	 * Setup or clear error handler field scsi_target.eh.
+	 * This error handler is working on designated target, it will only
+	 * operate the designated target, do not affect other targets.
+	 * If not set, error handle will fallback.
+	 * LLDD can use custom error handler, or use inner defined:
+	 *   scsi_target_setup_eh/scsi_target_clear_eh
+	 *
+	 * Status: OPTIONAL
+	 */
+	int (*target_setup_eh)(struct scsi_target *starget);
+	void (*target_clear_eh)(struct scsi_target *starget);
+
 	/*
 	 * If a host has the ability to discover targets on its own instead
 	 * of scanning the entire bus, it can fill in this function and
@@ -483,6 +496,8 @@ struct scsi_host_template {
 
 	/* The error handle of scsi_device will fallback when failed. */
 	unsigned sdev_eh_fallback:1;
+	/* The error handle of scsi_target will fallback when failed. */
+	unsigned target_eh_fallback:1;
 
 	/*
 	 * Countdown for host blocking with no commands outstanding.
-- 
2.33.0

