From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.2-rc3
Date: Fri, 07 Jun 2019 23:05:26 -0700
Message-ID: <1559973926.2787.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two bug fixes, both for fairly serious problems; the UFS one looks like
it could be used to exfiltrate data from the kernel, although probably
only a privileged user has access to the command management interface
and the missing unlock in smartpqi is long standing and probably a
little used error path.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Avri Altman (1):
      scsi: ufs: Check that space was properly alloced in copy_query_response

Dan Carpenter (1):
      scsi: smartpqi: unlock on error in pqi_submit_raid_request_synchronous()

And the diffstat:

 drivers/scsi/smartpqi/smartpqi_init.c | 6 ++++--
 drivers/scsi/ufs/ufshcd.c             | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d6be4e8f4a8f..8fd5ffc55792 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -4046,8 +4046,10 @@ static int pqi_submit_raid_request_synchronous(struct pqi_ctrl_info *ctrl_info,
 				return -ETIMEDOUT;
 			msecs_blocked =
 				jiffies_to_msecs(jiffies - start_jiffies);
-			if (msecs_blocked >= timeout_msecs)
-				return -ETIMEDOUT;
+			if (msecs_blocked >= timeout_msecs) {
+				rc = -ETIMEDOUT;
+				goto out;
+			}
 			timeout_msecs -= msecs_blocked;
 		}
 	}
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8c1c551f2b42..3fe3029617a8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1917,7 +1917,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	memcpy(&query_res->upiu_res, &lrbp->ucd_rsp_ptr->qr, QUERY_OSF_SIZE);
 
 	/* Get the descriptor */
-	if (lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
+	if (hba->dev_cmd.query.descriptor &&
+	    lrbp->ucd_rsp_ptr->qr.opcode == UPIU_QUERY_OPCODE_READ_DESC) {
 		u8 *descp = (u8 *)lrbp->ucd_rsp_ptr +
 				GENERAL_UPIU_REQUEST_SIZE;
 		u16 resp_len;
