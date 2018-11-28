From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 03/41] scsi: aacraid: aachba: Mark expected switch
 fall-throughs
Date: Tue, 27 Nov 2018 22:25:41 -0600
Message-ID: <fba277107d0b94bdd6e7cabf1d17e0fb0b6e13d8.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Also, a break statement is properly aligned.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/aacraid/aachba.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index bd7f352c28f3..75ab5ff6b78c 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2892,6 +2892,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 					    !(dev->raw_io_64) ||
 					    ((scsicmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
 						break;
+					/* fall through */
 				case INQUIRY:
 				case READ_CAPACITY:
 				case TEST_UNIT_READY:
@@ -2966,6 +2967,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 		/* Issue FIB to tell Firmware to flush it's cache */
 		if ((aac_cache & 6) != 2)
 			return aac_synchronize(scsicmd);
+		/* fall through */
 	case INQUIRY:
 	{
 		struct inquiry_data inq_data;
@@ -3319,8 +3321,9 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			       min_t(size_t,
 				     sizeof(dev->fsa_dev[cid].sense_data),
 				     SCSI_SENSE_BUFFERSIZE));
-		break;
+			break;
 		}
+		/* fall through */
 	case RESERVE:
 	case RELEASE:
 	case REZERO_UNIT:
-- 
2.17.1
