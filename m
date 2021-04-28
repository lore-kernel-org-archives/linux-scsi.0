Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A7BC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 23:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BA0361419
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 23:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhD1Xcn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 19:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbhD1Xcn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 19:32:43 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA319C06138B;
        Wed, 28 Apr 2021 16:31:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id A0EAA12806EB;
        Wed, 28 Apr 2021 16:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1619652715;
        bh=WWjzz3nQrilX2IjYauGStCvMCNGvh/YxqBBWa4A5bpM=;
        h=Message-ID:Subject:From:To:Date:From;
        b=wElRyhXvv6t68YrER4N9CpBy8K3rxwLtoomLChwUxj2pexpZZbR/96EheVQyfX3Mz
         hUAuX4q93UNsPKc02nB1h01l6Eb8Q7aQ2vu4QoRaIohteShQu9J0KYqREYC9aXTe5P
         7HnGVGWto0ITWJW2Qv386Qd4e8GFr5cSDJq1Kf5c=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vFFfrwmeBR_H; Wed, 28 Apr 2021 16:31:55 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3897712806D3;
        Wed, 28 Apr 2021 16:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1619652715;
        bh=WWjzz3nQrilX2IjYauGStCvMCNGvh/YxqBBWa4A5bpM=;
        h=Message-ID:Subject:From:To:Date:From;
        b=wElRyhXvv6t68YrER4N9CpBy8K3rxwLtoomLChwUxj2pexpZZbR/96EheVQyfX3Mz
         hUAuX4q93UNsPKc02nB1h01l6Eb8Q7aQ2vu4QoRaIohteShQu9J0KYqREYC9aXTe5P
         7HnGVGWto0ITWJW2Qv386Qd4e8GFr5cSDJq1Kf5c=
Message-ID: <14aef9fe8b29ee43c54a38b777905e9f85a25eb3.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.11+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 28 Apr 2021 16:31:54 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series consists of the usual driver updates (ufs, target, tcmu,
smartpqi, lpfc, zfcp, qla2xxx, mpt3sas, pm80xx).  The major core change
is using a sbitmap instead of an atomic for queue tracking.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (5):
      scsi: ufs: ufs-pci: Add support for Intel LKF
      scsi: ufs: ufs-debugfs: Add user-defined exception event rate limiting
      scsi: ufs: ufs-debugfs: Add user-defined exception_event_mask
      scsi: ufs: Add exception event definitions
      scsi: ufs: Add exception event tracepoint

Alexey Dobriyan (1):
      scsi: qla2xxx: Fix broken #endif placement

Arnd Bergmann (6):
      scsi: fcoe: Fix mismatched fcoe_wwn_from_mac declaration
      scsi: lpfc: Fix gcc -Wstringop-overread warning
      scsi: mvsas: Avoid -Wempty-body warning
      scsi: message: fusion: Avoid -Wempty-body warnings
      scsi: aic94xx: Avoid -Wempty-body warning
      scsi: pm8001: Avoid -Wrestrict warning

Arun Easi (3):
      scsi: qla2xxx: Fix crash in qla2xxx_mqueuecommand()
      scsi: qla2xxx: Add H:C:T info in the log message for fc ports
      scsi: qla2xxx: Fix IOPS drop seen in some adapters

Bart Van Assche (28):
      scsi: target: tcm_fc: Fix a kernel-doc header
      scsi: target: Shorten ALUA error messages
      scsi: target: Fix two format specifiers
      scsi: target: Compare explicitly with SAM_STAT_GOOD
      scsi: sd: Introduce a new local variable in sd_check_events()
      scsi: dc395x: Open-code status_byte(u8) calls
      scsi: 53c700: Open-code status_byte(u8) calls
      scsi: smartpqi: Remove unused functions
      scsi: qla4xxx: Remove an unused function
      scsi: myrs: Remove unused functions
      scsi: myrb: Remove unused functions
      scsi: mpt3sas: Fix two kernel-doc headers
      scsi: fcoe: Suppress a compiler warning
      scsi: libfc: Fix a format specifier
      scsi: aacraid: Remove an unused function
      scsi: core: Introduce enum scsi_disposition
      scsi: core: Modify the scsi_send_eh_cmnd() return value for the SDEV_BLOCK case
      scsi: core: Rename scsi_softirq_done() into scsi_complete()
      scsi: core: Remove an incorrect comment
      scsi: core: Make the scsi_alloc_sgtables() documentation more accurate
      scsi: qla2xxx: Check kzalloc() return value
      scsi: qla2xxx: Always check the return value of qla24xx_get_isp_stats()
      scsi: qla2xxx: Simplify qla8044_minidump_process_control()
      scsi: qla2xxx: Suppress Coverity complaints about dseg_r*
      scsi: qla2xxx: Fix endianness annotations
      scsi: qla2xxx: Constify struct qla_tgt_func_tmpl
      scsi: Revert "qla2xxx: Make sure that aborted commands are freed"
      scsi: sbitmap: Silence a debug kernel warning triggered by sbitmap_put()

Bhaskar Chowdhury (11):
      scsi: lpfc: Fix a typo
      scsi: esp_scsi: Trivial typo fixes
      scsi: bfa: Fix a typo in two places
      scsi: scsi_dh: Fix a typo
      scsi: bnx2fc: Fix a typo
      scsi: mpt3sas: Fix a typo
      scsi: csiostor: Fix a typo
      scsi: fusion: Fix a typo in the file mptbase.h
      scsi: fnic: Rudimentary spelling fixes
      scsi: qla1280: Spelling fixes
      scsi: qla4xxx: Fix a typo

Bodo Stroesser (10):
      scsi: target: tcmu: Make data_pages_per_blk changeable via configfs
      scsi: target: tcmu: Replace block size definitions with new udev members
      scsi: target: tcmu: Remove function tcmu_get_block_page()
      scsi: target: tcmu: Support DATA_BLOCK_SIZE = N * PAGE_SIZE
      scsi: target: tcmu: Prepare for PAGE_SIZE != DATA_BLOCK_SIZE
      scsi: target: tcmu: Adjust names of variables and definitions
      scsi: target: tcmu: Adjust parameter in call to tcmu_blocks_release()
      scsi: target: tcmu: Use GFP_NOIO while handling cmds or holding cmdr_lock
      scsi: target: tcmu: Replace radix_tree with XArray
      scsi: target: tcmu: Replace IDR by XArray

