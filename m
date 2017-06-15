From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 3/4] g_NCR5380: Limit sg_tablesize to avoid PDMA read overruns
 on DTC436
Date: Thu, 15 Jun 2017 08:17:56 -0400 (EDT)
Message-ID: <9a3c7141589fc15bc8457523ba5912da2d26a93d.1497528687.git.fthain@telegraphics.com.au>
References: <cover.1497528687.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1497528687.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Back-to-back DMA receive transfers can lose a byte due to a 5380
flaw. This makes scatter-receive difficult or impossible on affected
hardware, so limit the scatter/gather tablesize to 1.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 1e1cf7ca86fa..784913193ea5 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -247,6 +247,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 	case BOARD_DTC3181E:
 		ports = dtc_3181e_ports;
 		magic = ncr_53c400a_magic;
+		tpnt->sg_tablesize = 1;
 		break;
 	}
 
-- 
2.13.0
