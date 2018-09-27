From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 08/10] NCR5380: Don't call dsprintk() following reselection
 interrupt
Date: Thu, 27 Sep 2018 11:17:11 +1000
Message-ID: <415637c4234a45a626f293eef60766c244d1edbb.1538011031.git.fthain@telegraphics.com.au>
References: <cover.1538011031.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538011031.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, Ondrey Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The X3T9.2 specification (draft) says, under "6.1.4.1 RESELECTION",

    ... The reselected initiator shall then assert the BSY signal
    within a selection abort time of its most recent detection of being
    reselected; this is required for correct operation of the time-out
    procedure.

The selection abort time is only 200 us which may be insufficient time
for a printk() call. Move the diagnostics to the error paths.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 5826421146ba..419033643015 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2023,8 +2023,6 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 		return;
 	}
 
-	dsprintk(NDEBUG_RESELECTION, instance, "reselect\n");
-
 	/*
 	 * At this point, we have detected that our SCSI ID is on the bus,
 	 * SEL is true and BSY was false for at least one bus settle delay
@@ -2037,6 +2035,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_BSY);
 	if (NCR5380_poll_politely(hostdata,
 	                          STATUS_REG, SR_SEL, 0, 2 * HZ) < 0) {
+		shost_printk(KERN_ERR, instance, "reselect: !SEL timeout\n");
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		return;
 	}
@@ -2048,6 +2047,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 	if (NCR5380_poll_politely(hostdata,
 	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0) {
+		shost_printk(KERN_ERR, instance, "reselect: REQ timeout\n");
 		do_abort(instance);
 		return;
 	}
-- 
2.16.4
