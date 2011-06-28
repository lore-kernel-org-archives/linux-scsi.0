From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT] isci: preparing for 3.0 pull request by week's end
Date: Tue, 28 Jun 2011 16:40:52 -0700
Message-ID: <1309304452.2758.18.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17711 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1F1Xkx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2011 19:40:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Jeff Garzik <jeff@garzik.org>, hare@suse.de, Dave Jiang <dave.jiang@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>

James, Christoph,

We are looking to get the cleanups completed by the end of the week, and
the tree has been updated with the latest progress.  The remaining work
is unifying the device and host objects, cleaning up duplicated fields,
more "should not be macros" deletion, and some straggling header files
with content smaller than the license header.

Showstoppers like scic_request_get_virt_addr() are deleted in this
update, but please take a look for other items that you expect will
jeopardize the driver's acceptance.

For the final submission-request my plan is to cc Linus again as I
expect he will want to revisit the same questions that were asked for
the 2.6.39 candidate.  I also expect a few notes about why the driver is
so large are needed (perhaps preparing those notes will identify a few
more cleanup ideas).

For reference we are:

 30 files changed, 3829 insertions(+), 5877 deletions(-)
 delete mode 100644 drivers/scsi/isci/pool.h
 delete mode 100644 drivers/scsi/isci/state_machine.c
 delete mode 100644 drivers/scsi/isci/state_machine.h
 delete mode 100644 drivers/scsi/isci/timers.c
 delete mode 100644 drivers/scsi/isci/timers.h

...since the 2.6.39 pull request.  With at least a few hundred more
lines to go with the known-pending work.

--
Dan for the isci driver team

The following changes since commit 39353be0d680ff789be17285431fe898a100564d:

  isci: Terminate dev requests on FIS err bit rx in NCQ (2011-06-23 23:47:07 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

Dan Williams (6):
      isci: unify can_queue tracking on the tci_pool, uplevel tag assignment
      isci: combine request flags
      isci: preallocate requests
      isci: rename / clean up scic_sds_stp_request
      isci: unify isci_request and scic_sds_request
      isci: unify isci_phy and scic_sds_phy

 drivers/scsi/isci/host.c                |  491 +++++--------
 drivers/scsi/isci/host.h                |   95 +--
 drivers/scsi/isci/phy.c                 |  481 ++++++------
 drivers/scsi/isci/phy.h                 |  112 +---
 drivers/scsi/isci/port.c                |  364 ++++------
 drivers/scsi/isci/port.h                |   24 +-
 drivers/scsi/isci/port_config.c         |  135 ++--
 drivers/scsi/isci/remote_device.c       |   99 ++--
 drivers/scsi/isci/remote_device.h       |    8 +-
 drivers/scsi/isci/remote_node_context.c |    4 +-
 drivers/scsi/isci/remote_node_context.h |    6 +-
 drivers/scsi/isci/request.c             | 1264 +++++++++++++------------------
 drivers/scsi/isci/request.h             |  346 ++-------
 drivers/scsi/isci/sata.c                |    9 +-
 drivers/scsi/isci/task.c                |  127 ++--
 15 files changed, 1405 insertions(+), 2160 deletions(-)

commit 8163f84751dab7101289400b2250f4b6677c3401
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jun 28 13:47:09 2011 -0700

    isci: unify can_queue tracking on the tci_pool, uplevel tag assignment
    
    The tci_pool tracks our outstanding command slots which are also the 'index'
    portion of our tags.  Grabbing the tag early in ->lldd_execute_task let's us
    drop the isci_host_can_queue() and ->was_tag_assigned_by_user infrastructure.
    ->was_tag_assigned_by_user required the task context to be duplicated in
    request-local buffer.  With the tci established early we can build the
    task_context directly into its final location and skip a memcpy.
    
    With the task context buffer at a known address at request construction we
    have the opportunity/obligation to also fix sgl handling.  This rework feels
    like it belongs in another patch but the sgl handling and task_context are too
    intertwined.
    1/ fix the 'ab' pair embedded in the task context to point to the 'cd' pair in
       the task context (previously we were prematurely linking to the staging
       buffer).
    2/ fix the broken iteration of pio sgls that assumes all sgls are relative to
       the request, and does a dangerous looking reverse lookup of physical
       address to virtual address.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a5c9144c2518c96fb480d7b3ed72c6e4a3994946
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 23 14:33:48 2011 -0700

    isci: combine request flags
    
    Combine three bools into one unsigned long 'flags'.  Doesn't increase the
    request size due to packing. (to do: optimize the structure layout).
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f41816b67f7e30d42f2d0c9ec61172e4b0250abc
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jun 17 14:18:39 2011 -0700

    isci: preallocate requests
    
    the dma_pool interface is optimized for object_size << page_size which
    is not the case with isci_request objects and the dma_pool routines show
    up in the top of the profile.
    
    The old io_request_table which tracked whether tci slots were in-flight
    or not is replaced with an IREQ_ACTIVE flag per request.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a925d841fb91a9180f986a2e4e4ce39b6229f405
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 27 11:56:41 2011 -0700

    isci: rename / clean up scic_sds_stp_request
    
    * Rename scic_sds_stp_request to isci_stp_request
    * Remove the unused fields and union indirection
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d65c9aef12eb01682ea9b429dc284cad9d3da349
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Jun 27 14:57:03 2011 -0700

    isci: unify isci_request and scic_sds_request
    
    They are one in the same object so remove the distinction.  The near
    duplicate fields (owning_controller, and isci_host) will be cleaned up
    after the scic_sds_contoller isci_host unification.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9f3d039c7f630c1f214fe9dad57d3afe3bbd4388
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Jun 28 15:05:53 2011 -0700

    isci: unify isci_phy and scic_sds_phy
    
    They are one in the same object so remove the distinction.  The near
    duplicate fields (owning_port, and isci_port) will be cleaned up
    after the scic_sds_port isci_port unification.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


