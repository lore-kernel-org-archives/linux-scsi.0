From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] first batch of SCSI udpates for the 2.6.30 merge window
Date: Fri, 12 Jun 2009 15:18:20 +0000
Message-ID: <1244819900.4184.22.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48515 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208AbZFLPSY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2009 11:18:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a large slew of driver updates and miscellaneous changes.  Most
notable are the addition of SLI4 to lpfc and the conversion of mvsas to
a new driver layout that supports updated cards.  With FCoE we're
spilling over into the net tree as well (all pieces acked by DaveM).

I've also had to merge up to fix the conflict with block API conversion
spotted by Stephen Rothwell in linux-next.

The update is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Aaro Koskinen (2):
      sym53c8xx_2: slave_alloc/destroy safety (2.6.27.5)
      sym53c8xx_2: lun to_clear flag not re-initialized (2.6.27.5)

Abhijeet Joglekar (1):
      libfc,fcoe,fnic: Separate rport and lport max retry counts

Alan Cox (1):
      gdth: fix overlapping snprintf users

Alan Stern (1):
      Increase default timeout for INQUIRY

Andrew Vasquez (25):
      qla2xxx: Update version number to 8.03.01-k3.
      qla2xxx: Synchronize MPI settings after a PE Reset.
      qla2xxx: Export additional firmware-states for application support.
      qla2xxx: Reduce lock-contention during do-work processing.
      qla2xxx: Avoid explicit LOGO during driver host tear-down.
      qla2xxx: Query supported RISC registers bits in determining a paused-state.
      qla2xxx: Avoid redundant RISC reset during (re)-initialization.
      qla2xxx: Fallback enode-mac should not be a multicast address.
      qla2xxx: Add notification message when an NPIV fails to acquire a port-id.
      qla2xxx: Add 10Gb iiDMA support.
      qla2xxx: Mark a port's state as needing-rediscovery during link disruptions.
      qla2xxx: Check status of qla2x00_get_fw_version() call.
      qla2xxx: Use 'proper' DID_* status code for dropped-frame scenarios.
      qla2xxx: Fallback to 'golden-firmware' operation on supported ISPs.
      qla2xxx: Correct logic-bug in set-model-info().
      qla2xxx: Export TLV data on supported ISPs.
      qla2xxx: Export XGMAC statistics on supported ISPs.
      qla2xxx: Export negotiated fabric-parameters for application support.
      qla2xxx: Update version number to 8.03.01-k2.
      qla2xxx: Add an override option to specify ISP firmware load semantics.
      qla2xxx: Don't try to 'stop' firmware if already in ROM code.
      qla2xxx: Restrict model-name/description device-table usage.
      qla2xxx: Correct typo in read_nvram() callback.
      qla2xxx: Correct compilation failures when DEBUG'n' options are enabled.
      qla2xxx: Export additional FCoE attributes for application support.

Andy Yan (7):
      mvsas: remove all the casts from void * or to void *
      mvsas: performance improvement using domain_device->lldd_dev
      mvsas: correct bit map usage
      mvsas: bug fix, null pointer may be used
      mvsas: bug fix of dead lock
      mvsas: bug fix with setting task management frame type
      mvsas: add support for 94xx; layout change; bug fixes

Anirban Chakraborty (6):
      qla2xxx: Correct NULL pointer bug in cpu affinity mode.
      qla2xxx: Correct queue-creation bug when driver loaded in QoS mode.
      qla2xxx: Use port number to compute nvram/vpd parameter offsets.
      qla2xxx: Remove reference to request queue from scsi request block.
      qla2xxx: Add CPU affinity support.
      qla2xxx: Add QoS support.

Bartlomiej Zolnierkiewicz (1):
      fix documentation for two functions

Boaz Harrosh (10):
      osd: Remove out-of-tree left overs
      libosd: Use REQ_QUIET requests.
      osduld: use filp_open() when looking up an osd-device
      libosd: Define an osd_dev wrapper to retrieve the request_queue
      libosd: osd_req_{read,write} takes a length parameter
      libosd: Let _osd_req_finalize_data_integrity receive number of out_bytes
      libosd: osd_req_{read,write}_kern new API
      libosd: Better printout of OSD target system information
      libosd: OSD2r05: Attribute definitions
      libosd: OSD2r05: Additional command enums

