From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 0/6] isci: initial driver release (part1: intro and lldd)
Date: Sun, 06 Feb 2011 16:34:34 -0800
Message-ID: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48483 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab1BGAQm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2011 19:16:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

Introduction:
The upcoming Intel(R) C600 series Patsburg chipset family integrates
6Gb/s SAS capabilities.  Depending on the version up to two 4-port SAS
controllers will be presented.  This implementation does not utilize
firmware and relies on the driver to manage hardware state machines and
some protocol (to a higher degree than existing libsas drivers, more
details below).  The isci driver is divided into two components the lldd
layer which interfaces with libsas and the core which manages the
hardware state and protocol exceptions.  Development can be tracked
here:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git

This is an early release (fixes and reworks still in progress), but is
ready for community feedback.

Driver overview:
The hardware accelerates all the protocol fast paths (SSP, STP FPDMA and
UDMA), and relies on the the driver for everything else.  One example is
legacy sata pio reads which are managed "manually" by their own state
machine in the driver.  The driver submits the read and when the data
fis comes back the hardware, not having acceleration for pio operations,
assigns it to an unidentified frame queue.  The core then associates that
frame with the pending pio request, copies the data into the location
specified by the original sgl, and completes the command up to the lldd.

Responsibility for these types of exceptions and slow path cases are
what contribute to the size of the driver compared to its peers.
Although the overall diffstat of drivers/scsi/isci/ is currently:

	100 files changed, 51183 insertions(+), 0 deletions(-)

...the physical line count of the driver is around 23K [1], and expect
that number to drop further as the driver is cleaned up (see below).
 
Fixes and reworks overview (current todo list summary):
1/ The core handles the low level hardware interface and state machines,
   but it also grew "too high" with OS abstracted convenience functions at
   its interface to the lldd layer.  The interface routines in
   drivers/scsi/isci/deprecated.c are set for removal as the lldd layer
   pushes down to replace the OS abstracted core routines with a native
   implementation.

2/ Locking and lifetime (lldd_dev) issues in the lldd 

3/ dma_map and kmap (in the pio data in case)

4/ Type safety, identifier names, and remaining style issues.

Current code:
As can be seen by the shortlog of the git tree a number of cleanups and
reworks have already been applied, some of which would have made the
early review more difficult.

Dan Williams (34):
      isci: Kconfig and Makefile
      isci: Make silicon revision configurable
      isci: kill unused build options
      isci: kill unnecessary call to pci_disable_msix()
      isci: kill can queue device file
      isci: auto install isci firmware
      isci: clean up abort checks at submission
      isci: cleanup sci_base_state
      isci: controller state machine cleanup step1
      isci: readable io request state machines step1
      isci: controller state machine cleanup step2
      isci: controller state machine cleanup step3
      isci: kill off dubious usage of likely/unlikely
      isci: fix driver name string
      isci: kill ->dma_pool_name
      isci: use a module scope kmem_cache rather then per-host
      isci: kill isci_controller_init_names
      isci: rename dev_p to pdev
      isci: cleanup scic_remote_device_construct
      isci: __iomem annotations
      isci: remove 'library' dependency for initializing registers
      isci: refactor init to handle arbitrary controller layouts
      isci: move controller allocation to the core (kill isci_module_struct)
      isci: kill 'library' interface
      isci: fix ata protocol detection
      isci: use sas_protocol_ata
      isci: remove some host template debug overrides
      isci: drop isci_queuecommand
      isci: fix up queue parameters
      isci: allow the silicon revision to be specified at runtime
      isci: smp_request is too large for stack allocation
      isci: sci_object cleanup step1
      isci: drop redundant name from path
      isci: consolidate core

Dave Jiang (11):
      isci: Loading oem params through binary firmware instead of via module params
      isci: move initialization to managed device model
      isci: remove sci_environment.h file
      isci: Moved lld logging calls to dev_* calls
      isci: Remove logger in core and use appropriate dev_* calls
      isci: Removing ASSERT() calls and change them to BUG_ON()
      isci: Move pci mapping functions to dma mapping functions
      isci: Remove MIN/MAX macro and use native linux macros
      isci: remove special macros for upper and lower 32 bits
      isci: Removing over-enthusiastic gotos
      isci: clean up scic_cb_io_request_get_physical_address()

Edmund Nadolski (11):
      isci: remove extraneous typedefs/enums/comments from sci_types.h
      isci: remove SCI_TIMER_CALLBACK_T typedef
      isci: remove SCI_OBJECT_HANDLE_T typedef
      isci: remove SCI_TASK_REQUEST_HANDLE_T typedef
      isci: remove SCI_IO_REQUEST_HANDLE_T typedef
      isci: remove SCI_PHY_HANDLE_T typedef
      isci: fix typo recieved to received
      isci: remove SCI_PORT_HANDLE_T typedef
      isci: remove SCI_REMOTE_DEVICE_HANDLE_T typedef
      isci: remove SCI_MEMORY_DESCRIPTOR_HANDLE_T typedef
      isci: remove SCI_CONTROLLER_HANDLE_T typedef

  146 files changed, 16620 insertions(+), 26286 deletions(-)

The patches that follow this cover letter are a snapshot of the current
state of the lldd portion of the driver (with the above cleanups already
applied).  The core will follow later, and the full driver is always
available from the git url above.

Suggestions and comments welcome.

--
Dan for the isci driver team

[1]: generated using David A. Wheeler's 'SLOCCount'.
