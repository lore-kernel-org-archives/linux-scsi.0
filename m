From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] isci: sas controller driver for 3.0
Date: Fri, 01 Jul 2011 16:35:48 -0700
Message-ID: <1309563349.19567.26.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5335 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757869Ab1GAXfu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jul 2011 19:35:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, David Milburn <dmilburn@redhat.com>, Jeff Garzik <jeff@garzik.org>, Jacek Danecki <jacek.danecki@intel.com>, hare@suse.de

James, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

...to receive the isci driver that supports the integrated 6Gb/s SAS
capabilities of the upcoming Intel(R) C600 series chipset family.  This
part is targeted at standard servers / workstations and provides
up to 8-ports (2x4-port controllers) of SAS beyond the traditional SATA
ports (surfaced by the ahci driver).

Since the last merge candidate [1], the driver has shed an additional
3,500 lines of code:

 34 files changed, 5683 insertions(+), 9248 deletions(-)
 delete mode 100644 drivers/scsi/isci/pool.h
 delete mode 100644 drivers/scsi/isci/sata.c
 delete mode 100644 drivers/scsi/isci/sata.h
 delete mode 100644 drivers/scsi/isci/scu_unsolicited_frame.h
 delete mode 100644 drivers/scsi/isci/state_machine.c
 delete mode 100644 drivers/scsi/isci/state_machine.h
 delete mode 100644 drivers/scsi/isci/timers.c
 delete mode 100644 drivers/scsi/isci/timers.h

Thanks again goes to Christoph for his continued review of the driver.

There was a question in the last pull request about the why this driver
is the size that it is.  According to physical lines of source [2] the
isci driver is now ~1.3x the size of the next largest libsas driver
aic94xx.  Looking over that driver there are several additional
responsibilities that the hardware requires of isci:

1/ OOB management: the sequencing to bring the phys, perform speed
negotiation at all the operation points and handle spin-up ordering is
controlled by software.

2/ Non-fast path protocols: All non-fast path i/o protocols and
conditions (smp, sata-pio, atapi, errors/exceptions) are handled in
software (allowing more hardware resources to be dedicated to the fast
path)

3/ Port configuration and oem parameters: Since this controller is
embedded in the chipset and not a standalone hba the electrical
characteristics of the phys need to be tuned per platform.  The platform
vendor also has the option to customize the port configuration.
Enabling patches like pci_map_biosrom() allow the driver to retrieve
these parameters embedded in the platform BIOS/EFI driver.  We have a
binary blob firmware file that can be used as a backup for these
parameters.

There are still opportunities for code simplification, but we are
starting to approach the underlying complexity of the solution.  In any
event, the diffstat since the initial import makes all the late nights
seem worth it:

   192 files changed, 23575 insertions(+), 60895 deletions(-)

--
Dan for the isci driver team

[1]: http://marc.info/?l=linux-scsi&m=130531654412722&w=2
[2]: generated using David A. Wheeler's 'SLOCCount'.

Adam Gruchala (2):
      isci: merge phy substates
      isci: Added support for C0 to SCU Driver

Artur Wojcik (1):
      isci: unify isci_host data structures

Bartosz Barcinski (2):
      isci: sparse warnings cleanup
      isci: audit usage of BUG_ON macro in isci driver

Christoph Hellwig (7):
      isci: remove mmio wrappers
      isci: remove base_controller abstraction
      isci: remove base_request abstraction
      isci: kill dead data structurs in scic_io_request.h
      isci: simplify request state handlers
      isci: simplify dma coherent allocation
      isci: remove scic_controller state handlers

