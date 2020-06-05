Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E4BC433E1
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 04:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85F2E2086A
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 04:55:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="WmTfaVfm";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="WmTfaVfm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgFEEz1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 00:55:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47172 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbgFEEz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 00:55:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C03EE8EE17B;
        Thu,  4 Jun 2020 21:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1591332926;
        bh=i6ESkRro23dtw0pO1gxTG4nWHRsBncVLQs5C1I4mQ8E=;
        h=Subject:From:To:Cc:Date:From;
        b=WmTfaVfmDNYLFlCeFIM9LUVRCQQAw4VardqRWF0KCwK7DuvswzgxjvgSRrOMdz4Wp
         F5x6L6i8O0c3NPQSDRItVGFJbsTRb4tSYb7nvQCr8DwtEDFUEc6pd3cL/hBVjjZCDg
         iFlQNZ9Da03+Bwy/UiaLXDandmpZ+xeQoJUPhS6Y=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1DQmJMB91fKy; Thu,  4 Jun 2020 21:55:26 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 36ED18EE10C;
        Thu,  4 Jun 2020 21:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1591332926;
        bh=i6ESkRro23dtw0pO1gxTG4nWHRsBncVLQs5C1I4mQ8E=;
        h=Subject:From:To:Cc:Date:From;
        b=WmTfaVfmDNYLFlCeFIM9LUVRCQQAw4VardqRWF0KCwK7DuvswzgxjvgSRrOMdz4Wp
         F5x6L6i8O0c3NPQSDRItVGFJbsTRb4tSYb7nvQCr8DwtEDFUEc6pd3cL/hBVjjZCDg
         iFlQNZ9Da03+Bwy/UiaLXDandmpZ+xeQoJUPhS6Y=
Message-ID: <1591332925.3685.16.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.6+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 04 Jun 2020 21:55:25 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series consists of the usual driver updates (qla2xxx, ufs, zfcp,
target, scsi_debug, lpfc, qedi, qedf, hisi_sas, mpt3sas) plus a host of
other minor updates.  There are no major core changes in this series
apart from a refactoring in scsi_lib.c.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alex Dewar (2):
      scsi: aic7xxx: Remove unnecessary NULL checks before kfree
      scsi: aic7xxx: Use kzalloc() instead of kmalloc()+memset()

André Almeida (1):
      scsi: core: doc: Change function comments to kernel-doc style

Arun Easi (1):
      scsi: qla2xxx: Fix MPI failure AEN (8200) handling

Asutosh Das (4):
      scsi: ufs-qcom: Configure write booster type
      scsi: ufs: sysfs: Add sysfs entries for write booster
      scsi: ufs: Add write booster feature support
      scsi: ufs: full reinit upon resume if link was off

Bart Van Assche (20):
      scsi: qla2xxx: Remove an unused function
      scsi: qla2xxx: Fix endianness annotations in source files
      scsi: qla2xxx: Fix endianness annotations in header files
      scsi: qla2xxx: Use make_handle() instead of open-coding it
      scsi: qla2xxx: Cast explicitly to uint16_t / uint32_t
      scsi: qla2xxx: Change {RD,WRT}_REG_*() function names from upper case into lower case
      scsi: qla2xxx: Fix the code that reads from mailbox registers
      scsi: qla2xxx: Use register names instead of register offsets
      scsi: qla2xxx: Change two hardcoded constants into offsetof() / sizeof() expressions
      scsi: qla2xxx: Increase the size of struct qla_fcp_prio_cfg to FCP_PRIO_CFG_SIZE
      scsi: qla2xxx: Make a gap in struct qla2xxx_offld_chain explicit
      scsi: qla2xxx: Add more BUILD_BUG_ON() statements
      scsi: qla2xxx: Sort BUILD_BUG_ON() statements alphabetically
      scsi: qla2xxx: Simplify the functions for dumping firmware
      scsi: qla2xxx: Suppress two recently introduced compiler warnings
      scsi: qla2xxx: Fix spelling of a variable name
      scsi: ufs: Make ufshcd_wait_for_register() sleep instead of busy-waiting
      scsi: sr: Use {get,put}_unaligned_be*() instead of open-coding these functions
      scsi: qla2xxx: Use ARRAY_SIZE() instead of open-coding it
      scsi: qla2xxx: Split qla2x00_configure_local_loop()

