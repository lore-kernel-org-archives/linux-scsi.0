From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] scsi fixes for 3.0-rc5
Date: Mon, 04 Jul 2011 16:00:16 -0500
Message-ID: <1309813216.2606.32.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59970 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab1GDVAU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2011 17:00:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a couple of driver fixes and the addition of the isci intel SAS
driver under the new driver merge exception.  The isci tree is cleanly
separated with everything under drivers/scsi/isci (plus the
Makefile/Kconfig plumbing and one firmware file under firmware/isci).
The driver itself weighs in at around 23k lines, which is on the heavy
side, but Christoph Hellwig and I think it's ready enough to accept now
so that we have a working driver by the time the motherboards ship
(estimated to be in the 3.0 release timeframe).

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The shortlog for just the driver fixes (lest they get lost in the flood) is:

Brian King (1):
      ibmvfc: Fix Virtual I/O failover hang

Stephen M. Cameron (2):
      hpsa: fix potential overrun while memcpy'ing sense data
      hpsa: fix dma unmap error in hpsa_passthru_ioctl

The full changelog is:

Adam Gruchala (2):
      isci: Added support for C0 to SCU Driver
      isci: merge phy substates

Artur Wojcik (1):
      isci: unify isci_host data structures

Bartosz Barcinski (2):
      isci: audit usage of BUG_ON macro in isci driver
      isci: sparse warnings cleanup

Brian King (1):
      ibmvfc: Fix Virtual I/O failover hang

Christoph Hellwig (7):
      isci: remove scic_controller state handlers
      isci: simplify dma coherent allocation
      isci: simplify request state handlers
      isci: kill dead data structurs in scic_io_request.h
      isci: remove base_request abstraction
      isci: remove base_controller abstraction
      isci: remove mmio wrappers

