From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 04/10] NCR5380: Withhold disconnect privilege for REQUEST
 SENSE
Date: Thu, 27 Sep 2018 11:17:11 +1000
Message-ID: <44118a49ffa8ea8d3bfa63ca13166946b75f1843.1538011031.git.fthain@telegraphics.com.au>
References: <cover.1538011031.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538011031.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, Ondrey Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is mostly needed because an AztecMonster II target has been
observed disconnecting REQUEST SENSE commands and then failing
to reselect properly.

Suggested-by: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 7be1ba2b9e4e..5226164cfa65 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -936,6 +936,8 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 	int len;
 	int err;
 	bool ret = true;
+	bool can_disconnect = instance->irq != NO_IRQ &&
+			      cmd->cmnd[0] != REQUEST_SENSE;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dsprintk(NDEBUG_ARBITRATION, instance, "starting arbitration, id = %d\n",
@@ -1159,7 +1161,7 @@ static bool NCR5380_select(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 
 	dsprintk(NDEBUG_SELECTION, instance, "target %d selected, going into MESSAGE OUT phase.\n",
 	         scmd_id(cmd));
-	tmp[0] = IDENTIFY(((instance->irq == NO_IRQ) ? 0 : 1), cmd->device->lun);
+	tmp[0] = IDENTIFY(can_disconnect, cmd->device->lun);
 
 	len = 1;
 	data = tmp;
-- 
2.16.4
