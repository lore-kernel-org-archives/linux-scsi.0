From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT] isci: final update for initial merge candidate
Date: Fri, 01 Jul 2011 14:17:55 -0700
Message-ID: <1309555075.10989.19.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48672 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757242Ab1GAVSG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jul 2011 17:18:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <JBottomley@parallels.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Christoph Hellwig <hch@lst.de>, Jeff Garzik <jeff@garzik.org>, hare@suse.de

The pull request message will be sent shortly, but here are the final
updates relative to the last release.

This completes the structural cleanup of the driver.  The primary
outstanding issue identified during the 2.6.39 pull request attempt was
the removal of the data structure distinction between the lldd and
'core' layers.  That work is complete as well some additional items
identified by Christoph:
1/ get/set macros with names longer than the open coded equivalent
2/ the scic_sds_ and scic_ prefixes which only had relevance if a 'core'
was being maintained
3/ fixing the silicon revision detection to be per-pci-device

Another indication that the major structural work has reached a
milestone is that the cleanups are no longer yielding the same 2:1
deletion-to-insertion ratio that has been the norm for all the previous
cleanup cycles.

--
Dan for the isci driver team

The following changes since commit 9f3d039c7f630c1f214fe9dad57d3afe3bbd4388:

  isci: unify isci_phy and scic_sds_phy (2011-06-28 16:06:40 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

Dan Williams (10):
      isci: fix scic_sds_remote_device_terminate_requests
      isci: unify isci_port and scic_sds_port
      isci: unify isci_remote_device and scic_sds_remote_device
      isci: unify isci_host and scic_sds_controller
      isci: retire scic_sds_ and scic_ prefixes
      isci: kill 'get/set' macros
      isci: merge sata.[ch] into request.c
      isci: merge scu_unsolicited_frame.h into unsolicited_frame_control.h
      isci: cleanup silicon revision detection
      isci: pare back error messsages

Jeff Skirvin (1):
      isci: Device reset should request sas_phy_reset(phy, true)

 drivers/scsi/isci/Makefile                    |    2 +-
 drivers/scsi/isci/host.c                      | 1474 +++++++++++--------------
 drivers/scsi/isci/host.h                      |  372 ++-----
 drivers/scsi/isci/init.c                      |   45 +-
 drivers/scsi/isci/isci.h                      |   11 +-
 drivers/scsi/isci/phy.c                       |  428 +++-----
 drivers/scsi/isci/phy.h                       |   87 +-
 drivers/scsi/isci/port.c                      |  972 +++++++----------
 drivers/scsi/isci/port.h                      |  247 ++---
 drivers/scsi/isci/port_config.c               |  257 ++---
 drivers/scsi/isci/probe_roms.c                |   22 +-
 drivers/scsi/isci/probe_roms.h                |   38 +-
 drivers/scsi/isci/remote_device.c             |  600 +++++------
 drivers/scsi/isci/remote_device.h             |  265 ++----
 drivers/scsi/isci/remote_node_context.c       |  228 ++--
 drivers/scsi/isci/remote_node_context.h       |   33 +-
 drivers/scsi/isci/remote_node_table.c         |  114 +-
 drivers/scsi/isci/remote_node_table.h         |   16 +-
 drivers/scsi/isci/request.c                   |  806 ++++++--------
 drivers/scsi/isci/request.h                   |  105 +--
 drivers/scsi/isci/sata.c                      |  232 ----
 drivers/scsi/isci/sata.h                      |   79 --
 drivers/scsi/isci/scu_unsolicited_frame.h     |  117 --
 drivers/scsi/isci/task.c                      |  241 +++--
 drivers/scsi/isci/task.h                      |   12 -
 drivers/scsi/isci/unsolicited_frame_control.c |   59 +-
 drivers/scsi/isci/unsolicited_frame_control.h |   89 ++-
 27 files changed, 2717 insertions(+), 4234 deletions(-)
 delete mode 100644 drivers/scsi/isci/sata.c
 delete mode 100644 drivers/scsi/isci/sata.h
 delete mode 100644 drivers/scsi/isci/scu_unsolicited_frame.h

commit 2599b8dd51ade5ea65edfe64872631390bb1f9a8
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Jun 29 09:45:48 2011 -0700

    isci: fix scic_sds_remote_device_terminate_requests
    
    Commit 0815632 "isci: unify remote_device stop_handlers" introduced the
    possibility that not all requests get terminated if we reach the
    request_count.  Now that we properly reference count devices we don't
    need this self-defense and can do the straightforward scan of all active
    requests.
    
    Reported-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Acked-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 06c9dca9aa7d12a4f2f27b4528ec4755e79a8990
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Jun 29 13:09:25 2011 -0700

    isci: unify isci_port and scic_sds_port
    
    Remove the distinction between these two implementations and unify on
    isci_port (local instances named iport).  The duplicate '->owning_port' and
    '->isci_port' in both isci_phy and isci_remote_device will be fixed in a later
    patch... this is just the straightforward rename/unification.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 449c7d287b4fe53769c1f8fa011cb243c27c77a6
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 30 16:31:37 2011 -0700

    isci: unify isci_remote_device and scic_sds_remote_device
    
    Remove the distinction between these two implementations and unify on
    isci_remote_device (local instances named idev).
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit eb1ac8cba091d697a3c8ec44ccb07b40e6735126
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 30 17:38:32 2011 -0700

    isci: unify isci_host and scic_sds_controller
    
    Remove the distinction between these two implementations and unify on
    isci_host (local instances named ihost).  Hmmm, we had two
    'oem_parameters' instances, one was unused... nice.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 87407dc569c211ffc2ca45c2b48c82c8258d7181
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Jun 30 19:14:33 2011 -0700

    isci: retire scic_sds_ and scic_ prefixes
    
    The distinction between scic_sds_ scic_ and sci_ are no longer relevant
    so just unify the prefixes on sci_.  The distinction between isci_ and
    sci_ is historically significant, and useful for comparing the old
    'core' to the current Linux driver. 'sci_' represents the former core as
    well as the routines that are closer to the hardware and protocol than
    their 'isci_' brethren. sci == sas controller interface.
    
    Also unwind the 'sds1' out of the parameter structs.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a02218e5c24b3351ed7d744a343c27a7868f16ed
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 1 02:25:15 2011 -0700

    isci: kill 'get/set' macros
    
    Most of these simple dereference macros are longer than their open coded
    equivalent.  Deleting enum sci_controller_mode is thrown in for good
    measure.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit dfd7f7850fb1c90c1cec6a807098aa9d81c34f4a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 1 10:52:55 2011 -0700

    isci: merge sata.[ch] into request.c
    
    Undo some needless separation.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit be2b524bbd3304000b7158403540a3984ea09d71
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 1 11:15:12 2011 -0700

    isci: merge scu_unsolicited_frame.h into unsolicited_frame_control.h
    
    Does not need its own file.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 936e6f9e6dbe27c5a7a1be9611e852ae5578ce0b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 1 11:41:21 2011 -0700

    isci: cleanup silicon revision detection
    
    Perform checking per-pci device (even though all systems will only have
    1 pci device in this generation), and delete support for silicon that
    does not report a proper revision (i.e. A0).
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit afdc34dd54cd78e14e131e2c933d9f515849120c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Jul 1 12:07:25 2011 -0700

    isci: pare back error messsages
    
    The messages emitted from task.c and some from request.c likely
    duplicate (in a less understandable way) what is reported by the
    midlayer.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4ab073e40a7dc6a542905de68f760c9e8e01bb91
Author: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Date:   Fri Jul 1 13:03:44 2011 -0700

    isci: Device reset should request sas_phy_reset(phy, true)
    
    The hard_reset parameter passed to the LLDD in the direct-attached
    phy control case allows the LLDD to filter link failure events
    while the direct-attached device reset is executing.
    
    Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>


