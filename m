From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] First round of SCSI updates for the 3.4+ merge window
Date: Mon, 21 May 2012 12:30:19 +0100
Message-ID: <1337599819.3042.7.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The patch contains the usual assortment of driver updates (be2iscsi,
bfa, bnx2i, fcoe, hpsa, isci, lpfc, megaraid, mpt2sas, pm8001, sg) plus
an assortment of other changes and fixes.  Also new is the fact that th=
e
isci update is delivered as a git merge (with signed tag).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is

Adam Radford (3):
      megaraid_sas: Version and Changelog update
      megaraid_sas: Add fpRead/WriteCapable, fpRead/WriteAcrossStripe c=
hecks
      megaraid_sas: Optimize HostMSIxVectors setting

Akinobu Mita (1):
      hpsa: use check_signature

Andrzej Jakowski (1):
      isci: Changes in COMSAS timings enabling ISCI to detect buggy dis=
c drives.

Dan Carpenter (1):
      fcoe: remove a stray unlock

Dan Williams (12):
      isci: fix oem parameter validation on single controller skus
      isci: kill isci_host.shost
      isci: fix interrupt disable
      isci: fix 'link-up' events occur after 'start-complete'
      isci: fix controller stop
      isci: refactor initialization for S3/S4
      isci: kill isci_port.domain_dev_list
      isci: kill ->status, and ->state_lock in isci_host
      isci: kill sci_phy_protocol and sci_request_protocol
      isci: kill ->is_direct_attached
      isci: improve 'invalid state' warnings
      sd: limit the scope of the async probe domain

David Jeffery (1):
      st: fix memory leak with >1MB tape I/O

Eddie Wai (2):
      bnx2i: Updated version and copyright year
      bnx2i: Added the setting of target can_queue via target_alloc

James Smart (20):
      lpfc 8.3.31: Update lpfc to version 8.3.31
      lpfc 8.3.31: Fixed system crash due to not providing SCSI error-h=
andling host reset handler
      lpfc 8.3.31: Fix bug with driver using the wrong xritag when send=
ing an els echo
      lpfc 8.3.31: Debug helper utility routines for dumping various SL=
I4 queues
      lpfc 8.3.31: Fix unsol abts xri lookup
      lpfc 8.3.31: Correct point-to-point mode discovery errors on LPe1=
6xxx
      lpfc 8.3.31: Reregister VPI for SLI3 after cable moved to new Sat=
urn port
      lpfc 8.3.31: Fix driver crash during back-to-back ramp events
      lpfc 8.3.31: Fix log message for Mailbox command when no error is=
 detected
      lpfc 8.3.31: Revise FCP LOG for easier Finisar trace correlation
      lpfc 8.3.31: Fix build warnings when debugfs is not defined
      lpfc 8.3.31: Fix kernel panic when going into to sleep state
      lpfc 8.3.31: Fix error message displayed even when not an error
      lpfc 8.3.31: Fix Read Link status data
      lpfc 8.3.31: Fixed system panic due to midlayer abort and driver =
complete race on SCSI cmd
      lpfc 8.3.31: Fix unable to create vports on FCoE SLI4 adapter
      lpfc 8.3.31: Fix initiator sending flogi after acking flogi from =
target
      lpfc 8.3.31: Fix bug with driver not supporting the get controlle=
r attributes command
      lpfc 8.3.31: Correct handling of SLI4-port XRI resource-provision=
ing profile change
      lpfc 8.3.31: Fix bug with driver unload leaving a scsi host for a=
 vport around

Jayamohan Kallickal (13):
      be2iscsi: Adding bsg interface for be2iscsi
      be2iscsi: Return async handle of unknown opcode to free list.
      be2iscsi: Check ASYNC PDU Handle corresponds to HDR/DATA Handle
      be2iscsi: Bump the driver Version
      be2iscsi: Update external Branding to Emulex
      be2iscsi: Fix the function return values.
      be2iscsi: Code cleanup, removing the goto statement
      be2iscsi: Fix double free of MCCQ info memory.
      be2iscsi: Set num_cpu =3D 1 if pci_enable_msix fails
      be2iscsi: Fix typo function name mismatch
      be2iscsi: WRB Initialization and Failure code path change
      be2iscsi: Fix in ASYNC PDU stitching logic.
      be2iscsi: Fix in the Asynchronous Code Path

