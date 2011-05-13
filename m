From: Dan Williams <dan.j.williams@intel.com>
Subject: [GIT PULL] isci merge candidate
Date: Fri, 13 May 2011 13:14:40 -0700
Message-ID: <1305317680.21099.83.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, Christoph Hellwig <hch@lst.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Jiang <dave.jiang@intel.com>, David Milburn <dmilburn@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

[ Linus, only cc'ing you in case a new-driver merge exception can be
entertained at this very late date.  James made clear he needed this in
advance of rc7, and this still needs Christoph's ack, but I would be
remiss not to send this after reaching this milestone...]

James, Christoph,

The isci driver team has now completed the major rework items addressed
in the review on linux-scsi (including removal of state handlers,
merging lldd and 'core', cleaning up the source code layout).

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

We are now at a diffstat of:

	46 files changed, 27172 insertions(+), 0 deletions(-)

...which is a massive improvement compared to where we started at the
beginning of this year.

	161 files changed, 64288 insertions(+), 0 deletions(-)

This driver supports the 6Gb/s SAS/SATA capabilities of the upcoming
Intel(R) C600 series chipset family, where 2.6.39 is likely to be the
latest upstream kernel release available at that time.  Below I include
the full diffstat of the current driver, followed by the changes since
the last release.  I want to take this opportunity to thank the
reviewers and highlight that they have been credited with Reported-by's
(55 in total), with Christoph coming out on the top of that list with
44.

 drivers/scsi/Kconfig                          |   13 +
 drivers/scsi/Makefile                         |    1 +
 drivers/scsi/isci/Makefile                    |    9 +
 drivers/scsi/isci/firmware/Makefile           |   19 +
 drivers/scsi/isci/firmware/README             |   36 +
 drivers/scsi/isci/firmware/create_fw.c        |   99 +
 drivers/scsi/isci/firmware/create_fw.h        |   77 +
 drivers/scsi/isci/host.c                      | 3241 ++++++++++++++++++++++
 drivers/scsi/isci/host.h                      |  828 ++++++
 drivers/scsi/isci/init.c                      |  598 ++++
 drivers/scsi/isci/isci.h                      |  554 ++++
 drivers/scsi/isci/phy.c                       | 1454 ++++++++++
 drivers/scsi/isci/phy.h                       |  583 ++++
 drivers/scsi/isci/pool.h                      |  199 ++
 drivers/scsi/isci/port.c                      | 1960 +++++++++++++
 drivers/scsi/isci/port.h                      |  398 +++
 drivers/scsi/isci/port_config.c               |  826 ++++++
 drivers/scsi/isci/probe_roms.c                |  270 ++
 drivers/scsi/isci/probe_roms.h                |  273 ++
 drivers/scsi/isci/registers.h                 | 1934 +++++++++++++
 drivers/scsi/isci/remote_device.c             | 1548 +++++++++++
 drivers/scsi/isci/remote_device.h             |  481 ++++
 drivers/scsi/isci/remote_node_context.c       |  652 +++++
 drivers/scsi/isci/remote_node_context.h       |  227 ++
 drivers/scsi/isci/remote_node_table.c         |  598 ++++
 drivers/scsi/isci/remote_node_table.h         |  188 ++
 drivers/scsi/isci/request.c                   | 3687 +++++++++++++++++++++++++
 drivers/scsi/isci/request.h                   |  805 ++++++
 drivers/scsi/isci/sas.h                       |  228 ++
 drivers/scsi/isci/sata.c                      |  234 ++
 drivers/scsi/isci/sata.h                      |   79 +
 drivers/scsi/isci/scu_completion_codes.h      |  283 ++
 drivers/scsi/isci/scu_event_codes.h           |  336 +++
 drivers/scsi/isci/scu_remote_node_context.h   |  229 ++
 drivers/scsi/isci/scu_task_context.h          |  942 +++++++
 drivers/scsi/isci/scu_unsolicited_frame.h     |  117 +
 drivers/scsi/isci/state_machine.c             |  162 ++
 drivers/scsi/isci/state_machine.h             |  124 +
 drivers/scsi/isci/task.c                      | 1557 +++++++++++
 drivers/scsi/isci/task.h                      |  368 +++
 drivers/scsi/isci/timers.c                    |  245 ++
 drivers/scsi/isci/timers.h                    |   88 +
 drivers/scsi/isci/unsolicited_frame_control.c |  354 +++
 drivers/scsi/isci/unsolicited_frame_control.h |  251 ++
 firmware/Makefile                             |    1 +
 firmware/isci/isci_firmware.bin.ihex          |   16 +
 46 files changed, 27172 insertions(+), 0 deletions(-)

