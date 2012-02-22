From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 18/34] scsi proc_ops: convert drivers/scsi/ips.c
Date: Wed, 22 Feb 2012 22:46:09 +0300
Message-ID: <1329939985-26793-18-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59220 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2BVTrG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:06 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433763bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:05 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/ips.c |  176 ++++++++++++++--------------------------------------
 drivers/scsi/ips.h |    9 ---
 2 files changed, 46 insertions(+), 139 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index d77891e..6e960cc 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -174,6 +174,7 @@
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/reboot.h>
+#include <linux/seq_file.h>
 #include <linux/interrupt.h>
 
 #include <linux/blkdev.h>
@@ -326,10 +327,8 @@ static void ips_scmd_buf_write(struct scsi_cmnd * scmd, void *data,
 static void ips_scmd_buf_read(struct scsi_cmnd * scmd, void *data,
 			      unsigned int count);
 
-static int ips_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
-static int ips_host_info(ips_ha_t *, char *, off_t, int);
-static void copy_mem_info(IPS_INFOSTR *, char *, int);
-static int copy_info(IPS_INFOSTR *, char *, ...);
+static const struct file_operations ips_proc_ops;
+static void ips_host_info(ips_ha_t *, struct seq_file *);
 static int ips_abort_init(ips_ha_t * ha, int index);
 static int ips_init_phase2(int index);
 
@@ -367,7 +366,7 @@ static struct scsi_host_template ips_driver_template = {
 	.eh_abort_handler	= ips_eh_abort,
 	.eh_host_reset_handler	= ips_eh_reset,
 	.proc_name		= "ips",
-	.proc_info		= ips_proc_info,
+	.proc_ops		= &ips_proc_ops,
 	.slave_configure	= ips_slave_configure,
 	.bios_param		= ips_biosparam,
 	.this_id		= -1,
@@ -1433,25 +1432,12 @@ ips_info(struct Scsi_Host *SH)
 	return (bp);
 }
 
-/****************************************************************************/
-/*                                                                          */
-/* Routine Name: ips_proc_info                                              */
-/*                                                                          */
-/* Routine Description:                                                     */
-/*                                                                          */
-/*   The passthru interface for the driver                                  */
-/*                                                                          */
-/****************************************************************************/
-static int
-ips_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-	      int length, int func)
+static int ips_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *host = m->private;
 	int i;
-	int ret;
 	ips_ha_t *ha = NULL;
 