Brian King (13):
      ibmvscsi: Add support for capabilities MAD
      ibmvscsi: Send adapter info before login
      ibmvscsi: Add 16 byte CDB support
      ibmvfc: Driver version 1.0.6
      ibmvfc: Improve LOGO/PRLO ELS handling
      ibmvfc: Improve device rediscovery
      ibmvfc: Add flush on halt support
      ibmvfc: Add support for NPIV Logout
      ibmvfc: Fix deadlock in EH
      ibmvfc: Reduce error logging noise
      ibmvfc: Use DEVICE_ATTR macro
      ibmvfc: Fixup GFP flags for target allocations
      ibmvfc: Fix invalid error response handling

Chauhan, Vijay (1):
      scsi_dh_rdac: Retry for NOT_READY(02/04/01) in rdac device handler

Chris Leech (1):
      fcoe: use ETH_P_FIP for skb->protocol of FIP frames

Christof Schmitt (6):
      zfcp: Keep ccw device and model id in zfcp_ccw.c
      zfcp: Add comments to switch/case fallthroughs
      zfcp: Remove unnecessary default case and assignments
      zfcp: Make queue_depth adjustable
      zfcp: Update message and add description
      zfcp: Use correct req_id for traces

Eric Moore (5):
      mpt2sas: bump driver version to 01.100.03.00
      mpt2sas: using the same naming convention for all static function
      mpt2sas: add query task support for MPT2COMMAND ioctl
      mpt2sas: LUN Reset Support
      mpt2sas: T10 DIF Support

Eric Piel (1):
      Update wording of CONFIG_SCSI_MULTI_LUN help

FUJITA Tomonori (1):
      scsi_debug: fix virtual disk larger than 1TB

Harish Zunjarrao (1):
      qla2xxx: Correct hard-coded address of a second-port's NVRAM.

Herbert Xu (1):
      cxgb3i: Include net/dst.h for struct dst_cache

James Bottomley (3):
      mpt fusion: fix up doc book comments
      sd: fix bug in SCSI async probing
      fix up scsi_eh_lock_door()

James Smart (9):
      lpfc 8.3.2 : Update the lpfc driver version to 8.3.2
      lpfc 8.3.2 : Persistent Vport Support
      lpfc 8.3.2 : Miscellaneous Changes
      lpfc 8.3.2 : Update of copyrights
      lpfc 8.3.2 : Addition of SLI4 Interface - FCOE Discovery support
      lpfc 8.3.2 : Addition of SLI4 Interface - Mailbox handling
      lpfc 8.3.2 : Addition of SLI4 Interface - Queues
      lpfc 8.3.2 : Addition of SLI4 Interface - Base Support
      lpfc 8.3.2 : Reorganization for SLI4

Jeff Garzik (2):
      mvsas: split driver into multiple files
      mvsas: move into new directory drivers/scsi/mvsas/

Joe Carnuccio (1):
      qla2xxx: Perform an implicit login to the Management Server.

Joe Eykholt (2):
      net, libfcoe: Add the FCoE Initialization Protocol ethertype
      libfcoe: fip: fix non-FIP-mode FLOGI state after reset.

Kai Makisara (1):
      st: fix gcc 4.4 warning

Kashyap, Desai (16):
      mpt fusion: Added support for Broadcast primitives Event handling
      mpt fusion: Queue full event handling
      mpt fusion: RAID device handling and Dual port Raid support is added
      mpt fusion: Put IOC into ready state if it not already in ready state
      mpt fusion: Code Cleanup patch
      mpt fusion: Rescan SAS topology added
      mpt fusion: SAS topology scan changes, expander events
      mpt fusion: Firmware event implementation using seperate WorkQueue
      mpt fusion: rewrite of ioctl_cmds internal generated function
      mpt fusion: Adding DeviceResetCtx for internal Device reset frame
      mpt fusion: rewrite taskmgmt request and completion routines
      mpt fusion: rewrite of all internal generated functions
      mpt fusion: config path optimized, completion queue is used
      mpt fusion: Optimized SendEvent notification Using Doorbell instead FIFO
      mpt fusion: Added support for MPT discovery completion check
      mpt fusion: Fixing 1078 data corruption issue for 36GB memory region

