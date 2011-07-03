From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PULL] isci: sas controller driver for 3.0
Date: Sun, 03 Jul 2011 04:37:18 -0700
Message-ID: <1309693038.13127.20.camel@dwillia2-linux>
References: <1309563349.19567.26.camel@dwillia2-linux>
	 <1309646729.2554.17.camel@mulgrave>  <4E0FD74F.4000701@intel.com>
	 <1309670184.2554.28.camel@mulgrave> <4E10024F.8020403@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60752 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab1GCLhT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Jul 2011 07:37:19 -0400
In-Reply-To: <4E10024F.8020403@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Jiang, Dave" <dave.jiang@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, David Milburn <dmilburn@redhat.com>, Jeff Garzik <jeff@garzik.org>, "Danecki, Jacek" <jacek.danecki@intel.com>, "hare@suse.de" <hare@suse.de>

On Sat, 2011-07-02 at 22:46 -0700, Dan Williams wrote:
> > I just stopped at the first failure ... please ensure that there aren't
> > any more ... as in test every bisection point in the tree, don't just
> > squash the commit I've flagged as failing.
> >
> > The fact that there is a bisection failure tends to indicate you haven't
> > been careful to check each commit in the tree ... which does make it
> > suspect and will mean every commit in the reconstituted tree needs
> > checking for bisectability.
> >
> 
> Will verify each commit.

I have pushed out a rebased tree it:

1/ discards the history prior to the first public release of the driver.

2/ discards merge commits and the cherry-pick backports

3/ deletes the reverts, and moves the CONFIG_EFI=n compile fix into the
patch that introduced efi support.  No other commit edits were required
after this step.

4/ passes a compile test of every commit using a script like:
for p in $(stg series --noprefix | xargs)
do
        stg goto $p
        if ! make -j 8; then
                echo $p >> build-breakers
        else
                echo $p >> build-clean
        fi
done

5/ is identical to the previous release

I moved the old tree to a 'historical' branch.

--

The following changes since commit 59c5f46fbe01a00eedf54a23789634438bb80603:

  Linux 3.0-rc2 (2011-06-06 18:06:33 +0900)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

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

Dan Williams (142):
      isci: Intel(R) C600 Series Chipset Storage Control Unit Driver
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
      isci: Errors in the submit path for SATA devices manage the ap lock.
      isci: add "isci_id" attribute
      isci: fix incorrect assumptions about task->dev and task->dev->port being NULL
      isci: task.h compile and checkpatch fixes
      isci: reset hardware at init
      isci: Add support for probing OROM for OEM params
      isci: fixup with testing from isci OROM in BIOS
      isci: fix oem parameter initialization and mode detection
      isci: fix apc mode definition
      isci: fix a build warning
      isci: reorder init to cleanup unneeded declarations
      isci: kill some long macros
      isci: namespacecheck cleanups
      isci: remove unused "remote_device_started"
      isci: cleanup isci_remote_device[_not]_ready interface
      isci: fix fragile/conditional isci_host lookups
      isci: replace sci_sas_link_rate with sas_linkrate
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
      isci: remove 'min memory' infrastructure
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

Dave Jiang (38):
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

Edmund Nadolski (17):
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

Havard Skinnemoen (1):
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

Jeff Skirvin (27):
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


