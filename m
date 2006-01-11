From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] sr: split sr_audio_ioctl into specific helpers
Date: Wed, 11 Jan 2006 14:28:06 +0100
Message-ID: <20060111132806.GA9690@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45786 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751535AbWAKN2K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2006 08:28:10 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

split each ioctl handled in sr_audio_ioctl into a function of it's own.
This cleans the code up nicely, and allows various places in sr_ioctl
to call these helpers directly instead of going through the multiplexer.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/sr_ioctl.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sr_ioctl.c	2005-12-15 17:43:41.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/sr_ioctl.c	2006-01-11 14:25:47.000000000 +0100
@@ -31,6 +31,79 @@
 
 module_param(xa_test, int, S_IRUGO | S_IWUSR);
 
+/* primitive to determine whether we need to have GFP_DMA set based on
+ * the status of the unchecked_isa_dma flag in the host structure */
+#define SR_GFP_DMA(cd) (((cd)->device->host->unchecked_isa_dma) ? GFP_DMA : 0)
+
+
+static int sr_read_tochdr(struct cdrom_device_info *cdi,
+		struct cdrom_tochdr *tochdr)
+{
+	struct scsi_cd *cd = cdi->handle;
+	struct packet_command cgc;
+	int result;
+	unsigned char *buffer;
+
+	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	if (!buffer)
+		return -ENOMEM;
+
+	memset(&cgc, 0, sizeof(struct packet_command));
+	cgc.timeout = IOCTL_TIMEOUT;
+	cgc.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
+	cgc.cmd[8] = 12;		/* LSB of length */
+	cgc.buffer = buffer;
+	cgc.buflen = 12;
+	cgc.quiet = 1;
+	cgc.data_direction = DMA_FROM_DEVICE;
+
+	result = sr_do_ioctl(cd, &cgc);
+
+	tochdr->cdth_trk0 = buffer[2];
+	tochdr->cdth_trk1 = buffer[3];
+
+	kfree(buffer);
+	return result;
+}
+
+static int sr_read_tocentry(struct cdrom_device_info *cdi,
+		struct cdrom_tocentry *tocentry)
+{
+	struct scsi_cd *cd = cdi->handle;
+	struct packet_command cgc;
+	int result;
+	unsigned char *buffer;
+
+	buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+	if (!buffer)
+		return -ENOMEM;
+
+	memset(&cgc, 0, sizeof(struct packet_command));
+	cgc.timeout = IOCTL_TIMEOUT;
+	cgc.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
+	cgc.cmd[1] |= (tocentry->cdte_format == CDROM_MSF) ? 0x02 : 0;
+	cgc.cmd[6] = tocentry->cdte_track;
+	cgc.cmd[8] = 12;		/* LSB of length */
+	cgc.buffer = buffer;
+	cgc.buflen = 12;
+	cgc.data_direction = DMA_FROM_DEVICE;
+
+	result = sr_do_ioctl(cd, &cgc);
+
+	tocentry->cdte_ctrl = buffer[5] & 0xf;
+	tocentry->cdte_adr = buffer[5] >> 4;
+	tocentry->cdte_datamode = (tocentry->cdte_ctrl & 0x04) ? 1 : 0;
+	if (tocentry->cdte_format == CDROM_MSF) {
+		tocentry->cdte_addr.msf.minute = buffer[9];
+		tocentry->cdte_addr.msf.second = buffer[10];
+		tocentry->cdte_addr.msf.frame = buffer[11];
+	} else
+		tocentry->cdte_addr.lba = (((((buffer[8] << 8) + buffer[9]) << 8)
+			+ buffer[10]) << 8) + buffer[11];
+
+	kfree(buffer);
+	return result;
+}
 
 #define IOCTL_RETRIES 3
 
@@ -45,7 +118,8 @@
 	struct packet_command cgc;
 	int ntracks, ret;
 
-	if ((ret = sr_audio_ioctl(cdi, CDROMREADTOCHDR, &tochdr)))
+	ret = sr_read_tochdr(cdi, &tochdr);
+	if (ret)
 		return ret;
 
 	ntracks = tochdr.cdth_trk1 - tochdr.cdth_trk0 + 1;
@@ -60,9 +134,11 @@
 	trk1_te.cdte_track = ti->cdti_trk1;
 	trk1_te.cdte_format = CDROM_MSF;
 	
-	if ((ret = sr_audio_ioctl(cdi, CDROMREADTOCENTRY, &trk0_te)))
+	ret = sr_read_tocentry(cdi, &trk0_te);
+	if (ret)
 		return ret;
-	if ((ret = sr_audio_ioctl(cdi, CDROMREADTOCENTRY, &trk1_te)))
+	ret = sr_read_tocentry(cdi, &trk1_te);
+	if (ret)
 		return ret;
 
 	memset(&cgc, 0, sizeof(struct packet_command));
@@ -78,6 +154,30 @@
 	return sr_do_ioctl(cdi->handle, &cgc);
 }
 
+static int sr_play_trkind(struct cdrom_device_info *cdi,
+		struct cdrom_ti *ti)
+
+{
+	struct scsi_cd *cd = cdi->handle;
+	struct packet_command cgc;
+	int result;
+
+	memset(&cgc, 0, sizeof(struct packet_command));
+	cgc.timeout = IOCTL_TIMEOUT;
+	cgc.cmd[0] = GPCMD_PLAYAUDIO_TI;
+	cgc.cmd[4] = ti->cdti_trk0;
+	cgc.cmd[5] = ti->cdti_ind0;
+	cgc.cmd[7] = ti->cdti_trk1;
+	cgc.cmd[8] = ti->cdti_ind1;
+	cgc.data_direction = DMA_NONE;
+
+	result = sr_do_ioctl(cd, &cgc);
+	if (result == -EDRIVE_CANT_DO_THIS)
+		result = sr_fake_playtrkind(cdi, ti);
+
+	return result;
+}
+
 /* We do our own retries because we want to know what the specific
    error code is.  Normally the UNIT_ATTENTION code will automatically
    clear after one error */
