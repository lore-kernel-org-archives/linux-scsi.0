From: Meelis Roos <mroos@linux.ee>
Subject: [PATCH] qlogicpti: increase timeout
Date: Fri, 7 Oct 2011 10:53:57 +0300 (EEST)
Message-ID: <alpine.SOC.1.00.1110071050080.648@math.ut.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
To: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

qlogicpti times out for some tape library operations (like mtx 
inventory). It seems SCSI command timeout is hardcoded into the driver. 
So let's increase it to some arbitrary higher value that Works For 
Me(tm).

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 9689d41c..4290141 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -880,7 +880,7 @@ static inline void cmd_frob(struct Command_Entry *cmd, struct scsi_cmnd *Cmnd,
 		cmd->control_flags |= CFLAG_WRITE;
 	else
 		cmd->control_flags |= CFLAG_READ;
-	cmd->time_out = 30;
+	cmd->time_out = 120;
 	memcpy(cmd->cdb, Cmnd->cmnd, Cmnd->cmd_len);
 }
 

-- 
Meelis Roos (mroos@linux.ee)
