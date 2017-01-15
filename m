From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 5/6] ncr5380: Improve target selection robustness
Date: Sun, 15 Jan 2017 18:50:57 -0500 (EST)
Message-ID: <61652a75a09c748f92c61cee1ea5c7f2e471a4e2.1484523085.git.fthain@telegraphics.com.au>
References: <cover.1484523085.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1484523085.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Handle timeout or bus phase change errors that could occur when
sending the IDENTIFY message.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 518d101..acc3344 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1165,8 +1165,16 @@ static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *instance,
 	data = tmp;
 	phase = PHASE_MSGOUT;
 	NCR5380_transfer_pio(instance, &phase, &len, &data);
+	if (len) {
+		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+		cmd->result = DID_ERROR << 16;
+		complete_cmd(instance, cmd);
+		dsprintk(NDEBUG_SELECTION, instance, "IDENTIFY message transfer failed\n");
+		cmd = NULL;
+		goto out;
+	}
+
 	dsprintk(NDEBUG_SELECTION, instance, "nexus established.\n");
-	/* XXX need to handle errors here */
 
 	hostdata->connected = cmd;
 	hostdata->busy[cmd->device->id] |= 1 << cmd->device->lun;
-- 
2.10.2
