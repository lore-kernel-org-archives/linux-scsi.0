From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] aic79xx: Update to adaptec version 2.0.15
Date: Mon, 16 Jan 2006 11:04:31 +0100
Message-ID: <43CB6FAF.5080000@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090409020807080505070401"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:53481 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932316AbWAPKEe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 05:04:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------090409020807080505070401
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch updates aic79xx to adaptec version 2.0.15.





--------------090409020807080505070401
Content-Type: text/plain;
 name="0003-aic79xx-Update-to-adaptec-version-2.0.15.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0003-aic79xx-Update-to-adaptec-version-2.0.15.txt"

[PATCH 3/3] aic79xx: Update to adaptec version 2.0.15

This patch updates the aic79xx driver to adaptec version 2.0.15.
---

 drivers/scsi/aic7xxx/README.aic79xx            |  723 ++++++++++++++++++++++++
 drivers/scsi/aic7xxx/README.aic7xxx            |  530 ++++++++++++++++++
 drivers/scsi/aic7xxx/aic79xx_core.c            |   11 
 drivers/scsi/aic7xxx/aic79xx_osm.h             |    2 
 drivers/scsi/aic7xxx/aicasm/Makefile           |    6 
 drivers/scsi/aic7xxx/aicasm/aicasm.c           |   23 +
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y      |   19 +
 drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h |   88 +++
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l      |   27 +
 9 files changed, 1405 insertions(+), 24 deletions(-)
 create mode 100644 drivers/scsi/aic7xxx/README.aic79xx
 create mode 100644 drivers/scsi/aic7xxx/README.aic7xxx

