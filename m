Return-Path: <SRS0=AAGU=DU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C7AC433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 23:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E5C722201
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Oct 2020 23:03:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="gPlcPibP";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="gPlcPibP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgJMXDp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:03:45 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:59040 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726894AbgJMXDo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Oct 2020 19:03:44 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2020 19:03:44 EDT
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2346D1280F3C;
        Tue, 13 Oct 2020 15:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1602629628;
        bh=ASBR05sJFf/8IbMGhADN1ZhR3KUTenxnTVTCPvKLIhk=;
        h=Subject:From:To:Cc:Date:From;
        b=gPlcPibPgKAMLMwdNYhevQlLIsY+FzolJLFa7wC7H+ghG8Wi3f7oEWow5uTneraJ6
         z1/DNN35DPcj34fGj0xqGjJcysp9isVmofmJezF+uDN8BkVJrog1K05jm26rduuZx/
         JWgPCzoPSuhGI+FfEgB4RKWlaot77owEIpY2Tt/g=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2e6Gfe-ATneH; Tue, 13 Oct 2020 15:53:48 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id BD5FB1280F3B;
        Tue, 13 Oct 2020 15:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1602629628;
        bh=ASBR05sJFf/8IbMGhADN1ZhR3KUTenxnTVTCPvKLIhk=;
        h=Subject:From:To:Cc:Date:From;
        b=gPlcPibPgKAMLMwdNYhevQlLIsY+FzolJLFa7wC7H+ghG8Wi3f7oEWow5uTneraJ6
         z1/DNN35DPcj34fGj0xqGjJcysp9isVmofmJezF+uDN8BkVJrog1K05jm26rduuZx/
         JWgPCzoPSuhGI+FfEgB4RKWlaot77owEIpY2Tt/g=
Message-ID: <fdee2336d2a7eada3749e07c3cc6ea682f8200b3.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.8+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 13 Oct 2020 15:53:46 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series consists of the usual driver updates (ufs, qla2xxx, tcmu,
ibmvfc, lpfc, smartpqi, hisi_sas, qedi, qedf, mpt3sas) and minor bug
fixes.  There are only three core changes: adding sense codes, cleaning
up noretry and adding an option for limitless retries.

We've got one obvious conflict between deleting a spurious fall through
annotation and changing it to the new form in
drivers/scsi/aacraid/aachba.c.  The resolution is just to delete the
new form one.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (4):
      scsi: ufs-pci: Add LTR support for Intel controllers
      scsi: ufs: Improve interrupt handling for shared interrupts
      scsi: ufs: Fix interrupt error message for shared interrupts
      scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel EHL

Alex Dewar (2):
      scsi: aic7xxx: Use kmemdup() in two places
      scsi: esas2r: Remove unnecessary casts

Alim Akhtar (1):
      scsi: ufs: Fix 'unmet direct dependencies' config warning

Andy Shevchenko (1):
      scsi: dc395x: Use %*ph to print small buffer

Andy Teng (1):
      scsi: ufs: ufs-mediatek: Modify the minimum RX/TX lane count to 2

Arun Easi (12):
      scsi: qla2xxx: Fix point-to-point (N2N) device discovery issue
      scsi: qla2xxx: Fix reset of MPI firmware
      scsi: qla2xxx: Fix MPI reset needed message
      scsi: qla2xxx: Add rport fields in debugfs
      scsi: qla2xxx: Make tgt_port_database available in initiator mode
      scsi: qla2xxx: Fix I/O errors during LIP reset tests
      scsi: qla2xxx: Honor status qualifier in FCP_RSP per spec
      scsi: qla2xxx: Allow dev_loss_tmo setting for FC-NVMe devices
      scsi: qla2xxx: Setup debugfs entries for remote ports
      scsi: qla2xxx: Fix I/O failures during remote port toggle testing
      scsi: qla2xxx: Fix WARN_ON in qla_nvme_register_hba
      scsi: qla2xxx: Allow ql2xextended_error_logging special value 1 to be set anytime