Benjamin Block (8):
      scsi: zfcp: Move allocation of the shost object to after xconf- and xport-data
      scsi: zfcp: Fence early sysfs interfaces for accesses of shost objects
      scsi: zfcp: Fence adapter status propagation for common statuses
      scsi: zfcp: Move p-t-p port allocation to after xport data
      scsi: zfcp: Fence fc_host updates during link-down handling
      scsi: zfcp: Move fc_host updates during xport data handling into fenced function
      scsi: zfcp: Move shost updates during xconfig data handling into fenced function
      scsi: zfcp: Move shost modification after QDIO (re-)open into fenced function

Bob Liu (1):
      scsi: iscsi: Register sysfs for iscsi workqueue

Bodo Stroesser (6):
      scsi: target: tcmu: Userspace must not complete queued commands
      scsi: target: loopback: Fix READ with data and sensebytes
      scsi: target: tcmu: Make pgr_support and alua_support attributes writable
      scsi: target: Make transport_flags per device
      scsi: target: tcmu: Add attributes enforce_pr_isids and force_pr_aptpl
      scsi: target: Add missing emulate_pr attribute to passthrough backends

Chad Dupuis (2):
      scsi: qedf: Fix crash when MFW calls for protocol stats while function is still probing
      scsi: qedf: Add schedule recovery handler

Chandrakanth Patil (1):
      scsi: megaraid_sas: Update driver version to 07.714.04.00-rc1

Chen Tao (1):
      scsi: ibmvscsi: Make some functions static

ChenTao (1):
      scsi: ufs-mediatek: Make ufs_mtk_fixup_dev_quirks static

Christoph Hellwig (1):
      scsi: mpt3sas: Don't change the DMA coherent mask after allocations

Christophe JAILLET (1):
      scsi: aacraid: Fix error handling paths in aac_probe_one()

Colin Ian King (2):
      scsi: lpfc: Remove redundant initialization to variable rc
      scsi: qla2xxx: make 1-bit bit-fields unsigned int

Damien Le Moal (7):
      scsi: sd: Add zoned capabilities device attribute
      scsi: sd: Signal drive managed SMR disks
      scsi: scsi_debug: Disallow zone sizes that are not powers of 2
      scsi: scsi_debug: Implement ZBC host-aware emulation
      scsi: scsi_debug: Add zone_size_mb module parameter
      scsi: scsi_debug: Add zone_nr_conv module parameter
      scsi: scsi_debug: Add zone_max_open module parameter

Dan Carpenter (5):
      scsi: cxgb3i: Fix some leaks in init_act_open()
      scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
      scsi: aacraid: Fix an oops in error handling
      scsi: scsi_debug: Fix an error handling bug in sdeb_zbc_model_str()
      scsi: qedi: Check for buffer overflow in qedi_set_path()

Daniel Wagner (2):
      scsi: qla2xxx: Remove return value from qla_nvme_ls()
      scsi: qedf: Simplify mutex_unlock() usage

Dick Kennedy (8):
      scsi: lpfc: Update lpfc version to 12.8.0.1
      scsi: lpfc: Fix MDS Diagnostic Enablement definition
      scsi: lpfc: Fix noderef and address space warnings
      scsi: lpfc: Remove unnecessary lockdep_assert_held calls
      scsi: lpfc: Change default queue allocation for reduced memory consumption
      scsi: lpfc: Fix negation of else clause in lpfc_prep_node_fc4type
      scsi: lpfc: Remove re-binding of nvme rport during registration
      scsi: lpfc: Maintain atomic consistency of queue_claimed flag

