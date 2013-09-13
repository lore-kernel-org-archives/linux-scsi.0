From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 1/3] fnic: host reset returns nonzero value(errno) on success
Date: Thu, 12 Sep 2013 17:45:41 -0700
Message-ID: <1379033143-1482-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-1.cisco.com ([173.36.130.12]:35480 "EHLO
	mtv-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3IMAuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2013 20:50:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Narsimhulu Musini <nmusini@cisco.com>, Hiral Patel <hiralpat@cisco.com>

From: Narsimhulu Musini <nmusini@cisco.com>

Fixed appropriate error codes that returns negative error number on failure,
and 0 on success. fnic_reset() is used directly by the fc transport callback
issue_fc_host_lip which requires a negative error number on failure.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index d014aae..50f3b32 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2207,7 +2207,7 @@ int fnic_reset(struct Scsi_Host *shost)
 {
 	struct fc_lport *lp;
 	struct fnic *fnic;
-	int ret = SUCCESS;
+	int ret = 0;
 
 	lp = shost_priv(shost);
 	fnic = lport_priv(lp);
@@ -2219,12 +2219,11 @@ int fnic_reset(struct Scsi_Host *shost)
 	 * Reset local port, this will clean up libFC exchanges,
 	 * reset remote port sessions, and if link is up, begin flogi
 	 */
-	if (lp->tt.lport_reset(lp))
-		ret = FAILED;
+	ret = lp->tt.lport_reset(lp);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Returning from fnic reset %s\n",
-		      (ret == SUCCESS) ?
+		      (ret == 0) ?
 		      "SUCCESS" : "FAILED");
 
 	return ret;
@@ -2251,7 +2250,7 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 	 * scsi-ml tries to send a TUR to every device if host reset is
 	 * successful, so before returning to scsi, fabric should be up
 	 */
-	ret = fnic_reset(shost);
+	ret = (fnic_reset(shost) == 0) ? SUCCESS : FAILED;
 	if (ret == SUCCESS) {
 		wait_host_tmo = jiffies + FNIC_HOST_RESET_SETTLE_TIME * HZ;
 		ret = FAILED;
-- 
1.7.10.4

