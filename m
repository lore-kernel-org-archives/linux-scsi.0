From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/22] scsi: stop decoding if scsi_normalize_sense() fails
Date: Thu, 28 Aug 2014 19:33:20 +0200
Message-ID: <1409247216-76074-7-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaH1Rdk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:40 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

If scsi_normalize_sense() fails we couldn't decode the sense
buffer, so we should not try to interpret the result.
We should rather dump the sense buffer instead and stop decoding.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 36e1ffd..6b05575 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1429,25 +1429,21 @@ scsi_print_sense_hdr(struct scsi_device *sdev, const char *name,
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
 static void
-scsi_decode_sense_buffer(const unsigned char *sense_buffer, int sense_len,
-		       struct scsi_sense_hdr *sshdr)
+scsi_dump_sense_buffer(struct scsi_device *sdev, const char *name,
+		       const unsigned char *sense_buffer, int sense_len)
 {
-	int k, num, res;
+	char linebuf[128];
+	int i, linelen, remaining;
 
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
-		}
-		printk("\n");
-		return;
+	remaining = sense_len;
+	for (i = 0; i < sense_len; i += 16) {
+		linelen = min(remaining, 16);
+		remaining -= 16;
+
+		hex_dump_to_buffer(sense_buffer + i, linelen, 16, 1,
+				   linebuf, sizeof(linebuf), false);
+		sdev_prefix_printk(KERN_INFO, sdev, name,
+				   "Sense: %s\n", linebuf);
 	}
 }
 
@@ -1517,8 +1513,13 @@ void __scsi_print_sense(struct scsi_device *sdev, const char *name,
 			const unsigned char *sense_buffer, int sense_len)
 {
 	struct scsi_sense_hdr sshdr;
+	int res;
 
-	scsi_decode_sense_buffer(sense_buffer, sense_len, &sshdr);
+	res = scsi_normalize_sense(sense_buffer, sense_len, &sshdr);
+	if (res == 0) {
+		scsi_dump_sense_buffer(sdev, name, sense_buffer, sense_len);
+		return;
+	}
 	scsi_show_sense_hdr(sdev, name, &sshdr);
 	scsi_decode_sense_extras(sense_buffer, sense_len, &sshdr);
 	scsi_show_extd_sense(sdev, name, sshdr.asc, sshdr.ascq);
-- 
1.8.5.2

