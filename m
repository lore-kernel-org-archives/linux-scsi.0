From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [RFC]: performance improvement by coalescing requests?
Date: Mon, 20 Jun 2005 15:25:08 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01520EDD@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:11488 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261521AbVFTTZz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 15:25:55 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j5KJPsc14404
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2005 12:25:54 -0700
Received: from otce2k01.adaptec.com (otce2k01.adaptec.com [10.12.1.83])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j5KJPrg14035
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2005 12:25:53 -0700
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is not a patch to be applied to any release, for discussion only.

We have managed to increase the performance of the I/O to the driver by
pushing back on the scsi_merge layer when we detect that we are issuing
sequential requests (patch enclosed below to demonstrate the technique
used to investigate). In the algorithm used, when we see that we have an
I/O that adjoins the previous request, we reduce the queue depth to a
value of 2 for the device. This allows the incoming I/O to be
scrutinized by the scsi_merge layer for a bit longer permitting them to
be merged together into a larger more efficient request.

By limiting the queue to a depth of two, we also do not delay the system
much since we keep one worker and one outstanding remaining in the
controller. This keeps the I/O's fed without delay.

The net result was instead of receiving, for example, 64 4K sequential
I/O requests to an eager controller more than willing to accept the
commands into it's domain, we instead see two 4K I/O requests, followed
by one 248KB I/O request.

I would like to hear from the luminaries about how we could move this
proposed policy to the scsi or block layers for a generalized increase
in Linux performance.

One should note that this kind of policy to deal with sequential I/O
activity is not new in high performance operating systems. It is simply
lacking in the Linux I/O layers.

Sincerely -- Mark Salyzyn

diff -ru a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c	Mon Jun 20 11:57:47 2005
+++ b/drivers/scsi/aacraid/aachba.c	Mon Jun 20 12:08:23 2005
@@ -154,6 +154,10 @@
 module_param(commit, int, 0);
 MODULE_PARM_DESC(commit, "Control whether a COMMIT_CONFIG is issued to
the adapter for foreign arrays.\nThis is typically needed in systems
that do not have a BIOS. 0=off, 1=on");
 
+static int coalescethreshold = 0;
+module_param(coalescethreshold, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(coalescethreshold, "Control the maximum block size of
sequential requests that are fed back to the\nscsi_merge layer for
coalescing. 0=off, 16 block (8KB) default.");
+
 int numacb = -1;
 module_param(numacb, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(numacb, "Request a limit to the number of adapter
control blocks (FIB) allocated. Valid\nvalues are 512 and down. Default
is to use suggestion from Firmware.");
@@ -878,6 +882,40 @@
 	aac_io_done(scsicmd);
 }
 
+static inline void aac_select_queue_depth(
+	struct scsi_cmnd * scsicmd,
+	int cid,
+	u64 lba,
+	u32 count)
+{
+	struct scsi_device *device = scsicmd->device;
+	struct aac_dev *dev;
+	unsigned depth;
+
+	if (!device->tagged_supported)
+		return;
+	dev = (struct aac_dev *)device->host->hostdata;
+	if (dev->fsa_dev[cid].queue_depth <= 2)
+		dev->fsa_dev[cid].queue_depth = device->queue_depth;
+	if (lba == dev->fsa_dev[cid].last) {
+		/*
+		 * If larger than coalescethreshold in size, coalescing
has
+		 * less effect on overall performance.  Also, if we are
+		 * coalescing right now, leave it alone if above the
threshold.
+		 */
+		if (count > coalescethreshold)
+			return;
+		depth = 2;
+	} else {
+		depth = dev->fsa_dev[cid].queue_depth;
+	}
+	scsi_adjust_queue_depth(device, MSG_ORDERED_TAG, depth);
+	dprintk((KERN_DEBUG "l=%llu %llu[%u] q=%u %lu\n",
+	  dev->fsa_dev[cid].last, lba, count, device->queue_depth,
+	  dev->queues->queue[AdapNormCmdQueue].numpending));
+	dev->fsa_dev[cid].last = lba + count;
+}
+
 static int aac_read(struct scsi_cmnd * scsicmd, int cid)
 {
 	u32 lba;
@@ -910,6 +948,10 @@
 	dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %u, t = %ld.\n",
 	  smp_processor_id(), (unsigned long long)lba, jiffies));
 	/*
+	 *	Are we in a sequential mode?
+	 */
+	aac_select_queue_depth(scsicmd, cid, lba, count);
+	/*
 	 *	Alocate and initialize a Fib
 	 */
 	if (!(cmd_fibcontext = fib_alloc(dev))) {
@@ -1016,6 +1058,10 @@
 	dprintk((KERN_DEBUG "aac_write[cpu %d]: lba = %u, t = %ld.\n",
 	  smp_processor_id(), (unsigned long long)lba, jiffies));
 	/*
+	 *	Are we in a sequential mode?
+	 */
+	aac_select_queue_depth(scsicmd, cid, lba, count);
+	/*
 	 *	Allocate and initialize a Fib then setup a BlockWrite
command
 	 */
 	if (!(cmd_fibcontext = fib_alloc(dev))) {
