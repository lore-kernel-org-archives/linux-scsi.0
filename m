From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 06/10] NCR5380: Check for invalid reselection target
Date: Thu, 27 Sep 2018 11:17:11 +1000
Message-ID: <6ae77d4d63ee60992e71baa281ad6e2ec7b29d25.1538011031.git.fthain@telegraphics.com.au>
References: <cover.1538011031.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538011031.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, Ondrey Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The X3T9.2 specification (draft) says, under "6.1.4.1 RESELECTION", that
"the initiator shall not respond to a RESELECTION phase if other than two
SCSI ID bits are on the DATA BUS." This issue (too many bits set) has
been observed in the wild, so add a check.

Tested-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index e96a48b9e86c..3058b68b6740 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2016,6 +2016,11 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	NCR5380_write(MODE_REG, MR_BASE);
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
+	if (!target_mask || target_mask & (target_mask - 1)) {
+		shost_printk(KERN_WARNING, instance,
+			     "reselect: bad target_mask 0x%02x\n", target_mask);
+		return;
+	}
 
 	dsprintk(NDEBUG_RESELECTION, instance, "reselect\n");
 
-- 
2.16.4
