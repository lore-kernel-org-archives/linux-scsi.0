From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 3/5] g_NCR5380: Limit sg_tablesize to avoid PDMA read
 overruns on DTC436
Date: Sat, 24 Jun 2017 02:37:36 -0400 (EDT)
Message-ID: <3b30382cbcb350793a5500615e37d12aca74f3ab.1498285948.git.fthain@telegraphics.com.au>
References: <cover.1498285948.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1498285948.git.fthain@telegraphics.com.au>
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
index 911a4300ea51..7b3626fe120b 100644
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
