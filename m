From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT]: isci updates
Date: Wed, 23 Feb 2011 15:22:02 -0800
Message-ID: <1298503322.9709.85.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54218 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab1BWW73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 17:59:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, Dave Jiang <dave.jiang@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>

The isci git tree (still a work in progress) has been updated with the
following changes:

1/ Interrupt setup / handling rework incorporating Jeff's and
Christoph's comments

2/ Created x86-pending branch to stage proposed adapter rom scanning
implementation [1] and dependent code that retrieves the driver's "oem
parameters"

3/ Created libsas-pending branch to stage proposed libsas fixes [2] [3]
while awaiting acceptance in scsi-misc.

4/ Created upstream-pending branch which is just a convenience merge of
master, x86-pending, and libsas-pending.  The master branch is still the
primary development branch.

5/ A collection of fixlets and cleanups across the driver (full
changelog below)

The full diffstat and changelog for upstream-pending are posted below.
The included diff only references the lldd (drivers/scsi/isci/) changes
relative to the last patch posting [4].  The core changes
(drivers/scsi/isci/core/) will be included in the coming review of the
core in patch form.

--
Dan (for the isci driver team)

[1]: http://marc.info/?l=linux-scsi&m=129840446430324&w=2
[2]: http://marc.info/?l=linux-scsi&m=129791077719331&w=2
[3]: http://marc.info/?l=linux-scsi&m=129791105419577&w=2
[4]: http://marc.info/?l=linux-scsi&m=129703780424729&w=2

The following changes since commit 4c1db2d085b1d471850056f05fb83b183ddd8fa9:

  isci: consolidate core (2011-02-06 10:00:24 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git upstream-pending

Dan Williams (16):
      isci: kill SCI_IO_REQUEST_DATA_DIRECTION
      isci: cleanup core consolidation leftovers
      isci: kill a callback cast
      libsas: flush initial device discovery before completing ->scan_finished()
      libsas: fix/amend device gone notification in sas_deform_port()
      isci: remove SCIC_DEBUG_ENABLED, and fixup an odd macro
      isci: bypass scic_controller_get_handler_methods()
      isci: cleanup "starting" state handling
      isci: implement error isr
      isci: advertise linkrate
      isci: debug fixes
      isci: Add support for probing OROM for OEM params
      isci: phy state machine cleanup step1
      isci: clean up remaining silicon revision ifdefs in phy init
      Merge branch 'x86-pending' into upstream-pending
      Merge branch 'libsas-pending' into upstream-pending

Dave Jiang (4):
      isci: removing unused loglevel module param
      isci: Move firmware loading to per PCI device
      x86: Moving probe_roms_32 to probe_roms
      isci: Adding EFI variable skeletal support

Edmund Nadolski (5):
      isci: remove unused SC_LIBRARY_HANDLE_T typedef
      isci: remove SCI_INVALID_HANDLE
      isci: kill sci_types.h
      isci: enable interrupts during controller start, and flush discovery
      isci: remove scic_controller_get_handler_methods and ilk

Havard Skinnemoen (2):
      isci: Add missing PCI IDs
      isci: Initialize proc_name field in scsi_host_template

Henryk Dembkowski (5):
      isci: remote device and node cleanup step1
      isci: coding style changes for remote device
      isci: c99 tables cleanup step1
      isci: coding style changes for remote device
      isci: Move transport layer registers from port to phy

Jacek Danecki (1):
      isci: Add support for user parameters in SCIC layer

Piotr Sawicki (1):
      isci: fix for asserts during aborts/resets to SAS/SATA in APC mode

Tomasz Chudy (2):
      isci: fix "no outbound task timeout" default value
      isci: Add Support for new TC completion codes

 arch/x86/include/asm/probe_roms.h                  |    7 +
 arch/x86/include/asm/setup.h                       |    3 +-
 arch/x86/kernel/Makefile                           |    2 +-
 arch/x86/kernel/head32.c                           |    1 -
 arch/x86/kernel/{probe_roms_32.c => probe_roms.c}  |   13 +
 arch/x86/kernel/x86_init.c                         |    2 +-
 drivers/scsi/aic94xx/aic94xx_init.c                |    2 +-
 drivers/scsi/isci/Makefile                         |    2 +-
 .../isci/core/sci_base_memory_descriptor_list.c    |    6 +-
 .../isci/core/sci_base_memory_descriptor_list.h    |    4 +-
 drivers/scsi/isci/core/sci_base_phy.h              |   15 +-
 drivers/scsi/isci/core/sci_base_remote_device.h    |   31 +-
 drivers/scsi/isci/core/sci_base_state_machine.h    |    2 +
 drivers/scsi/isci/core/sci_controller.h            |    2 -
 .../scsi/isci/core/sci_memory_descriptor_list.h    |    1 -
 drivers/scsi/isci/core/sci_object.h                |    1 -
 drivers/scsi/isci/core/sci_util.h                  |    7 +-
 drivers/scsi/isci/core/scic_config_parameters.h    |   44 +--
 drivers/scsi/isci/core/scic_controller.h           |   97 +---
 drivers/scsi/isci/core/scic_io_request.h           |    1 -
 drivers/scsi/isci/core/scic_phy.h                  |    6 +-
 drivers/scsi/isci/core/scic_port.h                 |    1 -
 drivers/scsi/isci/core/scic_remote_device.h        |    1 -
 drivers/scsi/isci/core/scic_sds_controller.c       |  544 ++---------------
 drivers/scsi/isci/core/scic_sds_controller.h       |   15 +-
 drivers/scsi/isci/core/scic_sds_pci.h              |    1 -
 drivers/scsi/isci/core/scic_sds_phy.c              |  651 ++++++++------------
 drivers/scsi/isci/core/scic_sds_phy.h              |   60 +--
 drivers/scsi/isci/core/scic_sds_phy_registers.h    |   61 ++
 drivers/scsi/isci/core/scic_sds_port.c             |   91 +--
 drivers/scsi/isci/core/scic_sds_port.h             |   66 +--
 .../isci/core/scic_sds_port_configuration_agent.c  |   60 ++-
 drivers/scsi/isci/core/scic_sds_port_registers.h   |   76 ---
 drivers/scsi/isci/core/scic_sds_remote_device.c    |  478 +++++----------
 drivers/scsi/isci/core/scic_sds_remote_device.h    |  104 ++--
 .../scsi/isci/core/scic_sds_remote_node_context.c  |   55 +-
 .../scsi/isci/core/scic_sds_remote_node_context.h  |   47 +-
 .../scsi/isci/core/scic_sds_remote_node_table.h    |    1 -
 drivers/scsi/isci/core/scic_sds_request.c          |   89 ++--
 .../scsi/isci/core/scic_sds_smp_remote_device.c    |  160 ++----
 drivers/scsi/isci/core/scic_sds_smp_request.h      |    1 -
 drivers/scsi/isci/core/scic_sds_ssp_request.c      |   78 +---
 .../scsi/isci/core/scic_sds_stp_packet_request.h   |    1 -
 .../scsi/isci/core/scic_sds_stp_remote_device.c    |  294 +++------
 drivers/scsi/isci/core/scic_sds_stp_request.c      |   65 +--
 drivers/scsi/isci/core/scic_sds_stp_request.h      |    6 +-
 drivers/scsi/isci/core/scic_task_request.h         |    1 -
 drivers/scsi/isci/core/scic_user_callback.h        |   18 +-
 drivers/scsi/isci/core/scu_completion_codes.h      |    3 +
 drivers/scsi/isci/core/scu_registers.h             |    8 +-
 drivers/scsi/isci/core/scu_remote_node_context.h   |    1 -
 drivers/scsi/isci/core/scu_task_context.h          |    1 -
 drivers/scsi/isci/core/scu_unsolicited_frame.h     |    2 +-
 drivers/scsi/isci/core/scu_viit_data.h             |    1 -
 drivers/scsi/isci/deprecated.c                     |   10 +-
 drivers/scsi/isci/events.c                         |    7 +-
 drivers/scsi/isci/firmware/create_fw.c             |  197 ++-----
 drivers/scsi/isci/firmware/create_fw.h             |   67 ++
 drivers/scsi/isci/host.c                           |  490 ++++-----------
 drivers/scsi/isci/host.h                           |   32 +-
 drivers/scsi/isci/init.c                           |  130 ++---
 drivers/scsi/isci/isci.h                           |   47 +--
 drivers/scsi/isci/port.c                           |    2 +
 drivers/scsi/isci/probe_roms.c                     |  188 ++++++
 .../scsi/isci/{core/sci_types.h => probe_roms.h}   |   87 ++-
 drivers/scsi/isci/remote_device.c                  |   10 +-
 drivers/scsi/isci/request.c                        |   42 +--
 drivers/scsi/isci/request.h                        |    3 +-
 drivers/scsi/isci/sci_environment.h                |   14 +
 drivers/scsi/isci/task.c                           |    3 +-
 drivers/scsi/libsas/sas_expander.c                 |   20 +-
 drivers/scsi/libsas/sas_internal.h                 |    3 +-
 drivers/scsi/libsas/sas_phy.c                      |    4 +-
 drivers/scsi/libsas/sas_port.c                     |   21 +-
 drivers/scsi/mvsas/mv_sas.c                        |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |    2 +-
 firmware/isci/isci_firmware.bin.ihex               |   25 +-
 include/scsi/libsas.h                              |   13 +
 78 files changed, 1667 insertions(+), 3042 deletions(-)
 create mode 100644 arch/x86/include/asm/probe_roms.h
 rename arch/x86/kernel/{probe_roms_32.c => probe_roms.c} (93%)
 create mode 100644 drivers/scsi/isci/firmware/create_fw.h
 create mode 100644 drivers/scsi/isci/probe_roms.c
 rename drivers/scsi/isci/{core/sci_types.h => probe_roms.h} (61%)

commit 705478842ea358a6e6bc1cfbc9264fef29a2ba0a
Merge: bd285f5 9f6d842
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Feb 23 12:53:52 2011 -0800

    Merge branch 'libsas-pending' into upstream-pending

commit bd285f54d2b34a8d318e3015358386d9bddd2aa5
Merge: 3077cf0 4f354bf
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Feb 23 12:53:46 2011 -0800

    Merge branch 'x86-pending' into upstream-pending
    
    Conflicts:
    	drivers/scsi/isci/core/scic_config_parameters.h
    	drivers/scsi/isci/core/scic_sds_controller.c

commit 4f354bf780db50b091652c2923c53d6468cc25b9
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed Feb 23 00:02:24 2011 -0800

    isci: Adding EFI variable skeletal support
    
    Adding EFI variable retrieving for OEM parameters. Still need GUID and
    variable name.
    
    Also updated the data struct for oem parameters and hex file for firmware
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3077cf009b8925ec4762b3138fd6c0faf150df50
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Wed Feb 23 00:09:14 2011 -0800

    isci: fix for asserts during aborts/resets to SAS/SATA in APC mode
    
    Sending aborts/resets to SAS/SATA targets in APC mode eventually causes
    an assert in scic_sds_apc_agent_link_up().  We need to handle the hard reset
    case for apc mode ports.
    
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ac7571b7bb38e63c6a4b89a271377443289d6775
Author: Tomasz Chudy <Tomasz.Chudy@intel.com>
Date:   Wed Feb 23 00:09:04 2011 -0800

    isci: Add Support for new TC completion codes
    
    Update the SCI Core to comprehend the changes in the TC completion
    codes from A0 to B0.  Specifically, there isnew R_ER code
    differences for command and data FISes.
    
    Changes are as follows:
    
    1) 0x16 now additionally indicates an R_ERR received for a COMMAND
    FIS being sent to a SATA target.  0x16 for SSP still indicates a
    NAK received for a COMMAND frame.  Fix is to retry TC to be compliant
    with SATA spec or ensure proper error handling of return value
    (not spec compliant I don't believe).
    2) 0x1B was previously called DONE_BREAK_RCVD for STP and
    DONE_LL_ABORT_ERR for SSP.  Now it is universally called
    DONE_LL_ABORT_ERR.  This is purely a superficial change.
    3) 0x32 is no longer a reserved code.  Now it indicates
    DONE_CMD_SDMA_ERR for STP/SSP.  There was a fatal error on the
    SDMA for a command IU (includes Raw frames).  Consider retry,
    but at a minimum gracefully fail the request.
    4) 0x33 is no longer a reserved code.  Now it indicates
    DONE_CMD_LL_ABORT_ERR for SSP.  There was a break receivd
    during transmission of a command IU.  Consider retry, but
    at a minimum gracefully fail the request.
    
    Signed-off-by: Tomasz Chudy <Tomasz.Chudy@intel.com>
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9c2b8da43649a9aa5a258e4be123e89b7365a60b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Feb 23 00:09:01 2011 -0800

    isci: clean up remaining silicon revision ifdefs in phy init
    
    Use the dynamic revision detection code in
    scic_sds_phy_link_layer_initialization() and apply some coding style
    fixups (long deref chains).  The compile time max link rate setting is
    removed in favor of honoring the user-parameter max.
    
    Reported-by: Krzysztof Wierzbicki <Krzysztof.Wierzbicki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e87a52b6ff7912f3a7b8b48894ed7418fe4c6665