Douglas Gilbert (12):
      scsi: scsi_debug: Parser tables and code interaction
      scsi: scsi_debug: Add ZBC module parameter
      scsi: scsi_debug: Add ZBC zone commands
      scsi: scsi_debug: Add ZBC mode and VPD pages
      scsi: scsi_debug: Bump to version 1.89
      scsi: scsi_debug: Re-arrange parameters alphabetically
      scsi: scsi_debug: Implement PRE-FETCH commands
      scsi: scsi_debug: Improve command duration calculation
      scsi: scsi_debug: Weaken rwlock around ramdisk access
      scsi: scsi_debug: Implement VERIFY(10), add VERIFY(16)
      scsi: scsi_debug: Add per_host_store option
      scsi: scsi_debug: Randomize command completion time

Gabriel Krisman Bertazi (1):
      scsi: iscsi: Fix deadlock on recovery path during GFP_IO reclaim

Gustavo A. R. Silva (2):
      scsi: ufs: Replace zero-length array with flexible-array
      scsi: libsas: Replace zero-length array with flexible-array

Hannes Reinecke (1):
      scsi: core: Remove 'list' entry from struct scsi_cmnd

James Smart (1):
      scsi: lpfc: remove duplicate unloading checks

Jason Yan (45):
      scsi: hisi_sas: Display proc_name in sysfs
      scsi: bfa: Make bfad_iocmd_ioc_get_stats() static
      scsi: mpt3sas: Use true, false for ioc->use_32bit_dma
      scsi: vmw_pvscsi: Use true, false for adapter->use_msg
      scsi: fnic: Use true, false for fnic->internal_reset_inprogress
      scsi: qedi: Remove comparison of 0/1 to bool variable
      scsi: qla2xxx: Make qlafx00_process_aen() return void
      scsi: qla2xxx: Use true, false for ha->fw_dumped
      scsi: qla2xxx: Use true, false for need_mpi_reset
      scsi: qla2xxx: Make qla_set_ini_mode() return void
      scsi: ufs: Use true for bool variables in ufshcd_complete_dev_init()
      scsi: sgiwd93: Remove unneeded semicolon in sgiwd93.c
      scsi: qla4xxx: Remove unneeded semicolon in ql4_os.c
      scsi: isci: Use true, false for bool variables
      scsi: bnx2fc: Remove unneeded semicolon in bnx2fc_fcoe.c
      scsi: bfa: Remove unneeded semicolon in bfa_fcs_rport.c
      scsi: snic: Make snic_io_exch_ver_cmpl_handler() return void
      scsi: mpt3sas: Remove NULL check before freeing function
      scsi: ipr: Remove NULL check before freeing function
      scsi: bfa: Remove unneeded semicolon in bfa_fcs_lport_ns_sm_online()
      scsi: BusLogic: Remove conversion to bool in blogic_inquiry()
      scsi: megaraid: Use true, false for bool variables
      scsi: mpt3sas: use true,false for bool variables
      scsi: fcoe: remove unneeded semicolon in fcoe.c
      scsi: ufs-qcom: remove unneeded variable 'ret'
      scsi: st: remove unneeded variable 'result' in st_release()
      scsi: mvsas: remove unused symbol 'mvs_th'
      scsi: mvsas: make mvst_host_attrs static
      scsi: qedi: make qedi_ll2_buf_size static
      scsi: fnic: make vnic_wq_get_ctrl and vnic_wq_alloc_ring static
      scsi: fnic: make fnic_list and fnic_list_lock static
      scsi: fnic: make some symbols static
      scsi: ipr: remove unneeded semicolon
      scsi: qla1280: make qla1280_firmware_mutex and qla1280_fw_tbl static
      scsi: megaraid: make two symbols static in megaraid_sas_base.c
      scsi: megaraid: make some symbols static in megaraid_sas_fusion.c
      scsi: megaraid: make some symbols static in megaraid_sas_fp.c
      scsi: megaraid: make two symbols static in megaraid_mbox.c
      scsi: bfa: bfad.c: make max_rport_logins static
      scsi: bfa: bfad_attr.c: make two funcitons static
      scsi: bfa: bfa_ioc_ct.c: make two funcitons static
      scsi: bfa: bfa_fcs_lport.c: make bfa_fcport_get_loop_attr() static
      scsi: bfa: bfa_fcpim.c: make two functions static
      scsi: bfa: bfa_core.c: make bfa_isr_rspq() static
      scsi: bfa: bfa_svc.c: make two functions static

