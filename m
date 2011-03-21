From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] sd: Fix regression in sd_read_cache_type
Date: Mon, 21 Mar 2011 17:29:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1103211727450.1637-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:44359 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753212Ab1CUV3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 17:29:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Richard Senior <richard@r-senior.demon.co.uk>, Luben Tuikov <ltuikov@yahoo.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1454) fixes a regression in the sd driver.  Commit
24d720b726c1a85f1962831ac30ad4d2ef8276b1 ([SCSI] Retrieve the Caching
mode page) recently introduced the strategy of asking for all pages
(page code 0x3F) instead of asking for the caching page (0x08) on
devices that might not support it.  This ought to be safe, because sd
already uses page code 0x3F when checking for write protection.

Unfortunately, the commit did not copy the checks used by
sd_read_write_protect_flag().  Some devices don't support page code
0x3F, and others require a fixed transfer length of 192 bytes.  This
patch adds those checks into sd_read_cache_type().

Without this fix, some USB mass-storage devices crash when they
receive a MODE SENSE command with page code 0x3F asking for only 4
bytes of data.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Richard Senior <richard@r-senior.demon.co.uk>
CC: Luben Tuikov <ltuikov@yahoo.com>
CC: <stable@kernel.org>

---

The only stable kernel requiring this fix is 2.6.38; earlier kernels
are okay.


 drivers/scsi/sd.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1904,17 +1904,23 @@ sd_read_cache_type(struct scsi_disk *sdk
 
 	int dbd;
 	int modepage;
+	int first_len;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 	int old_wce = sdkp->WCE;
 	int old_rcd = sdkp->RCD;
 	int old_dpofua = sdkp->DPOFUA;
 
+	first_len = 4;
 	if (sdp->skip_ms_page_8) {
 		if (sdp->type == TYPE_RBC)
 			goto defaults;
 		else {
+			if (sdp->skip_ms_page_3f)
+				goto defaults;
 			modepage = 0x3F;
+			if (sdp->use_192_bytes_for_3f)
+				first_len = 192;
 			dbd = 0;
 		}
 	} else if (sdp->type == TYPE_RBC) {
@@ -1926,13 +1932,15 @@ sd_read_cache_type(struct scsi_disk *sdk
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
 
@@ -1952,7 +1960,9 @@ sd_read_cache_type(struct scsi_disk *sdk
 	}
 
 	/* Get the data */
-	res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &sshdr);
+	if (len > first_len)
+		res = sd_do_mode_sense(sdp, dbd, modepage, buffer, len,
+				&data, &sshdr);
 
 	if (scsi_status_is_good(res)) {
 		int offset = data.header_length + data.block_descriptor_length;