Brian King (1):
      scsi: ibmvfc: Fix invalid state machine BUG_ON()

Caleb Connolly (3):
      scsi: ufs: core: Remove version check
      scsi: ufs: qcom: Use ufshci_version() function
      scsi: ufs: core: Use a function to calculate versions

Can Guo (4):
      scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs
      scsi: ufs: core: Fix task management request completion timeout
      scsi: ufs: Remove redundant checks of !hba in suspend/resume callbacks
      scsi: ufs: Minor adjustments to error handling

Chaitanya Kulkarni (14):
      scsi: target: core: file: Don't duplicate memset(0xff)
      scsi: target: core: pr: Initialize arrays at declaration time
      scsi: target: configfs: Initialize arrays at declaration time
      scsi: target: iscsi: Initialize arrays at declaration time
      scsi: target: iscsi: Remove unused macro PRINT_BUF
      scsi: target: iscsi: Remove unused macro TEXT_LEN
      scsi: target: iscsi: Remove unused macro ISCSI_INST_LAST_FAILURE_TYPE
      scsi: target: core: Remove unused macros NONE and ISPRINT
      scsi: target: core: Get rid of warning in compare_and_write_do_cmp()
      scsi: target: pscsi: Remove unused macro ISPRINT
      scsi: target: pscsi: Fix warning in pscsi_complete_cmd()
      scsi: target: iblock: Fix type of logs_per_phys
      scsi: target: iblock: Trim line longer than 80 characters
      scsi: target: iblock: Remove an extra argument

Christophe JAILLET (2):
      scsi: qla2xxx: Reuse existing error handling path
      scsi: mpt3sas: Do not use GFP_KERNEL in atomic context

Colin Ian King (3):
      scsi: pm80xx: Fix potential infinite loop
      scsi: a100u2w: Remove unused variable biosaddr
      scsi: qedi: Remove redundant assignment to variable err

Dan Carpenter (1):
      scsi: lpfc: Fix some error codes in debugfs

Don Brace (10):
      scsi: smartpqi: Fix device pointer variable reference static checker issue
      scsi: smartpqi: Fix blocks_per_row static checker issue
      scsi: smartpqi: Update version to 2.1.8-045
      scsi: smartpqi: Add host level stream detection enable
      scsi: smartpqi: Add stream detection
      scsi: smartpqi: Add support for RAID1 writes
      scsi: smartpqi: Add support for RAID5 and RAID6 writes
      scsi: smartpqi: Refactor scatterlist code
      scsi: smartpqi: Refactor aio submission code
      scsi: smartpqi: Use host-wide tag space

Douglas Gilbert (2):
      scsi: scsi_debug: Fix cmd duration calculation
      scsi: scsi_debug: Add new defer type for mq_poll

Ewan D. Milne (1):
      scsi: scsi_dh_alua: Remove check for ASC 24h in alua_rtpg()

Gulam Mohamed (1):
      scsi: iscsi: Fix race condition between login and sync thread

Gustavo A. R. Silva (5):
      scsi: mpt3sas: Fix out-of-bounds warnings in _ctl_addnl_diag_query
      scsi: ufs: core: Fix out-of-bounds warnings in ufshcd_exec_raw_upiu_cmd()
      scsi: message: mptlan: Replace one-element array with flexible-array member
      scsi: message: fusion: Replace one-element array with flexible-array member
      scsi: mpt3sas: Replace unnecessary dynamic allocation with a static one

Igor Pylypiv (4):
      scsi: pm80xx: Remove busy wait from mpi_uninit_check()
      scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check()
      scsi: pm80xx: Replace magic numbers with device state defines
      scsi: pm80xx: Remove list entry from pm8001_ccb_info

James Smart (38):
      scsi: lpfc: Copyright updates for 12.8.0.9 patches
      scsi: lpfc: Update lpfc version to 12.8.0.9
      scsi: lpfc: Eliminate use of LPFC_DRIVER_NAME in lpfc_attr.c
      scsi: lpfc: Standardize discovery object logging format
      scsi: lpfc: Fix various trivial errors in comments and log messages
      scsi: lpfc: Remove unsupported mbox PORT_CAPABILITIES logic
      scsi: lpfc: Fix lpfc_hdw_queue attribute being ignored
      scsi: lpfc: Fix missing FDMI registrations after Mgmt Svc login
      scsi: lpfc: Fix silent memory allocation failure in lpfc_sli4_bsg_link_diag_test()
      scsi: lpfc: Fix use-after-free on unused nodes after port swap
      scsi: lpfc: Fix error handling for mailboxes completed in MBX_POLL mode
      scsi: lpfc: Fix lack of device removal on port swaps with PRLIs
      scsi: lpfc: Fix NMI crash during rmmod due to circular hbalock dependency
      scsi: lpfc: Fix reference counting errors in lpfc_cmpl_els_rsp()
      scsi: lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO response
      scsi: lpfc: Fix rmmod crash due to bad ring pointers to abort_iotag
      scsi: lpfc: Update copyrights for 12.8.0.7 and 12.8.0.8 changes
      scsi: lpfc: Update lpfc version to 12.8.0.8
      scsi: lpfc: Correct function header comments related to ndlp reference counting
      scsi: lpfc: Reduce LOG_TRACE_EVENT logging for vports
      scsi: lpfc: Change wording of invalid pci reset log message
      scsi: lpfc: Fix crash caused by switch reboot
      scsi: lpfc: Fix pt2pt state transition causing rmmod hang
      scsi: lpfc: Fix nodeinfo debugfs output
      scsi: lpfc: Fix ADISC handling that never frees nodes
      scsi: lpfc: Fix PLOGI ACC to be transmit after REG_LOGIN
      scsi: lpfc: Fix dropped FLOGI during pt2pt discovery recovery
      scsi: lpfc: Fix status returned in lpfc_els_retry() error exit path
      scsi: lpfc: Fix use after free in lpfc_els_free_iocb
      scsi: lpfc: Fix null pointer dereference in lpfc_prep_els_iocb()
      scsi: lpfc: Fix unnecessary null check in lpfc_release_scsi_buf
      scsi: lpfc: Fix pt2pt connection does not recover after LOGO
      scsi: lpfc: Fix lpfc_els_retry() possible null pointer dereference
      scsi: lpfc: Fix FLOGI failure due to accessing a freed node
      scsi: lpfc: Fix stale node accesses on stale RRQ request
      scsi: lpfc: Fix reftag generation sizing errors
      scsi: lpfc: Fix vport indices in lpfc_find_vport_by_vpid()
      scsi: lpfc: Fix incorrect dbde assignment when building target abts wqe