Dan Williams (187):
      libsas: fix definition of wideport, include local sas address
      isci: import baseline driver with automated conversions
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
      isci: kill SCI_IO_REQUEST_DATA_DIRECTION
      isci: cleanup core consolidation leftovers
      isci: kill a callback cast
      isci: remove SCIC_DEBUG_ENABLED, and fixup an odd macro
      isci: bypass scic_controller_get_handler_methods()
      isci: cleanup "starting" state handling
      isci: implement error isr
      isci: advertise linkrate
      isci: debug fixes
      isci: phy state machine cleanup step1
      isci: clean up remaining silicon revision ifdefs in phy init
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
      x86: introduce pci_map_biosrom()
      isci: Add support for probing OROM for OEM params
      isci: fixup with testing from isci OROM in BIOS
      isci: Errors in the submit path for SATA devices manage the ap lock.
      isci: add "isci_id" attribute
      isci: fix incorrect assumptions about task->dev and task->dev->port being NULL
      isci: task.h compile and checkpatch fixes
      isci: fix oem parameter initialization and mode detection
      Revert "isci: SATA/STP and SMP tasks are never explicitly put in the error path."
      Revert "isci: only call sas_task_abort for tasks with NEED_DEV_RESET"
      isci: reset hardware at init
      isci: fix apc mode definition
      isci: fix a build warning
      Merge branch 'x86-pending' into devel
      isci: reorder init to cleanup unneeded declarations
      isci: kill some long macros
      isci: namespacecheck cleanups
      isci: remove unused "remote_device_started"
      isci: cleanup isci_remote_device[_not]_ready interface
      isci: fix fragile/conditional isci_host lookups
      isci: replace sci_sas_link_rate with sas_linkrate
      Merge commit 'v2.6.38' into devel
      isci: fix oem parameter header definition
      isci: validate oem parameters early, and fallback
      isci: rely on irq core for intx multiplexing, and silence screaming intx
      isci: make a remote_node_context a proper member of a remote_device
      isci: remove rnc->device back pointer
      isci: unify remote_device data structures
      isci: move remote_device handling out of the core
      isci: cleanup remote device construction and comments
      isci: kill smp_discover_response_protocols in favor of domain_device.dev_type
      isci: kill smp_discover_response
      isci: remove usage of sci_sas_address in scic_sds_remote_device
      isci: remove scic_sds_remote_device_get_port_index
      isci: allow fallback to option-rom if efi variable retrieval fails
      isci: defer pci_map_biosrom
      isci: fix CONFIG_EFI=n compile error
      isci: merge remote_device substates into a single state machine
      isci: kill scic_remote_device_get_connection_rate
      isci: fix remote_device start_io regressions
      isci: unify remote_device start_handlers
      isci: unify remote_device stop_handlers
      isci: kill remote_device fail_handler
      isci: unify remote_device destruct_handlers
      isci: unify remote_device reset_handlers
      isci: unify remote_device reset_complete_handlers
      isci: unify remote_device start_io_handlers
      isci: unify remote_device complete_io_handlers
      isci: kill remote_device continue_io_handler
      isci: unify remote_device start_task_handlers
      isci: kill remote_device complete_task_handler
      isci: unify remote_device suspend_handlers
      isci: kill remote_device resume_handler
      isci: unify remote_device event_handlers
      isci: unify remote_device frame_handlers
      isci: kill scic_sds_remote_device.state_handlers
      isci: remove compile-time (Kconfig) silicon configuration
      isci: fix ata locking
      isci: implement I_T_nexus_reset
      isci: unify phy data structures
      isci: unify port data structures
      isci: move stp request info to scic_sds_request
      isci: make sgl explicit/aligned request object member
      isci: move task context alignment from run-time to compile time
      isci: make command/response iu explicit request object members
      isci: unify request data structures
      isci: unify constants
      isci: move core/controller to host
      isci: uplevel register hardware data structures and unsolicited frame handling
      isci: uplevel state machine
      isci: uplevel request infrastructure
      isci: uplevel phy infrastructure
      isci: uplevel port infrastructure
      isci: merge ssp task management substates into primary state machine
      isci: merge smp request substates into primary state machine
      isci: merge stp request substates into primary state machine
      isci: unify request abort handlers
      isci: unify request frame handlers
      isci: remove request task context completion state handler
      isci: remove the completion and event state handlers
      isci: unify phy start handlers
      isci: unify phy stop handlers
      isci: unify phy reset handlers
      isci: remove phy destruct handlers
      isci: unify phy frame handlers
      isci: unify phy event handlers
      isci: unify phy consume_power handlers
      isci: clarify phy to port lookups
      isci: unify port start_io and complete_io handlers
      isci: unify rnc event handlers
      isci: unify rnc destruct handlers
      isci: unify rnc suspend/resume handlers
      isci: unify rnc start{io|task} handlers
      isci: add some type safety to the state machine interface
      Revert "isci: Add missing PCI IDs"
      isci: remove 'min memory' infrastructure
      Merge commit 'v3.0-rc2' into devel
      isci: use pci_map_biosrom
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
      isci: unify can_queue tracking on the tci_pool, uplevel tag assignment
      isci: combine request flags
      isci: preallocate requests
      isci: rename / clean up scic_sds_stp_request
      isci: unify isci_request and scic_sds_request
      isci: unify isci_phy and scic_sds_phy
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

