From: akpm@linux-foundation.org
Subject: [patch 18/18] scsi/pmcraid: redundant check in pmcraid_check_ioctl_buffer()?
Date: Tue, 17 Nov 2009 14:53:28 -0800
Message-ID: <200911172253.nAHMrS2N020220@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756745AbZKQW4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 17:56:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, anil_ravindranath@pmc-sierra.com

From: Roel Kluin <roel.kluin@gmail.com>

struct pmcraid_ioctl_header member buffer_length is unsigned, so this
check appears redundant.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pmcraid.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/scsi/pmcraid.c~scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer drivers/scsi/pmcraid.c
--- a/drivers/scsi/pmcraid.c~scsi-pmcraid-redundant-check-in-pmcraid_check_ioctl_buffer
+++ a/drivers/scsi/pmcraid.c
@@ -3736,12 +3736,6 @@ static int pmcraid_check_ioctl_buffer(
 		return -EINVAL;
 	}
 
-	/* buffer length can't be negetive */
-	if (hdr->buffer_length < 0) {
-		pmcraid_err("ioctl: invalid buffer length specified\n");
-		return -EINVAL;
-	}
-
 	/* check for appropriate buffer access */
 	if ((_IOC_DIR(cmd) & _IOC_READ) == _IOC_READ)
 		access = VERIFY_WRITE;
_
