From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.5-rc6
Date: Fri, 04 Mar 2016 15:30:39 -0800
Message-ID: <1457134239.2419.121.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two fairly simple fixes.  One is a regression with ipr firmware loading
caused by one of the trivial patches in the last merge window which
failed to strip the \n from the file name string, so now the firmware
loader no longer works leading to a lot of unhappy ipr users; fix by
stripping the \n.  The second is a memory leak within SCSI: the
BLK_PREP_INVALID state was introduced a recent fix but we forgot to
account for it correctly when freeing state, resulting in memory
leakage.  Add the correct state freeing in scsi_prep_return().

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Gabriel Krisman Bertazi (1):
      ipr: Fix regression when loading firmware

jiangyiwen (1):
      SCSI: Free resources when we return BLKPREP_INVALID

And the diffstat:

 drivers/scsi/ipr.c      | 5 +++++
 drivers/scsi/scsi_lib.c | 1 +
 2 files changed, 6 insertions(+)

With full diff below.

James

---

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 3b3e099..d6a691e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4002,6 +4002,7 @@ static ssize_t ipr_store_update_fw(struct device *dev,
 	struct ipr_sglist *sglist;
 	char fname[100];
 	char *src;
+	char *endline;
 	int result, dnld_size;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -4009,6 +4010,10 @@ static ssize_t ipr_store_update_fw(struct device *dev,
 
 	snprintf(fname, sizeof(fname), "%s", buf);
 
+	endline = strchr(fname, '\n');
+	if (endline)
+		*endline = '\0';
+
 	if (request_firmware(&fw_entry, fname, &ioa_cfg->pdev->dev)) {
 		dev_err(&ioa_cfg->pdev->dev, "Firmware file %s not found\n", fname);
 		return -EIO;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fa6b2c4..8c6e318 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1344,6 +1344,7 @@ scsi_prep_return(struct request_queue *q, struct request *req, int ret)
 
 	switch (ret) {
 	case BLKPREP_KILL:
+	case BLKPREP_INVALID:
 		req->errors = DID_NO_CONNECT << 16;
 		/* release the command and kill it */
 		if (req->special) {