Darrick J. Wong (1):
      libsas: Don't issue commands to devices that have been hot-removed

Dave Jiang (49):
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
      isci: removing unused loglevel module param
      isci: Move firmware loading to per PCI device
      isci: Removed special macros that does 64bit address math
      isci: Make the driver copy data directly from and to sg for PIO
      isci: have the driver use native SG calls and DMA-API
      isci: Change event notify calls from scic_cb_* to isci_event_*
      isci: Removing deprecated functions
      isci: Adding support for phy enable and disable
      isci: Cleanup warning messages for phy resets
      isci: Adding EFI variable skeletal support
      isci: update efi variable name and guid
      isci: copy the oem parameters instead of assign
      isci: Fixup for OEM parameter EFI variable retrieval
      isci: exposing user parameters via module params
      isci: Remove event_* calls as they are just wrappers
      isci: Remove "screaming" data types
      isci: replace this_* and the_* variables with more meaningful names
      isci: removing non-working ATAPI code
      isci: Remove excessive log noise with expander hot-unplug
      isci: Removing unused define SCIC_SDS_4_ENABLED
      isci: Convert SATA fis data structures to Linux native
      isci: Convert ATA defines to Linux native defines
      isci: Convert SAS identify address frame to Linux Native format
      isci: Collapsing of phy_type data structure
      isci: renaming sas_capabilities to scic_phy_cap
      isci: Fixup SSP command IU and task IU
      isci: Convert of sci_ssp_response_iu to ssp_response_iu
      isci: Fixup of smp request
      isci: Converting smp_response to Linux native smp_resp
      isci: remove redundant copies of IAF
      isci: fixup SAS iaf protocols data structure
      isci: Remove SCIC_SWAP_DWORD()
      isci: Using Linux SSP frame header
      isci: removing intel_*.h headers
      isci: Removing unnecessary functions in request.c
      isci: removing the kmalloc in smp request construct
      isci: Retrieve the EFI variable for OEM parameter
      isci: Removing unused variables compiler warnings

Edmund Nadolski (28):
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
      isci: remove unused SC_LIBRARY_HANDLE_T typedef
      isci: remove SCI_INVALID_HANDLE
      isci: kill sci_types.h
      isci: enable interrupts during controller start, and flush discovery
      isci: remove scic_controller_get_handler_methods and ilk
      isci: kill scic_controller_get_port_handle function
      isci: remove scic_sds_port_increment_request_count
      isci: replace isci_timer list with proper embedded timers
      isci: convert port config agent timer to sci_timer
      isci: convert phy sata_timeout_timer to sci_timer
      isci: convert power control timer to sci_timer
      isci: convert scic_timeout_timer to sci_timer
      isci: convert phy_startup_timer to sci_timer
      isci: Remove tmf timeout_timer
      isci: remove isci_timer interface
      isci: state machine cleanup
      isci: additional state machine cleanup

Havard Skinnemoen (2):
      isci: Add missing PCI IDs
      isci: Initialize proc_name field in scsi_host_template

Henryk Dembkowski (6):
      isci: remote device and node cleanup step1
      isci: coding style changes for remote device
      isci: c99 tables cleanup step1
      isci: coding style changes for remote device
      isci: Move transport layer registers from port to phy
      isci: add support for 2 more oem parmeters

Jacek Danecki (2):
      isci: Add support for user parameters in SCIC layer
      isci: rnc state machine table c99 conversion

