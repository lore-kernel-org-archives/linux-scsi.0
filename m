From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid changes for 2.4.24 kernel to add support of AMD64 (part 2)
Date: Fri, 13 Feb 2004 21:58:59 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040213215859.B20911@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552A2@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:13579 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267239AbUBMV7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 16:59:00 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552A2@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Fri, Feb 13, 2004 at 04:16:14PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

 struct fib_ioctl
 {
-	char	*fibctx;
-	int	wait;
-	char	*fib;
+	u32	fibctx;
+	s32	wait;
+#if (defined(__x86_64__))
+	u64	fib;
+#else
+	u32	fib;
+#endif

	This is broken.   If you really mean what you wrote just use
	unsigned long, but if you want this API to actually work as
	expected use the same value on all architectures.

+	if (!dev || !dev->scsi_host_ptr) {
+		return;
+	}
+	for (device = dev->scsi_host_ptr->host_queue;
+	  device != (Scsi_Device *)NULL;
+	  device = device->next)
+	{
+		dprintk((KERN_INFO "aifd: device (%d,%d,%d,%d)?\n",
+		  dev->scsi_host_ptr->host_no,
+		  device->channel,
+		  device->id,
+		  device->lun));
+		if ((device->channel == CONTAINER_TO_CHANNEL(container))
+		 && (device->id == CONTAINER_TO_ID(container))
+		 && (device->lun == CONTAINER_TO_LUN(container))) {
+			busy |= device->access_count || dev->scsi_host_ptr->in_recovery;
+			if (busy == 0) {
+				device->removable = TRUE;
+			}
+		}
+	}

	This gives you nice races again.

+		dprintk((KERN_INFO "proc_scsi=%p ", proc_scsi));
+		for (entry = proc_scsi->subdir;
+		  entry != (struct proc_dir_entry *)NULL;
+		  entry = entry->next) {
+			dprintk(("\"%.*s\"[%d]=%x ", entry->namelen,
+			  entry->name, entry->namelen, entry->low_ino));
+			if ((entry->low_ino != 0)
+			 && (entry->namelen == 4)
+			 && (memcmp ("scsi", entry->name, 4) == 0)) {
+				dprintk(("%p->write_proc=%p ", entry, entry->write_proc));
+				if (entry->write_proc != (int (*)(struct file *, const char *, unsigned long, void *))NULL) {
+					char buffer[80];
+					int length;
+					mm_segment_t fs;
+
+					sprintf (buffer,
+					  "scsi %s-single-device %d %d %d %d\n",
+					  ((DeviceConfigNeeded == DELETE)
+					   ? "remove"
+					   : "add"),
+					  dev->scsi_host_ptr->host_no,
+					  CONTAINER_TO_CHANNEL(container),
+					  CONTAINER_TO_ID(container),
+					  CONTAINER_TO_LUN(container));
+					length = strlen (buffer);
+					dprintk((KERN_INFO
+					  "echo %.*s > /proc/scsi/scsi\n",
+					  length-1,
+					  buffer));
+//printk("echo %.*s > /proc/scsi/scsi\n", length-1, buffer);
+					fs = get_fs();
+					set_fs(get_ds());
+					length = entry->write_proc(
+					  NULL, buffer, length, NULL);
+					set_fs(fs);
+					dprintk((KERN_INFO
+					  "returns %d\n", length));

	Stop it.  The code is bogus that I wonder how you even dare to post it.

+#if (defined(__x86_64__))
+# include <asm-x86_64/ioctl32.h>
+  /* Cast the function, since sys_ioctl does not match */
+# define aac_ioctl32(x,y) register_ioctl32_conversion((x), \
+    (int(*)(unsigned int,unsigned int,unsigned long,struct file*))(y))
+# include <asm/uaccess.h>
+#endif

	So why do the other drivers not need this?

 
