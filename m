From: Christoph Hellwig <hch@caldera.de>
Subject: [PATCH] remove old SCSI-EH methods from Scsi_Host_Template
Date: Mon, 15 Apr 2002 19:49:29 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020415194929.A8937@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org

Hi Linus,

when I removed the old SCSI error handling in 2.5.<early> I accidentally
left the Scsi_Host_Template methods for it in.  The bloat cause by this
isn't much so this shouldn't be a real issue, but it allowed the drivers
not updated to new error handling to still compile and cause bad problems
in case of the need for error handling.  The patch below nukes it to
break compilation for the huge number of drivers not yet updated.

	Christoph

--- linux/drivers/scsi/hosts.h~	Tue Jan 15 10:59:08 2002
+++ linux/drivers/scsi/hosts.h	Mon Apr 15 20:35:46 2002
@@ -166,40 +166,6 @@
      int (*eh_host_reset_handler)(Scsi_Cmnd *);
 
     /*
-     * Since the mid level driver handles time outs, etc, we want to
-     * be able to abort the current command.  Abort returns 0 if the
-     * abortion was successful.	 The field SCpnt->abort reason
-     * can be filled in with the appropriate reason why we wanted
-     * the abort in the first place, and this will be used
-     * in the mid-level code instead of the host_byte().
-     * If non-zero, the code passed to it
-     * will be used as the return code, otherwise
-     * DID_ABORT  should be returned.
-     *
-     * Note that the scsi driver should "clean up" after itself,
-     * resetting the bus, etc.	if necessary.
-     *
-     * NOTE - this interface is depreciated, and will go away.  Use
-     * the eh_ routines instead.
-     */
-    int (* abort)(Scsi_Cmnd *);
-
-    /*
-     * The reset function will reset the SCSI bus.  Any executing
-     * commands should fail with a DID_RESET in the host byte.
-     * The Scsi_Cmnd  is passed so that the reset routine can figure
-     * out which host adapter should be reset, and also which command
-     * within the command block was responsible for the reset in
-     * the first place.	 Some hosts do not implement a reset function,
-     * and these hosts must call scsi_request_sense(SCpnt) to keep
-     * the command alive.
-     *
-     * NOTE - this interface is depreciated, and will go away.  Use
-     * the eh_ routines instead.
-     */
-    int (* reset)(Scsi_Cmnd *, unsigned int);
-
-    /*
      * This function is used to select synchronous communications,
      * which will result in a higher data throughput.  Not implemented
      * yet.
