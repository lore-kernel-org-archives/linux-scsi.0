From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] libata support for rotation speed
Date: Thu, 19 Jun 2008 11:59:05 -0600
Message-ID: <20080619175904.GK4392@parisc-linux.org>
References: <20080619160216.GH4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51371 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbYFSR7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2008 13:59:21 -0400
Content-Disposition: inline
In-Reply-To: <20080619160216.GH4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org


Version 2, Jeff pointed out I was missing a check for a sufficiently
recent version of the specification.

Add support for VPD page b1 to libata

SCSI VPD page b1 reports the nominal rotation speed of the device.
ATA devices return this information in word 217 of the identify data.
b1 can also report the physical size of the device (5.25", 3.5", etc)
but that doesn't currently seem to be defined in the ATA specification.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2e6e162..07512d4 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1778,7 +1778,9 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
 	const u8 pages[] = {
 		0x00,	/* page 0x00, this page */
 		0x80,	/* page 0x80, unit serial no page */
-		0x83	/* page 0x83, device ident page */
+		0x83,	/* page 0x83, device ident page */
+		0x89,	/* page 0x89, ata info page */
+		0xb1,	/* page 0xb1, block device characteristics page */
 	};
 
 	rbuf[3] = sizeof(pages);	/* number of supported VPD pages */
@@ -1899,6 +1901,18 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
+{
+	rbuf[1] = 0xb1;
+	rbuf[3] = 0x3c;
+	if (ata_id_major_version(args->id) > 7) {
+		rbuf[4] = args->id[217] >> 8;
+		rbuf[5] = args->id[217];
+	}
+
+	return 0;
+}
+
 /**
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
@@ -2922,6 +2936,9 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		case 0x89:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_89);
 			break;
+		case 0xb1:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b1);
+			break;
 		default:
 			ata_scsi_invalid_field(cmd, done);
 			break;

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
