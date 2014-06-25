From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/6] scsi: use dev_printk() variants for ioctl
Date: Wed, 25 Jun 2014 16:39:58 +0200
Message-ID: <1403707199-102664-6-git-send-email-hare@suse.de>
References: <1403707199-102664-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242AbaFYOkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2014 10:40:03 -0400
In-Reply-To: <1403707199-102664-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_ioctl.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index d9564fb..1aaaf43 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -91,12 +91,14 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 	int result;
 	struct scsi_sense_hdr sshdr;
 
-	SCSI_LOG_IOCTL(1, printk("Trying ioctl with scsi command %d\n", *cmd));
+	SCSI_LOG_IOCTL(1, sdev_printk(KERN_INFO, sdev,
+				      "Trying ioctl with scsi command %d\n", *cmd));
 
 	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
 				  &sshdr, timeout, retries, NULL);
 
-	SCSI_LOG_IOCTL(2, printk("Ioctl returned  0x%x\n", result));
+	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
+				      "Ioctl returned  0x%x\n", result));
 
 	if ((driver_byte(result) & DRIVER_SENSE) &&
 	    (scsi_sense_valid(&sshdr))) {
@@ -105,9 +107,11 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 			if (cmd[0] == ALLOW_MEDIUM_REMOVAL)
 				sdev->lockable = 0;
 			else
-				printk(KERN_INFO "ioctl_internal_command: "
-				       "ILLEGAL REQUEST asc=0x%x ascq=0x%x\n",
-				       sshdr.asc, sshdr.ascq);
+				sdev_printk(KERN_INFO, sdev,
+					    "ioctl_internal_command: "
+					    "ILLEGAL REQUEST "
+					    "asc=0x%x ascq=0x%x\n",
+					    sshdr.asc, sshdr.ascq);
 			break;
 		case NOT_READY:	/* This happens if there is no disc in drive */
 			if (sdev->removable)
@@ -127,7 +131,8 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 		}
 	}
 
-	SCSI_LOG_IOCTL(2, printk("IOCTL Releasing command\n"));
+	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
+				      "IOCTL Releasing command\n"));
 	return result;
 }
 
-- 
1.7.12.4