Bao D. Nguyen (1):
      scsi: ufshcd: Allow specifying an Auto-Hibernate Timer value of zero

Bean Huo (4):
      scsi: ufs: ufs-exynos: Use devm_platform_ioremap_resource_byname()
      scsi: ufs: Remove several redundant goto statements
      scsi: ufs: Change ufshcd_comp_devman_upiu() to ufshcd_compose_devman_upiu()
      scsi: ufs: No need to send Abort Task if the task in DB was cleared

Bodo Stroesser (3):
      scsi: target: tcmu: Optimize scatter_data_area()
      scsi: target: tcmu: Optimize queue_cmd_ring()
      scsi: target: tcmu: Join tcmu_cmd_get_data_length() and tcmu_cmd_get_block_cnt()

Brian King (2):
      scsi: ibmvfc: Protect vhost->task_set increment by the host lock
      scsi: ibmvfc: Avoid link down on FS9100 canister reboot

Can Guo (12):
      scsi: ufs: Handle LINERESET indication in err handler
      scsi: ufs: Abort tasks before clearing them from doorbell
      scsi: ufs: Remove an unpaired ufshcd_scsi_unblock_requests() in err_handler()
      scsi: ufs: Properly release resources if a task is aborted successfully
      scsi: ufs: Fix a race condition between error handler and runtime PM ops
      scsi: ufs: Move dumps in IRQ handler to error handler
      scsi: ufs: Recover HBA runtime PM error in error handler
      scsi: ufs: Fix concurrency of error handler and other error recovery paths
      scsi: ufs: Add some debug information to ufshcd_print_host_state()
      scsi: ufs-qcom: Remove testbus dump in ufs_qcom_dump_dbg_regs
      scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()
      scsi: ufs: Add checks before setting clk-gating states

Christophe JAILLET (2):
      scsi: qla2xxx: Fix the size used in a 'dma_free_coherent()' call
      scsi: qla4xxx: Fix an error handling path in 'qla4xxx_get_host_stats()'

Colin Ian King (4):
      scsi: lpfc: Fix spelling mistake "Cant" -> "Can't"
      scsi: csiostor: Fix spelling mistake "couldnt" -> "couldn't"
      scsi: bnx2fc: Fix spelling mistake "couldnt" -> "couldn't"
      scsi: snic: Fix spelling mistakes of "Queueing"

Daejun Park (1):
      scsi: ufs: Fix NOP OUT timeout value

Damien Le Moal (2):
      scsi: core: Update additional sense codes list
      scsi: core: Clean up scsi_noretry_cmd()

Dan Carpenter (4):
      scsi: be2iscsi: Fix a theoretical leak in beiscsi_create_eqs()
      scsi: libsas: Fix error path in sas_notify_lldd_dev_found()
      scsi: aacraid: Remove erroneous fallthrough annotation
      scsi: libcxgbi: Fix a use after free in cxgbi_conn_xmit_pdu()

Daniel Wagner (4):
      scsi: qla2xxx: Handle incorrect entry_type entries
      scsi: qla2xxx: Log calling function name in qla2x00_get_sp_from_handle()
      scsi: qla2xxx: Simplify return value logic in qla2x00_get_sp_from_handle()
      scsi: qla2xxx: Warn if done() or free() are called on an already freed srb

Denis Efremov (1):
      scsi: libcxgbi: Use kvzalloc instead of opencoded kzalloc/vzalloc

Dinghao Liu (1):
      scsi: pm8001: Fix memleak in pm8001_exec_internal_task_abort

Don Brace (5):
      scsi: smartpqi: Update copyright
      scsi: smartpqi: Update documentation
      scsi: MAINTAINERS: Update smartpqi and hpsa
      scsi: hpsa: Update copyright
      scsi: smartpqi: Bump version to 1.2.16-010

Douglas Gilbert (2):
      scsi: scsi_debug: Implement lun_format
      scsi: scsi_debug: Fix scp is NULL errors

Enzo Matsumiya (1):
      scsi: qla2xxx: Use MBX_TOV_SECONDS for mailbox command timeout values

