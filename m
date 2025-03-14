Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CC715573F;
	Fri, 14 Mar 2025 01:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914626; cv=none; b=tuuI2i8ZjwAwd6wc0XCdy/Zi/tGsyygPzb+rGXr/skWNu4kVWafn7AsSPxP1b4MZ8vlED8ld2V7CZ/1c9z8Lwy9c7y+BStqH4/DgAklGcORwwUA+G1FYkp+u1W/m440JWpveMpjU4wBJR3KWvQ4I4ad0anxi2qGBQ8J5mk3XU1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914626; c=relaxed/simple;
	bh=d9ajH5E4b3zFqyrtsSlhkb6bpRYiRJD79v2eaonvz/w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S1SmTlow6D5epJbwh8bb5IZcaseiQjoCXSPtra82h6csZvU9Ly0rPW2KWZU3dLX50OWGrmEpi+Rbh6XXLfO2UeBgxXDRU0vtG8m2rcG+LAFyUtsHVTKGbgc3Wsh0LbUr/QNxuTc/ohnoCO1oHCu5FxtIRwtODYcDM0uKmEL0XyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZDR5X6JHYzvWpq;
	Fri, 14 Mar 2025 09:06:24 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 363B7180102;
	Fri, 14 Mar 2025 09:10:16 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:15 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 08/19] scsi: scsi_error: Add a general LUN based error handler
Date: Fri, 14 Mar 2025 09:29:16 +0800
Message-ID: <20250314012927.150860-9-jiangjianjun3@huawei.com>
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

Add a general LUN based error handler which can be used by drivers
directly. This error handler implements an scsi_device_eh, when handling
error commands, it would call helper function scsi_sdev_eh() added before
to try recover error commands.

The behavior if scsi_sdev_eh() can not recover all error commands
depends on fallback flag, which is initialized when scsi_device is
allocated. If fallback is set, it would fallback to further error
recover strategy like old host based error handle; else it would
mark this scsi device offline and flush all error commands.

To using this error handler, drivers should call scsi_device_setup_eh()
in its slave_alloc() to setup it's LUN based error handler;
call scsi_device_clear_eh() in its slave_destroy() to clear LUN based
error handler.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c | 170 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |   2 +
 2 files changed, 172 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 21f72c075531..7302536ba62a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2766,3 +2766,173 @@ bool scsi_get_sense_info_fld(const u8 *sense_buffer, int sb_len,
 	}
 }
 EXPORT_SYMBOL(scsi_get_sense_info_fld);
+
+struct scsi_lun_eh {
+	spinlock_t		eh_lock;
+	unsigned int		eh_num;
+	struct list_head	eh_cmd_q;
+	struct scsi_device	*sdev;
+	struct work_struct	eh_handle_work;
+	unsigned int		fallback:1;	/* If fallback to further */
+						/* recovery on failure  */
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
+		sdev_printk(KERN_INFO, sdev, "%s:luneh: Device offlined - "
+			    "not ready after error recovery\n", current->comm);
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
+		    __scsi_eh_scmd_add_starget(scmd))
+			__scsi_eh_scmd_add(scmd);
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
+	luneh = (struct scsi_lun_eh *)sdev->eh->driver_data;
+
+	spin_lock_irqsave(&luneh->eh_lock, flags);
+	list_add_tail(&scmd->eh_entry, &luneh->eh_cmd_q);
+	luneh->eh_num++;
+	spin_unlock_irqrestore(&luneh->eh_lock, flags);
+}
+static int sdev_eh_is_busy(struct scsi_device *sdev)
+{
+	int ret = 0;
+	unsigned long flags;
+	struct scsi_lun_eh *luneh;
+
+	if (!sdev->eh)
+		return 0;
+
+	luneh = (struct scsi_lun_eh *)sdev->eh->driver_data;
+
+	spin_lock_irqsave(&luneh->eh_lock, flags);
+	ret = luneh->eh_num;
+	spin_unlock_irqrestore(&luneh->eh_lock, flags);
+
+	return ret;
+}
+static int sdev_eh_wakeup(struct scsi_device *sdev)
+{
+	unsigned long flags;
+	unsigned int nr_error;
+	unsigned int nr_busy;
+	struct scsi_lun_eh *luneh;
+
+	luneh = (struct scsi_lun_eh *)sdev->eh->driver_data;
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
+		return 0;
+	}
+
+	SCSI_LOG_ERROR_RECOVERY(2, sdev_printk(KERN_INFO, sdev,
+		"%s:luneh: waking up, busy/error: %d/%d\n",
+		current->comm, nr_busy, nr_error));
+
+	return schedule_work(&luneh->eh_handle_work);
+}
+
+int scsi_device_setup_eh(struct scsi_device *sdev, int fallback)
+{
+	struct scsi_device_eh *eh;
+	struct scsi_lun_eh *luneh;
+
+	eh = kzalloc(sizeof(struct scsi_device_eh) + sizeof(struct scsi_lun_eh),
+		GFP_KERNEL);
+	if (!eh) {
+		sdev_printk(KERN_ERR, sdev, "failed to setup error handle\n");
+		return -ENOMEM;
+	}
+	luneh = (struct scsi_lun_eh *)eh->driver_data;
+
+	eh->add_cmnd = sdev_eh_add_cmnd;
+	eh->is_busy  = sdev_eh_is_busy;
+	eh->wakeup   = sdev_eh_wakeup;
+
+	luneh->fallback = fallback;
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
+void scsi_device_clear_eh(struct scsi_device *sdev)
+{
+	kfree(sdev->eh);
+	sdev->eh = NULL;
+}
+EXPORT_SYMBOL_GPL(scsi_device_clear_eh);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 5ce791063baf..89b471aa484f 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -20,6 +20,8 @@ extern bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 extern enum scsi_disposition scsi_check_sense(struct scsi_cmnd *);
 extern int scsi_sdev_eh(struct scsi_device *sdev, struct list_head *workq,
 			struct list_head *doneq);
+extern int scsi_device_setup_eh(struct scsi_device *sdev, int fallback);
+extern void scsi_device_clear_eh(struct scsi_device *sdev);
 
 static inline bool scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
 {
-- 
2.33.0