Jeff Skirvin (37):
      isci: End the RNC resumption wait when the RNC is destroyed.
      isci: Fixed RNC bug that lost the suspension or resumption during=
 destroy
      isci: Fix RNC AWAIT_SUSPENSION->INVALIDATING transition.
      isci: Manage the IREQ_NO_AUTO_FREE_TAG under scic_lock.
      isci: Remove obviated host callback list.
      isci: Check IDEV_GONE before performing abort path operations.
      isci: Restore the ATAPI device RNC management code.
      isci: Don't wait for an RNC suspend if it's being destroyed.
      isci: Change the phy control and link reset interface for HW reas=
ons.
      isci: Added timeouts to RNC suspensions in the abort path.
      isci: Add protocol indicator for TMF requests.
      isci: Directly control IREQ_ABORT_PATH_ACTIVE when completing TMF=
s.
      isci: Wait for RNC resumption before leaving the abort path.
      isci: Fix RNC suspend call for SCI_RESUMING state.
      isci: Manage tag releases differently when aborting tasks.
      isci: Callbacks to libsas occur under scic_lock and are synchroni=
zed.
      isci: When in the abort path, defeat other resume calls until don=
e.
      isci: Implement waiting for suspend in the abort path.
      isci: Make sure all TCs are terminated and cleaned in LUN reset.
      isci: Manage the LLHANG timer enable/disable per-device.
      isci: Save the suspension hint for upcoming suspensions.
      isci: Fix the terminated I/O to not call sas_task_abort().
      isci: Distinguish between remote device suspension cases
      isci: Remove isci_device reqs_in_process and dev_node from isci_d=
evice.
      isci: Only set IDEV_GONE in the device stop path.
      isci: All pending TCs are terminated when the RNC is invalidated.
      isci: Device access in the error path does not depend on IDEV_GON=
E.
      isci: Add suspension cases for RNC INVALIDATING, POSTING states.
      isci: Redesign device suspension, abort, cleanup.
      isci: Escalate to I_T_Nexus_Reset when the device is gone.
      isci: Remote device stop also suspends the RNC and terminates I/O=
=2E
      isci: Remote device must be suspended for NCQ cleanup.
      isci: Manage device suspensions during TC terminations.
      isci: Terminate outstanding TCs on TX/RX RNC suspensions.
      isci: Handle all suspending TC completions
      isci: Fixed bug in resumption from RNC Tx/Rx suspend state.
      isci: Manage the link layer hang detect timer for RNC suspensions=
=2E

John Soni Jose (2):
      be2iscsi: Get Port State and Speed of the Adapter
      be2iscsi: Get Initiator Name for the iSCSI_Host

J=C3=B6rn Engel (9):
      sg: constify sg_proc_leaf_arr
      sg: remove sg_mutex
      sg: completely protect sfds
      sg: protect sdp->exclude
      sg: prevent unwoken sleep
      sg: remove closed flag
      sg: use wait_event_interruptible()
      sg: remove while (1) non-loop
      sg: remove unnecessary indentation

K. Y. Srinivasan (1):
      storvsc: Properly handle errors from the host

Krishna Gudipati (4):
      bfa: Update the MAINTAINERS file.
      bfa: Fix bfa logging for Logical port state change notification
      bfa: sysfs model description fix.
      bfa: Fix to defer vport delete handler invocation till firmware l=
ogo response.

Maciej Trela (1):
      isci: enable BCN in sci_port_add_phy()

Mark Salyzyn (1):
      pm8001: raise host can queue

Matt Bondurant (1):
      hpsa: retry driver initiated commands on busy status

Matt Gates (2):
      hpsa: refine interrupt handler locking for greater concurrency
      hpsa: use multiple reply queues

Mike Christie (3):
      fc class: fix scanning when devs are offline
      be2iscsi: adding functionality to change network settings using i=
scsiadm
      be2iscsi: Freeing of WRB and SGL Handle in cleanup task

Mike Maslenkin (1):
      scsi_transport_spi: fix for unbalanced reference counting

Mike Miller (1):
      hpsa: add new RAID level "1(ADM)"

Moger, Babu (3):
      scsi_dh_alua: Optimize the STPG command
      scsi_dh_alua: Store the PREF bit from RTPG
      scsi_dh_alua: Inroduce the set_params interface scsi_dh_alua hand=
ler

Robert Love (1):
      fcoe: Don't hold rtnl_mutex in fcoe_update_src_mac

Roland Dreier (1):
      be2iscsi: Remove unused OFFSET_IN_PAGE() macro

Santosh Nayak (1):
      pm8001: fix endian issue with code optimization.

Santosh Yaraganavi (1):
      ufs: Assign UTRLBAU =3D upper_32_ bits(UTRLD base address)

