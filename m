From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid changes for 2.4.24 kernel to add support of AMD64 (part 1)
Date: Fri, 13 Feb 2004 21:58:54 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040213215854.A20911@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552A1@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:13067 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267232AbUBMV64 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 16:58:56 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552A1@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Fri, Feb 13, 2004 at 04:15:30PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Feb 13, 2004 at 04:15:30PM -0500, Salyzyn, Mark wrote:
> This first part of two forms a `big' patch to the aacraid driver adds
> support for the AMD64 systems.
> 
> There is some side effect of this patch associated with bug fixes and
> clean up that became apparent as a result of the 64 bit adjustments.

+#include <linux/version.h> /* For the following test */

	What test?

+static void aac_io_done(Scsi_Cmnd * scsicmd)
+{
+	unsigned long cpu_flags;
+
+	if (scsicmd->scsi_done == (void (*)(Scsi_Cmnd*))NULL) {
+		printk(KERN_WARNING "aac_io_done: scsi_done NULL\n");
+		return;
+	}
+	aac_spin_lock_irqsave(host->host_lock, cpu_flags);
+	scsicmd->scsi_done(scsicmd);
+	aac_spin_unlock_irqrestore(host->host_lock, cpu_flags);
+} /* aac_io_done */

	You don't need a lock around the completion function,
	look at scsi_done.
	Also the NULL check above looks wrong.

+	/*
+	 *	Only enable DAC mode if the dma_addr_t is larger than 32
+	 * bit addressing, and we have more than 32 bit addressing worth of
+	 * memory and if the controller supports 64 bit scatter gather elements.
+	 */
+	if( (sizeof(dma_addr_t) > 4) && (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) && (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)){

	The num_physpages check is wrong.  There's machines with
	non-continguous memory where you can get addresses bigger than
	32bits with less than 4 GB of memory.

+} /* read_callback */

	These comments are completely against the linux code style,
	please don't add them

+static void get_sd_devname(int disknum, char *buffer)
+{
+	if (disknum < 0) {
+		sprintf(buffer, "%s", "");
+		return;
+	}
+
+	if (disknum < 26)
+		sprintf(buffer, "sd%c", 'a' + disknum);
+	else {
+		unsigned int min1;
+		unsigned int min2;
+		/*
+		 * For larger numbers of disks, we need to go to a new
+		 * naming scheme.
+		 */
+		min1 = disknum / 26;
+		min2 = disknum % 26;
+		sprintf(buffer, "sd%c%c", 'a' + min1 - 1, 'a' + min2);
+	}
+} /* get_sd_devname */

	This is copletely broken.  a scsi LLDD doesn't know about device
	names, it sits below the midlayer.

+static int busy_disk(struct aac_dev * dev, int cid)
+{
+	if ((dev != (struct aac_dev *)NULL)
+	 && (dev->scsi_host_ptr != (struct Scsi_Host *)NULL)) {
+		Scsi_Device * device;
+
+		for (device = dev->scsi_host_ptr->host_queue;
+		  device != (Scsi_Device *)NULL;
+		  device = device->next)
+		{
+			if ((device->channel == CONTAINER_TO_CHANNEL(cid))
+			 && (device->id == CONTAINER_TO_ID(cid))
+			 && (device->lun == CONTAINER_TO_LUN(cid))
+			&& (device->access_count
+			  || dev->scsi_host_ptr->in_recovery)) {
+				return 1;
+			}
+		}
+	}
+	return 0;
+} /* aac_busy_disk */


	Uuum, guys.  This is racy as hell.  What the heck do you actually
	want to archive?  And we had this discussion a few times already..