--
Dan for the isci driver team

The following changes since commit 364815082e2069616a6129bc4e59a1e80e33853f:

  isci: kill scic_sds_remote_device.state_handlers (2011-05-01 17:15:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master

Adam Gruchala (1):
      isci: merge phy substates

Artur Wojcik (1):
      isci: unify isci_host data structures

Dan Williams (38):
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

Dave Jiang (16):
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

Edmund Nadolski (2):
      isci: kill scic_controller_get_port_handle function
      isci: remove scic_sds_port_increment_request_count

Jacek Danecki (1):
      isci: rnc state machine table c99 conversion

Piotr Sawicki (9):
      isci: unify request start handlers
      isci: c99 port state handlers
      isci: merge port ready substates into primary state machine
      isci: remove port start handler
      isci: unify port stop handlers
      isci: remove port destruct handler
      isci: unify port reset, add_phy, and remove_phy handlers
      isci: remove port frame and event handlers
      isci: unify port link_up and link_down handlers

 drivers/scsi/Kconfig                               |   18 -
 drivers/scsi/isci/Makefile                         |   19 +-
 drivers/scsi/isci/core/intel_ata.h                 |  554 ----
 drivers/scsi/isci/core/intel_sas.h                 |  737 -----
 drivers/scsi/isci/core/intel_sat.h                 |   95 -
 drivers/scsi/isci/core/intel_sata.h                |  280 --
 drivers/scsi/isci/core/intel_scsi.h                |  474 ---
 drivers/scsi/isci/core/sci_base_state.h            |   84 -
 drivers/scsi/isci/core/sci_controller.h            |   69 -
 drivers/scsi/isci/core/sci_controller_constants.h  |  215 --
 drivers/scsi/isci/core/sci_status.h                |  409 ---
 drivers/scsi/isci/core/sci_util.c                  |  100 -
 drivers/scsi/isci/core/sci_util.h                  |  108 -
 drivers/scsi/isci/core/scic_config_parameters.h    |  299 --
 drivers/scsi/isci/core/scic_controller.h           |  143 -
 drivers/scsi/isci/core/scic_io_request.h           |  328 --
 drivers/scsi/isci/core/scic_phy.h                  |  306 --
 drivers/scsi/isci/core/scic_port.h                 |   97 -
 drivers/scsi/isci/core/scic_sds_controller.c       | 3081 ------------------
 drivers/scsi/isci/core/scic_sds_controller.h       |  599 ----
 drivers/scsi/isci/core/scic_sds_phy.c              | 2405 --------------
 drivers/scsi/isci/core/scic_sds_phy.h              |  462 ---
 drivers/scsi/isci/core/scic_sds_port.c             | 2484 ---------------
 drivers/scsi/isci/core/scic_sds_port.h             |  450 ---
 .../isci/core/scic_sds_port_configuration_agent.h  |  108 -
 drivers/scsi/isci/core/scic_sds_port_registers.h   |   66 -
 drivers/scsi/isci/core/scic_sds_request.c          | 1800 -----------
 drivers/scsi/isci/core/scic_sds_request.h          |  484 ---
 drivers/scsi/isci/core/scic_sds_smp_request.c      |  628 ----
 drivers/scsi/isci/core/scic_sds_smp_request.h      |   68 -
 drivers/scsi/isci/core/scic_sds_ssp_request.c      |  243 --
 .../scsi/isci/core/scic_sds_stp_packet_request.h   |  114 -
 drivers/scsi/isci/core/scic_sds_stp_pio_request.h  |  105 -
 drivers/scsi/isci/core/scic_sds_stp_request.c      | 1813 -----------
 drivers/scsi/isci/core/scic_sds_stp_request.h      |  196 --
 drivers/scsi/isci/core/scic_task_request.h         |  147 -
 drivers/scsi/isci/core/scu_constants.h             |  151 -
 drivers/scsi/isci/core/scu_viit_data.h             |  178 --
 drivers/scsi/isci/host.c                           | 2869 +++++++++++++++++-
 drivers/scsi/isci/host.h                           |  671 ++++-
 drivers/scsi/isci/init.c                           |   18 +-
 drivers/scsi/isci/isci.h                           |  503 +++-
 drivers/scsi/isci/phy.c                            | 1397 ++++++++-
 drivers/scsi/isci/phy.h                            |  527 +++-
 drivers/scsi/isci/{core/sci_pool.h => pool.h}      |    0
 drivers/scsi/isci/port.c                           | 1907 ++++++++++--
 drivers/scsi/isci/port.h                           |  343 ++-
 ...ds_port_configuration_agent.c => port_config.c} |  264 +-
 drivers/scsi/isci/probe_roms.c                     |    2 -
 drivers/scsi/isci/probe_roms.h                     |  125 +-
 .../isci/{core/scu_registers.h => registers.h}     |  110 +-
 drivers/scsi/isci/remote_device.c                  |  152 +-
 drivers/scsi/isci/remote_device.h                  |    3 +-
 drivers/scsi/isci/remote_node_context.c            | 1135 ++-----
 drivers/scsi/isci/remote_node_context.h            |  105 +-
 drivers/scsi/isci/remote_node_table.c              |    2 -
 drivers/scsi/isci/remote_node_table.h              |    9 +-
 drivers/scsi/isci/request.c                        | 3305 +++++++++++++++++---
 drivers/scsi/isci/request.h                        |  485 +++-
 drivers/scsi/isci/sas.h                            |  228 ++
 drivers/scsi/isci/sata.c                           |  138 +-
 drivers/scsi/isci/sata.h                           |    4 -
 drivers/scsi/isci/sci_environment.h                |  125 -
 .../scsi/isci/{core => }/scu_completion_codes.h    |    0
 drivers/scsi/isci/{core => }/scu_event_codes.h     |    0
 drivers/scsi/isci/{core => }/scu_task_context.h    |    0
 .../scsi/isci/{core => }/scu_unsolicited_frame.h   |    0
 .../sci_base_state_machine.c => state_machine.c}   |   26 +-
 .../sci_base_state_machine.h => state_machine.h}   |   71 +-
 drivers/scsi/isci/task.c                           |  322 +--
 drivers/scsi/isci/task.h                           |   51 +-
 drivers/scsi/isci/timers.c                         |    1 +
 ...frame_control.c => unsolicited_frame_control.c} |   20 +-
 ...frame_control.h => unsolicited_frame_control.h} |   19 +-
 74 files changed, 12145 insertions(+), 22709 deletions(-)
 delete mode 100644 drivers/scsi/isci/core/intel_ata.h
 delete mode 100644 drivers/scsi/isci/core/intel_sas.h
 delete mode 100644 drivers/scsi/isci/core/intel_sat.h
 delete mode 100644 drivers/scsi/isci/core/intel_sata.h
 delete mode 100644 drivers/scsi/isci/core/intel_scsi.h
 delete mode 100644 drivers/scsi/isci/core/sci_base_state.h
 delete mode 100644 drivers/scsi/isci/core/sci_controller.h
 delete mode 100644 drivers/scsi/isci/core/sci_controller_constants.h
 delete mode 100644 drivers/scsi/isci/core/sci_status.h
 delete mode 100644 drivers/scsi/isci/core/sci_util.c
 delete mode 100644 drivers/scsi/isci/core/sci_util.h
 delete mode 100644 drivers/scsi/isci/core/scic_config_parameters.h
 delete mode 100644 drivers/scsi/isci/core/scic_controller.h
 delete mode 100644 drivers/scsi/isci/core/scic_io_request.h
 delete mode 100644 drivers/scsi/isci/core/scic_phy.h
 delete mode 100644 drivers/scsi/isci/core/scic_port.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_controller.c
 delete mode 100644 drivers/scsi/isci/core/scic_sds_controller.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_phy.c
 delete mode 100644 drivers/scsi/isci/core/scic_sds_phy.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_port.c
 delete mode 100644 drivers/scsi/isci/core/scic_sds_port.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_port_configuration_agent.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_port_registers.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_request.c
 delete mode 100644 drivers/scsi/isci/core/scic_sds_request.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_smp_request.c
 delete mode 100644 drivers/scsi/isci/core/scic_sds_smp_request.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_ssp_request.c
 delete mode 100644 drivers/scsi/isci/core/scic_sds_stp_packet_request.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_stp_pio_request.h
 delete mode 100644 drivers/scsi/isci/core/scic_sds_stp_request.c
 delete mode 100644 drivers/scsi/isci/core/scic_sds_stp_request.h
 delete mode 100644 drivers/scsi/isci/core/scic_task_request.h
 delete mode 100644 drivers/scsi/isci/core/scu_constants.h
 delete mode 100644 drivers/scsi/isci/core/scu_viit_data.h
 rename drivers/scsi/isci/{core/sci_pool.h => pool.h} (100%)
 rename drivers/scsi/isci/{core/scic_sds_port_configuration_agent.c => port_config.c} (80%)
 rename drivers/scsi/isci/{core/scu_registers.h => registers.h} (95%)
 create mode 100644 drivers/scsi/isci/sas.h
 delete mode 100644 drivers/scsi/isci/sci_environment.h
 rename drivers/scsi/isci/{core => }/scu_completion_codes.h (100%)
 rename drivers/scsi/isci/{core => }/scu_event_codes.h (100%)
 rename drivers/scsi/isci/{core => }/scu_task_context.h (100%)
 rename drivers/scsi/isci/{core => }/scu_unsolicited_frame.h (100%)
 rename drivers/scsi/isci/{core/sci_base_state_machine.c => state_machine.c} (86%)
 rename drivers/scsi/isci/{core/sci_base_state_machine.h => state_machine.h} (71%)
 rename drivers/scsi/isci/{core/scic_sds_unsolicited_frame_control.c => unsolicited_frame_control.c} (96%)
 rename drivers/scsi/isci/{core/scic_sds_unsolicited_frame_control.h => unsolicited_frame_control.h} (93%)

