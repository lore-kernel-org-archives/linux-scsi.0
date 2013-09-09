From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 2/9] fnic: host reset returns nonzero value(errno) on success
Date: Mon,  9 Sep 2013 13:31:46 -0700
Message-ID: <1378758713-22443-2-git-send-email-hiralpat@cisco.com>
References: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:22291 "EHLO
	rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab3IIUgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 16:36:18 -0400
In-Reply-To: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Narsimhulu Musini <nmusini@cisco.com>, Hiral Patel <hiralpat@cisco.com>

From: Narsimhulu Musini <nmusini@cisco.com>

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

