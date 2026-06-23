Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B1B36A342;
	Tue, 23 Jun 2026 07:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782201310; cv=none; b=BZMcfj9VExYkRIKttOIDk1eEDtQtUg4FoO9vSyGTKLj1cK5qxjQYCjXlje/hNMFp6IoOpkB97T5CBPHl1D7COHw+P8pNEb/lxJFwG7g4sG/SDFNV+rZYNF2u26jKomyBGuBopSh4EkjiXFDk81UYA4BSvhvabIYVh3fpjDb6OoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782201310; c=relaxed/simple;
	bh=FRfwH3MIKqmKPNdllLLIaxCN3KeQ27UpXSQdkzfsalA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UDnPBlvT/o0UOOkYVpS/uBdk3EEGebkTJUvH6aO8lFAI6d+7Ug+Wzr5R6hbq9ZV0xegdlIfjWFCMfAX+JvDJtYMrEckBczOYLrpynqoKfOvSCdNA5On7meouN4KlwC5QBG+zv3Aeo5n4QMMgYAY+4oP4+eSQU0f74DrAreNEjyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from spam.asrmicro.com (localhost [127.0.0.2] (may be forged))
	by spam.asrmicro.com with ESMTP id 65N7iwf4071682;
	Tue, 23 Jun 2026 15:44:58 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 65N7i6XV071536
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Tue, 23 Jun 2026 15:44:06 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Tue, 23 Jun 2026 15:44:09
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <jgarzik@redhat.com>, <stern@rowland.harvard.edu>,
        <bvanassche@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1] scsi: core: pair EH runtime PM get and put
Date: Tue, 23 Jun 2026 15:44:08 +0800
Message-ID: <20260623074408.1639663-1-hongjiefang@asrmicro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: exch02.asrmicro.com (10.1.24.122) To exch02.asrmicro.com
 (10.1.24.122)
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:spam.asrmicro.com 65N7iwf4071682

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

Fix this by calling scsi_autopm_put_host() only if the same iteration
successfully acquired a runtime PM reference through the
scsi_autopm_get_host().

Fixes: ae0751ffc77e ("[SCSI] add flag to skip the runtime PM calls on the host")
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
---
 drivers/scsi/scsi_error.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..c78ea64641a9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2342,6 +2342,7 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
+	bool autopm_put;
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
@@ -2383,12 +2384,16 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
-			SCSI_LOG_ERROR_RECOVERY(1,
-				shost_printk(KERN_ERR, shost,
-					     "scsi_eh_%d: unable to autoresume\n",
-					     shost->host_no));
-			continue;
+		autopm_put = false;
+		if (!shost->eh_noresume) {
+			if (scsi_autopm_get_host(shost) != 0) {
+				SCSI_LOG_ERROR_RECOVERY(1,
+					shost_printk(KERN_ERR, shost,
+						     "scsi_eh_%d: unable to autoresume\n",
+						     shost->host_no));
+				continue;
+			}
+			autopm_put = true;
 		}
 
 		if (shost->transportt->eh_strategy_handler)
@@ -2407,7 +2412,7 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		if (!shost->eh_noresume)
+		if (autopm_put)
 			scsi_autopm_put_host(shost);
 	}
 	__set_current_state(TASK_RUNNING);
-- 
2.25.1

