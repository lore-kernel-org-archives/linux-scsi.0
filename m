From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] Next round of SCSI updates for the 3.2+ merge window
Date: Wed, 18 Jan 2012 17:15:51 +0400
Message-ID: <1326892551.2898.41.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch contains the next set of SCSI updates including qla4xxx,
isci, bfa, megaraid_sas and fcoe.

I still have a set of libsas and pm8001 patches I'm trying to fit into
the merge window.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git scsi-misc

The short changelog is

Adam Radford (5):
      megaraid: fix sparse warnings
      megaraid_sas: Version and Changelog update
      megaraid_sas: remove poll_mode_io code
      megaraid_sas: mask off flags in ioctl path
      megaraid_sas: Fix reglockFlags for degraded raid5/6

Alok Kataria (1):
      MAINTAINERS: pvscsi maintainers update

Bart Van Assche (2):
      fcoe: Move fcoe_debug_logging from fcoe.h to fcoe.c
      libfc: Declare local functions static

Bartek Nowakowski (1):
      isci: enable wide port targets

Ben Hutchings (1):
      isci, firmware: Remove isci fallback parameter blob and generator

Dan Williams (2):
      isci: update version to 1.1
      isci: cleanup oem parameter and recipe handling

Dave Jiang (1):
      isci: oem parameter format v1.1 (ssc select)

Giridhar Malavali (1):
      qla4xxx: Disable generating pause frames in case of FW hung

James Smart (1):
      scsi_transport_fc: Clear Devloss Callback Done flag in fc_remote_port_rolechg

Jeff Skirvin (3):
      isci: link speeds default to gen 2
      isci: oem parameter format v1.3 (cable select)
      isci: update afe (analog-front-end) recipe for C1

Karen Higgins (1):
      qla4xxx: Cleanup modinfo display

Krishna Gudipati (3):
      bfa: Implement LUN Masking feature using the SCSI Slave Callouts.
      bfa: Revert back the current LUN Masking Implementation.
      bfa: Fix possible NULL pointer dereference in lunmask add/delete.

Lalit Chandivade (1):
      qla4xxx: cleanup, make qla4xxx_build_ddb_list short

Maciej Trela (1):
      isci: remove unused 'isci_tmf->device' field

Manish Rangankar (1):
      qla4xxx: Fixed BFS with sendtargets as boot index.

Marcin Tomczak (6):
      isci: fix, prevent port from getting stuck in the 'configuring' state
      isci: fix start OOB
      isci: fix io failures while wide port links are coming up
      isci: allow more time for wide port targets
      isci: Fix IO fails when pull cable from phy in x4 wideport in MPC mode.
      isci: performance-fix, shorten default "no outbound task" timeout

Mike Hernandez (1):
      qla4xxx: Temperature monitoring for ISP82XX core.

Moger, Babu (1):
      scsi_dh_alua: Retry the check-condition in case Mode Parameters Changed

Nilesh Javali (3):
      qla4xxx: Added error logging for firmware abort
      qla4xxx: Break the loop if the sendtargets list was empty
      qla4xxx: Limit the ACB Default Timeout value to 12s

Richard Weinberger (1):
      scsi_dh_rdac: Fix error path

Robert Love (1):
      fcoe: remove double check if skb is nonlinear

Sarang Radke (1):
      qla4xxx: Clear the RISC interrupt bit during FW init

Shaohua Li (1):
      don't change sdev starvation list order without request dispatched

Stephen Boyd (1):
      sg: convert to kstrtoul_from_user()

Stephen M. Cameron (1):
      hpsa: do not sleep in atomic context in rmmod path.

Stratos Psomadakis (1):
      sym53c8xx: Fix NULL pointer dereference in slave_destroy

Thadeu Lima de Souza Cascardo (1):
      libcxgbi: do not print a message when memory allocation fails

Vikas Chaudhary (3):
      qla4xxx: Update driver version to 5.02.00-k12
      qla4xxx: Update license
      qla4xxx: Update driver version to 5.02.00-k11

Yi Zou (2):
      libfc: remove redundant timer init for fcp
      fcoe: fix regression on offload em matching function for initiator/target