Eric Biggers (1):
      scsi: ufs: Make ufshcd_print_trs() consider UFSHCD_QUIRK_PRDT_BYTE_GRAN

Hannes Reinecke (2):
      scsi: lpfc: Drop nodelist reference on error in lpfc_gen_req()
      scsi: fnic: Do not call 'scsi_done()' for unhandled commands

Hou Pu (1):
      scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem

James Smart (5):
      scsi: fc: Add 256GBit speed setting to SCSI FC transport
      scsi: lpfc: Update lpfc version to 12.8.0.4
      scsi: lpfc: Extend the RDF FPIN Registration descriptor for additional events
      scsi: lpfc: Fix FLOGI/PLOGI receive race condition in pt2pt discovery
      scsi: lpfc: Fix setting IRQ affinity with an empty CPU mask

Jason Yan (22):
      scsi: myrb: Make some symblos static
      scsi: myrs: Make some symbols static
      scsi: isci: Make scu_link_layer_set_txcomsas_timeout() static
      scsi: bnx2fc: Make a bunch of symbols static in bnx2fc_fcoe.c
      scsi: isci: Make isci_host_attrs static
      scsi: aacraid: Make some symbols static in aachba.c
      scsi: megaraid: Make smp_affinity_enable static
      scsi: fnic: Remove unneeded semicolon
      scsi: nsp32: Remove unneeded semicolon
      scsi: sym53c8xx_2: Remove unneeded semicolon
      scsi: qla2xxx: Remove unneeded variable 'rval'
      scsi: qla1280: Remove set but not used variable in qla1280_status_entry()
      scsi: qla1280: Remove set but not used variable in qla1280_mailbox_command()
      scsi: qla1280: Remove set but not used variable in qla1280_nvram_config()
      scsi: qla1280: Remove set but not used variable in qla1280_done()
      scsi: fnic: Remove set but not used 'eth_hdrs_stripped'
      scsi: fnic: Remove set but not used 'fr_len'
      scsi: fnic: Remove set but not used variable in is_fnic_fip_flogi_reject()
      scsi: fnic: Remove set but not used 'old_vlan'
      scsi: mptscsih: Remove set but not used 'timeleft'
      scsi: isci: Remove set but not used 'index'
      scsi: dpt_i2o: Remove set but not used 'pHba'

Javed Hasan (4):
      scsi: qedf: FDMI attributes correction
      scsi: qedf: Fix for the session’s E_D_TOV value
      scsi: qedf: Change the debug parameter permission to read & write
      scsi: libfc: Fix for double free()

Jing Xiangfeng (7):
      scsi: qedf: Remove redundant assignment to variable 'rc'
      scsi: mvumi: Fix error return in mvumi_io_attach()
      scsi: snic: Remove unnecessary condition
      scsi: oak: Remove redundant initialization of variable ret
      scsi: target: Remove redundant assignment to variable 'ret'
      scsi: ibmvfc: Fix error return in ibmvfc_probe()
      scsi: ufs: ti-j721e-ufs: Fix error return in ti_j721e_ufs_probe()

Joe Perches (1):
      scsi: arm: Avoid comma separated statements

John Donnelly (1):
      scsi: target: tcmu: Fix warning: 'page' may be used uninitialized

John Pittman (2):
      scsi: scsi_debug: Make sdebug_build_parts() respect virtual_gb
      scsi: scsi_debug: Adjust num_parts to create equally sized partitions

Julian Wiedmann (2):
      scsi: zfcp: Clarify access to erp_action in zfcp_fsf_req_complete()
      scsi: zfcp: Use list_first_entry_or_null() in zfcp_erp_thread()

Kevin Barnett (4):
      scsi: smartpqi: Add RAID bypass counter
      scsi: smartpqi: Support device deletion via sysfs
      scsi: smartpqi: Avoid crashing kernel for controller issues
      scsi: smartpqi: Identify physical devices without issuing INQUIRY