@@ -229,13 +329,14 @@
 	int i, rc, have_datatracks = 0;
 
 	/* look for data tracks */
-	if (0 != (rc = sr_audio_ioctl(cdi, CDROMREADTOCHDR, &toc_h)))
+	rc = sr_read_tochdr(cdi, &toc_h);
+	if (rc)
 		return (rc == -ENOMEDIUM) ? CDS_NO_DISC : CDS_NO_INFO;
 
 	for (i = toc_h.cdth_trk0; i <= toc_h.cdth_trk1; i++) {
 		toc_e.cdte_track = i;
 		toc_e.cdte_format = CDROM_LBA;
-		if (sr_audio_ioctl(cdi, CDROMREADTOCENTRY, &toc_e))
+		if (sr_read_tocentry(cdi, &toc_e))
 			return CDS_NO_INFO;
 		if (toc_e.cdte_ctrl & CDROM_DATA_TRACK) {
 			have_datatracks = 1;
@@ -262,10 +363,6 @@
 	return 0;
 }
 
-/* primitive to determine whether we need to have GFP_DMA set based on
- * the status of the unchecked_isa_dma flag in the host structure */
-#define SR_GFP_DMA(cd) (((cd)->device->host->unchecked_isa_dma) ? GFP_DMA : 0)
-
 int sr_get_mcn(struct cdrom_device_info *cdi, struct cdrom_mcn *mcn)
 {
 	Scsi_CD *cd = cdi->handle;
@@ -329,93 +426,16 @@
 
 int sr_audio_ioctl(struct cdrom_device_info *cdi, unsigned int cmd, void *arg)
 {
-	Scsi_CD *cd = cdi->handle;
-	struct packet_command cgc;
-	int result;
-	unsigned char *buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
-
-	if (!buffer)
-		return -ENOMEM;
-
-	memset(&cgc, 0, sizeof(struct packet_command));
-	cgc.timeout = IOCTL_TIMEOUT;
-
 	switch (cmd) {
 	case CDROMREADTOCHDR:
-		{
-			struct cdrom_tochdr *tochdr = (struct cdrom_tochdr *) arg;
-
-			cgc.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
-			cgc.cmd[8] = 12;		/* LSB of length */
-			cgc.buffer = buffer;
-			cgc.buflen = 12;
-			cgc.quiet = 1;
-			cgc.data_direction = DMA_FROM_DEVICE;
-
-			result = sr_do_ioctl(cd, &cgc);
-
-			tochdr->cdth_trk0 = buffer[2];
-			tochdr->cdth_trk1 = buffer[3];
-
-			break;
-		}
-
+		return sr_read_tochdr(cdi, arg);
 	case CDROMREADTOCENTRY:
-		{
-			struct cdrom_tocentry *tocentry = (struct cdrom_tocentry *) arg;
-
-			cgc.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
-			cgc.cmd[1] |= (tocentry->cdte_format == CDROM_MSF) ? 0x02 : 0;
-			cgc.cmd[6] = tocentry->cdte_track;
-			cgc.cmd[8] = 12;		/* LSB of length */
-			cgc.buffer = buffer;
-			cgc.buflen = 12;
-			cgc.data_direction = DMA_FROM_DEVICE;
-
-			result = sr_do_ioctl(cd, &cgc);
-
-			tocentry->cdte_ctrl = buffer[5] & 0xf;
-			tocentry->cdte_adr = buffer[5] >> 4;
-			tocentry->cdte_datamode = (tocentry->cdte_ctrl & 0x04) ? 1 : 0;
-			if (tocentry->cdte_format == CDROM_MSF) {
-				tocentry->cdte_addr.msf.minute = buffer[9];
-				tocentry->cdte_addr.msf.second = buffer[10];
-				tocentry->cdte_addr.msf.frame = buffer[11];
-			} else
-				tocentry->cdte_addr.lba = (((((buffer[8] << 8) + buffer[9]) << 8)
-					+ buffer[10]) << 8) + buffer[11];
-
-			break;
-		}
-
-	case CDROMPLAYTRKIND: {
-		struct cdrom_ti* ti = (struct cdrom_ti*)arg;
-
-		cgc.cmd[0] = GPCMD_PLAYAUDIO_TI;
-		cgc.cmd[4] = ti->cdti_trk0;
-		cgc.cmd[5] = ti->cdti_ind0;
-		cgc.cmd[7] = ti->cdti_trk1;
-		cgc.cmd[8] = ti->cdti_ind1;
-		cgc.data_direction = DMA_NONE;
-
-		result = sr_do_ioctl(cd, &cgc);
-		if (result == -EDRIVE_CANT_DO_THIS)
-			result = sr_fake_playtrkind(cdi, ti);
-
-		break;
-	}
-
+		return sr_read_tocentry(cdi, arg);
+	case CDROMPLAYTRKIND:
+		return sr_play_trkind(cdi, arg);
 	default:
-		result = -EINVAL;
+		return -EINVAL;
 	}
-
-#if 0
-	if (result)
-		printk("DEBUG: sr_audio: result for ioctl %x: %x\n", cmd, result);
-#endif
-
-	kfree(buffer);
-	return result;
 }
 
 /* -----------------------------------------------------------------------
