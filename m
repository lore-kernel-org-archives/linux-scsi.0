From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 2/9] fnic: host reset returns nonzero value(errno) on success
Date: Thu, 29 Aug 2013 10:57:20 -0700
Message-ID: <1377799047-12644-2-git-send-email-hiralpat@cisco.com>
References: <1377799047-12644-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtv-iport-1.cisco.com ([173.36.130.12]:19290 "EHLO
	mtv-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab3H2SLa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2013 14:11:30 -0400
In-Reply-To: <1377799047-12644-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Hiral Patel <hiralpat@cisco.com>, Narsimhulu Musini <nmusini@cisco.com>

Fixed appropriate error codes that returns -1 on failure, and 0 on success

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index a97e6e5..ef3c463 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2208,7 +2208,7 @@ int fnic_reset(struct Scsi_Host *shost)
 {
 	struct fc_lport *lp;
 	struct fnic *fnic;
-	int ret = SUCCESS;
+	int ret = 0;
 
 	lp = shost_priv(shost);
 	fnic = lport_priv(lp);
@@ -2221,11 +2221,11 @@ int fnic_reset(struct Scsi_Host *shost)
 	 * reset remote port sessions, and if link is up, begin flogi
 	 */
 	if (lp->tt.lport_reset(lp))
-		ret = FAILED;
+		ret = -1;
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Returning from fnic reset %s\n",
-		      (ret == SUCCESS) ?
+		      (ret == 0) ?
 		      "SUCCESS" : "FAILED");
 
 	return ret;
@@ -2252,7 +2252,7 @@ int fnic_host_reset(struct scsi_cmnd *sc)
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

