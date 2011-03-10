From: Dan Williams <dan.j.williams@intel.com>
Subject: [RFC PATCH 00/10] isci: core
Date: Thu, 10 Mar 2011 02:54:19 -0800
Message-ID: <20110310105347.6485.20780.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21336 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab1CJKxC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 05:53:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

As first introduced in "[RFC PATCH 0/6] isci: initial driver release
(part1: intro and lldd) " [1], the isci driver is split into an lldd
layer that interfaces with libsas and a core layer that interfaces with
the hardware.  Quoting from the original introduction:

   Driver overview:
   The hardware accelerates all the protocol fast paths (SSP, STP
   FPDMA and UDMA), and relies on the the driver for everything
   else.  One example is legacy sata pio reads which are managed
   "manually" by their own state machine in the driver.  The driver
   submits the read and when the data fis comes back the hardware,
   not having acceleration for pio operations, assigns it to an
   unidentified frame queue.  The core then associates that frame
   with the pending pio request, copies the data into the location
   specified by the original sgl, and completes the command up to
   the lldd.

Since the initial import the core has shed about 10k lines of code.
The todo list has also shrunk, we have eliminated the os abstractions
(formerly in drivers/scsi/isci/deprecated.c), and usages of phys_to_virt
and virt_to_phys have been replaced with proper dma api and kmap calls.

The full driver and history is available in git:

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

The libsas-pending branch contains proposed libsas fixes (pending
acceptance into scsi-misc):

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git libsas-pending

The x86-pending branch contains a proposed api for mapping bios roms so
the driver can retrieve configuration parameters (pending acceptance
into -tip):

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git x86-pending

--
Dan for the isci driver team


[1]: http://marc.info/?l=linux-scsi&m=129703780424729&w=2

---