commit de2ac6c33c407c8bf73549b95822ac310ffcae94
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Fri Apr 22 06:39:48 2011 +0000

    isci: Removing unused define SCIC_SDS_4_ENABLED
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f3bc679e4267bee67eaf677d360b9e102e9d7d68
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed May 4 13:49:32 2011 -0700

    isci: remove compile-time (Kconfig) silicon configuration
    
    Pre-production silicon support is deprecated, and will be removed
    completely in the future.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 2810ee48ca4bb953e4aba11c8d7e53bd3ea7c0d3
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 15:02:02 2011 -0700

    isci: Convert SATA fis data structures to Linux native
    
    Converting of sata_fis_reg_d2h to dev_to_host_fis
    Converting of sata_fis_reg_h2d to host_to_dev_fis
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b997bba32c8b5ad364a8f4e5d72fb0924751f7c9
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 15:02:03 2011 -0700

    isci: Convert ATA defines to Linux native defines
    
    * Removing all intel_sata and intel_ata defines
    * Removing the usage of SAT_PROTOCOL_*. We can get everything from sas_task
    * Moved SATA FIS types to local sas.h. These defines will have to go
      into include/scsi/sas.h eventually.
    * Added offsets for SATA FIS header in order to grab the values
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3d5a05d40473d3489ba3f3dc785d39174daf3b68
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 15:37:52 2011 -0700

    isci: Convert SAS identify address frame to Linux Native format
    
    Convert struct sci_sas_identify_address_frame to struct sas_identify_frame
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a438e964357df049235d93eee837f431e67adb04
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 16:13:17 2011 -0700

    isci: Collapsing of phy_type data structure
    
    Collapsing of struct scic_sds_phy phy_type data structure
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ab004c814754df4ab8534fdcf57a1e5f7ff1b162
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 16:16:44 2011 -0700

    isci: renaming sas_capabilities to scic_phy_cap
    
    This seems to be a data structure that represents the phy capabilities
    register from the hardware and has nothing to do with SAS data structs.
    Moving and fixup
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b3b4593bedf134f8edb3f212583c57dacb19f34d
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 17:44:54 2011 -0700

    isci: Fixup SSP command IU and task IU
    
    Fixup of SSP command IU and SSP task IU to something that looks like Linux
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit af4522b2b7cb3c9084ec48b2cf943e36a0c6e3aa
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 17:53:24 2011 -0700

    isci: Convert of sci_ssp_response_iu to ssp_response_iu
    
    Converting to Linux native format. However the isci driver does a lot of
    the calculation based on the max size of this data structure and the
    Linux data structure only has a pointer to the response data. Thus the
    sizeof(struct ssp_response_iu) will be incorrect and we need to define
    the max size.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 57719e478ca7f1cd31c408060aa57b3cffa99b4b
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 18:01:22 2011 -0700

    isci: Fixup of smp request
    
    The struct smp_request data structure has be fixed up for Linux consumption.
    This probably should go to scsi/sas.h eventually.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 114d9668d68a43d18376949dec917eee254d1e53
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 18:07:09 2011 -0700

    isci: Converting smp_response to Linux native smp_resp
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4ed8872de3b76708819eb510ef3982ce35ae627f
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 18:08:35 2011 -0700

    isci: remove redundant copies of IAF
    
    We need to remove the extra copies of identify address frame that's
    being kept around. We only need the one copy that libsas is using.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    [further cleanups]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e7e68e596c9bf0c3dc35b101f0d46b14b6905fcd
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 18:22:33 2011 -0700

    isci: fixup SAS iaf protocols data structure
    
    Moved the actual data structure that's read from the phy register to phy
    header.  Removed the parsing of identify address frame protocol bits as
    that seemed not necessary and we can use existing information.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 7eac8f6083bd6b31f99492cb720c2ddacbf4c3c1
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 18:28:32 2011 -0700

    isci: Remove SCIC_SWAP_DWORD()
    
    Use Linux native swab32() call instead of SCIC_SWAP_DWORD().
    
    We need to swab() because the hardware munges the data into a
    "big-endian dword" stream which is byte-swapped from the sas definition
    regardless of host endian.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 390b33cf7630ebe2aa18574da15db687f64c53de
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 18:45:05 2011 -0700

    isci: Using Linux SSP frame header
    
    Removing of struct sci_ssp_frame_header and migrate to struct ssp_frame_hdr.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 70e346fccd1745e5828c6ecaa11c23cf2c66a96b
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Wed May 4 19:01:01 2011 -0700

    isci: removing intel_*.h headers
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5109c4077e06d00fa50c30c231251dee2768a5a9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 5 17:47:44 2011 -0700

    isci: fix ata locking
    
    Upstream commit a29b5dad "libata: fix locking for sas paths" switched
    libsas ata locking to the ata_host lock.  We need to do the same when
    returning ata tasks from the execute path.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fd0ef2c28ff6e6040f31bc4c1206ef9e0fb677e1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon May 2 13:59:25 2011 -0700

    isci: implement I_T_nexus_reset
    
    This is a requirement for 2.6.39's new libata eh.
    
    Still some questions about lldd_dev_gone racing against dev->lldd_dev
    lookups, but we are at least no more broken than mvsas in this regard.
    
    We also short-circuit I_T_nexus_reset invocations from the device
    discovery path (IDEV_EH similar to MVS_DEV_EH) to filter out the
    resulting domain rediscoveries triggered by the reset.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bf128b79b7a6425891c5b11f2a24f10ee5d64ee0
