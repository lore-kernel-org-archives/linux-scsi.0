From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid changes for 2.4.24 kernel to add support of AMD64 (part 2)
Date: Fri, 13 Feb 2004 17:37:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552B8@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:17798 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267261AbUBMWhr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 17:37:47 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Comments embedded

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Friday, February 13, 2004 4:59 PM
To: Salyzyn, Mark
Cc: linux-scsi
Subject: Re: [PATCH] aacraid changes for 2.4.24 kernel to add support of
AMD64 (part 2)

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

[MGS] The ioctl that utilizes this structure detects if the caller is a
32 bit or a 64 bit application under the AMD64 environment, and tunes
itself to the size of the fib element as necessary. I opted to use the
redefinition of this structure as a means to simplify the split
personality code that utilizes this structure.

In a 32 bit environment, there is no need to detect if the caller is a
32 bit or a 64 bit application, so the smaller fib element is all that
is needed.

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
+			busy |= device->access_count ||
dev->scsi_host_ptr->in_recovery;
+			if (busy == 0) {
+				device->removable = TRUE;
+			}
+		}
+	}

	This gives you nice races again.

[MGS] Without any test of busy status at all, we run the *high* risk of
a panic resulting from a stack overflow. This code is here because of a
broken error recovery in the scsi layer resulting in infinite recursion
under some sensitive activities.

Fix the scsi layer, and this code can go away.

+		dprintk((KERN_INFO "proc_scsi=%p ", proc_scsi));
+		for (entry = proc_scsi->subdir;
+		  entry != (struct proc_dir_entry *)NULL;
+		  entry = entry->next) {
+			dprintk(("\"%.*s\"[%d]=%x ", entry->namelen,
+			  entry->name, entry->namelen, entry->low_ino));
+			if ((entry->low_ino != 0)
+			 && (entry->namelen == 4)
+			 && (memcmp ("scsi", entry->name, 4) == 0)) {
+				dprintk(("%p->write_proc=%p ", entry,
entry->write_proc));
+				if (entry->write_proc != (int (*)(struct
file *, const char *, unsigned long, void *))NULL) {
+					char buffer[80];
+					int length;
+					mm_segment_t fs;
+
+					sprintf (buffer,
+					  "scsi %s-single-device %d %d
%d %d\n",
+					  ((DeviceConfigNeeded ==
DELETE)
+					   ? "remove"
+					   : "add"),
+					  dev->scsi_host_ptr->host_no,
+
CONTAINER_TO_CHANNEL(container),
+					  CONTAINER_TO_ID(container),
+					  CONTAINER_TO_LUN(container));
+					length = strlen (buffer);
+					dprintk((KERN_INFO
+					  "echo %.*s >
/proc/scsi/scsi\n",
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

	Stop it.  The code is bogus that I wonder how you even dare to
post it.

[MGS] Ok, tell me how to rescan for a device? The RAID drivers cause
asynchronous device changes that need to be reported to the scsi layer.
The scan_scsis call is hidden, so we *must* use the proc write to get to
it.

The code may be bogus, but it works. If you have a means to rescan
devices in the current 2.4 scsi layer, I will take that as a valid
alternative. Otherwise Adaptec customers will need to reboot their
machine every time something significant happens with the array.

+#if (defined(__x86_64__))
+# include <asm-x86_64/ioctl32.h>
+  /* Cast the function, since sys_ioctl does not match */
+# define aac_ioctl32(x,y) register_ioctl32_conversion((x), \
+    (int(*)(unsigned int,unsigned int,unsigned long,struct file*))(y))
+# include <asm/uaccess.h>
+#endif

	So why do the other drivers not need this?

[MGS] Not sure what you mean about other drivers? I have a series of
warning messages without the cast.

Or do you mean the arrangements for register_ioctl32_conversion? Because
other drivers do not have 32 bit applications calling a 64 bit ioctl for
RAID management functions. The current structure of the x86_64 port in
the 2.4 tree is to block 32 bit applications from calling the ioctl
without these arrangements.

 
