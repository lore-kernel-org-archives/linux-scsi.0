From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [RFC PATCH 04/10] scsi/constants: Cleanup printk message in
 scsi_dump_sense_buffer()
Date: Fri, 08 Aug 2014 11:50:14 +0000
Message-ID: <20140808115014.6768.44632.stgit@yuno-kbuild.novalocal>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Doug Gilbert <dgilbert@interlog.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Unrecognized sense data should be output after linebuf is filled because
"[%s] Unrecognized sense data (in hex): %s" message is output many times in
loop.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 drivers/scsi/constants.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 5956d4d..6fad6b4 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1385,16 +1385,13 @@ EXPORT_SYMBOL(scsi_print_sense_hdr);
 
 static void
 scsi_dump_sense_buffer(struct scsi_device *sdev, const char *prefix,
-		       const unsigned char *sense_buffer, int sense_len,
-		       struct scsi_sense_hdr *sshdr)
+		       const unsigned char *sense_buffer, int sense_len)
 {
 	char linebuf[128];
 	int i, linelen, remaining;
 
 	if (sense_len < 32)
 		sense_len = 32;
-	sdev_printk(KERN_INFO, sdev,
-		    "[%s] Unrecognized sense data (in hex):", prefix);
 
 	remaining = sense_len;
 	for (i = 0; i < sense_len; i += 16) {
@@ -1403,9 +1400,10 @@ scsi_dump_sense_buffer(struct scsi_device *sdev, const char *prefix,
 
 		hex_dump_to_buffer(sense_buffer + i, linelen, 16, 1,
 				   linebuf, sizeof(linebuf), false);
-		sdev_printk(KERN_INFO, sdev, "[%s] Sense: %s\n",
-			    prefix, linebuf);
 	}
+	sdev_printk(KERN_INFO, sdev,
+		    "[%s] Unrecognized sense data (in hex): %s",
+		    prefix, linebuf);
 }
 
 static void
@@ -1467,8 +1465,7 @@ void __scsi_print_sense(struct scsi_device *sdev, const char *name,
 
 	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
 		/* this may be SCSI-1 sense data */
-		scsi_dump_sense_buffer(sdev, name, sense_buffer,
-				       sense_len, &sshdr);
+		scsi_dump_sense_buffer(sdev, name, sense_buffer, sense_len);
 		return;
 	}
 
