Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC41CC11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 08:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFD2761411
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 08:11:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhGBIOQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 04:14:16 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:50928 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230147AbhGBIOP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 04:14:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 7F6BF12801D4;
        Fri,  2 Jul 2021 01:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1625213503;
        bh=Vj+FYzuk7H19doW2FAgW/dd6oz2LZ4goFsGGhi3lDcA=;
        h=Message-ID:Subject:From:To:Date:From;
        b=Z1y8EryGTHldajuJori3q4FeefPo/rLmwtIygu5O9WJVn6ASXZs+JZYMxs+OJND3H
         qcoeaPkZlDu+IwjLRxi1os/lJfHTnBZ0Y3PaRCy5knX0KuQ8QeYetdJ2RoPQTDyf63
         fihglMdm6xbxO2ULIqS/Dy3JMoXRJ6UW0s47qUUs=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gFcwj7Un0mC6; Fri,  2 Jul 2021 01:11:43 -0700 (PDT)
Received: from [192.168.42.44] (cpc1-seac25-2-0-cust181.7-2.cable.virginm.net [82.8.18.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3547C1280144;
        Fri,  2 Jul 2021 01:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1625213503;
        bh=Vj+FYzuk7H19doW2FAgW/dd6oz2LZ4goFsGGhi3lDcA=;
        h=Message-ID:Subject:From:To:Date:From;
        b=Z1y8EryGTHldajuJori3q4FeefPo/rLmwtIygu5O9WJVn6ASXZs+JZYMxs+OJND3H
         qcoeaPkZlDu+IwjLRxi1os/lJfHTnBZ0Y3PaRCy5knX0KuQ8QeYetdJ2RoPQTDyf63
         fihglMdm6xbxO2ULIqS/Dy3JMoXRJ6UW0s47qUUs=
Message-ID: <e118d4b2fb924156f791564483336e7125276c47.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.13+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 02 Jul 2021 09:11:40 +0100
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series consists of the usual driver updates (ufs, ibmvfc,
megaraid_sas, lpfc, elx, mpi3mr, qedi, iscsi, storvsc, mpt3sas) with
elx and mpi3mr being new drivers.  The major core change is a rework to
drop the status byte handling macros and the old bit shifted
definitions and the rest of the updates are minor fixes.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alice.Chao (2):
      scsi: ufs: ufs-mediatek: Disable HCI before HW reset
      scsi: ufs: core: Export ufshcd_hba_stop()

Andy Shevchenko (2):
      scsi: ppa: Switch to use module_parport_driver()
      scsi: imm: Switch to use module_parport_driver()

Asutosh Das (2):
      scsi: ufs: sysfs: Resume the proper SCSI device
      scsi: ufs: core: Enable power management for wlun

Avri Altman (1):
      scsi: ufs: core: Remove irrelevant reference to non-existing doc

Baokun Li (1):
      scsi: qla2xxx: Use list_move_tail() instead of list_del()/list_add_tail()

Bart Van Assche (7):
      scsi: core: Change the type of the second argument of scsi_host_complete_all_commands()
      scsi: core: Introduce enums for the SAM and host status codes
      scsi: libsas: Introduce more SAM status code aliases in enum exec_status
      scsi: ufs: Suppress false positive unhandled interrupt messages
      scsi: ufs: Use designated initializers in ufs_pm_lvl_states[]
      scsi: ufs: ufs-exynos: Move definitions from .h to .c
      scsi: ufs: core: Remove usfhcd_is_*_pm() macros

Bean Huo (5):
      scsi: ufs: core: Use UPIU query trace in devman_upiu_cmd()
      scsi: ufs: core: Capture command trace only for the cmd != NULL case
      scsi: ufs: core: Let UPIU completion trace print RSP UPIU header
      scsi: ufs: core: Clean up ufshcd_add_command_trace()
      scsi: ufs: Fix a kernel-doc related formatting issue

Bodo Stroesser (1):
      scsi: target: tcmu: Rename TCM_DEV_BIT_PLUGGED to TCMU_DEV_BIT_PLUGGED

Brian King (3):
      scsi: ibmvfc: Reinit target retries
      scsi: ibmvfc: Avoid move login if fast fail is enabled
      scsi: ibmvfc: Handle move login failure

Can Guo (5):
      scsi: ufs: core: Fix a possible use before initialization case
      scsi: ufs: Utilize Transfer Request List Completion Notification Register
      scsi: ufs: Optimize host lock on transfer requests send/compl paths
      scsi: ufs: Remove a redundant command completion logic in error handler
      scsi: ufs: core: Introduce HBA performance monitor sysfs nodes

Chandrakanth Patil (4):
      scsi: megaraid_sas: Update driver version to 07.717.02.00-rc1
      scsi: megaraid_sas: Handle missing interrupts while re-enabling IRQs
      scsi: megaraid_sas: Fix resource leak in case of probe failure
      scsi: megaraid_sas: Send all non-RW I/Os for TYPE_ENCLOSURE device through firmware

Christophe JAILLET (2):
      scsi: bfa: Remove some unused variables
      scsi: snic: Fix an error message

Colin Ian King (9):
      scsi: elx: libefc: Fix less than zero comparison of a unsigned int
      scsi: elx: efct: Remove redundant initialization of variable lun
      scsi: elx: efct: Fix spelling mistake "Unexected" -> "Unexpected"
      scsi: target: iscsi: Remove redundant continue statement
      scsi: qla4xxx: Remove redundant continue statement
      scsi: ufs: ufs-exynos: Make a const array static, makes object smaller
      scsi: megaraid_mbox: Remove redundant initialization of pointer mbox
      scsi: lpfc: Remove redundant assignment to pointer temp_hdr
      scsi: 3w-9xxx: Move * operator to clean up code style warning

Dan Carpenter (4):
      scsi: elx: libefc: Fix IRQ restore in efc_domain_dispatch_frame()
      scsi: mpi3mr: Fix error handling in mpi3mr_setup_isr()
      scsi: mpi3mr: Delete unnecessary NULL check
      scsi: scsi_dh_alua: Fix signedness bug in alua_rtpg()

Daniel Wagner (2):
      scsi: qla2xxx: Log PCI address in qla_nvme_unregister_remote_port()
      scsi: scsi_transport_fc: Remove double FC_FPORT_DELETED in mask creation

Gaurav Srivastava (10):
      scsi: lpfc: vmid: Introduce VMID in I/O path
      scsi: lpfc: vmid: Add QFPA and VMID timeout check in worker thread
      scsi: lpfc: vmid: Timeout implementation for VMID
      scsi: lpfc: vmid: Append the VMID to the wqe before sending
      scsi: lpfc: vmid: Implement CT commands for appid
      scsi: lpfc: vmid: Functions to manage VMIDs
      scsi: lpfc: vmid: Implement ELS commands for appid
      scsi: lpfc: vmid: Add support for VMID in mailbox command
      scsi: lpfc: vmid: VMID parameter initialization
      scsi: lpfc: vmid: Add datastructure for supporting VMID in lpfc

Guenter Roeck (2):
      scsi: qedf: Drop unnecessary NULL checks after container_of()
      scsi: target: iscsi: Drop unnecessary container_of()

Gustavo A. R. Silva (4):
      scsi: mpi3mr: Fix fall-through warning for Clang
      scsi: NCR5380: Fix fall-through warning for Clang
      scsi: mpt3sas: Fix fall-through warnings for Clang
      scsi: aacraid: Replace one-element array with flexible-array member

Hannes Reinecke (40):
      scsi: core: Drop obsolete Linux-specific SCSI status codes
      scsi: pcmcia: nsp_cs: Use SAM_STAT_CHECK_CONDITION
      scsi: target: Use standard SAM status types
      scsi: core: Kill message byte
      scsi: core: Drop message byte helper
      scsi: fdomain: Translate message to host byte status
      scsi: fdomain: Drop last argument to fdomain_finish_cmd()
      scsi: FlashPoint: Use standard SCSI definitions
      scsi: fas216: Use get_status_byte() to avoid using Linux-specific status codes
      scsi: fas216: Translate message to host byte status
      scsi: advansys: Do not set message byte in SCSI status
      scsi: aha152x: Do not set message byte when calling scsi_done()
      scsi: aha152x: Modify done() to use separate status bytes
      scsi: acornscsi: Translate message byte to host byte
      scsi: acornscsi: Remove acornscsi_reportstatus()
      scsi: mesh: Translate message to host byte status
      scsi: wd33c93: Translate message byte to host byte
      scsi: nsp32: Do not set message byte
      scsi: nsp32: Whitespace cleanup
      scsi: qlogicfas408: Whitespace cleanup
      scsi: qlogicfas408: make ql_pcmd() a void function
      scsi: dc395: Translate message bytes
      scsi: dc395: Use standard macros to set SCSI result
      scsi: core: Add scsi_msg_to_host_byte()
      scsi: core: Add get_{status,host}_byte() accessor functions
      scsi: NCR5380: Fold SCSI message ABORT onto DID_ABORT
      scsi: core: Drop the now obsolete driver_byte definitions
      scsi: xen-scsifront: Compability status handling
      scsi: xen-scsiback: Use DID_ERROR instead of DRIVER_ERROR
      scsi: core: Use DID_TIME_OUT instead of DRIVER_TIMEOUT
      scsi: core: Do not use DRIVER_INVALID
      scsi: core: Kill DRIVER_SENSE
      scsi: core: Introduce scsi_status_is_check_condition()
      scsi: core: Introduce scsi_build_sense()
      scsi: core: Stop using DRIVER_ERROR
      scsi: scsi_dh_alua: Check for negative result value
      scsi: core: Reshuffle response handling in scsi_mode_sense()
      scsi: core: Fixup calling convention for scsi_mode_sense()
      scsi: scsi_ioctl: Return error code when blk_rq_map_kern() fails
      scsi: st: Return error code in st_scsi_execute()

James Smart (46):
      scsi: elx: efct: Fix pointer error checking in debugfs init
      scsi: elx: efct: Fix is_originator return code type
      scsi: elx: efct: Fix link error for _bad_cmpxchg
      scsi: lpfc: Fix build error in lpfc_scsi.c
      scsi: elx: efct: Tie into kernel Kconfig and build process
      scsi: elx: efct: Add Makefile and Kconfig for efct driver
      scsi: elx: efct: Transport class host interface support
      scsi: elx: efct: Transport and hardware teardown routines
      scsi: elx: efct: Link and host statistics
      scsi: elx: efct: Hardware I/O submission routines
      scsi: elx: efct: LIO backend interface routines
      scsi: elx: efct: SCSI I/O handling routines
      scsi: elx: efct: Unsolicited FC frame processing routines
      scsi: elx: efct: Hardware queues processing
      scsi: elx: efct: Hardware I/O and SGL initialization
      scsi: elx: efct: RQ buffer, memory pool allocation and deallocation APIs
      scsi: elx: efct: Hardware queue creation and deletion
      scsi: elx: efct: Driver initialization routines
      scsi: elx: efct: Data structures and defines for hw operations
      scsi: elx: libefc: Register discovery objects with hardware
      scsi: elx: libefc: Extended link Service I/O handling
      scsi: elx: libefc: FC node ELS and state handling
      scsi: elx: libefc: Fabric node state machine interfaces
      scsi: elx: libefc: Remote node state machine interfaces
      scsi: elx: libefc: SLI and FC PORT state machine interfaces
      scsi: elx: libefc: FC Domain state machine interfaces
      scsi: elx: libefc: Emulex FC discovery library APIs and definitions
      scsi: elx: libefc: Generic state machine framework
      scsi: elx: libefc_sli: APIs to setup SLI library
      scsi: elx: libefc_sli: BMBX routines and SLI config commands
      scsi: elx: libefc_sli: Populate and post different WQEs
      scsi: elx: libefc_sli: Queue create/destroy/parse routines
      scsi: elx: libefc_sli: Data structures and defines for mbox commands
      scsi: elx: libefc_sli: SLI Descriptors and Queue entries
      scsi: elx: libefc_sli: SLI-4 register offsets and field definitions
      scsi: lpfc: Update lpfc version to 12.8.0.10
      scsi: lpfc: Reregister FPIN types if ELS_RDF is received from fabric controller
      scsi: lpfc: Add a option to enable interlocked ABTS before job completion
      scsi: lpfc: Fix crash when lpfc_sli4_hba_setup() fails to initialize the SGLs
      scsi: lpfc: Ignore GID-FT response that may be received after a link flip
      scsi: lpfc: Fix node handling for Fabric Controller and Domain Controller
      scsi: lpfc: Fix Node recovery when driver is handling simultaneous PLOGIs
      scsi: lpfc: Add ndlp kref accounting for resume RPI path
      scsi: lpfc: Fix "Unexpected timeout" error in direct attach topology
      scsi: lpfc: Fix non-optimized ERSP handling
      scsi: lpfc: Fix unreleased RPIs when NPIV ports are created

Jason Yan (1):
      scsi: core: Treat device offline as a failure

Javed Hasan (7):
      scsi: fc: FDMI enhancement
      scsi: libfc: FDMI enhancements
      scsi: libfc: Add FDMI-2 attributes
      scsi: qedf: Add vendor identifier attribute
      scsi: libfc: Initialisation of RHBA and RPA attributes
      scsi: libfc: Correct the condition check and invalid argument passed
      scsi: fc: Correct RHBA attributes length

Jiapeng Chong (4):
      scsi: qla2xxx: Remove redundant assignment to rval
      scsi: bfa: Fix inconsistent indenting
      scsi: target: sbp_target: Remove redundant assignment to pg_size
      scsi: message: fusion: Remove redundant assignment to rc

John Garry (1):
      scsi: core: Cap scsi_host cmd_per_lun at can_queue

Juerg Haefliger (1):
      scsi: core: Remove leading spaces in Kconfig

Kashyap Desai (25):
      scsi: megaraid_sas: Early detection of VD deletion through RaidMap update
      scsi: mpi3mr: Add event handling debug prints
      scsi: mpi3mr: Add EEDP DIF DIX support
      scsi: mpi3mr: Add support for DSN secure firmware check
      scsi: mpi3mr: Add support for PM suspend and resume
      scsi: mpi3mr: Wait for pending I/O completions upon detection of VD I/O timeout
      scsi: mpi3mr: Print pending host I/Os for debugging
      scsi: mpi3mr: Complete support for soft reset
      scsi: mpi3mr: Add support for threaded ISR
      scsi: mpi3mr: Hardware workaround for UNMAP commands to NVMe drives
      scsi: mpi3mr: Allow certain commands during pci-remove hook
      scsi: mpi3mr: Add change queue depth support
      scsi: mpi3mr: Implement SCSI error handler hooks
      scsi: mpi3mr: Add bios_param SCSI host template hook
      scsi: mpi3mr: Print IOC info for debugging
      scsi: mpi3mr: Add support for timestamp sync with firmware
      scsi: mpi3mr: Add support for recovering controller
      scsi: mpi3mr: Additional event handling
      scsi: mpi3mr: Add support for PCIe device event handling
      scsi: mpi3mr: Add support for device add/remove event handling
      scsi: mpi3mr: Add support for internal watchdog thread
      scsi: mpi3mr: Add support for queue command processing
      scsi: mpi3mr: Create operational request and reply queue pair
      scsi: mpi3mr: Base driver code
      scsi: mpi3mr: Add mpi30 Rev-R headers and Kconfig

Kees Cook (6):
      scsi: aha1740: Avoid over-read of sense buffer
      scsi: arcmsr: Avoid over-read of sense buffer
      scsi: ips: Avoid over-read of sense buffer
      scsi: fcoe: Statically initialize flogi_maddr
      scsi: isci: Use correctly sized target buffer for memcpy()
      scsi: esas2r: Switch to flexible array member

Keoseong Park (3):
      scsi: ufs: core: Remove repeated word in comment
      scsi: ufs: core: Clean up whitespace
      scsi: ufs: core: Remove redundant parenthesis

Konstantin Shelekhin (2):
      scsi: target: core: Add the VERSION DESCRIPTOR fields to the INQUIRY data
      scsi: target: core: Bump INQUIRY VERSION to SPC-4

Luo Jiaxing (5):
      scsi: hisi_sas: Speed up error handling when internal abort timeout occurs
      scsi: hisi_sas: Reset controller for internal abort timeout
      scsi: hisi_sas: Include HZ in timer macros
      scsi: hisi_sas: Run I_T nexus resets in parallel for clear nexus reset
      scsi: hisi_sas: Put a limit of link reset retries

Martin Wilck (1):
      scsi: scsi_dh_alua: Retry RTPG on a different path after failure

Michael Kelley (3):
      scsi: storvsc: Correctly handle multiple flags in srb_status
      scsi: storvsc: Update error logging
      scsi: storvsc: Miscellaneous code cleanups

Mike Christie (29):
      scsi: qedi: Fix host removal with running sessions
      scsi: qedi: Wake up if cmd_cleanup_req is set
      scsi: qedi: Complete TMF works before disconnect
      scsi: qedi: Pass send_iscsi_tmf task to abort
      scsi: qedi: Fix cleanup session block/unblock use
      scsi: qedi: Fix TMF session block/unblock use
      scsi: qedi: Use GFP_NOIO for TMF allocation
      scsi: qedi: Fix TMF tid allocation
      scsi: qedi: Fix use after free during abort cleanup
      scsi: qedi: Fix race during abort timeouts
      scsi: qedi: Fix null ref during abort handling
      scsi: iscsi: Move pool freeing
      scsi: iscsi: Hold task ref during TMF timeout handling
      scsi: iscsi: Flush block work before unblock
      scsi: iscsi: Fix completion check during abort races
      scsi: iscsi: Fix shost->max_id use
      scsi: iscsi: Fix conn use after free during resets
      scsi: iscsi: Get ref to conn during reset handling
      scsi: iscsi: Have abort handler get ref to conn
      scsi: iscsi: Add iscsi_cls_conn refcount helpers
      scsi: iscsi: iscsi_tcp: Start socket shutdown during conn stop
      scsi: iscsi: iscsi_tcp: Set no linger
      scsi: iscsi: Fix in-kernel conn failure handling
      scsi: iscsi: Rel ref after iscsi_lookup_endpoint()
      scsi: iscsi: Use system_unbound_wq for destroy_work
      scsi: iscsi: Force immediate failure during shutdown
      scsi: iscsi: Drop suspend calls from ep_disconnect
      scsi: iscsi: Stop queueing during ep_disconnect
      scsi: iscsi: Add task completion helper

Muneendra Kumar (3):
      scsi: nvme: Added a new sysfs attribute appid_store
      scsi: blkcg: Add app identifier support for blkcg
      scsi: cgroup: Add cgroup_get_from_id()

Nathan Chancellor (2):
      scsi: elx: efct: Eliminate unnecessary boolean check in efct_hw_command_cancel()
      scsi: elx: efct: Do not use id uninitialized in efct_lio_setup_session()

Nigel Christian (1):
      scsi: be2iscsi: Remove redundant initialization

Peter Wang (1):
      scsi: ufs-mediatek: Create reset control device_link

Randy Dunlap (3):
      scsi: FlashPoint: Rename si_flags field
      scsi: message: fusion: Documentation cleanup
      scsi: mpt3sas: Documentation cleanup

Samuel Holland (3):
      scsi: 3w-9xxx: Fix endianness issues in command packets
      scsi: 3w-9xxx: Reduce scope of structure packing
      scsi: 3w-9xxx: Use flexible array members to avoid struct padding

Saurav Kashyap (1):
      scsi: qedf: Update the max_id value in host structure

Sergey Samoylenko (2):
      scsi: target: core: Add configurable IEEE Company ID attribute
      scsi: target: core: Unify NAA identifier generation

Sergey Shtylyov (1):
      scsi: hisi_sas: Propagate errors in interrupt_init_v1_hw()

Shaokun Zhang (1):
      scsi: qla2xxx: Remove duplicate declarations

Shixin Liu (1):
      scsi: megaraid_sas: Use DEFINE_SPINLOCK() for spinlock

Suganath Prabu S (4):
      scsi: mpt3sas: Fix Coverity reported issue
      scsi: mpt3sas: Handle firmware faults during second half of IOC init
      scsi: mpt3sas: Handle firmware faults during first half of IOC init
      scsi: mpt3sas: Fix deadlock while cancelling the running firmware event

Tomas Henzl (1):
      scsi: mpi3mr: Fix a double free

Uwe Kleine-König (1):
      scsi: scsi_debug: Drop if with an always false condition

Varun Prakash (1):
      scsi: target: cxgbit: Unmap DMA buffer before calling target_execute_cmd()

Wan Jiabing (1):
      scsi: qla4xxx: Simplify conditional

Wei Ming Chen (1):
      scsi: fas216: Use fallthrough pseudo-keyword

Wei Yongjun (1):
      scsi: elx: efct: Fix error handling in efct_hw_init()

Xiang Chen (1):
      scsi: core: Fix a comment in function scsi_host_dev_release()

Yang Yingliang (5):
      scsi: mpi3mr: Make some symbols static
      scsi: mpi3mr: Fix error return code in mpi3mr_init_ioc()
      scsi: mpi3mr: Fix missing unlock on error
      scsi: qedf: Use vzalloc() instead of vmalloc()/memset(0)
      scsi: target: iscsi: Switch to kmemdup_nul()

Zhen Lei (3):
      scsi: mpt3sas: Fix error return value in _scsih_expander_add()
      scsi: pm8001: Remove unnecessary OOM message
      scsi: Fix spelling mistakes in header files

Zou Wei (2):
      scsi: ufs: ufs-mediatek: Add missing of_node_put() in ufs_mtk_probe()
      scsi: lpfc: Use list_move_tail() instead of list_del()/list_add_tail()

ching Huang (4):
      scsi: arcmsr: Update driver version to v1.50.00.05-20210429
      scsi: arcmsr: Fix doorbell status being updated late on ARC-1886
      scsi: arcmsr: Update driver version to v1.50.00.04-20210414
      scsi: arcmsr: Fix the wrong CDB payload report to IOP

kernel test robot (1):
      scsi: target: tcmu: Fix boolreturn.cocci warnings

zuoqilin (2):
      scsi: bfa: Fix typo
      scsi: pmcraid: Fix typos

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs     |  126 +
 Documentation/scsi/scsi_mid_low_api.rst        |    7 +-
 MAINTAINERS                                    |    9 +
 block/Kconfig                                  |    9 +
 block/bsg-lib.c                                |    2 +-
 block/bsg.c                                    |    4 +-
 block/scsi_ioctl.c                             |   13 +-
 drivers/ata/libata-scsi.c                      |   30 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c       |    2 +
 drivers/infiniband/ulp/srp/ib_srp.c            |    2 +-
 drivers/message/fusion/mptbase.c               |    2 -
 drivers/message/fusion/mptsas.c                |  119 +-
 drivers/nvme/host/fc.c                         |   72 +-
 drivers/s390/scsi/zfcp_scsi.c                  |    5 +-
 drivers/scsi/3w-9xxx.c                         |   74 +-
 drivers/scsi/3w-9xxx.h                         |  121 +-
 drivers/scsi/3w-xxxx.c                         |    6 +-
 drivers/scsi/53c700.c                          |    6 +-
 drivers/scsi/FlashPoint.c                      |  197 +-
 drivers/scsi/Kconfig                           |   18 +-
 drivers/scsi/Makefile                          |    2 +
 drivers/scsi/NCR5380.c                         |   10 +-
 drivers/scsi/aacraid/aachba.c                  |   10 +-
 drivers/scsi/aacraid/aacraid.h                 |    2 +-
 drivers/scsi/advansys.c                        |    4 -
 drivers/scsi/aha152x.c                         |   33 +-
 drivers/scsi/aha1740.c                         |    7 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c             |   19 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c             |    1 -
 drivers/scsi/aic94xx/aic94xx_task.c            |    2 +-
 drivers/scsi/arcmsr/arcmsr.h                   |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c               |   43 +-
 drivers/scsi/arm/acornscsi.c                   |   46 +-
 drivers/scsi/arm/fas216.c                      |   17 +-
 drivers/scsi/be2iscsi/be_iscsi.c               |   25 +-
 drivers/scsi/be2iscsi/be_main.c                |    7 +-
 drivers/scsi/bfa/bfa_defs_svc.h                |    2 +-
 drivers/scsi/bfa/bfa_svc.c                     |    8 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c               |   32 +-
 drivers/scsi/ch.c                              |    5 +-
 drivers/scsi/constants.c                       |   17 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c             |    1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c             |    1 +
 drivers/scsi/cxgbi/libcxgbi.c                  |   17 +-
 drivers/scsi/cxlflash/superpipe.c              |    3 +-
 drivers/scsi/dc395x.c                          |   80 +-
 drivers/scsi/device_handler/scsi_dh_alua.c     |   81 +-
 drivers/scsi/elx/Kconfig                       |    9 +
 drivers/scsi/elx/Makefile                      |   18 +
 drivers/scsi/elx/efct/efct_driver.c            |  786 ++++
 drivers/scsi/elx/efct/efct_driver.h            |  109 +
 drivers/scsi/elx/efct/efct_hw.c                | 3581 ++++++++++++++++
 drivers/scsi/elx/efct/efct_hw.h                |  764 ++++
 drivers/scsi/elx/efct/efct_hw_queues.c         |  677 ++++
 drivers/scsi/elx/efct/efct_io.c                |  191 +
 drivers/scsi/elx/efct/efct_io.h                |  174 +
 drivers/scsi/elx/efct/efct_lio.c               | 1698 ++++++++
 drivers/scsi/elx/efct/efct_lio.h               |  189 +
 drivers/scsi/elx/efct/efct_scsi.c              | 1159 ++++++
 drivers/scsi/elx/efct/efct_scsi.h              |  203 +
 drivers/scsi/elx/efct/efct_unsol.c             |  492 +++
 drivers/scsi/elx/efct/efct_unsol.h             |   17 +
 drivers/scsi/elx/efct/efct_xport.c             | 1111 +++++
 drivers/scsi/elx/efct/efct_xport.h             |  186 +
 drivers/scsi/elx/include/efc_common.h          |   37 +
 drivers/scsi/elx/libefc/efc.h                  |   52 +
 drivers/scsi/elx/libefc/efc_cmds.c             |  777 ++++
 drivers/scsi/elx/libefc/efc_cmds.h             |   35 +
 drivers/scsi/elx/libefc/efc_device.c           | 1603 ++++++++
 drivers/scsi/elx/libefc/efc_device.h           |   72 +
 drivers/scsi/elx/libefc/efc_domain.c           | 1088 +++++
 drivers/scsi/elx/libefc/efc_domain.h           |   54 +
 drivers/scsi/elx/libefc/efc_els.c              | 1098 +++++
 drivers/scsi/elx/libefc/efc_els.h              |  107 +
 drivers/scsi/elx/libefc/efc_fabric.c           | 1564 +++++++
 drivers/scsi/elx/libefc/efc_fabric.h           |  116 +
 drivers/scsi/elx/libefc/efc_node.c             | 1102 +++++
 drivers/scsi/elx/libefc/efc_node.h             |  191 +
 drivers/scsi/elx/libefc/efc_nport.c            |  777 ++++
 drivers/scsi/elx/libefc/efc_nport.h            |   50 +
 drivers/scsi/elx/libefc/efc_sm.c               |   54 +
 drivers/scsi/elx/libefc/efc_sm.h               |  197 +
 drivers/scsi/elx/libefc/efclib.c               |   81 +
 drivers/scsi/elx/libefc/efclib.h               |  620 +++
 drivers/scsi/elx/libefc_sli/sli4.c             | 5162 ++++++++++++++++++++++++
 drivers/scsi/elx/libefc_sli/sli4.h             | 4132 +++++++++++++++++++
 drivers/scsi/esas2r/atioctl.h                  |    2 +-
 drivers/scsi/esas2r/esas2r_main.c              |    2 +-
 drivers/scsi/esp_scsi.c                        |    4 +-
 drivers/scsi/fcoe/fcoe.c                       |    6 +-
 drivers/scsi/fdomain.c                         |   22 +-
 drivers/scsi/hisi_sas/hisi_sas.h               |    7 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c          |   99 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c         |   20 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c         |   10 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c         |   10 +-
 drivers/scsi/hosts.c                           |   13 +-
 drivers/scsi/hptiop.c                          |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                 |   60 +-
 drivers/scsi/ibmvscsi/ibmvfc.h                 |    3 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c               |    2 +-
 drivers/scsi/imm.c                             |   15 +-
 drivers/scsi/ips.c                             |   10 +-
 drivers/scsi/isci/request.c                    |   10 +-
 drivers/scsi/isci/task.c                       |    6 +-
 drivers/scsi/iscsi_tcp.c                       |    7 +
 drivers/scsi/libfc/fc_encode.h                 |  256 +-
 drivers/scsi/libfc/fc_lport.c                  |   88 +-
 drivers/scsi/libiscsi.c                        |  234 +-
 drivers/scsi/libsas/sas_ata.c                  |    7 +-
 drivers/scsi/libsas/sas_expander.c             |    2 +-
 drivers/scsi/libsas/sas_task.c                 |    4 +-
 drivers/scsi/lpfc/lpfc.h                       |  124 +
 drivers/scsi/lpfc/lpfc_attr.c                  |   59 +
 drivers/scsi/lpfc/lpfc_crtn.h                  |   12 +
 drivers/scsi/lpfc/lpfc_ct.c                    |  298 +-
 drivers/scsi/lpfc/lpfc_debugfs.c               |   11 +-
 drivers/scsi/lpfc/lpfc_disc.h                  |    2 +
 drivers/scsi/lpfc/lpfc_els.c                   |  665 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c               |  229 +-
 drivers/scsi/lpfc/lpfc_hw.h                    |  124 +-
 drivers/scsi/lpfc/lpfc_hw4.h                   |   12 +
 drivers/scsi/lpfc/lpfc_init.c                  |  109 +-
 drivers/scsi/lpfc/lpfc_mbox.c                  |    9 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c             |   40 +-
 drivers/scsi/lpfc/lpfc_nvme.c                  |   14 +-
 drivers/scsi/lpfc/lpfc_scsi.c                  |  416 +-
 drivers/scsi/lpfc/lpfc_sli.c                   |   66 +-
 drivers/scsi/lpfc/lpfc_sli.h                   |   11 +-
 drivers/scsi/lpfc/lpfc_version.h               |    2 +-
 drivers/scsi/megaraid.c                        |   20 +-
 drivers/scsi/megaraid/megaraid_mbox.c          |   27 +-
 drivers/scsi/megaraid/megaraid_sas.h           |   16 +-
 drivers/scsi/megaraid/megaraid_sas_base.c      |  102 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c        |    6 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c    |   21 +-
 drivers/scsi/mesh.c                            |    9 +-
 drivers/scsi/mpi3mr/Kconfig                    |    7 +
 drivers/scsi/mpi3mr/Makefile                   |    4 +
 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h           | 1880 +++++++++
 drivers/scsi/mpi3mr/mpi/mpi30_image.h          |  216 +
 drivers/scsi/mpi3mr/mpi/mpi30_init.h           |  159 +
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h            | 1004 +++++
 drivers/scsi/mpi3mr/mpi/mpi30_sas.h            |   33 +
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h      |  463 +++
 drivers/scsi/mpi3mr/mpi3mr.h                   |  901 +++++
 drivers/scsi/mpi3mr/mpi3mr_debug.h             |   60 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c                | 3958 ++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c                | 4045 +++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.c            |  349 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h            |    8 +
 drivers/scsi/mpt3sas/mpt3sas_config.c          |   18 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c           |  193 +-
 drivers/scsi/mvsas/mv_sas.c                    |   10 +-
 drivers/scsi/mvumi.c                           |   10 +-
 drivers/scsi/myrb.c                            |   64 +-
 drivers/scsi/myrs.c                            |    9 +-
 drivers/scsi/nsp32.c                           |  419 +-
 drivers/scsi/pcmcia/nsp_cs.c                   |    2 +-
 drivers/scsi/pm8001/pm8001_hwi.c               |   16 +-
 drivers/scsi/pm8001/pm8001_sas.c               |   10 +-
 drivers/scsi/pm8001/pm80xx_hwi.c               |   14 +-
 drivers/scsi/pmcraid.h                         |    4 +-
 drivers/scsi/ppa.c                             |   14 +-
 drivers/scsi/ps3rom.c                          |    7 +-
 drivers/scsi/qedf/qedf_dbg.c                   |    3 +-
 drivers/scsi/qedf/qedf_io.c                    |    5 -
 drivers/scsi/qedf/qedf_main.c                  |    9 +-
 drivers/scsi/qedi/qedi.h                       |    1 +
 drivers/scsi/qedi/qedi_fw.c                    |  291 +-
 drivers/scsi/qedi/qedi_gbl.h                   |    4 +-
 drivers/scsi/qedi/qedi_iscsi.c                 |  105 +-
 drivers/scsi/qedi/qedi_iscsi.h                 |    5 +-
 drivers/scsi/qedi/qedi_main.c                  |    9 +-
 drivers/scsi/qla2xxx/qla_gbl.h                 |    4 -
 drivers/scsi/qla2xxx/qla_init.c                |    2 -
 drivers/scsi/qla2xxx/qla_isr.c                 |   15 +-
 drivers/scsi/qla2xxx/qla_nvme.c                |    2 +-
 drivers/scsi/qla2xxx/qla_target.c              |    3 +-
 drivers/scsi/qla4xxx/ql4_83xx.c                |    3 +-
 drivers/scsi/qla4xxx/ql4_os.c                  |    4 +-
 drivers/scsi/qlogicfas408.c                    |  138 +-
 drivers/scsi/scsi.c                            |   11 +-
 drivers/scsi/scsi_debug.c                      |   20 +-
 drivers/scsi/scsi_error.c                      |   70 +-
 drivers/scsi/scsi_ioctl.c                      |    7 +-
 drivers/scsi/scsi_lib.c                        |  119 +-
 drivers/scsi/scsi_logging.c                    |   10 +-
 drivers/scsi/scsi_scan.c                       |    6 +-
 drivers/scsi/scsi_transport_fc.c               |    2 +-
 drivers/scsi/scsi_transport_iscsi.c            |  499 ++-
 drivers/scsi/scsi_transport_sas.c              |    9 +-
 drivers/scsi/scsi_transport_spi.c              |    2 +-
 drivers/scsi/sd.c                              |   63 +-
 drivers/scsi/sd_zbc.c                          |    3 +-
 drivers/scsi/sg.c                              |    9 +-
 drivers/scsi/smartpqi/smartpqi_init.c          |    3 +-
 drivers/scsi/snic/snic_ctl.c                   |    5 +-
 drivers/scsi/sr.c                              |    4 +-
 drivers/scsi/sr_ioctl.c                        |    6 +-
 drivers/scsi/st.c                              |    8 +-
 drivers/scsi/stex.c                            |    9 +-
 drivers/scsi/storvsc_drv.c                     |  119 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c            |    6 +-
 drivers/scsi/ufs/Kconfig                       |    1 +
 drivers/scsi/ufs/cdns-pltfrm.c                 |    2 +
 drivers/scsi/ufs/tc-dwc-g210-pci.c             |    2 +
 drivers/scsi/ufs/ufs-debugfs.c                 |    6 +-
 drivers/scsi/ufs/ufs-debugfs.h                 |    2 +-
 drivers/scsi/ufs/ufs-exynos.c                  |   31 +-
 drivers/scsi/ufs/ufs-exynos.h                  |   26 -
 drivers/scsi/ufs/ufs-hisi.c                    |    4 +-
 drivers/scsi/ufs/ufs-mediatek.c                |   45 +-
 drivers/scsi/ufs/ufs-qcom.c                    |    2 +
 drivers/scsi/ufs/ufs-sysfs.c                   |  269 +-
 drivers/scsi/ufs/ufs_bsg.c                     |    6 +-
 drivers/scsi/ufs/ufshcd-pci.c                  |   36 +-
 drivers/scsi/ufs/ufshcd.c                      | 1163 ++++--
 drivers/scsi/ufs/ufshcd.h                      |   82 +-
 drivers/scsi/ufs/ufshci.h                      |    1 +
 drivers/scsi/virtio_scsi.c                     |    5 +-
 drivers/scsi/vmw_pvscsi.c                      |    6 -
 drivers/scsi/wd33c93.c                         |   43 +-
 drivers/scsi/xen-scsifront.c                   |    8 +-
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c       |   19 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c    |   21 +-
 drivers/target/iscsi/iscsi_target_erl1.c       |    2 -
 drivers/target/iscsi/iscsi_target_nego.c       |   11 +-
 drivers/target/iscsi/iscsi_target_parameters.c |    4 +-
 drivers/target/loopback/tcm_loop.c             |    1 -
 drivers/target/sbp/sbp_target.c                |    1 -
 drivers/target/target_core_alua.c              |    6 +-
 drivers/target/target_core_configfs.c          |   50 +
 drivers/target/target_core_device.c            |    5 +
 drivers/target/target_core_iblock.c            |    2 +-
 drivers/target/target_core_pr.c                |    8 +-
 drivers/target/target_core_pr.h                |    2 +-
 drivers/target/target_core_pscsi.c             |    2 +-
 drivers/target/target_core_sbc.c               |   10 +-
 drivers/target/target_core_spc.c               |   97 +-
 drivers/target/target_core_user.c              |   10 +-
 drivers/target/target_core_xcopy.c             |   19 +-
 drivers/usb/storage/cypress_atacb.c            |    4 +-
 drivers/xen/xen-scsiback.c                     |   17 +-
 include/linux/blk-cgroup.h                     |   63 +
 include/linux/cgroup.h                         |    6 +
 include/scsi/fc/fc_ms.h                        |   59 +-
 include/scsi/iscsi_proto.h                     |    2 +-
 include/scsi/libfc.h                           |    6 +-
 include/scsi/libiscsi.h                        |   20 +-
 include/scsi/libsas.h                          |   12 +-
 include/scsi/scsi.h                            |  159 +-
 include/scsi/scsi_bsg_iscsi.h                  |    2 +-
 include/scsi/scsi_cmnd.h                       |   38 +-
 include/scsi/scsi_host.h                       |    2 +-
 include/scsi/scsi_proto.h                      |   58 +-
 include/scsi/scsi_status.h                     |   74 +
 include/scsi/scsi_transport_fc.h               |   25 +-
 include/scsi/scsi_transport_iscsi.h            |   14 +-
 include/scsi/sg.h                              |   35 +-
 include/target/target_core_base.h              |    1 +
 include/trace/events/scsi.h                    |   48 +-
 include/trace/events/ufs.h                     |   20 +
 kernel/cgroup/cgroup.c                         |   26 +
 264 files changed, 50071 insertions(+), 3039 deletions(-)
 create mode 100644 drivers/scsi/elx/Kconfig
 create mode 100644 drivers/scsi/elx/Makefile
 create mode 100644 drivers/scsi/elx/efct/efct_driver.c
 create mode 100644 drivers/scsi/elx/efct/efct_driver.h
 create mode 100644 drivers/scsi/elx/efct/efct_hw.c
 create mode 100644 drivers/scsi/elx/efct/efct_hw.h
 create mode 100644 drivers/scsi/elx/efct/efct_hw_queues.c
 create mode 100644 drivers/scsi/elx/efct/efct_io.c
 create mode 100644 drivers/scsi/elx/efct/efct_io.h
 create mode 100644 drivers/scsi/elx/efct/efct_lio.c
 create mode 100644 drivers/scsi/elx/efct/efct_lio.h
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.c
 create mode 100644 drivers/scsi/elx/efct/efct_scsi.h
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.c
 create mode 100644 drivers/scsi/elx/efct/efct_unsol.h
 create mode 100644 drivers/scsi/elx/efct/efct_xport.c
 create mode 100644 drivers/scsi/elx/efct/efct_xport.h
 create mode 100644 drivers/scsi/elx/include/efc_common.h
 create mode 100644 drivers/scsi/elx/libefc/efc.h
 create mode 100644 drivers/scsi/elx/libefc/efc_cmds.c
 create mode 100644 drivers/scsi/elx/libefc/efc_cmds.h
 create mode 100644 drivers/scsi/elx/libefc/efc_device.c
 create mode 100644 drivers/scsi/elx/libefc/efc_device.h
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.c
 create mode 100644 drivers/scsi/elx/libefc/efc_domain.h
 create mode 100644 drivers/scsi/elx/libefc/efc_els.c
 create mode 100644 drivers/scsi/elx/libefc/efc_els.h
 create mode 100644 drivers/scsi/elx/libefc/efc_fabric.c
 create mode 100644 drivers/scsi/elx/libefc/efc_fabric.h
 create mode 100644 drivers/scsi/elx/libefc/efc_node.c
 create mode 100644 drivers/scsi/elx/libefc/efc_node.h
 create mode 100644 drivers/scsi/elx/libefc/efc_nport.c
 create mode 100644 drivers/scsi/elx/libefc/efc_nport.h
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
 create mode 100644 drivers/scsi/elx/libefc/efc_sm.h
 create mode 100644 drivers/scsi/elx/libefc/efclib.c
 create mode 100644 drivers/scsi/elx/libefc/efclib.h
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.c
 create mode 100644 drivers/scsi/elx/libefc_sli/sli4.h
 create mode 100644 drivers/scsi/mpi3mr/Kconfig
 create mode 100644 drivers/scsi/mpi3mr/Makefile
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_image.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_init.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_sas.h
 create mode 100644 drivers/scsi/mpi3mr/mpi/mpi30_transport.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_debug.h
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_fw.c
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_os.c
 create mode 100644 include/scsi/scsi_status.h

James


