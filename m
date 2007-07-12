From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [patch 2/4] aha152x.c - Clean Reset path
Date: Thu, 12 Jul 2007 12:55:21 +0300
Message-ID: <4695FA89.4010105@panasas.com>
References: <4695F76F.5000305@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13327 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755151AbXGLJzj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 05:55:39 -0400
In-Reply-To: <4695F76F.5000305@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, =?ISO-8859-1?Q?=22J=FCrgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


  What Reset code was doing:  Save command's important/dangerous
  Info on stack. NULL those members from scsi_cmnd.
  Issue a Reset. wait for it to finish than restore members
  and return.
  What I do is save or NULL nothing. But use the "resetting"
  hint in aha152x_internal_queue() to NULL out working members
  and leave struct scsi_cmnd alone.
  (Actually the Reset path never touches any of these working
   members but it looks safer this way, just in case.)
  
  The indentation in aha152x_internal_queue() is wrong at
  this stage but it will be eliminated in last patch, and
  for now it is easier for review.
---
 drivers/scsi/aha152x.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 29253f9..ea57ecd 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1022,6 +1022,14 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 	   SCp.buffer           : next buffer
 	   SCp.buffers_residual : left buffers in list
 	   SCp.phase            : current state of the command */
+
+	if(phase & resetting) {
+		SCpnt->SCp.ptr           = NULL;
+		SCpnt->SCp.this_residual = 0;
+		SCpnt->resid             = 0;
+		SCpnt->SCp.buffer           = NULL;
+		SCpnt->SCp.buffers_residual = 0;
+	} else {
 	if (SCpnt->use_sg) {
 		SCpnt->SCp.buffer           = (struct scatterlist *) SCpnt->request_buffer;
 		SCpnt->SCp.ptr              = SG_ADDRESS(SCpnt->SCp.buffer);
@@ -1033,6 +1041,7 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
 		SCpnt->SCp.buffer           = NULL;
 		SCpnt->SCp.buffers_residual = 0;
 	}
+	}
 
 	DO_LOCK(flags);
 
@@ -1149,10 +1158,6 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	DECLARE_COMPLETION(done);
 	int ret, issued, disconnected;
-	unsigned char old_cmd_len = SCpnt->cmd_len;
-	unsigned short old_use_sg = SCpnt->use_sg;
-	void *old_buffer = SCpnt->request_buffer;
-	unsigned old_bufflen = SCpnt->request_bufflen;
 	unsigned long flags;
 	unsigned long timeleft;
 
@@ -1173,11 +1178,6 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	disconnected = issued && remove_SC(&DISCONNECTED_SC, SCpnt);
 	DO_UNLOCK(flags);
 
-	SCpnt->cmd_len         = 0;
-	SCpnt->use_sg          = 0;
-	SCpnt->request_buffer  = NULL;
-	SCpnt->request_bufflen = 0;
-
 	aha152x_internal_queue(SCpnt, &done, resetting, reset_done);
 
 	timeleft = wait_for_completion_timeout(&done, 100*HZ);
@@ -1188,11 +1188,6 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 		DO_UNLOCK(flags);
 	}
 
-	SCpnt->cmd_len         = old_cmd_len;
-	SCpnt->use_sg          = old_use_sg;
-  	SCpnt->request_buffer  = old_buffer;
-       	SCpnt->request_bufflen = old_bufflen;
-
 	DO_LOCK(flags);
 
 	if(SCpnt->SCp.phase & resetted) {
-- 
1.5.2.2.249.g45fd