and the diffstat is

 Documentation/scsi/ChangeLog.megaraid_sas  |   10 +
 Documentation/scsi/LICENSE.qla4xxx         |   23 +--
 MAINTAINERS                                |    2 +-
 drivers/scsi/Kconfig                       |    5 -
 drivers/scsi/bfa/bfa_defs_svc.h            |    7 +-
 drivers/scsi/bfa/bfa_fc.h                  |  155 ---------
 drivers/scsi/bfa/bfa_fcpim.c               |  416 +----------------------
 drivers/scsi/bfa/bfa_fcpim.h               |    7 -
 drivers/scsi/bfa/bfa_svc.h                 |    5 -
 drivers/scsi/bfa/bfad.c                    |    2 +
 drivers/scsi/bfa/bfad_attr.c               |    2 +-
 drivers/scsi/bfa/bfad_bsg.c                |   27 ++-
 drivers/scsi/bfa/bfad_drv.h                |    2 +
 drivers/scsi/bfa/bfad_im.c                 |   56 +++
 drivers/scsi/bfa/bfad_im.h                 |   27 ++
 drivers/scsi/cxgbi/libcxgbi.c              |    5 +-
 drivers/scsi/device_handler/scsi_dh_alua.c |    5 +
 drivers/scsi/device_handler/scsi_dh_rdac.c |    2 +
 drivers/scsi/fcoe/fcoe.c                   |   46 ++--
 drivers/scsi/fcoe/fcoe.h                   |    4 +-
 drivers/scsi/hpsa.c                        |    2 +
 drivers/scsi/isci/firmware/Makefile        |   19 -
 drivers/scsi/isci/firmware/README          |   36 --
 drivers/scsi/isci/firmware/create_fw.c     |   99 ------
 drivers/scsi/isci/firmware/create_fw.h     |   77 -----
 drivers/scsi/isci/host.c                   |  340 ++++++++++++++-----
 drivers/scsi/isci/host.h                   |   27 ++-
 drivers/scsi/isci/init.c                   |   25 ++-
 drivers/scsi/isci/isci.h                   |    1 +
 drivers/scsi/isci/phy.c                    |  172 ++++++----
 drivers/scsi/isci/port.c                   |  104 ++++---
 drivers/scsi/isci/port.h                   |   10 +
 drivers/scsi/isci/port_config.c            |   35 ++-
 drivers/scsi/isci/probe_roms.c             |    2 +-
 drivers/scsi/isci/probe_roms.h             |   89 +++++-
 drivers/scsi/isci/remote_device.c          |   10 +-
 drivers/scsi/isci/task.c                   |    2 +-
 drivers/scsi/isci/task.h                   |    7 +-
 drivers/scsi/libfc/fc_disc.c               |    6 +-
 drivers/scsi/libfc/fc_elsct.c              |    1 +
 drivers/scsi/libfc/fc_exch.c               |    2 +-
 drivers/scsi/libfc/fc_fcp.c                |    4 +-
 drivers/scsi/libfc/fc_lport.c              |    5 +-
 drivers/scsi/libfc/fc_rport.c              |   10 +-
 drivers/scsi/megaraid.c                    |   13 +-
 drivers/scsi/megaraid/megaraid_sas.h       |    8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c  |  145 +--------
 drivers/scsi/megaraid/megaraid_sas_fp.c    |    4 +-
 drivers/scsi/qla4xxx/ql4_def.h             |    3 +
 drivers/scsi/qla4xxx/ql4_init.c            |    3 +
 drivers/scsi/qla4xxx/ql4_mbx.c             |    7 +
 drivers/scsi/qla4xxx/ql4_nx.c              |    5 +
 drivers/scsi/qla4xxx/ql4_nx.h              |   22 +-
 drivers/scsi/qla4xxx/ql4_os.c              |  511 ++++++++++++++++++----------
 drivers/scsi/qla4xxx/ql4_version.h         |    2 +-
 drivers/scsi/scsi_lib.c                    |    7 +-
 drivers/scsi/scsi_transport_fc.c           |    3 +-
 drivers/scsi/sg.c                          |   25 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c        |    4 +
 firmware/Makefile                          |    1 -
 firmware/isci/isci_firmware.bin.ihex       |   16 -
 include/scsi/libfc.h                       |    2 +-
 62 files changed, 1192 insertions(+), 1482 deletions(-)
 delete mode 100644 drivers/scsi/isci/firmware/Makefile
 delete mode 100644 drivers/scsi/isci/firmware/README
 delete mode 100644 drivers/scsi/isci/firmware/create_fw.c
 delete mode 100644 drivers/scsi/isci/firmware/create_fw.h
 delete mode 100644 firmware/isci/isci_firmware.bin.ihex

James
