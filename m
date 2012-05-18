From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] isci update for 3.5
Date: Fri, 18 May 2012 00:54:39 -0700
Message-ID: <1337327709.18204.17.camel@dwillia2-mobl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:65290 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761293Ab2ERHzT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 May 2012 03:55:19 -0400
Received: by yenq6 with SMTP id q6so2573016yen.25
        for <linux-scsi@vger.kernel.org>; Fri, 18 May 2012 00:55:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

James,

The following changes since commit 36be50515fe2aef61533b516fa2576a2c7fe7664:

  Linux 3.4-rc7 (2012-05-12 18:37:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git tags/isci-for-3.5

for you to fetch changes up to de2eb4d5c5c25e8fb75d1e19092f24b83cb7d8d5:

  isci: End the RNC resumption wait when the RNC is destroyed. (2012-05-17 14:33:44 -0700)

All of these, except "isci: fix oem parameter validation on single
controller skus" were posted before 3.4-rc1, and have been in -next.
This update was recently rebased to lose any entanglements with the
pending libsas changes [1].  Build integrity of each commit was
re-verified.

There is one (not included) patch to turn on suspend/resume support in
the isci driver [2] that depends on the pending libsas update.

--
Dan

[1]: http://marc.info/?l=linux-scsi&m=133632746229553&w=2
[2]: http://marc.info/?l=linux-scsi&m=133145008328785&w=2

----------------------------------------------------------------
isci update for 3.5

1/ Rework remote-node-context (RNC) handling for proper management of
   the silicon state machine in error handling and hot-plug conditions.
   Further details below, suffice to say if the RNC is mismanaged the
   silicon state machines may lock up.

2/ Refactor the initialization code to be reused for suspend/resume support

3/ Miscellaneous bug fixes to address discovery issues and hardware
   compatibility.

RNC rework details from Jeff Skirvin:

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

----------------------------------------------------------------
Andrzej Jakowski (1):
      isci: Changes in COMSAS timings enabling ISCI to detect buggy disc drives.

Dan Williams (11):
      isci: improve 'invalid state' warnings
      isci: kill ->is_direct_attached
      isci: kill sci_phy_protocol and sci_request_protocol
      isci: kill ->status, and ->state_lock in isci_host
      isci: kill isci_port.domain_dev_list
      isci: refactor initialization for S3/S4
      isci: fix controller stop
      isci: fix 'link-up' events occur after 'start-complete'
      isci: fix interrupt disable
      isci: kill isci_host.shost
      isci: fix oem parameter validation on single controller skus

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

Maciej Trela (1):
      isci: enable BCN in sci_port_add_phy()

Tom Jackson (1):
      isci: Don't filter BROADCAST CHANGE primitives

 drivers/scsi/isci/host.c                      |  703 ++++++++--------------
 drivers/scsi/isci/host.h                      |  124 ++--
 drivers/scsi/isci/init.c                      |  212 ++++++-
 drivers/scsi/isci/phy.c                       |   76 ++-
 drivers/scsi/isci/phy.h                       |    9 +-
 drivers/scsi/isci/port.c                      |   68 ++-
 drivers/scsi/isci/port.h                      |   11 +-
 drivers/scsi/isci/port_config.c               |   18 +-
 drivers/scsi/isci/probe_roms.c                |   12 -
 drivers/scsi/isci/probe_roms.h                |    2 -
 drivers/scsi/isci/registers.h                 |    8 +
 drivers/scsi/isci/remote_device.c             |  576 +++++++++++++-----
 drivers/scsi/isci/remote_device.h             |   63 +-
 drivers/scsi/isci/remote_node_context.c       |  393 ++++++++----
 drivers/scsi/isci/remote_node_context.h       |   43 +-
 drivers/scsi/isci/request.c                   |  715 ++++++++++------------
 drivers/scsi/isci/request.h                   |  125 +---
 drivers/scsi/isci/scu_completion_codes.h      |    2 +
 drivers/scsi/isci/task.c                      |  800 +++++--------------------
 drivers/scsi/isci/task.h                      |  132 +---
 drivers/scsi/isci/unsolicited_frame_control.c |   30 +-
 drivers/scsi/isci/unsolicited_frame_control.h |    6 +-
 include/scsi/sas.h                            |    1 +
 23 files changed, 1874 insertions(+), 2255 deletions(-)