-	METHOD_TRACE("ips_proc_info", 1);
-
 	/* Find our host structure */
 	for (i = 0; i < ips_next_controller; i++) {
 		if (ips_sh[i]) {
@@ -1465,20 +1451,22 @@ ips_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
 	if (!ha)
 		return (-EINVAL);
 
-	if (func) {
-		/* write */
-		return (0);
-	} else {
-		/* read */
-		if (start)
-			*start = buffer;
-
-		ret = ips_host_info(ha, buffer, offset, length);
+	ips_host_info(ha, m);
+	return 0;
+}
 
-		return (ret);
-	}
+static int ips_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ips_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations ips_proc_ops = {
+	.open		= ips_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*--------------------------------------------------------------------------*/
 /* Helper Functions                                                         */
 /*--------------------------------------------------------------------------*/
@@ -2034,51 +2022,43 @@ ips_cleanup_passthru(ips_ha_t * ha, ips_scb_t * scb)
 /*   The passthru interface for the driver                                  */
 /*                                                                          */
 /****************************************************************************/
-static int
-ips_host_info(ips_ha_t * ha, char *ptr, off_t offset, int len)
+static void
+ips_host_info(ips_ha_t * ha, struct seq_file *m)
 {
-	IPS_INFOSTR info;
-
 	METHOD_TRACE("ips_host_info", 1);
 
-	info.buffer = ptr;
-	info.length = len;
-	info.offset = offset;
-	info.pos = 0;
-	info.localpos = 0;
-
-	copy_info(&info, "\nIBM ServeRAID General Information:\n\n");
+	seq_printf(m, "\nIBM ServeRAID General Information:\n\n");
 
 	if ((le32_to_cpu(ha->nvram->signature) == IPS_NVRAM_P5_SIG) &&
 	    (le16_to_cpu(ha->nvram->adapter_type) != 0))
-		copy_info(&info, "\tController Type                   : %s\n",
+		seq_printf(m, "\tController Type                   : %s\n",
 			  ips_adapter_name[ha->ad_type - 1]);
 	else
-		copy_info(&info,
+		seq_printf(m,
 			  "\tController Type                   : Unknown\n");
 
 	if (ha->io_addr)
-		copy_info(&info,
-			  "\tIO region                         : 0x%lx (%d bytes)\n",
+		seq_printf(m,
+			  "\tIO region                         : 0x%x (%d bytes)\n",
 			  ha->io_addr, ha->io_len);
 
 	if (ha->mem_addr) {
-		copy_info(&info,
-			  "\tMemory region                     : 0x%lx (%d bytes)\n",
+		seq_printf(m,
+			  "\tMemory region                     : 0x%x (%d bytes)\n",
 			  ha->mem_addr, ha->mem_len);
-		copy_info(&info,
-			  "\tShared memory address             : 0x%lx\n",
+		seq_printf(m,
+			  "\tShared memory address             : %p\n",
 			  ha->mem_ptr);
 	}
 
-	copy_info(&info, "\tIRQ number                        : %d\n", ha->pcidev->irq);
+	seq_printf(m, "\tIRQ number                        : %d\n", ha->pcidev->irq);
 
     /* For the Next 3 lines Check for Binary 0 at the end and don't include it if it's there. */
     /* That keeps everything happy for "text" operations on the proc file.                    */
 
 	if (le32_to_cpu(ha->nvram->signature) == IPS_NVRAM_P5_SIG) {
 	if (ha->nvram->bios_low[3] == 0) {
-            copy_info(&info,
+            seq_printf(m,
 			          "\tBIOS Version                      : %c%c%c%c%c%c%c\n",
 			          ha->nvram->bios_high[0], ha->nvram->bios_high[1],
 			          ha->nvram->bios_high[2], ha->nvram->bios_high[3],
@@ -2086,7 +2066,7 @@ ips_host_info(ips_ha_t * ha, char *ptr, off_t offset, int len)
 			          ha->nvram->bios_low[2]);
 
         } else {
-		    copy_info(&info,
+		    seq_printf(m,
 			          "\tBIOS Version                      : %c%c%c%c%c%c%c%c\n",
 			          ha->nvram->bios_high[0], ha->nvram->bios_high[1],
 			          ha->nvram->bios_high[2], ha->nvram->bios_high[3],
@@ -2097,14 +2077,14 @@ ips_host_info(ips_ha_t * ha, char *ptr, off_t offset, int len)
     }
 
     if (ha->enq->CodeBlkVersion[7] == 0) {
-        copy_info(&info,
+        seq_printf(m,
 		          "\tFirmware Version                  : %c%c%c%c%c%c%c\n",
 		          ha->enq->CodeBlkVersion[0], ha->enq->CodeBlkVersion[1],
 		          ha->enq->CodeBlkVersion[2], ha->enq->CodeBlkVersion[3],
 		          ha->enq->CodeBlkVersion[4], ha->enq->CodeBlkVersion[5],
 		          ha->enq->CodeBlkVersion[6]);
     } else {
-        copy_info(&info,
+        seq_printf(m,
 		          "\tFirmware Version                  : %c%c%c%c%c%c%c%c\n",
 		          ha->enq->CodeBlkVersion[0], ha->enq->CodeBlkVersion[1],
 		          ha->enq->CodeBlkVersion[2], ha->enq->CodeBlkVersion[3],
@@ -2113,14 +2093,14 @@ ips_host_info(ips_ha_t * ha, char *ptr, off_t offset, int len)
     }
 
     if (ha->enq->BootBlkVersion[7] == 0) {
-        copy_info(&info,
+        seq_printf(m,
 		          "\tBoot Block Version                : %c%c%c%c%c%c%c\n",
 		          ha->enq->BootBlkVersion[0], ha->enq->BootBlkVersion[1],
 		          ha->enq->BootBlkVersion[2], ha->enq->BootBlkVersion[3],
 		          ha->enq->BootBlkVersion[4], ha->enq->BootBlkVersion[5],
 		          ha->enq->BootBlkVersion[6]);
     } else {
-        copy_info(&info,
+        seq_printf(m,
 		          "\tBoot Block Version                : %c%c%c%c%c%c%c%c\n",
 		          ha->enq->BootBlkVersion[0], ha->enq->BootBlkVersion[1],
 		          ha->enq->BootBlkVersion[2], ha->enq->BootBlkVersion[3],
@@ -2128,90 +2108,26 @@ ips_host_info(ips_ha_t * ha, char *ptr, off_t offset, int len)
 		          ha->enq->BootBlkVersion[6], ha->enq->BootBlkVersion[7]);
     }
 
-	copy_info(&info, "\tDriver Version                    : %s%s\n",
+	seq_printf(m, "\tDriver Version                    : %s%s\n",
 		  IPS_VERSION_HIGH, IPS_VERSION_LOW);
 
-	copy_info(&info, "\tDriver Build                      : %d\n",
+	seq_printf(m, "\tDriver Build                      : %d\n",
 		  IPS_BUILD_IDENT);
 
-	copy_info(&info, "\tMax Physical Devices              : %d\n",
+	seq_printf(m, "\tMax Physical Devices              : %d\n",
 		  ha->enq->ucMaxPhysicalDevices);
-	copy_info(&info, "\tMax Active Commands               : %d\n",
+	seq_printf(m, "\tMax Active Commands               : %d\n",
 		  ha->max_cmds);
-	copy_info(&info, "\tCurrent Queued Commands           : %d\n",
+	seq_printf(m, "\tCurrent Queued Commands           : %d\n",
 		  ha->scb_waitlist.count);
-	copy_info(&info, "\tCurrent Active Commands           : %d\n",
+	seq_printf(m, "\tCurrent Active Commands           : %d\n",
 		  ha->scb_activelist.count - ha->num_ioctl);
-	copy_info(&info, "\tCurrent Queued PT Commands        : %d\n",
+	seq_printf(m, "\tCurrent Queued PT Commands        : %d\n",
 		  ha->copp_waitlist.count);
-	copy_info(&info, "\tCurrent Active PT Commands        : %d\n",
+	seq_printf(m, "\tCurrent Active PT Commands        : %d\n",
 		  ha->num_ioctl);
 
-	copy_info(&info, "\n");
-
-	return (info.localpos);
-}
-
-/****************************************************************************/
-/*                                                                          */
-/* Routine Name: copy_mem_info                                              */
-/*                                                                          */
-/* Routine Description:                                                     */
-/*                                                                          */
-/*   Copy data into an IPS_INFOSTR structure                                */
-/*                                                                          */
-/****************************************************************************/
-static void
-copy_mem_info(IPS_INFOSTR * info, char *data, int len)
-{
-	METHOD_TRACE("copy_mem_info", 1);
-
-	if (info->pos + len < info->offset) {
-		info->pos += len;
-		return;
-	}
-
-	if (info->pos < info->offset) {
-		data += (info->offset - info->pos);
-		len -= (info->offset - info->pos);
-		info->pos += (info->offset - info->pos);
-	}
-
-	if (info->localpos + len > info->length)
-		len = info->length - info->localpos;
-
-	if (len > 0) {
-		memcpy(info->buffer + info->localpos, data, len);
-		info->pos += len;
-		info->localpos += len;
-	}
-}
-
-/****************************************************************************/
-/*                                                                          */
-/* Routine Name: copy_info                                                  */
-/*                                                                          */
-/* Routine Description:                                                     */
-/*                                                                          */
-/*   printf style wrapper for an info structure                             */
-/*                                                                          */
-/****************************************************************************/
-static int
-copy_info(IPS_INFOSTR * info, char *fmt, ...)
-{
-	va_list args;
-	char buf[128];
-	int len;
-
-	METHOD_TRACE("copy_info", 1);
-
-	va_start(args, fmt);
-	len = vsprintf(buf, fmt, args);
-	va_end(args);
-
-	copy_mem_info(info, buf, len);
-
-	return (len);
+	seq_printf(m, "\n");
 }
 
 /****************************************************************************/
diff --git a/drivers/scsi/ips.h b/drivers/scsi/ips.h
index f2df059..45b9566 100644
--- a/drivers/scsi/ips.h
+++ b/drivers/scsi/ips.h
@@ -416,7 +416,6 @@
    /*
     * Scsi_Host Template
     */
-   static int ips_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
    static int ips_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int geom[]);
    static int ips_slave_configure(struct scsi_device *SDptr);
@@ -959,14 +958,6 @@ typedef union {
    IPS_ENH_SG_LIST  *enh_list;
 } IPS_SG_LIST;
 
-typedef struct _IPS_INFOSTR {
-   char *buffer;
-   int   length;
-   int   offset;
-   int   pos;
-   int   localpos;
-} IPS_INFOSTR;
-
 typedef struct {
    char *option_name;
    int  *option_flag;
-- 
1.7.3.4

