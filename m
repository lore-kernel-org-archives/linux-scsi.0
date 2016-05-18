From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 4.6+ merge window
Date: Wed, 18 May 2016 07:19:06 -0400
Message-ID: <1463570346.27423.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58142 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750795AbcERLTL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2016 07:19:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This patch includes the usual quota of driver updates (bnx2fc, mp3sas,
hpsa, ncr5380, lpfc, hisi_sas, snic, aacraid, megaraid_sas) there's
also a multiqueue update for scsi_debug, assorted bug fixes and a few
other minor updates (refactor of scsi_sg_pools into generic code, alua
and VPD updates, and struct timeval conversions).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

lexey Khoroshilov (1):
      mptsas: fix checks for dma mapping errors

Andy Lutomirski (1):
      megaraid_sas: Downgrade two success messages to info

Bart Van Assche (8):
      scsi_dh_alua: Declare local functions static
      scsi_transport_iscsi: Declare local symbols static
      scsi_transport_iscsi: Unexport iscsi_is_flashnode_conn_dev()
      scsi_transport_iscsi: Remove set-but-not-used variables
      libiscsi: Remove set-but-not-used variables
      libiscsi: Unexport iscsi_eh_target_reset()
      qla2xxx: Indicate out-of-memory with -ENOMEM
      scsi_transport_fc: Unexport scsi_is_fc_vport()

Chad Dupuis (4):
      bnx2fc: Update version number to 2.10.3.
      bnx2fc: Check sc_cmd device and host pointer before returning the command to the mid-layer.
      bnx2fc: Print netdev device name when FCoE is successfully initialized.
      bnx2fc: Print when we send a fip keep alive.

Chaitra P B (6):
      mpt3sas: Used "synchronize_irq()"API to synchronize timed-out IO & TMs
      mpt3sas: Set maximum transfer length per IO to 4MB for VDs
      mpt3sas: Updating mpt3sas driver version to 13.100.00.00
      mpt3sas: Fix initial Reference tag field for 4K PI drives.
      mpt3sas: Handle active cable exception event
      mpt3sas: Update MPI header to 2.00.42

Dan Carpenter (4):
      eata_pio: missing break statement
      bfa: fix bfa_fcb_itnim_alloc() error handling
      bnx2i: silence uninitialized variable warnings
      hpsa: set the enclosure identifier to zero

David Daney (1):
      pm80xx: Remove bogus address masking in pm8001_ioremap()

Don Brace (6):
      hpsa: update driver version
      hpsa: correct handling of HBA device removal
      hpsa: correct ioaccel2 error procecssing.
      hpsa: correct ioaccel state change operation
      hpsa: add timeouts for driver initiated commands
      hpsa: correct initialization order issue

Douglas Gilbert (13):
      scsi_debug: use locally assigned naa
      scsi_debug: uuid for lu name
      scsi_debug: vpd and mode page work
      scsi_debug: add multiple queue support
      scsi_debug: rework resp_report_luns
      scsi_debug: use pdt constants
      scsi_debug: use likely hints on fast path
      scsi_debug: re-order file scope declarations
      scsi_debug: replace tasklet with work queue
      scsi_debug: make jiffy delay name clearer
      scsi_debug: replace jiffy timers with hr timers
      scsi_debug: ignore host lock option
      scsi_debug: cleanup naming and bit crunching

Finn Thain (24):
      MAINTAINERS: Update the file list for the NCR 5380 entry
      ncr5380: Call complete_cmd() for disconnected commands on bus reset
      mac_scsi: Fix pseudo DMA implementation
      atari_scsi: Allow can_queue to be increased for Falcon
      atari_scsi: Set a reasonable default for cmd_per_lun
      ncr5380: Update usage documentation
      ncr5380: Remove DONT_USE_INTR and AUTOPROBE_IRQ macros
      ncr5380: Remove remaining register storage qualifiers
      ncr5380: Fix register decoding for debugging
      dmx3191d: Drop max_sectors limit
      ncr5380: Reduce max_lun limit
      ncr5380: Remove disused atari_NCR5380.c core driver
      sun3_scsi: Adopt NCR5380.c core driver
      atari_scsi: Adopt NCR5380.c core driver
      ncr5380: Merge DMA implementation from atari_NCR5380 core driver
      ncr5380: Adopt uniform DMA setup convention
      ncr5380: Use DMA hooks for PDMA
      ncr5380: Remove BOARD_REQUIRES_NO_DELAY macro
      ncr5380: Remove PSEUDO_DMA macro
      ncr5380: Disable the DMA errata workaround flag by default
      atari_NCR5380: Remove DMA_MIN_SIZE macro
      ncr5380: Remove REAL_DMA and REAL_DMA_POLL macros
      ncr5380: Remove FLAG_NO_PSEUDO_DMA where possible
      g_ncr5380: Remove CONFIG_SCSI_GENERIC_NCR53C400

