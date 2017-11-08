From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: ppa: mark expected switch fall-throughs
Date: Wed, 8 Nov 2017 11:17:39 -0600
Message-ID: <20171108171739.GA9139@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 114988
Addresses-Coverity-ID: 114989
Addresses-Coverity-ID: 114990
Addresses-Coverity-ID: 114991
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/ppa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 7be5823..ee86a0c 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -724,6 +724,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 			return 0;
 		}
 		cmd->SCp.phase++;
+		/* fall through */
 
 	case 3:		/* Phase 3 - Ready to accept a command */
 		w_ctr(ppb, 0x0c);
@@ -733,6 +734,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 		if (!ppa_send_command(cmd))
 			return 0;
 		cmd->SCp.phase++;
+		/* fall through */
 
 	case 4:		/* Phase 4 - Setup scatter/gather buffers */
 		if (scsi_bufflen(cmd)) {
@@ -746,6 +748,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 		}
 		cmd->SCp.buffers_residual = scsi_sg_count(cmd) - 1;
 		cmd->SCp.phase++;
+		/* fall through */
 
 	case 5:		/* Phase 5 - Data transfer stage */
 		w_ctr(ppb, 0x0c);
@@ -758,6 +761,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 		if (retv == 0)
 			return 1;
 		cmd->SCp.phase++;
+		/* fall through */
 
 	case 6:		/* Phase 6 - Read status/message */
 		cmd->result = DID_OK << 16;
-- 
2.7.4