Stephen M. Cameron (13):
      hpsa: dial down lockup detection during firmware flash
      hpsa: removed unused member maxQsinceinit
      hpsa: factor out hpsa_free_irqs_and_disable_msix
      hpsa: factor out tail calls to next_command() in process_(non)ind=
exed_cmd()
      hpsa: do aborts two ways
      hpsa: add abort error handler function
      hpsa: remove unused parameter from finish_cmd
      hpsa: do not give up retry of driver cmds after only 3 retries
      hpsa: do not read from controller unnecessarily in completion cod=
e
      hpsa: suppress excessively chatty error messages
      hpsa: enable bus master bit after pci_enable_device
      hpsa: do not skip disabled devices
      hpsa: call pci_disable_device on driver unload

Tom Jackson (1):
      isci: Don't filter BROADCAST CHANGE primitives

Tomas Henzl (2):
      mpt2sas: move the scsi_host_put to the right place
      aacraid: add an iounmap call to aac_src_ioremap

Vasu Dev (3):
      libfc: defer releasing master lport until complete fcoe interface=
 cleanuped up
      libfc: flush lport worker after its disabled
      fcoe: remove lport from net device before doing per cpu rx thread=
 cleanup

Venkatraman S (1):
      ufs: Fix evaluation of UTP task completion code

Vinayak Holikatti (1):
      ufs: Update MAINTAINERS

Yi Zou (1):
      libfcoe: fix VN2VN N_Port_ID Beacon source MAC

nagalakshmi.nandigama@lsi.com (12):
      mpt2sas: Bump driver vesion to 13.100.00.00
      mpt2sas: Fix for panic happening because of improper memory alloc=
ation
      mpt2sas: Fix for hard drive going OFFLINE when hard reset issued =
and simultaneously another hard drive is hot unplugged
      mpt2sas: Set the phy identifier of the end device to the phy numb=
er of the parent device it is linked to
      mpt2sas : While enabling phy, read the current port number from s=
as iounit page 0 instead of page 1
      mpt2sas: Fix linux driver sparse errors
      mpt2sas: Fix security scan issues reported by source code analysi=
s tool
      mpt2sas: Improvement were made to better protect the sas_device, =
raid_device, and expander_device lists
      mpt2sas : Perform Target Reset instead of HBA reset when a SATA_P=
ASSTHROUGH cmd timeout happens
      mpt2sas: Added multisegment mode support for Linux BSG Driver
      mpt2sas: Removed redundant global mutex for IOCTLs
      mpt2sas: MPI next revision header update

And the diffstat:

 Documentation/scsi/ChangeLog.megaraid_sas     |    8 +
 MAINTAINERS                                   |    9 +
 drivers/scsi/Kconfig                          |    1 +
 drivers/scsi/aacraid/src.c                    |    2 +
 drivers/scsi/be2iscsi/be.h                    |    4 -
 drivers/scsi/be2iscsi/be_cmds.c               |    2 +
 drivers/scsi/be2iscsi/be_cmds.h               |  154 ++++-
 drivers/scsi/be2iscsi/be_iscsi.c              |  493 +++++++++++++--
 drivers/scsi/be2iscsi/be_iscsi.h              |   15 +
 drivers/scsi/be2iscsi/be_main.c               |  447 ++++++++------
 drivers/scsi/be2iscsi/be_main.h               |   17 +-
 drivers/scsi/be2iscsi/be_mgmt.c               |  522 +++++++++++++++-
 drivers/scsi/be2iscsi/be_mgmt.h               |   50 +-
 drivers/scsi/bfa/bfa_fcs.h                    |    3 -
 drivers/scsi/bfa/bfa_fcs_lport.c              |   32 +-
 drivers/scsi/bfa/bfad.c                       |   17 -
 drivers/scsi/bfa/bfad_attr.c                  |   20 +-
 drivers/scsi/bnx2i/57xx_iscsi_constants.h     |    2 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h           |    2 +-
 drivers/scsi/bnx2i/bnx2i.h                    |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                |    2 +-
 drivers/scsi/bnx2i/bnx2i_init.c               |    6 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c              |    3 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c              |    2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c    |   70 ++-
 drivers/scsi/fcoe/fcoe.c                      |   41 +-
 drivers/scsi/fcoe/fcoe.h                      |    4 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                 |    8 +-
 drivers/scsi/hpsa.c                           |  683 ++++++++++++++++-=
----
 drivers/scsi/hpsa.h                           |   85 ++-
 drivers/scsi/hpsa_cmd.h                       |   37 +-
 drivers/scsi/isci/host.c                      |  703 ++++++++---------=