Hannes Reinecke (8):
      scsi_lib: Decode T10 vendor IDs
      scsi_dh_alua: do not fail for unknown VPD identification
      zfcp: Revert to original scanning behaviour
      scsi: vpd pages are mandatory for SPC-2
      scsi-trace: define ZBC_IN and ZBC_OUT
      scsi-trace: Decode MAINTENANCE_IN and MAINTENANCE_OUT commands
      scsi-trace: remove service action definitions
      scsi: disable automatic target scan

James Smart (9):
      lpfc: Update driver version to 11.1.0.0
      lpfc: Update modified file copyrights
      lpfc: Fix interaction between fdmi_on and enable_SmartSAN
      lpfc: Add support for SmartSAN 2.0
      lpfc: Fix Device discovery failures during switch reboot test.
      lpfc: Utilize embedded CDB logic to minimize IO latency
      lpfc: Fix crash when unregistering default rpi.
      lpfc: Fix DMA faults observed upon plugging loopback connector
      lpfc: Correct LOGO handling during login

Joe Carnuccio (1):
      bnx2fc: Add driver tunables.

Joe Lawrence (1):
      mpt3sas - remove unused fw_event_work elements

Johannes Thumshirn (2):
      Revert "scsi: fix soft lockup in scsi_remove_target() on module removal"
      scsi: Add intermediate STARGET_REMOVE state to scsi_target_state

John Garry (8):
      hisi_sas: add alloc_dev_quirk_v2_hw()
      hisi_sas: add slot_index_alloc_quirk_v2_hw()
      hisi_sas: add device and slot alloc hw methods
      hisi_sas: update driver version to 1.4
      hisi_sas: for v2 hw only set ITCT qw2 for SAS device
      hisi_sas: add v2 hw support for >4 SATA phys
      hisi_sas: fix v2 hw multiple SATA disk issue
      hisi_sas: use device linkrate in MCR for v2 hw

Joseph T Handzik (1):
      hpsa: add sas_address to sysfs device attibute

Kai Makisara (1):
      st: clear ILI if Medium Error

Leonid Moiseichuk (1):
      mvsas: Generalize Marvell 9485 in pci_device_id

Manoj N. Kumar (1):
      cxlflash: Fix to resolve dead-lock during EEH recovery

Martin K. Petersen (1):
      Revert "lpfc: Delete unnecessary checks before the function call mempool_destroy"

Ming Lin (5):
      lib: scatterlist: move SG pool code from SCSI driver to lib/sg_pool.c
      scsi: rename SCSI_MAX_{SG, SG_CHAIN}_SEGMENTS
      scsi: rename SG related struct and functions
      scsi: replace "mq" with "first_chunk" in SG functions
      scsi: replace "scsi_data_buffer" with "sg_table" in SG functions

Narsimhulu Musini (7):
      snic: add scsi host after determining max IOs.
      snic: Fixing race in the hba reset and IO/TM completion
      snic: Fix for missing interrupts
      snic: target cleanup in driver unload path
      snic: Handling control path queue issues
      snic: LUN goes offline due to scsi cmd timeouts
      snic: Added additional stats

Petros Koutoupis (1):
      hpsa: Fix type ZBC conditional checks

Raghava Aditya Renukunta (10):
      aacraid: Update driver version
      aacraid: Fix for KDUMP driver hang
      aacraid: Remove code to needlessly complete fib
      aacraid: Log firmware AIF messages
      aacraid: Fix for aac_command_thread hang
      aacraid: Disable MSI mode for series 6, 7, 8 cards
      aacraid: Relinquish CPU during timeout wait
      aacraid: Start adapter after updating number of MSIX vectors
      aacraid: Fix incorrectly named MACRO
      aacraid: Removed unnecessary checks for NULL

