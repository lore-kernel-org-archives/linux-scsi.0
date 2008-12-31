From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] ses: Use new scsi VPD helper
Date: Wed, 31 Dec 2008 12:11:17 -0700
Message-ID: <20081231191116.GI2002@parisc-linux.org>
References: <1230747167-31677-1-git-send-email-matthew@wil.cx> <1230747167-31677-2-git-send-email-matthew@wil.cx> <1230749978.3408.128.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55579 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYLaTLd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Dec 2008 14:11:33 -0500
Content-Disposition: inline
In-Reply-To: <1230749978.3408.128.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Wed, Dec 31, 2008 at 12:59:38PM -0600, James Bottomley wrote:
> This was actually wrong in the original code.  It should be
> 
> pd_len = (buf[2] << 8) | buf[3] + 4;
> 
> to account for the header offset in the returned data length.

Ah yes.  I got it right in the scsi_get_vpd_page() code, and then forgot
about it while changing the ses code.  Thanks for spotting that.

vpd_len also needs to be unsigned int, as a u16 could wrap.  Here's a
replacement patch:

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 7f0df29..95d16b3 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -345,44 +345,21 @@ static int ses_enclosure_find_by_addr(struct enclosure_device *edev,
 	return 0;
 }
 
-#define VPD_INQUIRY_SIZE 36
-
 static void ses_match_to_enclosure(struct enclosure_device *edev,
 				   struct scsi_device *sdev)
 {
-	unsigned char *buf = kmalloc(VPD_INQUIRY_SIZE, GFP_KERNEL);
+	unsigned char *buf;
 	unsigned char *desc;
-	u16 vpd_len;
+	unsigned int vpd_len;
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
 
+	buf = scsi_get_vpd_page(sdev, 0x83);
 	if (!buf)
 		return;
 
-	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
-			     VPD_INQUIRY_SIZE, NULL, SES_TIMEOUT, SES_RETRIES,
-			     NULL))
-		goto free;
-
-	vpd_len = (buf[2] << 8) + buf[3];
-	kfree(buf);
-	buf = kmalloc(vpd_len, GFP_KERNEL);
-	if (!buf)
-		return;
-	cmd[3] = vpd_len >> 8;
-	cmd[4] = vpd_len & 0xff;
-	if (scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf,
-			     vpd_len, NULL, SES_TIMEOUT, SES_RETRIES, NULL))
-		goto free;
+	vpd_len = ((buf[2] << 8) | buf[3]) + 4;
 
 	desc = buf + 4;
 	while (desc < buf + vpd_len) {

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
