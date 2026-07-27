Received: from spam.asrmicro.com (asrmicro.com [210.13.118.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9643542F6;
	Mon, 27 Jul 2026 05:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.13.118.86
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785131810; cv=none; b=X23zb4430KJIAQPkzoBF3aWLwM3OEaFJiQKS8BiPH1amZB2fVk5ZY9pmwmEKqxDJNENoMKuMjjnTwlATyP6qvlu4FAGrj9n4zgOHlslBlFE8JwAeA1Sv1N30XvNeHJ2fWANm7wE5bFGv3gx7SwwkmMsAdBtF27EcdKP6RmgT+JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785131810; c=relaxed/simple;
	bh=eWqjJ6vKGhigSplWbBoZH6Gn6KG4CblorKSXW6fTfO4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uv6gbxstYh/giVz9StR8Me358+6Pg7lEi58Z1N5EIqETiGfYf/wHANLR0+L6Zy6bKNijeT9MXn5nLc6JYfzuu0OcBNyMwO+bIIIaWCWLohMT63Xy/oW+UDC2xvcJLbnMYzhRp851ogbGIH9G13/i+xCQYYxKX0im6zVH4WEYgC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com; spf=pass smtp.mailfrom=asrmicro.com; arc=none smtp.client-ip=210.13.118.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=asrmicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asrmicro.com
Received: from exch02.asrmicro.com (exch02.asrmicro.com [10.1.24.122])
	by spam.asrmicro.com with ESMTPS id 66R5uCbG027034
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 13:56:12 +0800 (GMT-8)
	(envelope-from hongjiefang@asrmicro.com)
Received: from localhost (10.1.170.248) by exch02.asrmicro.com (10.1.24.122)
 with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 27 Jul 2026 13:56:15
 +0800
From: Hongjie Fang <hongjiefang@asrmicro.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <jgarzik@redhat.com>, <stern@rowland.harvard.edu>,
        <bvanassche@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] scsi: core: pair EH runtime PM get and put
Date: Mon, 27 Jul 2026 13:56:15 +0800
Message-ID: <20260727055615.2287217-1-hongjiefang@asrmicro.com>
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
X-MAIL:spam.asrmicro.com 66R5uCbG027034

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

Fix this by snapshotting shost->eh_noresume once per EH iteration and
using that snapshot for both runtime PM get and put decisions.

Fixes: ae0751ffc77e ("[SCSI] add flag to skip the runtime PM calls on the host")
Signed-off-by: Hongjie Fang <hongjiefang@asrmicro.com>
---
 drivers/scsi/scsi_error.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..a216f56044d9 100644
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
+		eh_noresume = shost->eh_noresume;
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
-- 
2.25.1

