Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599E62E3382;
	Fri, 14 Mar 2025 01:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914619; cv=none; b=DX1IJjJUfHqaT0o3+VPPzidP6u/BEYjv0VhoQYzBB5+P7QIVQhF2eaaOT4wFjrAzOl11N9N77w5Qy9W4Hjr/BVYF5pSVmDEBTiTdyafkhe16C9zPiBxs5BPPL2Mej/Zc+V62mSvwfEPd+FtsS6A+tFSUWEY3V8kmTCdE4uyt1Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914619; c=relaxed/simple;
	bh=XTXliUfYEwLhbUuqtXXlqZhKqQNWomihSNae6xtoezk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j5iJC/6HuqiqExS7hDyiFwjYw9OlyYWrbMOTtb8GsN4rFyosNLaE4z/gqSrfU/uOoFfjOFALLsnPGoxBYnuzHSzetn8brpuz66yoiQaqCfUejlayc3cDDRWo56lFaFv6Nosx1oewSaB+/UH0CPI9omrKU23Feb1j6po5cXfCpv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZDR812Rglz1R6jr;
	Fri, 14 Mar 2025 09:08:33 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 37FEE1A0188;
	Fri, 14 Mar 2025 09:10:15 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:14 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 06/19] scsi: scsi_error: Add flags to mark error handle steps has done
Date: Fri, 14 Mar 2025 09:29:14 +0800
Message-ID: <20250314012927.150860-7-jiangjianjun3@huawei.com>
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

LUN based error handle would mainly do three steps to recover
commands which are check sense, start unit, and reset lun. It might
fallback to target/host based error handle which would do these steps
too.

Target based error handle would reset target, it would also fallback
to host based error handle.

Add some flags to mark these steps are done to avoid repeating
these steps.

The flags should be cleared when LUN/target based error handler is
waked up or when target/host based error handle finished, and set
when fallback to target/host based error handle.

scsi_eh_get_sense, scsi_eh_stu, scsi_eh_bus_device_reset and
scsi_eh_target_reset would check these flags before actually action.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c  | 55 ++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h | 28 +++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 80e5787055d3..628ecbfcfff2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -57,10 +57,50 @@
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
+static inline int starget_reset_done(struct scsi_target *starget)
+{
+	struct scsi_target_eh *eh = starget->eh;
+
+	if (!eh)
+		return 0;
+	return eh->reset_done;
+}
+
+static inline void shost_clear_eh_done(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	struct scsi_target *starget;
+
+	list_for_each_entry(starget, &shost->__targets, siblings)
+		if (starget->eh)
+			starget->eh->reset_done = 0;
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
@@ -1405,6 +1445,9 @@ int scsi_eh_get_sense(struct list_head *work_q,
 					     current->comm));
 			break;
 		}
+		if (sdev_get_sense_done(scmd->device) ||
+		    starget_reset_done(scsi_target(scmd->device)))
+			continue;
 		if (!scsi_status_is_check_condition(scmd->result))
 			/*
 			 * don't request sense if there's no check condition
@@ -1618,6 +1661,9 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			scsi_device_put(sdev);
 			break;
 		}
+		if (sdev_stu_done(sdev) ||
+		    starget_reset_done(scsi_target(sdev)))
+			continue;
 		stu_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
@@ -1701,6 +1747,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 				bdr_scmd = scmd;
 				break;
 			}
+		if (sdev_reset_done(sdev) ||
+		    starget_reset_done(scsi_target(sdev)))
+			continue;
 
 		if (!bdr_scmd)
 			continue;
@@ -1749,6 +1798,11 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		}
 
 		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
+		if (starget_reset_done(scsi_target(scmd->device))) {
+			/* push back on work queue for further processing */
+			list_move(&scmd->eh_entry, work_q);
+			continue;
+		}
 		id = scmd_id(scmd);
 
 		SCSI_LOG_ERROR_RECOVERY(3,
@@ -2365,6 +2419,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 	if (!scsi_eh_get_sense(&eh_work_q, &eh_done_q))
 		scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
 
+	shost_clear_eh_done(shost);
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (shost->eh_deadline != -1)
 		shost->last_reset = 0;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6388abb6c0d4..5cc18ca69fc7 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -104,6 +104,24 @@ struct scsi_device;
 struct scsi_target;
 
 struct scsi_device_eh {
+	/*
+	 * LUN rebased error handle would mainly do three
+	 * steps to recovery commands which are
+	 *   check sense
+	 *   start unit
+	 *   reset lun
+	 * While we would fallback to target or host based error handle
+	 * which would do these steps too. Add flags to mark thes steps
+	 * are done to avoid repeating these steps.
+	 *
+	 * The flags should be cleared when LUN based error handler is
+	 * wakedup or when target/host based error handle finished,
+	 * set when fallback to target or host based error handle.
+	 */
+	unsigned get_sense_done:1;
+	unsigned stu_done:1;
+	unsigned reset_done:1;
+
 	/*
 	 * add scsi command to error handler so it would be handuled by
 	 * driver's error handle strategy
@@ -135,6 +153,16 @@ struct scsi_device_eh {
 };
 
 struct scsi_target_eh {
+	/*
+	 * flag to mark target reset is done to avoid repeating
+	 * these steps when fallback to host based error handle
+	 *
+	 * The flag should be cleared when target based error handler
+	 * is * wakedup or when host based error handle finished,
+	 * set when fallback to host based error handle.
+	 */
+	unsigned reset_done:1;
+
 	/*
 	 * add scsi command to error handler so it would be handuled by
 	 * driver's error handle strategy
-- 
2.33.0

