From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 00/37] remote node context rework
Date: Thu, 22 Mar 2012 17:27:48 -0700
Message-ID: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63086 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2CWAMV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:12:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This series is unfortunately being posted during the merge window but has
been in development since the beginning of February.  Part of the delay
in getting it posted was due to waiting for the libsas error-handling
and hotplug work to stabilize, and waiting for the full test results to
come back showing that this development topic was effective.

With these patches, on top of the libsas changes, our hotplug /
exception handling tests are now passing.  Previously we were seeing
frequent system crashes and sometimes locking up the silicon.  I will
let Jeff describe the technical changes in more detail, but it bears
pointing out that this comes with a modest but welcome cleanup of the
code complexity:

 15 files changed, 1316 insertions(+), 1633 deletions(-)

Also available via:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git isci-rnc-v1

...this topic builds on top of isci-for-3.4-v4.

--
Dan

From: Jeff Skirvin

In the controller, devices as they appear on a SAS domain (or
direct-attached SATA devices) are represented by memory structures known
as "Remote Node Contexts" (RNCs).  These structures are transferred from
main memory to the controller using a set of register commands; these
commands include setting up the context ("posting"), removing the
context ("invalidating"), and commands to control the scheduling of
commands and connections to that remote device ("suspensions" and
"resumptions").  There is a similar path to control RNC scheduling from
the protocol engine, which interprets the results of command and data
transmission and reception.

In general, the controller chooses among non-suspended RNCs to find one
that has work requiring scheduling the transmission of command and data
frames to a target.  Likewise, when a target tries to return data back
to the initiator, the state of the RNC is used by the controller to
determine how to treat the incoming request. As an example, if the RNC
is in the state "TX/RX Suspended", incoming SSP connection requests from
the target will be rejected by the controller hardware.  When an RNC is
"TX Suspended", it will not be selected by the controller hardware to
start outgoing command or data operations (with certain priority-based
exceptions).

As mentioned above, there are two sources for management of the RNC
states: commands from driver software, and the result of transmission
and reception conditions of commands and data signaled by the controller
hardware.  As an example of the latter, if an outgoing SSP command ends
with a OPEN_REJECT(BAD_DESTINATION) status, the RNC state will
transition to the "TX Suspended" state, and this is signaled by the
controller hardware in the status to the completion of the pending
command as well as signaled in a controller hardware event.  Examples of
the former are included in the patch changelogs.

Driver software is required to suspend the RNC in a "TX/RX Suspended"
condition before any outstanding commands can be terminated.  Failure to
guarantee this can lead to a complete hardware hang condition.  Earlier
versions of the driver software did not guarantee that an RNC was
correctly managed before I/O termination, and so operated in an unsafe
way.

Further, the driver performed unnecessary contortions to preserve the
remote device command state and so was more complicated than it needed
to be.  A simplifying driver assumption is that once an I/O has entered
the error handler path without having completed in the target, the
requirement on the driver is that all use of the sas_task must end.
Beyond that, recovery of operation is dependent on libsas and other
components to reset, rediscover and reconfigure the device before normal
operation can restart.  In the driver, this simplifying assumption meant
that the RNC management could be reduced to entry into the suspended
state, terminating the targeted I/O request, and resuming the RNC as
needed for device-specific management such as an SSP Abort Task or LUN
Reset Management request.

---

Jeff Skirvin (37):
      isci: Manage the link layer hang detect timer for RNC suspensions.
      isci: Fixed bug in resumption from RNC Tx/Rx suspend state.
      isci: Handle all suspending TC completions
      isci: Terminate outstanding TCs on TX/RX RNC suspensions.
      isci: Manage device suspensions during TC terminations.
      isci: Remote device must be suspended for NCQ cleanup.
      isci: Remote device stop also suspends the RNC and terminates I/O.
      isci: Escalate to I_T_Nexus_Reset when the device is gone.
      isci: Redesign device suspension, abort, cleanup.
      isci: Add suspension cases for RNC INVALIDATING, POSTING states.
      isci: Device access in the error path does not depend on IDEV_GONE.
      isci: All pending TCs are terminated when the RNC is invalidated.
      isci: Only set IDEV_GONE in the device stop path.
      isci: Remove isci_device reqs_in_process and dev_node from isci_device.
      isci: Distinguish between remote device suspension cases
      isci: Fix the terminated I/O to not call sas_task_abort().
      isci: Save the suspension hint for upcoming suspensions.
      isci: Manage the LLHANG timer enable/disable per-device.
      isci: Make sure all TCs are terminated and cleaned in LUN reset.
      isci: Implement waiting for suspend in the abort path.
      isci: When in the abort path, defeat other resume calls until done.
      isci: Callbacks to libsas occur under scic_lock and are synchronized.
      isci: Manage tag releases differently when aborting tasks.
      isci: Fix RNC suspend call for SCI_RESUMING state.
      isci: Wait for RNC resumption before leaving the abort path.
      isci: Directly control IREQ_ABORT_PATH_ACTIVE when completing TMFs.
      isci: Add protocol indicator for TMF requests.
      isci: Added timeouts to RNC suspensions in the abort path.
      isci: Change the phy control and link reset interface for HW reasons.
      isci: Don't wait for an RNC suspend if it's being destroyed.
      isci: Restore the ATAPI device RNC management code.
      isci: Check IDEV_GONE before performing abort path operations.
      isci: Remove obviated host callback list.
      isci: Manage the IREQ_NO_AUTO_FREE_TAG under scic_lock.
      isci: Fix RNC AWAIT_SUSPENSION->INVALIDATING transition.
      isci: Fixed RNC bug that lost the suspension or resumption during destroy
      isci: End the RNC resumption wait when the RNC is destroyed.

 drivers/scsi/isci/host.c                 |  143 ++---
 drivers/scsi/isci/host.h                 |    8 
 drivers/scsi/isci/init.c                 |    3 
 drivers/scsi/isci/phy.c                  |    2 
 drivers/scsi/isci/port.c                 |   45 +-
 drivers/scsi/isci/port.h                 |    5 
 drivers/scsi/isci/remote_device.c        |  547 ++++++++++++++++-----
 drivers/scsi/isci/remote_device.h        |   62 ++
 drivers/scsi/isci/remote_node_context.c  |  345 ++++++++++---
 drivers/scsi/isci/remote_node_context.h  |   43 +-
 drivers/scsi/isci/request.c              |  696 +++++++++++---------------
 drivers/scsi/isci/request.h              |  116 ----
 drivers/scsi/isci/scu_completion_codes.h |    2 
 drivers/scsi/isci/task.c                 |  800 +++++-------------------------
 drivers/scsi/isci/task.h                 |  132 -----
 15 files changed, 1316 insertions(+), 1633 deletions(-)