Author: Jacek Danecki <Jacek.Danecki@intel.com>
Date:   Wed Feb 23 00:08:58 2011 -0800

    isci: Add support for user parameters in SCIC layer
    
    Add support for the following parameters in SCIC:
    
         /**
           * This field specifies the NOTIFY (ENABLE SPIN UP) primitive
           * insertion frequency for this phy index.
           */
          u32  notify_enable_spin_up_insertion_frequency;
    
          /**
           * This method specifies the number of transmitted DWORDs within which
           * to transmit a single ALIGN primitive.  This value applies regardless
           * of what type of device is attached or connection state.  A value of
           * 0 indicates that no ALIGN primitives will be inserted.
           */
          u16  align_insertion_frequency;
    
          /**
           * This method specifies the number of transmitted DWORDs within which
           * to transmit 2 ALIGN primitives.  This applies for SAS connections
           * only.  A minimum value of 3 is required for this field.
           */
          u16  in_connection_align_insertion_frequency;
    
    Signed-off-by: Krzysztof Wierzbicki <Krzysztof.Wierzbicki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2b318c8e80bf25ff357e969777ec127f539f8c9a
Author: Henryk Dembkowski <Henryk.Dembkowski@intel.com>
Date:   Wed Feb 23 00:08:52 2011 -0800

    isci: Move transport layer registers from port to phy
    
    At init and RNC resume we need to touch every phy in a port to be sure
    we have initialized STP properties in the case where port_index !=
    phy_index.  Also add some missing __iomem annotations.
    
    Signed-off-by: Henryk Dembkowski <henryk.dembkowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d9cf9c7c77e6a69dfab5dbead8329175f3c44bba