Dan Williams (142):
      isci: pare back error messsages
      isci: cleanup silicon revision detection
      isci: merge scu_unsolicited_frame.h into unsolicited_frame_control.h
      isci: merge sata.[ch] into request.c
      isci: kill 'get/set' macros
      isci: retire scic_sds_ and scic_ prefixes
      isci: unify isci_host and scic_sds_controller
      isci: unify isci_remote_device and scic_sds_remote_device
      isci: unify isci_port and scic_sds_port
      isci: fix scic_sds_remote_device_terminate_requests
      isci: unify isci_phy and scic_sds_phy
      isci: unify isci_request and scic_sds_request
      isci: rename / clean up scic_sds_stp_request
      isci: preallocate requests
      isci: combine request flags
      isci: unify can_queue tracking on the tci_pool, uplevel tag assignment
      isci: fix frame received locking
      isci: fix isci_task_execute_tmf completion
      isci: fix support for arbitrarily large smp requests
      isci: fix dma_unmap_sg usage
      isci: fix smp response frame overrun
      isci: kill device_sequence
      isci: kill isci_remote_device_change_state()
      isci: atomic device lookup and reference counting
      isci: fix ssp response iu buffer size in isci_tmf
      isci: cleanup request allocation
      isci: cleanup/optimize queue increment macros
      isci: cleanup tag macros
      isci: cleanup/optimize pool implementation
      isci: fix isci_terminate_pending() list management
      isci: remove 'min memory' infrastructure
      isci: add some type safety to the state machine interface
      isci: unify rnc start{io|task} handlers
      isci: unify rnc suspend/resume handlers
      isci: unify rnc destruct handlers
      isci: unify rnc event handlers
      isci: unify port start_io and complete_io handlers
      isci: clarify phy to port lookups
      isci: unify phy consume_power handlers
      isci: unify phy event handlers
      isci: unify phy frame handlers
      isci: remove phy destruct handlers
      isci: unify phy reset handlers
      isci: unify phy stop handlers
      isci: unify phy start handlers
      isci: remove the completion and event state handlers
      isci: remove request task context completion state handler
      isci: unify request frame handlers
      isci: unify request abort handlers
      isci: merge stp request substates into primary state machine
      isci: merge smp request substates into primary state machine
      isci: merge ssp task management substates into primary state machine
      isci: uplevel port infrastructure
      isci: uplevel phy infrastructure
      isci: uplevel request infrastructure
      isci: uplevel state machine
      isci: uplevel register hardware data structures and unsolicited frame handling
      isci: move core/controller to host
      isci: unify constants
      isci: unify request data structures
      isci: make command/response iu explicit request object members
      isci: move task context alignment from run-time to compile time
      isci: make sgl explicit/aligned request object member
      isci: move stp request info to scic_sds_request
      isci: unify port data structures
      isci: unify phy data structures
      isci: implement I_T_nexus_reset
      isci: fix ata locking
      isci: remove compile-time (Kconfig) silicon configuration
      isci: kill scic_sds_remote_device.state_handlers
      isci: unify remote_device frame_handlers
      isci: unify remote_device event_handlers
      isci: kill remote_device resume_handler
      isci: unify remote_device suspend_handlers
      isci: kill remote_device complete_task_handler
      isci: unify remote_device start_task_handlers
      isci: kill remote_device continue_io_handler
      isci: unify remote_device complete_io_handlers
      isci: unify remote_device start_io_handlers
      isci: unify remote_device reset_complete_handlers
      isci: unify remote_device reset_handlers
      isci: unify remote_device destruct_handlers
      isci: kill remote_device fail_handler
      isci: unify remote_device stop_handlers
      isci: unify remote_device start_handlers
      isci: fix remote_device start_io regressions
      isci: kill scic_remote_device_get_connection_rate
      isci: merge remote_device substates into a single state machine
      isci: allow fallback to option-rom if efi variable retrieval fails
      isci: remove scic_sds_remote_device_get_port_index
      isci: remove usage of sci_sas_address in scic_sds_remote_device
      isci: kill smp_discover_response
      isci: kill smp_discover_response_protocols in favor of domain_device.dev_type
      isci: cleanup remote device construction and comments
      isci: move remote_device handling out of the core
      isci: unify remote_device data structures
      isci: remove rnc->device back pointer
      isci: make a remote_node_context a proper member of a remote_device
      isci: rely on irq core for intx multiplexing, and silence screaming intx
      isci: validate oem parameters early, and fallback
      isci: fix oem parameter header definition
      isci: replace sci_sas_link_rate with sas_linkrate
      isci: fix fragile/conditional isci_host lookups
      isci: cleanup isci_remote_device[_not]_ready interface
      isci: remove unused "remote_device_started"
      isci: namespacecheck cleanups
      isci: kill some long macros
      isci: reorder init to cleanup unneeded declarations
      isci: fix a build warning
      isci: fix apc mode definition
      isci: fix oem parameter initialization and mode detection
      isci: fixup with testing from isci OROM in BIOS
      isci: Add support for probing OROM for OEM params
      isci: reset hardware at init
      isci: task.h compile and checkpatch fixes
      isci: fix incorrect assumptions about task->dev and task->dev->port being NULL
      isci: add "isci_id" attribute
      isci: Errors in the submit path for SATA devices manage the ap lock.
      isci: cleanup debug leftovers in isci.h
      isci: replace remote_device_lock  with scic_lock
      isci: preallocate remote devices
      isci: replace isci_remote_device completion with event queue
      isci: kill "host quiesce" mechanism
      isci: remove sci_device_handle
      isci: kill isci_host list in favor of an array
      isci: enable isci for dmar builds
      isci: pad stp and smp request sizes
      isci: fix hang after target reset
      isci: rework timer api
      isci: fix sas address reporting
      isci: clean up remaining silicon revision ifdefs in phy init
      isci: phy state machine cleanup step1
      isci: debug fixes
      isci: advertise linkrate
      isci: implement error isr
      isci: cleanup "starting" state handling
      isci: bypass scic_controller_get_handler_methods()
      isci: remove SCIC_DEBUG_ENABLED, and fixup an odd macro
      isci: kill a callback cast
      isci: cleanup core consolidation leftovers
      isci: kill SCI_IO_REQUEST_DATA_DIRECTION
      isci: Intel(R) C600 Series Chipset Storage Control Unit Driver