Javed Hasan (3):
      scsi: qedf: Honor status qualifier in FCP_RSP per spec
      scsi: qedf: Acquire rport_lock for resetting the delay_timestamp
      scsi: qedf: Increase the upper limit of retry delay

Jeffrey Hugo (1):
      scsi: ufs-qcom: Fix scheduling while atomic issue

Johannes Thumshirn (1):
      scsi: core: free sgtables in case command setup fails

John Garry (1):
      scsi: hisi_sas: Stop returning error code from slot_complete_vX_hw()

Jules Irenge (2):
      scsi: bnx2fc: Add missing annotation for bnx2fc_abts_cleanup()
      scsi: libsas: Add missing annotation for sas_ata_qc_issue()

Kashyap Desai (1):
      scsi: megaraid_sas: Limit device queue depth to controller queue depth

Lance Digby (1):
      scsi: target: core: Add initiatorname to NON_EXISTENT_LUN error

Luo Jiaxing (3):
      scsi: hisi_sas: Add SAS_RAS_INTR0 to debugfs register name list
      scsi: hisi_sas: Modify the commit information for DSM method
      scsi: hisi_sas: Do not reset phy timer to wait for stray phy up

Manish Rangankar (4):
      scsi: qedi: Add modules param to enable qed iSCSI debug
      scsi: qedi: Use correct msix count for fastpath vectors
      scsi: qedi: Avoid unnecessary endpoint allocation on link down
      scsi: qedi: Remove additional char from boot target iqnname

Maurizio Lombardi (1):
      scsi: target: iscsi: Remove the iscsi_data_count structure

Mauro Carvalho Chehab (1):
      scsi: docs: fusion: get rid of a doc build warning

Ming Lei (1):
      scsi: core: Avoid calling synchronize_rcu() for each device in scsi_host_block()

Nilesh Javali (2):
      scsi: qedi: Fix termination timeouts in session logout
      scsi: qedi: Do not flush offload work if ARP not resolved

Samuel Zou (1):
      scsi: mpt3sas: Remove unused including <linux/version.h>

Saurav Kashyap (3):
      scsi: qedf: Get dev info after updating the params
      scsi: qedf: Implement callback for bw_update
      scsi: qedf: Keep track of num of pending flogi

Shivasharan S (1):
      scsi: megaraid_sas: Replace undefined MFI_BIG_ENDIAN macro with __BIG_ENDIAN_BITFIELD macro

Sreekanth Reddy (1):
      scsi: mpt3sas: Disable DIF when prot_mask set to zero

Stanley Chu (15):
      scsi: ufs: Fix WriteBooster flush during runtime suspend
      scsi: ufs: Fix index of attributes query for WriteBooster feature
      scsi: ufs: Allow WriteBooster on UFS 2.2 devices
      scsi: ufs: Remove unnecessary memset for dev_info
      scsi: ufs-mediatek: Customize WriteBooster flush policy
      scsi: ufs: Customize flush threshold for WriteBooster
      scsi: ufs: Introduce ufs_hba_variant_params to group customizable parameters
      scsi: ufs: Cleanup WriteBooster feature
      scsi: ufs-mediatek: Enable WriteBooster capability
      scsi: ufs: Add LU Dedicated buffer mode support for WriteBooster
      scsi: ufs: Add "index" in parameter list of ufshcd_query_flag()
      scsi: ufs-mediatek: Add fixup_dev_quirks vops
      scsi: ufs: Export ufs_fixup_device_setup() function
      scsi: ufs: Introduce fixup_dev_quirks vops
      scsi: ufs: Enable WriteBooster on some pre-3.1 UFS devices

Sudarsana Reddy Kalluru (1):
      scsi: qed: Send BW update notifications to the protocol drivers

