From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid changes for 2.4.24 kernel to add support of AMD64 (part 1)
Date: Fri, 13 Feb 2004 17:27:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F2552B7@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:28394 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S267218AbUBMW1j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2004 17:27:39 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Comments enclosed preceded by [MGS]

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Friday, February 13, 2004 4:59 PM
To: Salyzyn, Mark
Cc: linux-scsi
Subject: Re: [PATCH] aacraid changes for 2.4.24 kernel to add support of
AMD64 (part 1)

On Fri, Feb 13, 2004 at 04:15:30PM -0500, Salyzyn, Mark wrote:
> This first part of two forms a `big' patch to the aacraid driver adds
> support for the AMD64 systems.
> 
> There is some side effect of this patch associated with bug fixes and
> clean up that became apparent as a result of the 64 bit adjustments.

+#include <linux/version.h> /* For the following test */

	What test?

[MGS] In Adaptec's codebase for this driver we have one source for
everything (2.4.2-2.6.2) and to produce the patch for a specific kernel
I need to strip all the ifdef KERNEL_VERSION and include linux_version.h
stuff out. The version.h file slipped in. No side effects regardless.

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

[MGS] We have found commands issued to the controller with no callback
function under some conditions. Admittedly this may only happen on older
kernels (?) and sneaks in here, but I would need to test a 2.4.24 kernel
under those conditions to prove that this code was not needed. What is
wrong, the fact we need to perform this check, or the check itself?
Adaptec is paranoid, the test costs little.

As for the lock, this code is simply moved up from another area of the
driver so that a prototype was not necessary to head it off. A code
change to drop the locks introduces risks that can be dealt with in a
later patch. The code works (in smp environments) reliably, I would be
nervous to remove the locks as that was not under the prevue of the many
AMD64 changes required.

+	/*
+	 *	Only enable DAC mode if the dma_addr_t is larger than 32
+	 * bit addressing, and we have more than 32 bit addressing worth
of
+	 * memory and if the controller supports 64 bit scatter gather
elements.
+	 */
+	if( (sizeof(dma_addr_t) > 4) && (num_physpages > (0xFFFFFFFFULL
>> PAGE_SHIFT)) && (dev->adapter_info.options & AAC_OPT_SGMAP_HOST64)){

	The num_physpages check is wrong.  There's machines with
	non-continguous memory where you can get addresses bigger than
	32bits with less than 4 GB of memory.

[MGS] The driver functions better in a 32 bit environment as we can load
up more scatter gather elements. Although I agree there is this
inaccuracy, the cost of bounce buffers in such an environment is a small
cost to pay for the improved performance options available through the
ability to retune the driver for larger requests.

+} /* read_callback */

	These comments are completely against the linux code style,
	please don't add them

[MGS] Okely Dokely.

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

[MGS] The Applications depend on this function in order to report device
linkages. This above code exists in the driver already and was simply
moved elsewhere because of a restructuring of code. We will need to
figure out a means to fix this code at another time.

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
+			if ((device->channel ==
CONTAINER_TO_CHANNEL(cid))
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


	Uuum, guys.  This is racy as hell.  What the heck do you
actually
	want to archive?  And we had this discussion a few times
already..

[MGS] I know, and I keep on pushing back because we have *much* more
serious problems if the applications can not determine if the device is
busy. We must block the users from making changes to arrays, or causing
rescans, when the devices are busy, or if the system is dealing with
error recovery. This code helps us reduce the number of panics users
experience when they `play' with the arrays. The fact that this code is
racy is inconsequential; we are dealing with user initiated actions that
have timeframes of activities that are lengthy enough that the window of
opportunity for failure is low. Without the test, the window of
opportunity of failure is *much* higher.

We are dealing here with the needs of an array controller and management
tools. It this portion of the code is not accepted, Adaptec still has a
need to address the issue and must send out drivers that are not
synchronized with the linux tree for reasons of liability.

I need an alternative (snif ;-/ )
