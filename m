From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT] isci update
Date: Fri, 24 Jun 2011 16:08:37 -0700
Message-ID: <1308956917.9225.27.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60162 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793Ab1FXXIi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2011 19:08:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Jeff Garzik <jeff@garzik.org>, Dave Jiang <dave.jiang@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, David Milburn <dmilburn@redhat.com>, hare@suse.de

The following changes since commit 24ddeace8923d1da9d9ea839d02afb1482f9c652:

  isci: use pci_map_biosrom (2011-06-06 14:23:36 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

We took a break from the pure cleanup work to tackle some of the pending
bug backlog.  The biggest changes are the bcn filtering to prevent
devices from disappearing prematurely,  device object reference counting
to close a class of use after free bugs, and a fix for NCQ error
handling.  However, we're still seeing the mid-layer tear down the sdev
while commands are in-flight, so that investigation continues.

With these out of they way we can return to the data structure
unification effort (although that likely will not decrease the line
count much further, not like the 2:1 ratio of deletions-to-insertions
that we saw with the previous cleanups).  The commits below deleted some
unneeded fields out of the data structures, but we can perform another
audit pass after the unification.

--
Dan for the isci driver team

Dan Williams (14):
      isci: fix isci_terminate_pending() list management
      isci: cleanup/optimize pool implementation
      isci: cleanup tag macros
      isci: cleanup/optimize queue increment macros
      isci: cleanup request allocation
      isci: fix ssp response iu buffer size in isci_tmf
      isci: atomic device lookup and reference counting
      isci: kill isci_remote_device_change_state()
      isci: kill device_sequence
      isci: fix smp response frame overrun
      isci: fix dma_unmap_sg usage
      isci: fix support for arbitrarily large smp requests
      isci: fix isci_task_execute_tmf completion
      isci: fix frame received locking

Jeff Skirvin (9):
      isci: Move the reset delay after the remote node resumption.
      isci: filter broadcast change notifications during SMP phy resets
      isci: Add decode for SMP request retry error condition
      isci: Requests that do not start must be set to "complete"
      isci: Handle timed-out request terminations correctly
      isci: Explicitly decode remote node ready and suspended states
      isci: Hard reset failure will link reset all phys in the port
      isci: Disable link layer hang detection
      isci: Terminate dev requests on FIS err bit rx in NCQ

Maciej Patelczyk (1):
      isci: possible buffer overflow in isci_parse_oem_parameters fixed

 drivers/scsi/isci/host.c                      |  206 +++---
 drivers/scsi/isci/host.h                      |   84 +--
 drivers/scsi/isci/isci.h                      |    7 +-
 drivers/scsi/isci/phy.c                       |   12 +-
 drivers/scsi/isci/pool.h                      |  199 -----
 drivers/scsi/isci/port.c                      |  157 +++--
 drivers/scsi/isci/port.h                      |    5 +
 drivers/scsi/isci/probe_roms.c                |    2 +-
 drivers/scsi/isci/remote_device.c             |  161 ++---
 drivers/scsi/isci/remote_device.h             |   40 +-
 drivers/scsi/isci/remote_node_context.c       |   15 +-
 drivers/scsi/isci/request.c                   |  465 ++++++------
 drivers/scsi/isci/request.h                   |  127 +---
 drivers/scsi/isci/sas.h                       |   11 +-
 drivers/scsi/isci/sata.c                      |    7 +-
 drivers/scsi/isci/task.c                      | 1051 ++++++++++++++-----------
 drivers/scsi/isci/task.h                      |   39 +-
 drivers/scsi/isci/unsolicited_frame_control.c |   58 +-
 18 files changed, 1217 insertions(+), 1429 deletions(-)
 delete mode 100644 drivers/scsi/isci/pool.h

There is an additional few commits pending internal test that clarify
the code a bit further.  These are available on the 'testing' branch.

Dan Williams (3):
      isci: unify can_queue tracking on the tci_pool, uplevel tag assignment
      isci: combine request flags
      isci: preallocate requests

 drivers/scsi/isci/host.c          |  333 ++++++++-----------------
 drivers/scsi/isci/host.h          |   66 +-----
 drivers/scsi/isci/port.c          |   61 ++---
 drivers/scsi/isci/port.h          |    2 +-
 drivers/scsi/isci/remote_device.c |    9 +-
 drivers/scsi/isci/request.c       |  489 ++++++++++++-------------------------
 drivers/scsi/isci/request.h       |   47 +---
 drivers/scsi/isci/task.c          |  112 ++++-----
 8 files changed, 362 insertions(+), 757 deletions(-)

Full changelog for the new commits on 'master':

commit 38c58d3ec9f9738e9ec8e488164a2a9ee58a587a
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Mon Jun 20 14:08:51 2011 -0700

    isci: Move the reset delay after the remote node resumption.
    
    Delay after bringing up the RNC to allow for resumption latency.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e5bd90ee3311f961df592d7f996170c0065f1e7d
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Tue Jun 21 12:16:33 2011 -0700

    isci: filter broadcast change notifications during SMP phy resets
    
    When resetting a sata device in the domain we have seen occasions where
    libsas prematurely marks a device gone in the time it takes for the
    device to re-establish the link.  This plays badly with software raid
    arrays.  Other libsas drivers have non-uniform delays in their reset
    handlers to try to cover this condition, but not sufficient to close the
    hole.  Given that a sata device can take many seconds to recover we
    filter bcns and poll for the device reattach state before notifying
    libsas that the port needs the domain to be rediscovered.  Once this has
    been proven out at the lldd level we can think about uplevelling this
    feature to a common implementation in libsas.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    [ use kzalloc instead of kmem_cache ]
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    [ use eventq and time macros ]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2e6e44527fd195546768be86ebceb3b52dbda325
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Mon Jun 20 14:09:06 2011 -0700

    isci: Add decode for SMP request retry error condition
    
    There are situations with slow expanders in which a first attempt
    to execute an SMP request will fail with a timeout.  Immediate
    subsequent retries will generally succeed.  This change makes sure
    SMP I/O failures are immediately failed to libsas so that retries
    happen with no discovery process timeout delay.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fbe6083a8c54767221f476d054144c04bc80210c
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Mon Jun 20 14:09:11 2011 -0700

    isci: Requests that do not start must be set to "complete"
    
    Requests that fail at start because of a reset pending condition
    must be set to complete in order to allow for later cleanup.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 61531b090278dcab2bb4c0ab833f1a33f18127ea
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Mon Jun 20 14:09:16 2011 -0700

    isci: Handle timed-out request terminations correctly
    
    In the situation where a termination of an I/O times-out,
    make sure that the linkage from the request to the task
    is severed completely.  Also make sure that the selection
    of tasks to terminate occurs under scic_lock.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 23304772281abf75cc1f2f46fa08c3b7d967b360
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 20 15:11:22 2011 -0700

    isci: fix isci_terminate_pending() list management
    
    Walk through the list of pending requests being careful to consider that
    multiple requests can be terminated when the lock is dropped (i.e.
    invalidating the 'next' reference established by
    list_for_each_entry_safe).
    
    Also noticed that all callers to isci_terminate_pending_requests()
    specifying terminating, so just drop the parameter.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bb723712dfb4447b470c50694f0fdfc2b604c51a
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Mon Jun 20 14:09:22 2011 -0700

    isci: Explicitly decode remote node ready and suspended states
    
    The remote node context should only signal a device reset condition
    in a suspended state.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d675df226d63f9ea47c13b31fae53eb01f6591a3
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Mon Jun 20 14:09:26 2011 -0700

    isci: Hard reset failure will link reset all phys in the port
    
    In the case where the hard reset process fails, each link in
    the port is put through a link reset sequence.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 7d77a6244b39b4922bb561ce53d9824b5868ceb7
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Mon Jun 20 14:09:31 2011 -0700

    isci: Disable link layer hang detection
    
    Some targets exceed the hang detect timer.  Use the OS timeout to
    catch hung tasks.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1b42240883b9c2f2292b714f2b318cb01fdb8946
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jun 7 18:50:55 2011 -0700

    isci: cleanup/optimize pool implementation
    
    The circ_buf macros are ~6% faster, as measured by perf, because they take
    advantage of power-of-two math assumptions i.e. no test and branch for
    rollover. Their semantics are clearer than the hidden side effects in pool.h
    (like sci_pool_get() which hides an assignment).
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 69c22befdd2083f7d752052d282838f49d6de703
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 9 11:06:58 2011 -0700

    isci: cleanup tag macros
    
    A tag is a 16 bit number where the upper four bits is a sequence number
    and the remainder is the task context index (tci).  Sanitize the macro
    names and shave 256-bytes out of scic_sds_controller by reducing the size of
    io_request_sequence.
    
    scic_sds_io_tag_construct --> ISCI_TAG
    scic_sds_io_tag_get_sequence --> ISCI_TAG_SEQ
    scic_sds_io_tag_get_index() --> ISCI_TAG_TCI
    scic_sds_io_sequence_increment() [delete / open code]
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e1fefd145ad9fe20715987cb06ad55958fa9c35d
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 9 16:04:28 2011 -0700

    isci: cleanup/optimize queue increment macros
    
    Every single i/o or event completion incurs a test and branch to see if
    the cycle bit changed.  For power-of-2 queue sizes the cycle bit can be
    read directly from the rollover of the queue pointer.
    
    Likely premature optimization, but the hidden if() and hidden
    assignments / side-effects in the macros were already asking to be
    cleaned up.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e1835f37389714685a47973fe581101f45a209ab
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 13 00:51:30 2011 -0700

    isci: cleanup request allocation
    
    Rather than return an error code and update a pointer that was passed by
    reference just return the request object directly (or null if allocation
    failed).
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit eb7e2b6e583303f58b5ee2f0503eac8e79a4485c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Jun 15 11:11:03 2011 -0700

    isci: fix ssp response iu buffer size in isci_tmf
    
    In isci_task_request_complete() we save the response/sense data from the
    command.  Make sure isci_tmf has enough space to hold the full response.
    
    [ it does not look like we actually use this data, and
      response_data_len/sense_data_len should be specifying the byte count,
      in any event do the simple fix first so we don't corrupt memory ]
    
    Reported-by: Adam Gruchala <adam.gruchala@intel.com>
    Tested-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2be9012668d77ecd898ccc98af399ad400340e8f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 13 17:39:44 2011 -0700

    isci: atomic device lookup and reference counting
    
    We have unsafe references to remote devices that are notified to
    disappear at lldd_dev_gone.  In order to clean this up we need a single
    canonical source for device lookups and stable references once a lookup
    succeeds.  Towards that end guarantee that domain_device.lldd_dev is
    NULL as soon as we start the process of stopping a device.  Any code
    path that wants to safely lookup a remote device must do so through
    task->dev->lldd_dev (isci_lookup_device()).
    
    For in-flight references outside of scic_lock we need reference counting
    to ensure that the device is not recycled before we are done with it.
    Simplify device back references to just scic_sds_request.target_device
    which is now the only permissible internal reference that is maintained
    relative to the reference count.
    
    There were two occasions where we wanted new i/o's to be treated as
    SAS_TASK_UNDELIVERED but where the domain_dev->lldd_dev link is still
    intact.  Introduce a 'gone' flag to prevent i/o while waiting for libsas
    to take action on the port down event.
    
    One 'core' leftover is that we currently call
    scic_remote_device_destruct() from isci_remote_device_deconstruct()
    which is called when the 'core' says the device is stopped.  It would be
    more natural for the final put to trigger
    isci_remote_device_deconstruct() but this implementation is deferred as
    it requires other changes.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c63df553f0b9c05cbefdbdc5860bb254aa3704bd
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 16 11:26:12 2011 -0700

    isci: kill isci_remote_device_change_state()
    
    Now that "stopping/stopped" are one in the same and signalled by a NULL device
    pointer the rest of the device status infrastructure can be removed (->status
    and ->state_lock).  The "not ready for i/o state" is replaced with a state
    flag, and is evaluated under scic_lock so that we don't see transients from
    taking the device reference to submitting the i/o.
    
    This also fixes a potential leakage of can_queue slots in the rare case that
    SAS_TASK_ABORTED is set at submission.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 06c1c5f7413585e8a723ce9f7883521f94430a45
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jun 17 13:34:43 2011 -0700

    isci: kill device_sequence
    
    Now that we have upleveled device reassignment protection to the
    isci_remote_device reference count we no longer need this level of
    self-defense.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 13a3bfc8ad2efb7bbd87e5a2a3bdd5c8e7a9d772
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 16 17:20:35 2011 -0700

    isci: fix smp response frame overrun
    
    Due to a typo we currently copy way too much when copying over the
    response data, but since a request is likely backed by a full page
    allocation we don't corrupt live data.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 631025ad3c0982b34fac0c1603ad5d50c53c7b4f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jun 17 10:40:43 2011 -0700

    isci: fix dma_unmap_sg usage
    
    One bug and a cleanup:
    1/ Fix cases where we were unmapping invalid addresses (smp requests were
       being unmapped)
    
    [  604.662770] ------------[ cut here ]------------
    [  604.668026] WARNING: at lib/dma-debug.c:800 check_unmap+0x418/0x740()
    [  604.675315] Hardware name: SandyBridge Platform
    [  604.680465] isci 0000:03:00.0: DMA-API: device driver tries to free an invalid DMA memory address
    
    2/ The unmap routine is too large to be an inline function, and
       isci_request_io_request_get_next_sge is unused.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3b847c876324e5787f055c5eb89150506511bd86
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 16 16:59:56 2011 -0700

    isci: fix support for arbitrarily large smp requests
    
    Instead of duplicating the smp request buffer reuse the one provided by
    libsas.  This future proofs the driver to support arbitrarily large smp
    requests, and shrinks the request structure size by ~700 bytes.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b5176891de77d9665fd3e04e7a83c4d0ee4415ac
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jun 21 16:23:03 2011 -0700

    isci: fix isci_task_execute_tmf completion
    
    1/ fix the timeout for wait_for_completion_timeout
    2/ In the tmf timeout case we need to wait for our termination callback
    3/ Once the request is successfully started it will be freed according to the
       normal lifetime for requests.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a92485d9a2f028dd15228e09a679d7dae83f4071
Author: Maciej Patelczyk <maciej.patelczyk@intel.com>
Date:   Tue Jun 21 22:03:13 2011 +0000

    isci: possible buffer overflow in isci_parse_oem_parameters fixed
    
    scu_index is a parameter of isci_parse_eom_parameters and is an index
    in controller table. There is a check: scu_index > SCI_MAX_CONTROLLERS
    which is insufficient and should be: scu_index >= SCI_MAX_CONTROLLERS.
    scu_index is used as an index in the table which size is
    SCI_MAX_CONTROLLERS.
    
    Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c5c64c6a3451868d87e6dbcb93d6f089043c411a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 23 23:44:52 2011 -0700

    isci: fix frame received locking
    
    Updates to the frame_rcvd before need to be atomic with respect to when
    they are evaluated by libsas.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 39353be0d680ff789be17285431fe898a100564d
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Thu Jun 23 17:09:02 2011 -0700

    isci: Terminate dev requests on FIS err bit rx in NCQ
    
    When the remote device transitions to a not-ready state because of
    an NCQ error condition, all outstanding requests to that device
    are terminated and completed to libsas on the normal path.  The
    device then waits for a READ LOG EXT command to issue on the task
    management path.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 78836d8907509fd464a33e37e628feb0fb7ebae4
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jun 17 14:25:00 2011 -0700

    isci: unify can_queue tracking on the tci_pool, uplevel tag assignment
    
    The tci_pool tracks our outstanding command slots which are also the 'index'
    portion of our tags.  Grabbing the tag early in ->lldd_execute_task let's us
    drop the isci_host_can_queue() and ->was_tag_assigned_by_user infrastructure.
    ->was_tag_assigned_by_user required the task context to be duplicated in
    request-local buffer.  With the tci established early we can build the
    task_context directly into its final location and skip a memcpy.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1c021c690d45b8b36d1536e9c28c1909f7fc443c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 23 14:33:48 2011 -0700

    isci: combine request flags
    
    Combine three bools into one unsigned long 'flags'.  Doesn't increase the
    request size due to packing. (to do: optimize the structure layout).
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 762b7eeb9c2dbb8da0de7f4c02b097cc1dc4edf8
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jun 17 14:18:39 2011 -0700

    isci: preallocate requests
    
    the dma_pool interface is optimized for object_size << page_size which
    is not the case with isci_request objects and the dma_pool routines show
    up in the top of the profile.
    
    The old io_request_table which tracked whether tci slots were in-flight
    or not is replaced with an IREQ_ACTIVE flag per request.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