Sudhakar Panneerselvam (1):
      scsi: vhost: Notify TCM about the maximum sg entries supported per command

Suganath Prabu (6):
      scsi: mpt3sas: Update maintainers
      scsi: mpt3sas: Capture IOC data for debugging purposes
      scsi: mpt3sas: Update mpt3sas version to 33.101.00.00
      scsi: mpt3sas: Handle RDPQ DMA allocation in same 4G region
      scsi: mpt3sas: Separate out RDPQ allocation to new function
      scsi: mpt3sas: Rename function name is_MSB_are_same

Suganath Prabu S (2):
      scsi: mpt3sas: Fix reply queue count in non RDPQ mode
      scsi: mpt3sas: Fix double free warnings

Sumit Saxena (2):
      scsi: megaraid_sas: TM command refire leads to controller firmware crash
      scsi: megaraid_sas: Remove IO buffer hole detection logic

Viacheslav Dubeyko (3):
      scsi: qla2xxx: Fix issue with adapter's stopping state
      scsi: qla2xxx: Fix failure message in qlt_disable_vha()
      scsi: qla2xxx: Fix warning after FC target reset

Vignesh Raghavendra (1):
      scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtime changes

Wang Hai (1):
      scsi: gdth: Make __gdth_execute static

Wei Yongjun (1):
      scsi: cxlflash: Fix error return code in cxlflash_probe()

Wu Bo (1):
      scsi: pmcraid: Replace dma_pool_malloc with dma_pool_zalloc

Xie XiuQi (1):
      scsi: qedi: Remove unused variable udev & uctrl

Xiongfeng Wang (1):
      scsi: dpt_i2o: Remove always false 'chan < 0' statement

Xiyu Yang (1):
      scsi: lpfc: Fix lpfc_nodelist leak when processing unsolicited event

Xu Wang (1):
      scsi: cxgb4i: Remove superfluous null check

Ye Bin (2):
      scsi: core: Refactor scsi_mq_setup_tags function
      scsi: core: Fix incorrect usage of shost_for_each_device

YueHaibing (1):
      scsi: bfa: Remove set but not used variable 'fchs'

Zou Wei (2):
      scsi: aacraid: Use memdup_user() as a cleanup
      scsi: aacraid: Make some symbols static

