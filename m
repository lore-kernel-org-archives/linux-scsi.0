From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] libata support for rotation speed
Date: Thu, 19 Jun 2008 13:13:38 -0600
Message-ID: <20080619191337.GO4392@parisc-linux.org>
References: <20080619160216.GH4392@parisc-linux.org> <20080619175904.GK4392@parisc-linux.org> <1213899895.3501.45.camel@localhost.localdomain> <20080619183113.GM4392@parisc-linux.org> <485AAD0D.9000205@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <485AAD0D.9000205@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 19, 2008 at 03:01:33PM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >On Thu, Jun 19, 2008 at 01:24:55PM -0500, James Bottomley wrote:
> >>This looks like it can be called for ATA_DEV_ATAPI as well, in which
> >>case it's an illegal page to ask for.
> >
> >I was under the impression that this entire file is only used for
> >non-atapi devices.
> 
> Correct.  That code path is not travelled by ATAPI.

Thanks, Jeff.  Here's version three, including the form factor from word
168:


Add support for VPD page b1 to libata

SCSI VPD page b1 reports the nominal rotation speed and physical size
of the device.  Devices that conform to ATA-8 can return this information
in words 217 and 168 of the identify data.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 2e6e162..c08c3b9 100644
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
@@ -1899,6 +1901,19 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
+{
+	rbuf[1] = 0xb1;
+	rbuf[3] = 0x3c;
+	if (ata_id_major_version(args->id) > 7) {
+		rbuf[4] = args->id[217] >> 8;
+		rbuf[5] = args->id[217];
+		rbuf[7] = args->id[168] & 0xf;
+	}
+
+	return 0;
+}
+
 /**
  *	ata_scsiop_noop - Command handler that simply returns success.
  *	@args: device IDENTIFY data / SCSI command of interest.
@@ -2922,6 +2937,9 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
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