Dan Williams (10):
      isci/core: controller
      isci/core: phy
      isci/core: port
      isci/core: remote device
      isci/core: remote node context
      isci/core: stp
      isci/core: request (general, ssp and smp)
      isci/core: unsolicited frame handling and registers
      isci/core: base state machine and memory descriptors
      isci/core: common definitions and utility functions


 drivers/scsi/isci/core/intel_ata.h                 |  554 +++
 drivers/scsi/isci/core/intel_sas.h                 |  948 +++++
 drivers/scsi/isci/core/intel_sat.h                 |   95 
 drivers/scsi/isci/core/intel_sata.h                |  280 +
 drivers/scsi/isci/core/intel_scsi.h                |  474 ++
 drivers/scsi/isci/core/sati_device.h               |  156 +
 drivers/scsi/isci/core/sati_translator_sequence.h  |  304 ++
 drivers/scsi/isci/core/sati_types.h                |  145 +
 drivers/scsi/isci/core/sci_base_controller.h       |  306 ++
 .../isci/core/sci_base_memory_descriptor_list.c    |  159 +
 .../isci/core/sci_base_memory_descriptor_list.h    |  153 +
 drivers/scsi/isci/core/sci_base_phy.h              |  200 +
 drivers/scsi/isci/core/sci_base_port.h             |  203 +
 drivers/scsi/isci/core/sci_base_remote_device.h    |  274 +
 drivers/scsi/isci/core/sci_base_request.h          |  195 +
 drivers/scsi/isci/core/sci_base_state.h            |   90 
 drivers/scsi/isci/core/sci_base_state_machine.c    |  182 +
 drivers/scsi/isci/core/sci_base_state_machine.h    |  141 +
 drivers/scsi/isci/core/sci_controller.h            |   98 +
 drivers/scsi/isci/core/sci_controller_constants.h  |  215 +
 .../scsi/isci/core/sci_memory_descriptor_list.h    |  168 +
 drivers/scsi/isci/core/sci_object.h                |   98 +
 drivers/scsi/isci/core/sci_pool.h                  |  199 +
 drivers/scsi/isci/core/sci_status.h                |  409 ++
 drivers/scsi/isci/core/sci_util.c                  |  101 +
 drivers/scsi/isci/core/sci_util.h                  |  108 +
 drivers/scsi/isci/core/scic_config_parameters.h    |  346 ++
 drivers/scsi/isci/core/scic_controller.h           |  495 +++
 drivers/scsi/isci/core/scic_io_request.h           |  511 +++
 drivers/scsi/isci/core/scic_phy.h                  |  305 ++
 drivers/scsi/isci/core/scic_port.h                 |  195 +
 drivers/scsi/isci/core/scic_remote_device.h        |  294 ++
 drivers/scsi/isci/core/scic_sds_controller.c       | 3804 ++++++++++++++++++++
 drivers/scsi/isci/core/scic_sds_controller.h       |  722 ++++
 .../scsi/isci/core/scic_sds_controller_registers.h |  463 ++
 drivers/scsi/isci/core/scic_sds_pci.h              |   94 
 drivers/scsi/isci/core/scic_sds_phy.c              | 2726 ++++++++++++++
 drivers/scsi/isci/core/scic_sds_phy.h              |  476 +++
 drivers/scsi/isci/core/scic_sds_phy_registers.h    |  248 +
 drivers/scsi/isci/core/scic_sds_port.c             | 2915 +++++++++++++++
 drivers/scsi/isci/core/scic_sds_port.h             |  499 +++
 .../isci/core/scic_sds_port_configuration_agent.c  |  863 +++++
 .../isci/core/scic_sds_port_configuration_agent.h  |  108 +
 drivers/scsi/isci/core/scic_sds_port_registers.h   |  147 +
 drivers/scsi/isci/core/scic_sds_remote_device.c    | 2079 +++++++++++
 drivers/scsi/isci/core/scic_sds_remote_device.h    |  570 +++
 .../scsi/isci/core/scic_sds_remote_node_context.c  | 1247 +++++++
 .../scsi/isci/core/scic_sds_remote_node_context.h  |  323 ++
 .../scsi/isci/core/scic_sds_remote_node_table.c    |  600 +++
 .../scsi/isci/core/scic_sds_remote_node_table.h    |  195 +
 drivers/scsi/isci/core/scic_sds_request.c          | 2174 +++++++++++
 drivers/scsi/isci/core/scic_sds_request.h          |  469 ++
 .../scsi/isci/core/scic_sds_smp_remote_device.c    |  325 ++
 drivers/scsi/isci/core/scic_sds_smp_request.c      |  669 ++++
 drivers/scsi/isci/core/scic_sds_smp_request.h      |   69 
 drivers/scsi/isci/core/scic_sds_ssp_request.c      |  268 +
 .../scsi/isci/core/scic_sds_stp_packet_request.c   |  834 ++++
 .../scsi/isci/core/scic_sds_stp_packet_request.h   |  153 +
 drivers/scsi/isci/core/scic_sds_stp_pio_request.h  |  116 +
 .../scsi/isci/core/scic_sds_stp_remote_device.c    |  908 +++++
 drivers/scsi/isci/core/scic_sds_stp_request.c      | 1941 ++++++++++
 drivers/scsi/isci/core/scic_sds_stp_request.h      |  221 +
 .../isci/core/scic_sds_unsolicited_frame_control.c |  383 ++
 .../isci/core/scic_sds_unsolicited_frame_control.h |  286 ++
 drivers/scsi/isci/core/scic_task_request.h         |  147 +
 drivers/scsi/isci/core/scu_completion_codes.h      |  283 +
 drivers/scsi/isci/core/scu_constants.h             |  151 +
 drivers/scsi/isci/core/scu_event_codes.h           |  336 ++
 drivers/scsi/isci/core/scu_registers.h             | 1830 ++++++++++
 drivers/scsi/isci/core/scu_remote_node_context.h   |  229 +
 drivers/scsi/isci/core/scu_task_context.h          |  942 +++++
 drivers/scsi/isci/core/scu_unsolicited_frame.h     |  117 +
 drivers/scsi/isci/core/scu_viit_data.h             |  178 +
 73 files changed, 39509 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/isci/core/intel_ata.h
 create mode 100644 drivers/scsi/isci/core/intel_sas.h
 create mode 100644 drivers/scsi/isci/core/intel_sat.h
 create mode 100644 drivers/scsi/isci/core/intel_sata.h
 create mode 100644 drivers/scsi/isci/core/intel_scsi.h
 create mode 100644 drivers/scsi/isci/core/sati_device.h
 create mode 100644 drivers/scsi/isci/core/sati_translator_sequence.h
 create mode 100644 drivers/scsi/isci/core/sati_types.h
 create mode 100644 drivers/scsi/isci/core/sci_base_controller.h
 create mode 100644 drivers/scsi/isci/core/sci_base_memory_descriptor_list.c
 create mode 100644 drivers/scsi/isci/core/sci_base_memory_descriptor_list.h
 create mode 100644 drivers/scsi/isci/core/sci_base_phy.h
 create mode 100644 drivers/scsi/isci/core/sci_base_port.h
 create mode 100644 drivers/scsi/isci/core/sci_base_remote_device.h
 create mode 100644 drivers/scsi/isci/core/sci_base_request.h
 create mode 100644 drivers/scsi/isci/core/sci_base_state.h
 create mode 100644 drivers/scsi/isci/core/sci_base_state_machine.c
 create mode 100644 drivers/scsi/isci/core/sci_base_state_machine.h
 create mode 100644 drivers/scsi/isci/core/sci_controller.h
 create mode 100644 drivers/scsi/isci/core/sci_controller_constants.h
 create mode 100644 drivers/scsi/isci/core/sci_memory_descriptor_list.h
 create mode 100644 drivers/scsi/isci/core/sci_object.h
 create mode 100644 drivers/scsi/isci/core/sci_pool.h
 create mode 100644 drivers/scsi/isci/core/sci_status.h
 create mode 100644 drivers/scsi/isci/core/sci_util.c
 create mode 100644 drivers/scsi/isci/core/sci_util.h
 create mode 100644 drivers/scsi/isci/core/scic_config_parameters.h
 create mode 100644 drivers/scsi/isci/core/scic_controller.h
 create mode 100644 drivers/scsi/isci/core/scic_io_request.h
 create mode 100644 drivers/scsi/isci/core/scic_phy.h
 create mode 100644 drivers/scsi/isci/core/scic_port.h
 create mode 100644 drivers/scsi/isci/core/scic_remote_device.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_controller.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_controller.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_controller_registers.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_pci.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_phy.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_phy.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_phy_registers.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_port.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_port.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_port_configuration_agent.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_port_configuration_agent.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_port_registers.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_device.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_device.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_node_context.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_node_context.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_node_table.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_remote_node_table.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_request.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_request.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_smp_remote_device.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_smp_request.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_smp_request.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_ssp_request.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_packet_request.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_packet_request.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_pio_request.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_remote_device.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_request.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_stp_request.h
 create mode 100644 drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.c
 create mode 100644 drivers/scsi/isci/core/scic_sds_unsolicited_frame_control.h
 create mode 100644 drivers/scsi/isci/core/scic_task_request.h
 create mode 100644 drivers/scsi/isci/core/scu_completion_codes.h
 create mode 100644 drivers/scsi/isci/core/scu_constants.h
 create mode 100644 drivers/scsi/isci/core/scu_event_codes.h
 create mode 100644 drivers/scsi/isci/core/scu_registers.h
 create mode 100644 drivers/scsi/isci/core/scu_remote_node_context.h
 create mode 100644 drivers/scsi/isci/core/scu_task_context.h
 create mode 100644 drivers/scsi/isci/core/scu_unsolicited_frame.h
 create mode 100644 drivers/scsi/isci/core/scu_viit_data.h
