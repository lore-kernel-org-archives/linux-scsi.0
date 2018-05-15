From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.17-rc5
Date: Tue, 15 May 2018 17:16:32 +0200
Message-ID: <1526397392.17390.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two small driver fixes: aacraid to fix an unknown IU type on task
management functions which causes a firmware fault and vmw_pvscsi to
change a return code to retry the operation instead of causing an
immediate error

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dave Carroll (1):
      scsi: aacraid: Correct hba_send to include iu_type

Jim Gill (1):
      scsi: vmw-pvscsi: return DID_BUS_BUSY for adapter-initated aborts

And the diffstat:

 drivers/scsi/aacraid/commsup.c | 8 ++++----
 drivers/scsi/vmw_pvscsi.c      | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/commsup.c
b/drivers/scsi/aacraid/commsup.c
index 0156c9623c35..d62ddd63f4fe 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -724,6 +724,8 @@ int aac_hba_send(u8 command, struct fib *fibptr,
fib_callback callback,
 	int wait;
 	unsigned long flags = 0;
 	unsigned long mflags = 0;
+	struct aac_hba_cmd_req *hbacmd = (struct aac_hba_cmd_req *)
+			fibptr->hw_fib_va;
 
 	fibptr->flags = (FIB_CONTEXT_FLAG |
FIB_CONTEXT_FLAG_NATIVE_HBA);
 	if (callback) {
@@ -734,11 +736,9 @@ int aac_hba_send(u8 command, struct fib *fibptr,
fib_callback callback,
 		wait = 1;
 
 
-	if (command == HBA_IU_TYPE_SCSI_CMD_REQ) {
-		struct aac_hba_cmd_req *hbacmd =
-			(struct aac_hba_cmd_req *)fibptr->hw_fib_va;
+	hbacmd->iu_type = command;
 
-		hbacmd->iu_type = command;
+	if (command == HBA_IU_TYPE_SCSI_CMD_REQ) {
 		/* bit1 of request_id must be 0 */
 		hbacmd->request_id =
 			cpu_to_le32((((u32)(fibptr - dev->fibs)) << 2)
+ 1);
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index c374e3b5c678..777e5f1e52d1 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -609,7 +609,7 @@ static void pvscsi_complete_request(struct
pvscsi_adapter *adapter,
 			break;
 
 		case BTSTAT_ABORTQUEUE:
-			cmd->result = (DID_ABORT << 16);
+			cmd->result = (DID_BUS_BUSY << 16);
 			break;
 
 		case BTSTAT_SCSIPARITY:
