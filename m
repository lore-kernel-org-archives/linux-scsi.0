From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT] isci: fixes and cleanups
Date: Thu, 10 Mar 2011 00:55:56 -0800
Message-ID: <1299747356.31565.24.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55586 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab1CJIyp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 03:54:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>, David Milburn <dmilburn@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>

The isci git tree:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

=2E..has been updated with the following:

1/ task lifetime fixes
2/ removal of drivers/scsi/isci/deprecated.c (os abstraction layer)
3/ dma api and kmap fixes
4/ locking cleanups (host_quiesce_lock and remote_device_lock removed)
5/ first round of lldd_dev lifetime fixes
6/ workaround for a port task scheduler silicon issue
7/ various other fixes and cleanups
8/ userspace visible changes
   - sysfs 'isci_id' attribute under hostX to identify the controller
   - phy enable/disable support

Diffstat, log, and and the lldd portion of the diff included below (i.e=
=2E
git diff 3077cf00.. $(gls drivers/scsi/isci/ | grep -v /core/)).  I
could post these as separate patches but I thought I would conserve lis=
t
bandwidth for the upcoming posting of the core as a set of omnibus
patches.=20

Dan Williams (14):
      isci: fix sas address reporting
      isci: rework timer api
      isci: fix hang after target reset
      isci: pad stp and smp request sizes
      isci: enable isci for dmar builds
      isci: kill isci_host list in favor of an array
      isci: remove sci_device_handle
      isci: kill "host quiesce" mechanism
      isci: replace isci_remote_device completion with event queue
      isci: preallocate remote devices
      isci: replace remote_device_lock  with scic_lock
      isci: cleanup debug leftovers in isci.h
      isci: Errors in the submit path for SATA devices manage the ap lo=
ck.
      isci: add "isci_id" attribute

Dave Jiang (7):
      isci: Removed special macros that does 64bit address math
      isci: Make the driver copy data directly from and to sg for PIO
      isci: have the driver use native SG calls and DMA-API
      isci: Change event notify calls from scic_cb_* to isci_event_*
      isci: Removing deprecated functions
      isci: Adding support for phy enable and disable
      isci: Cleanup warning messages for phy resets

Jeff Skirvin (12):
      isci: isci_request_cleanup_completed_loiterer checks task before =
task_done
      isci: Changes in isci_host_completion_routine
      isci: fix completion / abort path.
      isci: Any reset indicated on an I/O completion escalates it to th=
e error path.
      isci: save the i/o tag outside the scic request structure.
      isci: Cleaning up task execute path.
      isci: Code review change for completion pointer cleanup.
      isci: Termination handling cleanup, added termination timeouts.
      isci: Fix TMF build for SAS/SATA LUN reset cases.
      isci: Fixed BUG_ON in isci_abort_task_process_cb callback.
      isci: Always set response/status for requests going into the erro=
r path.
      isci: All pending requests are terminated before stopping the dev=
ice.

Pawel Marek (1):
      isci: controller stop/start fixes

Piotr Sawicki (1):
      isci: handle cases where a d2h fis is used report an ncq error

Tomasz Chudy (1):
      isci: workaround port task scheduler starvation issue

 drivers/scsi/Kconfig                               |    3 -
 drivers/scsi/isci/Makefile                         |    2 +-
 drivers/scsi/isci/core/sci_util.c                  |   31 +
 drivers/scsi/isci/core/sci_util.h                  |   51 +--
 drivers/scsi/isci/core/scic_port.h                 |   17 -
 drivers/scsi/isci/core/scic_sds_controller.c       |  215 ++++--
 drivers/scsi/isci/core/scic_sds_controller.h       |   29 +-
 drivers/scsi/isci/core/scic_sds_phy.c              |  166 +++--
 drivers/scsi/isci/core/scic_sds_phy.h              |    3 +
 drivers/scsi/isci/core/scic_sds_port.c             |  399 ++++++++---
 drivers/scsi/isci/core/scic_sds_port.h             |    9 +
 .../isci/core/scic_sds_port_configuration_agent.c  |   10 +-
 drivers/scsi/isci/core/scic_sds_remote_device.c    |   21 +-
 drivers/scsi/isci/core/scic_sds_request.c          |  324 +++++----
 drivers/scsi/isci/core/scic_sds_request.h          |   39 +-
 .../scsi/isci/core/scic_sds_smp_remote_device.c    |    5 +-
 drivers/scsi/isci/core/scic_sds_smp_request.c      |  124 ++--
 .../scsi/isci/core/scic_sds_stp_packet_request.c   |   20 +-
 .../scsi/isci/core/scic_sds_stp_remote_device.c    |  135 ++--
 drivers/scsi/isci/core/scic_sds_stp_request.c      |  284 +++-----
 drivers/scsi/isci/core/scic_sds_stp_request.h      |    2 +-
 .../isci/core/scic_sds_unsolicited_frame_control.c |   74 +-
 drivers/scsi/isci/core/scic_user_callback.h        |  736 ------------=
------
 drivers/scsi/isci/deprecated.c                     |  485 ------------
 drivers/scsi/isci/events.c                         |  163 ++---
 drivers/scsi/isci/events.h                         |  373 ++++++++++
 drivers/scsi/isci/host.c                           |  126 ++--
 drivers/scsi/isci/host.h                           |   36 +-
 drivers/scsi/isci/init.c                           |   84 +--
 drivers/scsi/isci/isci.h                           |   31 +-
 drivers/scsi/isci/phy.c                            |   91 ++--
 drivers/scsi/isci/port.c                           |   18 +-
 drivers/scsi/isci/port.h                           |    2 -
 drivers/scsi/isci/remote_device.c                  |  219 ++----
 drivers/scsi/isci/remote_device.h                  |   41 +-
 drivers/scsi/isci/request.c                        |  114 ++--
 drivers/scsi/isci/request.h                        |    3 +-
 drivers/scsi/isci/sata.c                           |    4 +-
 drivers/scsi/isci/task.c                           |  782 +++++++++++-=
--------
 drivers/scsi/isci/task.h                           |  118 ++--
 drivers/scsi/isci/timers.c                         |  173 ++---
 drivers/scsi/isci/timers.h                         |   60 +--
 42 files changed, 2484 insertions(+), 3138 deletions(-)
 delete mode 100644 drivers/scsi/isci/core/scic_user_callback.h
 delete mode 100644 drivers/scsi/isci/deprecated.c
 create mode 100644 drivers/scsi/isci/events.h

commit 119c8f35648d7cbc24339eeb9d02c7c2e35db685
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 10 00:01:43 2011 -0800

    isci: add "isci_id" attribute
   =20
    Allow each controller to be identified via sysfs.
   =20
    # cat /sys/class/scsi_host/host13/isci_id
    1
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fa4d37357b355fde9c9fc8ec3c3eef932d16c10c
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Tue Mar 8 20:32:16 2011 -0700

    isci: All pending requests are terminated before stopping the devic=
e.
   =20
    Make sure all pending I/O including any in the libsas error handler
    process is cleaned-up.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 828339b14f3948c6fa023353d1dfa5f67e549542
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Mon Mar 7 16:40:47 2011 -0700

    isci: Always set response/status for requests going into the error =
path.
   =20
    In the case of I/O requests being failed because of a required devi=
ce
    reset condition, set the response and status to indicate an I/O fai=
lure.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ec745eb31b7e12791bd74988e90aea02242e98f0
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 9 21:27:46 2011 -0800

    isci: Errors in the submit path for SATA devices manage the ap lock=
=2E
   =20
    Since libsas takes the domain device sata_dev.ap->lock before submi=
tting
    a task, error completions in the submit path for SATA devices must
    unlock/relock when completing the sas_task back to libsas.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 7df663b34aeb46cd310873ab3f3a7e5a031e4ed0
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Fri Mar 4 14:06:58 2011 -0800

    isci: Fixed BUG_ON in isci_abort_task_process_cb callback.
   =20
    The request may be in the "aborted" or the "completed" state when
    performing a task management operation on it.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0b08e9fe99941263e3757dd8abf8adf43977470f
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Fri Mar 4 14:06:56 2011 -0800

    isci: Fix TMF build for SAS/SATA LUN reset cases.
   =20
    In the case where a SAS or SATA LUN reset TMF is built a NULL point=
er
    dereference occurred because of the (unused) callback data pointer.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>

commit cc476493a6883df996c5d5912e677795fcb9b65b
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Fri Mar 4 14:06:52 2011 -0800

    isci: Termination handling cleanup, added termination timeouts.
   =20
    Added a request "dead" state for use when a termination wait times-=
out.
   =20
    isci_terminate_pending_requests now detaches the device's pending l=
ist
    and terminates each entry on the detached list.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit afdfc7a2f730f7b21f36507e2d8389d4b82c3b13
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Fri Mar 4 14:06:50 2011 -0800

    isci: Code review change for completion pointer cleanup.
   =20
    Since the request structure contains a pointer to the completion to=
 be
    used if the request is being aborted or terminated, there is no rea=
son
    to pass the completion as a pointer to isci_terminate_request_core(=
).
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a2f5738193192f6dda498f448ff6bb1c44662816
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Tue Mar 8 19:22:07 2011 -0700

    isci: Cleaning up task execute path.
   =20
    Made sure the device ready check accounts for all states.
    Moved the aborted task check into the loop of pulling task requests
    off of the submitted list.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    [remove host and device starting state checks]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 871cd89bc64acb03fb202c3849d1b5378b637b06
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Fri Mar 4 14:06:46 2011 -0800

    isci: save the i/o tag outside the scic request structure.
   =20
    The pointer to the core representation of a request is marked NULL =
at
    completion, but we need to save the i/o tag for task management.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    [revise changelog]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 03674d66d44ed96b4ab4b96209ab1a8a3ab174e3
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Fri Mar 4 14:06:44 2011 -0800

    isci: Any reset indicated on an I/O completion escalates it to the =
error path.
   =20
    If there is a pending device reset, the I/O is used to accomplish t=
he reset by setting the
    RESET bit in the task status, and then putting the task into the er=
