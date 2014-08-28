From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/22] scsi: pass in string buffer to __scsi_print_command()
Date: Thu, 28 Aug 2014 19:33:28 +0200
Message-ID: <1409247216-76074-15-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbaH1Rdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:43 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Instead of using an on-stack buffer for __scsi_print_command()
we should pass in the string buffer directly.
This allows us to simplify the caller.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ch.c        |  5 +++--
 drivers/scsi/constants.c | 16 ++++++++--------
 drivers/scsi/sr_ioctl.c  | 10 +++++++---
 include/scsi/scsi_dbg.h  |  2 +-
 4 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index eea94a9..ed023cc 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -189,6 +189,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
 {
 	int errno, retries = 0, timeout, result;
 	struct scsi_sense_hdr sshdr;
+	char logbuf[80];
 
 	timeout = (cmd[0] == INITIALIZE_ELEMENT_STATUS)
 		? timeout_init : timeout_move;
@@ -196,8 +197,8 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
  retry:
 	errno = 0;
 	if (debug) {
-		DPRINTK("command: ");
-		__scsi_print_command(cmd);
+		__scsi_print_command(cmd, logbuf, 80);
+		DPRINTK("command: %s", logbuf);
 	}
 
 	result = scsi_execute_req(ch->device, cmd, direction, buffer,
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index e9c099d..c74cb85 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -394,18 +394,18 @@ static int print_opcode_name(unsigned char * cdbp, int cdb_len,
 }
 #endif
 
-void __scsi_print_command(unsigned char *cdb)
+void __scsi_print_command(unsigned char *cdb, char *buf, int buf_len)
 {
-	char buf[80];
-	int k, len, off = 0;
+	int len, off = 0;
 
-	off = print_opcode_name(cdb, 0, buf, 80);
-	printk("%s", buf);
+	off = print_opcode_name(cdb, 0, buf, buf_len);
 	len = scsi_command_size(cdb);
 	/* print out all bytes in cdb */
-	for (k = 0; k < len; ++k)
-		printk(" %02x", cdb[k]);
-	printk("\n");
+	strcat(buf, ": ");
+	off += 2;
+
+	hex_dump_to_buffer(cdb, len, 32, 1,
+			   buf + off, buf_len - off, false);
 }
 EXPORT_SYMBOL(__scsi_print_command);
 
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 17e0c2b..3e82e66 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -188,6 +188,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 	struct scsi_sense_hdr sshdr;
 	int result, err = 0, retries = 0;
 	struct request_sense *sense = cgc->sense;
+	char logbuf[80];
 
 	SDev = cd->device;
 
@@ -257,14 +258,17 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 				/* sense: Invalid command operation code */
 				err = -EDRIVE_CANT_DO_THIS;
 #ifdef DEBUG
-			__scsi_print_command(cgc->cmd);
+			__scsi_print_command(cgc->cmd, logbuf, 80);
+			sr_printk(KERN_DEBUG, cd,
+				  "CDROM (ioctl) illegal request, "
+				  "command: %s\n", logbuf);
 			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 #endif
 			break;
 		default:
+			__scsi_print_command(cgc->cmd, logbuf, 80);
 			sr_printk(KERN_ERR, cd,
-				  "CDROM (ioctl) error, command: ");
-			__scsi_print_command(cgc->cmd);
+				  "CDROM (ioctl) error, command: %s\n", logbuf);
 			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 			err = -EIO;
 		}
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index a46bc55..e682fe3 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -6,7 +6,7 @@ struct scsi_device;
 struct scsi_sense_hdr;
 
 extern void scsi_print_command(struct scsi_cmnd *);
-extern void __scsi_print_command(unsigned char *);
+extern void __scsi_print_command(unsigned char *, char *, int);
 extern void scsi_show_extd_sense(struct scsi_device *, const char *,
 				 unsigned char, unsigned char);
 extern void scsi_show_sense_hdr(struct scsi_device *, const char *,
-- 
1.8.5.2

