From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/26] scsi: stop decoding if scsi_normalize_sense() fails
Date: Mon,  6 Oct 2014 11:01:10 +0200
Message-ID: <1412586086-129821-11-git-send-email-hare@suse.de>
References: <1412586086-129821-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaJFJBb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2014 05:01:31 -0400
In-Reply-To: <1412586086-129821-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

If scsi_normalize_sense() fails we couldn't decode the sense
buffer, and the scsi_sense_hdr fields are invalid.
For those cases we should rather dump the sense buffer
and not try to decode invalid fields.

Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index f9e2317..0b74e94 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1435,26 +1435,21 @@ scsi_print_sense_hdr(const struct scsi_device *sdev, const char *name,
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
 static void
-scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
-		       struct scsi_sense_hdr *sshdr)
+scsi_dump_sense_buffer(const unsigned char *sense_buffer, int sense_len)
 {
-	int k, num, res;
-
-	res = scsi_normalize_sense(sense_buffer, sense_len, sshdr);
-	if (0 == res) {
-		/* this may be SCSI-1 sense data */
-		num = (sense_len < 32) ? sense_len : 32;
-		printk("Unrecognized sense data (in hex):");
-		for (k = 0; k < num; ++k) {
-			if (0 == (k % 16)) {
-				printk("\n");
-				printk(KERN_INFO "        ");
-			}
-			printk("%02x ", sense_buffer[k]);
+	int k, num;
+
+	num = (sense_len < 32) ? sense_len : 32;
+	printk("Unrecognized sense data (in hex):");
+	for (k = 0; k < num; ++k) {
+		if (0 == (k % 16)) {
+			printk("\n");
+			printk(KERN_INFO "        ");
 		}
-		printk("\n");
-		return;
+		printk("%02x ", sense_buffer[k]);
 	}
+	printk("\n");
+	return;
 }
 
 static void
@@ -1524,7 +1519,10 @@ void __scsi_print_sense(const struct scsi_device *sdev, const char *name,
 {
 	struct scsi_sense_hdr sshdr;
 
-	scsi_decode_sense_buffer(sense_buffer, sense_len, &sshdr);
+	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
+		scsi_dump_sense_buffer(sense_buffer, sense_len);
+		return;
+	}
 	scsi_show_sense_hdr(sdev, name, &sshdr);
 	scsi_decode_sense_extras(sense_buffer, sense_len, &sshdr);
 	scsi_show_extd_sense(sdev, name, sshdr.asc, sshdr.ascq);
-- 
1.8.5.2

