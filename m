From: Pavel Machek <pavel@ucw.cz>
Subject: Small cleanups for scsi_host.h
Date: Mon, 17 Dec 2007 15:34:24 +0100
Message-ID: <20071217143424.GA12455@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52369 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760339AbXLQXGj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2007 18:06:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

Small cleanups in scsi_host.h. Few #defines make me wonder if their
description is still up to date..?

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit f37d85c2619d02ca383962e588417b9eacae366d
tree 4f2b2e93717c2f434e91ba32115a3801212e5e3d
parent 9918d25acff9540d86ccd93f6e8e536f1cb0a281
author Pavel <pavel@amd.ucw.cz> Mon, 17 Dec 2007 15:32:49 +0100
committer Pavel <pavel@amd.ucw.cz> Mon, 17 Dec 2007 15:32:49 +0100

 include/scsi/scsi_host.h |   46 ++++++++++++++++++++++++++--------------------
 1 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0fd4746..69e5a4a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -283,39 +283,45 @@ #endif
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
 
@@ -354,7 +360,7 @@ #endif
 
 	/*
 	 * This determines if we will use a non-interrupt driven
-	 * or an interrupt driven scheme,  It is set to the maximum number
+	 * or an interrupt driven scheme.  It is set to the maximum number
 	 * of simultaneous commands a given host adapter will accept.
 	 */
 	int can_queue;
@@ -375,12 +381,12 @@ #endif
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
@@ -389,7 +395,7 @@ #endif
 	 * This specifies "machine infinity" for host templates which don't
 	 * limit the transfer size.  Note this limit represents an absolute
 	 * maximum, and may be over the transfer limits allowed for
-	 * individual devices (e.g. 256 for SCSI-1)
+	 * individual devices (e.g. 256 for SCSI-1).
 	 */
 #define SCSI_DEFAULT_MAX_SECTORS	1024
 
@@ -416,12 +422,12 @@ #define SCSI_DEFAULT_MAX_SECTORS	1024
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
@@ -431,7 +437,7 @@ #define SCSI_DEFAULT_MAX_SECTORS	1024
 	unsigned use_clustering:1;
 
 	/*
-	 * True for emulated SCSI host adapters (e.g. ATAPI)
+	 * True for emulated SCSI host adapters (e.g. ATAPI).
 	 */
 	unsigned emulated:1;
 
@@ -441,12 +447,12 @@ #define SCSI_DEFAULT_MAX_SECTORS	1024
 	unsigned skip_settle_delay:1;
 
 	/*
-	 * ordered write support
+	 * True if we are using ordered write support.
 	 */
 	unsigned ordered_tag:1;
 
 	/*
-	 * true if the low-level driver can support sg chaining. this
+	 * True if the low-level driver can support sg chaining. This
 	 * will be removed eventually when all the drivers are
 	 * converted to support sg chaining.
 	 *
@@ -455,7 +461,7 @@ #define SCSI_DEFAULT_MAX_SECTORS	1024
 	unsigned use_sg_chaining:1;
 
 	/*
-	 * Countdown for host blocking with no commands outstanding
+	 * Countdown for host blocking with no commands outstanding.
 	 */
 	unsigned int max_host_blocked;
 
@@ -534,8 +540,8 @@ struct Scsi_Host {
 	struct scsi_transport_template *transportt;
 
 	/*
-	 * area to keep a shared tag map (if needed, will be
-	 * NULL if not)
+	 * Area to keep a shared tag map (if needed, will be
+	 * NULL if not).
 	 */
 	struct blk_queue_tag	*bqt;
 
@@ -609,16 +615,16 @@ struct Scsi_Host {
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

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