Javed Hasan (2):
      scsi: qedf: Use devlink to report errors and recovery
      scsi: qedf: Enable devlink support

Jia-Ju Bai (2):
      scsi: mpt3sas: Fix error return code of mpt3sas_base_attach()
      scsi: qedi: Fix error return code of qedi_alloc_global_queues()

Jianqin Xie (1):
      scsi: hisi_sas: Directly snapshot registers when executing a reset

Jiapeng Chong (10):
      scsi: message: fusion: Remove unused local variable 'vtarget'
      scsi: message: fusion: Remove unused local variable 'status'
      scsi: bfa: Fix warning comparing pointer to 0
      scsi: qla1280: Fix warning comparing pointer to 0
      scsi: mac53c94: Fix warning comparing pointer to 0
      scsi: dc395x: Use bitwise instead of arithmetic operator for flags
      scsi: csiostor: Assign boolean values to a bool variable
      scsi: mvumi: Use true and false for bool variable
      scsi: ibmvfc: Switch to using kobj_to_dev()
      scsi: ufs: Convert sysfs sprintf/snprintf family to sysfs_emit

Johannes Thumshirn (1):
      scsi: sd_zbc: Update write pointer offset cache

John Pittman (1):
      scsi: scsi_dh_alua: Prevent duplicate pg info print in alua_rtpg()

Julian Wiedmann (4):
      scsi: zfcp: Lift Request Queue tasklet & timer from qdio
      scsi: zfcp: Clean up sysfs code for SFP diagnostics
      scsi: zfcp: Fix sysfs roll-back on error in zfcp_adapter_enqueue()
      scsi: zfcp: Remove unneeded INIT_LIST_HEAD() for FSF requests

Kashyap Desai (5):
      scsi: core: Set shost as hctx driver_data
      scsi: scsi_debug: mq_poll support
      scsi: megaraid_sas: mq_poll support
      scsi: core: Add mq_poll support to SCSI layer
      scsi: megaraid_sas: Replace sdev_busy with local counter

Kevin Barnett (19):
      scsi: smartpqi: Add new PCI IDs
      scsi: smartpqi: Correct system hangs when resuming from hibernation
      scsi: smartpqi: Add additional logging for LUN resets
      scsi: smartpqi: Convert snprintf() to scnprintf()
      scsi: smartpqi: Fix driver synchronization issues
      scsi: smartpqi: Update device scan operations
      scsi: smartpqi: Update OFA management
      scsi: smartpqi: Update RAID bypass handling
      scsi: smartpqi: Update suspend/resume and shutdown
      scsi: smartpqi: Synchronize device resets with mutex
      scsi: smartpqi: Update soft reset management for OFA
      scsi: smartpqi: Update event handler
      scsi: smartpqi: Add support for wwid
      scsi: smartpqi: Remove timeouts from internal cmds
      scsi: smartpqi: Disable WRITE SAME for HBA NVMe disks
      scsi: smartpqi: Align code with oob driver
      scsi: smartpqi: Add support for long firmware version
      scsi: smartpqi: Add support for BMIC sense feature cmd and feature bits
      scsi: smartpqi: Add support for new product ids

Konstantin Shelekhin (2):
      scsi: target: Make the virtual LUN 0 device
      scsi: target: Add the DUMMY flag to rd_mcp

Lee Duncan (1):
      scsi: fnic: Remove bogus ratelimit messages

