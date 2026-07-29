Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A20E47141F;
	Wed, 29 Jul 2026 11:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785323809; cv=none; b=gWrjMsXxOSX9+PoalnCOso177X/2BYHq8l9CNWVD5viYAbnpiLsEg++scjga3uv7YbV4xDZBGulunFQRWihD6aAGza0yay5KbWCm+kXc0+MLyPm+XIsGXkc0Y/i8Y1cS/towC+OshruOA20ddRtv2HhrAe0uHERzjlhwvBW5ZLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785323809; c=relaxed/simple;
	bh=jn18Jl58KzSrNmR8IKTGDLJrTCyPCBd20J6IWrRz1AU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XlB/bLUMam4xoMMinizJJEawyR5HG9pZYYbdH+rapzhJFvtlKiYljqMyl6od3bB2D1w9vDYJGtlZF5yQBVVDSMtaiU07qk6rsYc1EEYezCrLr4dCGyaTyVCg08KTEpNq4k2Mt3zEzsoAR6ynzdHo6wePOkVuzVxngeAurplGzuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 66TBG9W5041773
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=FAIL);
	Wed, 29 Jul 2026 19:16:09 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 29 Jul 2026 19:16:14
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <stern@rowland.harvard.edu>,
        <peter.wang@mediatek.com>, <bvanassche@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] scsi: core: pair EH runtime PM get and put
Date: Wed, 29 Jul 2026 19:16:14 +0800
Message-ID: <20260729111614.2407559-1-hongjiefang@asrmicro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: sh-exch01.asrmicro.com (10.1.24.97) To exch02.asrmicro.com
 (10.1.24.122)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 66TBG9W5041773

shost->eh_noresume is currently consulted twice in one error handling
iteration: once before scsi_autopm_get_host() and once again before
scsi_autopm_put_host().

That is racy when a PM-triggered error path flips shost->eh_noresume while
the SCSI EH thread is still running.

The problem flow looks like this:
PM path
  ufshcd_set_dev_pwr_mode()
    shost->eh_noresume = 1
    ufshcd_execute_start_stop  <-- trigger EH
    ...
    shost->eh_noresume = 0

EH path
  scsi_error_handler()
    if (!shost->eh_noresume)
      scsi_autopm_get_host()  <-- skipped
    ...
    if (!shost->eh_noresume)
       scsi_autopm_put_host()  <-- executed later

In that case one EH iteration can skip autoresume on entry and still drop
a runtime PM reference on exit. That leaves an unmatched runtime PM put
and can trigger a runtime PM usage count underflow.

Fix this by making eh_noresume a regular bool so it can be accessed with
READ_ONCE() and WRITE_ONCE(). Snapshot it once per EH iteration and use
that snapshot for both runtime PM get and put decisions.

Fixes: ae0751ffc77e ("[SCSI] add flag to skip the runtime PM calls on the host")
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
---

v3:
- Use READ_ONCE() and WRITE_ONCE() for eh_noresume.
- Make eh_noresume a regular bool since READ_ONCE() cannot be used on
  bitfields.

v2:
- Snapshot the shost->eh_noresume once per EH iteration.

 drivers/scsi/scsi_error.c | 6 ++++--
 drivers/ufs/core/ufshcd.c | 4 ++--
 include/scsi/scsi_host.h  | 6 +++---
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..72515fa6daf7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2342,6 +2342,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
+	bool eh_noresume;
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -2383,7 +2384,8 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
+		eh_noresume = READ_ONCE(shost->eh_noresume);
+		if (!eh_noresume && scsi_autopm_get_host(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				shost_printk(KERN_ERR, shost,
 					     "scsi_eh_%d: unable to autoresume\n",
@@ -2407,7 +2409,7 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		if (!shost->eh_noresume)
+		if (!eh_noresume)
 			scsi_autopm_put_host(shost);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c3f08957d179..9e2ae37340c9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9995,7 +9995,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * we are functional while we are here, skip host resume in error
 	 * handling context.
 	 */
-	hba->host->eh_noresume = 1;
+	WRITE_ONCE(hba->host->eh_noresume, 1);
 
 	/*
 	 * Current function would be generally called from the power management
@@ -10017,7 +10017,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	}
 
 	scsi_device_put(sdp);
-	hba->host->eh_noresume = 0;
+	WRITE_ONCE(hba->host->eh_noresume, 0);
 	return ret;
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7e2011830ba4..857f955f08cf 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -664,6 +664,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	bool async_scan __guarded_by(&scan_mutex);
 
+	/* Don't resume host in EH */
+	bool eh_noresume;
+
 	unsigned active_mode:2;
 
 	/*
@@ -682,9 +685,6 @@ struct Scsi_Host {
 	/* Task mgmt function in progress */
 	unsigned tmf_in_progress:1;
 
-	/* Don't resume host in EH */
-	unsigned eh_noresume:1;
-
 	/* The controller does not support WRITE SAME */
 	unsigned no_write_same:1;
 
-- 
2.25.1

