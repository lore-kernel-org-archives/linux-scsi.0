From: Minwoo Im <minwoo.im.dev@gmail.com>
Subject: [RESEND PATCH] mpt3sas: support target smid for [abort|query] task
Date: Sun, 28 Jul 2019 03:53:37 +0900
Message-ID: <20190727185337.19299-1-minwoo.im.dev@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Euihyeok Kwon <eh81.kwon@samsung.com>, Sarah Cho <sohyeon.jo@samsung.com>, Sanggwan Lee <sanggwan.lee@samsung.com>, Gyeongmin Nam <gm.nam@samsung.com>, Sungjun Park <sj1228.park@samsung.com>, Minwoo Im <minwoo.im@samsung.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, MPT-FusionLinux.pdl@broadcom.com, Minwoo Im <minwoo.im.dev@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Minwoo Im <minwoo.im@samsung.com>

From: Minwoo Im <minwoo.im@samsung.com>

We can request task management IOCTL command(MPI2_FUNCTION_SCSI_TASK_MGMT)
to /dev/mpt3ctl.  If the given task_type is either abort task or query
task, it may need a field named "Initiator Port Transfer Tag to Manage"
in the IU.

Current code does not support to check target IPTT tag from the
tm_request.  This patch introduces to check TaskMID given from the
userspace as a target tag.  We have a rule of relationship between
(struct request *req->tag) and smid in mpt3sas_base.c:

3318 u16
3319 mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
3320         struct scsi_cmnd *scmd)
3321 {
3322         struct scsiio_tracker *request = scsi_cmd_priv(scmd);
3323         unsigned int tag = scmd->request->tag;
3324         u16 smid;
3325
3326         smid = tag + 1;

So if we want to abort a request tagged #X, then we can pass (X + 1) to
this IOCTL handler.  Otherwise, user space just can pass 0 TaskMID to
abort the first outstanding smid which is legacy behaviour.

Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
Acked-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index d4ecfbbe738c..a26c5516ea3e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -596,8 +596,16 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command *karg,
 		if (priv_data->sas_target->handle != handle)
 			continue;
 		st = scsi_cmd_priv(scmd);
-		tm_request->TaskMID = cpu_to_le16(st->smid);
-		found = 1;
+
+		/*
+		 * If the given TaskMID from the user space is zero, then the
+		 * first outstanding smid will be picked up.  Otherwise,
+		 * targeted smid will be the one.
+		 */
+		if (!tm_request->TaskMID || tm_request->TaskMID == st->smid) {
+			tm_request->TaskMID = cpu_to_le16(st->smid);
+			found = 1;
+		}
 	}
 
 	if (!found) {
-- 
2.17.1