Kiwoong Kim (3):
      scsi: ufs: exynos: Enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
      scsi: ufs: Introduce skipping manual flush for Write Booster
      scsi: ufs: Change fDeviceInit busy wait

Li Heng (6):
      scsi: mpt3sas: Remove superfluous memset()
      scsi: qla2xxx: Remove superfluous memset()
      scsi: pmcraid: Remove superfluous memset()
      scsi: mvsas: Remove superfluous memset()
      scsi: mptctl: Remove unneeded cast from memory allocation
      scsi: mptfc: Remove unneeded cast from memory allocation

Liu Shixin (8):
      scsi: snic: Convert to use DEFINE_SEQ_ATTRIBUTE macro
      scsi: sun_esp: Use module_platform_driver to simplify the code
      scsi: sun3x_esp: Use module_platform_driver to simplify the code
      scsi: sni_53c710: Use module_platform_driver to simplify the code
      scsi: qlogicpti: Use module_platform_driver to simplify the code
      scsi: mac_esp: Use module_platform_driver to simplify the code
      scsi: jazz_esp: Use module_platform_driver to simplify the code
      scsi: libsas: Simplify the return expression of sas_discover_* functions

Luo Jiaxing (8):
      scsi: hisi_sas: Use hisi_hba->cq_nvecs for calling calling synchronize_irq()
      scsi: hisi_sas: Code style cleanup
      scsi: hisi_sas: Add BIST support for fixed code pattern
      scsi: hisi_sas: Add BIST support for phy FFE
      scsi: hisi_sas: Make phy index variable name consistent
      scsi: hisi_sas: Do not modify upper fields of PROG_PHY_LINK_RATE reg
      scsi: hisi_sas: Modify macro name for OOB phy linkrate
      scsi: libsas: Set data_dir as DMA_NONE if libata marks qc as NODATA

Mahesh Rajashekhara (2):
      scsi: smartpqi: Update logical volume size after expansion
      scsi: smartpqi: Add id support for SmartRAID 3152-8i

Manish Rangankar (6):
      scsi: qedi: Add schedule_hw_err_handler callback for fan failure
      scsi: qedi: Add support for handling PCIe errors
      scsi: qedi: Add firmware error recovery invocation support
      scsi: qedi: Use snprintf instead of sprintf
      scsi: qedi: Skip firmware connection termination for PCI shutdown handler
      scsi: qedi: Use qed count from set_fp_int in msix allocation

Matej Genci (1):
      scsi: virtio_scsi: Rescan the entire target on transport reset when LUN is 0

Mike Christie (3):
      scsi: sd: Allow user to configure command retries
      scsi: core: Add limitless cmd retry support
      scsi: fcoe: Fix I/O path allocation

Ming Lei (1):
      scsi: core: Only re-run queue in scsi_end_request() if device queue is busy

Niklas Cassel (1):
      scsi: scsi_debug: Remove superfluous close zone in resp_open_zone()

Nilesh Javali (6):
      scsi: qla2xxx: Update version to 10.02.00.103-k
      scsi: qla2xxx: Update version to 10.02.00.102-k
      scsi: qedi: Mark all connections for recovery on link down event
      scsi: qedi: Protect active command list to avoid list corruption
      scsi: qedi: Fix list_del corruption while removing active I/O
      scsi: MAINTAINERS: Update Marvell owned driver maintainers

Nícolas F. R. A. Prado (1):
      scsi: docs: Remove obsolete scsi typedef text from scsi_mid_low_api

Pujin Shi (1):
      scsi: ufs: Fix missing brace warning for old compilers

Qinglang Miao (1):
      scsi: bnx2i: Remove unnecessary mutex_init()