Author: Tomasz Chudy <Tomasz.Chudy@intel.com>
Date:   Wed Feb 23 00:08:49 2011 -0800

    isci: fix "no outbound task timeout" default value
    
    The default should be 5us.  The hardware encodes it in 256ns increments,
    so the value should be 20 to approximate a 5us timeout.
    
    Signed-off-by: Tomasz Chudy <Tomasz.Chudy@intel.com>
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3bd36a4a311c8dae1a3c105a51b3e08fd5176ec2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Feb 23 00:14:06 2011 -0800

    isci: phy state machine cleanup step1
    
     c99 the struct initializers:
    	1/ allows grep to consistently show method name associations.  The
    	   naming is mostly consistent (except when it isn't) so this guarantees
    	   coverage of present and future exception cases.
    	2/ let's the compiler guarantee that the state table array entry
    	   correlates with an actual state name and detect accidental reordering or
    	   deletion of states.
    	/ allows default handler's to be identified easily
    
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f502dbe99adc8de6cee74e6549677997c6d719ed
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed Feb 23 00:02:22 2011 -0800

    isci: Add support for probing OROM for OEM params
    
    We need to scan the OROM for signature and grab the OEM parameters. We
    also need to do the same for EFI. If all fails then we resort to user
    binary blob, and if that fails then we go to the defaults.
    
    Share the format with the create_fw utility so that all possible sources
    of the parameters are in-sync.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 353199ee9e69e626d408d26c98478a4af7170a1e
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Tue Feb 22 15:25:17 2011 -0800

    x86: Moving probe_roms_32 to probe_roms
    
    Moving the probe_roms_32 code to probe_roms and make available for all x86. The
    end result adapter roms data structure is made available read-only to drivers.
    The Intel isci SAS driver needs to scan the OROM memory in order to pull OEM
    parameters from the OROM.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>

commit 1709eec56656e2daae34020acd3aaa927a68b996
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Tue Feb 22 01:27:03 2011 -0800

    isci: Move firmware loading to per PCI device
    
    Moved the firmware loading from per adapter to per PCI device. This should
    prevent firmware from being loaded twice becuase of 2 SCU controller per
    PCI device. We do have to do it per PCI device because request_firmware()
    requires a struct device passed in.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8dbdb430fdb7fc15c049e7a8aa29d64d12dd9566
Author: Havard Skinnemoen <hskinnemoen@google.com>
Date:   Fri Feb 18 18:32:08 2011 -0800

    isci: Initialize proc_name field in scsi_host_template
    
    The proc_name field in struct scsi_host_template is exported through sysfs and
    allows userspace tools to identify the driver behind a particular SCSI host
    controller.
    
    Initialize this field so that userspace tools can easily identify isci host
    controllers through sysfs.
    
    Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c2af8ba967f85a652d102e3ced262f8420d58ff6
Author: Havard Skinnemoen <hskinnemoen@google.com>
Date:   Fri Feb 18 18:32:07 2011 -0800

    isci: Add missing PCI IDs
    
    The SCUDIDOV register can be used to select any value from 0x1d60 to 0x1d6f as
    the PCI ID. Make sure the driver supports them all.
    
    Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 55b98b72f70edbad922587a66a25d2f3c4a7f144
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Fri Feb 18 09:25:17 2011 -0800

    isci: remove scic_controller_get_handler_methods and ilk
    
    This removes scic_controller_get_handler_methods and its
    associated unused code.
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    [djbw: kill off the legacy handler, now that we have basic error isr support]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9544923c684632f9f54e838dd8a43d3a3628226b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Feb 18 09:25:15 2011 -0800

    isci: debug fixes
    
    Some of the chain walks to get back to our dev are invalid.
    
    isci_remote_device_change_state: delete rather than adding conditional deref
    chain walking
    isci_request_change_state: fix, it was being called too early
    isci_request_ssp_io_request_get_lun: fix compile breakage hidden by ifdef DEBUG
    
    Signed-off-by: Maciej Trela <maciej.trela@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2e10c2b47ea7350c72ed7da1f2e4c884efc3e51d
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Feb 18 09:25:13 2011 -0800

    isci: advertise linkrate
    
    Inform libsas of the linkrate of direct attached links.
    
    Reported-by: Haavard Skinnemoen <hskinnemoen@gmail.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6e3f6ad0a6b59b1bebf3b66dfacbfaae0a98c96e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Feb 18 09:25:11 2011 -0800

    isci: implement error isr
    
    Add basic support for handling/reporting error interrupts.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a88bfbcb9b0237deeddd49db7789c3992fb006ce
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Fri Feb 18 09:25:09 2011 -0800

    isci: enable interrupts during controller start, and flush discovery
    
    Polling the event queue during scan is an unneeded holdover from the
    original driver.
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    [djbw: ensure we flush all port events and domain discovery]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2f89431766a7178e4a1beb87d3606d020f981e94
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Feb 18 09:25:07 2011 -0800

    isci: cleanup "starting" state handling
    
    The lldd actively disallows requests in the "starting" state.  Retrying
    or holding off commands in this state is sub-optimal:
    1/ it adds another state check to the fast path
    2/ retrying can cause libsas to give up
    
    However, isci's ->lldd_dev_found() routine already waits for controller
    start to complete before allowing further progress.  Checking the
    "starting" state in isci_task_execute_task and the isr is redundant and
    misleading.  Clean this up and introduce a controller-wide event queue
    to start reeling in "completion" proliferation in the driver.
    
    The "stopping" state cleanups are in a similar vein, rely on the the isr
    and other paths being precluded from occurring rather than implementing
    state checking logic.
    
    Reported-by: Christoph Hellwig <hch@infradead.org>
    Cc: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bb17c26248fad2e897fb5a351f36bba2d0dcb077
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Feb 18 09:25:05 2011 -0800

    isci: bypass scic_controller_get_handler_methods()
    
    The indirection is unecessary and broken in the current case that assigns the
    handlers based on a not up-to-date pdev->msix_enabled value.
    
    Route the handlers directly to the requisite core routines.
    
    Todo: hook up error interrupt handling
    
    Reported-by: Jeff Garzik <jeff@garzik.org>
    Cc: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 45f72ff3356b79de31a7b91e9464b48db54e9abd
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu Feb 17 15:01:46 2011 -0800

    isci: remove SCIC_DEBUG_ENABLED, and fixup an odd macro
    
    This will be replaced by state machine tracepoints and should have been a part
    of the logger removal.
    
    Ran across scic_sds_port_decrement_request_count() which is an ugly macro
    which silently hides accounting errors.  Turn it into a WARN_ONCE to see if it
    ever triggers.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9f6d842d9512fc839db877cc0d7b8a12fbcda035
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Feb 18 09:22:43 2011 -0800

    libsas: fix/amend device gone notification in sas_deform_port()
    
    Commit 56dd2c06 "libsas: Don't issue commands to devices that have been
    hot-removed" edited Darrick's original patch to remove setting 'gone' in
    the sas_deform_port() path because that prevented scsi sync cache
    commands from being issued when the driver was unloaded.  However, this
    allows true device gone notifications (as signaled port phy events) to
    trigger sync cache commands to devices that are known to be unreachable.
    
    Teach libsas which sas_deform_port() invocations are likely device gone
    events.
    
    This patch also introduces sas_device_gone() which hopefully allows
    subtle/tricky locking to be dropped from lldd drivers, like the
    following in mvsas which is broken if the ata path is ever converted to
    call lldd_execute_task() with irqs enabled:
    
    	flags_libsas = 0;
    	[...]
    	spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags_libsas);
    	spin_unlock_irqrestore(&mvi->lock, flags);
    	t->task_done(t);
    	spin_lock_irqsave(&mvi->lock, flags);
    	spin_lock_irqsave(dev->sata_dev.ap->lock, flags_libsas);
    
    Cc: Darrick J. Wong <djwong@us.ibm.com>
    Cc: Haipao Fan <haipao.fan@intel.com>
    Cc: Maciej Trela <maciej.trela@intel.com>
    Cc: David Milburn <dmilburn@redhat.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ca5a014f79e6864810abe943543ff9e10ba0b88c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Feb 18 09:22:32 2011 -0800

    libsas: flush initial device discovery before completing ->scan_finished()
    
    During initial scan libsas drivers start their phys and notify libsas
    with PORTE_BYTES_DMAED events as port links are established.  This
    notification in turn causes libsas to post DISCE_DISCOVER_DOMAIN events
    to the queue.  Calling scsi_flush_work() at the end of scan_finished
    guarantees that all preceding PORTE_BYTES_DMAED events have been
    registered in the queue, but it does not guarantee that the resulting
    DISCE_DISCOVER_DOMAIN events have been processed because
    flush_workqueue() explicitly avoids live-locking with incoming work.
    
    Introduce sas_flush_discovery() to guarantee that all initial discovery
    events have completed.  It is called after the driver determines all
    initial PORTE_BYTES_DMAED events have had a chance to enter the queue.
    This does not cover BCNs that are generated during expander bring up,
    only the initial sas_discover_domain() event.
    
    Cc: David Milburn <dmilburn@redhat.com>
    Cc: Srinivas <satyasrinivasp@hcl.in>
    Cc: jack_wang@usish.com
    Cc: lindar_liu@usish.com
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ca2f350e97de3a971176aacd412867c2abddd98c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Feb 12 11:50:15 2011 -0800

    isci: kill a callback cast
    
    Callbacks are already type unsafe, obfuscating things further by casting the
    callback routine is less safe because now function argument number changes
    will not be caught by the compiler.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2522e96a393af4b1cf18cec4ed7daca0b91991fc
