From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] sr: reduce debug noise in sr_do_ioctl
Date: Sun, 18 Jan 2015 16:11:31 +0100
Message-ID: <1421593891-19984-4-git-send-email-hch@lst.de>
References: <1421593891-19984-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52048 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbbARPM3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 10:12:29 -0500
In-Reply-To: <1421593891-19984-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <JBottomley@Parallels.com>, linux-scsi@vger.kernel.org

The midlayer scsi logging already logs the command and sense code
if the logging level is high enough, no need to duplicate that
in the sr driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sr_ioctl.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index e8deb9c..03054c0 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -188,7 +188,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 	struct scsi_sense_hdr sshdr;
 	int result, err = 0, retries = 0;
 	struct request_sense *sense = cgc->sense;
-	char logbuf[SCSI_LOG_BUFSIZE];
 
 	SDev = cd->device;
 
@@ -246,9 +245,6 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 				sr_printk(KERN_INFO, cd,
 					  "CDROM not ready.  Make sure there "
 					  "is a disc in the drive.\n");
-#ifdef DEBUG
-			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
-#endif
 			err = -ENOMEDIUM;
 			break;
 		case ILLEGAL_REQUEST:
@@ -257,22 +253,8 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 			    sshdr.ascq == 0x00)
 				/* sense: Invalid command operation code */
 				err = -EDRIVE_CANT_DO_THIS;
-#ifdef DEBUG
-			__scsi_format_command(logbuf, sizeof(logbuf),
-					      cgc->cmd, CDROM_PACKET_SIZE);
-			sr_printk(KERN_INFO, cd,
-				  "CDROM (ioctl) invalid command: %s\n",
-				  logbuf);
-			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
-#endif
 			break;
 		default:
-			__scsi_format_command(logbuf, sizeof(logbuf),
-					      cgc->cmd, CDROM_PACKET_SIZE);
-			sr_printk(KERN_ERR, cd,
-				  "CDROM (ioctl) error, command: %s\n",
-				  logbuf);
-			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 			err = -EIO;
 		}
 	}
-- 
1.9.1