Author: Artur Wojcik <artur.wojcik@intel.com>
Date:   Wed May 4 07:58:16 2011 +0000

    isci: unify isci_host data structures
    
    Make it explicit that isci_host and scic_sds_controller are one in the same
    object.
    
    Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
    [removed ->ihost back pointer]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8b5b701b86d89c70732b4359526e4f980c44f146
Author: Dave Jiang <dave.jiang@intel.com>
Date:   Fri May 6 02:17:37 2011 +0000

    isci: Removing unnecessary functions in request.c
    
    No need for wrappers, just access sas_task directly.
    
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c76dd82133f4e53a7aef0c3c746b86449e9ded1e
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu May 5 01:11:43 2011 +0000

    isci: kill scic_controller_get_port_handle function
    
    This function is just overkill and its usage is inconsistent. Replace
    with inlined code.
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 5f475beafa9c124844c54fb7380c655793e6d00f
Author: Edmund Nadolski <edmund.nadolski@intel.com>
Date:   Thu May 5 01:11:49 2011 +0000

    isci: remove scic_sds_port_increment_request_count
    
    Removes excessive encapsulation function.
    
    Signed-off-by: Edmund Nadolski <edmund.nadolski@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8498b81db8ab656b8675e04aedc903f518f096ec
Author: Jacek Danecki <Jacek.Danecki@intel.com>
Date:   Tue May 3 04:21:07 2011 +0000

    isci: rnc state machine table c99 conversion
    
    This makes the subsequent patches to delete rnc->state_handler more
    clear.
    
    Signed-off-by: Jacek Danecki <Jacek.Danecki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9161854f50bdc6f8f150e810f7b5c52806d604aa
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri May 6 17:36:38 2011 -0700

    isci: unify phy data structures
    
    Make scic_sds_phy a member of isci_phy and merge their lifetimes which
    means removing the phy table from scic_sds_controller in favor of the
    one at that isci_host level.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 29687c7bc306079af7e103ac6a9256c901c68fc9
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat May 7 10:11:43 2011 -0700

    isci: unify port data structures
    
    Make scic_sds_port a member of isci_port and merge their lifetimes which
    means removing the port table from scic_sds_controller in favor of the
    one at the isci_host level.  Merge ihost->sas_ports into ihost->ports.
    _
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 29ac6fee477cec1b83c5d27d4cffad272156bcbe
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat May 7 15:59:09 2011 -0700

    isci: move stp request info to scic_sds_request
    
    In preparation for unifying allocation of all request information make stp
    data available in all requests.  Incidentally collapse indentation.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 03e2d94c2e3dcdfb127d7e347b55021f917e2deb
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 8 01:56:57 2011 -0700

    isci: make sgl explicit/aligned request object member
    
    Towards unifying request objects we need all members to be defined in the
    object and not carved out of anonymous buffer space.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3a2629eab4c972daef0240ff6da602b3a3916590
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat May 7 19:07:14 2011 -0700

    isci: move task context alignment from run-time to compile time
    
    Remove usage of PTR_ALIGN by arranging for the task context to be aligned by
    the compiler.  Another step towards unifying isci_request and
    scic_sds_request.  Once this is complete the task context in the request can
    likely be removed in favor of building the task directly to tc memory (see:
    scic_sds_controller_copy_task_context).  It's not clear why this needs to be
    cacheline aligned if we just end up copying before submission...
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f3aa5407b946f61e9dd21786cb882a6421763fc1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 8 02:35:32 2011 -0700

    isci: make command/response iu explicit request object members
    
    Final elimination of the anonymous data at the end of the request
    structure.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 201ad9b45a5f0597c12c46cf44745c46d3bc7541
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 8 11:47:15 2011 -0700

    isci: unify request data structures
    
    Make scic_sds_request a proper member of isci_request.  Also let's us
    get rid of the dma pool object size tracking since we now know that all
    requests are sizeof(isci_request).  While cleaning up the construct
    routine incidentally replaced SCI_FIELD_OFFSET with offsetof.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f6edc9bb505c709561ad0b9b9caa2bc2461247b0
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 8 15:49:15 2011 -0700

    isci: unify constants
    
    cross driver constants are spread out over multiple header files, consolidate
    them into isci.h, and push some includes out to the source files that need
    them.
    
    TODO: remove SCI_MODE_SIZE infrastructure.
    TODO: task.h is full of inlines that are too large
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 933dd596a1e25eac842ec8c5c03ac53ae94b4825
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 8 17:34:44 2011 -0700

    isci: move core/controller to host
    
    Now that the data structures are unified unify the implementation in
    host.[ch] and cleanup namespace pollution.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fa7c74b1f7f251eb7634a79ac1277e24b6bd7204
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 8 21:36:46 2011 -0700

    isci: uplevel register hardware data structures and unsolicited frame handling
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b5be45e2f19bf02f4a86db0c2de897c3de0f7776
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sun May 8 22:15:10 2011 -0700

    isci: uplevel state machine
    
    unify core/sci_base_state.h and core/sci_base_state_machine.[ch] into
    state_machine.[ch]
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 234ef4864c222af1eb63ad4fa69ebcdf2f50fa19
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue May 10 02:28:45 2011 -0700

    isci: uplevel request infrastructure
    
    * Consolidate tiny header files
    * Move files out of core/ (drop core/scic_sds_ prefix)
    * Merge core/scic_sds_request.[ch] into request.[ch]
    * Cleanup request.c namespace (clean forward declarations and global
      namespace pollution)
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9adac25a927f4465b0e678178709b43d8adf3f41
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue May 10 02:28:45 2011 -0700

    isci: uplevel phy infrastructure
    
    Merge core/scic_sds_phy.[ch] into phy.[ch]
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d18e754f0733203e9ae7b3d7e4fe3c5419516da2
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue May 10 02:28:46 2011 -0700

    isci: uplevel port infrastructure
    
    * Move port configuration agent implementation
    * Merge core/scic_sds_port.[ch] into port.[ch]
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 7a2b2f700b9f6834759706b003894f06944e2383
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue May 10 02:28:47 2011 -0700

    isci: merge ssp task management substates into primary state machine
    
    Remove usage of the request substate machine for ssp task management
    requests identified by:
    	ireq->ttype == tmf_task && dev->dev_type == SAS_END_DEV;
    
    The only routine that checks the base 'started' state is
    scic_sds_io_request_tc_completion which calls the substate machine
    handler if we are not in the 'started' state or we are 'started' and no
    substate machine is defined.  This routine requires no conversion
    because we have transitioned out of 'started' and the substate routine
    will be called naturally as a result.
    
    There are also no side effects of this conversion on exiting the
    'started', state because it only stops the substate machine, which is no
    longer relevant for this transaction type.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 9172b21beaaf8160eae5d50143c932a16677929a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue May 10 02:28:48 2011 -0700

    isci: merge smp request substates into primary state machine
    
    Remove usage of the request substate machine for smp requests identified by:
    	task->task_proto == SAS_PROTOCOL_SMP
    
    While merging over the smp_request infrastructure noticed that all the
    assign buffer implementations are now equal, so moved it to
    scic_sds_general_request_construct.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 12ce26b30513806128ba311354acbedfadf48781
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue May 10 02:28:49 2011 -0700

    isci: merge stp request substates into primary state machine
    
    Remove usage of the request substate machine for stp requests, and kill
    the request substate infrastructure.
    
    Similar to the previous conversions this adds the substates to the
    primary state machine and arranges for the 'started' state to transition
    to the proper stp substate.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6234bd737b5d0a06d201ec7ce204cc85f9e1d371
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue May 10 02:39:11 2011 -0700

    isci: unify request abort handlers
    
    Unify the implementation in scic_sds_io_request_terminate and kill the state
    handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 1761433a3c3bcb602d09bfe0de1c2de0d343f09d
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Tue May 10 23:50:32 2011 +0000

    isci: unify request start handlers
    
    Unify the implementation in scic_sds_request_start and kill the state
    handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    [remove scic_sds_request_constructed_state_start_handler]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 32f7215e45b9ab5b3ffb6f83b2dae4ac9f12627b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed May 11 08:27:47 2011 -0700

    isci: unify request frame handlers
    
    Unify the implementation in scic_sds_io_request_frame_handler and kill
    the state handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit e0b70d098c39108bbae012446dab630cb434676a
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed May 11 08:27:47 2011 -0700

    isci: remove request task context completion state handler
    
    Unlike the other conversions this only updates
    scic_sds_io_request_tc_completion() to call the old state handlers directly
    (with less verbose names).  This was done for future patch readability, the
    implementations have only minor differences for different completion codes.
    Without a reference to the function name it would be difficult to dicern which
    state is being updated.  Considered changing the order to look up the
    completion code before the state but that was not a clean conversion either.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d25de0260c436a240116f54aa4a9a74a18a052ac
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Wed May 11 08:29:56 2011 -0700

    isci: remove the completion and event state handlers
    
    With these handlers gone the rest of the state handler infrastructure is
    removed.
    
    Added some WARN_ONCEs where previously we would cause NULL pointer
    dereferences or silently run handlers from a previous state.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit fee682b2523209be5c0f85a2b01e88b981da014e