Quinn Tran (13):
      scsi: qla2xxx: Fix crash on session cleanup with unload
      scsi: qla2xxx: Fix buffer-buffer credit extraction error
      scsi: qla2xxx: Add IOCB resource tracking
      scsi: qla2xxx: Performance tweak
      scsi: qla2xxx: Fix memory size truncation
      scsi: qla2xxx: Reduce duplicate code in reporting speed
      Revert "scsi: qla2xxx: Disable T10-DIF feature with FC-NVMe during probe"
      scsi: qla2xxx: Fix null pointer access during disconnect from subsystem
      scsi: qla2xxx: Reduce noisy debug message
      scsi: qla2xxx: Fix login timeout
      scsi: qla2xxx: Indicate correct supported speeds for Mezz card
      scsi: qla2xxx: Flush I/O on zone disable
      scsi: qla2xxx: Flush all sessions on zone disable

René Rebe (1):
      scsi: qla2xxx: Fix regression on sparc64

Roman Bolshakov (1):
      scsi: target: core: Add CONTROL field for trace events

Sai Prakash Ranjan (1):
      scsi: ufs-qcom: Remove unused MSM bus scaling APIs

Saurav Kashyap (15):
      scsi: qla2xxx: Correct the check for sscanf() return value
      scsi: qla2xxx: Add SLER and PI control support
      scsi: qedf: Retry qed->probe during recovery
      scsi: qedf: Add schedule_hw_err_handler callback for fan failure
      scsi: qedf: Return SUCCESS if stale rport is encountered
      scsi: qedf: Correct the comment in qedf_initiate_els
      scsi: qedf: Fix race between ELS completion and flushing ELS request
      scsi: qedf: Don't process ELS completion if event is flushed or cleaned up
      scsi: qedf: Initiate cleanup for ELS commands as well
      scsi: qedf: Send cleanup even for RRQ on timeout
      scsi: qedf: Do not kill timeout work for original I/O on RRQ completion
      scsi: qedf: Check the validity of rjt frame before processing
      scsi: qedf: Check for port type and role before processing an event
      Revert "scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"
      scsi: qla2xxx: Check if FW supports MQ before enabling

Sergey Shtylyov (1):
      scsi: fdomain_isa: Merge branches in fdomain_isa_match()

Sreekanth Reddy (1):
      scsi: mpt3sas: Detect tampered Aero and Sea adapters

Stanley Chu (10):
      scsi: ufs-mediatek: dt-bindings: Add mt8192-ufshci compatible string
      scsi: ufs-mediatek: Support performance mode for inline encryption engine
      scsi: ufs: ufs-mediatek: Fix build warnings with make W=1
      scsi: ufs: ufs-mediatek: Add host reset mechanism
      scsi: ufs: ufs-mediatek: Fix flag of unipro low-power mode
      scsi: ufs: ufs-mediatek: Fix HOST_PA_TACTIVATE quirk
      scsi: ufs: ufs-mediatek: Eliminate error message for unbound mphy
      scsi: ufs: Clean up completed request without interrupt notification
      scsi: ufs-mediatek: Fix incorrect time to wait link status
      scsi: ufs: Fix possible infinite loop in ufshcd_hold

Steffen Maier (1):
      scsi: zfcp: Fix use-after-free in request timeout handlers

Suganath Prabu S (7):
      scsi: mpt3sas: Update driver version to 35.100.00.00
      scsi: mpt3sas: Postprocessing of target and LUN reset
      scsi: mpt3sas: Add functions to check if any cmd is outstanding on Target and LUN
      scsi: mpt3sas: Rename and export interrupt mask/unmask functions
      scsi: mpt3sas: Cancel the running work during host reset
      scsi: mpt3sas: Dump system registers for debugging
      scsi: mpt3sas: Memset config_cmds.reply buffer with zeros

Suraj Upadhyay (7):
      scsi: megaraid: Remove pci-dma-compat wrapper API
      scsi: qla2xxx: Remove pci-dma-compat wrapper API
      scsi: hpsa: Remove pci-dma-compat wrapper API
      scsi: mpt3sas: Remove pci-dma-compat wrapper API
      scsi: dc395x: Remove pci-dma-compat wrapper API
      scsi: aic7xxx: Remove pci-dma-compat wrapper API
      scsi: aacraid: Remove pci-dma-compat wrapper API