-----
 drivers/scsi/isci/host.h                      |  124 ++--
 drivers/scsi/isci/init.c                      |  212 ++++++-
 drivers/scsi/isci/phy.c                       |   76 ++-
 drivers/scsi/isci/phy.h                       |    9 +-
 drivers/scsi/isci/port.c                      |   68 ++-
 drivers/scsi/isci/port.h                      |   11 +-
 drivers/scsi/isci/port_config.c               |   18 +-
 drivers/scsi/isci/probe_roms.c                |   12 -
 drivers/scsi/isci/probe_roms.h                |    2 -
 drivers/scsi/isci/registers.h                 |    8 +
 drivers/scsi/isci/remote_device.c             |  576 +++++++++++++----=
-
 drivers/scsi/isci/remote_device.h             |   63 +-
 drivers/scsi/isci/remote_node_context.c       |  393 ++++++++----
 drivers/scsi/isci/remote_node_context.h       |   43 +-
 drivers/scsi/isci/request.c                   |  715 ++++++++++-------=
-----
 drivers/scsi/isci/request.h                   |  125 +---
 drivers/scsi/isci/scu_completion_codes.h      |    2 +
 drivers/scsi/isci/task.c                      |  800 +++++------------=
--------
 drivers/scsi/isci/task.h                      |  132 +---
 drivers/scsi/isci/unsolicited_frame_control.c |   30 +-
 drivers/scsi/isci/unsolicited_frame_control.h |    6 +-
 drivers/scsi/libfc/fc_lport.c                 |    2 +-
 drivers/scsi/lpfc/lpfc.h                      |    4 +
 drivers/scsi/lpfc/lpfc_bsg.c                  |    4 +-
 drivers/scsi/lpfc/lpfc_bsg.h                  |    3 +-
 drivers/scsi/lpfc/lpfc_crtn.h                 |    8 +-
 drivers/scsi/lpfc/lpfc_debugfs.c              |   46 ++
 drivers/scsi/lpfc/lpfc_debugfs.h              |  418 +++++++++++++
 drivers/scsi/lpfc/lpfc_els.c                  |  141 ++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c              |   18 +-
 drivers/scsi/lpfc/lpfc_hw.h                   |    3 +
 drivers/scsi/lpfc/lpfc_hw4.h                  |   18 +-
 drivers/scsi/lpfc/lpfc_init.c                 |  377 +++++++-----
 drivers/scsi/lpfc/lpfc_nportdisc.c            |    9 +
 drivers/scsi/lpfc/lpfc_scsi.c                 |  414 ++++++++-----
 drivers/scsi/lpfc/lpfc_sli.c                  |  785 ++++++++++-------=
-------
 drivers/scsi/lpfc/lpfc_sli.h                  |    2 +-
 drivers/scsi/lpfc/lpfc_sli4.h                 |   17 +-
 drivers/scsi/lpfc/lpfc_version.h              |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h          |    6 +-
 drivers/scsi/megaraid/megaraid_sas_base.c     |    2 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c       |   21 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c   |    4 +-
 drivers/scsi/mpt2sas/mpi/mpi2.h               |    7 +-
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h          |   68 ++-
 drivers/scsi/mpt2sas/mpt2sas_base.c           |   38 +-
 drivers/scsi/mpt2sas/mpt2sas_base.h           |   10 +-
 drivers/scsi/mpt2sas/mpt2sas_ctl.c            |  312 +++++-----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c          |  597 +++++++++--------=
-
 drivers/scsi/mpt2sas/mpt2sas_transport.c      |  243 ++++++--
 drivers/scsi/pm8001/pm8001_defs.h             |    3 +-
 drivers/scsi/pm8001/pm8001_hwi.c              |   23 +-
 drivers/scsi/pm8001/pm8001_hwi.h              |    2 +-
 drivers/scsi/pm8001/pm8001_init.c             |   10 +-
 drivers/scsi/scsi.c                           |    6 +
 drivers/scsi/scsi_lib.c                       |   10 +-
 drivers/scsi/scsi_pm.c                        |    2 +-
 drivers/scsi/scsi_priv.h                      |    2 +
 drivers/scsi/scsi_transport_fc.c              |   24 +-
 drivers/scsi/scsi_transport_spi.c             |    4 +-
 drivers/scsi/sd.c                             |    5 +-
 drivers/scsi/sg.c                             |  183 +++---
 drivers/scsi/st.h                             |    2 +-
 drivers/scsi/storvsc_drv.c                    |   20 +-
 drivers/scsi/ufs/ufshcd.c                     |    8 +-
 include/scsi/iscsi_proto.h                    |    2 +
 include/scsi/sas.h                            |    1 +
 99 files changed, 6500 insertions(+), 4257 deletions(-)

James
