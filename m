Received: from out30-84.freemail.mail.aliyun.com (out30-84.freemail.mail.aliyun.com [115.124.30.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2292609FD;
	Thu,  5 Mar 2026 02:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772679110; cv=none; b=SORwvLk+SCYxxgt8v37B98OW0XAVkaqkmcWyWUV1szi6XKbcXq/KXnjqX5NzNy7ejCm/U1q0vlvFEFBvXCIzb05U6nVgIybgBZgj2Yzg/wAluN2DYvnS78GOq9jq1CwE10bUbp1w6bVZIe5xWSZsVGyujR45ALhPMnyyXXASv4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772679110; c=relaxed/simple;
	bh=6MY7SK+A/RM4vre6tMqWc6MPN1forPz0kmeLNJ7x3bc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PNPE20oW/PxmLotPHxn1kx7AftPOd3OXKtWbCT0wjcbxYVqQfDMcr+lzkCveGuaE9XOnwfCQ0/D8QeSNFX0tjR9uTiq3WK6/WSOIvk5xa/uXAhUlTopR6EU31ginE0ubIu3sX0Csj/hQ9ZqG+T21cfJcIoOkUp0jB/9bsD4zYRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=NMMI6pXh; arc=none smtp.client-ip=115.124.30.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="NMMI6pXh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1772679107; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jEo2bpxFm1pgRWe76+u7bmuFKcrbwWR/pT8k+SYlNsE=;
	b=NMMI6pXhkVo7sXKi4ZeGGhVI7pbKxaAxZlx/q1HikCwcYUhNDmL5hOBQ5YBP6SI17FiJ9aCoiHpjbhqqIvCCdXM9FqSiEAR7T5IXyHM9Tq0oNyAJ04+C+Ho8u+IpcmJakYeXUt68C7Hqz4Rh6GKyb5HMhsLwKzdCF7a3bDLqfjM=
Received: from localhost.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0X-GlC9g_1772679101 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 05 Mar 2026 10:51:46 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	dlemoal@kernel.org,
	bvanassche@acm.org,
	hch@infradead.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chaohai Chen <wdhh6@aliyun.com>
Subject: [PATCH v5] scsi: core: Drop using the host_lock to protect async_scan race condition
Date: Thu,  5 Mar 2026 10:51:24 +0800
Message-ID: <20260305025125.3649517-1-wdhh6@aliyun.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, host_lock was used to prevent bit-set conflicts in async_scan,
but this approach introduced naked reads in some code paths.

Convert async_scan from a bitfield to a bool type to eliminate bit-level
conflicts entirely. Use __guarded_by(&scan_mutex) to indicate that the
async_scan variable is protected by scan_mutex.

Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
---
 drivers/scsi/scsi_scan.c | 10 ++--------
 include/scsi/scsi_host.h |  7 ++++---
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 60c06fa4ec32..efcaf85ff699 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1943,7 +1943,6 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 {
 	struct async_scan_data *data = NULL;
-	unsigned long flags;
 
 	if (strncmp(scsi_scan_type, "sync", 4) == 0)
 		return NULL;
@@ -1962,9 +1961,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		goto err;
 	init_completion(&data->prev_finished);
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->async_scan = 1;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	shost->async_scan = true;
 	mutex_unlock(&shost->scan_mutex);
 
 	spin_lock(&async_scan_lock);
@@ -1992,7 +1989,6 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 static void scsi_finish_async_scan(struct async_scan_data *data)
 {
 	struct Scsi_Host *shost;
-	unsigned long flags;
 
 	if (!data)
 		return;
@@ -2012,9 +2008,7 @@ static void scsi_finish_async_scan(struct async_scan_data *data)
 
 	scsi_sysfs_add_devices(shost);
 
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->async_scan = 0;
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	shost->async_scan = false;
 
 	mutex_unlock(&shost->scan_mutex);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f6e12565a81d..7e2011830ba4 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -660,6 +660,10 @@ struct Scsi_Host {
 	 */
 	unsigned nr_hw_queues;
 	unsigned nr_maps;
+
+	/* Asynchronous scan in progress */
+	bool async_scan __guarded_by(&scan_mutex);
+
 	unsigned active_mode:2;
 
 	/*
@@ -678,9 +682,6 @@ struct Scsi_Host {
 	/* Task mgmt function in progress */
 	unsigned tmf_in_progress:1;
 
-	/* Asynchronous scan in progress */
-	unsigned async_scan:1;
-
 	/* Don't resume host in EH */
 	unsigned eh_noresume:1;
 
-- 
2.43.7