9fd618cafc5ee0b0145b9c8a5b5720090a8beff6
diff --git a/drivers/scsi/aic7xxx/README.aic79xx b/drivers/scsi/aic7xxx/README.aic79xx
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/aic7xxx/README.aic79xx
@@ -0,0 +1,723 @@
+====================================================================
+=             Adaptec Ultra320 Family Manager Set                  =
+=                                                                  =
+=                            README for                            =
+=                    The Linux Operating System                    =
+====================================================================
+
+The following information is available in this file:
+
+  1. Supported Hardware
+  2. Version History
+  3. Command Line Options
+  4. Additional Notes
+  5. Contacting Adaptec
+
+
+1. Supported Hardware
+
+   The following Adaptec SCSI Host Adapters are supported by this 
+   driver set. 
+
+   Ultra320 ASIC              Description
+   ----------------------------------------------------------------
+   AIC-7901A                  Single Channel 64-bit PCI-X 133MHz to 
+                              Ultra320 SCSI ASIC
+   AIC-7901B                  Single Channel 64-bit PCI-X 133MHz to 
+                              Ultra320 SCSI ASIC with Retained Training
+   AIC-7902A4                 Dual Channel 64-bit PCI-X 133MHz to 
+                              Ultra320 SCSI ASIC
+   AIC-7902B                  Dual Channel 64-bit PCI-X 133MHz to
+                              Ultra320 SCSI ASIC with Retained Training
+
+   Ultra320 Adapters          Description                              ASIC
+   --------------------------------------------------------------------------
+   Adaptec SCSI Card 39320    Dual Channel 64-bit PCI-X 133MHz to   7902A4/7902B
+                              Ultra320 SCSI Card (one external 
+                              68-pin, two internal 68-pin)
+   Adaptec SCSI Card 39320A   Dual Channel 64-bit PCI-X 133MHz to      7902B
+                              Ultra320 SCSI Card (one external 
+                              68-pin, two internal 68-pin)
+   Adaptec SCSI Card 39320D   Dual Channel 64-bit PCI-X 133MHz to      7902A4
+                              Ultra320 SCSI Card (two external VHDC
+                              and one internal 68-pin)
+   Adaptec SCSI Card 39320D   Dual Channel 64-bit PCI-X 133MHz to      7902A4
+                              Ultra320 SCSI Card (two external VHDC
+                              and one internal 68-pin) based on the
+                              AIC-7902B ASIC
+   Adaptec SCSI Card 29320    Single Channel 64-bit PCI-X 133MHz to    7901A
+                              Ultra320 SCSI Card (one external 
+                              68-pin, two internal 68-pin, one
+                              internal 50-pin)
+   Adaptec SCSI Card 29320A   Single Channel 64-bit PCI-X 133MHz to    7901B
+                              Ultra320 SCSI Card (one external 
+                              68-pin, two internal 68-pin, one
+                              internal 50-pin)
+   Adaptec SCSI Card 29320LP  Single Channel 64-bit Low Profile        7901A
+                              PCI-X 133MHz to Ultra320 SCSI Card
+                              (One external VHDC, one internal
+                              68-pin)
+   Adaptec SCSI Card 29320ALP Single Channel 64-bit Low Profile        7901B
+                              PCI-X 133MHz to Ultra320 SCSI Card
+                              (One external VHDC, one internal
+                              68-pin)
+2. Version History
+
+   2.0.15 (September 25, 2005)
+	- Added code to enable slowcrc bit during nego 
+	  table update to slow down CRC interval to be 
+	  compatible with packetized U320 devices that 
+	  can't handle a CRC at full speed.
+
+   2.0.14 (December 23, 2004)
+	- PCI memory space is 512 bytes, not 256.
+	- Fix wrongly calling scsi_adjust_queue_depth() when
+	  the scsi device has no request_queue.
+	- Adding module option "slowcrc" to control the
+	  setting of that bit in the NEGODAT3 (NEGCONOPTS)
+	  register. The LSI chip being used in certain
+	  external storage boxes do not allow 320 connection
+	  for Rev B of the aic79xx. Turning on this bit
+	  works around the bug in the LSI chip.  Default is
+	  off.  To turn on, use kernel/module parameter as:
+
+	  aic79xx=slowcrc:1
+
+	- Adding proper PCI ID tables to support
+          hotplugging.
+	- Fix a compilation issue after scsi_sleep() became
+          obsolete, in stead of the new msleep() and
+          ssleep() functions.
+	- Edit Adaptec Customer Support info.
+	- Fix a bug freeing in reserve_io_regions (wrong pointer
+          to free).
+	- "Warnings are errors" is now selectable by the
+          kbuild system -- make it so here.
+	- Fix undefined symbol when compiling aic79xx for 2.6.
+	  Also regenerate the aic7xxx reg and seq files.
+	- Plug leaks in aic79xx_osm.c::ahd_linux_dev_reset().
+          Convert AIC to ssleep() and msleep() as
+          scsi_sleep() is no longer available in 2.6.
+	- Fix a double free.  If "ahc_alloc()" fails, it
+          frees the "name" argument passed.
+	- Invert the polarity of two tests in the recovery
+          code that could cause the driver to issue a bus
+          reset more quickly than intended. We want to
+          *wait* if we find another SCB that could be the
+          cause of this timeout, not proceed to a bus reset.
+        - As requested by linux-scsi: Add a flag which explicitly
+          forbids/allows the compilation of the firmware across
+          the whole build system.
+	- When doing domain validation, we send commands
+          which do not have a struct request.  In this case
+          we cannot just call scsi_populate_tag_msg(), since
+          it dereferences it blindly and oopses the kernel.
+          Now we call scsi_populate_tag_msg() only if the
+          SCSI command has a struct request associated with
+          it.
+
+   2.0.13 (July 22, 2004)
+        - Fix a compilation issue due to the changed location and name
+          of the "hosts.h" file.  Now it resides as <scsi/scsi_host.h>
+        - Add support for 16 byte CDBs.
+
+   2.0.12 (May 13th, 2004)
+        - Flag driver threads with PF_FREEZE to support software suspend.
+
+   2.0.11 (May 7th, 2004)
+        - Avoid split-completion bugs in certain PCI-X chipsets by
+          breaking up large completion entry DMAs on ADB boundaries.
+
+   2.0.10 (April 9th, 2004)
+        - Return "command timeout" status instead of "selection timeout
+	  status" to the SCSI mid-layer in response to selection timeouts.
+	  While the latter may seem more correct, the mid-layer will not
+	  offline devices suffering from persistent selection timeouts.
+	  This leads to extremely long recovery times for devices that
+	  go missing.  Returning command timeout status causes the mid-layer
+	  to enter recovery and eventually offline persistently missing
+	  devices.
+
+   2.0.9 (March 29th, 2004)
+        - Abort all pending transactions on a target in response to
+          a selection timeout.  This greatly increases the speed with
+          which we recover when a device "goes missing".
+
+   2.0.8 (March 7th, 2004)
+        - Fix PCI device/vendor ID mask for the 7901B probe entry
+          so the driver will successfully attach to 7901B parts
+          down on motherboards.
+
+   2.0.7 (February 24th, 2004)
+        - Implement delay on I/O after delivery of a Target Reset.
+        - Correct deregistration of sysrq handler when multiple
+          controllers are detected.
+
+   2.0.6 (February 6th, 2004)
+        - Force a renegotiation on all inqury commands so that
+          the negotiated transfer parameters are correct even
+          if the device has been externally reset since our last
+          command.  Devices are not allowed to report unit attention
+          conditions in response to inquiry requests otherwise we'd
+          not need to treat inquiry commands specially.
+        - Remove all vestiges of pre-2.4.X support.
+        - Close a very rare race-condition in RevA 790X controllers.
+          If both FIFOs are allocated before the sequencer's idle
+          loop is able to service the FIFO that was allocated first,
+          the sequencer could handle them out of order.  This could
+          lead to a deadlock where the FIFO attached to the SCSI bus
+          is being serviced by the sequencer, but the other FIFO is
+          required to handle a snapshot.  The sequencer now detects
+          this condition and always handles FIFOs that are not currently
+          on the bus first.
+        - Close a few race conditions by adding critical section
+          markers into the firmware.  These windows might have caused
+          issues during error recovery.
+        - Switch the complete DMA SCB list to a tailq so that multiple
+          SCBs completing with non-zero status do not interfere with
+          the state for the SCB currently being uploaded.
+        - Use the comparison of a kernel and a sequencer qfreeze
+          count to control the freezing of outgoing selections.  This
+          allows the kernel to handle non-zero SCB completions without
+          having to clear firmware critical sections.
+        - Change the completion FIFO mechanism so that all completion
+          entries are guaranteed aligned on a 64bit boundary.  This
+          avoids SCB DMA engine bugs that are triggered if the transfer
+          is interrupted (e.g. PCI disconnect) on a non-aligned boundary.
+          In some cases, these bugs would result in duplicate completions.
+        - Use one byte in the new completion entry to indicate if the
+          SCB completed without a residual or non-zero SCSI status.  This
+          avoids an extra memory reference in our interrupt handler.
+
+   2.0.5 (December 22nd, 2003)
+        - Correct a bug preventing the driver from renegotiating
+          during auto-request sense operations when a check
+          condition occurred for a zero length command.
+        - Sniff sense information returned by targets for unit
+          attention errors that may indicate that the device has
+          been changed.  If we see such status for non Domain
+          Validation related commands, start a DV scan for the
+          target.  In the past, DV would only occur for hot-plugged
+          devices if no target had been previously probed for a
+          particular ID.  This change guarantees that the DV process
+          will occur even if the user swaps devices without any
+          interveining I/O to tell us that a device has gone missing.
+          The old behavior, among other things, would fail to spin up
+          drives that were hot-plugged since the Linux mid-layer
+          will only spin-up drives on initial attach.
+        - Correct several issues in the rundown of the good status
+          FIFO during error recovery.  The typical failure scenario
+          evidenced by this defect was the loss of several commands
+          under high load when	 several queue full conditions occured
+          back to back.
+
+   2.0.4 (November 6th, 2003)
+        - Support the 2.6.0-test9 kernel
+        - Fix rare deadlock caused by using del_timer_sync from within
+          a timer handler.
+
+   2.0.3 (October 21st, 2003)
+        - On 7902A4 hardware, use the slow slew rate for transfer
+          rates slower than U320.  This behavior matches the Windows
+          driver.
+        - Fix some issues with the ahd_flush_qoutfifo() routine.
+        - Add a delay in the loop waiting for selection activity
+          to cease.  Otherwise we may exhaust the loop counter too
+          quickly on fast machines.
+        - Return to processing bad status completions through the
+          qoutfifo.  This reduces the amount of time the controller
+          is paused for these kinds of errors.
+        - Move additional common routines to the aiclib OSM library
+          to reduce code duplication.
+        - Leave removal of softcs from the global list of softcs to
+          the OSM.  This allows us to avoid holding the list_lock during
+          device destruction.
+        - Enforce a bus settle delay for bus resets that the
+          driver initiates.
+        - Fall back to basic DV for U160 devices that lack an
+          echo buffer.
+
+   2.0.2 (September 4th, 2003)
+        - Move additional common routines to the aiclib OSM library
+          to reduce code duplication.
+        - Avoid an inadvertant reset of the controller during the
+          memory mapped I/O test should the controller be left in
+          the reset state prior to driver initialization.  On some
+          systems, this extra reset resulted in a system hang due
+          to a chip access that occurred too soon after reset.
+        - Correct an endian bug in ahd_swap_with_next_hscb.  This
+          corrects strong-arm support.
+        - Reset the bus for transactions that timeout waiting for
+          the bus to go free after a disconnect or command complete
+          message.
+
+   2.0.1 (August 26th, 2003)
+        - Add magic sysrq handler that causes a card dump to be output
+          to the console for each controller.
+        - Avoid waking the mid-layer's error recovery handler during
+          timeout recovery by returning DID_ERROR instead of DID_TIMEOUT
+          for timed-out commands that have been aborted.
+        - Move additional common routines to the aiclib OSM library
+          to reduce code duplication.
+
+   2.0.0 (August 20th, 2003)
+        - Remove MMAPIO definition and allow memory mapped
+          I/O for any platform that supports PCI.
+        - Avoid clearing ENBUSFREE during single stepping to avoid
+          spurious "unexpected busfree while idle" messages.
+        - Correct deadlock in ahd_run_qoutfifo() processing.
+        - Optimize support for the 7901B.
+        - Correct a few cases where an explicit flush of pending
+          register writes was required to ensure acuracy in delays.
+        - Correct problems in manually flushing completed commands
+          on the controller.  The FIFOs are now flushed to ensure
+          that completed commands that are still draining to the
+          host are completed correctly.
+        - Correct incomplete CDB delivery detection on the 790XB.
+        - Ignore the cmd->underflow field since userland applications
+          using the legacy command pass-thru interface do not set
+          it correctly.  Honoring this field led to spurious errors
+          when users used the "scsi_unique_id" program.
+        - Perform timeout recovery within the driver instead of relying
+          on the Linux SCSI mid-layer to perform this function.  The
+          mid-layer does not know the full state of the SCSI bus and
+          is therefore prone to looping for several minutes to effect
+          recovery.  The new scheme recovers within 15 seconds of the
+          failure.
+        - Correct support for manual termination settings.
+        - Increase maximum wait time for serial eeprom writes allowing
+          writes to function correctly.
+
+   1.3.12 (August 11, 2003)
+        - Implement new error recovery thread that supercedes the existing
+          Linux SCSI error recovery code.
+        - Fix termination logic for 29320ALP.
+        - Fix SEEPROM delay to compensate for write ops taking longer.
+
+   1.3.11 (July 11, 2003)
+        - Fix several deadlock issues.
+        - Add 29320ALP and 39320B Id's.
+
+   1.3.10 (June 3rd, 2003)
+        - Align the SCB_TAG field on a 16byte boundary.  This avoids
+          SCB corruption on some PCI-33 busses.
+        - Correct non-zero luns on Rev B. hardware.
+        - Update for change in 2.5.X SCSI proc FS interface.
+        - When negotiation async via an 8bit WDTR message, send
+          an SDTR with an offset of 0 to be sure the target
+          knows we are async.  This works around a firmware defect
+          in the Quantum Atlas 10K.
+        - Implement controller susupend and resume.
+        - Clear PCI error state during driver attach so that we
+          don't disable memory mapped I/O due to a stray write
+          by some other driver probe that occurred before we
+          claimed the controller.
+
+   1.3.9 (May 22nd, 2003)
+        - Fix compiler errors.
+        - Remove S/G splitting for segments that cross a 4GB boundary.
+          This is guaranteed not to happen in Linux.
+        - Add support for scsi_report_device_reset() found in
+          2.5.X kernels.
+        - Add 7901B support.
+        - Simplify handling of the packtized lun Rev A workaround.
+        - Correct and simplify handling of the ignore wide residue
+          message.  The previous code would fail to report a residual
+          if the transaction data length was even and we received
+          an IWR message.
+
+   1.3.8 (April 29th, 2003)
+        - Fix types accessed via the command line interface code.
+        - Perform a few firmware optimizations.
+        - Fix "Unexpected PKT busfree" errors.
+        - Use a sequencer interrupt to notify the host of
+          commands with bad status.  We defer the notification
+          until there are no outstanding selections to ensure
+          that the host is interrupted for as short a time as
+          possible.
+        - Remove pre-2.2.X support.
+        - Add support for new 2.5.X interrupt API.
+        - Correct big-endian architecture support.
+
+   1.3.7 (April 16th, 2003)
+        - Use del_timer_sync() to ensure that no timeouts
+          are pending during controller shutdown.
+        - For pre-2.5.X kernels, carefully adjust our segment
+          list size to avoid SCSI malloc pool fragmentation.
+        - Cleanup channel display in our /proc output.
+        - Workaround duplicate device entries in the mid-layer
+          devlice list during add-single-device.
+
+   1.3.6 (March 28th, 2003)
+        - Correct a double free in the Domain Validation code.
+        - Correct a reference to free'ed memory during controller
+          shutdown.
+        - Reset the bus on an SE->LVD change.  This is required
+          to reset our transcievers.
+
+   1.3.5 (March 24th, 2003)
+        - Fix a few register window mode bugs.
+        - Include read streaming in the PPR flags we display in
+          diagnostics as well as /proc.
+        - Add PCI hot plug support for 2.5.X kernels.
+        - Correct default precompensation value for RevA hardware.
+        - Fix Domain Validation thread shutdown.
+        - Add a firmware workaround to make the LED blink
+          brighter during packetized operations on the H2A4.
+        - Correct /proc display of user read streaming settings.
+        - Simplify driver locking by releasing the io_request_lock
+          upon driver entry from the mid-layer.
+        - Cleanup command line parsing and move much of this code
+          to aiclib.
+
+   1.3.4 (February 28th, 2003)
+        - Correct a race condition in our error recovery handler.
+        - Allow Test Unit Ready commands to take a full 5 seconds
+          during Domain Validation.
+
+   1.3.2 (February 19th, 2003)
+        - Correct a Rev B. regression due to the GEM318
+          compatibility fix included in 1.3.1.
+          
+   1.3.1 (February 11th, 2003)
+        - Add support for the 39320A.
+        - Improve recovery for certain PCI-X errors.
+        - Fix handling of LQ/DATA/LQ/DATA for the
+          same write transaction that can occur without
+          interveining training.
+        - Correct compatibility issues with the GEM318
+          enclosure services device.
+        - Correct data corruption issue that occurred under
+          high tag depth write loads.
+        - Adapt to a change in the 2.5.X daemonize() API.
+        - Correct a "Missing case in ahd_handle_scsiint" panic.
+
+   1.3.0 (January 21st, 2003)
+        - Full regression testing for all U320 products completed.
+        - Added abort and target/lun reset error recovery handler and
+          interrupt coalessing.
+
+   1.2.0 (November 14th, 2002)
+        - Added support for Domain Validation
+        - Add support for the Hewlett-Packard version of the 39320D
+          and AIC-7902 adapters.
+        Support for previous adapters has not been fully tested and should
+        only be used at the customer's own risk.
+
+   1.1.1 (September 24th, 2002)
+        - Added support for the Linux 2.5.X kernel series
+
+   1.1.0 (September 17th, 2002)
+        - Added support for four additional SCSI products:
+          ASC-39320, ASC-29320, ASC-29320LP, AIC-7901.
+
+   1.0.0 (May 30th, 2002)
+        - Initial driver release.
+
+   2.1. Software/Hardware Features
+        - Support for the SPI-4 "Ultra320" standard:
+          - 320MB/s transfer rates
+          - Packetized SCSI Protocol at 160MB/s and 320MB/s
+          - Quick Arbitration Selection (QAS)
+          - Retained Training Information (Rev B. ASIC only)
+        - Interrupt Coalessing
+        - Initiator Mode (target mode not currently 
+          supported)
+        - Support for the PCI-X standard up to 133MHz
+        - Support for the PCI v2.2 standard
+        - Domain Validation
+
+   2.2. Operating System Support:
+        - Redhat Linux 7.2, 7.3, 8.0, Advanced Server 2.1
+        - SuSE Linux 7.3, 8.0, 8.1, Enterprise Server 7
+        - only Intel and AMD x86 supported at this time
+        - >4GB memory configurations supported.
+
+     Refer to the User's Guide for more details on this.
+
+3. Command Line Options
+
+        WARNING: ALTERING OR ADDING THESE DRIVER PARAMETERS
+                 INCORRECTLY CAN RENDER YOUR SYSTEM INOPERABLE.
+                 USE THEM WITH CAUTION. 
+
+   Edit the file "modules.conf" in the directory /etc and add/edit a
+   line containing 'options aic79xx aic79xx=[command[,command...]]' where
+   'command' is one or more of the following:
+   -----------------------------------------------------------------
+              Option: verbose
+          Definition: enable additional informative messages during
+                      driver operation.
+     Possible Values: This option is a flag
+       Default Value: disabled
+   -----------------------------------------------------------------
+              Option: debug:[value]
+          Definition: Enables various levels of debugging information
+                      The bit definitions for the debugging mask can
+                      be found in drivers/scsi/aic7xxx/aic79xx.h under
+                      the "Debug" heading.
+     Possible Values: 0x0000 = no debugging, 0xffff = full debugging
+       Default Value: 0x0000
+   -----------------------------------------------------------------
+              Option: no_reset
+          Definition: Do not reset the bus during the initial probe
+                      phase
+     Possible Values: This option is a flag
+       Default Value: disabled
+   -----------------------------------------------------------------
+              Option: extended
+          Definition: Force extended translation on the controller
+     Possible Values: This option is a flag
+       Default Value: disabled
+   -----------------------------------------------------------------
+              Option: periodic_otag
+          Definition: Send an ordered tag periodically to prevent
+                      tag starvation.  Needed for some older devices
+     Possible Values: This option is a flag
+       Default Value: disabled
+   -----------------------------------------------------------------
+              Option: reverse_scan
+          Definition: Probe the scsi bus in reverse order, starting
+                      with target 15
+     Possible Values: This option is a flag
+       Default Value: disabled
+   -----------------------------------------------------------------
+              Option: global_tag_depth
+          Definition: Global tag depth for all targets on all busses.
+                      This option sets the default tag depth which
+                      may be selectively overridden vi the tag_info
+                      option.
+     Possible Values: 1 - 253
+       Default Value: 32
+   -----------------------------------------------------------------
+              Option: tag_info:{{value[,value...]}[,{value[,value...]}...]}
+          Definition: Set the per-target tagged queue depth on a
+                      per controller basis.  Both controllers and targets
+                      may be ommitted indicating that they should retain
+                      the default tag depth.
+            Examples: tag_info:{{16,32,32,64,8,8,,32,32,32,32,32,32,32,32,32}
+                        On Controller 0
+                          specifies a tag depth of 16 for target 0
+                          specifies a tag depth of 64 for target 3
+                          specifies a tag depth of 8 for targets 4 and 5
+                          leaves target 6 at the default
+                          specifies a tag depth of 32 for targets 1,2,7-15
+                        All other targets retain the default depth.
+
+                      tag_info:{{},{32,,32}}
+                        On Controller 1
+                          specifies a tag depth of 32 for targets 0 and 2
+                        All other targets retain the default depth.
+                        
+     Possible Values: 1 - 253
+       Default Value: 32
+   -----------------------------------------------------------------
+              Option: rd_strm: {rd_strm_bitmask[,rd_strm_bitmask...]}
+          Definition: Enable read streaming on a per target basis.
+                      The rd_strm_bitmask is a 16 bit hex value in which
+                      each bit represents a target.  Setting the target's
+                      bit to '1' enables read streaming for that
+                      target.  Controllers may be ommitted indicating that
+                      they should retain the default read streaming setting.
+             Example: rd_strm:{0x0041}
+                        On Controller 0
+                          enables read streaming for targets 0 and 6.
+                          disables read streaming for targets 1-5,7-15.
+                        All other targets retain the default read
+                        streaming setting.
+             Example: rd_strm:{0x0023,,0xFFFF}
+                        On Controller 0
+                          enables read streaming for targets 1,2, and 5.
+                          disables read streaming for targets 3,4,6-15.
+                        On Controller 2
+                          enables read streaming for all targets.
+                        All other targets retain the default read
+                        streaming setting.
+                      
+     Possible Values: 0x0000 - 0xffff
+       Default Value: 0x0000
+   -----------------------------------------------------------------
+              Option: dv: {value[,value...]}
+          Definition: Set Domain Validation Policy on a per-controller basis.
+                      Controllers may be ommitted indicating that
+                      they should retain the default read streaming setting.
+             Example: dv:{-1,0,,1,1,0}
+                        On Controller 0 leave DV at its default setting.
+                        On Controller 1 disable DV.
+                        Skip configuration on Controller 2.
+                        On Controllers 3 and 4 enable DV.
+                        On Controller 5 disable DV.
+
+     Possible Values: < 0 Use setting from serial EEPROM.
+                      0 Disable DV
+                      > 0 Enable DV
+       Default Value: DV Serial EEPROM configuration setting.
+   -----------------------------------------------------------------
+              Option: seltime:[value]
+          Definition: Specifies the selection timeout value
+     Possible Values: 0 = 256ms, 1 = 128ms, 2 = 64ms, 3 = 32ms
+       Default Value: 0
+   -----------------------------------------------------------------
+
+   *** The following three options should only be changed at ***
+   *** the direction of a technical support representative.  ***
+
+   -----------------------------------------------------------------
+              Option: precomp: {value[,value...]}
+          Definition: Set IO Cell precompensation value on a per-controller
+                      basis.
+                      Controllers may be ommitted indicating that
+                      they should retain the default precompensation setting.
+             Example: precomp:{0x1}
+                        On Controller 0 set precompensation to 1.
+             Example: precomp:{1,,7}
+                        On Controller 0 set precompensation to 1.
+                        On Controller 2 set precompensation to 8.
+                      
+     Possible Values: 0 - 7
+       Default Value: Varies based on chip revision
+   -----------------------------------------------------------------
+              Option: slewrate: {value[,value...]}
+          Definition: Set IO Cell slew rate on a per-controller basis.
+                      Controllers may be ommitted indicating that
+                      they should retain the default slew rate setting.
+             Example: slewrate:{0x1}
+                        On Controller 0 set slew rate to 1.
+             Example: slewrate :{1,,8}
+                        On Controller 0 set slew rate to 1.
+                        On Controller 2 set slew rate to 8.
+                      
+     Possible Values: 0 - 15
+       Default Value: Varies based on chip revision
+   -----------------------------------------------------------------
+              Option: amplitude: {value[,value...]}
+          Definition: Set IO Cell signal amplitude on a per-controller basis.
+                      Controllers may be ommitted indicating that
+                      they should retain the default read streaming setting.
+             Example: amplitude:{0x1}
+                        On Controller 0 set amplitude to 1.
+             Example: amplitude :{1,,7}
+                        On Controller 0 set amplitude to 1.
+                        On Controller 2 set amplitude to 7.
+                      
+     Possible Values: 1 - 7
+       Default Value: Varies based on chip revision
+   -----------------------------------------------------------------
+
+   Example: 'options aic79xx aic79xx=verbose,rd_strm:{{0x0041}}'
+        enables verbose output in the driver and turns read streaming on
+        for targets 0 and 6 of Controller 0.
+
+4. Additional Notes
+
+   4.1. Known/Unresolved or FYI Issues
+
+        * Under SuSE Linux Enterprise 7, the driver may fail to operate
+          correctly due to a problem with PCI interrupt routing in the
+          Linux kernel.  Please contact SuSE for an updated Linux
+          kernel.
+
+   4.2. Third-Party Compatibility Issues
+
+        * Adaptec only supports Ultra320 hard drives running
+          the latest firmware available. Please check with
+          your hard drive manufacturer to ensure you have the
+          latest version.
+
+   4.3. Operating System or Technology Limitations
+        
+        * PCI Hot Plug is untested and may cause the operating system 
+          to stop responding.
+        * Luns that are not numbered contiguously starting with 0 might not
+          be automatically probed during system startup.  This is a limitation
+          of the OS.  Please contact your Linux vendor for instructions on
+          manually probing non-contiguous luns.
+        * Using the Driver Update Disk version of this package during OS
+          installation under RedHat might result in two versions of this
+          driver being installed into the system module directory.  This
+          might cause problems with the /sbin/mkinitrd program and/or
+          other RPM packages that try to install system modules.  The best
+          way to correct this once the system is running is to install
+          the latest RPM package version of this driver, available from
+          http://www.adaptec.com.
+
+
+5. Adaptec Customer Support
+
+   A Technical Support Identification (TSID) Number is required for 
+   Adaptec technical support.
+    - The 12-digit TSID can be found on the white barcode-type label
+      included inside the box with your product.  The TSID helps us 
+      provide more efficient service by accurately identifying your 
+      product and support status.
+
+   Support Options
+    - Search the Adaptec Support Knowledgebase (ASK) at
+      http://ask.adaptec.com for articles, troubleshooting tips, and
+      frequently asked questions about your product.
+    - For support via Email, submit your question to Adaptec's 
+      Technical Support Specialists at http://ask.adaptec.com/.
+     
+   North America
+    - Visit our Web site at http://www.adaptec.com/.
+    - For information about Adaptec's support options, call
+      408-957-2550, 24 hours a day, 7 days a week.
+    - To speak with a Technical Support Specialist,
+      * For hardware products, call 408-934-7274,
+        Monday to Friday, 3:00 am to 5:00 pm, PDT.
+      * For RAID and Fibre Channel products, call 321-207-2000,
+        Monday to Friday, 3:00 am to 5:00 pm, PDT.
+      To expedite your service, have your computer with you.
+    - To order Adaptec products, including accessories and cables,
+      call 408-957-7274.  To order cables online go to
+      http://www.adaptec.com/buy-cables/.
+
+   Europe
+    - Visit our Web site at http://www.adaptec-europe.com/.
+    - To speak with a Technical Support Specialist, call, or email,
+      * German:  +49 89 4366 5522, Monday-Friday, 9:00-17:00 CET,
+        http://ask-de.adaptec.com/.
+      * French:  +49 89 4366 5533, Monday-Friday, 9:00-17:00 CET,
+	http://ask-fr.adaptec.com/.
+      * English: +49 89 4366 5544, Monday-Friday, 9:00-17:00 GMT,
+	http://ask.adaptec.com/.
+    - You can order Adaptec cables online at
+      http://www.adaptec.com/buy-cables/.
+
+   Japan
+    - Visit our web site at http://www.adaptec.co.jp/.
+    - To speak with a Technical Support Specialist, call 
+      +81 3 5308 6120, Monday-Friday, 9:00 a.m. to 12:00 p.m.,
+      1:00 p.m. to 6:00 p.m.
+
+-------------------------------------------------------------------
+/*
+ * Copyright (c) 2003 Adaptec Inc. 691 S. Milpitas Blvd., Milpitas CA 95035 USA.
+ * All rights reserved.
+ *
+ * You are permitted to redistribute, use and modify this README file in whole
+ * or in part in conjunction with redistribution of software governed by the
+ * General Public License, provided that the following conditions are met:
+ * 1. Redistributions of README file must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ * 3. Modifications or new contributions must be attributed in a copyright
+ *    notice identifying the author ("Contributor") and added below the
+ *    original copyright notice. The copyright notice is for purposes of
+ *    identifying contributors and should not be deemed as permission to alter
+ *    the permissions given by Adaptec.
+ *
+ * THIS README FILE IS PROVIDED BY ADAPTEC AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, ANY
+ * WARRANTIES OF NON-INFRINGEMENT OR THE IMPLIED WARRANTIES OF MERCHANTABILITY
+ * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
+ * ADAPTEC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
+ * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
+ * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS README
+ * FILE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
diff --git a/drivers/scsi/aic7xxx/README.aic7xxx b/drivers/scsi/aic7xxx/README.aic7xxx
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/aic7xxx/README.aic7xxx
@@ -0,0 +1,530 @@
+====================================================================
+=    Adaptec Aic7xxx Fast -> Ultra160 Family Manager Set v6.3.11   =
+=                            README for                            =
+=                     The Linux Operating System                   =
+====================================================================
+
+The following information is available in this file:
+
+  1. Supported Hardware
+  2. Version History
+  3. Command Line Options
+  4. Contacting Adaptec
+
+1. Supported Hardware
+
+   The following Adaptec SCSI Chips and Host Adapters are supported by
+   the aic7xxx driver. 
+
+   Chip    MIPS  Host Bus  MaxSync  MaxWidth  SCBs  Notes
+   ---------------------------------------------------------------
+   aic7770  10    EISA/VL   10MHz    16Bit      4   1
+   aic7850  10    PCI/32    10MHz    8Bit       3
+   aic7855  10    PCI/32    10MHz    8Bit       3
+   aic7856  10    PCI/32    10MHz    8Bit       3
+   aic7859  10    PCI/32    20MHz    8Bit       3
+   aic7860  10    PCI/32    20MHz    8Bit       3
+   aic7870  10    PCI/32    10MHz    16Bit      16
+   aic7880  10    PCI/32    20MHz    16Bit      16
+   aic7890  20    PCI/32    40MHz    16Bit      16      3 4 5 6 7 8
+   aic7891  20    PCI/64    40MHz    16Bit      16      3 4 5 6 7 8
+   aic7892  20   PCI/64-66  80MHz    16Bit      16      3 4 5 6 7 8
+   aic7895  15    PCI/32    20MHz    16Bit      16    2 3 4 5
+   aic7895C 15    PCI/32    20MHz    16Bit      16    2 3 4 5     8
+   aic7896  20    PCI/32    40MHz    16Bit      16    2 3 4 5 6 7 8
+   aic7897  20    PCI/64    40MHz    16Bit      16    2 3 4 5 6 7 8
+   aic7899  20   PCI/64-66  80MHz    16Bit      16    2 3 4 5 6 7 8
+
+   1.   Multiplexed Twin Channel Device - One controller servicing two
+        busses.
+   2.   Multi-function Twin Channel Device - Two controllers on one chip.
+   3.   Command Channel Secondary DMA Engine - Allows scatter gather list
+        and SCB prefetch.
+   4.   64 Byte SCB Support - Allows disconnected, unttagged request table
+        for all possible target/lun combinations.
+   5.   Block Move Instruction Support - Doubles the speed of certain
+        sequencer operations.
+   6.   `Bayonet' style Scatter Gather Engine - Improves S/G prefetch
+        performance.
+   7.   Queuing Registers - Allows queuing of new transactions without
+        pausing the sequencer.
+   8.   Multiple Target IDs - Allows the controller to respond to selection
+        as a target on multiple SCSI IDs.
+
+   Controller      Chip   Host-Bus    Int-Connectors  Ext-Connectors  Notes
+   --------------------------------------------------------------------------
+   AHA-274X[A]    aic7770   EISA         SE-50M         SE-HD50F
+   AHA-274X[A]W   aic7770   EISA         SE-HD68F       SE-HD68F
+                                         SE-50M
+   AHA-274X[A]T   aic7770   EISA       2 X SE-50M       SE-HD50F
+   AHA-2842       aic7770    VL          SE-50M         SE-HD50F
+   AHA-2940AU     aic7860   PCI/32       SE-50M         SE-HD50F
+   AVA-2902I      aic7860   PCI/32       SE-50M
+   AVA-2902E      aic7860   PCI/32       SE-50M
+   AVA-2906       aic7856   PCI/32       SE-50M         SE-DB25F
+   APC-7850       aic7850   PCI/32       SE-50M                       1
+   AVA-2940       aic7860   PCI/32       SE-50M
+   AHA-2920B      aic7860   PCI/32       SE-50M
+   AHA-2930B      aic7860   PCI/32       SE-50M
+   AHA-2920C      aic7856   PCI/32       SE-50M         SE-HD50F
+   AHA-2930C      aic7860   PCI/32       SE-50M
+   AHA-2930C      aic7860   PCI/32       SE-50M
+   AHA-2910C      aic7860   PCI/32       SE-50M
+   AHA-2915C      aic7860   PCI/32       SE-50M
+   AHA-2940AU/CN  aic7860   PCI/32       SE-50M         SE-HD50F
+   AHA-2944W      aic7870   PCI/32     HVD-HD68F        HVD-HD68F
+                                        HVD-50M
+   AHA-3940W      aic7870   PCI/32     2 X SE-HD68F     SE-HD68F        2
+   AHA-2940UW     aic7880   PCI/32       SE-HD68F
+                                         SE-50M         SE-HD68F
+   AHA-2940U      aic7880   PCI/32       SE-50M         SE-HD50F
+   AHA-2940D      aic7880   PCI/32
+   aHA-2940 A/T   aic7880   PCI/32
+   AHA-2940D A/T  aic7880   PCI/32
+   AHA-3940UW     aic7880   PCI/32     2 X SE-HD68F     SE-HD68F          3
+   AHA-3940UWD    aic7880   PCI/32     2 X SE-HD68F   2 X SE-VHD68F       3
+   AHA-3940U      aic7880   PCI/32     2 X SE-50M       SE-HD50F          3
+   AHA-2944UW     aic7880   PCI/32      HVD-HD68F       HVD-HD68F
+                                         HVD-50M
+   AHA-3944UWD    aic7880   PCI/32     2 X HVD-HD68F  2 X HVD-VHD68F      3
+   AHA-4944UW     aic7880   PCI/32
+   AHA-2930UW     aic7880   PCI/32
+   AHA-2940UW Pro aic7880   PCI/32      SE-HD68F        SE-HD68F            4
+                                         SE-50M
+   AHA-2940UW/CN  aic7880   PCI/32
+   AHA-2940UDual  aic7895   PCI/32
+   AHA-2940UWDual aic7895   PCI/32
+   AHA-3940UWD    aic7895   PCI/32
+   AHA-3940AUW    aic7895   PCI/32
+   AHA-3940AUWD   aic7895   PCI/32
+   AHA-3940AU     aic7895   PCI/32
+   AHA-3944AUWD   aic7895   PCI/32     2 X HVD-HD68F  2 X HVD-VHD68F
+   AHA-2940U2B    aic7890   PCI/32      LVD-HD68F       LVD-HD68F
+   AHA-2940U2 OEM aic7891   PCI/64
+   AHA-2940U2W    aic7890   PCI/32      LVD-HD68F       LVD-HD68F
+                                        SE-HD68F 
+                                         SE-50M
+   AHA-2950U2B    aic7891   PCI/64      LVD-HD68F       LVD-HD68F
+   AHA-2930U2     aic7890   PCI/32      LVD-HD68F       SE-HD50F
+                                         SE-50M 
+   AHA-3950U2B    aic7897   PCI/64
+   AHA-3950U2D    aic7897   PCI/64
+   AHA-29160      aic7892   PCI/64-66
+   AHA-29160 CPQ  aic7892   PCI/64-66
+   AHA-29160N     aic7892   PCI/32      LVD-HD68F       SE-HD50F
+                                         SE-50M
+   AHA-29160LP    aic7892   PCI/64-66
+   AHA-19160      aic7892   PCI/64-66
+   AHA-29150LP    aic7892   PCI/64-66
+   AHA-29130LP    aic7892   PCI/64-66
+   AHA-3960D      aic7899   PCI/64-66  2 X LVD-HD68F  2 X LVD-VHD68F
+                                         LVD-50M
+   AHA-3960D CPQ  aic7899   PCI/64-66  2 X LVD-HD68F  2 X LVD-VHD68F
+                                         LVD-50M
+   AHA-39160      aic7899   PCI/64-66  2 X LVD-HD68F  2 X LVD-VHD68F
+                                         LVD-50M
+
+   1. No BIOS support
+   2. DEC21050 PCI-PCI bridge with multiple controller chips on secondary bus
+   3. DEC2115X PCI-PCI bridge with multiple controller chips on secondary bus
+   4. All three SCSI connectors may be used simultaneously without
+      SCSI "stub" effects.
+
+2. Version History
+
+   6.3.11 (December 23, 2004)
+	- Fix wrongly calling scsi_adjust_queue_depth() when
+	  the scsi device has no request_queue.
+	- Adding proper PCI ID tables to support
+          hotplugging.
+	- Fix a compilation issue after scsi_sleep() became
+          obsolete, in stead of the new msleep() and
+          ssleep() functions.
+	- Edit Adaptec Customer Support info.
+	- "Warnings are errors" is now selectable by the
+          kbuild system -- make it so here.
+	- Fix undefined symbol when compiling aic79xx for 2.6.
+	  Also regenerate the aic7xxx reg and seq files.
+	- Fix a double free.  If "ahc_alloc()" fails, it
+          frees the "name" argument passed.
+        - As requested by linux-scsi: Add a flag which explicitly
+          forbids/allows the compilation of the firmware across
+          the whole build system.
+	- When doing domain validation, we send commands
+          which do not have a struct request.  In this case
+          we cannot just call scsi_populate_tag_msg(), since
+          it dereferences it blindly and oopses the kernel.
+          Now we call scsi_populate_tag_msg() only if the
+          SCSI command has a struct request associated with
+          it.
+
+   6.3.10 (July 22, 2004)
+        - Fix a compilation issue due to the changed location and name
+          of the "hosts.h" file.  Now it resides as <scsi/scsi_host.h>
+        - Add support for 16 byte CDBs.
+
+   6.3.9 (May 13th, 2004)
+        - Flag driver threads with PF_FREEZE to support software suspend.
+
+   6.3.8 (April 9th, 2004)
+        - Return "command timeout" status instead of "selection timeout
+	  status" to the SCSI mid-layer in response to selection timeouts.
+	  While the latter may seem more correct, the mid-layer will not
+	  offline devices suffering from persistent selection timeouts.
+	  This leads to extremely long recovery times for devices that
+	  go missing.  Returning command timeout status causes the mid-layer
+	  to enter recovery and eventually offline persistently missing
+	  devices.
+
+   6.3.7 (March 29th, 2004)
+        - Abort all pending transactions on a target in response to
+          a selection timeout.  This greatly increases the speed with
+          which we recover when a device "goes missing".
+
+   6.3.6 (February 24th, 2004)
+        - Implement delay on I/O after delivery of a Target Reset.
+        - Correct deregistration of sysrq handler when multiple
+          controllers are detected.
+        - Correct timeout recovery issues found while debugging
+          active/active failover on an external RAID controller.
+
+   6.3.5 (February 22nd, 2004)
+        - Force a renegotiation on all inqury commands so that
+          the negotiated transfer parameters are correct even
+          if the device has been externally reset since our last
+          command.  Devices are not allowed to report unit attention
+          conditions in response to inquiry requests otherwise we'd
+          not need to treat inquiry commands specially.
+        - Remove all vestiges of pre-2.4.X support.
+        - Move all lock and DMA API support to the aiclib.
+
+   6.3.4 (December 22nd, 2003)
+        - Provide a better description string for the 2915/30LP.
+        - Sniff sense information returned by targets for unit
+          attention errors that may indicate that the device has
+          been changed.  If we see such status for non Domain
+          Validation related commands, start a DV scan for the
+          target.  In the past, DV would only occur for hot-plugged
+          devices if no target had been previously probed for a
+          particular ID.  This change guarantees that the DV process
+          will occur even if the user swaps devices without any
+          interveining I/O to tell us that a device has gone missing.
+          The old behavior, among other things, would fail to spin up
+          drives that were hot-plugged since the Linux mid-layer
+          will only spin-up drives on initial attach.
+
+   6.3.3 (November 6th, 2003)
+        - Support the 2.6.0-test9 kernel
+        - Fix rare deadlock caused by using del_timer_sync from within
+          a timer handler.
+
+   6.3.2 (October 28th, 2003)
+        - Enforce a bus settle delay for bus resets that the
+          driver initiates.
+        - Fall back to basic DV for U160 devices that lack an
+          echo buffer.
+        - Correctly detect that left over BIOS data has not
+          been initialized when the CHPRST status bit is set
+          during driver initialization.
+
+   6.3.1 (October 21st, 2003)
+        - Fix a compiler error when building with only EISA or PCI
+          support compiled into the kernel.
+        - Add chained dependencies to both the driver and aicasm Makefiles
+          to avoid problems with parallel builds.
+        - Move additional common routines to the aiclib OSM library
+          to reduce code duplication.
+        - Fix a bug in the testing of the AHC_TMODE_WIDEODD_BUG that
+          could cause target mode operations to hang.
+        - Leave removal of softcs from the global list of softcs to
+          the OSM.  This allows us to avoid holding the list_lock during
+          device destruction.
+
+   6.3.0 (September 8th, 2003)
+        - Move additional common routines to the aiclib OSM library
+          to reduce code duplication.
+        - Bump minor number to reflect change in error recovery strategy.
+
+   6.2.38 (August 31st, 2003)
+        - Avoid an inadvertant reset of the controller during the
+          memory mapped I/O test should the controller be left in
+          the reset state prior to driver initialization.  On some
+          systems, this extra reset resulted in a system hang due
+          to a chip access that occurred too soon after reset.
+        - Move additional common routines to the aiclib OSM library
+          to reduce code duplication.
+        - Add magic sysrq handler that causes a card dump to be output
+          to the console for each controller.
+
+   6.2.37 (August 12th, 2003)
+        - Perform timeout recovery within the driver instead of relying
+          on the Linux SCSI mid-layer to perform this function.  The
+          mid-layer does not know the full state of the SCSI bus and
+          is therefore prone to looping for several minutes to effect
+          recovery.  The new scheme recovers within 15 seconds of the
+          failure.
+        - Support writing 93c56/66 SEEPROM on newer cards.
+	- Avoid clearing ENBUSFREE during single stepping to avoid
+          spurious "unexpected busfree while idle" messages.
+        - Enable the use of the "Auto-Access-Pause" feature on the
+          aic7880 and aic7870 chips.  It was disabled due to an
+          oversight.  Using this feature drastically reduces command
+          delivery latency.
+
+   6.2.36 (June 3rd, 2003)
+        - Correct code that disables PCI parity error checking.
+        - Correct and simplify handling of the ignore wide residue
+          message.  The previous code would fail to report a residual
+          if the transaction data length was even and we received
+          an IWR message.
+        - Add support for the 2.5.X EISA framework.
+        - Update for change in 2.5.X SCSI proc FS interface.
+        - Correct Domain Validation command-line option parsing.
+        - When negotiation async via an 8bit WDTR message, send
+          an SDTR with an offset of 0 to be sure the target
+          knows we are async.  This works around a firmware defect
+          in the Quantum Atlas 10K.
+        - Clear PCI error state during driver attach so that we
+          don't disable memory mapped I/O due to a stray write
+          by some other driver probe that occurred before we
+          claimed the controller.
+
+   6.2.35 (May 14th, 2003)
+        - Fix a few GCC 3.3 compiler warnings.
+        - Correct operation on EISA Twin Channel controller.
+        - Add support for 2.5.X's scsi_report_device_reset().
+
+   6.2.34 (May 5th, 2003)
+        - Fix locking regression instroduced in 6.2.29 that
+          could cuase a lock order reversal between the io_request_lock
+          and our per-softc lock.  This was only possible on RH9,
+          SuSE, and kernel.org 2.4.X kernels.
+
+   6.2.33 (April 30th, 2003)
+        - Dynamically disable PCI parity error reporting after
+          10 errors are reported to the user.  These errors are
+          the result of some other device issuing PCI transactions
+          with bad parity.  Once the user has been informed of the
+          problem, continuing to report the errors just degrades
+          our performance.
+
+   6.2.32 (March 28th, 2003)
+        - Dynamically sized S/G lists to avoid SCSI malloc
+          pool fragmentation and SCSI mid-layer deadlock.
+
+   6.2.28 (January 20th, 2003)
+        - Domain Validation Fixes
+        - Add ability to disable PCI parity error checking.
+        - Enhanced Memory Mapped I/O probe
+
+   6.2.20 (November 7th, 2002)
+        - Added Domain Validation.
+
+3. Command Line Options
+
+        WARNING: ALTERING OR ADDING THESE DRIVER PARAMETERS
+                 INCORRECTLY CAN RENDER YOUR SYSTEM INOPERABLE.
+                 USE THEM WITH CAUTION. 
+
+   Edit the file "modules.conf" in the directory /etc and add/edit a
+   line containing 'options aic7xxx aic7xxx=[command[,command...]]' where
+   'command' is one or more of the following:
+   -----------------------------------------------------------------
+              Option: verbose
+          Definition: enable additional informative messages during
+                      driver operation.
+     Possible Values: This option is a flag
+       Default Value: disabled
+   -----------------------------------------------------------------
+              Option: debug:[value]
+          Definition: Enables various levels of debugging information
+     Possible Values: 0x0000 = no debugging, 0xffff = full debugging
+       Default Value: 0x0000
+   -----------------------------------------------------------------
+              Option: no_probe
+              Option: probe_eisa_vl
+          Definition: Do not probe for EISA/VLB controllers.
+                      This is a toggle.  If the driver is compiled
+                      to not probe EISA/VLB controllers by default,
+                      specifying "no_probe" will enable this probing.
+                      If the driver is compiled to probe EISA/VLB
+                      controllers by default, specifying "no_probe"
+                      will disable this probing.
+     Possible Values: This option is a toggle
+       Default Value: EISA/VLB probing is disabled by default.
+   -----------------------------------------------------------------
+              Option: pci_parity
+          Definition: Toggles the detection of PCI parity errors.
+                      On many motherboards with VIA chipsets,
+                      PCI parity is not generated correctly on the
+                      PCI bus.  It is impossible for the hardware to
+                      differentiate between these "spurious" parity
+                      errors and real parity errors.  The symptom of
+                      this problem is a stream of the message:
+    "scsi0: Data Parity Error Detected during address or write data phase"
+                      output by the driver.
+     Possible Values: This option is a toggle
+       Default Value: PCI Parity Error reporting is disabled
+   -----------------------------------------------------------------
+              Option: no_reset
+          Definition: Do not reset the bus during the initial probe
+                      phase
+     Possible Values: This option is a flag
+       Default Value: disabled
+   -----------------------------------------------------------------
+              Option: extended
+          Definition: Force extended translation on the controller
+     Possible Values: This option is a flag
+       Default Value: disabled
+   -----------------------------------------------------------------
+              Option: periodic_otag
+          Definition: Send an ordered tag periodically to prevent
+                      tag starvation.  Needed for some older devices
+     Possible Values: This option is a flag
+       Default Value: disabled
+   -----------------------------------------------------------------
+              Option: reverse_scan
+          Definition: Probe the scsi bus in reverse order, starting
+                      with target 15
+     Possible Values: This option is a flag
+       Default Value: disabled
+   -----------------------------------------------------------------
+              Option: global_tag_depth:[value]
+          Definition: Global tag depth for all targets on all busses.
+                      This option sets the default tag depth which
+                      may be selectively overridden vi the tag_info
+                      option.
+     Possible Values: 1 - 253
+       Default Value: 32
+   -----------------------------------------------------------------
+              Option: tag_info:{{value[,value...]}[,{value[,value...]}...]}
+          Definition: Set the per-target tagged queue depth on a
+                      per controller basis.  Both controllers and targets
+                      may be ommitted indicating that they should retain
+                      the default tag depth.
+            Examples: tag_info:{{16,32,32,64,8,8,,32,32,32,32,32,32,32,32,32}
+                        On Controller 0
+                          specifies a tag depth of 16 for target 0
+                          specifies a tag depth of 64 for target 3
+                          specifies a tag depth of 8 for targets 4 and 5
+                          leaves target 6 at the default
+                          specifies a tag depth of 32 for targets 1,2,7-15
+                        All other targets retain the default depth.
+
+                      tag_info:{{},{32,,32}}
+                        On Controller 1
+                          specifies a tag depth of 32 for targets 0 and 2
+                        All other targets retain the default depth.
+                        
+     Possible Values: 1 - 253
+       Default Value: 32
+   -----------------------------------------------------------------
+              Option: seltime:[value]
+          Definition: Specifies the selection timeout value
+     Possible Values: 0 = 256ms, 1 = 128ms, 2 = 64ms, 3 = 32ms
+       Default Value: 0
+   -----------------------------------------------------------------
+              Option: dv: {value[,value...]} 
+          Definition: Set Domain Validation Policy on a per-controller basis.
+                      Controllers may be ommitted indicating that
+                      they should retain the default read streaming setting.
+             Example: dv:{-1,0,,1,1,0}
+                        On Controller 0 leave DV at its default setting.
+                        On Controller 1 disable DV.
+                        Skip configuration on Controller 2.
+                        On Controllers 3 and 4 enable DV.
+                        On Controller 5 disable DV.
+
+     Possible Values: < 0 Use setting from serial EEPROM.
+                      0 Disable DV
+                      > 0 Enable DV
+
+       Default Value: SCSI-Select setting on controllers with a SCSI Select
+                      option for DV.  Otherwise, on for controllers supporting
+                      U160 speeds and off for all other controller types.
+   -----------------------------------------------------------------
+
+   Example:
+   options aic7xxx aic7xxx=verbose,no_probe,tag_info:{{},{,,10}},seltime:1
+        enables verbose logging, Disable EISA/VLB probing,
+        and set tag depth on Controller 1/Target 2 to 10 tags.
+
+3. Adaptec Customer Support
+
+   A Technical Support Identification (TSID) Number is required for 
+   Adaptec technical support.
+    - The 12-digit TSID can be found on the white barcode-type label
+      included inside the box with your product.  The TSID helps us 
+      provide more efficient service by accurately identifying your 
+      product and support status.
+
+   Support Options
+    - Search the Adaptec Support Knowledgebase (ASK) at
+      http://ask.adaptec.com for articles, troubleshooting tips, and
+      frequently asked questions about your product.
+    - For support via Email, submit your question to Adaptec's 
+      Technical Support Specialists at http://ask.adaptec.com/.
+     
+   North America
+    - Visit our Web site at http://www.adaptec.com/.
+    - For information about Adaptec's support options, call
+      408-957-2550, 24 hours a day, 7 days a week.
+    - To speak with a Technical Support Specialist,
+      * For hardware products, call 408-934-7274,
+        Monday to Friday, 3:00 am to 5:00 pm, PDT.
+      * For RAID and Fibre Channel products, call 321-207-2000,
+        Monday to Friday, 3:00 am to 5:00 pm, PDT.
+      To expedite your service, have your computer with you.
+    - To order Adaptec products, including accessories and cables,
+      call 408-957-7274.  To order cables online go to
+      http://www.adaptec.com/buy-cables/.
+
+   Europe
+    - Visit our Web site at http://www.adaptec-europe.com/.
+    - To speak with a Technical Support Specialist, call, or email,
+      * German:  +49 89 4366 5522, Monday-Friday, 9:00-17:00 CET,
+        http://ask-de.adaptec.com/.
+      * French:  +49 89 4366 5533, Monday-Friday, 9:00-17:00 CET,
+	http://ask-fr.adaptec.com/.
+      * English: +49 89 4366 5544, Monday-Friday, 9:00-17:00 GMT,
+	http://ask.adaptec.com/.
+    - You can order Adaptec cables online at
+      http://www.adaptec.com/buy-cables/.
+
+   Japan
+    - Visit our web site at http://www.adaptec.co.jp/.
+    - To speak with a Technical Support Specialist, call 
+      +81 3 5308 6120, Monday-Friday, 9:00 a.m. to 12:00 p.m.,
+      1:00 p.m. to 6:00 p.m.
+
+-------------------------------------------------------------------
+/*
+ * Copyright (c) 2003 Adaptec Inc. 691 S. Milpitas Blvd., Milpitas CA 95035 USA.
+ * All rights reserved.
+ *
+ * You are permitted to redistribute, use and modify this README file in whole
+ * or in part in conjunction with redistribution of software governed by the
+ * General Public License, provided that the following conditions are met:
+ * 1. Redistributions of README file must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. The name of the author may not be used to endorse or promote products
+ *    derived from this software without specific prior written permission.
+ * 3. Modifications or new contributions must be attributed in a copyright
+ *    notice identifying the author ("Contributor") and added below the
+ *    original copyright notice. The copyright notice is for purposes of
+ *    identifying contributors and should not be deemed as permission to alter
+ *    the permissions given by Adaptec.
+ *
+ * THIS README FILE IS PROVIDED BY ADAPTEC AND CONTRIBUTORS ``AS IS'' AND
+ * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, ANY
+ * WARRANTIES OF NON-INFRINGEMENT OR THE IMPLIED WARRANTIES OF MERCHANTABILITY
+ * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
+ * ADAPTEC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
+ * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
+ * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
+ * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
+ * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS README
+ * FILE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#249 $
+ * $Id: //depot/aic7xxx/aic7xxx/aic79xx.c#250 $
  */
 
 #ifdef __linux__
@@ -3332,6 +3332,15 @@ ahd_update_neg_table(struct ahd_softc *a
 		con_opts |= WIDEXFER;
 
 	/*
+	 * Slow down our CRC interval to be
+	 * compatible with packetized U320 devices
+	 * that can't handle a CRC at full speed
+	 */
+	if (ahd->features & AHD_AIC79XXB_SLOWCRC) {
+		con_opts |= ENSLOWCRC;
+	}
+
+	/*
 	 * During packetized transfers, the target will
 	 * give us the oportunity to send command packets
 	 * without us asserting attention.
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -36,7 +36,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#137 $
+ * $Id: //depot/aic7xxx/linux/drivers/scsi/aic7xxx/aic79xx_osm.h#166 $
  *
  */
 #ifndef _AIC79XX_LINUX_H_
diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/aicasm/Makefile
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -34,14 +34,10 @@ $(PROG):  ${GENHDRS} $(SRCS)
 	$(AICASM_CC) $(AICASM_CFLAGS) $(SRCS) -o $(PROG) $(LIBS)
 
 aicdb.h:
-	@if [ -e "/usr/include/db4/db_185.h" ]; then		\
-		echo "#include <db4/db_185.h>" > aicdb.h;	\
-	 elif [ -e "/usr/include/db3/db_185.h" ]; then		\
+	@if [ -e "/usr/include/db3/db_185.h" ]; then		\
 		echo "#include <db3/db_185.h>" > aicdb.h;	\
 	 elif [ -e "/usr/include/db2/db_185.h" ]; then		\
 		echo "#include <db2/db_185.h>" > aicdb.h;	\
-	 elif [ -e "/usr/include/db1/db_185.h" ]; then		\
-		echo "#include <db1/db_185.h>" > aicdb.h;	\
 	 elif [ -e "/usr/include/db/db_185.h" ]; then		\
 		echo "#include <db/db_185.h>" > aicdb.h;	\
 	 elif [ -e "/usr/include/db_185.h" ]; then		\
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm.c b/drivers/scsi/aic7xxx/aicasm/aicasm.c
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm.c
@@ -37,7 +37,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm.c#22 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm.c#23 $
  *
  * $FreeBSD$
  */
@@ -609,10 +609,10 @@ output_listing(char *ifilename)
 
 		while (line < cur_instr->srcline) {
 			fgets(buf, sizeof(buf), ifile);
-				fprintf(listfile, "\t\t%s", buf);
+				fprintf(listfile, "             \t%s", buf);
 				line++;
 		}
-		fprintf(listfile, "%03x %02x%02x%02x%02x", instrptr,
+		fprintf(listfile, "%04x %02x%02x%02x%02x", instrptr,
 #ifdef __LITTLE_ENDIAN
 			cur_instr->format.bytes[0],
 			cur_instr->format.bytes[1],
@@ -624,14 +624,23 @@ output_listing(char *ifilename)
 			cur_instr->format.bytes[1],
 			cur_instr->format.bytes[0]);
 #endif
-		fgets(buf, sizeof(buf), ifile);
-		fprintf(listfile, "\t%s", buf);
-		line++;
+		/*
+		 * Macro expansions can cause several instructions
+		 * to be output for a single source line.  Only
+		 * advance the line once in these cases.
+		 */
+		if (line == cur_instr->srcline) {
+			fgets(buf, sizeof(buf), ifile);
+			fprintf(listfile, "\t%s", buf);
+			line++;
+		} else {
+			fprintf(listfile, "\n");
+		}
 		instrptr++;
 	}
 	/* Dump the remainder of the file */
 	while(fgets(buf, sizeof(buf), ifile) != NULL)
-		fprintf(listfile, "\t\t%s", buf);
+		fprintf(listfile, "             %s", buf);
 
 	fclose(ifile);
 }
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -38,7 +38,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_gram.y#29 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_gram.y#30 $
  *
  * $FreeBSD$
  */
@@ -157,6 +157,8 @@ static int  is_download_const(expression
 
 %token T_END_CS
 
+%token T_PAD_PAGE
+
 %token T_FIELD
 
 %token T_ENUM
@@ -189,6 +191,10 @@ static int  is_download_const(expression
 
 %token <value> T_OR
 
+/* 16 bit extensions */
+%token <value> T_OR16 T_AND16 T_XOR16 T_ADD16
+%token <value> T_ADC16 T_MVI16 T_TEST16 T_CMP16 T_CMPXCHG
+
 %token T_RET
 
 %token T_NOP
@@ -207,7 +213,7 @@ static int  is_download_const(expression
 
 %type <expression> expression immediate immediate_or_a
 
-%type <value> export ret f1_opcode f2_opcode jmp_jc_jnc_call jz_jnz je_jne
+%type <value> export ret f1_opcode f2_opcode f4_opcode jmp_jc_jnc_call jz_jnz je_jne
 
 %type <value> mode_value mode_list macro_arglist
 
@@ -1304,6 +1310,15 @@ f2_opcode:
 |	T_ROR { $$ = AIC_OP_ROR; }
 ;
 
+f4_opcode:
+	T_OR16	{ $$ = AIC_OP_OR16; }
+|	T_AND16 { $$ = AIC_OP_AND16; }
+|	T_XOR16 { $$ = AIC_OP_XOR16; }
+|	T_ADD16 { $$ = AIC_OP_ADD16; }
+|	T_ADC16 { $$ = AIC_OP_ADC16; }
+|	T_MVI16 { $$ = AIC_OP_MVI16; }
+;
+
 code:
 	f2_opcode destination ',' expression opt_source ret ';'
 	{
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_insformat.h
@@ -37,13 +37,14 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_insformat.h#11 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_insformat.h#12 $
  *
  * $FreeBSD$
  */
 
 #include <asm/byteorder.h>
 
+/* 8bit ALU logic operations */
 struct ins_format1 {
 #ifdef __LITTLE_ENDIAN
 	uint32_t	immediate	: 8,
@@ -62,6 +63,7 @@ struct ins_format1 {
 #endif
 };
 
+/* 8bit ALU shift/rotate operations */
 struct ins_format2 {
 #ifdef __LITTLE_ENDIAN
 	uint32_t	shift_control	: 8,
@@ -80,6 +82,7 @@ struct ins_format2 {
 #endif
 };
 
+/* 8bit branch control operations */
 struct ins_format3 {
 #ifdef __LITTLE_ENDIAN
 	uint32_t	immediate	: 8,
@@ -96,10 +99,68 @@ struct ins_format3 {
 #endif
 };
 
+/* 16bit ALU logic operations */
+struct ins_format4 {
+#ifdef __LITTLE_ENDIAN
+	uint32_t	opcode_ext	: 8,
+			source		: 9,
+			destination	: 9,
+			ret		: 1,
+			opcode		: 4,
+			parity		: 1;
+#else
+	uint32_t	parity		: 1,
+			opcode		: 4,
+			ret		: 1,
+			destination	: 9,
+			source		: 9,
+			opcode_ext	: 8;
+#endif
+};
+
+/* 16bit branch control operations */
+struct ins_format5 {
+#ifdef __LITTLE_ENDIAN
+	uint32_t	opcode_ext	: 8,
+			source		: 9,
+			address		: 10,
+			opcode		: 4,
+			parity		: 1;
+#else
+	uint32_t	parity		: 1,
+			opcode		: 4,
+			address		: 10,
+			source		: 9,
+			opcode_ext	: 8;
+#endif
+};
+
+/*  Far branch operations */
+struct ins_format6 {
+#ifdef __LITTLE_ENDIAN
+	uint32_t	page		: 3,
+			opcode_ext	: 5,
+			source		: 9,
+			address		: 10,
+			opcode		: 4,
+			parity		: 1;
+#else
+	uint32_t	parity		: 1,
+			opcode		: 4,
+			address		: 10,
+			source		: 9,
+			opcode_ext	: 5,
+			page		: 3;
+#endif
+};
+
 union ins_formats {
 		struct ins_format1 format1;
 		struct ins_format2 format2;
 		struct ins_format3 format3;
+		struct ins_format4 format4;
+		struct ins_format5 format5;
+		struct ins_format6 format6;
 		uint8_t		   bytes[4];
 		uint32_t	   integer;
 };
@@ -118,6 +179,8 @@ struct instruction {
 #define	AIC_OP_ROL	0x5
 #define	AIC_OP_BMOV	0x6
 
+#define	AIC_OP_MVI16	0x7
+
 #define	AIC_OP_JMP	0x8
 #define AIC_OP_JC	0x9
 #define AIC_OP_JNC	0xa
@@ -131,3 +194,26 @@ struct instruction {
 #define	AIC_OP_SHL	0x10
 #define	AIC_OP_SHR	0x20
 #define	AIC_OP_ROR	0x30
+
+/* 16bit Ops. Low byte main opcode.  High byte extended opcode. */ 
+#define	AIC_OP_OR16	0x8005
+#define	AIC_OP_AND16	0x8105
+#define	AIC_OP_XOR16	0x8205
+#define	AIC_OP_ADD16	0x8305
+#define	AIC_OP_ADC16	0x8405
+#define AIC_OP_JNE16	0x8805
+#define AIC_OP_JNZ16	0x8905
+#define AIC_OP_JE16	0x8C05
+#define AIC_OP_JZ16	0x8B05
+#define AIC_OP_JMP16	0x9005
+#define AIC_OP_JC16	0x9105
+#define AIC_OP_JNC16	0x9205
+#define AIC_OP_CALL16	0x9305
+#define AIC_OP_CALL16	0x9305
+
+/* Page extension is low three bits of second opcode byte. */
+#define AIC_OP_JMPF	0xA005
+#define AIC_OP_CALLF	0xB005
+#define AIC_OP_JCF	0xC005
+#define AIC_OP_JNCF	0xD005
+#define AIC_OP_CMPXCHG	0xE005
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -38,7 +38,7 @@
  * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  * POSSIBILITY OF SUCH DAMAGES.
  *
- * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_scan.l#19 $
+ * $Id: //depot/aic7xxx/aic7xxx/aicasm/aicasm_scan.l#20 $
  *
  * $FreeBSD$
  */
@@ -132,7 +132,7 @@ if[ \t]*\(		{
 						*string_buf_ptr++ = *yptr++;
 				}
 			}
-
+else			{ return T_ELSE; }
 VERSION			{ return T_VERSION; }
 PREFIX			{ return T_PREFIX; }
 PATCH_ARG_LIST		{ return T_PATCH_ARG_LIST; }
@@ -173,10 +173,6 @@ RW|RO|WO		{
 					yylval.value = WO;
 				 return T_MODE;
 			}
-BEGIN_CRITICAL		{ return T_BEGIN_CS; }
-END_CRITICAL		{ return T_END_CS; }
-SET_SRC_MODE		{ return T_SET_SRC_MODE; }
-SET_DST_MODE		{ return T_SET_DST_MODE; }
 field			{ return T_FIELD; }
 enum			{ return T_ENUM; }
 mask			{ return T_MASK; }
@@ -192,6 +188,13 @@ none			{ return T_NONE; }
 sindex			{ return T_SINDEX; }
 A			{ return T_A; }
 
+	/* Instruction Formatting */
+PAD_PAGE		{ return T_PAD_PAGE; }
+BEGIN_CRITICAL		{ return T_BEGIN_CS; }
+END_CRITICAL		{ return T_END_CS; }
+SET_SRC_MODE		{ return T_SET_SRC_MODE; }
+SET_DST_MODE		{ return T_SET_DST_MODE; }
+
 	/* Opcodes */
 shl			{ return T_SHL; }
 shr			{ return T_SHR; }
@@ -223,7 +226,17 @@ and			{ return T_AND;	}
 or			{ return T_OR;	}
 ret			{ return T_RET; }
 nop			{ return T_NOP; }
-else			{ return T_ELSE; }
+
+	/* ARP2 16bit extensions */
+or16			{ return T_OR16; }
+and16			{ return T_AND16; }
+xor16			{ return T_XOR16; }
+add16			{ return T_ADD16; }
+adc16			{ return T_ADC16; }
+mvi16			{ return T_MVI16; }
+test16			{ return T_TEST16; }
+cmp16			{ return T_CMP16; }
+cmpxchg			{ return T_CMPXCHG; }
 
 	/* Allowed Symbols */
 \<\<			{ return T_EXPR_LSHIFT; }

--------------090409020807080505070401--