Author: Adam Gruchala <adam.gruchala@intel.com>
Date:   Tue May 10 23:54:23 2011 +0000

    isci: merge phy substates
    
    Merged states and substates into one state machine, as we always
    unconditionally transitioned to the substate machine it was straightforward to
    enter that substate from the starting state.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Adam Gruchala <adam.gruchala@intel.com>
    [fixed construction, starting_state_enter, and starting check]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6f48c086d209242ba577d952cae54614364f9d4e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 03:44:24 2011 -0700

    isci: unify phy start handlers
    
    Implement all handlers in scic_sds_phy_start(), and kill the state handler
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8b420c28b084eae3c0e5fe61fe47f5e7f6459c7e
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 04:01:03 2011 -0700

    isci: unify phy stop handlers
    
    Merge all implementations in scic_sds_phy_stop(), and kill the state handler
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bccca56e9d4dae9714725ff643f8e3feffd828eb
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 04:02:07 2011 -0700

    isci: unify phy reset handlers
    
    Unify the implementations in scic_sds_phy_reset(), and kill the state handler
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c6791c98bf4a265696f88536f4ed14301d4ec019
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 04:10:41 2011 -0700

    isci: remove phy destruct handlers
    
    Unused infrastructure.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b661e4cbaa1b11cc3e08d593f0de6466bf9ce58c
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 04:17:51 2011 -0700

    isci: unify phy frame handlers
    
    Unify the implementations in scic_sds_phy_frame_handler(), and kill the state handler
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit c8a8f82cf6b4d87a54d1a64c2f3f81c631db26f1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 04:27:29 2011 -0700

    isci: unify phy event handlers
    
    Unify the implementations in scic_sds_phy_event_handler(), and kill the state handler
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f303b153b8d91272423a5719c3f1a47cc15085bf
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 04:51:41 2011 -0700

    isci: unify phy consume_power handlers
    
    Unify the implementations in scic_sds_phy_consume_power_handler(), and kill
    the state handler plus infrastructure.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit cc6df933c4ca68992b805873fd0a60f7aad27209
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 06:00:31 2011 -0700

    isci: clarify phy to port lookups
    
    While cleaning up the driver it is very tempting to convert scic_sds_get_*
    macros to their open coded equivalent.  They are all just pointer dereferences
    *except* scic_sds_phy_get_port() which returns NULL if the phy is assigned to
    the dummy port.  Clarify this by renaming it to phy_get_non_dummy_port().
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4dd184072b1bcdd0bc5f1b76c821a9a32679b66c
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Wed May 11 23:52:16 2011 +0000

    isci: c99 port state handlers
    
    Name the table fields for consistancy and clarity.
    
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 57754861a6f1a1f31eae0c48e1b4d0b4db2f93d4
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Wed May 11 23:52:21 2011 +0000

    isci: merge port ready substates into primary state machine
    
    This conversion was complicated by the fact that the ready state exit routine
    took unconditional action beyond just stopping the substate machine (like in
    previous conversions).  In order to ensure identical behaviour every state
    transition needs to be instrumented to catch ready-->!ready transitions and
    execute scic_sds_port_invalidate_dummy_remote_node()
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    [fix ready state exit handling]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 51fac19d6444e74916f4d6b0eb9f0383fed2ed59
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Wed May 11 23:52:26 2011 +0000

    isci: remove port start handler
    
    remove the handler from the port state handler table and implement the
    logic directly in scic_sds_port_start().
    
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    [remove a level of indirection]
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f839d90f59a2cba316665260639e09a27f68f044
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Wed May 11 23:52:31 2011 +0000

    isci: unify port stop handlers
    
    Implement the stop handlers directly in scic_sds_port_stop()
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 014de5fc8d4e3792d3ccee80bd66a8029a694edb
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Wed May 11 23:52:37 2011 +0000

    isci: remove port destruct handler
    
    The handler was never used.
    
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b62ddc1249ca1c356914dede54d890e5582d4e4a
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Thu May 12 19:10:03 2011 +0000

    isci: unify port reset, add_phy, and remove_phy handlers
    
    Unify the implementations and remove the state handlers.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 523fc82d825ba522dff4db6ceee3c5550f51f3ab
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Thu May 12 19:10:08 2011 +0000

    isci: remove port frame and event handlers
    
    Unused infrastructure.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit a04243ef266acff0cebc684b45da3bb73181fe43
