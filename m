From: Meelis Roos <mroos@linux.ee>
Subject: [PATCH v2] qlogicpti: fix timeout
Date: Fri, 7 Oct 2011 18:05:08 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1110071800120.29152@math.ut.ee>
References: <alpine.SOC.1.00.1110071050080.648@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:40157 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab1JGPFK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Oct 2011 11:05:10 -0400
In-Reply-To: <alpine.SOC.1.00.1110071050080.648@math.ut.ee>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

qlogicpti times out for some tape library operations (like mtx 
inventory). It seems SCSI command timeout is hardcoded into the driver. 
Fix it by propagating the timeout from scsi request to the controller as 
suggested by James Bottomley.

Tested on Sun Ultra 1 with Sun StorEdge L8 Autoloader.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 9689d41c..e40dc1c 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -880,7 +880,7 @@ static inline void cmd_frob(struct Command_Entry *cmd, struct scsi_cmnd *Cmnd,
 		cmd->control_flags |= CFLAG_WRITE;
 	else
 		cmd->control_flags |= CFLAG_READ;
-	cmd->time_out = 30;
+	cmd->time_out = Cmnd->request->timeout/HZ;
 	memcpy(cmd->cdb, Cmnd->cmnd, Cmnd->cmd_len);
 }
 


-- 
Meelis Roos (mroos@linux.ee)
