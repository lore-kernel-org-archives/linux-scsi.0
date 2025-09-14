Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE76245014;
	Sun, 14 Sep 2025 10:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757844691; cv=none; b=Evz1E/6DMxe8SdiAWQdOynamtxe8s3XBVGTlfTeYKynE3BXB5S4fhdVsd5Y38a31jHpPE3pE4vsInzKDtyOynA2D6iNrm6Ci9Nh0fUiAHDe0XpPNxvTf/8EfoizZRrIcMgJgNyejm+1xnQQ8qgxfC2JHs4DPW6TOHEj/Sn8FcvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757844691; c=relaxed/simple;
	bh=hRKhAeq9hGdXXPUYg7nH8gwzAO+Il/3zJ4PB9RB80aE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FPr3A51EwucSiyWFkaGQaPo8KMbc/gLBqbWKi5dKnqFFC7+aYueP1eVp7nDRof+8kSOLfn+c+/05uMR5hsbRbu5Zn8Ei65VmKwb7izv8SDfkOYKuMJ02Xl1e/Fl1JgUmmSzA/J2SkcvHr2o3PlGnDUV5Kg8x1J5025a5FiFMRME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cPkNf15nBz13N7W;
	Sun, 14 Sep 2025 18:07:14 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id BF8561401F4;
	Sun, 14 Sep 2025 18:11:19 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 14 Sep 2025 18:11:18 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <dlemoal@kernel.org>,
	<hewenliang4@huawei.com>, <yangyun50@huawei.com>, <wuyifeng10@huawei.com>,
	<yangxingui@h-partners.com>
Subject: [RFC PATCH v4 6/9] scsi: scsi_error: Add flags to mark error handle steps has done
Date: Sun, 14 Sep 2025 18:41:42 +0800
Message-ID: <20250914104145.2239901-7-jiangjianjun3@huawei.com>
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

LUN based error handle would mainly do three steps to recover
commands which are check sense, start unit, and reset lun. It might
fallback to host based error handler which would do these steps
too.

Add some flags to mark these steps are done to avoid repeating
these steps.

The flags should be cleared when LUN based error handler is waked up
or when host based error handler finished, and set when fallback to
host based error handle.

scsi_eh_get_sense, scsi_eh_stu, scsi_eh_bus_device_reset would check
these flags before actually action.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Co-developed-by: JiangJianJun <jiangjianjun3@huawei.com>
Signed-off-by: JiangJianJun <jiangjianjun3@huawei.com>
---
 drivers/scsi/scsi_error.c  | 33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h | 18 ++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f58aad351463..239f8231c3ff 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -57,10 +57,36 @@
 #define BUS_RESET_SETTLE_TIME   (10)
 #define HOST_RESET_SETTLE_TIME  (10)
 
+#define sdev_flags_done(flag)					\
+static inline int sdev_##flag(struct scsi_device *sdev)		\
+{								\
+	struct scsi_device_eh *eh = sdev->eh;			\
+	if (!eh)						\
+		return 0;					\
+	return eh->flag;					\
+}
+
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
 static enum scsi_disposition scsi_try_to_abort_cmd(const struct scsi_host_template *,
 						   struct scsi_cmnd *);
 
+sdev_flags_done(get_sense_done);
+sdev_flags_done(stu_done);
+sdev_flags_done(reset_done);
+
+static inline void shost_clear_eh_done(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost) {
+		if (!sdev->eh)
+			continue;
+		sdev->eh->get_sense_done = 0;
+		sdev->eh->stu_done	 = 0;
+		sdev->eh->reset_done	 = 0;
+	}
+}
+
 void scsi_eh_wakeup(struct Scsi_Host *shost, unsigned int busy)
 {
 	lockdep_assert_held(shost->host_lock);
@@ -1397,6 +1423,8 @@ int scsi_eh_get_sense(struct list_head *work_q,
 					     current->comm));
 			break;
 		}
+		if (sdev_get_sense_done(scmd->device))
+			continue;
 		if (!scsi_status_is_check_condition(scmd->result))
 			/*
 			 * don't request sense if there's no check condition
@@ -1610,6 +1638,8 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			scsi_device_put(sdev);
 			break;
 		}
+		if (sdev_stu_done(sdev))
+			continue;
 		stu_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
@@ -1693,6 +1723,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				bdr_scmd = scmd;
 				break;
 			}
+		if (sdev_reset_done(sdev))
+			continue;
 
 		if (!bdr_scmd)
 			continue;
@@ -2357,6 +2389,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 	if (!scsi_eh_get_sense(&eh_work_q, &eh_done_q))
 		scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
 
+	shost_clear_eh_done(shost);
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->eh_deadline != -1)
 		shost->last_reset = 0;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9d42858035ed..9fc052e48a3b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -103,6 +103,24 @@ struct scsi_vpd {
 struct scsi_device;
 
 struct scsi_device_eh {
+	/*
+	 * LUN rebased error handle would mainly do three
+	 * steps to recovery commands which are
+	 *   check sense
+	 *   start unit
+	 *   reset lun
+	 * While we would fallback to host based error handler which would
+	 * do these steps too. Add flags to mark thes steps are done to
+	 * avoid repeating these steps.
+	 *
+	 * The flags should be cleared when LUN based error handler is
+	 * wakedup or when host based error handler finished, set when
+	 * fallback to host based error handle.
+	 */
+	unsigned get_sense_done:1;
+	unsigned stu_done:1;
+	unsigned reset_done:1;
+
 	/*
 	 * add scsi command to error handler so it would be handuled by
 	 * driver's error handle strategy
-- 
2.33.0