And the diffstat:

 MAINTAINERS                                 |    2 +-
 drivers/message/fusion/mptbase.c            |    8 +-
 drivers/net/ethernet/qlogic/qed/qed.h       |    1 +
 drivers/net/ethernet/qlogic/qed/qed_main.c  |    9 +
 drivers/s390/scsi/zfcp_aux.c                |    5 +-
 drivers/s390/scsi/zfcp_diag.h               |    6 +-
 drivers/s390/scsi/zfcp_erp.c                |   84 +-
 drivers/s390/scsi/zfcp_ext.h                |   11 +
 drivers/s390/scsi/zfcp_fsf.c                |   76 +-
 drivers/s390/scsi/zfcp_qdio.c               |   19 +-
 drivers/s390/scsi/zfcp_scsi.c               |  131 +-
 drivers/s390/scsi/zfcp_sysfs.c              |   16 +-
 drivers/scsi/BusLogic.c                     |    2 +-
 drivers/scsi/aacraid/aachba.c               |    1 -
 drivers/scsi/aacraid/commctrl.c             |   13 +-
 drivers/scsi/aacraid/commsup.c              |    4 +-
 drivers/scsi/aacraid/linit.c                |   16 +-
 drivers/scsi/aic7xxx/aic79xx_core.c         |   18 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c         |   19 +-
 drivers/scsi/aic94xx/aic94xx_sds.c          |   14 +-
 drivers/scsi/bfa/bfa_core.c                 |    2 +-
 drivers/scsi/bfa/bfa_fcpim.c                |    4 +-
 drivers/scsi/bfa/bfa_fcs_lport.c            |    4 +-
 drivers/scsi/bfa/bfa_fcs_rport.c            |    4 +-
 drivers/scsi/bfa/bfa_ioc_ct.c               |    4 +-
 drivers/scsi/bfa/bfa_svc.c                  |    7 +-
 drivers/scsi/bfa/bfad.c                     |    2 +-
 drivers/scsi/bfa/bfad_attr.c                |    4 +-
 drivers/scsi/bfa/bfad_bsg.c                 |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |    4 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c             |    1 +
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c          |   18 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c          |    7 +-
 drivers/scsi/cxlflash/main.c                |    1 +
 drivers/scsi/dpt_i2o.c                      |    2 +-
 drivers/scsi/fcoe/fcoe.c                    |    4 +-
 drivers/scsi/fnic/fnic_main.c               |    4 +-
 drivers/scsi/fnic/fnic_scsi.c               |    6 +-
 drivers/scsi/fnic/vnic_dev.c                |   12 +-
 drivers/scsi/fnic/vnic_wq.c                 |    4 +-
 drivers/scsi/gdth.c                         |    4 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c       |    5 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c      |   13 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |   17 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |   26 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            |    4 +-
 drivers/scsi/ipr.c                          |    5 +-
 drivers/scsi/isci/isci.h                    |    6 +-
 drivers/scsi/libiscsi.c                     |    4 +-
 drivers/scsi/libsas/sas_ata.c               |    1 +
 drivers/scsi/lpfc/lpfc.h                    |   23 +-
 drivers/scsi/lpfc/lpfc_attr.c               |  108 +-
 drivers/scsi/lpfc/lpfc_ct.c                 |    1 -
 drivers/scsi/lpfc/lpfc_debugfs.c            |    3 +-
 drivers/scsi/lpfc/lpfc_els.c                |   12 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |    8 +-
 drivers/scsi/lpfc/lpfc_hw4.h                |    2 +-
 drivers/scsi/lpfc/lpfc_init.c               |   82 +-
 drivers/scsi/lpfc/lpfc_mbox.c               |    3 +-
 drivers/scsi/lpfc/lpfc_nvme.c               |   37 -
 drivers/scsi/lpfc/lpfc_nvmet.c              |   11 -
 drivers/scsi/lpfc/lpfc_sli.c                |   45 +-
 drivers/scsi/lpfc/lpfc_sli4.h               |    2 +-
 drivers/scsi/lpfc/lpfc_version.h            |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c       |    6 +-
 drivers/scsi/megaraid/megaraid_sas.h        |    8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   10 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c     |   12 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   81 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    6 +-
 drivers/scsi/mpt3sas/Makefile               |    3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  266 ++--
 drivers/scsi/mpt3sas/mpt3sas_base.h         |   21 +-
 drivers/scsi/mpt3sas/mpt3sas_debugfs.c      |  157 ++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |    8 +-
 drivers/scsi/mvsas/mv_init.c                |    6 +-
 drivers/scsi/pmcraid.c                      |    4 +-
 drivers/scsi/qedf/qedf.h                    |    6 +-
 drivers/scsi/qedf/qedf_els.c                |   10 +-
 drivers/scsi/qedf/qedf_io.c                 |   48 +-
 drivers/scsi/qedf/qedf_main.c               |  135 +-
 drivers/scsi/qedi/qedi_iscsi.c              |   21 +-
 drivers/scsi/qedi/qedi_main.c               |   22 +-
 drivers/scsi/qla1280.c                      |    4 +-
 drivers/scsi/qla2xxx/qla_attr.c             |   40 +-
 drivers/scsi/qla2xxx/qla_bsg.c              |    8 +-
 drivers/scsi/qla2xxx/qla_dbg.c              |  866 +++++------
 drivers/scsi/qla2xxx/qla_dbg.h              |  443 +++---
 drivers/scsi/qla2xxx/qla_def.h              |  728 +++++-----
 drivers/scsi/qla2xxx/qla_fw.h               |  768 +++++-----
 drivers/scsi/qla2xxx/qla_gbl.h              |   26 +-
 drivers/scsi/qla2xxx/qla_init.c             |  380 ++---
 drivers/scsi/qla2xxx/qla_inline.h           |    8 +-
 drivers/scsi/qla2xxx/qla_iocb.c             |  140 +-
 drivers/scsi/qla2xxx/qla_isr.c              |  287 ++--
 drivers/scsi/qla2xxx/qla_mbx.c              |  123 +-
 drivers/scsi/qla2xxx/qla_mid.c              |    4 +-
 drivers/scsi/qla2xxx/qla_mr.c               |  120 +-
 drivers/scsi/qla2xxx/qla_mr.h               |   32 +-
 drivers/scsi/qla2xxx/qla_nvme.c             |   16 +-
 drivers/scsi/qla2xxx/qla_nvme.h             |   64 +-
 drivers/scsi/qla2xxx/qla_nx.c               |  208 ++-
 drivers/scsi/qla2xxx/qla_nx.h               |   36 +-
 drivers/scsi/qla2xxx/qla_nx2.c              |   26 +-
 drivers/scsi/qla2xxx/qla_os.c               |  133 +-
 drivers/scsi/qla2xxx/qla_sup.c              |  323 +++--
 drivers/scsi/qla2xxx/qla_target.c           |  111 +-
 drivers/scsi/qla2xxx/qla_target.h           |  232 +--
 drivers/scsi/qla2xxx/qla_tmpl.c             |  140 +-
 drivers/scsi/qla2xxx/qla_tmpl.h             |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c          |   16 +
 drivers/scsi/qla4xxx/ql4_os.c               |    2 +-
 drivers/scsi/scsi_debug.c                   | 2072 +++++++++++++++++++++++----
 drivers/scsi/scsi_error.c                   |    2 +
 drivers/scsi/scsi_lib.c                     |  230 ++-
 drivers/scsi/scsi_transport_iscsi.c         |   68 +-
 drivers/scsi/sd.c                           |   19 +
 drivers/scsi/sgiwd93.c                      |    2 +-
 drivers/scsi/snic/snic.h                    |    2 +-
 drivers/scsi/snic/snic_ctl.c                |    5 +-
 drivers/scsi/sr.c                           |   26 +-
 drivers/scsi/st.c                           |    5 +-
 drivers/scsi/ufs/ti-j721e-ufs.c             |   13 +-
 drivers/scsi/ufs/ufs-mediatek.c             |   30 +-
 drivers/scsi/ufs/ufs-qcom.c                 |   10 +-
 drivers/scsi/ufs/ufs-sysfs.c                |   61 +-
 drivers/scsi/ufs/ufs.h                      |   43 +-
 drivers/scsi/ufs/ufs_quirks.h               |    7 +
 drivers/scsi/ufs/ufshcd.c                   |  515 +++++--
 drivers/scsi/ufs/ufshcd.h                   |   45 +-
 drivers/scsi/vmw_pvscsi.c                   |    2 +-
 drivers/target/iscsi/iscsi_target_util.c    |   30 +-
 drivers/target/loopback/tcm_loop.c          |   36 +-
 drivers/target/target_core_alua.c           |   10 +-
 drivers/target/target_core_configfs.c       |   82 +-
 drivers/target/target_core_device.c         |   13 +-
 drivers/target/target_core_pr.c             |    2 +-
 drivers/target/target_core_pscsi.c          |    6 +-
 drivers/target/target_core_tpg.c            |    3 +-
 drivers/target/target_core_transport.c      |    6 +-
 drivers/target/target_core_user.c           |  177 ++-
 drivers/vhost/scsi.c                        |    1 +
 include/linux/qed/qed_if.h                  |    1 +
 include/scsi/sas.h                          |    8 +-
 include/scsi/scsi_cmnd.h                    |    1 -
 include/target/iscsi/iscsi_target_core.h    |   10 -
 include/target/target_core_backend.h        |    4 +-
 include/target/target_core_base.h           |    1 +
 include/trace/events/qla.h                  |    7 +
 149 files changed, 6664 insertions(+), 3982 deletions(-)
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_debugfs.c

James