Lee Jones (103):
      scsi: ibmvscsi_tgt: Remove duplicate section 'NOTE'
      scsi: ibmvscsi: Fix a bunch of misdocumentation
      scsi: ibmvscsi: Fix a bunch of kernel-doc related issues
      scsi: cxlflash: Fix some misnaming related doc-rot
      scsi: cxlflash: Fix a few misnaming issues
      scsi: cxlflash: Fix a little doc-rot
      scsi: isci: remote_node_table: Provide some missing params and remove others
      scsi: isci: remote_node_context: Demote kernel-doc abuse
      scsi: isci: port: Fix a bunch of kernel-doc issues
      scsi: isci: request: Fix doc-rot issue relating to 'ireq' param
      scsi: isci: remote_device: Fix a bunch of doc-rot issues
      scsi: isci: port_config: Fix a bunch of doc-rot and demote abuses
      scsi: isci: remote_node_context: Fix one function header and demote a couple more
      scsi: isci: remote_node_table: Fix a bunch of kernel-doc misdemeanours
      scsi: isci: task: Demote non-conformant header and remove superfluous param
      scsi: isci: host: Fix bunch of kernel-doc related issues
      scsi: isci: request: Fix a myriad of kernel-doc issues
      scsi: isci: phy: Provide function name and demote non-conforming header
      scsi: isci: phy: Fix a few different kernel-doc related issues
      scsi: fnic: Kernel-doc headers must contain the function name
      scsi: fnic: Demote non-conformant kernel-doc headers
      scsi: be2iscsi: Demote incomplete/non-conformant kernel-doc header
      scsi: mpt3sas: Fix a few kernel-doc issues
      scsi: pmcraid: Correct function name pmcraid_show_adapter_id() in header
      scsi: myrs: Add missing ':' to make the kernel-doc checker happy
      scsi: a100u2w: Fix some misnaming and formatting issues
      scsi: initio: Fix a few kernel-doc misdemeanours
      scsi: dc395x: Fix some function param descriptions
      scsi: be2iscsi: Ensure function follows directly after its header
      scsi: aic94xx: Correct misspelling of function asd_dump_seq_state()
      scsi: sd: Fix function name in header
      scsi: pmcraid: Fix a whole host of kernel-doc issues
      scsi: sd_zbc: Place function name into header
      scsi: mvumi: Fix formatting and doc-rot issues
      scsi: ipr: Fix incorrect function names in their headers
      scsi: myrb: Demote non-conformant kernel-doc headers and fix others
      scsi: nsp32: Correct expected types in debug print formatting
      scsi: isci: Make local function port_state_name() static
      scsi: isci: Make local function isci_remote_device_wait_for_resume_from_abort() static
      scsi: sim710: Remove unused variable 'err' from sim710_init()
      scsi: FlashPoint: Remove unused variable 'TID' from FlashPoint_AbortCCB()
      scsi: nsp32: Remove or exclude unused variables
      scsi: nsp32: Supply __printf(x, y) formatting for nsp32_message()
      scsi: BusLogic: Supply __printf(x, y) formatting for blogic_msg()
      scsi: 3w-sas: Remove unused variables 'sglist' and 'tw_dev'
      scsi: 3w-9xxx: Remove a few set but unused variables
      scsi: 3w-xxxx: Remove 2 unused variables 'response_que_value' and 'tw_dev'
      scsi: myrs: Remove a couple of unused 'status' variables
      scsi: atp870u: Fix naming and demote incorrect and non-conformant kernel-doc header
      scsi: dc395x: Fix incorrect naming in function headers
      scsi: a100u2w: Remove unused variable 'bios_phys'
      scsi: initio: Remove unused variable 'prev'
      scsi: bnx2i: Fix bnx2i_set_ccell_info()'s name in description
      scsi: be2iscsi: Fix beiscsi_phys_port()'s name in header
      scsi: be2iscsi: Provide missing function name in header
      scsi: be2iscsi: Fix incorrect naming of beiscsi_iface_config_vlan()
      scsi: esas2r: Supply __printf(x, y) formatting for esas2r_log_master()
      scsi: cxgbi: cxgb3: Fix misnaming of ddp_setup_conn_digest()
      scsi: ufs: cdns-pltfrm: Supply function names for headers
      scsi: lpfc: Fix kernel-doc formatting issue
      scsi: bfa: Move a large struct from the stack onto the heap
      scsi: lpfc: Fix a few incorrectly named functions
      scsi: lpfc: Fix incorrectly documented function lpfc_debugfs_commonxripools_data()
      scsi: qla2xxx: Fix a couple of misdocumented functions
      scsi: qla2xxx: Fix incorrectly named function qla8044_check_temp()
      scsi: mpt3sas: Fix some kernel-doc misnaming issues
      scsi: qla2xxx: Fix a couple of misnamed functions
      scsi: libfc: Fix misspelling of fc_fcp_destroy()
      scsi: mpt3sas: Fix a couple of misdocumented functions/params
      scsi: libfc: Fix incorrect naming of fc_rport_adisc_resp()
      scsi: lpfc: Fix a bunch of misnamed functions
      scsi: lpfc: Fix a bunch of kernel-doc misdemeanours
      scsi: ufs: core: Fix incorrectly named ufshcd_find_max_sup_active_icc_level()
      scsi: mpt3sas: Fix a bunch of potential naming doc-rot
      scsi: mpt3sas: Move a little data from the stack onto the heap
      scsi: mpt3sas: Fix misspelling of _base_put_smid_default_atomic()
      scsi: lpfc: Fix incorrect naming of __lpfc_update_fcf_record()
      scsi: libfc: Fix some possible copy/paste issues
      scsi: lpfc: Fix formatting and misspelling issues
      scsi: aacraid: Fix misspelling of _aac_rx_init()
      scsi: qla2xxx: Fix some incorrect formatting/spelling issues
      scsi: pm8001: Fix a bunch of doc-rotted function headers
      scsi: aic94xx: Remove code that has been unused for at least 13 years
      scsi: bnx2fc: Fix misnaming of bnx2fc_free_session_resc()
      scsi: qla4xxx: Fix kernel-doc formatting and misnaming issue
      scsi: pm8001: Fix some misnamed function descriptions
      scsi: lpfc: Fix a bunch of kernel-doc issues
      scsi: aacraid: Repair formatting issue in aac_handle_sa_aif()'s header
      scsi: qla2xxx: Replace __qla2x00_marker()'s missing underscores
      scsi: aic94xx: Fix asd_erase_nv_sector()'s header
      scsi: pm8001: Fix incorrectly named functions in headers
      scsi: qla4xxx: Fix formatting issues - missing '-' and '_'
      scsi: pm8001: Provide function name 'pm8001_I_T_nexus_reset()' in header
      scsi: bnx2fc: Fix typo in bnx2fc_indicate_kcqe()
      scsi: aacraid: Fix incorrect spelling of aac_send_raw_srb()
      scsi: pm8001: Provide function name and fix a misspelling
      scsi: aacraid: Fix a few incorrectly named functions
      scsi: aic94xx: Fix a couple of misnamed function names
      scsi: fcoe: Fix a couple of incorrectly named functions
      scsi: megaraid_mbox: Fix function name megaraid_queue_command_lck() in description
      scsi: fcoe: Fix function name fcoe_set_vport_symbolic_name() in description
      scsi: megaraid_sas: Fix a bunch of misnamed functions in their headers
      scsi: megaraid_mm: Fix incorrect function name in header

Luo Jiaxing (8):
      scsi: hisi_sas: Print SATA device SAS address for soft reset failure
      scsi: hisi_sas: Warn in v3 hw channel interrupt handler when status reg cleared
      scsi: hisi_sas: Print SAS address for v3 hw erroneous completion print
      scsi: hisi_sas: Delete some unused callbacks
      scsi: pm8001: Clean up open braces
      scsi: pm8001: Clean up white space
      scsi: libsas: Clean up whitespace
      scsi: libsas: Correctly indent statements in sas_to_ata_err()

Lv Yunlong (2):
      scsi: st: Fix a use after free in st_open()
      scsi: myrs: Fix a double free in myrs_cleanup()

Martin Wilck (3):
      scsi: scsi_transport_srp: Don't block target in SRP_PORT_LOST state
      scsi: target: pscsi: Clean up after failure in pscsi_map_sg()
      scsi: target: pscsi: Avoid OOM in pscsi_map_sg()