Dave Jiang (38):
      isci: Removing unused variables compiler warnings
      isci: Retrieve the EFI variable for OEM parameter
      isci: removing the kmalloc in smp request construct
      isci: Removing unnecessary functions in request.c
      isci: removing intel_*.h headers
      isci: Using Linux SSP frame header
      isci: Remove SCIC_SWAP_DWORD()
      isci: fixup SAS iaf protocols data structure
      isci: remove redundant copies of IAF
      isci: Converting smp_response to Linux native smp_resp
      isci: Fixup of smp request
      isci: Convert of sci_ssp_response_iu to ssp_response_iu
      isci: Fixup SSP command IU and task IU
      isci: renaming sas_capabilities to scic_phy_cap
      isci: Collapsing of phy_type data structure
      isci: Convert SAS identify address frame to Linux Native format
      isci: Convert ATA defines to Linux native defines
      isci: Convert SATA fis data structures to Linux native
      isci: Removing unused define SCIC_SDS_4_ENABLED
      isci: Remove excessive log noise with expander hot-unplug
      isci: removing non-working ATAPI code
      isci: replace this_* and the_* variables with more meaningful names
      isci: Remove "screaming" data types
      isci: Remove event_* calls as they are just wrappers
      isci: exposing user parameters via module params
      isci: Fixup for OEM parameter EFI variable retrieval
      isci: copy the oem parameters instead of assign
      isci: update efi variable name and guid
      isci: Adding EFI variable skeletal support
      isci: Cleanup warning messages for phy resets
      isci: Adding support for phy enable and disable
      isci: Removing deprecated functions
      isci: Change event notify calls from scic_cb_* to isci_event_*
      isci: have the driver use native SG calls and DMA-API
      isci: Make the driver copy data directly from and to sg for PIO
      isci: Removed special macros that does 64bit address math
      isci: Move firmware loading to per PCI device
      isci: removing unused loglevel module param

Edmund Nadolski (17):
      isci: additional state machine cleanup
      isci: state machine cleanup
      isci: remove isci_timer interface
      isci: Remove tmf timeout_timer
      isci: convert phy_startup_timer to sci_timer
      isci: convert scic_timeout_timer to sci_timer
      isci: convert power control timer to sci_timer
      isci: convert phy sata_timeout_timer to sci_timer
      isci: convert port config agent timer to sci_timer
      isci: replace isci_timer list with proper embedded timers
      isci: remove scic_sds_port_increment_request_count
      isci: kill scic_controller_get_port_handle function
      isci: remove scic_controller_get_handler_methods and ilk
      isci: enable interrupts during controller start, and flush discovery
      isci: kill sci_types.h
      isci: remove SCI_INVALID_HANDLE
      isci: remove unused SC_LIBRARY_HANDLE_T typedef

Havard Skinnemoen (1):
      isci: Initialize proc_name field in scsi_host_template

Henryk Dembkowski (6):
      isci: add support for 2 more oem parmeters
      isci: Move transport layer registers from port to phy
      isci: coding style changes for remote device
      isci: c99 tables cleanup step1
      isci: coding style changes for remote device
      isci: remote device and node cleanup step1

Jacek Danecki (2):
      isci: rnc state machine table c99 conversion
      isci: Add support for user parameters in SCIC layer

James Bottomley (1):
      isci: fix checkpatch errors