Jack Wang (1):
      [SCSI] libsas: fix bug for vacant phy

Jeff Skirvin (29):
      isci: isci_request_cleanup_completed_loiterer checks task before task_done
      isci: Changes in isci_host_completion_routine
      isci: fix completion / abort path.
      isci: Any reset indicated on an I/O completion escalates it to the error path.
      isci: save the i/o tag outside the scic request structure.
      isci: Cleaning up task execute path.
      isci: Code review change for completion pointer cleanup.
      isci: Termination handling cleanup, added termination timeouts.
      isci: Fix TMF build for SAS/SATA LUN reset cases.
      isci: Fixed BUG_ON in isci_abort_task_process_cb callback.
      isci: Always set response/status for requests going into the error path.
      isci: All pending requests are terminated before stopping the device.
      isci: don't hold scic_lock over calls to sas_task_abort()
      isci: only call sas_task_abort for tasks with NEED_DEV_RESET
      isci: SATA/STP and SMP tasks are never explicitly put in the error path.
      isci: Properly handle requests in the "aborting" state.
      isci: Free host lock for SATA/STP abort escalation at submission time.
      isci: Fix use of SATA soft reset state machine.
      isci: Qualify when the host lock is managed for STP/SATA callbacks.
      isci: Move the reset delay after the remote node resumption.
      isci: filter broadcast change notifications during SMP phy resets
      isci: Add decode for SMP request retry error condition
      isci: Requests that do not start must be set to "complete"
      isci: Handle timed-out request terminations correctly
      isci: Explicitly decode remote node ready and suspended states
      isci: Hard reset failure will link reset all phys in the port
      isci: Disable link layer hang detection
      isci: Terminate dev requests on FIS err bit rx in NCQ
      isci: Device reset should request sas_phy_reset(phy, true)

Maciej Patelczyk (10):
      isci: Implement SCU AFE recipe 10.
      isci: Removed struct sci_base_object from state machine.
      isci: Removed sci_base_object from scic_sds_controller.
      isci: Removed sci_base_object from scic_sds_phy.
      isci: Removed sci_base_object from scic_sds_port.
      isci: Removed sci_base_object from scic_sds_remote_device.
      isci: Removed sci_base_object from scic_sds_remote_node_context.
      isci: Removed sci_base_object from scic_sds_request.
      isci: Removed sci_object.h from project.
      isci: possible buffer overflow in isci_parse_oem_parameters fixed

Maciej Trela (3):
      isci: remove base_remote_device abstraction
      isci: remove base_port abstraction
      isci: remove base_phy abstraction

Pawel Marek (1):
      isci: controller stop/start fixes

Piotr Sawicki (11):
      isci: fix for asserts during aborts/resets to SAS/SATA in APC mode
      isci: handle cases where a d2h fis is used report an ncq error
      isci: unify request start handlers
      isci: c99 port state handlers
      isci: merge port ready substates into primary state machine
      isci: remove port start handler
      isci: unify port stop handlers
      isci: remove port destruct handler
      isci: unify port reset, add_phy, and remove_phy handlers
      isci: remove port frame and event handlers
      isci: unify port link_up and link_down handlers