Melanie Plageman (Microsoft) (1):
      scsi: storvsc: Parameterize number hardware queues

Michael Kelley (1):
      scsi: storvsc: Enable scatterlist entry lengths > 4Kbytes

Mike Christie (26):
      scsi: target: Fix htmldocs warning in target_submit_prep()
      scsi: target: core: Make completion affinity configurable
      scsi: target: core: Flush submission work during TMR processing
      scsi: target: tcmu: Add backend plug/unplug callouts
      scsi: target: iblock: Add backend plug/unplug callouts
      scsi: target: core: Fix backend plugging
      scsi: target: core: Cleanup cmd flag bits
      scsi: target: tcm_loop: Use LIO wq cmd submission helper
      scsi: target: tcm_loop: Use block cmd allocator for se_cmds
      scsi: target: vhost-scsi: Use LIO wq cmd submission helper
      scsi: target: core: Add workqueue based cmd submission
      scsi: target: core: Add gfp_t arg to target_cmd_init_cdb()
      scsi: target: core: Remove target_submit_cmd_map_sgls()
      scsi: target: tcm_fc: Convert to new submission API
      scsi: target: xen-scsiback: Convert to new submission API
      scsi: target: vhost-scsi: Convert to new submission API
      scsi: target: usb: gadget: Convert to new submission API
      scsi: target: sbp_target: Convert to new submission API
      scsi: target: tcm_loop: Convert to new submission API
      scsi: target: qla2xxx: Convert to new submission API
      scsi: target: ibmvscsi_tgt: Convert to new submission API
      scsi: target: srpt: Convert to new submission API
      scsi: target: core: Break up target_submit_cmd_map_sgls()
      scsi: target: core: Rename transport_init_se_cmd()
      scsi: target: core: Drop kref_get_unless_zero() in target_get_sess_cmd()
      scsi: target: core: Move t_task_cdb initialization

Ming Lei (12):
      scsi: core: Replace sdev->device_busy with sbitmap
      scsi: core: Make sure sdev->queue_depth is <= max(shost->can_queue, 1024)
      scsi: core: Add scsi_device_busy() wrapper
      scsi: core: Put hot fields of scsi_host_template in one cacheline
      scsi: blk-mq: Return budget token from .get_budget callback
      scsi: blk-mq: Add callbacks for storing & retrieving budget token
      scsi: sbitmap: Add sbitmap_calculate_shift() helper
      scsi: sbitmap: Export sbitmap_weight
      scsi: sbitmap: Move allocation hint into sbitmap
      scsi: sbitmap: Add helpers for updating allocation hint
      scsi: sbitmap: Maintain allocation round_robin in sbitmap
      scsi: sbitmap: Remove sbitmap_clear_bit_unlock

Murthy Bhat (4):
      scsi: smartpqi: Update enclosure identifier in sysfs
      scsi: smartpqi: Update SAS initiator_port_protocols and target_port_protocols
      scsi: smartpqi: Add phy ID support for the physical drives
      scsi: smartpqi: Correct request leakage during reset operations

Nilesh Javali (1):
      scsi: qla2xxx: Update version to 10.02.00.106-k

Nitin Rawat (1):
      scsi: ufs: ufs-qcom: Disable interrupt in reset path

Qiheng Lin (2):
      scsi: qla4xxx: Remove unneeded if-null-free check
      scsi: qla2xxx: Remove unneeded if-null-free check

Qinglang Miao (1):
      scsi: zfcp: Move the position of put_device()

Quinn Tran (8):
      scsi: qla2xxx: Do logout even if fabric scan retries got exhausted
      scsi: qla2xxx: Update default AER debug mask
      scsi: qla2xxx: Fix mailbox recovery during PCIe error
      scsi: qla2xxx: Fix crash in PCIe error handling
      scsi: qla2xxx: Fix RISC RESET completion polling
      scsi: qla2xxx: Fix use after free in bsg
      scsi: qla2xxx: Consolidate zio threshold setting for both FCP & NVMe
      scsi: qla2xxx: Fix stuck session

Rasmus Villemoes (1):
      scsi: bnx2i: Make bnx2i_process_iscsi_error() simpler and more robust

Roman Bolshakov (2):
      scsi: qla2xxx: Reserve extra IRQ vectors
      scsi: target: iscsi: Fix zero tag inside a trace event

Ruksar Devadi (1):
      scsi: pm80xx: Completing pending I/O after fatal error

Sergei Trofimovich (3):
      scsi: hpsa: Add an assert to prevent __packed reintroduction
      scsi: hpsa: Fix boot on ia64 (atomic_t alignment)
      scsi: hpsa: Use __packed on individual structs, not header-wide

Sergey Shtylyov (5):
      scsi: sni_53c710: Add IRQ check
      scsi: sun3x_esp: Add IRQ check
      scsi: jazz_esp: Add IRQ check
      scsi: hisi_sas: Fix IRQ checks
      scsi: ufs: ufshcd-pltfrm: Fix deferred probing

Shixin Liu (2):
      scsi: myrs: Make symbols DAC960_{GEM/BA/LP}_privdata static
      scsi: myrb: Make symbols DAC960_{LA/PG/PD/P}_privdata static

Sreekanth Reddy (3):
      scsi: mpt3sas: Block PCI config access from userspace during reset
      scsi: mpt3sas: Fix endianness for ActiveCablePowerRequirement
      scsi: mpt3sas: Only one vSES is present even when IOC has multi vSES

Suganath Prabu S (7):
      scsi: mpt3sas: Update driver version to 37.101.00.00
      scsi: mpt3sas: Force reply post array allocations to be within same 4 GB region
      scsi: mpt3sas: Force reply post buffer allocations to be within same 4 GB region
      scsi: mpt3sas: Force reply buffer allocations to be within same 4 GB region
      scsi: mpt3sas: Force sense buffer allocations to be within same 4 GB region
      scsi: mpt3sas: Force chain buffer allocations to be within same 4 GB region
      scsi: mpt3sas: Force PCIe scatterlist allocations to be within same 4 GB region

Tian Tao (1):
      scsi: qedf: Remove unused include of linux/version.h

