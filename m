From: Joe Jin <joe.jin@oracle.com>
Subject: [PATCH-RESEND] [SCSI] fnic: return zero on fnic_reset() success
Date: Thu, 02 Feb 2012 10:26:30 +0800
Message-ID: <4F29F456.8090508@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>, Brian Uchino <buchino@cisco.com>, torvalds@linux-foundation.org
Cc: Sriharsha <sriharsha.devdas@oracle.com>, Joe Jin <joe.jin@oracle.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org, andrew thomas <andrew.thomas@oracle.com>, Greg Marsden <greg.marsden@oracle.com>, Guru Anbalagane <guru.anbalagane@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

When issue LIP by sysfs found write("1") returned 8194, this caused by
fnic_reset() return SUCCESS to store_fc_private_host_issue_lip().
Return 0/-1 for fnic_reset() fix this issue.

Tested-by: Sriharsha <sriharsha.devdas@oracle.com>
Signed-off-by: Joe Jin <joe.jin@oracle.com>
Cc: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: Venkata Siva Vijayendra Bhamidipati <vbhamidi@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
CC: stable@vger.kernel.org
---
 drivers/scsi/fnic/fnic_scsi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index c40ce52..e705e5e 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1662,7 +1662,7 @@ int fnic_reset(struct Scsi_Host *shost)
 {
 	struct fc_lport *lp;
 	struct fnic *fnic;
-	int ret = SUCCESS;
+	int ret = 0;
 
 	lp = shost_priv(shost);
 	fnic = lport_priv(lp);
@@ -1675,11 +1675,11 @@ int fnic_reset(struct Scsi_Host *shost)
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
@@ -1706,7 +1706,7 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 	 * scsi-ml tries to send a TUR to every device if host reset is
 	 * successful, so before returning to scsi, fabric should be up
 	 */
-	ret = fnic_reset(shost);
+	ret = (fnic_reset(shost) == 0) ? SUCCESS : FAILED;
 	if (ret == SUCCESS) {
 		wait_host_tmo = jiffies + FNIC_HOST_RESET_SETTLE_TIME * HZ;
 		ret = FAILED;
-- 
1.7.7.5