Kleber S. Souza (2):
      ipr: fix PCI permanent error handler
      ipr: ipr_remove() marked __devexit

Martin Petermann (1):
      zfcp: Increase ref counter for port open requests

Michael Chan (4):
      bnx2i: Add bnx2i iSCSI driver.
      cnic: Add new Broadcom CNIC driver.
      bnx2: Add support for CNIC driver.
      iscsi class: Add new NETLINK_ISCSI messages for cnic/bnx2i driver.

Michael Reed (3):
      qla1280: error recovery rewrite
      qla1280: driver clean up
      qla2xxx: Conditionally disable automatic queue full tracking.

Mike Christie (14):
      libfc: use DID_ERROR when we have internall aborted command
      libiscsi: add debug printks for iscsi command completion path
      libiscsi: add task aborted state
      libiscsi: check if iscsi host has work queue before queueing work
      libiscsi: don't let io sit in queue when session has failed
      libiscsi: handle cleanup task races
      libiscsi: fix iscsi transport checks to account for slower links
      libiscsi_tcp: update recv tracking for each skb instead of iscsi pdu
      libiscsi: fix nop response/reply and session cleanup race
      libiscsi: have iscsi_data_in_rsp call iscsi_update_cmdsn
      libiscsi: export iscsi_itt_to_task for bnx2i
      libiscsi: handle param allocation failures
      libiscsi: check of LLD has a alloc pdu callout.
      iscsi: pass ep connect shost

Randy Dunlap (1):
      fcoe, libfc: fix function declarations to be ANSI-compliant

Robert Jennings (2):
      ibmvscsi: Enable fast fail feature
      ibmvscsi: Add specific timeouts for operations

Roel Kluin (1):
      ibmvscsi: Remove redundant test on unsigned.

Seokmann Ju (1):
      qla2xxx: Correct bus-reset behaviour with recent ISPs.

Steve Ma (1):
      libfc: Check if exchange is completed when receiving a sequence

Swen Schillig (1):
      zfcp: Changed D_ID left port disabled

Takahiro Yasui (1):
      limit state transitions in scsi_internal_device_unblock

Vasu Dev (3):
      fcoe: removes reserving memory for vlan_ethdr on tx path
      fcoe: removes fcoe_watchdog
      fcoe: reduces lock cost when adding a new skb to fcoe_pending_queue

Zhenwen Xu (1):
      NCR_D700: fix IRQ handler return type

