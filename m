From: "Luiz Fernando N. Capitulino" <lcapitulino@prefeitura.sp.gov.br>
Subject: [PATCH] - fix possible bug in scsi/sr_ioctl.c.
Date: Wed, 26 May 2004 18:41:21 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040526214121.GE1314@lorien.prodam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sampa7.prodam.sp.gov.br ([200.230.190.107]:31499 "EHLO
	sampa7.prodam.sp.gov.br") by vger.kernel.org with ESMTP
	id S265822AbUEZVoS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 May 2004 17:44:18 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org


 Hi,

 In scsci/sr_ioctl.c::sr_audio_ioctl() (line 329) there is a
possible bug (found by coverity's checker): if kmalloc() returns NULL,
the contents of `buffer' will be used in the body of `case CDROMREADTOCHDR',
and `case CDROMREADTOCENTRY' whitout any memory allocated.

 The patch bellow fix that. My suggestion is to put de definition
of `buffer' only in the places where it is used, because in
`case CDROMPLAYTRKIND' don't use it, so it does not need to
allocate it.

 drivers/scsi/sr_ioctl.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)


diff -X dontdiff -Nparu a/drivers/scsi/sr_ioctl.c a~/drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c	2003-10-08 16:24:17.000000000 -0300
+++ a~/drivers/scsi/sr_ioctl.c	2004-05-26 18:05:51.000000000 -0300
@@ -329,7 +329,6 @@ int sr_audio_ioctl(struct cdrom_device_i
 	Scsi_CD *cd = cdi->handle;
 	struct cdrom_generic_command cgc;
 	int result;
-	unsigned char *buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
 
 	memset(&cgc, 0, sizeof(struct cdrom_generic_command));
 	cgc.timeout = IOCTL_TIMEOUT;
@@ -338,6 +337,9 @@ int sr_audio_ioctl(struct cdrom_device_i
 	case CDROMREADTOCHDR:
 		{
 			struct cdrom_tochdr *tochdr = (struct cdrom_tochdr *) arg;
+			unsigned char *buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+			if (!buffer)
+				return -ENOMEM;
 
 			cgc.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
 			cgc.cmd[8] = 12;		/* LSB of length */
@@ -351,12 +353,16 @@ int sr_audio_ioctl(struct cdrom_device_i
 			tochdr->cdth_trk0 = buffer[2];
 			tochdr->cdth_trk1 = buffer[3];
 
+			kfree(buffer);
 			break;
 		}
 
 	case CDROMREADTOCENTRY:
 		{
 			struct cdrom_tocentry *tocentry = (struct cdrom_tocentry *) arg;
+			unsigned char *buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
+			if (!buffer)
+				return -ENOMEM;
 
 			cgc.cmd[0] = GPCMD_READ_TOC_PMA_ATIP;
 			cgc.cmd[1] |= (tocentry->cdte_format == CDROM_MSF) ? 0x02 : 0;
@@ -379,6 +385,7 @@ int sr_audio_ioctl(struct cdrom_device_i
 				tocentry->cdte_addr.lba = (((((buffer[8] << 8) + buffer[9]) << 8)
 					+ buffer[10]) << 8) + buffer[11];
 
+			kfree(buffer);
 			break;
 		}
 
@@ -408,7 +415,6 @@ int sr_audio_ioctl(struct cdrom_device_i
 		printk("DEBUG: sr_audio: result for ioctl %x: %x\n", cmd, result);
 #endif
 
-	kfree(buffer);
 	return result;
 }
 
-- 
Luiz Fernando N. Capitulino
<http://www.telecentros.sp.gov.br>