Rasmus Villemoes (3):
      scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
      scsi: move Additional Sense Codes to separate file
      scsi: make some Additional Sense strings more grep'able

Satish Kharat (3):
      fnic: Using rport->dd_data to check rport online instead of rport_lookup.
      fnic: Cleanup the I/O pending with fw and has timed out and is used to issue LUN reset
      fnic: Fix to cleanup aborted IO to avoid device being offlined by mid-layer

Sebastian Herbszt (1):
      lpfc: remove incorrect lockdep assertion

Sumit Saxena (4):
      megaraid_sas: driver version upgrade
      megaraid_sas: task management code optimizations
      megaraid_sas: call ISR function to clean up pending replies in OCR path
      megaraid_sas: reduce memory footprints in kdump mode

Tina Ruchandani (2):
      mpt3sas: Remove usage of 'struct timeval'
      qla2xxx: Remove use of 'struct timeval'

And the diffstat:

 Documentation/scsi/g_NCR5380.txt            |   17 +-
 Documentation/scsi/scsi-parameters.txt      |   11 +-
 MAINTAINERS                                 |    2 +-
 drivers/ata/pata_icside.c                   |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c         |    6 +-
 drivers/message/fusion/mptsas.c             |    4 +-
 drivers/message/fusion/mptspi.c             |    2 +-
 drivers/s390/scsi/zfcp_unit.c               |    3 +-
 drivers/scsi/Kconfig                        |   16 +-
 drivers/scsi/NCR5380.c                      |  657 ++++---
 drivers/scsi/NCR5380.h                      |  143 +-
 drivers/scsi/aacraid/aachba.c               |   22 -
 drivers/scsi/aacraid/aacraid.h              |    9 +-
 drivers/scsi/aacraid/comminit.c             |   43 +-
 drivers/scsi/aacraid/commsup.c              |   39 +-
 drivers/scsi/aacraid/dpcsup.c               |    7 +-
 drivers/scsi/aacraid/linit.c                |    4 +-
 drivers/scsi/aacraid/src.c                  |    3 +-
 drivers/scsi/arm/cumana_1.c                 |   25 +-
 drivers/scsi/arm/cumana_2.c                 |    2 +-
 drivers/scsi/arm/eesox.c                    |    2 +-
 drivers/scsi/arm/oak.c                      |   22 +-
 drivers/scsi/arm/powertec.c                 |    2 +-
 drivers/scsi/atari_NCR5380.c                | 2676 -------------------------
 drivers/scsi/atari_scsi.c                   |  144 +-
 drivers/scsi/bfa/bfa_fcs.h                  |    4 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c            |    5 +-
 drivers/scsi/bfa/bfad_im.c                  |    5 +-
 drivers/scsi/bnx2fc/bnx2fc.h                |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |  100 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c             |   14 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |    4 +-
 drivers/scsi/constants.c                    |  859 +-------
 drivers/scsi/cxlflash/superpipe.c           |   15 +
 drivers/scsi/device_handler/scsi_dh_alua.c  |   33 +-
 drivers/scsi/dmx3191d.c                     |   10 +-
 drivers/scsi/dtc.c                          |   27 +-
 drivers/scsi/dtc.h                          |    7 +-
 drivers/scsi/eata_pio.c                     |    1 +
 drivers/scsi/esas2r/esas2r_main.c           |    4 +-
 drivers/scsi/fnic/fnic.h                    |    2 +-
 drivers/scsi/fnic/fnic_scsi.c               |   91 +-
 drivers/scsi/g_NCR5380.c                    |  141 +-
 drivers/scsi/g_NCR5380.h                    |   26 +-
 drivers/scsi/hisi_sas/hisi_sas.h            |    7 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c       |   11 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |   90 +-
 drivers/scsi/hpsa.c                         |  187 +-
 drivers/scsi/hpsa.h                         |    1 +
 drivers/scsi/libiscsi.c                     |    9 +-
 drivers/scsi/lpfc/lpfc.h                    |    4 +-
 drivers/scsi/lpfc/lpfc_attr.c               |   26 +-
 drivers/scsi/lpfc/lpfc_ct.c                 |    6 +-
 drivers/scsi/lpfc/lpfc_els.c                |  176 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |    5 +-
 drivers/scsi/lpfc/lpfc_hw.h                 |   75 +-
 drivers/scsi/lpfc/lpfc_hw4.h                |   29 +-
 drivers/scsi/lpfc/lpfc_init.c               |   27 +-
 drivers/scsi/lpfc/lpfc_mbox.c               |   12 +-
 drivers/scsi/lpfc/lpfc_mem.c                |    6 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c          |    4 +-
 drivers/scsi/lpfc/lpfc_sli.c                |  140 +-
 drivers/scsi/lpfc/lpfc_version.h            |    6 +-
 drivers/scsi/lpfc/lpfc_vport.c              |    5 +-
 drivers/scsi/mac_scsi.c                     |  241 +--
 drivers/scsi/megaraid/megaraid_sas.h        |    6 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  117 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    7 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h             |    7 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h        |   18 +-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h        |   15 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |   40 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |   32 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h         |   11 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |   37 +-
 drivers/scsi/mvsas/mv_init.c                |   19 +-
 drivers/scsi/pas16.c                        |   27 +-
 drivers/scsi/pas16.h                        |    5 +-
 drivers/scsi/pm8001/pm8001_init.c           |    2 -
 drivers/scsi/qla2xxx/qla_mr.c               |    5 +-
 drivers/scsi/qla2xxx/qla_nx.c               |    2 +-
 drivers/scsi/scsi_debug.c                   | 2801 ++++++++++++++-------------
 drivers/scsi/scsi_lib.c                     |  188 +-
 drivers/scsi/scsi_priv.h                    |    2 +-
 drivers/scsi/scsi_proc.c                    |    3 +-
 drivers/scsi/scsi_scan.c                    |   45 +-
 drivers/scsi/scsi_sysfs.c                   |    9 +-
 drivers/scsi/scsi_trace.c                   |  161 ++
 drivers/scsi/scsi_transport_fc.c            |    9 +-
 drivers/scsi/scsi_transport_iscsi.c         |   19 +-
 drivers/scsi/scsi_transport_sas.c           |    7 +-
 drivers/scsi/sense_codes.h                  |  826 ++++++++
 drivers/scsi/snic/snic.h                    |    5 +-
 drivers/scsi/snic/snic_ctl.c                |    8 +-
 drivers/scsi/snic/snic_debugfs.c            |   20 +-
 drivers/scsi/snic/snic_disc.c               |   19 +-
 drivers/scsi/snic/snic_fwint.h              |    4 +-
 drivers/scsi/snic/snic_io.c                 |   62 +-
 drivers/scsi/snic/snic_isr.c                |    6 +-
 drivers/scsi/snic/snic_main.c               |   44 +-
 drivers/scsi/snic/snic_scsi.c               |   56 +-
 drivers/scsi/snic/snic_stats.h              |   12 +-
 drivers/scsi/snic/vnic_dev.c                |   44 +-
 drivers/scsi/st.c                           |    9 +-
 drivers/scsi/sun3_scsi.c                    |   47 +-
 drivers/scsi/t128.c                         |   19 +-
 drivers/scsi/t128.h                         |    7 +-
 drivers/usb/storage/scsiglue.c              |    2 +-
 include/linux/scatterlist.h                 |   25 +
 include/scsi/scsi.h                         |   19 -
 include/scsi/scsi_device.h                  |   14 +-
 include/scsi/scsi_host.h                    |    2 +-
 include/scsi/scsi_proto.h                   |    9 +
 include/trace/events/scsi.h                 |    6 +-
 lib/Kconfig                                 |    7 +
 lib/Makefile                                |    1 +
 lib/sg_pool.c                               |  172 ++
 117 files changed, 4839 insertions(+), 6481 deletions(-)
 delete mode 100644 drivers/scsi/atari_NCR5380.c
 create mode 100644 drivers/scsi/sense_codes.h
 create mode 100644 lib/sg_pool.c

James