Tianjia Zhang (4):
      scsi: csiostor: Fix wrong return value in csio_hw_prep_fw()
      scsi: qla2xxx: Fix wrong return value in qla_nvme_register_hba()
      scsi: qla2xxx: Fix wrong return value in qlt_chk_unresolv_exchg()
      scsi: qla2xxx: Remove redundant variable initialization

Tomas Henzl (5):
      scsi: aacraid: Add a missing iounmap call
      scsi: mpt3sas: A small correction in _base_process_reply_queue
      scsi: mpt3sas: Fix sync irqs
      scsi: mpt3sas: Don't call disable_irq from IRQ poll handler
      scsi: megaraid_sas: Don't call disable_irq from process IRQ poll

Tong Zhang (1):
      scsi: aic7xxx: Fix error code handling

Tyrel Datwyler (2):
      scsi: ibmvfc: Interface updates for future FPIN and MQ support
      scsi: ibmvfc: Use compiler attribute defines instead of __attribute__()

Varun Prakash (1):
      scsi: target: iscsi: Fix data digest calculation

Xiang Chen (8):
      scsi: hisi_sas: Recover PHY state according to the status before reset
      scsi: hisi_sas: Filter out new PHY up events during suspend
      scsi: hisi_sas: Add device link between SCSI devices and hisi_hba
      scsi: hisi_sas: Add check for methods _PS0 and _PR0
      scsi: hisi_sas: Add controller runtime PM support for v3 hw
      scsi: hisi_sas: Switch to new framework to support suspend and resume
      scsi: hisi_sas: Add missing newlines
      scsi: hisi_sas: Avoid accessing to SSP task for SMP I/Os

Xianting Tian (1):
      scsi: qla2xxx: Fix the return value

Xiongfeng Wang (1):
      scsi: target: tcmu: Add missing newline when printing parameters

Xu Wang (1):
      scsi: qedi: Remove redundant NULL check

Ye Bin (11):
      scsi: lpfc: Remove unneeded variable 'status' in lpfc_fcp_cpu_map_store()
      scsi: qla4xxx: Delete unneeded variable 'status' in qla4xxx_process_ddb_changed
      scsi: fnic: Fix inconsistent format argument type in fnic_debugfs.c
      scsi: qla2xxx: Fix inconsistent format argument type in qla_dbg.c
      scsi: qla2xxx: Fix inconsistent format argument type in qla_os.c
      scsi: qla2xxx: Fix inconsistent format argument type in tcm_qla2xxx.c
      scsi: sym53c8xx_2: Delete unnecessary else-if in sym_xerr_cam_status()
      scsi: lpfc: Remove set but not used 'qp'
      scsi: gdth: Remove set but used 'cmd_index'
      scsi: pmcraid: Remove set but not used 'res'
      scsi: qedf: Fix null ptr reference in qedf_stag_change_work

YueHaibing (2):
      scsi: aic94xx: Remove unused inline function
      scsi: libfc: Fix passing zero to 'PTR_ERR' warning

