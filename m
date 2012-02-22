From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 22/34] scsi proc_ops: convert drivers/scsi/dpt_i2o.c
Date: Wed, 22 Feb 2012 22:46:13 +0300
Message-ID: <1329939985-26793-22-git-send-email-adobriyan@gmail.com>
References: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44011 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab2BVTrN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2012 14:47:13 -0500
Received: by mail-bk0-f46.google.com with SMTP id jm19so433831bkc.19
        for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2012 11:47:12 -0800 (PST)
In-Reply-To: <1329939985-26793-1-git-send-email-adobriyan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/scsi/dpt_i2o.c |  112 +++++++++++-------------------------------------
 1 files changed, 25 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index b4f6c9a..46c4c5f 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -48,6 +48,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Driver");
 #include <linux/interrupt.h>
 #include <linux/kernel.h>	/* for printk */
 #include <linux/sched.h>
+#include <linux/seq_file.h>
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
@@ -553,36 +554,15 @@ static const char *adpt_info(struct Scsi_Host *host)
 	return (char *) (pHba->detail);
 }
 
-static int adpt_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset,
-		  int length, int inout)
+static int adpt_proc_show(struct seq_file *m, void *v)
 {
+	struct Scsi_Host *host = m->private;
 	struct adpt_device* d;
 	int id;
 	int chan;
-	int len = 0;
-	int begin = 0;
-	int pos = 0;
 	adpt_hba* pHba;
 	int unit;
 
-	*start = buffer;
-	if (inout == TRUE) {
-		/*
-		 * The user has done a write and wants us to take the
-		 * data in the buffer and do something with it.
-		 * proc_scsiwrite calls us with inout = 1
-		 *
-		 * Read data from buffer (writing to us) - NOT SUPPORTED
-		 */
-		return -EINVAL;
-	}
-
-	/*
-	 * inout = 0 means the user has done a read and wants information
-	 * returned, so we write information about the cards into the buffer
-	 * proc_scsiread() calls us with inout = 0
-	 */
-
 	// Find HBA (host bus adapter) we are looking for
 	mutex_lock(&adpt_configuration_lock);
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
@@ -596,88 +576,46 @@ static int adpt_proc_info(struct Scsi_Host *host, char *buffer, char **start, of
 	}
 	host = pHba->host;
 
-	len  = sprintf(buffer    , "Adaptec I2O RAID Driver Version: %s\n\n", DPT_I2O_VERSION);
-	len += sprintf(buffer+len, "%s\n", pHba->detail);
-	len += sprintf(buffer+len, "SCSI Host=scsi%d  Control Node=/dev/%s  irq=%d\n", 
+	seq_printf(m, "Adaptec I2O RAID Driver Version: %s\n\n", DPT_I2O_VERSION);
+	seq_printf(m, "%s\n", pHba->detail);
+	seq_printf(m, "SCSI Host=scsi%d  Control Node=/dev/%s  irq=%d\n", 
 			pHba->host->host_no, pHba->name, host->irq);
-	len += sprintf(buffer+len, "\tpost fifo size  = %d\n\treply fifo size = %d\n\tsg table size   = %d\n\n",
+	seq_printf(m, "\tpost fifo size  = %d\n\treply fifo size = %d\n\tsg table size   = %d\n\n",
 			host->can_queue, (int) pHba->reply_fifo_size , host->sg_tablesize);
 
-	pos = begin + len;
-
-	/* CHECKPOINT */
-	if(pos > offset + length) {
-		goto stop_output;
-	}
-	if(pos <= offset) {
-		/*
-		 * If we haven't even written to where we last left
-		 * off (the last time we were called), reset the 
-		 * beginning pointer.
-		 */
-		len = 0;
-		begin = pos;
-	}
-	len +=  sprintf(buffer+len, "Devices:\n");
+	seq_printf(m, "Devices:\n");
 	for(chan = 0; chan < MAX_CHANNEL; chan++) {
 		for(id = 0; id < MAX_ID; id++) {
 			d = pHba->channel[chan].device[id];
 			while(d){
-				len += sprintf(buffer+len,"\t%-24.24s", d->pScsi_dev->vendor);
-				len += sprintf(buffer+len," Rev: %-8.8s\n", d->pScsi_dev->rev);
-				pos = begin + len;
-
-
-				/* CHECKPOINT */
-				if(pos > offset + length) {
-					goto stop_output;
-				}
-				if(pos <= offset) {
-					len = 0;
-					begin = pos;
-				}
+				seq_printf(m, "\t%-24.24s", d->pScsi_dev->vendor);
+				seq_printf(m, " Rev: %-8.8s\n", d->pScsi_dev->rev);
 
 				unit = d->pI2o_dev->lct_data.tid;
-				len += sprintf(buffer+len, "\tTID=%d, (Channel=%d, Target=%d, Lun=%d)  (%s)\n\n",
+				seq_printf(m, "\tTID=%d, (Channel=%d, Target=%d, Lun=%d)  (%s)\n\n",
 					       unit, (int)d->scsi_channel, (int)d->scsi_id, (int)d->scsi_lun,
 					       scsi_device_online(d->pScsi_dev)? "online":"offline"); 
-				pos = begin + len;
-
-				/* CHECKPOINT */
-				if(pos > offset + length) {
-					goto stop_output;
-				}
-				if(pos <= offset) {
-					len = 0;
-					begin = pos;
-				}
 
 				d = d->next_lun;
 			}
 		}
 	}
 
-	/*
-	 * begin is where we last checked our position with regards to offset
-	 * begin is always less than offset.  len is relative to begin.  It
-	 * is the number of bytes written past begin
-	 *
-	 */
-stop_output:
-	/* stop the output and calculate the correct length */
-	*(buffer + len) = '\0';
-
-	*start = buffer + (offset - begin);	/* Start of wanted data */
-	len -= (offset - begin);
-	if(len > length) {
-		len = length;
-	} else if(len < 0){
-		len = 0;
-		**start = '\0';
-	}
-	return len;
+	return 0;
+}
+
+static int adpt_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, adpt_proc_show, PDE(inode)->data);
 }
 
+static const struct file_operations adpt_proc_ops = {
+	.open		= adpt_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 /*
  *	Turn a struct scsi_cmnd * into a unique 32 bit 'context'.
  */
@@ -3639,7 +3577,7 @@ static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "dpt_i2o",
 	.proc_name		= "dpt_i2o",
-	.proc_info		= adpt_proc_info,
+	.proc_ops		= &adpt_proc_ops,
 	.info			= adpt_info,
 	.queuecommand		= adpt_queue,
 	.eh_abort_handler	= adpt_abort,
-- 
1.7.3.4