And the diffstat:

 drivers/infiniband/ulp/iser/iscsi_iser.c   |   10 
 drivers/message/fusion/mptbase.c           | 1571 ++++--
 drivers/message/fusion/mptbase.h           |  180 
 drivers/message/fusion/mptctl.c            |  692 +--
 drivers/message/fusion/mptdebug.h          |    3 
 drivers/message/fusion/mptfc.c             |   15 
 drivers/message/fusion/mptsas.c            | 3114 ++++++++++---
 drivers/message/fusion/mptsas.h            |   41 
 drivers/message/fusion/mptscsih.c          | 1329 ++---
 drivers/message/fusion/mptscsih.h          |    7 
 drivers/message/fusion/mptspi.c            |   71 
 drivers/net/Kconfig                        |   11 
 drivers/net/Makefile                       |    1 
 drivers/net/bnx2.c                         |  193 
 drivers/net/bnx2.h                         |   18 
 drivers/net/cnic.c                         | 2711 +++++++++++
 drivers/net/cnic.h                         |  299 +
 drivers/net/cnic_defs.h                    |  580 ++
 drivers/net/cnic_if.h                      |  299 +
 drivers/s390/scsi/zfcp_ccw.c               |   30 
 drivers/s390/scsi/zfcp_dbf.c               |   10 
 drivers/s390/scsi/zfcp_def.h               |    7 
 drivers/s390/scsi/zfcp_erp.c               |    8 
 drivers/s390/scsi/zfcp_ext.h               |    1 
 drivers/s390/scsi/zfcp_fc.c                |    7 
 drivers/s390/scsi/zfcp_fsf.c               |   29 
 drivers/s390/scsi/zfcp_scsi.c              |   13 
 drivers/scsi/Kconfig                       |   31 
 drivers/scsi/Makefile                      |    3 
 drivers/scsi/NCR_D700.c                    |    2 
 drivers/scsi/bnx2i/57xx_iscsi_constants.h  |  155 
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h        | 1509 ++++++
 drivers/scsi/bnx2i/Kconfig                 |    7 
 drivers/scsi/bnx2i/Makefile                |    3 
 drivers/scsi/bnx2i/bnx2i.h                 |  771 +++
 drivers/scsi/bnx2i/bnx2i_hwi.c             | 2405 ++++++++++
 drivers/scsi/bnx2i/bnx2i_init.c            |  438 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c           | 2064 ++++++++
 drivers/scsi/bnx2i/bnx2i_sysfs.c           |  142 
 drivers/scsi/cxgb3i/cxgb3i.h               |    1 
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c         |   26 
 drivers/scsi/cxgb3i/cxgb3i_offload.c       |   23 
 drivers/scsi/cxgb3i/cxgb3i_offload.h       |    3 
 drivers/scsi/device_handler/scsi_dh_rdac.c |    6 
 drivers/scsi/fcoe/fcoe.c                   |   95 
 drivers/scsi/fcoe/fcoe.h                   |    1 
 drivers/scsi/fcoe/libfcoe.c                |   21 
 drivers/scsi/fnic/fnic_main.c              |    1 
 drivers/scsi/gdth_proc.c                   |    5 
 drivers/scsi/ibmvscsi/ibmvfc.c             |  434 +
 drivers/scsi/ibmvscsi/ibmvfc.h             |   40 
 drivers/scsi/ibmvscsi/ibmvscsi.c           |  463 +-
 drivers/scsi/ibmvscsi/ibmvscsi.h           |    4 
 drivers/scsi/ibmvscsi/viosrp.h             |   68 
 drivers/scsi/ipr.c                         |    5 
 drivers/scsi/libfc/fc_exch.c               |    4 
 drivers/scsi/libfc/fc_fcp.c                |    2 
 drivers/scsi/libfc/fc_rport.c              |    6 
 drivers/scsi/libiscsi.c                    |  468 +-
 drivers/scsi/libiscsi_tcp.c                |   18 
 drivers/scsi/lpfc/lpfc.h                   |  123 
 drivers/scsi/lpfc/lpfc_attr.c              |  250 -
 drivers/scsi/lpfc/lpfc_crtn.h              |   63 
 drivers/scsi/lpfc/lpfc_ct.c                |   15 
 drivers/scsi/lpfc/lpfc_debugfs.c           |   21 
 drivers/scsi/lpfc/lpfc_disc.h              |    1 
 drivers/scsi/lpfc/lpfc_els.c               |  275 -
 drivers/scsi/lpfc/lpfc_hbadisc.c           | 1365 +++++
 drivers/scsi/lpfc/lpfc_hw.h                |  142 
 drivers/scsi/lpfc/lpfc_hw4.h               | 2141 +++++++++
 drivers/scsi/lpfc/lpfc_init.c              | 5626 +++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_logmsg.h            |   54 
 drivers/scsi/lpfc/lpfc_mbox.c              |  674 ++
 drivers/scsi/lpfc/lpfc_mem.c               |  206 
 drivers/scsi/lpfc/lpfc_nportdisc.c         |   51 
 drivers/scsi/lpfc/lpfc_scsi.c              |  930 +++-
 drivers/scsi/lpfc/lpfc_scsi.h              |    2 
 drivers/scsi/lpfc/lpfc_sli.c               | 6683 +++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_sli.h               |   29 
 drivers/scsi/lpfc/lpfc_sli4.h              |  467 ++
 drivers/scsi/lpfc/lpfc_version.h           |    2 
 drivers/scsi/lpfc/lpfc_vport.c             |   62 
 drivers/scsi/mpt2sas/mpt2sas_base.h        |    5 
 drivers/scsi/mpt2sas/mpt2sas_ctl.c         |   32 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c       |  363 +
 drivers/scsi/mpt2sas/mpt2sas_transport.c   |   36 
 drivers/scsi/mvsas.c                       | 3222 -------------
 drivers/scsi/mvsas/Kconfig                 |   42 
 drivers/scsi/mvsas/Makefile                |   32 
 drivers/scsi/mvsas/mv_64xx.c               |  793 +++
 drivers/scsi/mvsas/mv_64xx.h               |  151 
 drivers/scsi/mvsas/mv_94xx.c               |  672 ++
 drivers/scsi/mvsas/mv_94xx.h               |  222 
 drivers/scsi/mvsas/mv_chips.h              |  280 +
 drivers/scsi/mvsas/mv_defs.h               |  502 ++
 drivers/scsi/mvsas/mv_init.c               |  703 +++
 drivers/scsi/mvsas/mv_sas.c                | 2154 +++++++++
 drivers/scsi/mvsas/mv_sas.h                |  406 +
 drivers/scsi/osd/Kbuild                    |   25 
 drivers/scsi/osd/Makefile                  |   37 
 drivers/scsi/osd/osd_initiator.c           |   83 
 drivers/scsi/osd/osd_uld.c                 |   66 
 drivers/scsi/qla1280.c                     |  387 -
 drivers/scsi/qla1280.h                     |    3 
 drivers/scsi/qla2xxx/qla_attr.c            |  227 
 drivers/scsi/qla2xxx/qla_dbg.c             |   13 
 drivers/scsi/qla2xxx/qla_def.h             |   45 
 drivers/scsi/qla2xxx/qla_fw.h              |    6 
 drivers/scsi/qla2xxx/qla_gbl.h             |   43 
 drivers/scsi/qla2xxx/qla_gs.c              |    5 
 drivers/scsi/qla2xxx/qla_init.c            |  206 
 drivers/scsi/qla2xxx/qla_iocb.c            |   55 
 drivers/scsi/qla2xxx/qla_isr.c             |  240 -
 drivers/scsi/qla2xxx/qla_mbx.c             |  244 -
 drivers/scsi/qla2xxx/qla_mid.c             |  118 
 drivers/scsi/qla2xxx/qla_os.c              |  294 -
 drivers/scsi/qla2xxx/qla_sup.c             |   47 
 drivers/scsi/qla2xxx/qla_version.h         |    2 
 drivers/scsi/scsi.c                        |    4 
 drivers/scsi/scsi_debug.c                  |    2 
 drivers/scsi/scsi_error.c                  |   21 
 drivers/scsi/scsi_lib.c                    |   14 
 drivers/scsi/scsi_scan.c                   |    4 
 drivers/scsi/scsi_transport_iscsi.c        |  173 
 drivers/scsi/sd.c                          |   45 
 drivers/scsi/st.c                          |    2 
 drivers/scsi/sym53c8xx_2/sym_glue.c        |   66 
 drivers/scsi/sym53c8xx_2/sym_hipd.c        |   49 
 drivers/scsi/sym53c8xx_2/sym_hipd.h        |    2 
 fs/exofs/common.h                          |    6 
 fs/exofs/inode.c                           |    8 
 fs/exofs/osd.c                             |   26 
 include/linux/if_ether.h                   |    1 
 include/scsi/fc/fc_fip.h                   |    7 
 include/scsi/iscsi_if.h                    |   49 
 include/scsi/libfc.h                       |    1 
 include/scsi/libiscsi.h                    |    8 
 include/scsi/osd_attributes.h              |   74 
 include/scsi/osd_initiator.h               |   14 
 include/scsi/osd_protocol.h                |    8 
 include/scsi/scsi_transport_iscsi.h        |    8 
 141 files changed, 42941 insertions(+), 9068 deletions(-)

James


