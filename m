From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 3/7] scsi: NCR5380: Handle PDMA failure reliably
Date: Sun, 09 Jun 2019 11:19:11 +1000
Message-ID: <c32c86f51d42fcda5b4f0557eb89500f8b4c7c3b.1560043151.git.fthain@telegraphics.com.au>
References: <cover.1560043151.git.fthain@telegraphics.com.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <cover.1560043151.git.fthain@telegraphics.com.au>
Sender: stable-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A PDMA error is handled in the core driver by setting the device's
'borken' flag and aborting the command. Unfortunately, do_abort() is not
dependable. Perform a SCSI bus reset instead, to make sure that the
command fails and gets retried.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: stable@vger.kernel.org # v4.20+
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 08e3ea8159b3..d9fa9cf2fd8b 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1761,10 +1761,8 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						scmd_printk(KERN_INFO, cmd,
 							"switching to slow handshake\n");
 						cmd->device->borken = 1;
-						sink = 1;
-						do_abort(instance);
-						cmd->result = DID_ERROR << 16;
-						/* XXX - need to source or sink data here, as appropriate */
+						do_reset(instance);
+						bus_reset_cleanup(instance);
 					}
 				} else {
 					/* Transfer a small chunk so that the
-- 
2.21.0
