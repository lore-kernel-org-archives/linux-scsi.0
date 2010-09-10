From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] libata: Signal that our SATL supports WRITE SAME(16) with UNMAP
Date: Fri, 10 Sep 2010 01:23:18 -0400
Message-ID: <yq1vd6eqiih.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Until now identifying that a device supports WRITE SAME(16) with the
UNMAP bit set has been black magic.  Implement support for the SBC-3
Thin Provisioning VPD page and set the TPWS bit.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a54273d..eea9935 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2001,6 +2001,7 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 		0x89,	/* page 0x89, ata info page */
 		0xb0,	/* page 0xb0, block limits page */
 		0xb1,	/* page 0xb1, block device characteristics page */
+		0xb2,	/* page 0xb2, thin provisioning page */
 	};
 
 	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
@@ -2172,6 +2173,16 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b2(struct ata_scsi_args *args, u8 *rbuf)
+{
+	/* SCSI Thin Provisioning VPD page: SBC-3 rev 22 or later */
+	rbuf[1] = 0xb2;
+	rbuf[3] = 0x4;
+	rbuf[5] = 1 << 6;	/* TPWS */
+
+	return 0;
+}
+
 /**
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
@@ -3250,6 +3261,9 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		case 0xb1:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b1);
 			break;
+		case 0xb2:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b2);
+			break;
 		default:
 			ata_scsi_invalid_field(cmd, done);
 			break;