Author: Henryk Dembkowski <Henryk.Dembkowski@intel.com>
Date:   Sat Feb 12 11:50:13 2011 -0800

    isci: coding style changes for remote device
    
    Change names from upper to low letters
    
    Signed-off-by: Henryk Dembkowski <henryk.dembkowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit dafdb778811d1c9a0c223e1c59d4ab7a3c6f1cb4
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Feb 12 11:50:11 2011 -0800

    isci: cleanup core consolidation leftovers
    
    Remove duplicated license and header file includes that were leftover
    from commit 4c1db2d0 "isci: consolidate core"
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 30713cf69e3cbe0c8ca8be7604c93637f5834020
Author: Henryk Dembkowski <Henryk.Dembkowski@intel.com>
Date:   Sat Feb 12 11:50:09 2011 -0800

    isci: c99 tables cleanup step1
    
    	scic_sds_stp_remote_device_ready_substate_handler_table[]
    	scic_sds_smp_remote_device_ready_substate_handler_table[]
    
    c99 the struct initializers:
    	1/ allows grep to consistently show method name associations.  The
    	   naming is mostly consistent (except when it isn't) so this guarantees
    	   coverage of present and future exception cases.
    	2/ let's the compiler guarantee that the state table array entry
    	   correlates with an actual state name and detect accidental reordering or
    	   deletion of states.
    	3/ allows default handler's to be identified easily
    
    Signed-off-by: Henryk Dembkowski <henryk.dembkowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ccfa647727a1c47cbbdf337911ae5f3c62237bd6
Author: Henryk Dembkowski <Henryk.Dembkowski@intel.com>
Date:   Sat Feb 12 11:50:07 2011 -0800

    isci: coding style changes for remote device
    
    Change names from upper to low letters
    
    Signed-off-by: Henryk Dembkowski <henryk.dembkowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 506cdedec4c0ced8465aade81dd1a8d3314a2650
Author: Henryk Dembkowski <Henryk.Dembkowski@intel.com>
Date:   Sat Feb 12 11:50:05 2011 -0800

    isci: remote device and node cleanup step1
    
    c99 the struct initializers (scic_sds_remote_device_state_handler_table[]):
    	1/ allows grep to consistently show method name associations.  The
    	   naming is mostly consistent (except when it isn't) so this guarantees
    	   coverage of present and future exception cases.
    	2/ let's the compiler guarantee that the state table array entry
    	   correlates with an actual state name and detect accidental reordering or
    	   deletion of states.
    	3/ allows default handler's to be identified easily
    
    Change names from upper to low letters
    
    Cleanup empty lines
    
    Signed-off-by: Henryk Dembkowski <henryk.dembkowski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4252992bcc33b3f9c15d17f15692b7f09d79da98
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Fri Feb 11 18:04:28 2011 -0800

    isci: removing unused loglevel module param
    
    We no longer use the loglevel parameter. Remove.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9f2cbe33334052e38c639866d544b646bef5e846
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Tue Feb 8 09:31:55 2011 -0700

    isci: kill sci_types.h
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    [rebased after killing SCI_IO_REQUEST_DATA_DIRECTION]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6477c20ad054e70f716e6009f6f601a4bffe5553
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Feb 8 17:53:10 2011 -0800

    isci: kill SCI_IO_REQUEST_DATA_DIRECTION
    
    It's an unnecessary typedef that mirrors the kernel's enum
    dma_data_direction.
    
    Also cleanup some long variable names along the way.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b92a6cc143cd71c5b24c34ea95b7c7e80a68852d
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Tue Feb 8 09:28:42 2011 -0700

    isci: remove SCI_INVALID_HANDLE
    
    Replace SCI_INVALID_HANDLE with NULL
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e55e8363ee232ee008b52052995df38eb473f919
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Tue Feb 8 08:09:10 2011 -0700

    isci: remove unused SC_LIBRARY_HANDLE_T typedef
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/scsi/isci/deprecated.c b/drivers/scsi/isci/deprecated.c
index 847e687..0ee6679 100644
--- a/drivers/scsi/isci/deprecated.c
+++ b/drivers/scsi/isci/deprecated.c
@@ -139,16 +139,10 @@ u32 scic_cb_io_request_get_transfer_length(
  * @scic_user_io_request: This parameter points to the user's IO request
  *    object.  It is a cookie that allows the user to provide the necessary
  *    information for this callback.
- *
- * This method returns the value of SCI_IO_REQUEST_DATA_OUT or
- * SCI_IO_REQUEST_DATA_IN, or SCI_IO_REQUEST_NO_DATA.
  */
-SCI_IO_REQUEST_DATA_DIRECTION scic_cb_io_request_get_data_direction(
-	void *scic_user_io_request)
+enum dma_data_direction scic_cb_io_request_get_data_direction(void *req)
 {
-	return isci_request_io_request_get_data_direction(
-		       scic_user_io_request
-		       );
+	return isci_request_io_request_get_data_direction(req);
 }
 
 
diff --git a/drivers/scsi/isci/events.c b/drivers/scsi/isci/events.c
index 75f9cd5..6911ea5 100644
--- a/drivers/scsi/isci/events.c
+++ b/drivers/scsi/isci/events.c
@@ -399,8 +399,7 @@ void scic_cb_port_invalid_link_up(
  *    port.
  * @port: This parameter specifies the SCI port object for which the callback
  *    is being invoked.  For instances where the phy on which the primitive was
- *    received is not part of a port, this parameter will be
- *    SCI_INVALID_HANDLE_T.
+ *    received is not part of a port, this parameter will be NULL.
  * @phy: This parameter specifies the phy on which the primitive was received.
  *
  */
@@ -430,7 +429,7 @@ void scic_cb_port_bc_change_primitive_received(
  *    phy.
  * @port: This parameter specifies the port object for which the user callback
  *    is being invoked.  There may be conditions where this parameter can be
- *    SCI_INVALID_HANDLE
+ *    NULL
  * @phy: This parameter specifies the phy object for which the user callback is
  *    being invoked.
  *
@@ -460,7 +459,7 @@ void scic_cb_port_link_up(
  *    phy.
  * @port: This parameter specifies the port object for which the user callback
  *    is being invoked.  There may be conditions where this parameter can be
- *    SCI_INVALID_HANDLE
+ *    NULL
  * @phy: This parameter specifies the phy object for which the user callback is
  *    being invoked.
  *
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 6f16f4d..aa86615 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -62,84 +62,50 @@
 #include "request.h"
 #include "host.h"
 
-/**
- * isci_isr() - This function is the interrupt service routine for the
- *    controller. It schedules the tasklet and returns.
- * @vec: This parameter specifies the interrupt vector.
- * @data: This parameter specifies the ISCI host object.
- *
- * IRQ_HANDLED if out interrupt otherwise, IRQ_NONE
- */
-irqreturn_t isci_isr(int vec, void *data)
+irqreturn_t isci_msix_isr(int vec, void *data)
 {
-	struct isci_host *isci_host
-		= (struct isci_host *)data;
-	struct scic_controller_handler_methods *handlers
-		= &isci_host->scic_irq_handlers[SCI_MSIX_NORMAL_VECTOR];
-	irqreturn_t ret = IRQ_NONE;
+	struct isci_host *ihost = data;
+	struct scic_sds_controller *scic = ihost->core_controller;
 
-	if (isci_host_get_state(isci_host) != isci_starting
-	    && handlers->interrupt_handler) {
-
-		if (handlers->interrupt_handler(isci_host->core_controller)) {
-			if (isci_host_get_state(isci_host) != isci_stopped) {
-				tasklet_schedule(
-					&isci_host->completion_tasklet);
-			} else
-				dev_dbg(&isci_host->pdev->dev,
-					"%s: controller stopped\n",
-					__func__);
-			ret = IRQ_HANDLED;
-		}
-	} else
-		dev_warn(&isci_host->pdev->dev,
-			 "%s: get_handler_methods failed, "
-			 "isci_host->status = 0x%x\n",
-			 __func__,
-			 isci_host_get_state(isci_host));
+	if (scic_sds_controller_isr(scic))
+		tasklet_schedule(&ihost->completion_tasklet);
 
-	return ret;
+	return IRQ_HANDLED;
 }
 
-irqreturn_t isci_legacy_isr(int vec, void *data)
+irqreturn_t isci_intx_isr(int vec, void *data)
 {
 	struct pci_dev *pdev = data;
-	struct isci_host *isci_host;
-	struct scic_controller_handler_methods *handlers;
+	struct isci_host *ihost;
 	irqreturn_t ret = IRQ_NONE;
 
-	/*
-	 *  Since this is a legacy interrupt, either or both
-	 *  controllers could have triggered it.  Thus, we have to call
-	 *  the legacy interrupt handler for all controllers on the
-	 *  PCI function.
-	 */
-	for_each_isci_host(isci_host, pdev) {
-		handlers = &isci_host->scic_irq_handlers[SCI_MSIX_NORMAL_VECTOR];
-
-		if (isci_host_get_state(isci_host) != isci_starting
-		    && handlers->interrupt_handler) {
-
-			if (handlers->interrupt_handler(isci_host->core_controller)) {
-				if (isci_host_get_state(isci_host) != isci_stopped) {
-					tasklet_schedule(
-						&isci_host->completion_tasklet);
-				} else
-					dev_dbg(&isci_host->pdev->dev,
-						"%s: controller stopped\n",
-						__func__);
-				ret = IRQ_HANDLED;
-			}
-		} else
-			dev_warn(&isci_host->pdev->dev,
-				 "%s: get_handler_methods failed, "
-				 "isci_host->status = 0x%x\n",
-				 __func__,
-				 isci_host_get_state(isci_host));
+	for_each_isci_host(ihost, pdev) {
+		struct scic_sds_controller *scic = ihost->core_controller;
+
+		if (scic_sds_controller_isr(scic)) {
+			tasklet_schedule(&ihost->completion_tasklet);
+			ret = IRQ_HANDLED;
+		} else if (scic_sds_controller_error_isr(scic)) {
+			spin_lock(&ihost->scic_lock);
+			scic_sds_controller_error_handler(scic);
+			spin_unlock(&ihost->scic_lock);
+			ret = IRQ_HANDLED;
+		}
 	}
+
 	return ret;
 }
 
+irqreturn_t isci_error_isr(int vec, void *data)
+{
+	struct isci_host *ihost = data;
+	struct scic_sds_controller *scic = ihost->core_controller;
+
+	if (scic_sds_controller_error_isr(scic))
+		scic_sds_controller_error_handler(scic);
+
+	return IRQ_HANDLED;
+}
 
 /**
  * isci_host_start_complete() - This function is called by the core library,
@@ -149,116 +115,56 @@ irqreturn_t isci_legacy_isr(int vec, void *data)
  *    core library.
  *
  */
-void isci_host_start_complete(
-	struct isci_host *isci_host,
-	enum sci_status completion_status)
+void isci_host_start_complete(struct isci_host *ihost, enum sci_status completion_status)
 {
-	if (completion_status == SCI_SUCCESS) {
-		dev_dbg(&isci_host->pdev->dev,
-			"%s: completion_status: SCI_SUCCESS\n", __func__);
-		isci_host_change_state(isci_host, isci_ready);
-		complete_all(&isci_host->start_complete);
-	} else
-		dev_err(&isci_host->pdev->dev,
-			"controller start failed with "
-			"completion_status = 0x%x;",
-			completion_status);
-
+	if (completion_status != SCI_SUCCESS)
+		dev_info(&ihost->pdev->dev,
+			"controller start timed out, continuing...\n");
+	isci_host_change_state(ihost, isci_ready);
+	clear_bit(IHOST_START_PENDING, &ihost->flags);
+	wake_up(&ihost->eventq);
 }
 
-
-
-/**
- * isci_host_scan_finished() - This function is one of the SCSI Host Template
- *    functions. The SCSI midlayer calls this function during a target scan,
- *    approx. once every 10 millisecs.
- * @shost: This parameter specifies the SCSI host being scanned
- * @time: This parameter specifies the number of ticks since the scan started.
- *
- * scan status, zero indicates the SCSI midlayer should continue to poll,
- * otherwise assume controller is ready.
- */
-int isci_host_scan_finished(
-	struct Scsi_Host *shost,
-	unsigned long time)
+int isci_host_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
-	struct isci_host *isci_host
-		= isci_host_from_sas_ha(SHOST_TO_SAS_HA(shost));
+	struct isci_host *ihost = isci_host_from_sas_ha(SHOST_TO_SAS_HA(shost));
 
-	struct scic_controller_handler_methods *handlers
-		= &isci_host->scic_irq_handlers[SCI_MSIX_NORMAL_VECTOR];
-
-	if (handlers->interrupt_handler == NULL) {
-		dev_err(&isci_host->pdev->dev,
-			"%s: scic_controller_get_handler_methods failed\n",
-			__func__);
-		return 1;
-	}
-
-	/**
-	 * check interrupt_handler's status and call completion_handler if true,
-	 * link_up events should be coming from the scu core lib, as phy's come
-	 * online. for each link_up from the core, call
-	 * get_received_identify_address_frame, copy the frame into the
-	 * sas_phy object and call libsas notify_port_event(PORTE_BYTES_DMAED).
-	 * continue to return zero from thee scan_finished routine until
-	 * the scic_cb_controller_start_complete() call comes from the core.
-	 **/
-	if (handlers->interrupt_handler(isci_host->core_controller))
-		handlers->completion_handler(isci_host->core_controller);
-
-	if (isci_starting == isci_host_get_state(isci_host)
-	    && time < (HZ * 10)) {
-		dev_dbg(&isci_host->pdev->dev,
-			"%s: isci_host->status = %d, time = %ld\n",
-			     __func__, isci_host_get_state(isci_host), time);
+	if (test_bit(IHOST_START_PENDING, &ihost->flags))
 		return 0;
-	}
 
+	/* todo: use sas_flush_discovery once it is upstream */
+	scsi_flush_work(shost);
 
-	dev_dbg(&isci_host->pdev->dev,
-		"%s: isci_host->status = %d, time = %ld\n",
-		 __func__, isci_host_get_state(isci_host), time);
+	scsi_flush_work(shost);
 
-	scic_controller_enable_interrupts(isci_host->core_controller);
+	dev_dbg(&ihost->pdev->dev,
+		"%s: ihost->status = %d, time = %ld\n",
+		 __func__, isci_host_get_state(ihost), time);
 
 	return 1;
 
 }
 
-
-/**
- * isci_host_scan_start() - This function is one of the SCSI Host Template
- *    function, called by the SCSI mid layer berfore a target scan begins. The
- *    core library controller start routine is called from here.
- * @shost: This parameter specifies the SCSI host to be scanned
- *
- */
 void isci_host_scan_start(struct Scsi_Host *shost)
 {
-	struct isci_host *isci_host;
+	struct isci_host *ihost = isci_host_from_sas_ha(SHOST_TO_SAS_HA(shost));
+	struct scic_sds_controller *scic = ihost->core_controller;
+	unsigned long tmo = scic_controller_get_suggested_start_timeout(scic);
 
-	isci_host = isci_host_from_sas_ha(SHOST_TO_SAS_HA(shost));
-	isci_host_change_state(isci_host, isci_starting);
+	set_bit(IHOST_START_PENDING, &ihost->flags);
 
-	scic_controller_disable_interrupts(isci_host->core_controller);
-	init_completion(&isci_host->start_complete);
-	scic_controller_start(
-		isci_host->core_controller,
-		scic_controller_get_suggested_start_timeout(
-			isci_host->core_controller)
-		);
+	spin_lock_irq(&ihost->scic_lock);
+	scic_controller_start(scic, tmo);
+	scic_controller_enable_interrupts(scic);
+	spin_unlock_irq(&ihost->scic_lock);
 }
 
-void isci_host_stop_complete(
-	struct isci_host *isci_host,
-	enum sci_status completion_status)
+void isci_host_stop_complete(struct isci_host *ihost, enum sci_status completion_status)
 {
-	isci_host_change_state(isci_host, isci_stopped);
-	scic_controller_disable_interrupts(
-		isci_host->core_controller
-		);
-	complete(&isci_host->stop_complete);
+	isci_host_change_state(ihost, isci_stopped);
+	scic_controller_disable_interrupts(ihost->core_controller);
+	clear_bit(IHOST_STOP_PENDING, &ihost->flags);
+	wake_up(&ihost->eventq);
 }
 
 static struct coherent_memory_info *isci_host_alloc_mdl_struct(
@@ -363,8 +269,6 @@ static int isci_host_mdl_allocate_coherent(
 static void isci_host_completion_routine(unsigned long data)
 {
 	struct isci_host *isci_host = (struct isci_host *)data;
-	struct scic_controller_handler_methods *handlers
-		= &isci_host->scic_irq_handlers[SCI_MSIX_NORMAL_VECTOR];
 	struct list_head completed_request_list;
 	struct list_head aborted_request_list;
 	struct list_head *current_position;
@@ -378,11 +282,8 @@ static void isci_host_completion_routine(unsigned long data)
 
 	spin_lock_irq(&isci_host->scic_lock);
 
-	if (handlers->completion_handler) {
-		handlers->completion_handler(
-			isci_host->core_controller
-			);
-	}
+	scic_sds_controller_completion_handler(isci_host->core_controller);
+
 	/* Take the lists of completed I/Os from the host. */
 	list_splice_init(&isci_host->requests_to_complete,
 			 &completed_request_list);
@@ -431,92 +332,26 @@ static void isci_host_completion_routine(unsigned long data)
 
 }
 
-void isci_host_deinit(
-	struct isci_host *isci_host)
+void isci_host_deinit(struct isci_host *ihost)
 {
+	struct scic_sds_controller *scic = ihost->core_controller;
 	int i;
 
-	isci_host_change_state(isci_host, isci_stopping);
+	isci_host_change_state(ihost, isci_stopping);
 	for (i = 0; i < SCI_MAX_PORTS; i++) {
-		struct isci_port *port = &isci_host->isci_ports[i];
-		struct isci_remote_device *device, *tmpdev;
-		list_for_each_entry_safe(device, tmpdev,
-					 &port->remote_dev_list, node) {
-			isci_remote_device_change_state(device, isci_stopping);
-			isci_remote_device_stop(device);
-		}
-	}
+		struct isci_port *port = &ihost->isci_ports[i];
+		struct isci_remote_device *idev, *d;
 
-	/* stop the comtroller and wait for completion.  */
-	init_completion(&isci_host->stop_complete);
-	scic_controller_stop(
-		isci_host->core_controller,
-		SCIC_CONTROLLER_STOP_TIMEOUT
-		);
-	wait_for_completion(&isci_host->stop_complete);
-	/* next, reset the controller.           */
-	scic_controller_reset(isci_host->core_controller);
-}
-
-static int isci_verify_firmware(const struct firmware *fw,
-				struct isci_firmware *isci_fw)
-{
-	const u8 *tmp;
-
-	if (fw->size < ISCI_FIRMWARE_MIN_SIZE)
-		return -EINVAL;
-
-	tmp = fw->data;
-
-	/* 12th char should be the NULL terminate for the ID string */
-	if (tmp[11] != '\0')
-		return -EINVAL;
-
-	if (strncmp("#SCU MAGIC#", tmp, 11) != 0)
-		return -EINVAL;
-
-	isci_fw->id = tmp;
-	isci_fw->version = fw->data[ISCI_FW_VER_OFS];
-	isci_fw->subversion = fw->data[ISCI_FW_SUBVER_OFS];
-
-	tmp = fw->data + ISCI_FW_DATA_OFS;
-
-	while (*tmp != ISCI_FW_HDR_EOF) {
-		switch (*tmp) {
-		case ISCI_FW_HDR_PHYMASK:
-			tmp++;
-			isci_fw->phy_masks_size = *tmp;
-			tmp++;
-			isci_fw->phy_masks = (const u32 *)tmp;
-			tmp += sizeof(u32) * isci_fw->phy_masks_size;
-			break;
-
-		case ISCI_FW_HDR_PHYGEN:
-			tmp++;
-			isci_fw->phy_gens_size = *tmp;
-			tmp++;
-			isci_fw->phy_gens = (const u32 *)tmp;
-			tmp += sizeof(u32) * isci_fw->phy_gens_size;
-			break;
-
-		case ISCI_FW_HDR_SASADDR:
-			tmp++;
-			isci_fw->sas_addrs_size = *tmp;
-			tmp++;
-			isci_fw->sas_addrs = (const u64 *)tmp;
-			tmp += sizeof(u64) * isci_fw->sas_addrs_size;
-			break;
-
-		default:
-			pr_err("bad field in firmware binary blob\n");
-			return -EINVAL;
+		list_for_each_entry_safe(idev, d, &port->remote_dev_list, node) {
+			isci_remote_device_change_state(idev, isci_stopping);
+			isci_remote_device_stop(idev);
 		}
 	}
 
-	pr_info("isci firmware v%u.%u loaded.\n",
-	       isci_fw->version, isci_fw->subversion);
-
-	return SCI_SUCCESS;
+	set_bit(IHOST_STOP_PENDING, &ihost->flags);
+	scic_controller_stop(scic, SCIC_CONTROLLER_STOP_TIMEOUT);
+	wait_for_stop(ihost);
+	scic_controller_reset(scic);
 }
 
 static void __iomem *scu_base(struct isci_host *isci_host)
@@ -544,12 +379,8 @@ int isci_host_init(struct isci_host *isci_host)
 	enum sci_status status;
 	struct scic_sds_controller *controller;
 	struct scic_sds_port *scic_port;
-	struct scic_controller_handler_methods *handlers
-		= &isci_host->scic_irq_handlers[0];
 	union scic_oem_parameters scic_oem_params;
 	union scic_user_parameters scic_user_params;
-	const struct firmware *fw = NULL;
-	struct isci_firmware *isci_fw = NULL;
 
 	INIT_LIST_HEAD(&isci_host->timer_list_struct.timers);
 	isci_timer_list_construct(
@@ -560,15 +391,18 @@ int isci_host_init(struct isci_host *isci_host)
 	controller = scic_controller_alloc(&isci_host->pdev->dev);
 
 	if (!controller) {
-		err = -ENOMEM;
-		dev_err(&isci_host->pdev->dev, "%s: failed (%d)\n", __func__, err);
-		goto out;
+		dev_err(&isci_host->pdev->dev,
+			"%s: failed (%d)\n",
+			__func__,
+			err);
+		return -ENOMEM;
 	}
 
 	isci_host->core_controller = controller;
 	spin_lock_init(&isci_host->state_lock);
 	spin_lock_init(&isci_host->scic_lock);
 	spin_lock_init(&isci_host->queue_lock);
+	init_waitqueue_head(&isci_host->eventq);
 
 	isci_host_change_state(isci_host, isci_starting);
 	isci_host->can_queue = ISCI_CAN_QUEUE_VAL;
@@ -581,8 +415,7 @@ int isci_host_init(struct isci_host *isci_host)
 			"%s: scic_controller_construct failed - status = %x\n",
 			__func__,
 			status);
-		err = -ENODEV;
-		goto out;
+		return -ENODEV;
 	}
 
 	isci_host->sas_ha.dev = &isci_host->pdev->dev;
@@ -592,93 +425,52 @@ int isci_host_init(struct isci_host *isci_host)
 	 * set association host adapter struct in core controller.
 	 */
 	sci_object_set_association(isci_host->core_controller,
-				   (void *)isci_host
-				   );
+				   (void *)isci_host);
 
 	/* grab initial values stored in the controller object for OEM and USER
 	 * parameters */
 	scic_oem_parameters_get(controller, &scic_oem_params);
 	scic_user_parameters_get(controller, &scic_user_params);
 
-	isci_fw = devm_kzalloc(&isci_host->pdev->dev,
-			       sizeof(struct isci_firmware),
-			       GFP_KERNEL);
-	if (!isci_fw) {
-		dev_warn(&isci_host->pdev->dev,
-			 "allocating firmware struct failed\n");
-		dev_warn(&isci_host->pdev->dev,
-			 "Default OEM configuration being used:"
-			 " 4 narrow ports, and default SAS Addresses\n");
-		goto set_default_params;
-	}
-
-	status = request_firmware(&fw, ISCI_FW_NAME, &isci_host->pdev->dev);
-	if (status) {
-		dev_warn(&isci_host->pdev->dev,
-			 "Loading firmware failed, using default values\n");
-		dev_warn(&isci_host->pdev->dev,
-			 "Default OEM configuration being used:"
-			 " 4 narrow ports, and default SAS Addresses\n");
-		goto set_default_params;
-	}
-	else {
-		status = isci_verify_firmware(fw, isci_fw);
-		if (status != SCI_SUCCESS) {
-			dev_warn(&isci_host->pdev->dev,
-				 "firmware verification failed\n");
-			dev_warn(&isci_host->pdev->dev,
-				 "Default OEM configuration being used:"
-				 " 4 narrow ports, and default SAS "
-				 "Addresses\n");
-			goto set_default_params;
-		}
-
-		/* grab any OEM and USER parameters specified at module load */
+	if (isci_firmware) {
+		/* grab any OEM and USER parameters specified in binary blob */
 		status = isci_parse_oem_parameters(&scic_oem_params,
-						   isci_host->id, isci_fw);
+						   isci_host->id,
+						   isci_firmware);
 		if (status != SCI_SUCCESS) {
 			dev_warn(&isci_host->pdev->dev,
 				 "parsing firmware oem parameters failed\n");
-			err = -EINVAL;
-			goto out;
+			return -EINVAL;
 		}
 
 		status = isci_parse_user_parameters(&scic_user_params,
-						    isci_host->id, isci_fw);
+						    isci_host->id,
+						    isci_firmware);
 		if (status != SCI_SUCCESS) {
 			dev_warn(&isci_host->pdev->dev,
 				 "%s: isci_parse_user_parameters"
 				 " failed\n", __func__);
-			err = -EINVAL;
-			goto out;
+			return -EINVAL;
+		}
+	} else {
+		status = scic_oem_parameters_set(isci_host->core_controller,
+						 &scic_oem_params);
+		if (status != SCI_SUCCESS) {
+			dev_warn(&isci_host->pdev->dev,
+				 "%s: scic_oem_parameters_set failed\n",
+				 __func__);
+			return -ENODEV;
 		}
-	}
-
- set_default_params:
-
-	status = scic_oem_parameters_set(isci_host->core_controller,
-					 &scic_oem_params
-					 );
-
-	if (status != SCI_SUCCESS) {
-		dev_warn(&isci_host->pdev->dev,
-			 "%s: scic_oem_parameters_set failed\n",
-			 __func__);
-		err = -ENODEV;
-		goto out;
-	}
-
 
-	status = scic_user_parameters_set(isci_host->core_controller,
-					  &scic_user_params
-					  );
 
-	if (status != SCI_SUCCESS) {
-		dev_warn(&isci_host->pdev->dev,
-			 "%s: scic_user_parameters_set failed\n",
-			 __func__);
-		err = -ENODEV;
-		goto out;
+		status = scic_user_parameters_set(isci_host->core_controller,
+						  &scic_user_params);
+		if (status != SCI_SUCCESS) {
+			dev_warn(&isci_host->pdev->dev,
+				 "%s: scic_user_parameters_set failed\n",
+				 __func__);
+			return -ENODEV;
+		}
 	}
 
 	status = scic_controller_initialize(isci_host->core_controller);
@@ -687,39 +479,11 @@ int isci_host_init(struct isci_host *isci_host)
 			 "%s: scic_controller_initialize failed -"
 			 " status = 0x%x\n",
 			 __func__, status);
-		err = -ENODEV;
-		goto out;
-	}
-
-	/* @todo: use both MSI-X interrupts, and don't do indirect
-	 * calls to the handlers just register direct calls
-	 */
-	if (isci_host->pdev->msix_enabled) {
-		status = scic_controller_get_handler_methods(
-			SCIC_MSIX_INTERRUPT_TYPE,
-			SCI_MSIX_DOUBLE_VECTOR,
-			handlers
-			);
-	} else {
-		status = scic_controller_get_handler_methods(
-			SCIC_LEGACY_LINE_INTERRUPT_TYPE,
-			0,
-			handlers
-			);
-	}
-
-	if (status != SCI_SUCCESS) {
-		handlers->interrupt_handler = NULL;
-		handlers->completion_handler = NULL;
-		dev_err(&isci_host->pdev->dev,
-			"%s: scic_controller_get_handler_methods failed\n",
-			__func__);
+		return -ENODEV;
 	}
 
 	tasklet_init(&isci_host->completion_tasklet,
-		     isci_host_completion_routine,
-		     (unsigned long)isci_host
-		     );
+		     isci_host_completion_routine, (unsigned long)isci_host);
 
 	INIT_LIST_HEAD(&(isci_host->mdl_struct_list));
 
@@ -730,7 +494,7 @@ int isci_host_init(struct isci_host *isci_host)
 	err = isci_host_mdl_allocate_coherent(isci_host);
 
 	if (err)
-		goto err_out;
+		return err;
 
 	/*
 	 * keep the pool alloc size around, will use it for a bounds checking
@@ -742,40 +506,27 @@ int isci_host_init(struct isci_host *isci_host)
 					       isci_host->dma_pool_alloc_size,
 					       SLAB_HWCACHE_ALIGN, 0);
 
-	if (!isci_host->dma_pool) {
-		err = -ENOMEM;
-		goto req_obj_err_out;
-	}
+	if (!isci_host->dma_pool)
+		return -ENOMEM;
 
-	for (index = 0; index < SCI_MAX_PORTS; index++) {
+	for (index = 0; index < SCI_MAX_PORTS; index++)
 		isci_port_init(&isci_host->isci_ports[index],
-			       isci_host, index);
-	}
+			       isci_host,
+			       index);
 
 	for (index = 0; index < SCI_MAX_PHYS; index++)
 		isci_phy_init(&isci_host->phys[index], isci_host, index);
 
 	/* Why are we doing this? Is this even necessary? */
-	memcpy(&isci_host->sas_addr[0], &isci_host->phys[0].sas_addr[0],
+	memcpy(&isci_host->sas_addr[0],
+	       &isci_host->phys[0].sas_addr[0],
 	       SAS_ADDR_SIZE);
 
 	/* Start the ports */
 	for (index = 0; index < SCI_MAX_PORTS; index++) {
-
 		scic_controller_get_port_handle(controller, index, &scic_port);
 		scic_port_start(scic_port);
 	}
 
-	goto out;
-
-/* SPB_Debug: destroy request object cache */
- req_obj_err_out:
-/* SPB_Debug: destroy remote object cache */
- err_out:
-/* SPB_Debug: undo controller init, construct and alloc, remove from parent
- * controller list. */
- out:
-	if (fw)
-		release_firmware(fw);
-	return err;
+	return 0;
 }
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 3530076..26768c5 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -53,13 +53,6 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  */
 
-/**
- * This file contains the isci_module initialization routines.
- *
- * host.h
- */
-
-
 
 #if !defined(_SCI_HOST_H_)
 #define _SCI_HOST_H_
@@ -79,10 +72,6 @@
 #define SCI_SCU_BAR_SIZE  (4*1024*1024)
 #define SCI_IO_SPACE_BAR0 2
 #define SCI_IO_SPACE_BAR1 3
-#define SCI_MSIX_NORMAL_VECTOR 0
-#define SCI_MSIX_ERROR_VECTOR 1
-#define SCI_MSIX_SINGLE_VECTOR 1
-#define SCI_MSIX_DOUBLE_VECTOR 2
 #define ISCI_CAN_QUEUE_VAL 250 /* < SCI_MAX_IO_REQUESTS ? */
 #define SCIC_CONTROLLER_STOP_TIMEOUT 5000
 
@@ -96,7 +85,6 @@ struct coherent_memory_info {
 
 struct isci_host {
 	struct scic_sds_controller *core_controller;
-	struct scic_controller_handler_methods scic_irq_handlers[SCI_NUM_MSI_X_INT];
 	union scic_oem_parameters oem_parameters;
 
 	int id; /* unique within a given pci device */
@@ -121,13 +109,15 @@ struct isci_host {
 	u8 sas_addr[SAS_ADDR_SIZE];
 
 	enum isci_status status;
+	#define IHOST_START_PENDING 0
+	#define IHOST_STOP_PENDING 1
+	unsigned long flags;
+	wait_queue_head_t eventq;
 	struct Scsi_Host *shost;
 	struct tasklet_struct completion_tasklet;
 	struct list_head mdl_struct_list;
 	struct list_head requests_to_complete;
 	struct list_head requests_to_abort;
-	struct completion stop_complete;
-	struct completion start_complete;
 	spinlock_t scic_lock;
 	struct isci_host *next;
 };
@@ -143,7 +133,6 @@ struct isci_host {
 struct isci_pci_info {
 	struct msix_entry msix_entries[SCI_MAX_MSIX_INT];
 	int core_lib_array_index;
-	SCI_LIBRARY_HANDLE_T core_lib_handle;
 	struct isci_host *hosts;
 };
 
@@ -215,6 +204,17 @@ static inline void isci_host_can_dequeue(
 	spin_unlock_irqrestore(&isci_host->queue_lock, flags);
 }
 
+static inline void wait_for_start(struct isci_host *ihost)
+{
+	wait_event(ihost->eventq, !test_bit(IHOST_START_PENDING, &ihost->flags));
+}
+
+static inline void wait_for_stop(struct isci_host *ihost)
+{
+	wait_event(ihost->eventq, !test_bit(IHOST_STOP_PENDING, &ihost->flags));
+}
+
+
 /**
  * isci_host_from_sas_ha() - This accessor retrieves the isci_host object
  *    reference from the Linux sas_ha_struct reference.
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 07b072f..a5467cf 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -73,15 +73,21 @@ static DEFINE_PCI_DEVICE_TABLE(isci_id_table) = {
 	{ PCI_VDEVICE(INTEL, 0x1D67),},
 	{ PCI_VDEVICE(INTEL, 0x1D69),},
 	{ PCI_VDEVICE(INTEL, 0x1D6B),},
+	{ PCI_VDEVICE(INTEL, 0x1D6D),},
+	{ PCI_VDEVICE(INTEL, 0x1D6F),},
 	{ PCI_VDEVICE(INTEL, 0x1D60),},
 	{ PCI_VDEVICE(INTEL, 0x1D62),},
 	{ PCI_VDEVICE(INTEL, 0x1D64),},
 	{ PCI_VDEVICE(INTEL, 0x1D66),},
 	{ PCI_VDEVICE(INTEL, 0x1D68),},
 	{ PCI_VDEVICE(INTEL, 0x1D6A),},
+	{ PCI_VDEVICE(INTEL, 0x1D6C),},
+	{ PCI_VDEVICE(INTEL, 0x1D6E),},
 	{}
 };
 
+struct isci_firmware *isci_firmware;
+
 static int __devinit isci_pci_probe(
 	struct pci_dev *pdev,
 	const struct pci_device_id *device_id_p);
@@ -98,8 +104,6 @@ static struct pci_driver isci_pci_driver = {
 };
 
 /* linux isci specific settings */
-int loglevel = 3;
-module_param(loglevel, int, S_IRUGO | S_IWUSR);
 
 #if defined(CONFIG_PBG_HBA_A0)
 int isci_si_rev = ISCI_SI_REVA0;
@@ -115,6 +119,7 @@ static struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
 	.name				= DRV_NAME,
+	.proc_name			= DRV_NAME,
 	.queuecommand			= sas_queuecommand,
 	.target_alloc			= sas_target_alloc,
 	.slave_configure		= sas_slave_configure,
@@ -332,11 +337,17 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 		int id = i / SCI_NUM_MSI_X_INT;
 		struct msix_entry *msix = &pci_info->msix_entries[i];
 		struct isci_host *isci_host = isci_host_by_id(pdev, id);
+		irq_handler_t isr;
+
+		/* odd numbered vectors are error interrupts */
+		if (i & 1)
+			isr = isci_error_isr;
+		else
+			isr = isci_msix_isr;
 
 		BUG_ON(!isci_host);
 
-		/* @todo: need to handle error case. */
-		err = devm_request_irq(&pdev->dev, msix->vector, isci_isr, 0,
+		err = devm_request_irq(&pdev->dev, msix->vector, isr, 0,
 				       DRV_NAME"-msix", isci_host);
 		if (!err)
 			continue;
@@ -355,7 +366,7 @@ static int isci_setup_interrupts(struct pci_dev *pdev)
 	return 0;
 
  intx:
-	err = devm_request_irq(&pdev->dev, pdev->irq, isci_legacy_isr,
+	err = devm_request_irq(&pdev->dev, pdev->irq, isci_intx_isr,
 			       IRQF_SHARED, DRV_NAME"-intx", pdev);
 
 	return err;
@@ -514,11 +525,73 @@ static void check_si_rev(struct pci_dev *pdev)
 		
 }
 
+static int isci_verify_firmware(const struct firmware *fw,
+				struct isci_firmware *isci_fw)
+{
+	const u8 *tmp;
+
+	if (fw->size < ISCI_FIRMWARE_MIN_SIZE)
+		return -EINVAL;
+
+	tmp = fw->data;
+
+	/* 12th char should be the NULL terminate for the ID string */
+	if (tmp[11] != '\0')
+		return -EINVAL;
+
+	if (strncmp("#SCU MAGIC#", tmp, 11) != 0)
+		return -EINVAL;
+
+	isci_fw->id = tmp;
+	isci_fw->version = fw->data[ISCI_FW_VER_OFS];
+	isci_fw->subversion = fw->data[ISCI_FW_SUBVER_OFS];
+
+	tmp = fw->data + ISCI_FW_DATA_OFS;
+
+	while (*tmp != ISCI_FW_HDR_EOF) {
+		switch (*tmp) {
+		case ISCI_FW_HDR_PHYMASK:
+			tmp++;
+			isci_fw->phy_masks_size = *tmp;
+			tmp++;
+			isci_fw->phy_masks = (const u32 *)tmp;
+			tmp += sizeof(u32) * isci_fw->phy_masks_size;
+			break;
+
+		case ISCI_FW_HDR_PHYGEN:
+			tmp++;
+			isci_fw->phy_gens_size = *tmp;
+			tmp++;
+			isci_fw->phy_gens = (const u32 *)tmp;
+			tmp += sizeof(u32) * isci_fw->phy_gens_size;
+			break;
+
+		case ISCI_FW_HDR_SASADDR:
+			tmp++;
+			isci_fw->sas_addrs_size = *tmp;
+			tmp++;
+			isci_fw->sas_addrs = (const u64 *)tmp;
+			tmp += sizeof(u64) * isci_fw->sas_addrs_size;
+			break;
+
+		default:
+			pr_err("bad field in firmware binary blob\n");
+			return -EINVAL;
+		}
+	}
+
+	pr_info("isci firmware v%u.%u loaded.\n",
+	       isci_fw->version, isci_fw->subversion);
+
+	return SCI_SUCCESS;
+}
+
 static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct isci_pci_info *pci_info;
 	int err, i;
 	struct isci_host *isci_host;
+	const struct firmware *fw = NULL;
 
 	check_si_rev(pdev);
 
@@ -527,6 +600,33 @@ static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_devic
 		return -ENOMEM;
 	pci_set_drvdata(pdev, pci_info);
 
+	err = request_firmware(&fw, ISCI_FW_NAME, &pdev->dev);
+	if (err) {
+		dev_warn(&pdev->dev,
+			 "Loading firmware failed, using default values\n");
+		dev_warn(&pdev->dev,
+			 "Default OEM configuration being used:"
+			 " 4 narrow ports, and default SAS Addresses\n");
+	} else {
+		isci_firmware = devm_kzalloc(&pdev->dev,
+					     sizeof(struct isci_firmware),
+					     GFP_KERNEL);
+		if (isci_firmware) {
+			err = isci_verify_firmware(fw, isci_firmware);
+			if (err != SCI_SUCCESS) {
+				dev_warn(&pdev->dev,
+					 "firmware verification failed\n");
+				dev_warn(&pdev->dev,
+					 "Default OEM configuration being used:"
+					 " 4 narrow ports, and default SAS "
+					 "Addresses\n");
+				devm_kfree(&pdev->dev, isci_firmware);
+				isci_firmware = NULL;
+			}
+		}
+		release_firmware(fw);
+	}
+
 	err = isci_pci_init(pdev);
 	if (err)
 		return err;
diff --git a/drivers/scsi/isci/isci.h b/drivers/scsi/isci/isci.h
index 7d984f4..6c79b29 100644
--- a/drivers/scsi/isci/isci.h
+++ b/drivers/scsi/isci/isci.h
@@ -79,15 +79,14 @@
 #include <scsi/libsas.h>
 #include <scsi/scsi.h>
 
-#include "sci_types.h"
 #include "sci_base_controller.h"
 #include "scic_controller.h"
 #include "host.h"
 #include "timers.h"
 #include "sci_status.h"
 
-extern int loglevel;
 extern struct kmem_cache *isci_kmem_cache;
+extern struct isci_firmware *isci_firmware;
 
 #define ISCI_FW_NAME		"isci/isci_firmware.bin"
 
@@ -115,8 +114,14 @@ struct isci_firmware {
 	u8 sas_addrs_size;
 };
 
-irqreturn_t isci_isr(int vec, void *data);
-irqreturn_t isci_legacy_isr(int vec, void *data);
+irqreturn_t isci_msix_isr(int vec, void *data);
+irqreturn_t isci_intx_isr(int vec, void *data);
+irqreturn_t isci_error_isr(int vec, void *data);
+
+bool scic_sds_controller_isr(struct scic_sds_controller *scic);
+void scic_sds_controller_completion_handler(struct scic_sds_controller *scic);
+bool scic_sds_controller_error_isr(struct scic_sds_controller *scic);
+void scic_sds_controller_error_handler(struct scic_sds_controller *scic);
 
 enum sci_status isci_parse_oem_parameters(
 	union scic_oem_parameters *oem_params,
diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 2343f65..446da20 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -263,6 +263,8 @@ void isci_port_link_up(
 		success = false;
 	}
 
+	isci_phy->sas_phy.phy->negotiated_linkrate = sci_phy_linkrate(phy);
+
 	spin_unlock_irqrestore(&isci_phy->sas_phy.frame_rcvd_lock, flags);
 
 	/* Notify libsas that we have an address frame, if indeed
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index dbf3c82..dec9033 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -507,6 +507,8 @@ int isci_remote_device_found(struct domain_device *domain_dev)
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: domain_device = %p\n", __func__, domain_dev);
 
+	wait_for_start(isci_host);
+
 	sas_port = domain_dev->port;
 	sas_phy = list_first_entry(&sas_port->phy_list, struct asd_sas_phy,
 				   port_phy_el);
@@ -560,8 +562,6 @@ int isci_remote_device_found(struct domain_device *domain_dev)
 		return -ENODEV;
 	}
 
-	wait_for_completion(&isci_host->start_complete);
-
 	return 0;
 }
 /**
@@ -686,12 +686,6 @@ void isci_remote_device_change_state(
 {
 	unsigned long flags;
 
-	dev_dbg(&isci_device->isci_port->isci_host->pdev->dev,
-		"%s: isci_device = %p, state = 0x%x",
-		__func__,
-		isci_device,
-		status);
-
 	spin_lock_irqsave(&isci_device->state_lock, flags);
 	isci_device->status = status;
 	spin_unlock_irqrestore(&isci_device->state_lock, flags);
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index e564121..81a7733 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -285,7 +285,6 @@ static int isci_request_alloc_core(
 
 	/* initialize the request object.	*/
 	spin_lock_init(&request->state_lock);
-	isci_request_change_state(request, allocated);
 	request->sci_request_mem_ptr = ((u8 *)request) +
 				       sizeof(struct isci_request);
 	request->request_daddr = handle;
@@ -302,6 +301,7 @@ static int isci_request_alloc_core(
 	INIT_LIST_HEAD(&request->dev_node);
 
 	*isci_request = request;
+	isci_request_change_state(request, allocated);
 
 	return ret;
 }
@@ -1237,44 +1237,12 @@ u32 isci_request_io_request_get_transfer_length(struct isci_request *request)
  *
  * data direction for specified request.
  */
-SCI_IO_REQUEST_DATA_DIRECTION isci_request_io_request_get_data_direction(
+enum dma_data_direction isci_request_io_request_get_data_direction(
 	struct isci_request *request)
 {
 	struct sas_task *task = isci_request_access_task(request);
-	SCI_IO_REQUEST_DATA_DIRECTION ret;
-
-	switch (task->data_dir) {
-
-	case DMA_FROM_DEVICE:
-		ret = SCI_IO_REQUEST_DATA_IN;
-		dev_dbg(&request->isci_host->pdev->dev,
-			"%s: request=%p, FROM_DEVICE\n",
-			__func__,
-			request);
-		break;
-
-	case DMA_TO_DEVICE:
-		ret = SCI_IO_REQUEST_DATA_OUT;
-		dev_dbg(&request->isci_host->pdev->dev,
-			"%s: request=%p, TO_DEVICE\n",
-			__func__,
-			request);
-		break;
 
-	case DMA_BIDIRECTIONAL:
-	case DMA_NONE:
-	default:
-		ret = SCI_IO_REQUEST_NO_DATA;
-		dev_dbg(&request->isci_host->pdev->dev,
-			"%s: request=%p, unhandled direction case, "
-			"data_dir=%d\n",
-			__func__,
-			request,
-			task->data_dir);
-		break;
-
-	}
-	return ret;
+	return task->data_dir;
 }
 
 /**
@@ -1421,8 +1389,8 @@ u32 isci_request_ssp_io_request_get_lun(
 
 	for (i = 0; i < 8; i++)
 		dev_dbg(&request->isci_host->pdev->dev,
-			"%s: request->task->ssp_task.LUN[%d] = %x\n",
-			__func__, i, request->task->ssp_task.LUN[i]);
+			"%s: task->ssp_task.LUN[%d] = %x\n",
+			__func__, i, task->ssp_task.LUN[i]);
 
 #endif
 
diff --git a/drivers/scsi/isci/request.h b/drivers/scsi/isci/request.h
index 5079d4a..166295e 100644
--- a/drivers/scsi/isci/request.h
+++ b/drivers/scsi/isci/request.h
@@ -346,8 +346,7 @@ void isci_request_io_request_complete(
 u32 isci_request_io_request_get_transfer_length(
 	struct isci_request *request);
 
-SCI_IO_REQUEST_DATA_DIRECTION isci_request_io_request_get_data_direction(
-	struct isci_request *request);
+enum dma_data_direction isci_request_io_request_get_data_direction(struct isci_request *req);
 
 /**
  * isci_request_io_request_get_next_sge() - This function is called by the sci
diff --git a/drivers/scsi/isci/sci_environment.h b/drivers/scsi/isci/sci_environment.h
index e1020ee..8d57f95 100644
--- a/drivers/scsi/isci/sci_environment.h
+++ b/drivers/scsi/isci/sci_environment.h
@@ -108,5 +108,19 @@ enum {
 
 extern int isci_si_rev;
 
+static inline bool is_a0(void)
+{
+	return isci_si_rev == ISCI_SI_REVA0;
+}
+
+static inline bool is_a2(void)
+{
+	return isci_si_rev == ISCI_SI_REVA2;
+}
+
+static inline bool is_b0(void)
+{
+	return isci_si_rev > ISCI_SI_REVA2;
+}
 
 #endif
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 5e6f558..6f98f6c 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -164,8 +164,7 @@ int isci_task_execute_task(struct sas_task *task, int num, gfp_t gfp_flags)
 		 * for the quiesce spinlock.
 		 */
 
-		if (isci_host_get_state(isci_host) == isci_starting ||
-		    (device && ((isci_remote_device_get_state(device) == isci_ready) ||
+		if ((device && ((isci_remote_device_get_state(device) == isci_ready) ||
 		    (isci_remote_device_get_state(device) == isci_host_quiesce)))) {
 
 			/* Forces a retry from scsi mid layer. */