Jeff Skirvin (27):
      isci: Device reset should request sas_phy_reset(phy, true)
      isci: Terminate dev requests on FIS err bit rx in NCQ
      isci: Disable link layer hang detection
      isci: Hard reset failure will link reset all phys in the port
      isci: Explicitly decode remote node ready and suspended states
      isci: Handle timed-out request terminations correctly
      isci: Requests that do not start must be set to "complete"
      isci: Add decode for SMP request retry error condition
      isci: filter broadcast change notifications during SMP phy resets
      isci: Move the reset delay after the remote node resumption.
      isci: Qualify when the host lock is managed for STP/SATA callbacks.
      isci: Fix use of SATA soft reset state machine.
      isci: Free host lock for SATA/STP abort escalation at submission time.
      isci: Properly handle requests in the "aborting" state.
      isci: don't hold scic_lock over calls to sas_task_abort()
      isci: All pending requests are terminated before stopping the device.
      isci: Always set response/status for requests going into the error path.
      isci: Fixed BUG_ON in isci_abort_task_process_cb callback.
      isci: Fix TMF build for SAS/SATA LUN reset cases.
      isci: Termination handling cleanup, added termination timeouts.
      isci: Code review change for completion pointer cleanup.
      isci: Cleaning up task execute path.
      isci: save the i/o tag outside the scic request structure.
      isci: Any reset indicated on an I/O completion escalates it to the error path.
      isci: fix completion / abort path.
      isci: Changes in isci_host_completion_routine
      isci: isci_request_cleanup_completed_loiterer checks task before task_done

Maciej Patelczyk (10):
      isci: possible buffer overflow in isci_parse_oem_parameters fixed
      isci: Removed sci_object.h from project.
      isci: Removed sci_base_object from scic_sds_request.
      isci: Removed sci_base_object from scic_sds_remote_node_context.
      isci: Removed sci_base_object from scic_sds_remote_device.
      isci: Removed sci_base_object from scic_sds_port.
      isci: Removed sci_base_object from scic_sds_phy.
      isci: Removed sci_base_object from scic_sds_controller.
      isci: Removed struct sci_base_object from state machine.
      isci: Implement SCU AFE recipe 10.

Maciej Trela (3):
      isci: remove base_phy abstraction
      isci: remove base_port abstraction
      isci: remove base_remote_device abstraction

Pawel Marek (1):
      isci: controller stop/start fixes

Piotr Sawicki (11):
      isci: unify port link_up and link_down handlers
      isci: remove port frame and event handlers
      isci: unify port reset, add_phy, and remove_phy handlers
      isci: remove port destruct handler
      isci: unify port stop handlers
      isci: remove port start handler
      isci: merge port ready substates into primary state machine
      isci: c99 port state handlers
      isci: unify request start handlers
      isci: handle cases where a d2h fis is used report an ncq error
      isci: fix for asserts during aborts/resets to SAS/SATA in APC mode

Stephen M. Cameron (2):
      hpsa: fix potential overrun while memcpy'ing sense data
      hpsa: fix dma unmap error in hpsa_passthru_ioctl

Tomasz Chudy (3):
      isci: workaround port task scheduler starvation issue
      isci: Add Support for new TC completion codes
      isci: fix "no outbound task timeout" default value

And the diffstat:

 drivers/scsi/Kconfig                          |   13 +
 drivers/scsi/Makefile                         |    1 +
 drivers/scsi/hpsa.c                           |   16 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                |    4 +-
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
 drivers/scsi/isci/probe_roms.c                |  243 ++
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
 drivers/scsi/isci/task.c                      | 1676 ++++++++++++
 drivers/scsi/isci/task.h                      |  367 +++
 drivers/scsi/isci/unsolicited_frame_control.c |  225 ++
 drivers/scsi/isci/unsolicited_frame_control.h |  278 ++
 firmware/Makefile                             |    1 +
 firmware/isci/isci_firmware.bin.ihex          |   16 +
 40 files changed, 23622 insertions(+), 7 deletions(-)
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


