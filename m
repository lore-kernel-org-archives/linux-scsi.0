From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/4] Convert SES to use scsi_get_vpd_page
Date: Mon, 23 Jun 2008 09:18:27 -0600
Message-ID: <20080623151827.GG4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58729 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbYFWPS2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2008 11:18:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


SES had its own code to retrieve VPD from devices; convert it to use the
new scsi_get_vpd_page helper.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 45df83b..351bce7 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -356,21 +356,7 @@ static void ses_match_to_enclosure(struct enclosure_device *edev,
 	struct efd efd = {
 		.addr = 0,
 	};
-	unsigned char cmd[] = {
-		INQUIRY,
-		1,
-		0x83,
-		VPD_INQUIRY_SIZE >> 8,
-		VPD_INQUIRY_SIZE & 0xff,
-		0
-	};
-
-	if (!buf)
-		return;
-
-	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
-			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES))
-		goto free;
+	scsi_get_vpd_page(sdev, buf, 0x83, VPD_INQUIRY_SIZE);
 
 	len = (buf[2] << 8) + buf[3];
 	desc = buf + 4;
-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
