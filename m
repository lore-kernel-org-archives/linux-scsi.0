From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 07/19] lpfc: Fix IO failure during hba reset testing with nvme io.
Date: Tue, 30 Jan 2018 15:58:51 -0800
Message-ID: <20180130235903.5316-8-jsmart2021@gmail.com>
References: <20180130235903.5316-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36485 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753556AbeA3X7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2018 18:59:23 -0500
Received: by mail-qt0-f196.google.com with SMTP id z11so19667747qtm.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2018 15:59:23 -0800 (PST)
In-Reply-To: <20180130235903.5316-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

A stress test repeatedly resetting the adapter while performing
io would eventually report I/O failures and missing nvme namespaces.

The driver was setting the nvmefc_fcp_req->private pointer to NULL
during the IO completion routine before upcalling done().
If the transport was also running an abort for that IO, the driver
would fail the abort with message 6140. Failing the abort is not
allowed by the nvme-fc transport, as it mandates that the io must be
returned back to the transport. As that does not happen, the transport
controller delete has an outstanding reference and can't complete
teardown.

The NULL-ing of the private pointer should be done only when the io
is considered complete. It's complete when the adapter returns the
exchange with the "exchange busy" flag clear.

Move the NULL'ing of the structure to the done case. This leaves the
io contexts set while it is busy and until the subsequent XRI_ABORTED
completion which returns the exchange is received.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v3:
  Address review comment that preferred to continue to NULL if the
  io did complete in order to protect stale conditions. After review,
  we agreed, thus the above change.
---
 drivers/scsi/lpfc/lpfc_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 81e3a4f10c3c..c6e5b9972585 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -980,14 +980,14 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			phba->cpucheck_cmpl_io[lpfc_ncmd->cpu]++;
 	}
 #endif
-	freqpriv = nCmd->private;
-	freqpriv->nvme_buf = NULL;
 
 	/* NVME targets need completion held off until the abort exchange
 	 * completes unless the NVME Rport is getting unregistered.
 	 */
 
 	if (!(lpfc_ncmd->flags & LPFC_SBUF_XBUSY)) {
+		freqpriv = nCmd->private;
+		freqpriv->nvme_buf = NULL;
 		nCmd->done(nCmd);
 		lpfc_ncmd->nvmeCmd = NULL;
 	}
-- 
2.13.1
