From: Xose Vazquez Perez <xose@wanadoo.es>
Subject: Re: ADAPTEC 2.4 drivers too old
Date: Sat, 13 Mar 2004 20:09:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40535C61.1020408@wanadoo.es>
References: <405351A5.3010708@wanadoo.es> <1079203519.4446.5.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from boun03.eresmas.com ([62.81.235.118]:57481 "EHLO
	boun03.in.mad.eresmas.com") by vger.kernel.org with ESMTP
	id S263126AbUCMTJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Mar 2004 14:09:55 -0500
In-Reply-To: <1079203519.4446.5.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: 'linux-scsi' <linux-scsi@vger.kernel.org>

Arjan van de Ven wrote:

> I object to the words "too old" in your subject.
> The reality is that 2.4 doesn't have the brand-spanking-newest driver
> version *numbers*. So what? Newer != automatically better.

http://marc.theaimsgroup.com/?l=linux-kernel&m=107456492323846&w=2

"... and left at least the aic79xx driver in a worse state than it
was in before ..."

replace "too old" with "buggy", changelog:

     2.0.6 (February 6th, 2004)
         - Force a renegotiation on all inqury commands so that
           the negotiated transfer parameters are correct even
           if the device has been externally reset since our last
           command.  Devices are not allowed to report unit attention
           conditions in response to inquiry requests otherwise we'd
           not need to treat inquiry commands specially.
         - Remove all vestiges of pre-2.4.X support.
         - Close a very rare race-condition in RevA 790X controllers.
           If both FIFOs are allocated before the sequencer's idle
           loop is able to service the FIFO that was allocated first,
           the sequencer could handle them out of order.  This could
           lead to a deadlock where the FIFO attached to the SCSI bus
           is being serviced by the sequencer, but the other FIFO is
           required to handle a snapshot.  The sequencer now detects
           this condition and always handles FIFOs that are not currently
           on the bus first.
         - Close a few race conditions by adding critical section
           markers into the firmware.  These windows might have caused
           issues during error recovery.
         - Switch the complete DMA SCB list to a tailq so that multiple
           SCBs completing with non-zero status do not interfere with
           the state for the SCB currently being uploaded.
         - Use the comparison of a kernel and a sequencer qfreeze
           count to control the freezing of outgoing selections.  This
           allows the kernel to handle non-zero SCB completions without
           having to clear firmware critical sections.
         - Change the completion FIFO mechanism so that all completion
           entries are guaranteed aligned on a 64bit boundary.  This
           avoids SCB DMA engine bugs that are triggered if the transfer
           is interrupted (e.g. PCI disconnect) on a non-aligned boundary.
           In some cases, these bugs would result in duplicate completions.
         - Use one byte in the new completion entry to indicate if the
           SCB completed without a residual or non-zero SCSI status.  This
           avoids an extra memory reference in our interrupt handler.

    2.0.5 (December 22nd, 2003)
         - Correct a bug preventing the driver from renegotiating
           during auto-request sense operations when a check
           condition occurred for a zero length command.
         - Sniff sense information returned by targets for unit
           attention errors that may indicate that the device has
           been changed.  If we see such status for non Domain
           Validation related commands, start a DV scan for the
           target.  In the past, DV would only occur for hot-plugged
           devices if no target had been previously probed for a
           particular ID.  This change guarantees that the DV process
           will occur even if the user swaps devices without any
           interveining I/O to tell us that a device has gone missing.
           The old behavior, among other things, would fail to spin up
           drives that were hot-plugged since the Linux mid-layer
           will only spin-up drives on initial attach.
         - Correct several issues in the rundown of the good status
           FIFO during error recovery.  The typical failure scenario
           evidenced by this defect was the loss of several commands
           under high load when	 several queue full conditions occured
           back to back.

    2.0.4 (November 6th, 2003)
         - Support the 2.6.0-test9 kernel
         - Fix rare deadlock caused by using del_timer_sync from within
           a timer handler.

    2.0.3 (October 21st, 2003)
         - On 7902A4 hardware, use the slow slew rate for transfer
           rates slower than U320.  This behavior matches the Windows
           driver.
         - Fix some issues with the ahd_flush_qoutfifo() routine.
         - Add a delay in the loop waiting for selection activity
           to cease.  Otherwise we may exhaust the loop counter too
           quickly on fast machines.
         - Return to processing bad status completions through the
           qoutfifo.  This reduces the amount of time the controller
           is paused for these kinds of errors.
         - Move additional common routines to the aiclib OSM library
           to reduce code duplication.
         - Leave removal of softcs from the global list of softcs to
           the OSM.  This allows us to avoid holding the list_lock during
           device destruction.
         - Enforce a bus settle delay for bus resets that the
           driver initiates.
         - Fall back to basic DV for U160 devices that lack an
           echo buffer.

    2.0.2 (September 4th, 2003)
         - Move additional common routines to the aiclib OSM library
           to reduce code duplication.
         - Avoid an inadvertant reset of the controller during the
           memory mapped I/O test should the controller be left in
           the reset state prior to driver initialization.  On some
           systems, this extra reset resulted in a system hang due
           to a chip access that occurred too soon after reset.
         - Correct an endian bug in ahd_swap_with_next_hscb.  This
           corrects strong-arm support.
         - Reset the bus for transactions that timeout waiting for
           the bus to go free after a disconnect or command complete
           message.

    2.0.1 (August 26th, 2003)
         - Add magic sysrq handler that causes a card dump to be output
           to the console for each controller.
         - Avoid waking the mid-layer's error recovery handler during
           timeout recovery by returning DID_ERROR instead of DID_TIMEOUT
           for timed-out commands that have been aborted.
         - Move additional common routines to the aiclib OSM library
           to reduce code duplication.

    2.0.0 (August 20th, 2003)
         - Remove MMAPIO definition and allow memory mapped
           I/O for any platform that supports PCI.
         - Avoid clearing ENBUSFREE during single stepping to avoid
           spurious "unexpected busfree while idle" messages.
         - Correct deadlock in ahd_run_qoutfifo() processing.
         - Optimize support for the 7901B.
         - Correct a few cases where an explicit flush of pending
           register writes was required to ensure acuracy in delays.
         - Correct problems in manually flushing completed commands
           on the controller.  The FIFOs are now flushed to ensure
           that completed commands that are still draining to the
           host are completed correctly.
         - Correct incomplete CDB delivery detection on the 790XB.
         - Ignore the cmd->underflow field since userland applications
           using the legacy command pass-thru interface do not set
           it correctly.  Honoring this field led to spurious errors
           when users used the "scsi_unique_id" program.
         - Perform timeout recovery within the driver instead of relying
           on the Linux SCSI mid-layer to perform this function.  The
           mid-layer does not know the full state of the SCSI bus and
           is therefore prone to looping for several minutes to effect
           recovery.  The new scheme recovers within 15 seconds of the
           failure.
         - Correct support for manual termination settings.
         - Increase maximum wait time for serial eeprom writes allowing
           writes to function correctly.

    1.3.12 (August 11, 2003)
         - Implement new error recovery thread that supercedes the existing
           Linux SCSI error recovery code.
         - Fix termination logic for 29320ALP.
         - Fix SEEPROM delay to compensate for write ops taking longer.

    1.3.11 (July 11, 2003)
         - Fix several deadlock issues.
         - Add 29320ALP and 39320B Id's.


