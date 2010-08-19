From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/6] libata: Signal that our SATL supports WRITE SAME(16) with UNMAP
Date: Thu, 19 Aug 2010 11:48:56 -0400
Message-ID: <1282232941-9910-2-git-send-email-martin.petersen@oracle.com>
References: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1282232941-9910-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Until now identifying that a device supports WRITE SAME(16) with the
UNMAP bit set has been black magic.  Implement support for the new (SBC3
r24) Thin Provisioning VPD page and the TPWS bit.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/ata/libata-scsi.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a54273d..e280ae6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2001,6 +2001,7 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 		0x89,	/* page 0x89, ata info page */
 		0xb0,	/* page 0xb0, block limits page */
 		0xb1,	/* page 0xb1, block device characteristics page */
+		0xb2,	/* page 0xb2, thin provisioning page */
 	};
 
 	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
@@ -2172,6 +2173,15 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b2(struct ata_scsi_args *args, u8 *rbuf)
+{
+	rbuf[1] = 0xb1;
+	rbuf[3] = 0x3c;
+	rbuf[5] = 1 << 6;	/* TPWS */
+
+	return 0;
+}
+
 /**
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
@@ -3250,6 +3260,9 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		case 0xb1:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b1);
 			break;
+		case 0xb2:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b2);
+			break;
 		default:
 			ata_scsi_invalid_field(cmd, done);
 			break;
-- 
1.7.2.1

