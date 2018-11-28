From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 32/41] scsi: myrb: Mark expected switch fall-throughs
Date: Tue, 27 Nov 2018 22:32:52 -0600
Message-ID: <15cf75b544d6b2eae77ba98cd201620b44abec36.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 1465234 ("Missing break in switch")
Addresses-Coverity-ID: 1465238 ("Missing break in switch")
Addresses-Coverity-ID: 1465242 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/myrb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 0642f2d0a3bb..539ac8ce4fcd 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1528,6 +1528,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			scmd->scsi_done(scmd);
 			return 0;
 		}
+		/* fall through */
 	case WRITE_6:
 		lba = (((scmd->cmnd[1] & 0x1F) << 16) |
 		       (scmd->cmnd[2] << 8) |
@@ -1544,6 +1545,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			scmd->scsi_done(scmd);
 			return 0;
 		}
+		/* fall through */
 	case WRITE_10:
 	case VERIFY:		/* 0x2F */
 	case WRITE_VERIFY:	/* 0x2E */
@@ -1560,6 +1562,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
 			scmd->scsi_done(scmd);
 			return 0;
 		}
+		/* fall through */
 	case WRITE_12:
 	case VERIFY_12: /* 0xAF */
 	case WRITE_VERIFY_12:	/* 0xAE */
-- 
2.17.1