Tomasz Chudy (3):
      isci: fix "no outbound task timeout" default value
      isci: Add Support for new TC completion codes
      isci: workaround port task scheduler starvation issue

 drivers/scsi/Kconfig                          |   13 +
 drivers/scsi/Makefile                         |    1 +
 drivers/scsi/isci/Makefile                    |    8 +
 drivers/scsi/isci/firmware/Makefile           |   19 +
 drivers/scsi/isci/firmware/README             |   36 +
 drivers/scsi/isci/firmware/create_fw.c        |   99 +
 drivers/scsi/isci/firmware/create_fw.h        |   77 +
 drivers/scsi/isci/host.c                      | 2751 ++++++++++++++++++++
 drivers/scsi/isci/host.h                      |  542 ++++
 drivers/scsi/isci/init.c                      |  565 ++++
 drivers/scsi/isci/isci.h                      |  538 ++++
 drivers/scsi/isci/phy.c                       | 1312 ++++++++++
 drivers/scsi/isci/phy.h                       |  504 ++++
 drivers/scsi/isci/port.c                      | 1757 +++++++++++++
 drivers/scsi/isci/port.h                      |  306 +++
 drivers/scsi/isci/port_config.c               |  754 ++++++
 drivers/scsi/isci/probe_roms.c                |  242 ++
 drivers/scsi/isci/probe_roms.h                |  249 ++
 drivers/scsi/isci/registers.h                 | 1934 ++++++++++++++
 drivers/scsi/isci/remote_device.c             | 1501 +++++++++++
 drivers/scsi/isci/remote_device.h             |  352 +++
 drivers/scsi/isci/remote_node_context.c       |  627 +++++
 drivers/scsi/isci/remote_node_context.h       |  224 ++
 drivers/scsi/isci/remote_node_table.c         |  598 +++++
 drivers/scsi/isci/remote_node_table.h         |  188 ++
 drivers/scsi/isci/request.c                   | 3391 +++++++++++++++++++++++++
 drivers/scsi/isci/request.h                   |  448 ++++
 drivers/scsi/isci/sas.h                       |  219 ++
 drivers/scsi/isci/scu_completion_codes.h      |  283 ++
 drivers/scsi/isci/scu_event_codes.h           |  336 +++
 drivers/scsi/isci/scu_remote_node_context.h   |  229 ++
 drivers/scsi/isci/scu_task_context.h          |  942 +++++++
 drivers/scsi/isci/task.c                      | 1675 ++++++++++++
 drivers/scsi/isci/task.h                      |  367 +++
 drivers/scsi/isci/unsolicited_frame_control.c |  225 ++
 drivers/scsi/isci/unsolicited_frame_control.h |  278 ++
 firmware/Makefile                             |    1 +
 firmware/isci/isci_firmware.bin.ihex          |   16 +
 38 files changed, 23607 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/isci/Makefile
 create mode 100644 drivers/scsi/isci/firmware/Makefile
 create mode 100644 drivers/scsi/isci/firmware/README
 create mode 100644 drivers/scsi/isci/firmware/create_fw.c
 create mode 100644 drivers/scsi/isci/firmware/create_fw.h
 create mode 100644 drivers/scsi/isci/host.c
 create mode 100644 drivers/scsi/isci/host.h
 create mode 100644 drivers/scsi/isci/init.c
 create mode 100644 drivers/scsi/isci/isci.h
 create mode 100644 drivers/scsi/isci/phy.c
 create mode 100644 drivers/scsi/isci/phy.h
 create mode 100644 drivers/scsi/isci/port.c
 create mode 100644 drivers/scsi/isci/port.h
 create mode 100644 drivers/scsi/isci/port_config.c
 create mode 100644 drivers/scsi/isci/probe_roms.c
 create mode 100644 drivers/scsi/isci/probe_roms.h
 create mode 100644 drivers/scsi/isci/registers.h
 create mode 100644 drivers/scsi/isci/remote_device.c
 create mode 100644 drivers/scsi/isci/remote_device.h
 create mode 100644 drivers/scsi/isci/remote_node_context.c
 create mode 100644 drivers/scsi/isci/remote_node_context.h
 create mode 100644 drivers/scsi/isci/remote_node_table.c
 create mode 100644 drivers/scsi/isci/remote_node_table.h
 create mode 100644 drivers/scsi/isci/request.c
 create mode 100644 drivers/scsi/isci/request.h
 create mode 100644 drivers/scsi/isci/sas.h
 create mode 100644 drivers/scsi/isci/scu_completion_codes.h
 create mode 100644 drivers/scsi/isci/scu_event_codes.h
 create mode 100644 drivers/scsi/isci/scu_remote_node_context.h
 create mode 100644 drivers/scsi/isci/scu_task_context.h
 create mode 100644 drivers/scsi/isci/task.c
 create mode 100644 drivers/scsi/isci/task.h
 create mode 100644 drivers/scsi/isci/unsolicited_frame_control.c
 create mode 100644 drivers/scsi/isci/unsolicited_frame_control.h
 create mode 100644 firmware/isci/isci_firmware.bin.ihex



