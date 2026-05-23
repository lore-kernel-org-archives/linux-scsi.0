Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA49B1A5B8A;
	Sat, 23 May 2026 03:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779508214; cv=none; b=EbAdFwEkTyUmmQQRBjEUFk8v70pCfcAabIjvVAjEITVP1z6La1eRZnbes7nKxI+Cycy+TKjyn7gnkR+u0sqaliGUTPFOiR/bG0pxS6bLZCf906FU+DwkOgNJ0Z1vxM+0pJZmZ1jgOQqOkB+M7AfqJj1f0r46M2bPiEawYGipz2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779508214; c=relaxed/simple;
	bh=3xCIOI9WGTCBuuuNakDbvbddzXD2Tcz0KmJq6wMOI3c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=AOATASuOFMItLyy6J5veMW/4T7PQVTMJE31V4EwXFwFOX1TzrOGfGMRG6kvD3YHEq3dkBjZLiBGE4O3wEk4iwtLcEYoqia7PgOQiSYLFjRj78JSxzIpjKVCzfGgd5wx4LNpQr0/EA6gVBpmtnrI9NrieWgdKaivzlyUfpNpBXXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from spam.asrmicro.com (localhost [127.0.0.2] (may be forged))
	by spam.asrmicro.com with ESMTP id 64N3eI1K091925;
	Sat, 23 May 2026 11:40:18 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 64N3YaJJ091231
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Sat, 23 May 2026 11:34:36 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Sat, 23 May 2026 11:34:38
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <jgarzik@redhat.com>, <stern@rowland.harvard.edu>,
        <ming.m.lin@intel.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: core: pair EH runtime PM get/put with eh_noresume snapshot
Date: Sat, 23 May 2026 11:34:38 +0800
Message-ID: <20260523033438.3547549-1-hongjiefang@asrmicro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch03.asrmicro.com (10.1.24.118) To exch02.asrmicro.com
 (10.1.24.122)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 64N3eI1K091925

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

In that case one EH iteration can skip autoresume on entry and still drop a
runtime PM reference on exit. That leaves an unmatched runtime PM put and
can trigger a runtime PM usage count underflow.

Fix this by snapshotting shost->eh_noresume once at the beginning of each
EH iteration and by calling scsi_autopm_put_host() only if the same
iteration successfully acquired a runtime PM reference through the
scsi_autopm_get_host().

Fixes: ae0751ffc77e ("[SCSI] add flag to skip the runtime PM calls on the host")
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
---
 drivers/scsi/scsi_error.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..d83bfa24f184 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2342,6 +2342,8 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
+	bool autopm_get;
+	bool skip_autopm;
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -2383,12 +2385,17 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
-			SCSI_LOG_ERROR_RECOVERY(1,
-				shost_printk(KERN_ERR, shost,
-					     "scsi_eh_%d: unable to autoresume\n",
-					     shost->host_no));
-			continue;
+		autopm_get = false;
+		skip_autopm = shost->eh_noresume;
+		if (!skip_autopm) {
+			if (scsi_autopm_get_host(shost) != 0) {
+				SCSI_LOG_ERROR_RECOVERY(1,
+					shost_printk(KERN_ERR, shost,
+						     "scsi_eh_%d: unable to autoresume\n",
+						     shost->host_no));
+				continue;
+			}
+			autopm_get = true;
 		}
 
 		if (shost->transportt->eh_strategy_handler)
@@ -2407,7 +2414,7 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		if (!shost->eh_noresume)
+		if (autopm_get)
 			scsi_autopm_put_host(shost);
 	}
 	__set_current_state(TASK_RUNNING);
-- 
2.25.1