Author: Piotr Sawicki <piotr.sawicki@intel.com>
Date:   Thu May 12 19:10:14 2011 +0000

    isci: unify port link_up and link_down handlers
    
    Unify the handlers and kill the state handler implementations.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Piotr Sawicki <piotr.sawicki@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 4c7a6cdae93385ad4025d2861cba0b411d3d68ff
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 07:16:06 2011 -0700

    isci: unify port start_io and complete_io handlers
    
    Unify the handlers and kill the state handler infrastructure.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit db4d55bf4774b589bb4ffcbef114635bbb542208
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 07:46:59 2011 -0700

    isci: unify rnc event handlers
    
    Unify rnc event handlers and delete the state handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d28f3adba2228d55a8f5479a3e3bb21327ab70d3
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 08:26:56 2011 -0700

    isci: unify rnc destruct handlers
    
    Unify rnc destruct handlers and delete the state handler.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit ae0b906dad84c094c588fc79dc798f01b537515b
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 08:50:23 2011 -0700

    isci: unify rnc suspend/resume handlers
    
    Unify rnc suspend/resume handlers and delete the state handlers.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 42944bd5c4ef835811019f3ee4f83d4d94716fbf
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 09:27:52 2011 -0700

    isci: unify rnc start{io|task} handlers
    
    Unify rnc start{io|task} handlers and delete the state handler
    infrastructure.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit b0733ad3d6efab9659bd77b405587b36d03fe276
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Thu May 12 07:42:17 2011 -0700

    isci: add some type safety to the state machine interface
    
    Now that any given object type only has one state_machine we can use
    container_of() to get back to the given state machine owner.
    
    Reported-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
