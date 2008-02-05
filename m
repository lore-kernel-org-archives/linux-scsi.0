From: akpm@linux-foundation.org
Subject: [patch 11/13] Small cleanups for scsi_host.h
Date: Mon, 04 Feb 2008 23:53:24 -0800
Message-ID: <200802050753.m157r5bo010724@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41080 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754048AbYBEHxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 02:53:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, pavel@ucw.cz, James.Bottomley@steeleye.com, pavel@suse.cz

From: Pavel Machek <pavel@ucw.cz>

Small cleanups in scsi_host.h. Few #defines make me wonder if their
description is still up to date..?

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/scsi_host.h |   44 +++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff -puN include/scsi/scsi_host.h~small-cleanups-for-scsi_hosth include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h~small-cleanups-for-scsi_hosth
+++ a/include/scsi/scsi_host.h
@@ -280,39 +280,45 @@ struct scsi_host_template {
 	 * If the host wants to be called before the scan starts, but
 	 * after the midlayer has set up ready for the scan, it can fill
 	 * in this function.
+	 *
+	 * Status: OPTIONAL
 	 */
 	void (* scan_start)(struct Scsi_Host *);
 
 	/*
-	 * fill in this function to allow the queue depth of this host
-	 * to be changeable (on a per device basis).  returns either
+	 * Fill in this function to allow the queue depth of this host
+	 * to be changeable (on a per device basis).  Returns either
 	 * the current queue depth setting (may be different from what
 	 * was passed in) or an error.  An error should only be
 	 * returned if the requested depth is legal but the driver was
 	 * unable to set it.  If the requested depth is illegal, the
 	 * driver should set and return the closest legal queue depth.
 	 *
+	 * Status: OPTIONAL
 	 */
 	int (* change_queue_depth)(struct scsi_device *, int);
 
 	/*
-	 * fill in this function to allow the changing of tag types
+	 * Fill in this function to allow the changing of tag types
 	 * (this also allows the enabling/disabling of tag command
 	 * queueing).  An error should only be returned if something
 	 * went wrong in the driver while trying to set the tag type.
 	 * If the driver doesn't support the requested tag type, then
 	 * it should set the closest type it does support without
 	 * returning an error.  Returns the actual tag type set.
+	 *
+	 * Status: OPTIONAL
 	 */
 	int (* change_queue_type)(struct scsi_device *, int);
 
 	/*
-	 * This function determines the bios parameters for a given
+	 * This function determines the BIOS parameters for a given
 	 * harddisk.  These tend to be numbers that are made up by
 	 * the host adapter.  Parameters:
 	 * size, device, list (heads, sectors, cylinders)
 	 *
-	 * Status: OPTIONAL */
+	 * Status: OPTIONAL
+	 */
 	int (* bios_param)(struct scsi_device *, struct block_device *,
 			sector_t, int []);
 
@@ -351,7 +357,7 @@ struct scsi_host_template {
 
 	/*
 	 * This determines if we will use a non-interrupt driven
-	 * or an interrupt driven scheme,  It is set to the maximum number
+	 * or an interrupt driven scheme.  It is set to the maximum number
 	 * of simultaneous commands a given host adapter will accept.
 	 */
 	int can_queue;
@@ -372,12 +378,12 @@ struct scsi_host_template {
 	unsigned short sg_tablesize;
 
 	/*
-	 * If the host adapter has limitations beside segment count
+	 * Set this if the host adapter has limitations beside segment count.
 	 */
 	unsigned short max_sectors;
 
 	/*
-	 * dma scatter gather segment boundary limit. a segment crossing this
+	 * DMA scatter gather segment boundary limit. A segment crossing this
 	 * boundary will be split in two.
 	 */
 	unsigned long dma_boundary;
@@ -386,7 +392,7 @@ struct scsi_host_template {
 	 * This specifies "machine infinity" for host templates which don't
 	 * limit the transfer size.  Note this limit represents an absolute
 	 * maximum, and may be over the transfer limits allowed for
-	 * individual devices (e.g. 256 for SCSI-1)
+	 * individual devices (e.g. 256 for SCSI-1).
 	 */
 #define SCSI_DEFAULT_MAX_SECTORS	1024
 
@@ -413,12 +419,12 @@ struct scsi_host_template {
 	unsigned supported_mode:2;
 
 	/*
-	 * true if this host adapter uses unchecked DMA onto an ISA bus.
+	 * True if this host adapter uses unchecked DMA onto an ISA bus.
 	 */
 	unsigned unchecked_isa_dma:1;
 
 	/*
-	 * true if this host adapter can make good use of clustering.
+	 * True if this host adapter can make good use of clustering.
 	 * I originally thought that if the tablesize was large that it
 	 * was a waste of CPU cycles to prepare a cluster list, but
 	 * it works out that the Buslogic is faster if you use a smaller
@@ -428,7 +434,7 @@ struct scsi_host_template {
 	unsigned use_clustering:1;
 
 	/*
-	 * True for emulated SCSI host adapters (e.g. ATAPI)
+	 * True for emulated SCSI host adapters (e.g. ATAPI).
 	 */
 	unsigned emulated:1;
 
@@ -438,12 +444,12 @@ struct scsi_host_template {
 	unsigned skip_settle_delay:1;
 
 	/*
-	 * ordered write support
+	 * True if we are using ordered write support.
 	 */
 	unsigned ordered_tag:1;
 
 	/*
-	 * Countdown for host blocking with no commands outstanding
+	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
 
@@ -522,8 +528,8 @@ struct Scsi_Host {
 	struct scsi_transport_template *transportt;
 
 	/*
-	 * area to keep a shared tag map (if needed, will be
-	 * NULL if not)
+	 * Area to keep a shared tag map (if needed, will be
+	 * NULL if not).
 	 */
 	struct blk_queue_tag	*bqt;
 
@@ -596,16 +602,16 @@ struct Scsi_Host {
 	/*
 	 * Host uses correct SCSI ordering not PC ordering. The bit is
 	 * set for the minority of drivers whose authors actually read
-	 * the spec ;)
+	 * the spec ;).
 	 */
 	unsigned reverse_ordering:1;
 
 	/*
-	 * ordered write support
+	 * Ordered write support
 	 */
 	unsigned ordered_tag:1;
 
-	/* task mgmt function in progress */
+	/* Task mgmt function in progress */
 	unsigned tmf_in_progress:1;
 
 	/* Asynchronous scan in progress */
_
