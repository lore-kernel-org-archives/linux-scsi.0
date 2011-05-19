From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] Retrieve the Caching mode page (version 2)
Date: Thu, 19 May 2011 00:00:58 -0700 (PDT)
Message-ID: <192648.62620.qm@web31802.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm17-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.208]:45819 "HELO
	nm17-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932304Ab1ESHBA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2011 03:01:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, Richard Senior <richard@r-senior.demon.co.uk>, Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.or

Some kernel transport drivers unconditionally disable
retrieval of the Caching mode page. One such for example is
the BBB/CBI transport over USB. Such a restraint is too
harsh as some devices do support the Caching mode
page. Unconditionally enabling the retrieval of this mode
page over those transports at their transport code level may
result in some devices failing and becoming unusable.

This patch implements a method of retrieving the Caching
mode page without unconditionally enabling it in the
transports which unconditionally disable it. The idea is to
ask for all supported pages, page code 0x3F, and then search
for the Caching mode page in the mode parameter data
returned. The sd driver already asks for all the mode pages
supported by the attached device by setting the page code to
0x3F in order to find out if the media is write protected by
reading the WP bit in the Device Specific Parameter
field. It then attempts to retrieve only the Caching mode
page by setting the page code to 8 and actually attempting
to retrieve it if and only if the transport allows it.

The method implemented here is that if the transport doesn't
allow retrieval of the Caching mode page and the device is
not RBC, then we ask for all pages supported by setting the
page code to 0x3F (similarly to how the WP bit is retrieved
above), and then we search for the Caching mode page in the
mode parameter data returned.

With this patch, devices over SATA, report this (no change):

Oct 22 18:45:58 localhost kernel: sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
Oct 22 18:45:58 localhost kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Oct 22 18:45:58 localhost kernel: sd 0:0:0:0: [sda] Write Protect is off
Oct 22 18:45:58 localhost kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Oct 22 18:45:58 localhost kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Smart devices report their Caching mode page. This is a
change where we'd previously see the kernel making
assumption about the device's cache being write-through:

Oct 22 18:45:58 localhost kernel: sd 6:0:0:0: Attached scsi generic sg2 type 0
Oct 22 18:45:58 localhost kernel: sd 6:0:0:0: [sdb] 610472646 4096-byte logical blocks: (2.50 TB/2.27 TiB)
Oct 22 18:45:58 localhost kernel: sd 6:0:0:0: [sdb] Write Protect is off
Oct 22 18:45:58 localhost kernel: sd 6:0:0:0: [sdb] Mode Sense: 47 00 10 08
Oct 22 18:45:58 localhost kernel: sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA

And "dumb" devices over BBB, are correctly shown not to
support reporting the Caching mode page:

Oct 22 18:49:06 localhost kernel: sd 7:0:0:0: [sdc] 15663104 512-byte logical blocks: (8.01 GB/7.46 GiB)
Oct 22 18:49:06 localhost kernel: sd 7:0:0:0: [sdc] Write Protect is off
Oct 22 18:49:06 localhost kernel: sd 7:0:0:0: [sdc] Mode Sense: 23 00 00 00
Oct 22 18:49:06 localhost kernel: sd 7:0:0:0: [sdc] No Caching mode page present
Oct 22 18:49:06 localhost kernel: sd 7:0:0:0: [sdc] Assuming drive cache: write through

Version 2 adds this:

Some devices don't support page code 0x3F, and others require a
fixed transfer length of 192 bytes. This single commit includes a
patch by Alan Stern which fixes this.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Richard Senior <richard@r-senior.demon.co.uk>
CC: <stable@kernel.org>
Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/sd.c |   79 +++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bd0806e..0f57570 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2021,16 +2021,26 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 
 	int dbd;
 	int modepage;
+	int first_len;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 	int old_wce = sdkp->WCE;
 	int old_rcd = sdkp->RCD;
 	int old_dpofua = sdkp->DPOFUA;
 
-	if (sdp->skip_ms_page_8)
-		goto defaults;
-
-	if (sdp->type == TYPE_RBC) {
+	first_len = 4;
+	if (sdp->skip_ms_page_8) {
+		if (sdp->type == TYPE_RBC)
+			goto defaults;
+		else {
+			if (sdp->skip_ms_page_3f)
+				goto defaults;
+			modepage = 0x3F;
+			if (sdp->use_192_bytes_for_3f)
+				first_len = 192;
+			dbd = 0;
+		}
+	} else if (sdp->type == TYPE_RBC) {
 		modepage = 6;
 		dbd = 8;
 	} else {
@@ -2039,13 +2049,15 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 	/* cautiously ask */
-	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, 4, &data, &sshdr);
+	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, first_len,
+			&data, &sshdr);
 
 	if (!scsi_status_is_good(res))
 		goto bad_sense;
 
 	if (!data.header_length) {
 		modepage = 6;
+		first_len = 0;
 		sd_printk(KERN_ERR, sdkp, "Missing header in MODE_SENSE response\n");
 	}
 
@@ -2058,30 +2070,61 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	 */
 	if (len < 3)
 		goto bad_sense;
-	if (len > 20)
-		len = 20;
-
-	/* Take headers and block descriptors into account */
-	len += data.header_length + data.block_descriptor_length;
-	if (len > SD_BUF_SIZE)
-		goto bad_sense;
+	else if (len > SD_BUF_SIZE) {
+		sd_printk(KERN_NOTICE, sdkp, "Truncating mode parameter "
+			  "data from %d to %d bytes\n", len, SD_BUF_SIZE);
+		len = SD_BUF_SIZE;
+	}
+	if (modepage == 0x3F && sdp->use_192_bytes_for_3f)
+		len = 192;
 
 	/* Get the data */
-	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &sshdr);
+	if (len > first_len)
+		res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len,
+				&data, &sshdr);
 
 	if (scsi_status_is_good(res)) {
 		int offset = data.header_length + data.block_descriptor_length;
 
-		if (offset >= SD_BUF_SIZE - 2) {
-			sd_printk(KERN_ERR, sdkp, "Malformed MODE SENSE response\n");
-			goto defaults;
+		while (offset < len) {
+			u8 page_code = buffer[offset] & 0x3F;
+			u8 spf       = buffer[offset] & 0x40;
+
+			if (page_code == 8 || page_code == 6) {
+				/* We're interested only in the first 3 bytes.
+				 */
+				if (len - offset <= 2) {
+					sd_printk(KERN_ERR, sdkp, "Incomplete "
+						  "mode parameter data\n");
+					goto defaults;
+				} else {
+					modepage = page_code;
+					goto Page_found;
+				}
+			} else {
+				/* Go to the next page */
+				if (spf && len - offset > 3)
+					offset += 4 + (buffer[offset+2] << 8) +
+						buffer[offset+3];
+				else if (!spf && len - offset > 1)
+					offset += 2 + buffer[offset+1];
+				else {
+					sd_printk(KERN_ERR, sdkp, "Incomplete "
+						  "mode parameter data\n");
+					goto defaults;
+				}
+			}
 		}
 
-		if ((buffer[offset] & 0x3f) != modepage) {
+		if (modepage == 0x3F) {
+			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
+				  "present\n");
+			goto defaults;
+		} else if ((buffer[offset] & 0x3f) != modepage) {
 			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
 			goto defaults;
 		}
-
+	Page_found:
 		if (modepage == 8) {
 			sdkp->WCE = ((buffer[offset + 2] & 0x04) != 0);
 			sdkp->RCD = ((buffer[offset + 2] & 0x01) != 0);
-- 
1.7.2.2.165.gbc382


