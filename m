Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0278032861F;
	Wed, 10 Jun 2026 11:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781091301; cv=none; b=U3Jpi9HfydPVmR1CiIujxihC09ahrtUTZRFegL1mwXwl2/hlLGOhrBcmTeeDVpL4ZwXmHA1b0SZ9TSWcvWyvNo3B+aPj+zIWrOat4/otdwi1vqScqkaRfFE1bhZV24kGR5pLQWjWqHH9yOcdEK18VxzamdCzegI0zh2pdgYOf04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781091301; c=relaxed/simple;
	bh=FRfwH3MIKqmKPNdllLLIaxCN3KeQ27UpXSQdkzfsalA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ehMfHu59Gjm5/6G39Ap6KbNt/TutPs88xiVmmD2piIONc0bG4kcoHZdrwAYYdkMLUq3tDPad2NPPYK6th9x9nen+rC/AZInks69+w7JnhHl7ptRs4VnDxPQhMdRMsVoUNT3N2bahfOfsoMx1wDsq5F7pPRDjmGtmiFvW16iIKpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 65ABXfmv066567
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=FAIL);
	Wed, 10 Jun 2026 19:33:41 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.847.32; Wed, 10 Jun 2026 19:33:45
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <jgarzik@redhat.com>, <stern@rowland.harvard.edu>,
        <bvanassche@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] scsi: core: pair EH runtime PM get/put
Date: Wed, 10 Jun 2026 19:33:33 +0800
Message-ID: <20260610113333.632859-1-hongjiefang@asrmicro.com>
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
X-MAIL:spam.asrmicro.com 65ABXfmv066567

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

