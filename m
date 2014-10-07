From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/26] scsi: repurpose the last argument from print_opcode_name()
Date: Tue,  7 Oct 2014 11:03:16 +0200
Message-ID: <1412672605-42868-18-git-send-email-hare@suse.de>
References: <1412672605-42868-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbaJGJDf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 05:03:35 -0400
In-Reply-To: <1412672605-42868-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

print_opcode_name() was only ever called with a '0' argument
from LLDDs and ULDs which were _not_ supporting variable length
CDBs, so the 'if' clause was never triggered.
Instead we should be using the last argument to specify
the cdb length to avoid accidental overflow when reading
the cdb buffer.

Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/arm/fas216.c |  2 +-
 drivers/scsi/ch.c         | 24 +++++++++++++-----------
 drivers/scsi/constants.c  | 25 ++++++++++---------------
 drivers/scsi/sr_ioctl.c   |  4 ++--
 include/scsi/scsi_dbg.h   |  2 +-
 5 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index cea3463..d2581cb 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2424,7 +2424,7 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
 	info->stats.aborts += 1;
 
 	printk(KERN_WARNING "scsi%d: abort command ", info->host->host_no);
-	__scsi_print_command(SCpnt->cmnd);
+	__scsi_print_command(SCpnt->cmnd, SCpnt->cmd_len);
 
 	print_debug_list();
 	fas216_dumpstate(info);
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 53621a3..226ef77 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -182,7 +182,7 @@ static int ch_find_errno(struct scsi_sense_hdr *sshdr)
 }
 
 static int
-ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
+ch_do_scsi(scsi_changer *ch, unsigned char *cmd, int cmd_len,
 	   void *buffer, unsigned buflength,
 	   enum dma_data_direction direction)
 {
@@ -196,7 +196,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
 	errno = 0;
 	if (debug) {
 		DPRINTK("command: ");
-		__scsi_print_command(cmd);
+		__scsi_print_command(cmd, cmd_len);
 	}
 
 	result = scsi_execute_req(ch->device, cmd, direction, buffer,
@@ -257,7 +257,8 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
 	cmd[3] = elem        & 0xff;
 	cmd[5] = 1;
 	cmd[9] = 255;
-	if (0 == (result = ch_do_scsi(ch, cmd, buffer, 256, DMA_FROM_DEVICE))) {
+	if (0 == (result = ch_do_scsi(ch, cmd, 12,
+				      buffer, 256, DMA_FROM_DEVICE))) {
 		if (((buffer[16] << 8) | buffer[17]) != elem) {
 			DPRINTK("asked for element 0x%02x, got 0x%02x\n",
 				elem,(buffer[16] << 8) | buffer[17]);
@@ -287,7 +288,7 @@ ch_init_elem(scsi_changer *ch)
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
 	cmd[1] = (ch->device->lun & 0x7) << 5;
-	err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
+	err = ch_do_scsi(ch, cmd, 6, NULL, 0, DMA_NONE);
 	VPRINTK(KERN_INFO, "... finished\n");
 	return err;
 }
@@ -309,10 +310,10 @@ ch_readconfig(scsi_changer *ch)
 	cmd[1] = (ch->device->lun & 0x7) << 5;
 	cmd[2] = 0x1d;
 	cmd[4] = 255;
-	result = ch_do_scsi(ch, cmd, buffer, 255, DMA_FROM_DEVICE);
+	result = ch_do_scsi(ch, cmd, 10, buffer, 255, DMA_FROM_DEVICE);
 	if (0 != result) {
 		cmd[1] |= (1<<3);
-		result  = ch_do_scsi(ch, cmd, buffer, 255, DMA_FROM_DEVICE);
+		result  = ch_do_scsi(ch, cmd, 10, buffer, 255, DMA_FROM_DEVICE);
 	}
 	if (0 == result) {
 		ch->firsts[CHET_MT] =
@@ -437,7 +438,7 @@ ch_position(scsi_changer *ch, u_int trans, u_int elem, int rotate)
 	cmd[4]  = (elem  >> 8) & 0xff;
 	cmd[5]  =  elem        & 0xff;
 	cmd[8]  = rotate ? 1 : 0;
-	return ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 10, NULL, 0, DMA_NONE);
 }
 
 static int
@@ -458,7 +459,7 @@ ch_move(scsi_changer *ch, u_int trans, u_int src, u_int dest, int rotate)
 	cmd[6]  = (dest  >> 8) & 0xff;
 	cmd[7]  =  dest        & 0xff;
 	cmd[10] = rotate ? 1 : 0;
-	return ch_do_scsi(ch, cmd, NULL,0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 12, NULL,0, DMA_NONE);
 }
 
 static int
@@ -484,7 +485,7 @@ ch_exchange(scsi_changer *ch, u_int trans, u_int src,
 	cmd[9]  =  dest2       & 0xff;
 	cmd[10] = (rotate1 ? 1 : 0) | (rotate2 ? 2 : 0);
 
-	return ch_do_scsi(ch, cmd, NULL,0, DMA_NONE);
+	return ch_do_scsi(ch, cmd, 12, NULL, 0, DMA_NONE);
 }
 
 static void
@@ -534,7 +535,7 @@ ch_set_voltag(scsi_changer *ch, u_int elem,
 	memcpy(buffer,tag,32);
 	ch_check_voltag(buffer);
 
-	result = ch_do_scsi(ch, cmd, buffer, 256, DMA_TO_DEVICE);
+	result = ch_do_scsi(ch, cmd, 12, buffer, 256, DMA_TO_DEVICE);
 	kfree(buffer);
 	return result;
 }
@@ -765,7 +766,8 @@ static long ch_ioctl(struct file *file,
 		ch_cmd[5] = 1;
 		ch_cmd[9] = 255;
 
-		result = ch_do_scsi(ch, ch_cmd, buffer, 256, DMA_FROM_DEVICE);
+		result = ch_do_scsi(ch, ch_cmd, 12,
+				    buffer, 256, DMA_FROM_DEVICE);
 		if (!result) {
 			cge.cge_status = buffer[18];
 			cge.cge_flags = 0;
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 80a9942..ea391f8 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -320,25 +320,21 @@ static bool scsi_opcode_sa_name(int opcode, int service_action,
 	return true;
 }
 
-/* attempt to guess cdb length if cdb_len==0 . No trailing linefeed. */
-static void print_opcode_name(unsigned char * cdbp, int cdb_len)
+static void print_opcode_name(const unsigned char *cdbp, size_t cdb_len)
 {
-	int sa, len, cdb0;
+	int sa, cdb0;
 	const char *cdb_name = NULL, *sa_name = NULL;
 
 	cdb0 = cdbp[0];
 	if (cdb0 == VARIABLE_LENGTH_CMD) {
-		len = scsi_varlen_cdb_length(cdbp);
-		if (len < 10) {
-			printk("short variable length command, "
-			       "len=%d ext_len=%d", len, cdb_len);
+		if (cdb_len < 10) {
+			printk("short variable length command, len=%zu",
+			       cdb_len);
 			return;
 		}
 		sa = (cdbp[8] << 8) + cdbp[9];
-	} else {
+	} else
 		sa = cdbp[1] & 0x1f;
-		len = cdb_len;
-	}
 
 	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
 		if (cdb_name)
@@ -356,18 +352,17 @@ static void print_opcode_name(unsigned char * cdbp, int cdb_len)
 			printk("%s, sa=0x%x", cdb_name, sa);
 		else
 			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
-
-		if (cdb_len > 0 && len != cdb_len)
-			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
 	}
 }
 
-void __scsi_print_command(unsigned char *cdb)
+void __scsi_print_command(const unsigned char *cdb, size_t cdb_len)
 {
 	int k, len;
 
-	print_opcode_name(cdb, 0);
+	print_opcode_name(cdb, cdb_len);
 	len = scsi_command_size(cdb);
+	if (cdb_len < len)
+		len = cdb_len;
 	/* print out all bytes in cdb */
 	for (k = 0; k < len; ++k)
 		printk(" %02x", cdb[k]);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 17e0c2b..fb929fa 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -257,14 +257,14 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 				/* sense: Invalid command operation code */
 				err = -EDRIVE_CANT_DO_THIS;
 #ifdef DEBUG
-			__scsi_print_command(cgc->cmd);
+			__scsi_print_command(cgc->cmd, CDROM_PACKET_SIZE);
 			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 #endif
 			break;
 		default:
 			sr_printk(KERN_ERR, cd,
 				  "CDROM (ioctl) error, command: ");
-			__scsi_print_command(cgc->cmd);
+			__scsi_print_command(cgc->cmd, CDROM_PACKET_SIZE);
 			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 			err = -EIO;
 		}
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 386474e..81d0418 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -6,7 +6,7 @@ struct scsi_device;
 struct scsi_sense_hdr;
 
 extern void scsi_print_command(struct scsi_cmnd *);
-extern void __scsi_print_command(unsigned char *);
+extern void __scsi_print_command(const unsigned char *, size_t);
 extern void scsi_show_extd_sense(const struct scsi_device *, const char *,
 				 unsigned char, unsigned char);
 extern void scsi_show_sense_hdr(const struct scsi_device *, const char *,
-- 
1.8.5.2