Tyrel Datwyler (8):
      scsi: ibmvfc: Make ibmvfc_wait_for_ops() MQ aware
      scsi: ibmvfc: Fix potential race in ibmvfc_wait_for_ops()
      scsi: ibmvfc: Free channel_setup_buf during device tear down
      scsi: ibmvfc: Reinitialize sub-CRQs and perform channel enquiry after LPM
      scsi: ibmvfc: Store return code of H_FREE_SUB_CRQ during cleanup
      scsi: ibmvfc: Treat H_CLOSED as success during sub-CRQ registration
      scsi: ibmvfc: Fix invalid sub-CRQ handles after hard reset
      scsi: ibmvfc: Simplify handling of sub-CRQ initialization

Vinod Koul (1):
      scsi: ufs: dt-bindings: Add sm8250, sm8350 compatible strings

Vishakha Channapattan (5):
      scsi: pm80xx: Add sysfs attribute to track iop1 count
      scsi: pm80xx: Add sysfs attribute to track iop0 count
      scsi: pm80xx: Add sysfs attribute to track RAAE count
      scsi: pm80xx: Add sysfs attribute to check controller hmi error
      scsi: pm80xx: Add sysfs attribute to check MPI state

Vishal Bhakta (1):
      scsi: vmw_pvscsi: MAINTAINERS: Update maintainer

Viswas G (3):
      scsi: pm80xx: Remove global lock from outbound queue processing
      scsi: pm80xx: Reset PI and CI memory during re-initialization
      scsi: pm80xx: Fix chip initialization failure

Wan Jiabing (4):
      scsi: isci: Remove unnecessary struct declaration
      scsi: bfa: Remove unnecessary struct declarations
      scsi: core: scsi_host_cmd_pool is declared twice
      scsi: core: Remove duplicate declarations

Wang Qing (4):
      scsi: ibmvscsi: Remove unnecessary cast
      scsi: fnic: Remove unnecessary cast
      scsi: message: fusion: Remove unnecessary cast
      scsi: qla2xxx: Use dma_pool_zalloc()

Xiang Chen (1):
      scsi: hisi_sas: Call sas_unregister_ha() to roll back if .hw_init() fails

Yang Li (1):
      scsi: 3w-sas: Remove unneeded variable 'retval'

Yang Yingliang (1):
      scsi: fnic: Remove unnecessary spin_lock_init() and INIT_LIST_HEAD()

Ye Bin (1):
      scsi: ufs: ufs-qcom: Remove redundant dev_err() call in ufs_qcom_init()

Yevhen Viktorov (1):
      scsi: zfcp: Fix indentation coding style issue

Yue Hu (5):
      scsi: ufs: Remove unnecessary NULL checks in ufshcd_find_max_sup_active_icc_level()
      scsi: ufs: ufs-exynos: Remove pwr_max from parameter list of exynos_ufs_post_pwr_mode()
      scsi: ufs: core: Correct status type in ufshcd_vops_pwr_change_notify()
      scsi: ufs: core: Tidy up WB configuration code
      scsi: ufs: core: Remove unnecessary ret in ufshcd_populate_vreg()

Zhang Yunkai (1):
      scsi: ufs: Remove duplicate include in ufshcd

Zhen Lei (2):
      scsi: message: fusion: Remove unused local variable 'port'
      scsi: message: fusion: Remove unused local variable 'time_count'

dingsenjie (1):
      scsi: snic: Convert to DEFINE_SHOW_ATTRIBUTE()

dongjian (1):
      scsi: ufs: ufs-mediatek: Correct operator & -> &&

dudengke (1):
      scsi: core: Fix comment typo

ganjisheng (2):
      scsi: advansys: Fix spelling of 'is'
      scsi: 53c700: Fix spelling of conditions

wengjianfeng (1):
      scsi: lpfc: Fix a typo

zhouchuangao (1):
      scsi: message: fusion: Use BUG_ON instead of if condition followed by BUG

zuoqilin (1):
      scsi: FlashPoint: Fix typo