ror handler
    path using sas abort task.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit faa7690e2ba061a79ef8d3fdaf63976d455e1cf4
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Fri Mar 4 14:06:42 2011 -0800

    isci: fix completion / abort path.
   =20
    Corrected use of the request state_lock in the completion callback.
   =20
    In the case where an abort (or reset) thread is trying to terminate=
 an
    I/O request, it sets the request state to "aborting" (or "terminati=
ng")
    if the state is still "starting".  One of the bugs was to never set=
 the
    state to "completed".  Another was to not correctly recognize the
    situation where the I/O had completed but the sas_task was still pe=
nding
    callback to task_done - this was typically a problem in the LUN and
    device reset cases.
   =20
    It is now possible that we leave isci_task_abort_task() with
    request->io_request_completion pointing to localy allocated
    aborted_io_completion struct. It may result in a system crash.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Maciej Trela <Maciej.Trela@intel.com>
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c49bd907f09e753dafc23fad95bffbd70dfa7e8c
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Fri Mar 4 14:06:40 2011 -0800

    isci: Changes in isci_host_completion_routine
   =20
    Changes to move management of the reqs_in_process entry for the req=
uest here.
    Made changes to note when the task is already in the abort path and
    cannot be completed through callbacks.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 563ee3a3878bf066495a22e1ef07e71032c8181b
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Fri Mar 4 14:06:38 2011 -0800

    isci: isci_request_cleanup_completed_loiterer checks task before ta=
sk_done
   =20
    In the condition where outstanding I/Os are being cleaned from the =
device
    requests in process list, the cleanup function needs to check that =
the
    request is actually a sas-task and not a task management function.
   =20
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c89d0a12ddd42c7d3e26fe84317e99320885d5a3
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Mar 8 21:30:28 2011 -0800

    isci: cleanup debug leftovers in isci.h
   =20
    Reported-by: James Bottomley <James.Bottomley@suse.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bbca7739a6b4dbb8fb0452fa7953f03a4fcd9b26
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 3 18:01:43 2011 -0800

    isci: replace remote_device_lock  with scic_lock
   =20
    The remote_device_lock is currently used to protect a controller gl=
obal
    resource (RNCs), but the remote_device_lock is per-port.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8897a1f8f81685404521c2595542e0439f117da7
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 3 17:59:32 2011 -0800

    isci: preallocate remote devices
   =20
    Until we synchronize against device removal this limits the damage =
of
    use after free bugs to the driver's own objects.  Unless we impleme=
nt
    reference counting we need to ensure at least a subset of a remote
    device is valid at all times.  We follow the lead of other libsas
    drivers that also preallocate devices.
   =20
    This also enforces maximum remote device accounting at the lldd lay=
er,
    but the core may still run out of RNC's before we hit this limit.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a713b1bb72faef44e803ec57b331e71bc90346f0
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Mar 4 12:10:29 2011 -0800

    isci: replace isci_remote_device completion with event queue
   =20
    Replace the device completion infrastructure with the controller wi=
de
    event queue.  There was a potential for the stop and ready notifica=
tions
    to corrupt each other, now that cannot happen.
   =20
    The stop pending flag cannot be used until devices are statically
    allocated.  We temporarily need to maintain a completion to handle
    waiting for an object that has disappeared, but we can at least sto=
p
    scribbling on freed memory.
   =20
    A future change will also get rid of the "stopping" state as it sho=
uld
    not be exposed to the rest of the driver.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bb86966f2ce1773be8660a0b93fbeff9514b1229
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Mar 7 14:47:35 2011 -0800

    isci: kill "host quiesce" mechanism
   =20
    The midlayer is already throttling i/o in the places where host_qui=
esce
    was trying to prevent further i/o to the device.  It's also problem=
atic
    in that it holds a lock over GFP_KERNEL allocations.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f8d8ced6e8d0b0903877ff3d1e412da1836c76c8
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Mar 4 11:51:43 2011 -0800

    isci: remove sci_device_handle
   =20
    It belies the fact that isci_remote_device and scic_sds_remote_devi=
ce
    are one in same object with the same lifetime rules.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f7da6e00938a482298ec089816c7b52fee9d4ba8
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Mar 7 16:02:25 2011 -0800

    isci: kill isci_host list in favor of an array
   =20
    isci_host_by_id() should have been a clue that an array would have =
been
    a simpler approach.
   =20
    Reported-by: James Bottomley <James.Bottomley@suse.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4c68db90e2301b4d672b9571aad6f47bc61e5a80
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 3 17:59:25 2011 -0800

    isci: enable isci for dmar builds
   =20
    Now that phys_to_virt() and virt_to_phys() have been removed we are=
 no
    longer violating the dma mapping (or kmap apis).
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0113f67b3f070712aa544f4c9a3668a106998121
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Mar 3 14:58:11 2011 -0800

    isci: pad stp and smp request sizes
   =20
    Ross says:
     "The memory allocation for these requests doesn=E2=80=99t take int=
o account the
      additional memory needed when the code in
      scic_sds_s[mst]p_request_assign_buffers() shifts the struct
      scu_task_context so that it is cache line aligned:
   =20
      In an example from my machine, total buffer that I=E2=80=99ve giv=
en to SCIC goes
      from 0x410024566f84 to 0x410024567308.  From this same example, t=
his
      call shifts my task_context_buffer from 0x410024567208 to
      0x410024567240.
   =20
      This means that the task_context_buffer that used to range from
      0x410024567208 to 0x410024567308 instead now goes from 0x41002456=
7240 to
      0x410024567340.
   =20
      When the memset() call at the end of scic_task_request_construct(=
)
      clears out this task_context_buffer, it does so from 0x4100245672=
40 to
      0x410024567340, effectively killing whatever buffer follows this
      allocation in memory."
   =20
    djbw:
    Use the kernel's PTR_ALIGN instead of
    scic_sds_request_align_task_context_buffer() and SMP_CACHE_BYTES in=
stead of
    the local CACHE_LINE_SIZE definition.
   =20
    TODO: These allocations really want to be better defined in a union=
 rather
    than opaque buffers carved up by macros.
   =20
    Reported-by: Ross Zwisler <ross.zwisler@intel.com>
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 72bea0ed7761942d5b09b38c0b149e4fc41f2807
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 2 16:45:18 2011 -0800

    isci: fix hang after target reset
   =20
    When aborting a task context we need to be sure that the hardware h=
as acted on
    this request (retrieved the task context) before invalidating the r=
emote node
    context.  In the case of the "dummy" task context and remote node w=
e do not
    have the full state machine that goes through the complete tc abort=
 and rnc
    invalidate states.  Instead we ensure the hardware has seen and act=
ed on
   =20
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1cca16b180063d36a96ac21a5dc60736983151b3
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed Mar 2 13:10:45 2011 -0800

    isci: Cleanup warning messages for phy resets
   =20
    Moving some of the chattiness of warning messages to debug so only =
the Linux
    system messages are shown.
   =20
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3da551128b49035dfcaa43c1bbba82e147d18b32
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed Mar 2 12:31:24 2011 -0800

    isci: Adding support for phy enable and disable
   =20
    Adding support for PHY_FUNC_LINK_RESET and PHY_FUNC_DISABLE. This a=
llow the
    sysfs knob enable (both 0 and 1) and link_reset to work properly.
   =20
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e10094cbc7245fafdcc9d03f909a1a5eab6b1829
Author: Pawel Marek <pawel.marek@intel.com>
Date:   Tue Mar 1 12:31:06 2011 -0800

    isci: controller stop/start fixes
   =20
    Core reworks to support stopping and re-starting the controller, la=
ys the
    groundwork for phy disable / re-enable and fixes other bugs around =
port/phy
    setup/teardown.
   =20
    Signed-off-by: Pawel Marek <pawel.marek@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0a1292e1268b000215e504e5beae3501fc01ac97
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Fri Feb 25 13:07:38 2011 -0800

    isci: handle cases where a d2h fis is used report an ncq error
   =20
    Observed that some devices return a d2h fis, treat like an sdb erro=
r fis.
   =20
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c40a3a21e3fea3bcb29b903608361e172fa6e7d9
Author: Tomasz Chudy <Tomasz.Chudy@intel.com>
Date:   Fri Feb 25 02:25:09 2011 -0800

    isci: workaround port task scheduler starvation issue
   =20
    There is a condition whereby TCs (task contexts) can jump to the he=
ad of
    the round robin queue causing indefinite starvation of pending task=
s.
    Posting a TC to a suspended RNC (remote node context) causes the
    hardware to select that task first, but since the RNC is suspended =
the
    scheduler proceeds to the next task in the expected round robin fas=
hion,
    restoring TC arbitration fairness.
   =20
    Signed-off-by: Tomasz Chudy <tomasz.chudy@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8d32e5b2aefe0d5e966cc7f5c5e887aa2d2b6090
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Mar 2 11:49:26 2011 -0800

    isci: rework timer api
   =20
    Prepare the timer api for the arrival of dynamic creation and
    destruction events from the core.  It pretended to do this previous=
ly
    but the core to date only used it in a static init-time only fashio=
n.
    This is an interim fix until a cleaner event queue can be developed=
=2E
   =20
    1/ make all locking external to the api (add WARN_ONCE to verify)
    2/ add a timer_destroy interface (to be used by the core)
    3/ use del_timer_sync() prior to deallocating timer data
    4/ delete the "timer_list" indirection, we only have timers allocat=
ed
       for the isci_host
    5/ fix detection of timer list allocation errors
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit db3dd417bed5b2be0c95ace9e4b8871102ca5dcf
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Feb 25 10:25:21 2011 -0800

    isci: fix sas address reporting
   =20
    Undo the open coded and incorrect translation of the oem parameter =
sas
    address to its libsas expected format.
   =20
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 709637fec5ad729f864bebebcea378f725a1eea9
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed Feb 23 15:57:33 2011 -0800

    isci: Removing deprecated functions
   =20
    Removed all callbacks in the deprecated.c. Core will call the appro=
priate
    functions directly.
   =20
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f8cd82b1be3aa8cf98c0e1da31d209829c54560f
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed Feb 23 15:57:30 2011 -0800

    isci: Change event notify calls from scic_cb_* to isci_event_*
   =20
    Renaming the callbacks to apparopriate event notify calls for the L=
LDD.
   =20
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c32acaf4b9003f9d2d4855fdcc4e24c6a6836237
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed Feb 23 15:57:27 2011 -0800

    isci: have the driver use native SG calls and DMA-API
   =20
    Remove abstraction for SG building and get rid of callbacks for get=
ting
    DMA memory mapping.
   =20
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f67153dc4f1f6921cfb25c0e12b962f180a12756
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed Feb 23 15:57:24 2011 -0800

    isci: Make the driver copy data directly from and to sg for PIO
   =20
    We can copy the data directly to and from sg for SATA PIO read oper=
ations.
    There is no reason to involve the hardware SGL. In the process we a=
lso need
    to kmap the sg because we don't know where that can come from.
   =20
    We also do to not call phys_to_virt(). The driver already has the i=
nformation.
    We can just calculcate the appropriate offets.
   =20
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c249d29aebcc4adda8d5d6e25a90aceaf0bbb501
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Tue Feb 22 16:39:32 2011 -0700

    isci: Removed special macros that does 64bit address math
   =20
    These macros are not necessary. We can do 64bit math directly.
   =20
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


diff --git a/drivers/scsi/isci/Makefile b/drivers/scsi/isci/Makefile
index 34f7af3..d402d67 100644
--- a/drivers/scsi/isci/Makefile
+++ b/drivers/scsi/isci/Makefile
@@ -8,7 +8,7 @@ EXTRA_CFLAGS +=3D -DDISABLE_ATAPI
 EXTRA_CFLAGS +=3D -Idrivers/scsi/isci/core/ -Idrivers/scsi/isci/
 obj-$(CONFIG_SCSI_ISCI) +=3D isci.o
 isci-objs :=3D init.o phy.o request.o sata.o \
-	     remote_device.o port.o timers.o deprecated.o \
+	     remote_device.o port.o timers.o \
 	     host.o task.o events.o \
 	     core/scic_sds_controller.o  \
 	     core/scic_sds_remote_device.o    \
diff --git a/drivers/scsi/isci/events.c b/drivers/scsi/isci/events.c
index 6911ea5..9d58e45 100644
--- a/drivers/scsi/isci/events.c
+++ b/drivers/scsi/isci/events.c
@@ -64,9 +64,10 @@
 #include "request.h"
 #include "sata.h"
 #include "task.h"
+#include "events.h"
=20
 /**
- * scic_cb_timer_create() - This callback method asks the user to crea=
te a
+ * isci_event_timer_create() - This callback method asks the user to c=
reate a
  *    timer and provide a handle for this timer for use in further tim=
er
  *    interactions. The appropriate isci timer object function is call=
ed to
  *    create a timer object.
@@ -74,40 +75,28 @@
  *    whenever the timer expires.
  * @controller: This parameter specifies the controller with which thi=
s timer
  *    is to be associated.
- * @cookie: This parameter specifies a piece of information that the u=
ser must
- *    retain.  This cookie is to be supplied by the user anytime a tim=
eout
- *    occurs for the created timer.
+ * @cb_param: opaque callback parameter
  *
  * This method returns a handle to a timer object created by the user.=
  The
  * handle will be utilized for all further interactions relating to th=
is timer.
  */
-void *scic_cb_timer_create(
-	struct scic_sds_controller *controller,
-	void (*timer_callback)(void *),
-	void *cookie)
+void *isci_event_timer_create(struct scic_sds_controller *scic,
+			      void (*timer_callback)(void *),
+			      void *cb_param)
 {
-	struct isci_host *isci_host;
-	struct isci_timer *timer =3D NULL;
-
-	isci_host =3D (struct isci_host *)sci_object_get_association(controll=
er);
-
-	dev_dbg(&isci_host->pdev->dev,
-		"%s: isci_host =3D %p",
-		__func__, isci_host);
+	struct isci_host *ihost =3D sci_object_get_association(scic);
+	struct isci_timer *itimer;
=20
-	timer =3D isci_timer_create(&isci_host->timer_list_struct,
-				  isci_host,
-				  cookie,
-				  timer_callback);
+	itimer =3D isci_timer_create(ihost, cb_param, timer_callback);
=20
-	dev_dbg(&isci_host->pdev->dev, "%s: timer =3D %p\n", __func__, timer)=
;
+	dev_dbg(&ihost->pdev->dev, "%s: timer =3D %p\n", __func__, itimer);
=20
-	return (void *)timer;
+	return itimer;
 }
=20
=20
 /**
- * scic_cb_timer_start() - This callback method asks the user to start=
 the
+ * isci_event_timer_start() - This callback method asks the user to st=
art the
  *    supplied timer. The appropriate isci timer object function is ca=
lled to
  *    start the timer.
  * @controller: This parameter specifies the controller with which thi=
s timer
@@ -118,7 +107,7 @@ void *scic_cb_timer_create(
  *    where necessary.
  *
  */
-void scic_cb_timer_start(
+void isci_event_timer_start(
 	struct scic_sds_controller *controller,
 	void *timer,
 	u32 milliseconds)
@@ -137,7 +126,7 @@ void scic_cb_timer_start(
 }
=20
 /**
- * scic_cb_timer_stop() - This callback method asks the user to stop t=
he
+ * isci_event_timer_stop() - This callback method asks the user to sto=
p the
  *    supplied timer. The appropriate isci timer object function is ca=
lled to
  *    stop the timer.
  * @controller: This parameter specifies the controller with which thi=
s timer
@@ -145,14 +134,9 @@ void scic_cb_timer_start(
  * @timer: This parameter specifies the timer to be stopped.
  *
  */
-void scic_cb_timer_stop(
-	struct scic_sds_controller *controller,
-	void *timer)
+void isci_event_timer_stop(struct scic_sds_controller *controller, voi=
d *timer)
 {
-	struct isci_host *isci_host;
-
-	isci_host =3D
-		(struct isci_host *)sci_object_get_association(controller);
+	struct isci_host *isci_host =3D sci_object_get_association(controller=
);
=20
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: isci_host =3D %p, timer =3D %p\n",
@@ -161,8 +145,18 @@ void scic_cb_timer_stop(
 	isci_timer_stop((struct isci_timer *)timer);
 }
=20
+void isci_event_timer_destroy(struct scic_sds_controller *scic, void *=
timer)
+{
+        struct isci_host *ihost =3D sci_object_get_association(scic);
+
+	dev_dbg(&ihost->pdev->dev, "%s: ihost =3D %p, timer =3D %p\n",
+			__func__, ihost, timer);
+
+	isci_del_timer(ihost, timer);
+}
+
 /**
- * scic_cb_controller_start_complete() - This user callback will infor=
m the
+ * isci_event_controller_start_complete() - This user callback will in=
form the
  *    user that the controller has finished the start process. The ass=
ociated
  *    isci host adapter's start_complete function is called.
  * @controller: This parameter specifies the controller that was start=
ed.
@@ -170,7 +164,7 @@ void scic_cb_timer_stop(
  *    operation.  SCI_SUCCESS indicates successful completion.
  *
  */
-void scic_cb_controller_start_complete(
+void isci_event_controller_start_complete(
 	struct scic_sds_controller *controller,
 	enum sci_status completion_status)
 {
@@ -184,7 +178,7 @@ void scic_cb_controller_start_complete(
 }
=20
 /**
- * scic_cb_controller_stop_complete() - This user callback will inform=
 the user
+ * isci_event_controller_stop_complete() - This user callback will inf=
orm the user
  *    that the controller has finished the stop process. The associate=
d isci
  *    host adapter's start_complete function is called.
  * @controller: This parameter specifies the controller that was stopp=
ed.
@@ -192,7 +186,7 @@ void scic_cb_controller_start_complete(
  *    operation.  SCI_SUCCESS indicates successful completion.
  *
  */
-void scic_cb_controller_stop_complete(
+void isci_event_controller_stop_complete(
 	struct scic_sds_controller *controller,
 	enum sci_status completion_status)
 {
@@ -205,7 +199,7 @@ void scic_cb_controller_stop_complete(
 }
=20
 /**
- * scic_cb_io_request_complete() - This user callback will inform the =
user that
+ * isci_event_io_request_complete() - This user callback will inform t=
he user that
  *    an IO request has completed.
  * @controller: This parameter specifies the controller on which the I=
O is
  *    completing.
@@ -216,7 +210,7 @@ void scic_cb_controller_stop_complete(
  *    operation.  SCI_SUCCESS indicates successful completion.
  *
  */
-void scic_cb_io_request_complete(
+void isci_event_io_request_complete(
 	struct scic_sds_controller *controller,
 	struct scic_sds_remote_device *remote_device,
 	struct scic_sds_request *scic_io_request,
@@ -239,7 +233,7 @@ void scic_cb_io_request_complete(
 }
=20
 /**
- * scic_cb_task_request_complete() - This user callback will inform th=
e user
+ * isci_event_task_request_complete() - This user callback will inform=
 the user
  *    that a task management request completed.
  * @controller: This parameter specifies the controller on which the t=
ask
  *    management request is completing.
@@ -251,7 +245,7 @@ void scic_cb_io_request_complete(
  *    operation.  SCI_SUCCESS indicates successful completion.
  *
  */
-void scic_cb_task_request_complete(
+void isci_event_task_request_complete(
 	struct scic_sds_controller *controller,
 	struct scic_sds_remote_device *remote_device,
 	struct scic_sds_request *scic_task_request,
@@ -271,7 +265,7 @@ void scic_cb_task_request_complete(
 }
=20
 /**
- * scic_cb_port_stop_complete() - This method informs the user when a =
stop
+ * isci_event_port_stop_complete() - This method informs the user when=
 a stop
  *    operation on the port has completed.
  * @controller: This parameter represents the controller which contain=
s the
  *    port.
@@ -281,17 +275,20 @@ void scic_cb_task_request_complete(
  *    being completed.
  *
  */
-void scic_cb_port_stop_complete(
+void isci_event_port_stop_complete(
 	struct scic_sds_controller *controller,
 	struct scic_sds_port *port,
 	enum sci_status completion_status)
 {
-	pr_warn("%s:************************************************\n",
-		__func__);
+	struct isci_host *isci_host;
+
+	isci_host =3D (struct isci_host *)sci_object_get_association(controll=
er);
+
+	dev_notice(&isci_host->pdev->dev, "Port stop complete\n");
 }
=20
 /**
- * scic_cb_port_hard_reset_complete() - This method informs the user w=
hen a
+ * isci_event_port_hard_reset_complete() - This method informs the use=
r when a
  *    hard reset on the port has completed.  This hard reset could hav=
e been
  *    initiated by the user or by the remote port.
  * @controller: This parameter represents the controller which contain=
s the
@@ -302,7 +299,7 @@ void scic_cb_port_stop_complete(
  *    being completed.
  *
  */
-void scic_cb_port_hard_reset_complete(
+void isci_event_port_hard_reset_complete(
 	struct scic_sds_controller *controller,
 	struct scic_sds_port *port,
 	enum sci_status completion_status)
@@ -314,7 +311,7 @@ void scic_cb_port_hard_reset_complete(
 }
=20
 /**
- * scic_cb_port_ready() - This method informs the user that the port i=
s now in
+ * isci_event_port_ready() - This method informs the user that the por=
t is now in
  *    a ready state and can be utilized to issue IOs.
  * @controller: This parameter represents the controller which contain=
s the
  *    port.
@@ -322,7 +319,7 @@ void scic_cb_port_hard_reset_complete(
  *    is being invoked.
  *
  */
-void scic_cb_port_ready(
+void isci_event_port_ready(
 	struct scic_sds_controller *controller,
 	struct scic_sds_port *port)
 {
@@ -342,7 +339,7 @@ void scic_cb_port_ready(
 }
=20
 /**
- * scic_cb_port_not_ready() - This method informs the user that the po=
rt is now
+ * isci_event_port_not_ready() - This method informs the user that the=
 port is now
  *    not in a ready (i.e. busy) state and can't be utilized to issue =
IOs.
  * @controller: This parameter represents the controller which contain=
s the
  *    port.
@@ -350,7 +347,7 @@ void scic_cb_port_ready(
  *    is being invoked.
  *
  */
-void scic_cb_port_not_ready(
+void isci_event_port_not_ready(
 	struct scic_sds_controller *controller,
 	struct scic_sds_port *port,
 	u32 reason_code)
@@ -371,7 +368,7 @@ void scic_cb_port_not_ready(
 }
=20
 /**
- * scic_cb_port_invalid_link_up() - This method informs the SCI Core u=
ser that
+ * isci_event_port_invalid_link_up() - This method informs the SCI Cor=
e user that
  *    a phy/link became ready, but the phy is not allowed in the port.=
  In some
  *    situations the underlying hardware only allows for certain phy t=
o port
  *    mappings.  If these mappings are violated, then this API is invo=
ked.
@@ -383,17 +380,19 @@ void scic_cb_port_not_ready(
  *    a valid member of the port.
  *
  */
-void scic_cb_port_invalid_link_up(
+void isci_event_port_invalid_link_up(
 	struct scic_sds_controller *controller,
 	struct scic_sds_port *port,
 	struct scic_sds_phy *phy)
 {
-	pr_warn("%s:************************************************\n",
-		__func__);
+	struct isci_host *isci_host;
+
+	isci_host =3D (struct isci_host *)sci_object_get_association(controll=
er);
+	dev_warn(&isci_host->pdev->dev, "Invalid link up!\n");
 }
=20
 /**
- * scic_cb_port_bc_change_primitive_received() - This callback method =
informs
+ * isci_event_port_bc_change_primitive_received() - This callback meth=
od informs
  *    the user that a broadcast change primitive was received.
  * @controller: This parameter represents the controller which contain=
s the
  *    port.
@@ -403,7 +402,7 @@ void scic_cb_port_invalid_link_up(
  * @phy: This parameter specifies the phy on which the primitive was r=
eceived.
  *
  */
-void scic_cb_port_bc_change_primitive_received(
+void isci_event_port_bc_change_primitive_received(
 	struct scic_sds_controller *controller,
 	struct scic_sds_port *port,
 	struct scic_sds_phy *phy)
@@ -422,7 +421,7 @@ void scic_cb_port_bc_change_primitive_received(
=20
=20
 /**
- * scic_cb_port_link_up() - This callback method informs the user that=
 a phy
+ * isci_event_port_link_up() - This callback method informs the user t=
hat a phy
  *    has become operational and is capable of communicating with the =
remote
  *    end point.
  * @controller: This parameter represents the controller associated wi=
th the
@@ -435,7 +434,7 @@ void scic_cb_port_bc_change_primitive_received(
  *
  * none.
  */
-void scic_cb_port_link_up(
+void isci_event_port_link_up(
 	struct scic_sds_controller *controller,
 	struct scic_sds_port *port,
 	struct scic_sds_phy *phy)
@@ -452,7 +451,7 @@ void scic_cb_port_link_up(
 }
=20
 /**
- * scic_cb_port_link_down() - This callback method informs the user th=
at a phy
+ * isci_event_port_link_down() - This callback method informs the user=
 that a phy
  *    is no longer operational and is not capable of communicating wit=
h the
  *    remote end point.
  * @controller: This parameter represents the controller associated wi=
th the
@@ -465,7 +464,7 @@ void scic_cb_port_link_up(
  *
  * none.
  */
-void scic_cb_port_link_down(
+void isci_event_port_link_down(
 	struct scic_sds_controller *controller,
 	struct scic_sds_port *port,
 	struct scic_sds_phy *phy)
@@ -490,7 +489,7 @@ void scic_cb_port_link_down(
 }
=20
 /**
- * scic_cb_remote_device_start_complete() - This user callback method =
will
+ * isci_event_remote_device_start_complete() - This user callback meth=
od will
  *    inform the user that a start operation has completed.
  * @controller: This parameter specifies the core controller associate=
d with
  *    the completion callback.
@@ -500,7 +499,7 @@ void scic_cb_port_link_down(
  *    operation.
  *
  */
-void scic_cb_remote_device_start_complete(
+void isci_event_remote_device_start_complete(
 	struct scic_sds_controller *controller,
 	struct scic_sds_remote_device *remote_device,
 	enum sci_status completion_status)
@@ -525,9 +524,9 @@ void scic_cb_remote_device_start_complete(
 }
=20
 /**
- * scic_cb_remote_device_stop_complete() - This user callback method w=
ill
+ * isci_event_remote_device_stop_complete() - This user callback metho=
d will
  *    inform the user that a stop operation has completed.
- * @controller: This parameter specifies the core controller associate=
d with
+ * @scic: This parameter specifies the core controller associated with
  *    the completion callback.
  * @remote_device: This parameter specifies the remote device associat=
ed with
  *    the completion callback.
@@ -535,32 +534,24 @@ void scic_cb_remote_device_start_complete(
  *    operation.
  *
  */
-void scic_cb_remote_device_stop_complete(
-	struct scic_sds_controller *controller,
-	struct scic_sds_remote_device *remote_device,
-	enum sci_status completion_status)
+void isci_event_remote_device_stop_complete(struct scic_sds_controller=
 *scic,
+					    struct scic_sds_remote_device *sci_dev,
+					    enum sci_status completion_status)
 {
-	struct isci_host *isci_host;
-	struct isci_remote_device *isci_device;
-
-	isci_host =3D
-		(struct isci_host *)sci_object_get_association(controller);
-
-	isci_device =3D
-		(struct isci_remote_device *)sci_object_get_association(
-			remote_device
-			);
+	struct isci_host *ihost;
+	struct isci_remote_device *idev;
=20
-	dev_dbg(&isci_host->pdev->dev,
-		"%s: isci_device =3D %p\n", __func__, isci_device);
+	ihost =3D sci_object_get_association(scic);
+	idev =3D sci_object_get_association(sci_dev);
=20
-	isci_remote_device_stop_complete(
-		isci_host, isci_device, completion_status);
+	dev_dbg(&ihost->pdev->dev,
+		"%s: idev =3D %p\n", __func__, idev);
=20
+	isci_remote_device_stop_complete(ihost, idev, completion_status);
 }
=20
 /**
- * scic_cb_remote_device_ready() - This user callback method will info=
rm the
+ * isci_event_remote_device_ready() - This user callback method will i=
nform the
  *    user that a remote device is now capable of handling IO requests=
=2E
  * @controller: This parameter specifies the core controller associate=
d with
  *    the completion callback.
@@ -568,7 +559,7 @@ void scic_cb_remote_device_stop_complete(
  *    the callback.
  *
  */
-void scic_cb_remote_device_ready(
+void isci_event_remote_device_ready(
 	struct scic_sds_controller *controller,
 	struct scic_sds_remote_device *remote_device)
 {
@@ -583,7 +574,7 @@ void scic_cb_remote_device_ready(
 }
=20
 /**
- * scic_cb_remote_device_not_ready() - This user callback method will =
inform
+ * isci_event_remote_device_not_ready() - This user callback method wi=
ll inform
  *    the user that a remote device is no longer capable of handling I=
O
  *    requests (until a ready callback is invoked).
  * @controller: This parameter specifies the core controller associate=
d with
@@ -594,7 +585,7 @@ void scic_cb_remote_device_ready(
  *    going to a not ready state.
  *
  */
-void scic_cb_remote_device_not_ready(
+void isci_event_remote_device_not_ready(
 	struct scic_sds_controller *controller,
 	struct scic_sds_remote_device *remote_device,
 	u32 reason_code)
diff --git a/drivers/scsi/isci/events.h b/drivers/scsi/isci/events.h
new file mode 100644
index 0000000..fa2f6aa
--- /dev/null
+++ b/drivers/scsi/isci/events.h
@@ -0,0 +1,373 @@
+/*
+ * This file is provided under a dual BSD/GPLv2 license.  When using o=
r
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of version 2 of the GNU General Public License a=
s
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St - Fifth Floor, Boston, MA 02110-13=
01 USA.
+ * The full GNU General Public License is included in this distributio=
n
+ * in the file called LICENSE.GPL.
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above copyrig=
ht
+ *     notice, this list of conditions and the following disclaimer in
+ *     the documentation and/or other materials provided with the
+ *     distribution.
+ *   * Neither the name of Intel Corporation nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS F=
OR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGH=
T
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTA=
L,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF US=
E,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON A=
NY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE U=
SE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE=
=2E
+ */
+
+#ifndef _ISCI_EVENT_H_
+#define _ISCI_EVENT_H_
+
+/**
+ * isci_event_timer_create() - This callback method asks the user to c=
reate a
+ *    timer and provide a handle for this timer for use in further tim=
er
+ *    interactions.
+ * @controller: This parameter specifies the controller with which thi=
s timer
+ *    is to be associated.
+ * @timer_callback: This parameter specifies the callback method to be=
 invoked
+ *    whenever the timer expires.
+ * @cookie: This parameter specifies a piece of information that the u=
ser must
+ *    retain.  This cookie is to be supplied by the user anytime a tim=
eout
+ *    occurs for the created timer.
+ *
+ * The "timer_callback" method should be executed in a mutually exlusi=
ve manner
+ * from the controller completion handler handler. This method returns=
 a handle
+ * to a timer object created by the user.  The handle will be utilized=
 for all
+ * further interactions relating to this timer.
+ */
+void *isci_event_timer_create(
+	struct scic_sds_controller *controller,
+	void (*timer_callback)(void *),
+	void *cookie);
+
+/**
+ * isci_event_timer_start() - This callback method asks the user to st=
art the
+ *    supplied timer.
+ * @controller: This parameter specifies the controller with which thi=
s timer
+ *    is to associated.
+ * @timer: This parameter specifies the timer to be started.
+ * @milliseconds: This parameter specifies the number of milliseconds =
for which
+ *    to stall.  The operating system driver is allowed to round this =
value up
+ *    where necessary.
+ *
+ * All timers in the system started by the SCI Core are one shot timer=
s.
+ * Therefore, the SCI user should make sure that it removes the timer =
from it's
+ * list when a timer actually fires. Additionally, SCI Core user's sho=
uld be
+ * able to handle calls from the SCI Core to stop a timer that may alr=
eady be
+ * stopped. none
+ */
+void isci_event_timer_start(
+	struct scic_sds_controller *controller,
+	void *timer,
+	u32 milliseconds);
+
+/**
+ * isci_event_timer_stop() - This callback method asks the user to sto=
p the
+ *    supplied timer.
+ * @controller: This parameter specifies the controller with which thi=
s timer
+ *    is to associated.
+ * @timer: This parameter specifies the timer to be stopped.
+ *
+ */
+void isci_event_timer_stop(
+	struct scic_sds_controller *controller,
+	void *timer);
+
+
+void isci_event_timer_destroy(struct scic_sds_controller *scic, void *=
timer);
+
+/**
+ * isci_event_controller_start_complete() - This user callback will in=
form the
+ *    user that the controller has finished the start process.
+ * @controller: This parameter specifies the controller that was start=
ed.
+ * @completion_status: This parameter specifies the results of the sta=
rt
+ *    operation.  SCI_SUCCESS indicates successful completion.
+ *
+ */
+void isci_event_controller_start_complete(
+	struct scic_sds_controller *controller,
+	enum sci_status completion_status);
+
+/**
+ * isci_event_controller_stop_complete() - This user callback will inf=
orm the
+ * user that the controller has finished the stop process.
+ * @controller: This parameter specifies the controller that was stopp=
ed.
+ * @completion_status: This parameter specifies the results of the sto=
p
+ *    operation.  SCI_SUCCESS indicates successful completion.
+ *
+ */
+void isci_event_controller_stop_complete(
+	struct scic_sds_controller *controller,
+	enum sci_status completion_status);
+
+/**
+ * isci_event_io_request_complete() - This user callback will inform t=
he user
+ * that an IO request has completed.
+ * @controller: This parameter specifies the controller on which the I=
O is
+ *    completing.
+ * @remote_device: This parameter specifies the remote device on which=
 this IO
+ *    request is completing.
+ * @io_request: This parameter specifies the IO request that has compl=
eted.
+ * @completion_status: This parameter specifies the results of the IO =
request
+ *    operation.  SCI_SUCCESS indicates successful completion.
+ *
+ */
+void isci_event_io_request_complete(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *remote_device,
+	struct scic_sds_request *scic_io_request,
+	enum sci_io_status completion_status);
+
+/**
+ * isci_event_task_request_complete() - This user callback will inform=
 the user
+ *    that a task management request completed.
+ * @controller: This parameter specifies the controller on which the t=
ask
+ *    management request is completing.
+ * @remote_device: This parameter specifies the remote device on which=
 this
+ *    task management request is completing.
+ * @task_request: This parameter specifies the task management request=
 that has
+ *    completed.
+ * @completion_status: This parameter specifies the results of the IO =
request
+ *    operation.  SCI_SUCCESS indicates successful completion.
+ *
+ */
+void isci_event_task_request_complete(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *remote_device,
+	struct scic_sds_request *scic_task_request,
+	enum sci_task_status completion_status);
+
+/**
+ * isci_event_port_stop_complete() - This method informs the user when=
 a stop
+ *    operation on the port has completed.
+ * @controller: This parameter represents the controller which contain=
s the
+ *    port.
+ * @port: This parameter specifies the SCI port object for which the c=
allback
+ *    is being invoked.
+ * @completion_status: This parameter specifies the status for the ope=
ration
+ *    being completed.
+ *
+ */
+void isci_event_port_stop_complete(
+	struct scic_sds_controller *controller,
+	struct scic_sds_port *port,
+	enum sci_status completion_status);
+
+/**
+ * isci_event_port_hard_reset_complete() - This method informs the use=
r when a
+ *    hard reset on the port has completed.  This hard reset could hav=
e been
+ *    initiated by the user or by the remote port.
+ * @controller: This parameter represents the controller which contain=
s the
+ *    port.
+ * @port: This parameter specifies the SCI port object for which the c=
allback
+ *    is being invoked.
+ * @completion_status: This parameter specifies the status for the ope=
ration
+ *    being completed.
+ *
+ */
+void isci_event_port_hard_reset_complete(
+	struct scic_sds_controller *controller,
+	struct scic_sds_port *port,
+	enum sci_status completion_status);
+
+/**
+ * isci_event_port_ready() - This method informs the user that the por=
t is now
+ * in a ready state and can be utilized to issue IOs.
+ * @controller: This parameter represents the controller which contain=
s the
+ *    port.
+ * @port: This parameter specifies the SCI port object for which the c=
allback
+ *    is being invoked.
+ *
+ */
+void isci_event_port_ready(
+	struct scic_sds_controller *controller,
+	struct scic_sds_port *port);
+
+/**
+ * isci_event_port_not_ready() - This method informs the user that the=
 port is
+ * now not in a ready (i.e. busy) state and can't be utilized to issue=
 IOs.
+ * @controller: This parameter represents the controller which contain=
s the
+ *    port.
+ * @port: This parameter specifies the SCI port object for which the c=
allback
+ *    is being invoked.
+ * @reason_code: This parameter specifies the reason for the port not =
ready
+ *    callback.
+ *
+ */
+void isci_event_port_not_ready(
+	struct scic_sds_controller *controller,
+	struct scic_sds_port *port,
+	u32 reason_code);
+
+/**
+ * isci_event_port_invalid_link_up() - This method informs the SCI Cor=
e user
+ * that a phy/link became ready, but the phy is not allowed in the por=
t.  In
+ * some situations the underlying hardware only allows for certain phy=
 to port
+ *    mappings.  If these mappings are violated, then this API is invo=
ked.
+ * @controller: This parameter represents the controller which contain=
s the
+ *    port.
+ * @port: This parameter specifies the SCI port object for which the c=
allback
+ *    is being invoked.
+ * @phy: This parameter specifies the phy that came ready, but the phy=
 can't be
+ *    a valid member of the port.
+ *
+ */
+void isci_event_port_invalid_link_up(
+	struct scic_sds_controller *controller,
+	struct scic_sds_port *port,
+	struct scic_sds_phy *phy);
+
+/**
+ * isci_event_port_bc_change_primitive_received() - This callback meth=
od informs
+ *    the user that a broadcast change primitive was received.
+ * @controller: This parameter represents the controller which contain=
s the
+ *    port.
+ * @port: This parameter specifies the SCI port object for which the c=
allback
+ *    is being invoked.  For instances where the phy on which the prim=
itive was
+ *    received is not part of a port, this parameter will be
+ *    NULL.
+ * @phy: This parameter specifies the phy on which the primitive was r=
eceived.
+ *
+ */
+void isci_event_port_bc_change_primitive_received(
+	struct scic_sds_controller *controller,
+	struct scic_sds_port *port,
+	struct scic_sds_phy *phy);
+
+/**
+ * isci_event_port_link_up() - This callback method informs the user t=
hat a phy
+ *    has become operational and is capable of communicating with the =
remote
+ *    end point.
+ * @controller: This parameter represents the controller associated wi=
th the
+ *    phy.
+ * @port: This parameter specifies the port object for which the user =
callback
+ *    is being invoked.  There may be conditions where this parameter =
can be
+ *    NULL
+ * @phy: This parameter specifies the phy object for which the user ca=
llback is
+ *    being invoked.
+ *
+ */
+void isci_event_port_link_up(
+	struct scic_sds_controller *controller,
+	struct scic_sds_port *port,
+	struct scic_sds_phy *phy);
+
+/**
+ * isci_event_port_link_down() - This callback method informs the user=
 that a
+ * phy is no longer operational and is not capable of communicating wi=
th the
+ *    remote end point.
+ * @controller: This parameter represents the controller associated wi=
th the
+ *    phy.
+ * @port: This parameter specifies the port object for which the user =
callback
+ *    is being invoked.  There may be conditions where this parameter =
can be
+ *    NULL
+ * @phy: This parameter specifies the phy object for which the user ca=
llback is
+ *    being invoked.
+ *
+ */
+void isci_event_port_link_down(
+	struct scic_sds_controller *controller,
+	struct scic_sds_port *port,
+	struct scic_sds_phy *phy);
+
+/**
+ * isci_event_remote_device_start_complete() - This user callback meth=
od will
+ *    inform the user that a start operation has completed.
+ * @controller: This parameter specifies the core controller associate=
d with
+ *    the completion callback.
+ * @remote_device: This parameter specifies the remote device associat=
ed with
+ *    the completion callback.
+ * @completion_status: This parameter specifies the completion status =
for the
+ *    operation.
+ *
+ */
+void isci_event_remote_device_start_complete(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *remote_device,
+	enum sci_status completion_status);
+
+/**
+ * isci_event_remote_device_stop_complete() - This user callback metho=
d will
+ *    inform the user that a stop operation has completed.
+ * @controller: This parameter specifies the core controller associate=
d with
+ *    the completion callback.
+ * @remote_device: This parameter specifies the remote device associat=
ed with
+ *    the completion callback.
+ * @completion_status: This parameter specifies the completion status =
for the
+ *    operation.
+ *
+ */
+void isci_event_remote_device_stop_complete(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *remote_device,
+	enum sci_status completion_status);
+
+/**
+ * isci_event_remote_device_ready() - This user callback method will i=
nform the
+ *    user that a remote device is now capable of handling IO requests=
=2E
+ * @controller: This parameter specifies the core controller associate=
d with
+ *    the completion callback.
+ * @remote_device: This parameter specifies the remote device associat=
ed with
+ *    the callback.
+ *
+ */
+void isci_event_remote_device_ready(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *remote_device);
+
+/**
+ * isci_event_remote_device_not_ready() - This user callback method wi=
ll inform
+ *    the user that a remote device is no longer capable of handling I=
O
+ *    requests (until a ready callback is invoked).
+ * @controller: This parameter specifies the core controller associate=
d with
+ *    the completion callback.
+ * @remote_device: This parameter specifies the remote device associat=
ed with
+ *    the callback.
+ * @reason_code: This paramete specifies the reason the remote device =
is not
+ *    ready.
+ *
+ */
+void isci_event_remote_device_not_ready(
+	struct scic_sds_controller *controller,
+	struct scic_sds_remote_device *remote_device,
+	u32 reason_code);
+
+#endif
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index aa86615..dc231c2 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -78,8 +78,9 @@ irqreturn_t isci_intx_isr(int vec, void *data)
 	struct pci_dev *pdev =3D data;
 	struct isci_host *ihost;
 	irqreturn_t ret =3D IRQ_NONE;
+	int i;
=20
-	for_each_isci_host(ihost, pdev) {
+	for_each_isci_host(i, ihost, pdev) {
 		struct scic_sds_controller *scic =3D ihost->core_controller;
=20
 		if (scic_sds_controller_isr(scic)) {
@@ -269,27 +270,29 @@ static int isci_host_mdl_allocate_coherent(
 static void isci_host_completion_routine(unsigned long data)
 {
 	struct isci_host *isci_host =3D (struct isci_host *)data;
-	struct list_head completed_request_list;
-	struct list_head aborted_request_list;
-	struct list_head *current_position;
-	struct list_head *next_position;
+	struct list_head    completed_request_list;
+	struct list_head    errored_request_list;
+	struct list_head    *current_position;
+	struct list_head    *next_position;
 	struct isci_request *request;
 	struct isci_request *next_request;
-	struct sas_task *task;
+	struct sas_task     *task;
=20
 	INIT_LIST_HEAD(&completed_request_list);
-	INIT_LIST_HEAD(&aborted_request_list);
+	INIT_LIST_HEAD(&errored_request_list);
=20
 	spin_lock_irq(&isci_host->scic_lock);
=20
 	scic_sds_controller_completion_handler(isci_host->core_controller);
=20
 	/* Take the lists of completed I/Os from the host. */
+
 	list_splice_init(&isci_host->requests_to_complete,
 			 &completed_request_list);
=20
-	list_splice_init(&isci_host->requests_to_abort,
-			 &aborted_request_list);
+	/* Take the list of errored I/Os from the host. */
+	list_splice_init(&isci_host->requests_to_errorback,
+			 &errored_request_list);
=20
 	spin_unlock_irq(&isci_host->scic_lock);
=20
@@ -308,13 +311,22 @@ static void isci_host_completion_routine(unsigned=
 long data)
 			request,
 			task);
=20
-		task->task_done(task);
-		task->lldd_task =3D NULL;
+		/* Return the task to libsas */
+		if (task !=3D NULL) {
=20
+			task->lldd_task =3D NULL;
+			if (!(task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+
+				/* If the task is already in the abort path,
+				* the task_done callback cannot be called.
+				*/
+				task->task_done(task);
+			}
+		}
 		/* Free the request object. */
 		isci_request_free(isci_host, request);
 	}
-	list_for_each_entry_safe(request, next_request, &aborted_request_list=
,
+	list_for_each_entry_safe(request, next_request, &errored_request_list=
,
 				 completed_node) {
=20
 		task =3D isci_request_access_task(request);
@@ -326,8 +338,33 @@ static void isci_host_completion_routine(unsigned =
long data)
 			 request,
 			 task);
=20
-		/* Put the task into the abort path. */
-		sas_task_abort(task);
+		if (task !=3D NULL) {
+
+			/* Put the task into the abort path if it's not there
+			 * already.
+			 */
+			if (!(task->task_state_flags & SAS_TASK_STATE_ABORTED))
+				sas_task_abort(task);
+
+		} else {
+			/* This is a case where the request has completed with a
+			 * status such that it needed further target servicing,
+			 * but the sas_task reference has already been removed
+			 * from the request.  Since it was errored, it was not
+			 * being aborted, so there is nothing to do except free
+			 * it.
+			 */
+
+			spin_lock_irq(&isci_host->scic_lock);
+			/* Remove the request from the remote device's list
+			* of pending requests.
+			*/
+			list_del_init(&request->dev_node);
+			spin_unlock_irq(&isci_host->scic_lock);
+
+			/* Free the request object. */
+			isci_request_free(isci_host, request);
+		}
 	}
=20
 }
@@ -344,14 +381,19 @@ void isci_host_deinit(struct isci_host *ihost)
=20
 		list_for_each_entry_safe(idev, d, &port->remote_dev_list, node) {
 			isci_remote_device_change_state(idev, isci_stopping);
-			isci_remote_device_stop(idev);
+			isci_remote_device_stop(ihost, idev);
 		}
 	}
=20
 	set_bit(IHOST_STOP_PENDING, &ihost->flags);
+
+	spin_lock_irq(&ihost->scic_lock);
 	scic_controller_stop(scic, SCIC_CONTROLLER_STOP_TIMEOUT);
+	spin_unlock_irq(&ihost->scic_lock);
+
 	wait_for_stop(ihost);
 	scic_controller_reset(scic);
+	isci_timer_list_destroy(ihost);
 }
=20
 static void __iomem *scu_base(struct isci_host *isci_host)
@@ -370,23 +412,15 @@ static void __iomem *smu_base(struct isci_host *i=
sci_host)
 	return pcim_iomap_table(pdev)[SCI_SMU_BAR * 2] + SCI_SMU_BAR_SIZE * i=
d;
 }
=20
-#define SCI_MAX_TIMER_COUNT 25
-
 int isci_host_init(struct isci_host *isci_host)
 {
-	int err =3D 0;
-	int index =3D 0;
+	int err =3D 0, i;
 	enum sci_status status;
 	struct scic_sds_controller *controller;
-	struct scic_sds_port *scic_port;
 	union scic_oem_parameters scic_oem_params;
 	union scic_user_parameters scic_user_params;
=20
-	INIT_LIST_HEAD(&isci_host->timer_list_struct.timers);
-	isci_timer_list_construct(
-		&isci_host->timer_list_struct,
-		SCI_MAX_TIMER_COUNT
-		);
+	isci_timer_list_construct(isci_host);
=20
 	controller =3D scic_controller_alloc(&isci_host->pdev->dev);
=20
@@ -473,7 +507,17 @@ int isci_host_init(struct isci_host *isci_host)
 		}
 	}
=20
+	tasklet_init(&isci_host->completion_tasklet,
+		     isci_host_completion_routine, (unsigned long)isci_host);
+
+	INIT_LIST_HEAD(&(isci_host->mdl_struct_list));
+
+	INIT_LIST_HEAD(&isci_host->requests_to_complete);
+	INIT_LIST_HEAD(&isci_host->requests_to_errorback);
+
+	spin_lock_irq(&isci_host->scic_lock);
 	status =3D scic_controller_initialize(isci_host->core_controller);
+	spin_unlock_irq(&isci_host->scic_lock);
 	if (status !=3D SCI_SUCCESS) {
 		dev_warn(&isci_host->pdev->dev,
 			 "%s: scic_controller_initialize failed -"
@@ -482,17 +526,8 @@ int isci_host_init(struct isci_host *isci_host)
 		return -ENODEV;
 	}
=20
-	tasklet_init(&isci_host->completion_tasklet,
-		     isci_host_completion_routine, (unsigned long)isci_host);
-
-	INIT_LIST_HEAD(&(isci_host->mdl_struct_list));
-
-	INIT_LIST_HEAD(&isci_host->requests_to_complete);
-	INIT_LIST_HEAD(&isci_host->requests_to_abort);
-
 	/* populate mdl with dma memory. scu_mdl_allocate_coherent() */
 	err =3D isci_host_mdl_allocate_coherent(isci_host);
-
 	if (err)
 		return err;
=20
@@ -509,23 +544,18 @@ int isci_host_init(struct isci_host *isci_host)
 	if (!isci_host->dma_pool)
 		return -ENOMEM;
=20
-	for (index =3D 0; index < SCI_MAX_PORTS; index++)
-		isci_port_init(&isci_host->isci_ports[index],
-			       isci_host,
-			       index);
+	for (i =3D 0; i < SCI_MAX_PORTS; i++)
+		isci_port_init(&isci_host->isci_ports[i], isci_host, i);
=20
-	for (index =3D 0; index < SCI_MAX_PHYS; index++)
-		isci_phy_init(&isci_host->phys[index], isci_host, index);
+	for (i =3D 0; i < SCI_MAX_PHYS; i++)
+		isci_phy_init(&isci_host->phys[i], isci_host, i);
=20
-	/* Why are we doing this? Is this even necessary? */
-	memcpy(&isci_host->sas_addr[0],
-	       &isci_host->phys[0].sas_addr[0],
-	       SAS_ADDR_SIZE);
+	for (i =3D 0; i < SCI_MAX_REMOTE_DEVICES; i++) {
+		struct isci_remote_device *idev =3D idev_by_id(isci_host, i);
=20
-	/* Start the ports */
-	for (index =3D 0; index < SCI_MAX_PORTS; index++) {
-		scic_controller_get_port_handle(controller, index, &scic_port);
-		scic_port_start(scic_port);
+		INIT_LIST_HEAD(&idev->reqs_in_process);
+		INIT_LIST_HEAD(&idev->node);
+		spin_lock_init(&idev->state_lock);
 	}
=20
 	return 0;
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 26768c5..889a785 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -61,7 +61,7 @@
 /*#include "task.h"*/
 #include "timers.h"
 #include "remote_device.h"
-#include "scic_user_callback.h"
+#include "scic_remote_device.h"
=20
 #define DRV_NAME "isci"
 #define SCI_PCI_BAR_COUNT 2
@@ -88,7 +88,7 @@ struct isci_host {
 	union scic_oem_parameters oem_parameters;
=20
 	int id; /* unique within a given pci device */
-	struct isci_timer_list timer_list_struct;
+	struct list_head timers;
 	void *core_ctrl_memory;
 	struct dma_pool *dma_pool;
 	unsigned int dma_pool_alloc_size;
@@ -106,7 +106,6 @@ struct isci_host {
 	spinlock_t state_lock;
=20
 	struct pci_dev *pdev;
-	u8 sas_addr[SAS_ADDR_SIZE];
=20
 	enum isci_status status;
 	#define IHOST_START_PENDING 0
@@ -117,11 +116,20 @@ struct isci_host {
 	struct tasklet_struct completion_tasklet;
 	struct list_head mdl_struct_list;
 	struct list_head requests_to_complete;
-	struct list_head requests_to_abort;
+	struct list_head requests_to_errorback;
 	spinlock_t scic_lock;
-	struct isci_host *next;
+
+	/* careful only access this via idev_by_id */
+	struct isci_remote_device devices[0];
 };
=20
+static inline struct isci_remote_device *idev_by_id(struct isci_host *=
ihost, int i)
+{
+	void *p =3D ihost->devices;
+
+	return p + i * (sizeof(struct isci_remote_device) +
+			scic_remote_device_get_object_size());
+}
=20
 /**
  * struct isci_pci_info - This class represents the pci function conta=
ining the
@@ -133,7 +141,7 @@ struct isci_host {
 struct isci_pci_info {
 	struct msix_entry msix_entries[SCI_MAX_MSIX_INT];
 	int core_lib_array_index;
-	struct isci_host *hosts;
+	struct isci_host *hosts[SCI_MAX_CONTROLLERS];
 };
=20
 static inline struct isci_pci_info *to_pci_info(struct pci_dev *pdev)
@@ -141,9 +149,10 @@ static inline struct isci_pci_info *to_pci_info(st=
ruct pci_dev *pdev)
 	return pci_get_drvdata(pdev);
 }
=20
-#define for_each_isci_host(isci_host, pdev) \
-	for (isci_host =3D to_pci_info(pdev)->hosts;\
-	     isci_host; isci_host =3D isci_host->next)
+#define for_each_isci_host(id, ihost, pdev) \
+	for (id =3D 0, ihost =3D to_pci_info(pdev)->hosts[id]; \
+	     id < ARRAY_SIZE(to_pci_info(pdev)->hosts) && ihost; \
+	     ihost =3D to_pci_info(pdev)->hosts[++id])
=20
 static inline
 enum isci_status isci_host_get_state(
@@ -214,6 +223,15 @@ static inline void wait_for_stop(struct isci_host =
*ihost)
 	wait_event(ihost->eventq, !test_bit(IHOST_STOP_PENDING, &ihost->flags=
));
 }
=20
+static inline void wait_for_device_start(struct isci_host *ihost, stru=
ct isci_remote_device *idev)
+{
+	wait_event(ihost->eventq, !test_bit(IDEV_START_PENDING, &idev->flags)=
);
+}
+
+static inline void wait_for_device_stop(struct isci_host *ihost, struc=
t isci_remote_device *idev)
+{
+	wait_event(ihost->eventq, !test_bit(IDEV_STOP_PENDING, &idev->flags))=
;
+}
=20
 /**
  * isci_host_from_sas_ha() - This accessor retrieves the isci_host obj=
ect
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index a5467cf..500c0b5 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -64,7 +64,6 @@
 #include "sci_environment.h"
=20
 static struct scsi_transport_template *isci_transport_template;
-struct kmem_cache *isci_kmem_cache;
=20
 static DEFINE_PCI_DEVICE_TABLE(isci_id_table) =3D {
 	{ PCI_VDEVICE(INTEL, 0x1D61),},
@@ -213,7 +212,7 @@ static int isci_register_sas_ha(struct isci_host *i=
sci_host)
=20
 	sas_ha->sas_ha_name =3D DRV_NAME;
 	sas_ha->lldd_module =3D THIS_MODULE;
-	sas_ha->sas_addr    =3D &(isci_host->sas_addr[0]);
+	sas_ha->sas_addr    =3D &isci_host->phys[0].sas_addr[0];
=20
 	/* set the array of phy and port structs.  */
 	for (i =3D 0; i < SCI_MAX_PHYS; i++) {
@@ -234,12 +233,28 @@ static int isci_register_sas_ha(struct isci_host =
*isci_host)
 	return 0;
 }
=20
-static void isci_unregister_sas_ha(struct isci_host *isci_host)
+static ssize_t isci_show_id(struct device *dev, struct device_attribut=
e *attr, char *buf)
 {
+	struct Scsi_Host *shost =3D container_of(dev, typeof(*shost), shost_d=
ev);
+	struct sas_ha_struct *sas_ha =3D SHOST_TO_SAS_HA(shost);
+	struct isci_host *ihost =3D container_of(sas_ha, typeof(*ihost), sas_=
ha);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", ihost->id);
+}
+
+static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
+
+static void isci_unregister(struct isci_host *isci_host)
+{
+	struct Scsi_Host *shost;
+
 	if (!isci_host)
 		return;
=20
-	sas_unregister_ha(&(isci_host->sas_ha));
+	shost =3D isci_host->shost;
+	device_remove_file(&shost->shost_dev, &dev_attr_isci_id);
+
+	sas_unregister_ha(&isci_host->sas_ha);
=20
 	sas_remove_host(isci_host->shost);
 	scsi_remove_host(isci_host->shost);
@@ -289,16 +304,6 @@ static int __devinit isci_pci_init(struct pci_dev =
*pdev)
 	return 0;
 }
=20
-static struct isci_host *isci_host_by_id(struct pci_dev *pdev, int id)
-{
-	struct isci_host *h;
-
-	for_each_isci_host(h, pdev)
-		if (h->id =3D=3D id)
-			return h;
-	return NULL;
-}
-
 static int num_controllers(struct pci_dev *pdev)
 {
 	/* bar size alone can tell us if we are running with a dual controlle=
r
@@ -336,7 +341,7 @@ static int isci_setup_interrupts(struct pci_dev *pd=
ev)
 	for (i =3D 0; i < num_msix; i++) {
 		int id =3D i / SCI_NUM_MSI_X_INT;
 		struct msix_entry *msix =3D &pci_info->msix_entries[i];
-		struct isci_host *isci_host =3D isci_host_by_id(pdev, id);
+		struct isci_host *isci_host =3D pci_info->hosts[id];
 		irq_handler_t isr;
=20
 		/* odd numbered vectors are error interrupts */
@@ -355,7 +360,7 @@ static int isci_setup_interrupts(struct pci_dev *pd=
ev)
 		dev_info(&pdev->dev, "msix setup failed falling back to intx\n");
 		while (i--) {
 			id =3D i / SCI_NUM_MSI_X_INT;
-			isci_host =3D isci_host_by_id(pdev, id);
+			isci_host =3D pci_info->hosts[id];
 			msix =3D &pci_info->msix_entries[i];
 			devm_free_irq(&pdev->dev, msix->vector, isci_host);
 		}
@@ -457,7 +462,10 @@ static struct isci_host *isci_host_alloc(struct pc=
i_dev *pdev, int id)
 	struct Scsi_Host *shost;
 	int err;
=20
-	isci_host =3D devm_kzalloc(&pdev->dev, sizeof(*isci_host), GFP_KERNEL=
);
+	isci_host =3D devm_kzalloc(&pdev->dev, sizeof(*isci_host) +
+				 SCI_MAX_REMOTE_DEVICES *
+				 (sizeof(struct isci_remote_device) +
+				  scic_remote_device_get_object_size()), GFP_KERNEL);
 	if (!isci_host)
 		return NULL;
=20
@@ -489,8 +497,14 @@ static struct isci_host *isci_host_alloc(struct pc=
i_dev *pdev, int id)
 	if (err)
 		goto err_shost_remove;
=20
+	err =3D device_create_file(&shost->shost_dev, &dev_attr_isci_id);
+	if (err)
+		goto err_unregister_ha;
+
 	return isci_host;
=20
+ err_unregister_ha:
+	sas_unregister_ha(&(isci_host->sas_ha));
  err_shost_remove:
 	scsi_remove_host(shost);
  err_shost:
@@ -638,32 +652,31 @@ static int __devinit isci_pci_probe(struct pci_de=
v *pdev, const struct pci_devic
 			err =3D -ENOMEM;
 			goto err_host_alloc;
 		}
-
-		h->next =3D pci_info->hosts;
-		pci_info->hosts =3D h;
+		pci_info->hosts[i] =3D h;
 	}
=20
 	err =3D isci_setup_interrupts(pdev);
 	if (err)
 		goto err_host_alloc;
=20
-	for_each_isci_host(isci_host, pdev)
+	for_each_isci_host(i, isci_host, pdev)
 		scsi_scan_host(isci_host->shost);
=20
 	return 0;
=20
  err_host_alloc:
-	for_each_isci_host(isci_host, pdev)
-		isci_unregister_sas_ha(isci_host);
+	for_each_isci_host(i, isci_host, pdev)
+		isci_unregister(isci_host);
 	return err;
 }
=20
 static void __devexit isci_pci_remove(struct pci_dev *pdev)
 {
 	struct isci_host *isci_host;
+	int i;
=20
-	for_each_isci_host(isci_host, pdev) {
-		isci_unregister_sas_ha(isci_host);
+	for_each_isci_host(i, isci_host, pdev) {
+		isci_unregister(isci_host);
 		isci_host_deinit(isci_host);
 		scic_controller_disable_interrupts(isci_host->core_controller);
 	}
@@ -671,31 +684,17 @@ static void __devexit isci_pci_remove(struct pci_=
dev *pdev)
=20
 static __init int isci_init(void)
 {
-	int err =3D -ENOMEM;
+	int err;
=20
 	pr_info("%s: Intel(R) C600 SAS Controller Driver\n", DRV_NAME);
=20
-	isci_kmem_cache =3D kmem_cache_create(DRV_NAME,
-					    sizeof(struct isci_remote_device) +
-					    scic_remote_device_get_object_size(),
-					    0, 0, NULL);
-	if (!isci_kmem_cache)
-		return err;
-
 	isci_transport_template =3D sas_domain_attach_transport(&isci_transpo=
rt_ops);
 	if (!isci_transport_template)
-		goto err_kmem;
+		return -ENOMEM;
=20
 	err =3D pci_register_driver(&isci_pci_driver);
 	if (err)
-		goto err_sas;
-
-	return 0;
-
- err_sas:
-	sas_release_transport(isci_transport_template);
- err_kmem:
-	kmem_cache_destroy(isci_kmem_cache);
+		sas_release_transport(isci_transport_template);
=20
 	return err;
 }
@@ -704,7 +703,6 @@ static __exit void isci_exit(void)
 {
 	pci_unregister_driver(&isci_pci_driver);
 	sas_release_transport(isci_transport_template);
-	kmem_cache_destroy(isci_kmem_cache);
 }
=20
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/scsi/isci/isci.h b/drivers/scsi/isci/isci.h
index 6c79b29..b3f63f1 100644
--- a/drivers/scsi/isci/isci.h
+++ b/drivers/scsi/isci/isci.h
@@ -53,21 +53,8 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE=
=2E
  */
=20
-/**
- * This file contains the isci_module object definition.
- *
- * isci.h
- */
-
-#if !defined(_SCI_MODULE_H_)
-#define _SCI_MODULE_H_
-
-/**
- * This file contains the SCI low level driver interface to the SCI an=
d Libsas
- *    Libraries.
- *
- * isci.h
- */
+#ifndef __ISCI_H__
+#define __ISCI_H__
=20
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -84,8 +71,11 @@
 #include "host.h"
 #include "timers.h"
 #include "sci_status.h"
+#include "request.h"
+#include "events.h"
+#include "task.h"
+#include "sata.h"
=20
-extern struct kmem_cache *isci_kmem_cache;
 extern struct isci_firmware *isci_firmware;
=20
 #define ISCI_FW_NAME		"isci/isci_firmware.bin"
@@ -133,11 +123,4 @@ enum sci_status isci_parse_user_parameters(
 	int scu_index,
 	struct isci_firmware *fw);
=20
-#ifdef ISCI_SLAVE_ALLOC
-extern int ISCI_SLAVE_ALLOC(struct scsi_device *scsi_dev);
-#endif /* ISCI_SLAVE_ALLOC */
-
-#ifdef ISCI_SLAVE_DESTROY
-extern void ISCI_SLAVE_DESTROY(struct scsi_device *scsi_dev);
-#endif  /* ISCI_SLAVE_DESTROY */
-#endif  /* !defined(_SCI_MODULE_H_) */
+#endif  /* __ISCI_H__ */
diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index fbda570..decc0c0 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -58,6 +58,9 @@
 #include "scic_port.h"
 #include "scic_config_parameters.h"
=20
+struct scic_sds_phy;
+extern enum sci_status scic_sds_phy_start(struct scic_sds_phy *sci_phy=
);
+extern enum sci_status scic_sds_phy_stop(struct scic_sds_phy *sci_phy)=
;
=20
 /**
  * isci_phy_init() - This function is called by the probe function to
@@ -75,14 +78,15 @@ void isci_phy_init(
 	struct isci_host *isci_host,
 	int index)
 {
-	struct scic_sds_controller *controller =3D isci_host->core_controller=
;
+	struct scic_sds_controller *scic =3D isci_host->core_controller;
 	struct scic_sds_phy *scic_phy;
-	union scic_oem_parameters oem_parameters;
+	union scic_oem_parameters oem;
 	enum sci_status status =3D SCI_SUCCESS;
+	u64 sas_addr;
=20
 	/*--------------- SCU_Phy Initialization Stuff ----------------------=
-*/
=20
-	status =3D scic_controller_get_phy_handle(controller, index, &scic_ph=
y);
+	status =3D scic_controller_get_phy_handle(scic, index, &scic_phy);
 	if (status =3D=3D SCI_SUCCESS) {
 		sci_object_set_association(scic_phy, (void *)phy);
 		phy->sci_phy_handle =3D scic_phy;
@@ -90,24 +94,13 @@ void isci_phy_init(
 		dev_err(&isci_host->pdev->dev,
 			"failed scic_controller_get_phy_handle\n");
=20
-	scic_oem_parameters_get(controller, &oem_parameters);
-
-	phy->sas_addr[0] =3D  oem_parameters.sds1.phys[index].sas_address.low
-			   & 0xFF;
-	phy->sas_addr[1] =3D (oem_parameters.sds1.phys[index].sas_address.low
-			    >> 8)   & 0xFF;
-	phy->sas_addr[2] =3D (oem_parameters.sds1.phys[index].sas_address.low
-			    >> 16)  & 0xFF;
-	phy->sas_addr[3] =3D (oem_parameters.sds1.phys[index].sas_address.low
-			    >> 24)  & 0xFF;
-	phy->sas_addr[4] =3D  oem_parameters.sds1.phys[index].sas_address.hig=
h
-			   & 0xFF;
-	phy->sas_addr[5] =3D (oem_parameters.sds1.phys[index].sas_address.hig=
h
-			    >> 8)  & 0xFF;
-	phy->sas_addr[6] =3D (oem_parameters.sds1.phys[index].sas_address.hig=
h
-			    >> 16) & 0xFF;
-	phy->sas_addr[7] =3D (oem_parameters.sds1.phys[index].sas_address.hig=
h
-			    >> 24) & 0xFF;
+	scic_oem_parameters_get(scic, &oem);
+	sas_addr =3D oem.sds1.phys[index].sas_address.high;
+	sas_addr <<=3D 32;
+	sas_addr |=3D oem.sds1.phys[index].sas_address.low;
+	swab64s(&sas_addr);
+
+	memcpy(phy->sas_addr, &sas_addr, sizeof(sas_addr));
=20
 	phy->isci_port =3D NULL;
 	phy->sas_phy.enabled =3D 0;
@@ -137,42 +130,48 @@ void isci_phy_init(
  *
  * status, zero indicates success.
  */
-int isci_phy_control(
-	struct asd_sas_phy *phy,
-	enum phy_func func,
-	void *buf)
+int isci_phy_control(struct asd_sas_phy *sas_phy,
+		     enum phy_func func,
+		     void *buf)
 {
-	int ret            =3D TMF_RESP_FUNC_COMPLETE;
-	struct isci_phy *isci_phy_ptr  =3D (struct isci_phy *)phy->lldd_phy;
-	struct isci_port *isci_port_ptr =3D NULL;
-
-	if (isci_phy_ptr !=3D NULL)
-		isci_port_ptr =3D isci_phy_ptr->isci_port;
-
-	if ((isci_phy_ptr =3D=3D NULL) || (isci_port_ptr =3D=3D NULL)) {
-		pr_err("%s: asd_sas_phy %p: lldd_phy %p or "
-		       "isci_port %p =3D=3D NULL!\n",
-		       __func__, phy, isci_phy_ptr, isci_port_ptr);
-		return TMF_RESP_FUNC_FAILED;
-	}
+	int ret =3D 0;
+	struct isci_phy *iphy =3D sas_phy->lldd_phy;
+	struct isci_port *iport =3D iphy->isci_port;
+	struct isci_host *ihost =3D sas_phy->ha->lldd_ha;
+	unsigned long flags;
=20
-	pr_debug("%s: phy %p; func %d; buf %p; isci phy %p, port %p\n",
-		 __func__, phy, func, buf, isci_phy_ptr, isci_port_ptr);
+	dev_dbg(&ihost->pdev->dev,
+		"%s: phy %p; func %d; buf %p; isci phy %p, port %p\n",
+		__func__, sas_phy, func, buf, iphy, iport);
=20
 	switch (func) {
-	case PHY_FUNC_HARD_RESET:
+	case PHY_FUNC_DISABLE:
+		spin_lock_irqsave(&ihost->scic_lock, flags);
+		scic_sds_phy_stop(iphy->sci_phy_handle);
+		spin_unlock_irqrestore(&ihost->scic_lock, flags);
+		break;
+
 	case PHY_FUNC_LINK_RESET:
+		spin_lock_irqsave(&ihost->scic_lock, flags);
+		scic_sds_phy_stop(iphy->sci_phy_handle);
+		scic_sds_phy_start(iphy->sci_phy_handle);
+		spin_unlock_irqrestore(&ihost->scic_lock, flags);
+		break;
+
+	case PHY_FUNC_HARD_RESET:
+		if (!iport)
+			return -ENODEV;
=20
 		/* Perform the port reset. */
-		ret =3D isci_port_perform_hard_reset(isci_port_ptr, isci_phy_ptr);
+		ret =3D isci_port_perform_hard_reset(iport, iphy);
=20
 		break;
=20
-	case PHY_FUNC_DISABLE:
 	default:
-		pr_debug("%s: phy %p; func %d NOT IMPLEMENTED!\n",
-			 __func__, phy, func);
-		ret =3D TMF_RESP_FUNC_FAILED;
+		dev_dbg(&ihost->pdev->dev,
+			   "%s: phy %p; func %d NOT IMPLEMENTED!\n",
+			   __func__, sas_phy, func);
+		ret =3D -ENOSYS;
 		break;
 	}
 	return ret;
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 446da20..a5b2565 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -94,7 +94,6 @@ void isci_port_init(
=20
 	INIT_LIST_HEAD(&isci_port->remote_dev_list);
 	INIT_LIST_HEAD(&isci_port->domain_dev_list);
-	spin_lock_init(&isci_port->remote_device_lock);
 	spin_lock_init(&isci_port->state_lock);
 	init_completion(&isci_port->start_complete);
 	isci_port->isci_host =3D isci_host;
@@ -192,6 +191,7 @@ void isci_port_link_up(
 	scic_port_get_properties(port, &properties);
=20
 	if (properties.remote.protocols.u.bits.stp_target) {
+		u64 attached_sas_address;
=20
 		struct scic_sata_phy_properties sata_phy_properties;
=20
@@ -220,17 +220,13 @@ void isci_port_link_up(
 		 * will not be the same as assigned to the PHY and needs
 		 * to be obtained from struct scic_port_properties properties.
 		 */
+		attached_sas_address =3D properties.remote.sas_address.high;
+		attached_sas_address <<=3D 32;
+		attached_sas_address |=3D properties.remote.sas_address.low;
+		swab64s(&attached_sas_address);
=20
-		BUG_ON(((size_t)SAS_ADDR_SIZE / 2)
-		       !=3D sizeof(properties.remote.sas_address.low));
-
-		memcpy(&isci_phy->sas_phy.attached_sas_addr[0],
-		       &properties.remote.sas_address.low,
-		       SAS_ADDR_SIZE / 2);
-
-		memcpy(&isci_phy->sas_phy.attached_sas_addr[4],
-		       &properties.remote.sas_address.high,
-		       SAS_ADDR_SIZE / 2);
+		memcpy(&isci_phy->sas_phy.attached_sas_addr,
+		       &attached_sas_address, sizeof(attached_sas_address));
=20
 	} else if (properties.remote.protocols.u.bits.ssp_target ||
 		   properties.remote.protocols.u.bits.smp_target) {
diff --git a/drivers/scsi/isci/port.h b/drivers/scsi/isci/port.h
index b01b0c6..b7a7dd7 100644
--- a/drivers/scsi/isci/port.h
+++ b/drivers/scsi/isci/port.h
@@ -73,7 +73,6 @@ enum isci_status {
 	isci_ready_for_io =3D 0x03,
 	isci_stopping     =3D 0x04,
 	isci_stopped      =3D 0x05,
-	isci_host_quiesce =3D 0x06
 };
=20
 /**
@@ -91,7 +90,6 @@ struct isci_port {
 	struct isci_host *isci_host;
 	struct asd_sas_port sas_port;
 	struct list_head remote_dev_list;
-	spinlock_t remote_device_lock;
 	spinlock_t state_lock;
 	struct list_head domain_dev_list;
 	struct completion start_complete;
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remo=
te_device.c
index dec9033..6fe6815 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -67,35 +67,35 @@
=20
 /**
  * isci_remote_device_deconstruct() - This function frees an isci_remo=
te_device.
- * @isci_host: This parameter specifies the isci host object.
- * @isci_device: This parameter specifies the remote device to be free=
d.
+ * @ihost: This parameter specifies the isci host object.
+ * @idev: This parameter specifies the remote device to be freed.
  *
  */
-static void isci_remote_device_deconstruct(
-	struct isci_host *isci_host,
-	struct isci_remote_device *isci_device)
+static void isci_remote_device_deconstruct(struct isci_host *ihost, st=
ruct isci_remote_device *idev)
 {
-	dev_dbg(&isci_host->pdev->dev,
-		"%s: isci_device =3D %p\n", __func__, isci_device);
+	dev_dbg(&ihost->pdev->dev,
+		"%s: isci_device =3D %p\n", __func__, idev);
=20
 	/* There should not be any outstanding io's. All paths to
 	 * here should go through isci_remote_device_nuke_requests.
 	 * If we hit this condition, we will need a way to complete
 	 * io requests in process */
-	while (!list_empty(&isci_device->reqs_in_process)) {
+	while (!list_empty(&idev->reqs_in_process)) {
=20
-		dev_err(&isci_host->pdev->dev,
+		dev_err(&ihost->pdev->dev,
 			"%s: ** request list not empty! **\n", __func__);
 		BUG();
 	}
=20
-	/* Remove all related references to this device and free
-	 * the cache object.
-	 */
-	scic_remote_device_destruct(isci_device->sci_device_handle);
-	isci_device->domain_dev->lldd_dev =3D NULL;
-	list_del(&isci_device->node);
-	kmem_cache_free(isci_kmem_cache, isci_device);
+	scic_remote_device_destruct(to_sci_dev(idev));
+	idev->domain_dev->lldd_dev =3D NULL;
+	idev->domain_dev =3D NULL;
+	idev->isci_port =3D NULL;
+	list_del_init(&idev->node);
+
+	clear_bit(IDEV_START_PENDING, &idev->flags);
+	clear_bit(IDEV_STOP_PENDING, &idev->flags);
+	wake_up(&ihost->eventq);
 }
=20
=20
@@ -117,7 +117,7 @@ static enum sci_status isci_remote_device_construct=
(
=20
 	/* let the core do it's common constuction. */
 	scic_remote_device_construct(port->sci_port_handle,
-				     isci_device->sci_device_handle);
+				     to_sci_dev(isci_device));
=20
 	/* let the core do it's device specific constuction. */
 	if (isci_device->domain_dev->parent &&
@@ -183,15 +183,11 @@ static enum sci_status isci_remote_device_constru=
ct(
 			"%s: parent->dev_type =3D EDGE_DEV\n",
 			__func__);
=20
-		status =3D scic_remote_device_ea_construct(
-			isci_device->sci_device_handle,
-			(struct smp_response_discover *)&discover_response
-			);
+		status =3D scic_remote_device_ea_construct(to_sci_dev(isci_device),
+				(struct smp_response_discover *)&discover_response);
=20
 	} else
-		status =3D scic_remote_device_da_construct(
-			isci_device->sci_device_handle
-			);
+		status =3D scic_remote_device_da_construct(to_sci_dev(isci_device));
=20
=20
 	if (status !=3D SCI_SUCCESS) {
@@ -204,18 +200,13 @@ static enum sci_status isci_remote_device_constru=
ct(
 		return status;
 	}
=20
-	sci_object_set_association(
-		isci_device->sci_device_handle,
-		isci_device
-		);
+	sci_object_set_association(to_sci_dev(isci_device), isci_device);
=20
 	BUG_ON(port->isci_host =3D=3D NULL);
=20
 	/* start the device. */
-	status =3D scic_remote_device_start(
-		isci_device->sci_device_handle,
-		ISCI_REMOTE_DEVICE_START_TIMEOUT
-		);
+	status =3D scic_remote_device_start(to_sci_dev(isci_device),
+					  ISCI_REMOTE_DEVICE_START_TIMEOUT);
=20
 	if (status !=3D SCI_SUCCESS) {
 		dev_warn(&port->isci_host->pdev->dev,
@@ -263,81 +254,46 @@ void isci_remote_device_nuke_requests(
  * pointer to new isci_remote_device.
  */
 static struct isci_remote_device *
-isci_remote_device_alloc(struct isci_host *isci_host, struct isci_port=
 *port)
+isci_remote_device_alloc(struct isci_host *ihost, struct isci_port *ip=
ort)
 {
-	struct isci_remote_device *isci_device;
-	struct scic_sds_remote_device *sci_dev;
+	struct isci_remote_device *idev;
+	int i;
=20
-	isci_device =3D kmem_cache_zalloc(isci_kmem_cache, GFP_KERNEL);
+	for (i =3D 0; i < SCI_MAX_REMOTE_DEVICES; i++) {
+		idev =3D idev_by_id(ihost, i);
+		if (!test_and_set_bit(IDEV_ALLOCATED, &idev->flags))
+			break;
+	}
=20
-	if (!isci_device) {
-		dev_warn(&isci_host->pdev->dev, "%s: failed\n", __func__);
+	if (i >=3D SCI_MAX_REMOTE_DEVICES) {
+		dev_warn(&ihost->pdev->dev, "%s: failed\n", __func__);
 		return NULL;
 	}
=20
-	sci_dev =3D (struct scic_sds_remote_device *) &isci_device[1];
-	isci_device->sci_device_handle =3D sci_dev;
-	INIT_LIST_HEAD(&isci_device->reqs_in_process);
-	INIT_LIST_HEAD(&isci_device->node);
-	isci_device->host_quiesce          =3D false;
-
-	spin_lock_init(&isci_device->state_lock);
-	spin_lock_init(&isci_device->host_quiesce_lock);
-	isci_remote_device_change_state(isci_device, isci_freed);
+	BUG_ON(!list_empty(&idev->reqs_in_process));
+	BUG_ON(!list_empty(&idev->node));
+	isci_remote_device_change_state(idev, isci_freed);
=20
-	return isci_device;
-
-}
-/**
- * isci_device_set_host_quiesce_lock_state() - This function sets the =
host I/O
- *    quiesce lock state for the remote_device object.
- * @isci_device,: This parameter points to the isci_remote_device obje=
ct
- * @isci_device: This parameter specifies the new quiesce state.
- *
- */
-void isci_device_set_host_quiesce_lock_state(
-	struct isci_remote_device *isci_device,
-	bool lock_state)
-{
-	unsigned long flags;
-
-	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
-		"%s: isci_device=3D%p, lock_state=3D%d\n",
-		__func__, isci_device, lock_state);
-
-	spin_lock_irqsave(&isci_device->host_quiesce_lock, flags);
-	isci_device->host_quiesce =3D lock_state;
-	spin_unlock_irqrestore(&isci_device->host_quiesce_lock, flags);
+	return idev;
 }
=20
 /**
  * isci_remote_device_ready() - This function is called by the scic wh=
en the
  *    remote device is ready. We mark the isci device as ready and sig=
nal the
  *    waiting proccess.
- * @isci_host: This parameter specifies the isci host object.
- * @isci_device: This parameter specifies the remote device
+ * @idev: This parameter specifies the remote device
  *
  */
-void isci_remote_device_ready(struct isci_remote_device *isci_device)
+void isci_remote_device_ready(struct isci_remote_device *idev)
 {
-	unsigned long flags;
-
-	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
-		"%s: isci_device =3D %p\n", __func__, isci_device);
+	struct isci_host *ihost =3D idev->isci_port->isci_host;
=20
-	/* device ready is actually a "ready for io" state. */
-	if ((isci_starting =3D=3D isci_remote_device_get_state(isci_device)) =
||
-	    (isci_ready =3D=3D isci_remote_device_get_state(isci_device))) {
-		spin_lock_irqsave(&isci_device->isci_port->remote_device_lock,
-				  flags);
-		isci_remote_device_change_state(isci_device, isci_ready_for_io);
-		if (isci_device->completion)
-			complete(isci_device->completion);
-		spin_unlock_irqrestore(
-				&isci_device->isci_port->remote_device_lock,
-				flags);
-	}
+	dev_dbg(&ihost->pdev->dev,
+		"%s: idev =3D %p\n", __func__, idev);
=20
+	isci_remote_device_change_state(idev, isci_ready_for_io);
+	if (test_and_clear_bit(IDEV_START_PENDING, &idev->flags))
+		wake_up(&ihost->eventq);
 }
=20
 /**
@@ -376,8 +332,6 @@ void isci_remote_device_stop_complete(
 	struct isci_remote_device *isci_device,
 	enum sci_status status)
 {
-	struct completion *completion =3D isci_device->completion;
-
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: complete isci_device =3D %p, status =3D 0x%x\n",
 		__func__,
@@ -389,9 +343,6 @@ void isci_remote_device_stop_complete(
 	/* after stop, we can tear down resources. */
 	isci_remote_device_deconstruct(isci_host, isci_device);
=20
-	/* notify interested parties. */
-	if (completion)
-		complete(completion);
 }
=20
 /**
@@ -420,43 +371,35 @@ void isci_remote_device_start_complete(
  *
  * The status of the scic request to stop.
  */
-enum sci_status isci_remote_device_stop(
-	struct isci_remote_device *isci_device)
+enum sci_status isci_remote_device_stop(struct isci_host *ihost, struc=
t isci_remote_device *idev)
 {
 	enum sci_status status;
 	unsigned long flags;
=20
-	DECLARE_COMPLETION_ONSTACK(completion);
-
-	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
-		"%s: isci_device =3D %p\n", __func__, isci_device);
-
-	isci_remote_device_change_state(isci_device, isci_stopping);
+	dev_dbg(&ihost->pdev->dev,
+		"%s: isci_device =3D %p\n", __func__, idev);
=20
-	/* We need comfirmation that stop completed. */
-	isci_device->completion =3D &completion;
+	isci_remote_device_change_state(idev, isci_stopping);
=20
-	BUG_ON(isci_device->isci_port =3D=3D NULL);
-	BUG_ON(isci_device->isci_port->isci_host =3D=3D NULL);
+	/* Kill all outstanding requests. */
+	isci_remote_device_nuke_requests(idev);
=20
-	spin_lock_irqsave(&isci_device->isci_port->isci_host->scic_lock, flag=
s);
+	set_bit(IDEV_STOP_PENDING, &idev->flags);
=20
-	status =3D scic_remote_device_stop(
-		isci_device->sci_device_handle,
-		50
-		);
-
-	spin_unlock_irqrestore(&isci_device->isci_port->isci_host->scic_lock,=
 flags);
+	spin_lock_irqsave(&ihost->scic_lock, flags);
+	status =3D scic_remote_device_stop(to_sci_dev(idev), 50);
+	spin_unlock_irqrestore(&ihost->scic_lock, flags);
=20
 	/* Wait for the stop complete callback. */
-	if (status =3D=3D SCI_SUCCESS)
-		wait_for_completion(&completion);
+	if (status =3D=3D SCI_SUCCESS) {
+		wait_for_device_stop(ihost, idev);
+		clear_bit(IDEV_ALLOCATED, &idev->flags);
+	}
=20
-	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
-		"%s: isci_device =3D %p - after completion wait\n",
-		__func__, isci_device);
+	dev_dbg(&ihost->pdev->dev,
+		"%s: idev =3D %p - after completion wait\n",
+		__func__, idev);
=20
-	isci_device->completion =3D NULL;
 	return status;
 }
=20
@@ -466,18 +409,16 @@ enum sci_status isci_remote_device_stop(
  * @domain_device: This parameter specifies the libsas domain device.
  *
  */
-void isci_remote_device_gone(
-	struct domain_device *domain_dev)
+void isci_remote_device_gone(struct domain_device *dev)
 {
-	struct isci_remote_device *isci_device =3D isci_dev_from_domain_dev(
-		domain_dev);
+	struct isci_host *ihost =3D dev->port->ha->lldd_ha;
+	struct isci_remote_device *idev =3D dev->lldd_dev;
=20
-	dev_err(&isci_device->isci_port->isci_host->pdev->dev,
+	dev_dbg(&ihost->pdev->dev,
 		"%s: domain_device =3D %p, isci_device =3D %p, isci_port =3D %p\n",
-		__func__, domain_dev, isci_device, isci_device->isci_port);
+		__func__, dev, idev, idev->isci_port);
=20
-	if (isci_device !=3D NULL)
-		isci_remote_device_stop(isci_device);
+	isci_remote_device_stop(ihost, idev);
 }
=20
=20
@@ -492,7 +433,6 @@ void isci_remote_device_gone(
  */
 int isci_remote_device_found(struct domain_device *domain_dev)
 {
-	unsigned long flags;
 	struct isci_host *isci_host;
 	struct isci_port *isci_port;
 	struct isci_phy *isci_phy;
@@ -500,7 +440,6 @@ int isci_remote_device_found(struct domain_device *=
domain_dev)
 	struct asd_sas_phy *sas_phy;
 	struct isci_remote_device *isci_device;
 	enum sci_status status;
-	DECLARE_COMPLETION_ONSTACK(completion);
=20
 	isci_host =3D isci_host_from_sas_ha(domain_dev->port->ha);
=20
@@ -525,6 +464,8 @@ int isci_remote_device_found(struct domain_device *=
domain_dev)
 		return -ENODEV;
=20
 	isci_device =3D isci_remote_device_alloc(isci_host, isci_port);
+	if (!isci_device)
+		return -ENODEV;
=20
 	INIT_LIST_HEAD(&isci_device->node);
 	domain_dev->lldd_dev =3D isci_device;
@@ -533,19 +474,12 @@ int isci_remote_device_found(struct domain_device=
 *domain_dev)
 	isci_remote_device_change_state(isci_device, isci_starting);
=20
=20
-	spin_lock_irqsave(&isci_port->remote_device_lock, flags);
+	spin_lock_irq(&isci_host->scic_lock);
 	list_add_tail(&isci_device->node, &isci_port->remote_dev_list);
=20
-	/* for the device ready event. */
-	isci_device->completion =3D &completion;
-
+	set_bit(IDEV_START_PENDING, &isci_device->flags);
 	status =3D isci_remote_device_construct(isci_port, isci_device);
-
-	spin_unlock_irqrestore(&isci_port->remote_device_lock, flags);
-
-	/* wait for the device ready callback. */
-	wait_for_completion(isci_device->completion);
-	isci_device->completion =3D NULL;
+	spin_unlock_irq(&isci_host->scic_lock);
=20
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: isci_device =3D %p\n",
@@ -553,15 +487,18 @@ int isci_remote_device_found(struct domain_device=
 *domain_dev)
=20
 	if (status !=3D SCI_SUCCESS) {
=20
-		spin_lock_irqsave(&isci_port->remote_device_lock, flags);
+		spin_lock_irq(&isci_host->scic_lock);
 		isci_remote_device_deconstruct(
 			isci_host,
 			isci_device
 			);
-		spin_unlock_irqrestore(&isci_port->remote_device_lock, flags);
+		spin_unlock_irq(&isci_host->scic_lock);
 		return -ENODEV;
 	}
=20
+	/* wait for the device ready callback. */
+	wait_for_device_start(isci_host, isci_device);
+
 	return 0;
 }
 /**
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remo=
te_device.h
index a208f81..f45a5f0 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -55,25 +55,29 @@
=20
 #if !defined(_ISCI_REMOTE_DEVICE_H_)
 #define _ISCI_REMOTE_DEVICE_H_
-#include "scic_user_callback.h"
=20
 struct isci_host;
 struct scic_sds_remote_device;
=20
 struct isci_remote_device {
-	struct scic_sds_remote_device *sci_device_handle;
 	enum isci_status status;
+	#define IDEV_START_PENDING 0
+	#define IDEV_STOP_PENDING 1
+	#define IDEV_ALLOCATED 2
+	unsigned long flags;
 	struct isci_port *isci_port;
 	struct domain_device *domain_dev;
-	struct completion *completion;
 	struct list_head node;
 	struct list_head reqs_in_process;
-	struct work_struct stop_work;
 	spinlock_t state_lock;
-	spinlock_t host_quiesce_lock;
-	bool host_quiesce;
 };
=20
+static inline struct scic_sds_remote_device *to_sci_dev(struct isci_re=
mote_device *idev)
+{
+	/* core data is an opaque buffer at the end of the idev */
+	return (struct scic_sds_remote_device *) &idev[1];
+}
+
 #define to_isci_remote_device(p)	\
 	container_of(p, struct isci_remote_device, sci_remote_device);
=20
@@ -81,22 +85,6 @@ struct isci_remote_device {
=20
=20
 /**
- * This function gets the status of the remote_device object.
- * @isci_device: This parameter points to the isci_remote_device objec=
t
- *
- * status of the object as a isci_status enum.
- */
-static inline
-enum isci_status isci_remote_device_get_state(
-	struct isci_remote_device *isci_device)
-{
-	return (isci_device->host_quiesce)
-	       ? isci_host_quiesce
-	       : isci_device->status;
-}
-
-
-/**
  * isci_dev_from_domain_dev() - This accessor retrieves the remote_dev=
ice
  *    object reference from the Linux domain_device reference.
  * @domdev,: This parameter points to the Linux domain_device object .
@@ -116,9 +104,8 @@ void isci_remote_device_stop_complete(
 	struct isci_remote_device *,
 	enum sci_status);
=20
-enum sci_status isci_remote_device_stop(
-	struct isci_remote_device *isci_device);
-
+enum sci_status isci_remote_device_stop(struct isci_host *ihost,
+					struct isci_remote_device *idev);
 void isci_remote_device_nuke_requests(
 	struct isci_remote_device *isci_device);
=20
@@ -142,10 +129,6 @@ bool isci_device_is_reset_pending(
 void isci_device_clear_reset_pending(
 	struct isci_remote_device *isci_device);
=20
-void isci_device_set_host_quiesce_lock_state(
-	struct isci_remote_device *isci_device,
-	bool lock_state);
-
 void isci_remote_device_change_state(
 	struct isci_remote_device *isci_device,
 	enum isci_status status);
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 81a7733..0156431 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -179,8 +179,7 @@ static enum sci_status isci_io_request_build(
 	struct smp_discover_response_protocols dev_protocols;
 	enum sci_status status =3D SCI_SUCCESS;
 	struct sas_task *task =3D isci_request_access_task(request);
-	struct scic_sds_remote_device *sci_device =3D
-		isci_device->sci_device_handle;
+	struct scic_sds_remote_device *sci_device =3D to_sci_dev(isci_device)=
;
=20
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: isci_device =3D 0x%p; request =3D %p, "
@@ -408,7 +407,7 @@ int isci_request_execute(
 	unsigned long flags;
=20
 	isci_device =3D isci_dev_from_domain_dev(task->dev);
-	sci_device =3D isci_device->sci_device_handle;
+	sci_device =3D to_sci_dev(isci_device);
=20
 	/* do common allocation and init of request object. */
 	ret =3D isci_request_alloc_io(
@@ -464,6 +463,12 @@ int isci_request_execute(
 				 */
 				status =3D SCI_SUCCESS;
 			}
+			else
+				/* Save the tag for possible task mgmt later. */
+				request->io_tag =3D scic_io_request_get_io_tag(
+						     request->sci_request_handle);
+
+
 		} else
 			dev_warn(&isci_host->pdev->dev,
 				 "%s: failed request start\n",
@@ -791,9 +796,9 @@ static void isci_task_save_for_upper_layer_completi=
on(
 {
 	struct sas_task *task =3D isci_request_access_task(request);
=20
-	isci_task_set_completion_status(task, response, status,
-					 task_notification_selection);
-
+	task_notification_selection
+		=3D isci_task_set_completion_status(task, response, status,
+						  task_notification_selection);
=20
 	/* Tasks aborted specifically by a call to the lldd_abort_task
 	 * function should not be completed to the host in the regular path.
@@ -804,53 +809,68 @@ static void isci_task_save_for_upper_layer_comple=
tion(
=20
 		/* Normal notification (task_done) */
 		dev_dbg(&host->pdev->dev,
-			"%s: Normal - task =3D %p, response=3D%d, status=3D%d\n",
+			"%s: Normal - task =3D %p, response=3D%d (%d), status=3D%d (%d)\n",
 			__func__,
 			task,
-			response,
-			status);
+			task->task_status.resp, response,
+			task->task_status.stat, status);
 		/* Add to the completed list. */
 		list_add(&request->completed_node,
 			 &host->requests_to_complete);
+
+		/* Take the request off the device's pending request list. */
+		list_del_init(&request->dev_node);
 		break;
=20
 	case isci_perform_aborted_io_completion:
-		/*
-		 * No notification because this request is already
-		 * in the abort path.
+		/* No notification to libsas because this request is
+		 * already in the abort path.
 		 */
 		dev_warn(&host->pdev->dev,
-			 "%s: Aborted - task =3D %p, response=3D%d, status=3D%d\n",
+			 "%s: Aborted - task =3D %p, response=3D%d (%d), status=3D%d (%d)\n=
",
 			 __func__,
 			 task,
-			 response,
-			 status);
+			 task->task_status.resp, response,
+			 task->task_status.stat, status);
+
+		/* Wake up whatever process was waiting for this
+		 * request to complete.
+		 */
+		WARN_ON(request->io_request_completion =3D=3D NULL);
+
+		if (request->io_request_completion !=3D NULL) {
+
+			/* Signal whoever is waiting that this
+			* request is complete.
+			*/
+			complete(request->io_request_completion);
+		}
 		break;
=20
 	case isci_perform_error_io_completion:
 		/* Use sas_task_abort */
 		dev_warn(&host->pdev->dev,
-			 "%s: Error - task =3D %p, response=3D%d, status=3D%d\n",
+			 "%s: Error - task =3D %p, response=3D%d (%d), status=3D%d (%d)\n",
 			 __func__,
 			 task,
-			 response,
-			 status);
+			 task->task_status.resp, response,
+			 task->task_status.stat, status);
 		/* Add to the aborted list. */
 		list_add(&request->completed_node,
-			 &host->requests_to_abort);
+			 &host->requests_to_errorback);
 		break;
=20
 	default:
 		dev_warn(&host->pdev->dev,
-			 "%s: Unknown - task =3D %p, response=3D%d, status=3D%d\n",
+			 "%s: Unknown - task =3D %p, response=3D%d (%d), status=3D%d (%d)\n=
",
 			 __func__,
 			 task,
-			 response,
-			 status);
+			 task->task_status.resp, response,
+			 task->task_status.stat, status);
=20
-		/* Add to the aborted list. */
+		/* Add to the error to libsas list. */
 		list_add(&request->completed_node,
-			 &host->requests_to_abort);
+			 &host->requests_to_errorback);
 		break;
 	}
 }
@@ -874,8 +894,6 @@ void isci_request_io_request_complete(
 	struct ssp_response_iu *resp_iu;
 	void *resp_buf;
 	unsigned long task_flags;
-	unsigned long state_flags;
-	struct completion *io_request_completion;
 	struct isci_remote_device *isci_device   =3D request->isci_device;
 	enum service_response response       =3D SAS_TASK_UNDELIVERED;
 	enum exec_status status         =3D SAS_ABORTED_TASK;
@@ -892,9 +910,8 @@ void isci_request_io_request_complete(
 		task->data_dir,
 		completion_status);
=20
-	spin_lock_irqsave(&request->state_lock, state_flags);
+	spin_lock(&request->state_lock);
 	request_status =3D isci_request_get_state(request);
-	spin_unlock_irqrestore(&request->state_lock, state_flags);
=20
 	/* Decode the request status.  Note that if the request has been
 	 * aborted by a task management function, we don't care
@@ -929,6 +946,8 @@ void isci_request_io_request_complete(
=20
 		complete_to_host =3D isci_perform_aborted_io_completion;
 		/* This was an aborted request. */
+
+		spin_unlock(&request->state_lock);
 		break;
=20
 	case aborting:
@@ -956,6 +975,8 @@ void isci_request_io_request_complete(
 		complete_to_host =3D isci_perform_aborted_io_completion;
=20
 		/* This was an aborted request. */
+
+		spin_unlock(&request->state_lock);
 		break;
=20
 	case terminating:
@@ -978,13 +999,20 @@ void isci_request_io_request_complete(
 		else
 			status =3D SAS_ABORTED_TASK;
=20
-		complete_to_host =3D isci_perform_normal_io_completion;
+		complete_to_host =3D isci_perform_aborted_io_completion;
=20
 		/* This was a terminated request. */
+
+		spin_unlock(&request->state_lock);
 		break;
=20
 	default:
=20
+		/* The request is done from an SCU HW perspective. */
+		request->status =3D completed;
+
+		spin_unlock(&request->state_lock);
+
 		/* This is an active request being completed from the core. */
 		switch (completion_status) {
=20
@@ -1137,6 +1165,10 @@ void isci_request_io_request_complete(
 			task->task_state_flags |=3D SAS_TASK_NEED_DEV_RESET;
 			spin_unlock_irqrestore(&task->task_state_lock, task_flags);
=20
+			/* Fail the I/O. */
+			response =3D SAS_TASK_UNDELIVERED;
+			status =3D SAM_STAT_TASK_ABORTED;
+
 			complete_to_host =3D isci_perform_error_io_completion;
 			request->complete_in_target =3D false;
 			break;
@@ -1177,7 +1209,7 @@ void isci_request_io_request_complete(
 	/* complete the io request to the core. */
 	scic_controller_complete_io(
 		isci_host->core_controller,
-		isci_device->sci_device_handle,
+		to_sci_dev(isci_device),
 		request->sci_request_handle
 		);
 	/* NULL the request handle so it cannot be completed or
@@ -1186,28 +1218,6 @@ void isci_request_io_request_complete(
 	 */
 	request->sci_request_handle =3D NULL;
=20
-	/* Only remove the request from the remote device list
-	 * of pending requests if we have not requested error
-	 * handling on this request.
-	 */
-	if (complete_to_host !=3D isci_perform_error_io_completion)
-		list_del_init(&request->dev_node);
-
-
-	/* Save possible completion ptr. */
-	io_request_completion =3D request->io_request_completion;
-
-	if (io_request_completion) {
-
-		/* This is inherantly a regular I/O request,
-		 * since we are currently in the regular
-		 * I/O completion callback function.
-		 * Signal whoever is waiting that this
-		 * request is complete.
-		 */
-		complete(io_request_completion);
-	}
-
 	isci_host_can_dequeue(isci_host, 1);
 }
=20
diff --git a/drivers/scsi/isci/request.h b/drivers/scsi/isci/request.h
index 166295e..b45c0f1 100644
--- a/drivers/scsi/isci/request.h
+++ b/drivers/scsi/isci/request.h
@@ -71,7 +71,8 @@ enum isci_request_status {
 	completed   =3D 0x03,
 	aborting    =3D 0x04,
 	aborted     =3D 0x05,
-	terminating =3D 0x06
+	terminating =3D 0x06,
+	dead        =3D 0x07
 };
=20
 enum task_type {
diff --git a/drivers/scsi/isci/sata.c b/drivers/scsi/isci/sata.c
index 19b0eea..7a1b586 100644
--- a/drivers/scsi/isci/sata.c
+++ b/drivers/scsi/isci/sata.c
@@ -324,7 +324,7 @@ int isci_task_send_lu_reset_sata(
=20
 	/* Leave SRST high for a bit. */
 	#define ISCI_SRST_ASSERT_DELAY 100 /* usecs */
-	scic_cb_stall_execution(ISCI_SRST_ASSERT_DELAY);
+	udelay(ISCI_SRST_ASSERT_DELAY);
=20
 	/* Deassert SRST. */
 	isci_task_build_tmf(&tmf, isci_device, isci_tmf_sata_srst_low,
@@ -348,7 +348,7 @@ int isci_task_send_lu_reset_sata(
 	spin_lock_irqsave(&isci_host->scic_lock, flags);
=20
 	/* Resume the device. */
-	scic_sds_remote_device_resume(isci_device->sci_device_handle);
+	scic_sds_remote_device_resume(to_sci_dev(isci_device));
=20
 	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
=20
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 6f98f6c..d00b4c9 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -54,6 +54,8 @@
  */
=20
 #include <linux/completion.h>
+#include <linux/irqflags.h>
+#include <scsi/sas_ata.h>
 #include "scic_task_request.h"
 #include "scic_remote_device.h"
 #include "scic_io_request.h"
@@ -64,6 +66,91 @@
 #include "sata.h"
 #include "task.h"
=20
+/**
+* isci_task_complete_for_upper_layer() - This function completes the r=
equest
+*    to the upper layer driver in the case where an I/O needs to be co=
mpleted
+*    back in the submit path.
+* @host: This parameter is a pointer to the host on which the the requ=
est
+*    should be queued (either as an error or success).
+* @task: This parameter is the completed request.
+* @response: This parameter is the response code for the completed tas=
k.
+* @status: This parameter is the status code for the completed task.
+*
+* none.
+*/
+static void isci_task_complete_for_upper_layer(struct sas_task *task,
+					       enum service_response response,
+					       enum exec_status status,
+					       enum isci_completion_selection task_notification_selection=
)
+{
+	unsigned long    flags =3D 0;
+	struct Scsi_Host *host =3D NULL;
+
+	task_notification_selection
+		=3D isci_task_set_completion_status(task, response, status,
+						  task_notification_selection);
+
+	/* Tasks aborted specifically by a call to the lldd_abort_task
+	* function should not be completed to the host in the regular path.
+	*/
+	switch (task_notification_selection) {
+		case isci_perform_normal_io_completion:
+			/* Normal notification (task_done) */
+			dev_dbg(task->dev->port->ha->dev,
+				"%s: Normal - task =3D %p, response=3D%d, status=3D%d\n",
+				__func__, task, response, status);
+
+			if (dev_is_sata(task->dev)) {
+				/* Since we are still in the submit path, and since
+				* libsas takes the host lock on behalf of SATA
+				* devices before I/O starts, we need to unlock
+				* before we can call back and report the I/O
+				* submission error.
+				*/
+				if (task->dev
+				    && task->dev->port
+				    && task->dev->port->ha) {
+
+					host =3D task->dev->port->ha->core.shost;
+					raw_local_irq_save(flags);
+					spin_unlock(host->host_lock);
+				}
+				task->task_done(task);
+				if (host) {
+					spin_lock(host->host_lock);
+					raw_local_irq_restore(flags);
+				}
+			} else
+				task->task_done(task);
+
+			task->lldd_task =3D NULL;
+			break;
+
+		case isci_perform_aborted_io_completion:
+			/* No notification because this request is already in the
+			* abort path.
+			*/
+			dev_warn(task->dev->port->ha->dev,
+				 "%s: Aborted - task =3D %p, response=3D%d, status=3D%d\n",
+				 __func__, task, response, status);
+			break;
+
+		case isci_perform_error_io_completion:
+			/* Use sas_task_abort */
+			dev_warn(task->dev->port->ha->dev,
+				 "%s: Error - task =3D %p, response=3D%d, status=3D%d\n",
+				 __func__, task, response, status);
+			sas_task_abort(task);
+			break;
+
+		default:
+			dev_warn(task->dev->port->ha->dev,
+				 "%s: isci task notification default case!",
+				 __func__);
+			sas_task_abort(task);
+			break;
+	}
+}
=20
 /**
  * isci_task_execute_task() - This function is one of the SAS Domain T=
emplate
@@ -81,24 +168,12 @@ int isci_task_execute_task(struct sas_task *task, =
int num, gfp_t gfp_flags)
 	struct isci_request *request =3D NULL;
 	struct isci_remote_device *device;
 	unsigned long flags;
-	unsigned long quiesce_flags =3D 0;
 	int ret;
 	enum sci_status status;
-
+	enum isci_status device_status;
=20
 	dev_dbg(task->dev->port->ha->dev, "%s: num=3D%d\n", __func__, num);
=20
-	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
-
-		isci_task_complete_for_upper_layer(
-			task,
-			SAS_TASK_UNDELIVERED,
-			SAM_STAT_TASK_ABORTED,
-			isci_perform_normal_io_completion
-			);
-
-		return 0;  /* The I/O was accepted (and failed). */
-	}
 	if ((task->dev =3D=3D NULL) || (task->dev->port =3D=3D NULL)) {
=20
 		/* Indicate SAS_TASK_UNDELIVERED, so that the scsi midlayer
@@ -144,114 +219,105 @@ int isci_task_execute_task(struct sas_task *tas=
k, int num, gfp_t gfp_flags)
 			/* We don't have a valid host reference, so we
 			 * can't control the host queueing condition.
 			 */
-			continue;
+			goto next_task;
 		}
=20
 		device =3D isci_dev_from_domain_dev(task->dev);
=20
 		isci_host =3D isci_host_from_sas_ha(task->dev->port->ha);
=20
-		/* check if the controller hasn't started or if the device
-		 * is ready but not accepting IO.
-		 */
-		if (device) {
+		if (device)
+			device_status =3D device->status;
+		else
+			device_status =3D isci_freed;
=20
-			spin_lock_irqsave(&device->host_quiesce_lock,
-					  quiesce_flags);
-		}
 		/* From this point onward, any process that needs to guarantee
 		 * that there is no kernel I/O being started will have to wait
 		 * for the quiesce spinlock.
 		 */
=20
-		if ((device && ((isci_remote_device_get_state(device) =3D=3D isci_re=
ady) ||
-		    (isci_remote_device_get_state(device) =3D=3D isci_host_quiesce))=
)) {
+		if (device_status !=3D isci_ready_for_io) {
=20
 			/* Forces a retry from scsi mid layer. */
 			dev_warn(task->dev->port->ha->dev,
 				 "%s: task %p: isci_host->status =3D %d, "
-				 "device =3D %p\n",
+				 "device =3D %p; device_status =3D 0x%x\n\n",
 				 __func__,
 				 task,
 				 isci_host_get_state(isci_host),
-				 device);
-
-			if (device)
-				dev_dbg(task->dev->port->ha->dev,
-					"%s: device->status =3D 0x%x\n",
-					__func__,
-					isci_remote_device_get_state(device));
+				 device, device_status);
=20
-			/* Indicate QUEUE_FULL so that the scsi midlayer
-			 * retries.
-			 */
-			isci_task_complete_for_upper_layer(
-				task,
-				SAS_TASK_COMPLETE,
-				SAS_QUEUE_FULL,
-				isci_perform_normal_io_completion
-				);
+			if (device_status =3D=3D isci_ready) {
+				/* Indicate QUEUE_FULL so that the scsi midlayer
+				* retries.
+				*/
+				isci_task_complete_for_upper_layer(
+					task,
+					SAS_TASK_COMPLETE,
+					SAS_QUEUE_FULL,
+					isci_perform_normal_io_completion
+					);
+			} else {
+				/* Else, the device is going down. */
+				isci_task_complete_for_upper_layer(
+					task,
+					SAS_TASK_UNDELIVERED,
+					SAS_DEVICE_UNKNOWN,
+					isci_perform_normal_io_completion
+					);
+			}
 			isci_host_can_dequeue(isci_host, 1);
-		}
-		/* the device is going down... */
-		else if (!device || (isci_ready_for_io !=3D isci_remote_device_get_s=
tate(device))) {
+		} else {
+			/* There is a device and it's ready for I/O. */
+			spin_lock_irqsave(&task->task_state_lock, flags);
=20
-			dev_dbg(task->dev->port->ha->dev,
-				"%s: task %p: isci_host->status =3D %d, "
-				"device =3D %p\n",
-				__func__,
-				task,
-				isci_host_get_state(isci_host),
-				device);
+			if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
=20
-			if (device)
-				dev_dbg(task->dev->port->ha->dev,
-					"%s: device->status =3D 0x%x\n",
-					__func__,
-					isci_remote_device_get_state(device));
+				spin_unlock_irqrestore(&task->task_state_lock,
+						       flags);
=20
-			/* Indicate SAS_TASK_UNDELIVERED, so that the scsi
-			 * midlayer removes the target.
-			 */
-			isci_task_complete_for_upper_layer(
-				task,
-				SAS_TASK_UNDELIVERED,
-				SAS_DEVICE_UNKNOWN,
-				isci_perform_normal_io_completion
-				);
-			isci_host_can_dequeue(isci_host, 1);
+				isci_task_complete_for_upper_layer(
+					task,
+					SAS_TASK_UNDELIVERED,
+					SAM_STAT_TASK_ABORTED,
+					isci_perform_normal_io_completion
+					);
=20
-		} else {
-			/* build and send the request. */
-			status =3D isci_request_execute(isci_host, task, &request,
-						      gfp_flags);
+				/* The I/O was aborted. */
=20
-			if (status =3D=3D SCI_SUCCESS) {
-				spin_lock_irqsave(&task->task_state_lock, flags);
+			} else {
 				task->task_state_flags |=3D SAS_TASK_AT_INITIATOR;
 				spin_unlock_irqrestore(&task->task_state_lock, flags);
-			} else {
-				/* Indicate QUEUE_FULL so that the scsi
-				 * midlayer retries. if the request
-				 * failed for remote device reasons,
-				 * it gets returned as
-				 * SAS_TASK_UNDELIVERED next time
-				 * through.
-				 */
-				isci_task_complete_for_upper_layer(
+
+				/* build and send the request. */
+				status =3D isci_request_execute(isci_host, task, &request,
+							      gfp_flags);
+
+				if (status !=3D SCI_SUCCESS) {
+
+					spin_lock_irqsave(&task->task_state_lock, flags);
+					/* Did not really start this command. */
+					task->task_state_flags &=3D ~SAS_TASK_AT_INITIATOR;
+					spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+					/* Indicate QUEUE_FULL so that the scsi
+					* midlayer retries. if the request
+					* failed for remote device reasons,
+					* it gets returned as
+					* SAS_TASK_UNDELIVERED next time
+					* through.
+					*/
+					isci_task_complete_for_upper_layer(
 						task,
 						SAS_TASK_COMPLETE,
 						SAS_QUEUE_FULL,
 						isci_perform_normal_io_completion
 						);
-				isci_host_can_dequeue(isci_host, 1);
+					isci_host_can_dequeue(isci_host, 1);
+				}
 			}
 		}
-		if (device) {
-			spin_unlock_irqrestore(&device->host_quiesce_lock,
-					       quiesce_flags
-					       );
-		}
+next_task:
 		task =3D list_entry(task->list.next, struct sas_task, list);
 	} while (--num > 0);
 	return 0;
@@ -285,7 +351,7 @@ static enum sci_status isci_task_request_build(
 		"%s: isci_tmf =3D %p\n", __func__, isci_tmf);
=20
 	isci_device =3D isci_tmf->device;
-	sci_device =3D isci_device->sci_device_handle;
+	sci_device =3D to_sci_dev(isci_device);
=20
 	/* do common allocation and init of request object. */
 	status =3D isci_request_alloc_tmf(
@@ -395,7 +461,7 @@ static void isci_tmf_timeout_cb(void *tmf_request_a=
rg)
 		/* Terminate the TMF transmit request. */
 		status =3D scic_controller_terminate_request(
 			request->isci_host->core_controller,
-			request->isci_device->sci_device_handle,
+			to_sci_dev(request->isci_device),
 			request->sci_request_handle
 			);
=20
@@ -442,21 +508,18 @@ int isci_task_execute_tmf(
 	/* sanity check, return TMF_RESP_FUNC_FAILED
 	 * if the device is not there and ready.
 	 */
-	if (!isci_device ||
-	    ((isci_ready_for_io !=3D isci_remote_device_get_state(isci_device=
)) &&
-	    (isci_host_quiesce !=3D isci_remote_device_get_state(isci_device)=
))) {
+	if (!isci_device || isci_device->status !=3D isci_ready_for_io) {
 		dev_dbg(&isci_host->pdev->dev,
 			"%s: isci_device =3D %p not ready (%d)\n",
 			__func__,
-			isci_device,
-			isci_remote_device_get_state(isci_device));
+			isci_device, isci_device->status);
 		return TMF_RESP_FUNC_FAILED;
 	} else
 		dev_dbg(&isci_host->pdev->dev,
 			"%s: isci_device =3D %p\n",
 			__func__, isci_device);
=20
-	sci_device =3D isci_device->sci_device_handle;
+	sci_device =3D to_sci_dev(isci_device);
=20
 	/* Assign the pointer to the TMF's completion kernel wait structure. =
*/
 	tmf->complete =3D &completion;
@@ -475,14 +538,8 @@ int isci_task_execute_tmf(
 	}
=20
 	/* Allocate the TMF timeout timer. */
-	tmf->timeout_timer =3D isci_timer_create(
-		&isci_host->timer_list_struct,
-		isci_host,
-		request,
-		isci_tmf_timeout_cb
-		);
-
 	spin_lock_irqsave(&isci_host->scic_lock, flags);
+	tmf->timeout_timer =3D isci_timer_create(isci_host, request, isci_tmf=
_timeout_cb);
=20
 	/* Start the timer. */
 	if (tmf->timeout_timer)
@@ -557,9 +614,7 @@ int isci_task_execute_tmf(
=20
 	/* Clean up the timer if needed. */
 	if (tmf->timeout_timer) {
-		isci_timer_stop(tmf->timeout_timer);
-		isci_timer_free(&isci_host->timer_list_struct,
-				tmf->timeout_timer);
+		isci_del_timer(isci_host, tmf->timeout_timer);
 		tmf->timeout_timer =3D NULL;
 	}
=20
@@ -591,6 +646,20 @@ void isci_task_build_tmf(
 	tmf->cb_data       =3D cb_data;
 }
=20
+void isci_task_build_abort_task_tmf(
+	struct isci_tmf *tmf,
+	struct isci_remote_device *isci_device,
+	enum isci_tmf_function_codes code,
+	void (*tmf_sent_cb)(enum isci_tmf_cb_state,
+			    struct isci_tmf *,
+			    void *),
+	struct isci_request *old_request)
+{
+	isci_task_build_tmf(tmf, isci_device, code, tmf_sent_cb,
+			    (void *)old_request);
+	tmf->io_tag =3D old_request->io_tag;
+}
+
 static struct isci_request *isci_task_get_request_from_task(
 	struct sas_task *task,
 	struct isci_host **isci_host,
@@ -651,9 +720,6 @@ static enum isci_request_status isci_task_validate_=
request_to_abort(
 		old_state =3D isci_request_change_started_to_aborted(
 			isci_request, aborted_io_completion);
=20
-		/* Only abort requests in the started state. */
-		if (old_state !=3D started)
-			old_state =3D unallocated;
 	}
=20
 	return old_state;
@@ -664,22 +730,91 @@ static void isci_request_cleanup_completed_loiter=
er(
 	struct isci_remote_device *isci_device,
 	struct isci_request *isci_request)
 {
-	struct sas_task *task =3D isci_request_access_task(isci_request);
-	unsigned long flags;
+	struct sas_task     *task;
+	unsigned long       flags;
+
+	task =3D (isci_request->ttype =3D=3D io_task)
+		? isci_request_access_task(isci_request)
+		: NULL;
=20
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: isci_device=3D%p, request=3D%p, task=3D%p\n",
-		__func__, isci_device, isci_request,
-		isci_request->ttype_ptr.io_task_ptr);
+		__func__, isci_device, isci_request, task);
=20
 	spin_lock_irqsave(&isci_host->scic_lock, flags);
 	list_del_init(&isci_request->dev_node);
-	if (task !=3D NULL)
-		task->lldd_task =3D NULL;
 	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
=20
+	if (task !=3D NULL) {
+
+		spin_lock_irqsave(&task->task_state_lock, flags);
+		task->lldd_task =3D NULL;
+
+		isci_set_task_doneflags(task);
+
+		/* If this task is not in the abort path, call task_done. */
+		if (!(task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
+			task->task_done(task);
+		} else
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
+	}
 	isci_request_free(isci_host, isci_request);
 }
+
+/**
+* @isci_termination_timed_out(): this function will deal with a reques=
t for
+* which the wait for termination has timed-out.
+*
+* @isci_host    This SCU.
+* @isci_request The I/O request being terminated.
+*/
+static void
+isci_termination_timed_out(
+	struct isci_host    * host,
+	struct isci_request * request
+	)
+{
+	unsigned long state_flags;
+
+	dev_warn(&host->pdev->dev,
+		"%s: host =3D %p; request =3D %p\n",
+		__func__, host, request);
+
+	/* At this point, the request to terminate
+	* has timed out. The best we can do is to
+	* have the request die a silent death
+	* if it ever completes.
+	*/
+	spin_lock_irqsave(&request->state_lock, state_flags);
+
+	if (request->status =3D=3D started) {
+
+		/* Set the request state to "dead",
+		* and clear the task pointer so that an actual
+		* completion event callback doesn't do
+		* anything.
+		*/
+		request->status =3D dead;
+
+		/* Clear the timeout completion event pointer.*/
+		request->io_request_completion =3D NULL;
+
+		if (request->ttype =3D=3D io_task) {
+
+			/* Break links with the sas_task. */
+			if (request->ttype_ptr.io_task_ptr !=3D NULL) {
+
+				request->ttype_ptr.io_task_ptr->lldd_task =3D NULL;
+				request->ttype_ptr.io_task_ptr            =3D NULL;
+			}
+		}
+	}
+	spin_unlock_irqrestore(&request->state_lock, state_flags);
+}
+
+
 /**
  * isci_terminate_request_core() - This function will terminate the gi=
ven
  *    request, and wait for it to complete.  This function must only b=
e called
@@ -694,49 +829,37 @@ static void isci_request_cleanup_completed_loiter=
er(
 static void isci_terminate_request_core(
 	struct isci_host *isci_host,
 	struct isci_remote_device *isci_device,
-	struct isci_request *isci_request,
-	struct completion *request_completion)
+	struct isci_request *isci_request)
 {
-	enum sci_status status                 =3D SCI_SUCCESS;
+	enum sci_status status      =3D SCI_SUCCESS;
 	bool was_terminated         =3D false;
 	bool needs_cleanup_handling =3D false;
 	enum isci_request_status request_status;
 	unsigned long flags;
+	unsigned long timeout_remaining;
+
=20
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: device =3D %p; request =3D %p\n",
 		__func__, isci_device, isci_request);
=20
-	/* Peek at the current status of the request.  This will tell
-	 * us if there was special handling on the request such that it
-	 * needs to be detached and freed here.
-	 */
-	spin_lock_irqsave(&isci_request->state_lock, flags);
-	request_status =3D isci_request_get_state(isci_request);
-
-	/* TMFs are in their own thread */
-	if ((isci_request->ttype =3D=3D io_task) &&
-	    ((request_status =3D=3D aborted) ||
-	     (request_status =3D=3D aborting) ||
-	     (request_status =3D=3D terminating)))
-		/* The completion routine won't free a request in
-		 * the aborted/aborting/terminating state, so we do
-		 * it here.
-		 */
-		needs_cleanup_handling =3D true;
+	spin_lock_irqsave(&isci_host->scic_lock, flags);
=20
-	spin_unlock_irqrestore(&isci_request->state_lock, flags);
+	/* Note that we are not going to control
+	* the target to abort the request.
+	*/
+	isci_request->complete_in_target =3D true;
=20
-	spin_lock_irqsave(&isci_host->scic_lock, flags);
 	/* Make sure the request wasn't just sitting around signalling
 	 * device condition (if the request handle is NULL, then the
 	 * request completed but needed additional handling here).
 	 */
 	if (isci_request->sci_request_handle !=3D NULL) {
 		was_terminated =3D true;
+		needs_cleanup_handling =3D true;
 		status =3D scic_controller_terminate_request(
 			isci_host->core_controller,
-			isci_device->sci_device_handle,
+			to_sci_dev(isci_device),
 			isci_request->sci_request_handle
 			);
 	}
@@ -747,27 +870,73 @@ static void isci_terminate_request_core(
 	 * fail is when the io request is completed and
 	 * being aborted.
 	 */
-	if (status !=3D SCI_SUCCESS)
+	if (status !=3D SCI_SUCCESS) {
 		dev_err(&isci_host->pdev->dev,
 			"%s: scic_controller_terminate_request"
 			" returned =3D 0x%x\n",
 			__func__,
 			status);
-	else {
+		/* Clear the completion pointer from the request. */
+		isci_request->io_request_completion =3D NULL;
+
+	} else {
 		if (was_terminated) {
 			dev_dbg(&isci_host->pdev->dev,
 				"%s: before completion wait (%p)\n",
 				__func__,
-				request_completion);
+				isci_request->io_request_completion);
=20
 			/* Wait here for the request to complete. */
-			wait_for_completion(request_completion);
+			#define TERMINATION_TIMEOUT_MSEC 50
+			timeout_remaining
+				=3D wait_for_completion_timeout(
+				   isci_request->io_request_completion,
+				   msecs_to_jiffies(TERMINATION_TIMEOUT_MSEC));
=20
-			dev_dbg(&isci_host->pdev->dev,
-				"%s: after completion wait (%p)\n",
-				__func__,
-				request_completion);
+			if (!timeout_remaining) {
+
+				isci_termination_timed_out(isci_host,
+							   isci_request);
+
+				dev_err(&isci_host->pdev->dev,
+					"%s: *** Timeout waiting for "
+					"termination(%p/%p)\n",
+					__func__,
+					isci_request->io_request_completion,
+					isci_request);
+
+			} else
+				dev_dbg(&isci_host->pdev->dev,
+					"%s: after completion wait (%p)\n",
+					__func__,
+					isci_request->io_request_completion);
+		}
+		/* Clear the completion pointer from the request. */
+		isci_request->io_request_completion =3D NULL;
+
+		/* Peek at the status of the request.  This will tell
+		* us if there was special handling on the request such that it
+		* needs to be detached and freed here.
+		*/
+		spin_lock_irqsave(&isci_request->state_lock, flags);
+		request_status =3D isci_request_get_state(isci_request);
+
+		if ((isci_request->ttype =3D=3D io_task) /* TMFs are in their own th=
read */
+		    && ((request_status =3D=3D aborted)
+			|| (request_status =3D=3D aborting)
+			|| (request_status =3D=3D terminating)
+			|| (request_status =3D=3D completed)
+			|| (request_status =3D=3D dead)
+			)
+		    ) {
+
+			/* The completion routine won't free a request in
+			* the aborted/aborting/etc. states, so we do
+			* it here.
+			*/
+			needs_cleanup_handling =3D true;
 		}
+		spin_unlock_irqrestore(&isci_request->state_lock, flags);
=20
 		if (needs_cleanup_handling)
 			isci_request_cleanup_completed_loiterer(
@@ -775,6 +944,7 @@ static void isci_terminate_request_core(
 				);
 	}
 }
+
 static void isci_terminate_request(
 	struct isci_host *isci_host,
 	struct isci_remote_device *isci_device,
@@ -782,11 +952,7 @@ static void isci_terminate_request(
 	enum isci_request_status new_request_state)
 {
 	enum isci_request_status old_state;
-
 	DECLARE_COMPLETION_ONSTACK(request_completion);
-	unsigned long flags;
-
-	spin_lock_irqsave(&isci_host->scic_lock, flags);
=20
 	/* Change state to "new_request_state" if it is currently "started" *=
/
 	old_state =3D isci_request_change_started_to_newstate(
@@ -795,10 +961,10 @@ static void isci_terminate_request(
 		new_request_state
 		);
=20
-	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+	if ((old_state =3D=3D started) || (old_state =3D=3D completed)) {
=20
-	if (old_state =3D=3D started)
-		/* This request was not already being aborted. If it had been,
+		/* If the old_state is started:
+		 * This request was not already being aborted. If it had been,
 		 * then the aborting I/O (ie. the TMF request) would not be in
 		 * the aborting state, and thus would be terminated here.  Note
 		 * that since the TMF completion's call to the kernel function
@@ -807,9 +973,15 @@ static void isci_terminate_request(
 		 * special wait here for already aborting requests - the
 		 * termination of the TMF request will force the request
 		 * to finish it's already started terminate.
+		 *
+		 * If old_state =3D=3D completed:
+		 * This request completed from the SCU hardware perspective
+		 * and now just needs cleaning up in terms of freeing the
+		 * request and potentially calling up to libsas.
 		 */
 		isci_terminate_request_core(isci_host, isci_device,
-					    isci_request, &request_completion);
+					    isci_request);
+	}
 }
=20
 /**
@@ -828,77 +1000,44 @@ void isci_terminate_pending_requests(
 	struct isci_remote_device *isci_device,
 	enum isci_request_status new_request_state)
 {
-	struct isci_request *isci_request;
-	struct sas_task *task;
-	bool done =3D false;
-	unsigned long flags;
+	struct isci_request *request;
+	struct isci_request *next_request;
+	unsigned long       flags;
+	struct list_head    aborted_request_list;
+
+	INIT_LIST_HEAD(&aborted_request_list);
=20
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: isci_device =3D %p (new request state =3D %d)\n",
 		__func__, isci_device, new_request_state);
=20
-	#define ISCI_TERMINATE_SHOW_PENDING_REQUESTS
-	#ifdef ISCI_TERMINATE_SHOW_PENDING_REQUESTS
-	{
-		struct isci_request *request;
-
-		/* Only abort the task if it's in the
-		 * device's request_in_process list
-		 */
-		list_for_each_entry(request,
-				    &isci_device->reqs_in_process,
-				    dev_node)
-			dev_dbg(&isci_host->pdev->dev,
-				"%s: isci_device =3D %p; request is on "
-				"reqs_in_process list: %p\n",
-				__func__, isci_device, request);
-	}
-	#endif /* ISCI_TERMINATE_SHOW_PENDING_REQUESTS */
-
-	/* Clean up all pending requests. */
-	do {
-		spin_lock_irqsave(&isci_host->scic_lock, flags);
-
-		if (list_empty(&isci_device->reqs_in_process)) {
-
-			done =3D true;
-			spin_unlock_irqrestore(&isci_host->scic_lock, flags);
-
-			dev_dbg(&isci_host->pdev->dev,
-				"%s: isci_device =3D %p; done.\n",
-				__func__, isci_device);
-		} else {
-			/* The list was not empty - grab the first request. */
-			isci_request =3D list_first_entry(
-				&isci_device->reqs_in_process,
-				struct isci_request, dev_node
-				);
-			/* Note that we are not expecting to have to control
-			 * the target to abort the request.
-			 */
-			isci_request->complete_in_target =3D true;
-
-			spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+	spin_lock_irqsave(&isci_host->scic_lock, flags);
=20
-			/* Get the libsas task reference. */
-			task =3D isci_request_access_task(isci_request);
+	/* Move all of the pending requests off of the device list. */
+	list_splice_init(&isci_device->reqs_in_process,
+			 &aborted_request_list);
=20
-			dev_dbg(&isci_host->pdev->dev,
-				"%s: isci_device=3D%p request=3D%p; task=3D%p\n",
-				__func__, isci_device, isci_request, task);
+	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
=20
-			/* Mark all still pending I/O with the selected next
-			 * state.
-			 */
-			isci_terminate_request(isci_host, isci_device,
-					       isci_request, new_request_state
-					       );
+	/* Iterate through the now-local list. */
+	list_for_each_entry_safe(request, next_request,
+				 &aborted_request_list, dev_node) {
=20
-			/* Set the 'done' state on the task. */
-			if (task)
-				isci_task_all_done(task);
-		}
-	} while (!done);
+		dev_warn(&isci_host->pdev->dev,
+			"%s: isci_device=3D%p request=3D%p; task=3D%p\n",
+			__func__,
+			isci_device, request,
+			((request->ttype =3D=3D io_task)
+				? isci_request_access_task(request)
+				: NULL));
+
+		/* Mark all still pending I/O with the selected next
+		* state, terminate and free it.
+		*/
+		isci_terminate_request(isci_host, isci_device,
+				       request, new_request_state
+				       );
+	}
 }
=20
 /**
@@ -994,9 +1133,6 @@ int isci_task_lu_reset(
 		return TMF_RESP_FUNC_FAILED;
 	}
=20
-	/* Stop I/O to the remote device. */
-	isci_device_set_host_quiesce_lock_state(isci_device, true);
-
 	/* Send the task management part of the reset. */
 	if (sas_protocol_ata(domain_device->tproto)) {
 		ret =3D isci_task_send_lu_reset_sata(
@@ -1012,9 +1148,6 @@ int isci_task_lu_reset(
 						isci_device,
 						terminating);
=20
-	/* Resume I/O to the remote device. */
-	isci_device_set_host_quiesce_lock_state(isci_device, false);
-
 	return ret;
 }
=20
@@ -1070,7 +1203,8 @@ static void isci_abort_task_process_cb(
 		 * request state was already set to "aborted" by the abort
 		 * task function.
 		 */
-		BUG_ON(old_request->status !=3D aborted);
+		BUG_ON((old_request->status !=3D aborted)
+			&& (old_request->status !=3D completed));
 		break;
=20
 	case isci_tmf_timed_out:
@@ -1103,13 +1237,15 @@ static void isci_abort_task_process_cb(
 int isci_task_abort_task(struct sas_task *task)
 {
 	DECLARE_COMPLETION_ONSTACK(aborted_io_completion);
-	struct isci_request *old_request =3D NULL;
+	struct isci_request       *old_request =3D NULL;
+	enum isci_request_status  old_state;
 	struct isci_remote_device *isci_device =3D NULL;
-	struct isci_host *isci_host =3D NULL;
-	struct isci_tmf tmf;
-	int ret =3D TMF_RESP_FUNC_FAILED;
-	unsigned long flags;
-	bool any_dev_reset, device_stopping;
+	struct isci_host          *isci_host =3D NULL;
+	struct isci_tmf           tmf;
+	int                       ret =3D TMF_RESP_FUNC_FAILED;
+	unsigned long             flags;
+	bool                      any_dev_reset =3D false;
+	bool                      device_stopping;
=20
 	/* Get the isci_request reference from the task.  Note that
 	 * this check does not depend on the pending request list
@@ -1129,21 +1265,6 @@ int isci_task_abort_task(struct sas_task *task)
 	device_stopping =3D (isci_device->status =3D=3D isci_stopping)
 			  || (isci_device->status =3D=3D isci_stopped);
=20
-#ifdef NOMORE
-	/* This abort task function is the first stop of the libsas error
-	 * handler thread. Since libsas is executing in a thread with a
-	 * referernce to the "task" parameter, that task cannot be completed
-	 * directly back to the upper layers.  In order to make sure that
-	 * the task is managed correctly if this abort task fails, set the
-	 * "SAS_TASK_STATE_ABORTED" bit now such that completions up the
-	 * stack will be intercepted and only allowed to happen in the
-	 * libsas SCSI error handler thread.
-	 */
-	spin_lock_irqsave(&task->task_state_lock, flags);
-	task->task_state_flags |=3D SAS_TASK_STATE_ABORTED;
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
-#endif  /* NOMORE */
-
 	/* This version of the driver will fail abort requests for
 	 * SATA/STP.  Failing the abort request this way will cause the
 	 * SCSI error handler thread to escalate to LUN reset
@@ -1159,35 +1280,27 @@ int isci_task_abort_task(struct sas_task *task)
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: old_request =3D=3D %p\n", __func__, old_request);
=20
+	if (!device_stopping)
+		any_dev_reset =3D isci_device_is_reset_pending(isci_host,isci_device=
);
+
 	spin_lock_irqsave(&task->task_state_lock, flags);
=20
 	/* Don't do resets to stopping devices. */
-	if (device_stopping)
-		task->task_state_flags &=3D ~SAS_TASK_NEED_DEV_RESET;
+	if (device_stopping) {
=20
-	/* See if there is a pending device reset for this device. */
-	any_dev_reset =3D task->task_state_flags & SAS_TASK_NEED_DEV_RESET;
-
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
+		task->task_state_flags &=3D ~SAS_TASK_NEED_DEV_RESET;
+		any_dev_reset =3D false;
=20
-	if ((isci_device !=3D NULL) && !device_stopping)
+	} else	/* See if there is a pending device reset for this device. */
 		any_dev_reset =3D any_dev_reset
-				|| isci_device_is_reset_pending(isci_host,
-								isci_device
-								);
+			|| (task->task_state_flags & SAS_TASK_NEED_DEV_RESET);
=20
 	/* If the extraction of the request reference from the task
 	 * failed, then the request has been completed (or if there is a
 	 * pending reset then this abort request function must be failed
 	 * in order to escalate to the target reset).
 	 */
-	if ((old_request =3D=3D NULL) ||
-	    ((old_request !=3D NULL) &&
-	     (old_request->sci_request_handle =3D=3D NULL) &&
-	     (old_request->complete_in_target)) ||
-	     any_dev_reset) {
-
-		spin_lock_irqsave(&task->task_state_lock, flags);
+	if ((old_request =3D=3D NULL) || any_dev_reset) {
=20
 		/* If the device reset task flag is set, fail the task
 		 * management request.  Otherwise, the original request
@@ -1200,6 +1313,11 @@ int isci_task_abort_task(struct sas_task *task)
 			 */
 			task->task_state_flags &=3D ~SAS_TASK_STATE_DONE;
=20
+			/* Make the reset happen as soon as possible. */
+			task->task_state_flags |=3D SAS_TASK_NEED_DEV_RESET;
+
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
+
 			/* Fail the task management request in order to
 			 * escalate to the target reset.
 			 */
@@ -1212,13 +1330,8 @@ int isci_task_abort_task(struct sas_task *task)
 				"task %p on dev %p\n",
 				__func__, task, isci_device);
=20
-		} else {
-			ret =3D TMF_RESP_FUNC_COMPLETE;
-
-			dev_dbg(&isci_host->pdev->dev,
-				"%s: abort task not needed for %p\n",
-				__func__, task);
=20
+		} else {
 			/* The request has already completed and there
 			 * is nothing to do here other than to set the task
 			 * done bit, and indicate that the task abort function
@@ -1226,97 +1339,71 @@ int isci_task_abort_task(struct sas_task *task)
 			 */
 			isci_set_task_doneflags(task);
=20
-			/* Set the abort bit to make sure that libsas sticks the
-			 * task in the completed task queue.
-			 */
-/*			task->task_state_flags |=3D SAS_TASK_STATE_ABORTED; */
+			spin_unlock_irqrestore(&task->task_state_lock, flags);
=20
-			/* Check for the situation where the request was
-			 * left around on the device list but the
-			 * request already completed.
-			 */
-			if (old_request && !old_request->sci_request_handle) {
+			ret =3D TMF_RESP_FUNC_COMPLETE;
=20
-				isci_request_cleanup_completed_loiterer(
-					isci_host, isci_device, old_request
-					);
-			}
+			dev_dbg(&isci_host->pdev->dev,
+				"%s: abort task not needed for %p\n",
+				__func__, task);
 		}
-		spin_unlock_irqrestore(&task->task_state_lock, flags);
=20
 		return ret;
 	}
+	else
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
=20
 	spin_lock_irqsave(&isci_host->scic_lock, flags);
=20
-	/* Sanity check the request status, and set the I/O kernel completion
+	/* Check the request status and change to "aborting" if currently
+	 * "starting"; if true then set the I/O kernel completion
 	 * struct that will be triggered when the request completes.
 	 */
-	if (isci_task_validate_request_to_abort(
-		    old_request,
-		    isci_host,
-		    isci_device,
-		    &aborted_io_completion)
-	    =3D=3D unallocated) {
-		dev_dbg(&isci_host->pdev->dev,
-			"%s: old_request not valid for device =3D %p\n",
-			__func__,
-			isci_device);
-		old_request =3D NULL;
-	}
-
-	if (!old_request) {
-
-		/* There is no isci_request attached to the sas_task.
-		 * It must have been completed and detached.
-		 */
-		dev_dbg(&isci_host->pdev->dev,
-			"%s: old_request =3D=3D NULL\n",
-			__func__);
+	old_state =3D isci_task_validate_request_to_abort(
+				old_request, isci_host, isci_device,
+				&aborted_io_completion);
+	if ((old_state !=3D started) && (old_state !=3D completed)) {
=20
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
=20
-		/* Set the state on the task. */
-		isci_task_all_done(task);
+		/* The request was already being handled by someone else (because
+		* they got to set the state away from started).
+		*/
+		dev_dbg(&isci_host->pdev->dev,
+			"%s:  device =3D %p; old_request %p already being aborted\n",
+			__func__,
+			isci_device, old_request);
=20
 		return TMF_RESP_FUNC_COMPLETE;
 	}
-	if (task->task_proto =3D=3D SAS_PROTOCOL_SMP || device_stopping) {
-
-		if (device_stopping)
-			dev_dbg(&isci_host->pdev->dev,
-				"%s: device is stopping, thus no TMF\n",
-				__func__);
-		else
-			dev_dbg(&isci_host->pdev->dev,
-				"%s: request is SMP, thus no TMF\n",
-				__func__);
-
-		old_request->complete_in_target =3D true;
+	if ((task->task_proto =3D=3D SAS_PROTOCOL_SMP)
+	    || device_stopping
+	    || old_request->complete_in_target
+	    ) {
=20
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
=20
+		dev_dbg(&isci_host->pdev->dev,
+			"%s: SMP request (%d)"
+			" or device is stopping (%d)"
+			" or complete_in_target (%d), thus no TMF\n",
+			__func__, (task->task_proto =3D=3D SAS_PROTOCOL_SMP),
+			device_stopping, old_request->complete_in_target);
+
 		/* Set the state on the task. */
 		isci_task_all_done(task);
=20
 		ret =3D TMF_RESP_FUNC_COMPLETE;
=20
 		/* Stopping and SMP devices are not sent a TMF, and are not
-		 * reset, but the outstanding I/O request is terminated here.
-		 *
-		 * Clean up the request on our side, and wait for the aborted
-		 * I/O to complete.
+		 * reset, but the outstanding I/O request is terminated below.
 		 */
-		isci_terminate_request_core(isci_host, isci_device, old_request,
-					    &aborted_io_completion);
 	} else {
 		/* Fill in the tmf stucture */
-		isci_task_build_tmf(&tmf, isci_device, isci_tmf_ssp_task_abort,
-				    isci_abort_task_process_cb, old_request);
-
-		tmf.io_tag =3D scic_io_request_get_io_tag(
-			old_request->sci_request_handle
-			);
+		isci_task_build_abort_task_tmf(&tmf, isci_device,
+					       isci_tmf_ssp_task_abort,
+					       isci_abort_task_process_cb,
+					       old_request);
=20
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
=20
@@ -1324,23 +1411,22 @@ int isci_task_abort_task(struct sas_task *task)
 		ret =3D isci_task_execute_tmf(isci_host, &tmf,
 					    ISCI_ABORT_TASK_TIMEOUT_MS);
=20
-		if (ret =3D=3D TMF_RESP_FUNC_COMPLETE) {
-			old_request->complete_in_target =3D true;
-
-			/* Clean up the request on our side, and wait for the aborted I/O t=
o
-			 * complete.
-			 */
-			isci_terminate_request_core(isci_host, isci_device, old_request,
-						    &aborted_io_completion);
-
-			/* Set the state on the task. */
-			isci_task_all_done(task);
-		} else
+		if (ret !=3D TMF_RESP_FUNC_COMPLETE)
 			dev_err(&isci_host->pdev->dev,
 				"%s: isci_task_send_tmf failed\n",
 				__func__);
 	}
+	if (ret =3D=3D TMF_RESP_FUNC_COMPLETE) {
+		old_request->complete_in_target =3D true;
+
+		/* Clean up the request on our side, and wait for the aborted I/O to
+		* complete.
+		*/
+		isci_terminate_request_core(isci_host, isci_device, old_request);
+	}
=20
+	/* Make sure we do not leave a reference to aborted_io_completion */
+	old_request->io_request_completion =3D NULL;
 	return ret;
 }
=20
@@ -1468,10 +1554,7 @@ void isci_task_request_complete(
=20
 	/* Manage the timer if it is still running. */
 	if (tmf->timeout_timer) {
-
-		isci_timer_stop(tmf->timeout_timer);
-		isci_timer_free(&isci_host->timer_list_struct,
-				tmf->timeout_timer);
+		isci_del_timer(isci_host, tmf->timeout_timer);
 		tmf->timeout_timer =3D NULL;
 	}
=20
@@ -1480,7 +1563,7 @@ void isci_task_request_complete(
=20
 	scic_controller_complete_task(
 		isci_host->core_controller,
-		isci_device->sci_device_handle,
+		to_sci_dev(isci_device),
 		request->sci_request_handle
 		);
 	/* NULL the request handle to make sure it cannot be terminated
@@ -1623,7 +1706,7 @@ int isci_bus_reset_handler(struct scsi_cmnd *cmd)
 	if (isci_host !=3D NULL)
 		spin_lock_irqsave(&isci_host->scic_lock, flags);
=20
-	status =3D scic_remote_device_reset(isci_dev->sci_device_handle);
+	status =3D scic_remote_device_reset(to_sci_dev(isci_dev));
 	if (status !=3D SCI_SUCCESS) {
=20
 		if (isci_host !=3D NULL)
@@ -1638,9 +1721,6 @@ int isci_bus_reset_handler(struct scsi_cmnd *cmd)
 	if (isci_host !=3D NULL)
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
=20
-	/* Stop I/O to the remote device. */
-	isci_device_set_host_quiesce_lock_state(isci_dev, true);
-
 	/* Make sure all pending requests are able to be fully terminated. */
 	isci_device_clear_reset_pending(isci_dev);
=20
@@ -1665,8 +1745,7 @@ int isci_bus_reset_handler(struct scsi_cmnd *cmd)
=20
 	if (isci_host !=3D NULL)
 		spin_lock_irqsave(&isci_host->scic_lock, flags);
-	status
-		=3D scic_remote_device_reset_complete(isci_dev->sci_device_handle);
+	status =3D scic_remote_device_reset_complete(to_sci_dev(isci_dev));
=20
 	if (isci_host !=3D NULL)
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
@@ -1683,8 +1762,5 @@ int isci_bus_reset_handler(struct scsi_cmnd *cmd)
 		"%s: cmd %p, isci_dev %p complete.\n",
 		__func__, cmd, isci_dev);
=20
-	/* Resume I/O to the remote device. */
-	isci_device_set_host_quiesce_lock_state(isci_dev, false);
-
 	return TMF_RESP_FUNC_COMPLETE;
 }
diff --git a/drivers/scsi/isci/task.h b/drivers/scsi/isci/task.h
index ced6a8b..b84bedd 100644
--- a/drivers/scsi/isci/task.h
+++ b/drivers/scsi/isci/task.h
@@ -221,10 +221,19 @@ void isci_task_build_tmf(
 	struct isci_tmf *tmf,
 	struct isci_remote_device *isci_device,
 	enum isci_tmf_function_codes code,
+	void (*tmf_sent_cb)(enum isci_tmf_cb_state,
+			    struct isci_tmf *,
+			    void *),
+	void *cb_data);
+
+void isci_task_build_abort_task_tmf(
+	struct isci_tmf *tmf,
+	struct isci_remote_device *isci_device,
+	enum isci_tmf_function_codes code,
 	void (*tmf_sent_cb)(
 		enum isci_tmf_cb_state,
 		struct isci_tmf *, void *),
-	void *cb_data);
+	struct isci_request *old_request);
=20
 int isci_task_execute_tmf(
 	struct isci_host *isci_host,
@@ -280,9 +289,10 @@ static inline void isci_task_all_done(
  * @response: This parameter is the response code for the completed ta=
sk.
  * @status: This parameter is the status code for the completed task.
  *
- * none.
- */
-static inline void isci_task_set_completion_status(
+* @return The new notification mode for the request.
+*/
+static inline enum isci_completion_selection
+isci_task_set_completion_status(
 	struct sas_task *task,
 	enum service_response response,
 	enum exec_status status,
@@ -292,77 +302,49 @@ static inline void isci_task_set_completion_statu=
s(
=20
 	spin_lock_irqsave(&task->task_state_lock, flags);
=20
+	/* If a device reset is being indicated, make sure the I/O
+	* is in the error path.
+	*/
+	if (task->task_state_flags & SAS_TASK_NEED_DEV_RESET) {
+
+		/* Fail the I/O to make sure it goes into the error path. */
+		response =3D SAS_TASK_UNDELIVERED;
+		status =3D SAM_STAT_TASK_ABORTED;
+
+		task_notification_selection =3D isci_perform_error_io_completion;
+	}
 	task->task_status.resp =3D response;
 	task->task_status.stat =3D status;
=20
-	/* Don't set DONE (or clear AT_INITIATOR) for any task going into the
-	 * error path, because the EH interprets that as a handled error cond=
ition.
-	 * Also don't take action if there is a reset pending.
-	 */
-	if ((task_notification_selection !=3D isci_perform_error_io_completio=
n)
-	    && !(task->task_state_flags & SAS_TASK_NEED_DEV_RESET))
-		isci_set_task_doneflags(task);
+	switch (task_notification_selection) {
+
+		case isci_perform_aborted_io_completion:
+			/* This path can occur with task-managed requests as well as
+			* requests terminated because of LUN or device resets.
+			*/
+			/* Fall through to the normal case... */
+
+		case isci_perform_normal_io_completion:
+			/* Normal notification (task_done) */
+			isci_set_task_doneflags(task);
+			break;
+
+		default:
+			WARN_ON(FALSE);
+			/* Fall through to the error case... */
+
+		case isci_perform_error_io_completion:
+			/* Use sas_task_abort */
+			/* Leave SAS_TASK_STATE_DONE clear
+			*  Leave SAS_TASK_AT_INITIATOR set.
+			*/
+			break;
+	}
=20
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
-}
-/**
- * isci_task_complete_for_upper_layer() - This function completes the =
request
- *    to the upper layer driver.
- * @host: This parameter is a pointer to the host on which the the req=
uest
- *    should be queued (either as an error or success).
- * @request: This parameter is the completed request.
- * @response: This parameter is the response code for the completed ta=
sk.
- * @status: This parameter is the status code for the completed task.
- *
- * none.
- */
-static inline void isci_task_complete_for_upper_layer(
-	struct sas_task *task,
-	enum service_response response,
-	enum exec_status status,
-	enum isci_completion_selection task_notification_selection)
-{
-	isci_task_set_completion_status(task, response, status,
-					 task_notification_selection);
=20
+	return task_notification_selection;
=20
-	/* Tasks aborted specifically by a call to the lldd_abort_task
-	 * function should not be completed to the host in the regular path.
-	 */
-	switch (task_notification_selection) {
-	case isci_perform_normal_io_completion:
-		/* Normal notification (task_done) */
-		dev_dbg(task->dev->port->ha->dev,
-			"%s: Normal - task =3D %p, response=3D%d, status=3D%d\n",
-			__func__, task, response, status);
-		task->task_done(task);
-		task->lldd_task =3D NULL;
-		break;
-
-	case isci_perform_aborted_io_completion:
-		/* No notification because this request is already in the
-		 * abort path.
-		 */
-		dev_warn(task->dev->port->ha->dev,
-			 "%s: Aborted - task =3D %p, response=3D%d, status=3D%d\n",
-			 __func__, task, response, status);
-		break;
-
-	case isci_perform_error_io_completion:
-		/* Use sas_task_abort */
-		dev_warn(task->dev->port->ha->dev,
-			 "%s: Error - task =3D %p, response=3D%d, status=3D%d\n",
-			 __func__, task, response, status);
-		sas_task_abort(task);
-		break;
-
-	default:
-		dev_warn(task->dev->port->ha->dev,
-			 "%s: isci task notification default case!",
-			 __func__);
-		sas_task_abort(task);
-		break;
-	}
 }
=20
 #endif /* !defined(_SCI_TASK_H_) */
diff --git a/drivers/scsi/isci/timers.c b/drivers/scsi/isci/timers.c
index ca72308..f33eff0 100644
--- a/drivers/scsi/isci/timers.c
+++ b/drivers/scsi/isci/timers.c
@@ -56,96 +56,59 @@
 #include "isci.h"
 #include "timers.h"
=20
-
 /**
  * isci_timer_list_construct() - This method contrucst the SCI Timer L=
ist
  *    object used by the SCI Module class. The construction process in=
volves
  *    creating isci_timer objects and adding them to the SCI Timer Lis=
t
  *    object's list member. The number of isci_timer objects is determ=
ined by
  *    the timer_list_size parameter.
- * @isci_timer_list: This parameter points to the SCI Timer List objec=
t being
- *    constructed. The calling routine is responsible for allocating t=
he memory
- *    for isci_timer_list and initializing the timer list_head member =
of
- *    isci_timer_list.
- * @timer_list_size: This parameter specifies the number of isci_timer=
 objects
- *    contained by the SCI Timer List. which this timer is to be assoc=
iated.
+ * @ihost: container of the timer list
  *
  * This method returns an error code indicating sucess or failure. The=
 user
  * should check for possible memory allocation error return otherwise,=
 a zero
  * indicates success.
  */
-int isci_timer_list_construct(
-	struct isci_timer_list *isci_timer_list,
-	int timer_list_size)
+int isci_timer_list_construct(struct isci_host *ihost)
 {
-	struct isci_timer *isci_timer;
-	int i;
-	int err =3D 0;
-
+	struct isci_timer *itimer;
+	int i, err =3D 0;
=20
-	for (i =3D 0; i < timer_list_size; i++) {
-
-		isci_timer =3D kzalloc(sizeof(*isci_timer), GFP_KERNEL);
-
-		if (!isci_timer) {
+	INIT_LIST_HEAD(&ihost->timers);
+	for (i =3D 0; i < SCI_MAX_TIMER_COUNT; i++) {
+		itimer =3D devm_kzalloc(&ihost->pdev->dev, sizeof(*itimer), GFP_KERN=
EL);
=20
+		if (!itimer) {
 			err =3D -ENOMEM;
 			break;
 		}
-		isci_timer->used =3D 0;
-		isci_timer->stopped =3D 1;
-		isci_timer->parent =3D isci_timer_list;
-		list_add(&isci_timer->node, &isci_timer_list->timers);
+		init_timer(&itimer->timer);
+		itimer->used =3D 0;
+		itimer->stopped =3D 1;
+		list_add(&itimer->node, &ihost->timers);
 	}
=20
-	return 0;
-
+	return err;
 }
=20
-
 /**
  * isci_timer_list_destroy() - This method destroys the SCI Timer List=
 object
  *    used by the SCI Module class. The destruction  process involves =
freeing
  *    memory allocated for isci_timer objects on the SCI Timer List ob=
ject's
  *    timers list_head member. If any isci_timer objects are mark as "=
in use",
  *    they are not freed and the function returns an error code of -EB=
USY.
- * @isci_timer_list: This parameter points to the SCI Timer List objec=
t being
- *    destroyed.
- *
- * This method returns an error code indicating sucess or failure. The=
 user
- * should check for possible -EBUSY error return, in the event of one =
or more
- * isci_timers still "in use", otherwise, a zero indicates success.
+ * @ihost: container of the list to be destroyed
  */
-int isci_timer_list_destroy(
-	struct isci_timer_list *isci_timer_list)
+void isci_timer_list_destroy(struct isci_host *ihost)
 {
-	struct isci_timer *timer, *tmp;
-
-	list_for_each_entry_safe(timer, tmp, &isci_timer_list->timers, node) =
{
-		isci_timer_free(isci_timer_list, timer);
-		list_del(&timer->node);
-		kfree(timer);
-	}
-	return 0;
-}
+	struct isci_timer *timer;
+	LIST_HEAD(list);
=20
+	spin_lock_irq(&ihost->scic_lock);
+	list_splice_init(&ihost->timers, &list);
+	spin_unlock_irq(&ihost->scic_lock);
=20
-
-static void isci_timer_restart(struct isci_timer *isci_timer)
-{
-	struct timer_list *timer =3D
-		&isci_timer->timer;
-	unsigned long timeout;
-
-	dev_dbg(&isci_timer->isci_host->pdev->dev,
-		"%s: isci_timer =3D %p\n", __func__, isci_timer);
-
-	isci_timer->restart =3D 0;
-	isci_timer->stopped =3D 0;
-	timeout =3D isci_timer->timeout_value;
-	timeout =3D (timeout * HZ) / 1000;
-	timeout =3D timeout ? timeout : 1;
-	mod_timer(timer, jiffies + timeout);
+	list_for_each_entry(timer, &list, node)
+		del_timer_sync(&timer->timer);
 }
=20
 /**
@@ -169,7 +132,7 @@ static void isci_timer_restart(struct isci_timer *i=
sci_timer)
 static void timer_function(unsigned long data)
 {
=20
-	struct isci_timer *timer     =3D (struct isci_timer *)data;
+	struct isci_timer *timer =3D (struct isci_timer *)data;
 	struct isci_host *isci_host =3D timer->isci_host;
 	unsigned long flags;
=20
@@ -185,89 +148,66 @@ static void timer_function(unsigned long data)
=20
 	if (!timer->stopped) {
 		timer->stopped =3D 1;
-		timer->timer_callback(timer->cookie);
-
-		if (timer->restart)
-			isci_timer_restart(timer);
+		timer->timer_callback(timer->cb_param);
 	}
=20
 	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 }
=20
=20
-struct isci_timer *isci_timer_create(
-	struct isci_timer_list *isci_timer_list,
-	struct isci_host *isci_host,
-	void *cookie,
-	void (*timer_callback)(void *))
+struct isci_timer *isci_timer_create(struct isci_host *ihost, void *cb=
_param,
+				     void (*timer_callback)(void *))
 {
-
 	struct timer_list *timer;
 	struct isci_timer *isci_timer;
-	struct list_head *timer_list =3D
-		&isci_timer_list->timers;
-	unsigned long flags;
+	struct list_head *list =3D &ihost->timers;
=20
-	spin_lock_irqsave(&isci_host->scic_lock, flags);
+	WARN_ONCE(!spin_is_locked(&ihost->scic_lock),
+		  "%s: unlocked!\n", __func__);
=20
-	if (list_empty(timer_list)) {
-		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+	if (WARN_ONCE(list_empty(list), "%s: timer pool empty\n", __func__))
 		return NULL;
-	}
=20
-	isci_timer =3D list_entry(timer_list->next, struct isci_timer, node);
+	isci_timer =3D list_entry(list->next, struct isci_timer, node);
=20
-	if (isci_timer->used) {
-		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
-		return NULL;
-	}
 	isci_timer->used =3D 1;
 	isci_timer->stopped =3D 1;
-	list_move_tail(&isci_timer->node, timer_list);
-
-	spin_unlock_irqrestore(&isci_host->scic_lock, flags);
+	/* FIXME: what!? we recycle the timer, rather than take it off
+	 * the free list?
+	 */
+	list_move_tail(&isci_timer->node, list);
=20
 	timer =3D &isci_timer->timer;
 	timer->data =3D (unsigned long)isci_timer;
 	timer->function =3D timer_function;
-	isci_timer->cookie =3D cookie;
+	isci_timer->cb_param =3D cb_param;
 	isci_timer->timer_callback =3D timer_callback;
-	isci_timer->isci_host =3D isci_host;
+	isci_timer->isci_host =3D ihost;
=20
-	dev_dbg(&isci_host->pdev->dev,
+	dev_dbg(&ihost->pdev->dev,
 		"%s: isci_timer =3D %p\n", __func__, isci_timer);
=20
 	return isci_timer;
 }
=20
-/**
- * isci_timer_free() - This method frees the isci_timer, marking it "f=
ree to
+/* isci_del_timer() - This method frees the isci_timer, marking it "fr=
ee to
  *    use", then places its back at the head of the timers list for th=
e SCI
  *    Timer List object specified.
- * @isci_timer_list: This parameter points to the SCI Timer List from =
which the
- *    timer is reserved.
- * @isci_timer: This parameter specifies the timer to be freed.
- *
  */
-void isci_timer_free(
-	struct isci_timer_list *isci_timer_list,
-	struct isci_timer *isci_timer)
+void isci_del_timer(struct isci_host *ihost, struct isci_timer *isci_t=
imer)
 {
-	struct list_head *timer_list =3D &isci_timer_list->timers;
+	struct list_head *list =3D &ihost->timers;
+
+	WARN_ONCE(!spin_is_locked(&ihost->scic_lock),
+		  "%s unlocked!\n", __func__);
=20
 	dev_dbg(&isci_timer->isci_host->pdev->dev,
 		"%s: isci_timer =3D %p\n", __func__, isci_timer);
=20
-	if (list_empty(timer_list))
-		return;
-
 	isci_timer->used =3D 0;
-	list_move(&isci_timer->node, timer_list);
-
-	if (!isci_timer->stopped) {
-		del_timer(&isci_timer->timer);
-		isci_timer->stopped =3D 1;
-	}
+	list_move(&isci_timer->node, list);
+	del_timer(&isci_timer->timer);
+	isci_timer->stopped =3D 1;
 }
=20
 /**
@@ -278,26 +218,15 @@ void isci_timer_free(
  *    the associated callback function will be called.
  *
  */
-void isci_timer_start(
-	struct isci_timer *isci_timer,
-	unsigned long timeout)
+void isci_timer_start(struct isci_timer *isci_timer, unsigned long tmo=
)
 {
 	struct timer_list *timer =3D &isci_timer->timer;
=20
 	dev_dbg(&isci_timer->isci_host->pdev->dev,
 		"%s: isci_timer =3D %p\n", __func__, isci_timer);
=20
-	isci_timer->timeout_value =3D timeout;
-	init_timer(timer);
-	timeout =3D (timeout * HZ) / 1000;
-	timeout =3D timeout ? timeout : 1;
-
-	timer->expires =3D jiffies + timeout;
-	timer->data =3D (unsigned long)isci_timer;
-	timer->function =3D timer_function;
 	isci_timer->stopped =3D 0;
-	isci_timer->restart =3D 0;
-	add_timer(timer);
+	mod_timer(timer, jiffies + msecs_to_jiffies(tmo));
 }
=20
 /**
@@ -310,10 +239,6 @@ void isci_timer_stop(struct isci_timer *isci_timer=
)
 	dev_dbg(&isci_timer->isci_host->pdev->dev,
 		"%s: isci_timer =3D %p\n", __func__, isci_timer);
=20
-	if (isci_timer->stopped)
-		return;
-
 	isci_timer->stopped =3D 1;
-
 	del_timer(&isci_timer->timer);
 }
diff --git a/drivers/scsi/isci/timers.h b/drivers/scsi/isci/timers.h
index ca5c215..8d8a892 100644
--- a/drivers/scsi/isci/timers.h
+++ b/drivers/scsi/isci/timers.h
@@ -59,68 +59,30 @@
 #include <linux/timer.h>
 #include <linux/types.h>
=20
-/***************************************************
- * isci_timer
- ***************************************************
- */
-/**
- * struct isci_timer_list - This class is the container for all isci_t=
imer
- *    objects
- *
- *
- */
-struct isci_timer_list {
-
-	struct list_head timers;
-};
+#define SCI_MAX_TIMER_COUNT 25
=20
 /**
  * struct isci_timer - This class represents the timer object used by =
SCIC. It
- *    wraps the Linux timer_list object.
- *
+ *    wraps the Linux timer_list object, and (TODO) should be removed =
in favor
+ *    of a delayed-workqueue style interface with simpler locking
  *
  */
 struct isci_timer {
 	int used;
 	int stopped;
-	int restart;
-	int timeout_value;
-	void *cookie;
+	void *cb_param;
 	void (*timer_callback)(void *);
 	struct list_head node;
 	struct timer_list timer;
-	struct isci_timer_list *parent;
 	struct isci_host *isci_host;
 };
=20
-#define to_isci_timer(t)	\
-	container_of(t, struct isci_timer, timer);
-
-int isci_timer_list_construct(
-	struct isci_timer_list *isci_timer_list,
-	int timer_list_size);
-
-
-int isci_timer_list_destroy(
-	struct isci_timer_list *isci_timer_list);
-
-struct isci_timer *isci_timer_create(
-	struct isci_timer_list *isci_timer_list,
-	struct isci_host *isci_host,
-	void *cookie,
-	void (*timer_callback)(void *));
-
-void isci_timer_free(
-	struct isci_timer_list *isci_timer_list,
-	struct isci_timer *isci_timer);
-
-void isci_timer_start(
-	struct isci_timer *isci_timer,
-	unsigned long timeout);
-
-void isci_timer_stop(
-	struct isci_timer *isci_timer);
-
+int isci_timer_list_construct(struct isci_host *ihost);
+void isci_timer_list_destroy(struct isci_host *ihost);
+struct isci_timer *isci_timer_create(struct isci_host *ihost, void *cb=
_param,
+				     void (*timer_callback)(void *));
+void isci_del_timer(struct isci_host *ihost, struct isci_timer *itimer=
);
+void isci_timer_start(struct isci_timer *isci_timer, unsigned long tim=
eout);
+void isci_timer_stop(struct isci_timer *isci_timer);
=20
 #endif /* !defined (_SCI_TIMER_H_) */
-


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