And the diffstat:

 .../devicetree/bindings/ufs/ufs-mediatek.txt       |   4 +-
 Documentation/scsi/scsi_mid_low_api.rst            |   6 -
 Documentation/scsi/smartpqi.rst                    |  14 +-
 MAINTAINERS                                        |  28 +-
 drivers/message/fusion/mptctl.c                    |   5 +-
 drivers/message/fusion/mptfc.c                     |   6 +-
 drivers/message/fusion/mptscsih.c                  |   3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |   2 +-
 drivers/s390/scsi/zfcp_erp.c                       |   8 +-
 drivers/s390/scsi/zfcp_fsf.c                       |  14 +-
 drivers/scsi/aacraid/aachba.c                      |  11 +-
 drivers/scsi/aacraid/commctrl.c                    |  20 +-
 drivers/scsi/aacraid/commsup.c                     |   9 +-
 drivers/scsi/aacraid/linit.c                       |   4 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |   3 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |   7 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   3 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |   4 +-
 drivers/scsi/aic94xx/aic94xx.h                     |   8 -
 drivers/scsi/arm/cumana_2.c                        |  19 +-
 drivers/scsi/arm/eesox.c                           |   9 +-
 drivers/scsi/arm/oak.c                             |   2 +-
 drivers/scsi/arm/powertec.c                        |   9 +-
 drivers/scsi/be2iscsi/be_main.c                    |   4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |  10 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |   6 +-
 drivers/scsi/bnx2i/bnx2i_init.c                    |   2 -
 drivers/scsi/csiostor/csio_hw.c                    |   2 +-
 drivers/scsi/csiostor/csio_scsi.c                  |   6 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |  10 +-
 drivers/scsi/cxgbi/libcxgbi.h                      |  16 -
 drivers/scsi/dc395x.c                              |  16 +-
 drivers/scsi/dpt_i2o.c                             |   3 -
 drivers/scsi/esas2r/esas2r_ioctl.c                 |  28 +-
 drivers/scsi/fdomain_isa.c                         |   5 +-
 drivers/scsi/fnic/fnic_debugfs.c                   |   6 +-
 drivers/scsi/fnic/fnic_fcs.c                       |   9 -
 drivers/scsi/fnic/fnic_main.c                      |   5 +-
 drivers/scsi/fnic/fnic_scsi.c                      |   3 +-
 drivers/scsi/gdth.c                                |   2 -
 drivers/scsi/hisi_sas/Kconfig                      |   1 +
 drivers/scsi/hisi_sas/hisi_sas.h                   |  37 +
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 123 ++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |  24 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 251 ++++--
 drivers/scsi/hpsa.c                                |  17 +-
 drivers/scsi/hpsa.h                                |   1 +
 drivers/scsi/hpsa_cmd.h                            |   1 +
 drivers/scsi/ibmvscsi/ibmvfc.c                     | 229 +++++-
 drivers/scsi/ibmvscsi/ibmvfc.h                     | 160 +++-
 drivers/scsi/isci/host.c                           |   2 -
 drivers/scsi/isci/init.c                           |   2 +-
 drivers/scsi/isci/phy.c                            |   2 +-
 drivers/scsi/jazz_esp.c                            |  14 +-
 drivers/scsi/libfc/fc_disc.c                       |   6 +-
 drivers/scsi/libsas/sas_ata.c                      |  13 +-
 drivers/scsi/libsas/sas_discover.c                 |  11 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   3 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |   2 +
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   5 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   7 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   1 -
 drivers/scsi/lpfc/lpfc_version.h                   |   2 +-
 drivers/scsi/mac_esp.c                             |  14 +-
 drivers/scsi/megaraid.c                            | 192 ++---
 drivers/scsi/megaraid/megaraid_sas_base.c          |   2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  69 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |  21 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |  16 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               | 366 ++++++++-
 drivers/scsi/mvsas/mv_init.c                       |   4 -
 drivers/scsi/mvumi.c                               |   1 +
 drivers/scsi/myrb.c                                |   6 +-
 drivers/scsi/myrs.c                                |   8 +-
 drivers/scsi/nsp32.c                               |   4 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   2 +-
 drivers/scsi/pmcraid.c                             |   3 -
 drivers/scsi/qedf/qedf.h                           |   9 +
 drivers/scsi/qedf/qedf_els.c                       |  34 +-
 drivers/scsi/qedf/qedf_io.c                        |  12 +-
 drivers/scsi/qedf/qedf_main.c                      | 153 +++-
 drivers/scsi/qedi/qedi.h                           |   6 +
 drivers/scsi/qedi/qedi_fw.c                        |  30 +-
 drivers/scsi/qedi/qedi_iscsi.c                     |   7 +
 drivers/scsi/qedi/qedi_main.c                      | 131 ++-
 drivers/scsi/qla1280.c                             |  18 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |  97 +--
 drivers/scsi/qla2xxx/qla_dbg.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_dbg.h                     |   3 +
 drivers/scsi/qla2xxx/qla_def.h                     |  69 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     | 231 +++++-
 drivers/scsi/qla2xxx/qla_fw.h                      |   2 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   8 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |  55 +-
 drivers/scsi/qla2xxx/qla_init.c                    | 105 ++-
 drivers/scsi/qla2xxx/qla_inline.h                  |  98 ++-
 drivers/scsi/qla2xxx/qla_iocb.c                    |  57 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  81 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  93 +--
 drivers/scsi/qla2xxx/qla_mid.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  51 +-
 drivers/scsi/qla2xxx/qla_nvme.h                    |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      | 156 +---
 drivers/scsi/qla2xxx/qla_target.c                  |  23 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |  53 +-
 drivers/scsi/qla2xxx/qla_version.h                 |   6 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   2 +-
 drivers/scsi/qla4xxx/ql4_init.c                    |   3 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |   2 +-
 drivers/scsi/qlogicpti.c                           |  14 +-
 drivers/scsi/scsi_debug.c                          |  87 +-
 drivers/scsi/scsi_error.c                          |  37 +-
 drivers/scsi/scsi_lib.c                            |  77 +-
 drivers/scsi/scsi_priv.h                           |   1 +
 drivers/scsi/scsi_transport_fc.c                   |   1 +
 drivers/scsi/sd.c                                  | 101 ++-
 drivers/scsi/sd.h                                  |   1 +
 drivers/scsi/sense_codes.h                         |  54 +-
 drivers/scsi/smartpqi/Kconfig                      |   4 +-
 drivers/scsi/smartpqi/smartpqi.h                   |   7 +-
 drivers/scsi/smartpqi/smartpqi_init.c              | 476 ++++++-----
 drivers/scsi/smartpqi/smartpqi_sas_transport.c     |   2 +-
 drivers/scsi/smartpqi/smartpqi_sis.c               |   2 +-
 drivers/scsi/smartpqi/smartpqi_sis.h               |   2 +-
 drivers/scsi/sni_53c710.c                          |  14 +-
 drivers/scsi/snic/snic_debugfs.c                   |  16 +-
 drivers/scsi/snic/snic_scsi.c                      |   8 +-
 drivers/scsi/sun3x_esp.c                           |  14 +-
 drivers/scsi/sun_esp.c                             |  14 +-
 drivers/scsi/sym53c8xx_2/sym_fw.c                  |   6 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |   6 +-
 drivers/scsi/ufs/Kconfig                           |   1 -
 drivers/scsi/ufs/ti-j721e-ufs.c                    |   1 +
 drivers/scsi/ufs/ufs-exynos.c                      |  13 +-
 drivers/scsi/ufs/ufs-mediatek.c                    | 268 ++++++-
 drivers/scsi/ufs/ufs-mediatek.h                    |  29 +-
 drivers/scsi/ufs/ufs-qcom.c                        | 262 +-----
 drivers/scsi/ufs/ufs-qcom.h                        |  11 -
 drivers/scsi/ufs/ufs-sysfs.c                       |  10 +-
 drivers/scsi/ufs/ufshcd-crypto.c                   |   4 +-
 drivers/scsi/ufs/ufshcd-pci.c                      | 141 +++-
 drivers/scsi/ufs/ufshcd.c                          | 875 +++++++++++++--------
 drivers/scsi/ufs/ufshcd.h                          |  31 +-
 drivers/scsi/ufs/ufshci.h                          |   1 +
 drivers/scsi/ufs/unipro.h                          |   3 +
 drivers/scsi/virtio_scsi.c                         |   7 +-
 drivers/target/iscsi/iscsi_target.c                |  19 +-
 drivers/target/iscsi/iscsi_target_login.c          |   6 +-
 drivers/target/iscsi/iscsi_target_login.h          |   3 +-
 drivers/target/iscsi/iscsi_target_nego.c           |   3 +-
 drivers/target/target_core_user.c                  | 344 ++++----
 include/scsi/scsi_common.h                         |   7 +
 include/scsi/scsi_device.h                         |   1 +
 include/scsi/scsi_transport_fc.h                   |   1 +
 include/trace/events/target.h                      |  12 +-
 159 files changed, 4294 insertions(+), 2273 deletions(-)

James