And the diffstat:

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |    2 +
 MAINTAINERS                                        |    2 +-
 block/blk-mq-sched.c                               |   17 +-
 block/blk-mq.c                                     |   38 +-
 block/blk-mq.h                                     |   25 +-
 block/kyber-iosched.c                              |    3 +-
 drivers/ata/libata-eh.c                            |    2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   14 +-
 drivers/message/fusion/lsi/mpi.h                   |    4 +-
 drivers/message/fusion/lsi/mpi_ioc.h               |    2 +-
 drivers/message/fusion/mptbase.c                   |    9 +-
 drivers/message/fusion/mptbase.h                   |    2 +-
 drivers/message/fusion/mptctl.c                    |    8 -
 drivers/message/fusion/mptdebug.h                  |    7 +-
 drivers/message/fusion/mptlan.c                    |    9 +-
 drivers/message/fusion/mptsas.c                    |   10 +-
 drivers/s390/scsi/zfcp_aux.c                       |   28 +-
 drivers/s390/scsi/zfcp_def.h                       |    6 +-
 drivers/s390/scsi/zfcp_diag.c                      |   42 -
 drivers/s390/scsi/zfcp_diag.h                      |    7 -
 drivers/s390/scsi/zfcp_ext.h                       |    4 +-
 drivers/s390/scsi/zfcp_fsf.c                       |    1 -
 drivers/s390/scsi/zfcp_qdio.c                      |   68 +-
 drivers/s390/scsi/zfcp_qdio.h                      |    5 +
 drivers/s390/scsi/zfcp_sysfs.c                     |   14 +-
 drivers/s390/scsi/zfcp_unit.c                      |    4 +-
 drivers/scsi/3w-9xxx.c                             |   14 +-
 drivers/scsi/3w-sas.c                              |   13 +-
 drivers/scsi/3w-xxxx.c                             |    6 +-
 drivers/scsi/53c700.c                              |    6 +-
 drivers/scsi/BusLogic.c                            |    2 +-
 drivers/scsi/FlashPoint.c                          |    6 +-
 drivers/scsi/a100u2w.c                             |   13 +-
 drivers/scsi/aacraid/aachba.c                      |   13 +-
 drivers/scsi/aacraid/commctrl.c                    |    2 +-
 drivers/scsi/aacraid/commsup.c                     |    4 +-
 drivers/scsi/aacraid/rx.c                          |    2 +-
 drivers/scsi/advansys.c                            |    2 +-
 drivers/scsi/aic94xx/aic94xx.h                     |    2 +-
 drivers/scsi/aic94xx/aic94xx_dump.c                |  186 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c                 |    4 +-
 drivers/scsi/aic94xx/aic94xx_sds.c                 |    2 +-
 drivers/scsi/atp870u.c                             |    7 +-
 drivers/scsi/be2iscsi/be_iscsi.c                   |    2 +-
 drivers/scsi/be2iscsi/be_main.c                    |    6 +-
 drivers/scsi/be2iscsi/be_mgmt.c                    |    2 +-
 drivers/scsi/bfa/bfa_fc.h                          |    4 +-
 drivers/scsi/bfa/bfa_fcs.h                         |    3 -
 drivers/scsi/bfa/bfa_fcs_lport.c                   |   20 +-
 drivers/scsi/bfa/bfad_bsg.c                        |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c                   |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |   85 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c                   |    2 +-
 drivers/scsi/csiostor/csio_hw_t5.c                 |    2 +-
 drivers/scsi/csiostor/csio_scsi.c                  |    4 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c                 |    2 +-
 drivers/scsi/cxlflash/main.c                       |    8 +-
 drivers/scsi/cxlflash/superpipe.c                  |    6 +-
 drivers/scsi/cxlflash/vlun.c                       |    8 +-
 drivers/scsi/dc395x.c                              |   15 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   39 +-
 drivers/scsi/device_handler/scsi_dh_emc.c          |    4 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c         |    4 +-
 drivers/scsi/esas2r/esas2r_log.c                   |    7 +
 drivers/scsi/esp_scsi.c                            |    4 +-
 drivers/scsi/fcoe/fcoe.c                           |    2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |    4 +-
 drivers/scsi/fcoe/fcoe_transport.c                 |    2 +-
 drivers/scsi/fnic/fnic_debugfs.c                   |    3 +-
 drivers/scsi/fnic/fnic_fcs.c                       |   16 +-
 drivers/scsi/fnic/fnic_main.c                      |    3 -
 drivers/scsi/fnic/fnic_scsi.c                      |    6 +-
 drivers/scsi/fnic/fnic_trace.c                     |   18 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |    3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   38 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |    6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   44 +-
 drivers/scsi/hpsa_cmd.h                            |   78 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  219 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   73 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |   23 +-
 drivers/scsi/initio.c                              |   18 +-
 drivers/scsi/ipr.c                                 |    8 +-
 drivers/scsi/isci/host.c                           |   37 +-
 drivers/scsi/isci/phy.c                            |   34 +-
 drivers/scsi/isci/phy.h                            |    1 -
 drivers/scsi/isci/port.c                           |   62 +-
 drivers/scsi/isci/port_config.c                    |   37 +-
 drivers/scsi/isci/remote_device.c                  |   33 +-
 drivers/scsi/isci/remote_node_context.c            |   13 +-
 drivers/scsi/isci/remote_node_table.c              |   64 +-
 drivers/scsi/isci/request.c                        |   60 +-
 drivers/scsi/isci/task.c                           |    3 +-
 drivers/scsi/jazz_esp.c                            |    4 +-
 drivers/scsi/libfc/fc_fcp.c                        |    2 +-
 drivers/scsi/libfc/fc_lport.c                      |   14 +-
 drivers/scsi/libfc/fc_rport.c                      |    2 +-
 drivers/scsi/libsas/sas_ata.c                      |   74 +-
 drivers/scsi/libsas/sas_discover.c                 |    2 +-
 drivers/scsi/libsas/sas_expander.c                 |   13 +-
 drivers/scsi/lpfc/lpfc.h                           |    3 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  140 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |   28 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   11 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   44 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   25 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |    3 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  755 ++---
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   34 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |  176 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  142 +-
 drivers/scsi/lpfc/lpfc_mbox.c                      |   38 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  282 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   20 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   31 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |  124 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  118 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    6 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |   10 +-
 drivers/scsi/mac53c94.c                            |   13 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |    2 +-
 drivers/scsi/megaraid/megaraid_mm.c                |    2 +-
 drivers/scsi/megaraid/megaraid_sas.h               |    5 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |   98 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   89 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h        |    2 +
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h               |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  522 ++--
 drivers/scsi/mpt3sas/mpt3sas_base.h                |    5 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |   10 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |   45 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h                 |   12 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   67 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |    7 +-
 drivers/scsi/mvsas/mv_sas.h                        |    2 +-
 drivers/scsi/mvumi.c                               |    9 +-
 drivers/scsi/myrb.c                                |  126 +-
 drivers/scsi/myrs.c                                |  119 +-
 drivers/scsi/nsp32.c                               |   31 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |  151 +-
 drivers/scsi/pm8001/pm8001_ctl.h                   |    5 +
 drivers/scsi/pm8001/pm8001_hwi.c                   |  100 +-
 drivers/scsi/pm8001/pm8001_hwi.h                   |    1 +
 drivers/scsi/pm8001/pm8001_init.c                  |   19 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   31 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |    5 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   49 +-
 drivers/scsi/pm8001/pm80xx_hwi.h                   |    1 +
 drivers/scsi/pmcraid.c                             |   70 +-
 drivers/scsi/qedf/qedf.h                           |    3 +-
 drivers/scsi/qedf/qedf_dbg.h                       |    1 -
 drivers/scsi/qedf/qedf_main.c                      |   18 +-
 drivers/scsi/qedi/qedi_main.c                      |    5 +-
 drivers/scsi/qla1280.c                             |   10 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |    8 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |    7 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   16 +-
 drivers/scsi/qla2xxx/qla_dbg.h                     |    2 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   15 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |    3 +
 drivers/scsi/qla2xxx/qla_gs.c                      |   14 +-
 drivers/scsi/qla2xxx/qla_init.c                    |  115 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |   46 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |   84 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   15 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   38 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |   16 +-
 drivers/scsi/qla2xxx/qla_mr.h                      |    8 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   10 +-
 drivers/scsi/qla2xxx/qla_nx2.c                     |   10 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  223 +-
 drivers/scsi/qla2xxx/qla_sup.c                     |    9 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   24 +-
 drivers/scsi/qla2xxx/qla_target.h                  |    2 +-
 drivers/scsi/qla2xxx/qla_version.h                 |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   23 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |    4 +-
 drivers/scsi/qla4xxx/ql4_nx.c                      |    6 -
 drivers/scsi/qla4xxx/ql4_os.c                      |   33 +-
 drivers/scsi/scsi.c                                |   13 +
 drivers/scsi/scsi_debug.c                          |  229 +-
 drivers/scsi/scsi_dh.c                             |    2 +-
 drivers/scsi/scsi_error.c                          |   66 +-
 drivers/scsi/scsi_lib.c                            |  119 +-
 drivers/scsi/scsi_priv.h                           |    7 +-
 drivers/scsi/scsi_scan.c                           |   23 +-
 drivers/scsi/scsi_sysfs.c                          |    6 +-
 drivers/scsi/scsi_transport_iscsi.c                |   14 +-
 drivers/scsi/scsi_transport_srp.c                  |    2 +-
 drivers/scsi/sd.c                                  |    7 +-
 drivers/scsi/sd_zbc.c                              |   21 +-
 drivers/scsi/sg.c                                  |    2 +-
 drivers/scsi/sim710.c                              |   14 +-
 drivers/scsi/smartpqi/smartpqi.h                   |  310 +-
 drivers/scsi/smartpqi/smartpqi_init.c              | 3147 ++++++++++++--------
 drivers/scsi/smartpqi/smartpqi_sas_transport.c     |   39 +-
 drivers/scsi/smartpqi/smartpqi_sis.c               |    9 +-
 drivers/scsi/smartpqi/smartpqi_sis.h               |    1 +
 drivers/scsi/sni_53c710.c                          |    5 +-
 drivers/scsi/snic/snic_debugfs.c                   |   20 +-
 drivers/scsi/st.c                                  |    2 +-
 drivers/scsi/storvsc_drv.c                         |   84 +-
 drivers/scsi/sun3x_esp.c                           |    4 +-
 drivers/scsi/ufs/cdns-pltfrm.c                     |    4 +
 drivers/scsi/ufs/ufs-debugfs.c                     |   90 +
 drivers/scsi/ufs/ufs-debugfs.h                     |    2 +
 drivers/scsi/ufs/ufs-exynos.c                      |    3 +-
 drivers/scsi/ufs/ufs-mediatek.c                    |    2 +-
 drivers/scsi/ufs/ufs-qcom.c                        |   21 +-
 drivers/scsi/ufs/ufs-sysfs.c                       |    2 +-
 drivers/scsi/ufs/ufs.h                             |   10 +-
 drivers/scsi/ufs/ufshcd-pci.c                      |  169 ++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |    8 +-
 drivers/scsi/ufs/ufshcd.c                          |  357 ++-
 drivers/scsi/ufs/ufshcd.h                          |   30 +-
 drivers/scsi/ufs/ufshci.h                          |   40 +-
 drivers/scsi/vmw_pvscsi.c                          |    2 -
 drivers/scsi/vmw_pvscsi.h                          |    2 -
 drivers/target/iscsi/iscsi_target.c                |   23 +-
 drivers/target/iscsi/iscsi_target_configfs.c       |    3 +-
 drivers/target/iscsi/iscsi_target_nego.c           |    1 -
 drivers/target/iscsi/iscsi_target_stat.c           |    1 -
 drivers/target/iscsi/iscsi_target_util.c           |   17 -
 drivers/target/loopback/tcm_loop.c                 |   60 +-
 drivers/target/loopback/tcm_loop.h                 |    1 -
 drivers/target/sbp/sbp_target.c                    |    8 +-
 drivers/target/target_core_configfs.c              |   36 +-
 drivers/target/target_core_device.c                |   12 +-
 drivers/target/target_core_fabric_configfs.c       |   58 +
 drivers/target/target_core_file.c                  |    3 +-
 drivers/target/target_core_iblock.c                |   81 +-
 drivers/target/target_core_iblock.h                |   10 +
 drivers/target/target_core_internal.h              |    2 +
 drivers/target/target_core_pr.c                    |   42 +-
 drivers/target/target_core_pscsi.c                 |   16 +-
 drivers/target/target_core_rd.c                    |   27 +-
 drivers/target/target_core_rd.h                    |    1 +
 drivers/target/target_core_sbc.c                   |    4 +-
 drivers/target/target_core_spc.c                   |    6 +-
 drivers/target/target_core_stat.c                  |    3 -
 drivers/target/target_core_tmr.c                   |    4 +
 drivers/target/target_core_transport.c             |  300 +-
 drivers/target/target_core_user.c                  |  440 +--
 drivers/target/target_core_xcopy.c                 |   10 +-
 drivers/target/tcm_fc/tfc_cmd.c                    |   14 +-
 drivers/target/tcm_fc/tfc_sess.c                   |    2 +-
 drivers/usb/gadget/function/f_tcm.c                |   36 +-
 drivers/vhost/scsi.c                               |   58 +-
 drivers/xen/xen-scsiback.c                         |   21 +-
 include/linux/blk-mq.h                             |   13 +-
 include/linux/hyperv.h                             |    1 +
 include/linux/sbitmap.h                            |   85 +-
 include/scsi/libfcoe.h                             |    2 +-
 include/scsi/scsi.h                                |   21 +-
 include/scsi/scsi_cmnd.h                           |    3 +
 include/scsi/scsi_device.h                         |   10 +-
 include/scsi/scsi_dh.h                             |    5 +-
 include/scsi/scsi_eh.h                             |    2 +-
 include/scsi/scsi_host.h                           |   84 +-
 include/scsi/scsi_transport_iscsi.h                |    1 +
 include/target/target_core_backend.h               |    2 +
 include/target/target_core_base.h                  |   59 +-
 include/target/target_core_fabric.h                |   21 +-
 include/trace/events/ufs.h                         |   21 +
 lib/sbitmap.c                                      |  210 +-
 267 files changed, 7447 insertions(+), 5514 deletions(-)

James




