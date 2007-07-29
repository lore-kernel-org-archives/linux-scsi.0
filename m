From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/6] aha152x.c - Clean Reset path
Date: Sun, 29 Jul 2007 22:24:09 +0300
Message-ID: <46ACE959.4080102@panasas.com>
References: <46ACE62F.4070108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4633 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764400AbXG2TYU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 15:24:20 -0400
In-Reply-To: <46ACE62F.4070108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, =?ISO-8859-1?Q?=22J=FC?= =?ISO-8859-1?Q?rgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>


  What Reset code was doing:  Save command's important/dangerous
  Info on stack. NULL those members from scsi_cmnd.
  Issue a Reset. wait for it to finish than restore members
  and return.

  What I do is save or NULL nothing. But use the "resetting"
  hint in aha152x_internal_queue() to NULL out working members
  and leave struct scsi_cmnd alone.

  The indent here looks funny but it will change/drop in last
  patch and it is clear this way what changed.
---
 drivers/scsi/aha152x.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index dc7d84b..d7ca86f 100644
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
 
@@ -1150,9 +1159,6 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	DECLARE_COMPLETION(done);
 	int ret, issued, disconnected;
 	unsigned char old_cmd_len = SCpnt->cmd_len;
-	unsigned short old_use_sg = SCpnt->use_sg;
-	void *old_buffer = SCpnt->request_buffer;
-	unsigned old_bufflen = SCpnt->request_bufflen;
 	unsigned long flags;
 	unsigned long timeleft;
 
@@ -1174,9 +1180,6 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	DO_UNLOCK(flags);
 
 	SCpnt->cmd_len         = 0;
-	SCpnt->use_sg          = 0;
-	SCpnt->request_buffer  = NULL;
-	SCpnt->request_bufflen = 0;
 
 	aha152x_internal_queue(SCpnt, &done, resetting, reset_done);
 
@@ -1189,9 +1192,6 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 	}
 
 	SCpnt->cmd_len         = old_cmd_len;
-	SCpnt->use_sg          = old_use_sg;
-  	SCpnt->request_buffer  = old_buffer;
-       	SCpnt->request_bufflen = old_bufflen;
 
 	DO_LOCK(flags);
 
-- 
1.5.2.2.249.g45fd


