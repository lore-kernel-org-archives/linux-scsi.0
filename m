Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57AEC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 20:55:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D0F221E2
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 20:55:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Kak8o+J2";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Y4dYbciZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbgHFUzT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 16:55:19 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55986 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725875AbgHFUzR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 16:55:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id E7F8B8EE1E5;
        Thu,  6 Aug 2020 13:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1596747317;
        bh=SzVHVKjAxHNn4BBhRNhIm4We6bidyE/rhgT5/IOIJig=;
        h=Subject:From:To:Cc:Date:From;
        b=Kak8o+J28d4pM5G0LefNTEyXQS3dcKqJD7slh3yw7r7I7YQ9abDNwJJX+FCepx/32
         mJuKyBowCKh7Nm8luQoyFwPoFNsQi5lykEcrNGaBA+Xsd3Z+wJ3T7plrMW08qIxHfu
         bLYS2kNjKDcg+nXdnW07F0bcUs+Va7txcfy3tNNQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kkqXBY5cVcgH; Thu,  6 Aug 2020 13:55:16 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 623708EE194;
        Thu,  6 Aug 2020 13:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1596747316;
        bh=SzVHVKjAxHNn4BBhRNhIm4We6bidyE/rhgT5/IOIJig=;
        h=Subject:From:To:Cc:Date:From;
        b=Y4dYbciZhW+GXvrWeRltryXrXmPGYRxcrPcixwRDJX/L3bOW6r1zeRHmTksHO+TX9
         yjBFU/L5DFuWHDlLo8nL+aAy4xRdtaDxMY0f8rxsjll3AojG3ipBtZmEY/pCrB7U0s
         aFar3zv/mRZHz4hHuWGFRyMMDfE3dQRR64ZFZTSM=
Message-ID: <1596747315.25458.50.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.8+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 06 Aug 2020 13:55:15 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series consists of the usual driver updates (ufs, qla2xxx, tcmu,
lpfc, hpsa, zfcp, scsi_debug) and minor bug fixes.  We also have a huge
docbook fix update like most other subsystems and no major update to
the core (the few non trivial updates are either minor fixes or
removing an unused feature [scsi_sdb_cache]). 

Apparently the commit "scsi: virtio_scsi: Remove unnecessary condition
check" got duplicated in the vhost tree, but Stephen Rothwell tells me
ours is the more complete one you should choose when the conflict comes
up.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alan Stern (1):
      scsi: block: pm: Simplify resume handling

Alim Akhtar (7):
      scsi: ufs: ufs-exynos: Fix build warning
      scsi: ufs: Allow exynos ufs driver to build as module
      scsi: ufs: ufs-exynos: Add UFS host support for Exynos SoCs
      scsi: ufs: Introduce UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
      scsi: ufs: Add quirk to enable host controller without hce
      scsi: ufs: Add quirk to disallow reset of interrupt aggregation
      scsi: ufs: Add quirk to fix mishandling utrlclr/utmrlclr

Andres Beltran (1):
      scsi: storvsc: Add validation for untrusted Hyper-V values

Anton Blanchard (1):
      scsi: lpfc: Quieten some printks

Asutosh Das (1):
      scsi: ufs: docs: Add WriteBooster documentation

Bart Van Assche (9):
      scsi: qla2xxx: Introduce a function for computing the debug message prefix
      scsi: qla2xxx: Make qla2x00_restart_isp() easier to read
      scsi: qla2xxx: Fix a Coverity complaint in qla2100_fw_dump()
      scsi: qla2xxx: Make __qla2x00_alloc_iocbs() initialize 32 bits of request_t.handle
      scsi: qla2xxx: Remove a superfluous cast
      scsi: qla2xxx: Initialize 'n' before using it
      scsi: qla2xxx: Make qla82xx_flash_wait_write_finish() easier to read
      scsi: qla2xxx: Remove the __packed annotation from struct fcp_hdr and fcp_hdr_le
      scsi: qla2xxx: Check the size of struct fcp_hdr at compile time

Bean Huo (9):
      scsi: ufs: Change upiu_flags to be u8
      scsi: core: Fix formatting errors in scsi_lib.c
      scsi: core: Remove scsi_sdb_cache
      scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2 boilerplate
      scsi: ufs: Add compatibility with 3.1 UFS unit descriptor length
      scsi: ufs: Clean up ufs initialization path
      scsi: ufs: Fix potential NULL pointer access during memcpy
      scsi: ufs: Delete ufshcd_read_desc()
      scsi: ufs: Remove max_t in ufs_get_device_desc

Benjamin Block (2):
      scsi: docs: Remove invalid link and update text for zfcp kernel config
      scsi: docs: Update outdated link to IBM developerworks

Bob Liu (2):
      scsi: iscsi: Register sysfs for workqueue iscsi_destroy
      scsi: core: Register sysfs for SCSI workqueue

Bodo Stroesser (12):
      scsi: target: tcmu: Make TMR notification optional
      scsi: target: tcmu: Implement tmr_notify callback
      scsi: target: tcmu: Fix and simplify timeout handling
      scsi: target: tcmu: Factor out new helper ring_insert_padding
      scsi: target: tcmu: Do not queue aborted commands
      scsi: target: tcmu: Use priv pointer in se_cmd
      scsi: target: Add tmr_notify backend function
      scsi: target: Modify core_tmr_abort_task()
      scsi: target: tcmu: Fix crash on ARM during cmd completion
      scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM
      scsi: target: tcmu: Optimize use of flush_dcache_page
      scsi: target: tcmu: Remove unnecessary bit TCMU_CMD_BIT_INFLIGHT

Christophe JAILLET (3):
      scsi: eesox: Fix different dev_id between request_irq() and free_irq()
      scsi: powertec: Fix different dev_id between request_irq() and free_irq()
      scsi: cumana_2: Fix different dev_id between request_irq() and free_irq()

Colin Ian King (5):
      scsi: isci: Remove redundant initialization of variable 'status'
      scsi: libsas: Remove redundant assignment to variable res
      scsi: cxgb4i: Fix dereference of pointer tdata before it is null checked
      scsi: lpfc: Fix inconsistent indenting
      scsi: ufs: ufs-exynos: Fix spelling mistake "pa_granularty" -> "pa_granularity"

Damien Le Moal (10):
      scsi: mpt3sas: Fix kdoc comments format
      scsi: mpt3sas: Fix set but unused variable
      scsi: sd_zbc: Fix kdoc comment format
      scsi: sd: Fix kdoc comment format
      scsi: megaraid: Remove set but unused variable
      scsi: megaraid: Fix set but unused variable
      scsi: megaraid: Remove set but unused variable
      scsi: megaraid: Remove set but unused variable
      scsi: megaraid: Fix compilation warnings
      scsi: megaraid: Fix kdoc comments format

Dan Carpenter (2):
      scsi: cxgb4i: Clean up a debug printk
      scsi: ufs: ufs-exynos: Remove an unnecessary NULL check

Dick Kennedy (15):
      scsi: lpfc: Fix less-than-zero comparison of unsigned value
      scsi: lpfc: Fix interrupt assignments when multiple vectors are supported on same CPU
      scsi: lpfc: Update lpfc version to 12.8.0.2
      scsi: lpfc: Add an internal trace log buffer
      scsi: lpfc: Add blk_io_poll support for latency improvment
      scsi: lpfc: Add support to display if adapter dumps are available
      scsi: lpfc: Allow applications to issue Common Set Features mailbox command
      scsi: lpfc: Fix language in 0373 message to reflect non-error message
      scsi: lpfc: Fix kdump hang on PPC
      scsi: lpfc: Fix shost refcount mismatch when deleting vport
      scsi: lpfc: Fix stack trace seen while setting rrq active
      scsi: lpfc: Fix oops due to overrun when reading SLI3 data
      scsi: lpfc: Fix NVMe rport deregister and registration during ADISC
      scsi: lpfc: Fix missing MDS functionality
      scsi: lpfc: Fix unused assignment in lpfc_sli4_bsg_link_diag_test

Don Brace (5):
      scsi: hpsa: Correct ctrl queue depth
      scsi: hpsa: Bump version
      scsi: hpsa: Increase controller error handling timeout
      scsi: hpsa: Increase queue depth for external LUNs
      scsi: hpsa: Correct rare oob condition

Douglas Gilbert (5):
      scsi: scsi_debug: Implement tur_ms_to_ready parameter
      scsi: scsi_debug: Fix request sense
      scsi: scsi_debug: Update documentation url and bump version
      scsi: scsi_debug: every_nth triggered error injection
      scsi: scsi_debug: Fix in_use bitmap corruption

Eric Biggers (4):
      scsi: ufs-qcom: Add Inline Crypto Engine support
      scsi: ufs: Add program_key() variant op
      scsi: ufs-qcom: Name the dev_ref_clk_ctrl registers
      scsi: firmware: qcom_scm: Add support for programming inline crypto keys

Ferruh Yigit (1):
      scsi: lpfc: Fix typo in comment for ULP

Finn Thain (1):
      scsi: mesh: Fix panic after host or bus reset

Flavio Suligoi (2):
      scsi: storvsc: Fix spelling mistake
      scsi: mpt3sas: Fix spelling mistake

George Spelvin (1):
      scsi: zfcp: Use prandom_u32_max() for backoff

Guenter Roeck (1):
      scsi: lpfc: Add dependency on CPU_FREQ

Hannes Reinecke (3):
      scsi: scsi_transport_srp: Sanitize scsi_target_block/unblock sequences
      scsi: core: Only return started requests from scsi_host_find_tag()
      scsi: aic79xx: Restore modes when exiting ahd_linux_queue_abort_cmd()

Hou Pu (2):
      scsi: target: iscsi: Fix inconsistent debug message
      scsi: target: iscsi: Fix login error when receiving

James Smart (1):
      scsi: lpfc: NVMe remote port devloss_tmo from lldd

Javed Hasan (1):
      scsi: bnx2fc: Removal of unused variables

Jing Xiangfeng (1):
      scsi: iscsi: Do not put host in iscsi_set_flashnode_param()

Johannes Thumshirn (1):
      scsi: sd_zbc: Don't limit max_zone_append sectors to max_hw_sectors

John Garry (3):
      scsi: scsi_debug: Support hostwide tags
      scsi: scsi_debug: Add check for sdebug_max_queue during module init
      scsi: hisi_sas: Remove one kerneldoc comment

Julian Wiedmann (4):
      scsi: zfcp: Avoid benign overflow of the Request Queue's free-level
      scsi: zfcp: Replace open-coded list move
      scsi: zfcp: Clean up zfcp_erp_action_ready()
      scsi: zfcp: Fix an outdated comment for zfcp_qdio_send()

Kieran Bingham (1):
      scsi: Fix trivial spelling

Kiwoong Kim (1):
      scsi: ufs: Add quirk to fix abnormal ocs fatal error

Lee Jones (131):
      scsi: mvsas: Move 'core_nr' inside #ifdef and remove unused variable 'res_flag'
      scsi: esas2r: Demote a few non-conformant kerneldoc headers
      scsi: bnx2i: Add parameter description and rename another
      scsi: bfa: Ensure a blank line precedes next function/header
      scsi: qedi: Staticify non-external function 'qedi_get_iscsi_error'
      scsi: qedi: Demote seemingly unintentional kerneldoc header
      scsi: bfa: Demote seemingly unintentional kerneldoc header
      scsi: bfa: Demote seemingly unintentional kerneldoc header
      scsi: bfa: Demote non-kerneldoc headers down to standard comment blocks
      scsi: esas2r: Add braces around the one-line if()
      scsi: qedi: Remove set but unused variable 'tmp'
      scsi: be2iscsi: Correct misdocumentation of function param 'ep'
      scsi: bnx2i: Add, remove and edit some function parameter descriptions
      scsi: bnx2i: Fix a whole host of kerneldoc issues
      scsi: bfa: Remove unused variable 'adisc'
      scsi: bfa: Demote non-compliant kerneldoc headers to standard comments
      scsi: csiostor: Add missing description for csio_rnode_fwevt_handler()'s 'fwevt' param
      scsi: bfa: Staticify non-external functions
      scsi: csiostor: Remove 2 unused variables {mc,edc}_bist_status_rdata_reg
      scsi: csiostor: Mark known unused variable as __always_unused
      scsi: bfa: Remove a few unused variables 'pgoff' and 't'
      scsi: lpfc: Add description for lpfc_release_rpi()'s 'ndlpl param
      scsi: lpfc: Fix a bunch of kerneldoc misdemeanors
      scsi: qla4xxx: Rename function parameter descriptions
      scsi: lpfc: Add and rename a whole bunch of function parameter descriptions
      scsi: lpfc: Use __printf() format notation
      scsi: qla4xxx: Remove set but unused variable 'status'
      scsi: ips: Convert strnlen() to memcpy() since result should not be NUL terminated
      scsi: ips: Remove some set but unused variables
      scsi: qedi: Remove 2 set but unused variables
      scsi: bfa: Demote seemingly unintentional kerneldoc header
      scsi: bfa: Remove set but unused variable 'rp'
      scsi: bnx2i: Add missing descriptions for 'attr' parameter
      scsi: bfa: Staticify local functions
      scsi: ufs: ufs-exynos: Demote seemingly unintentional kerneldoc header
      scsi: bnx2i: Fix parameter misnaming in function header
      scsi: ufs: ufs-qcom: Demote nonconformant kerneldoc headers
      scsi: lpfc: Fix kerneldoc parameter formatting/misnaming/missing issues
      scsi: lpfc: Fix some function parameter descriptions
      scsi: cxgb3i: Remove bad documentation and demote kerneldoc header
      scsi: sym53c8xx_2: Ensure variable has the same stipulations as code using it
      scsi: sym53c8xx_2: Add missing description for 'pdev'
      scsi: lpfc: Ensure variable has the same stipulations as code using it
      scsi: bfa: Staticify all local functions
      scsi: csiostor: Demote kerneldoc that fails to meet the criteria
      scsi: qla4xxx: Supply description for 'code'
      scsi: qla4xxx: Remove three set but unused variables
      scsi: csiostor: Fix misnamed function parameter
      scsi: lpfc: Fix-up formatting/docrot where appropriate
      scsi: qla4xxx: Document qla4xxx_process_ddb()'s 'conn_err'
      scsi: lpfc: Provide description for lpfc_mem_alloc()'s 'align' param
      scsi: qla4xxx: Repair function documentation headers
      scsi: qla4xxx: Fix some kerneldoc parameter documentation issues
      scsi: pm8001: Staticify 'pm80xx_pci_mem_copy' and 'mpi_set_phy_profile_req'
      scsi: lpfc: Fix-up around 120 documentation issues
      scsi: qla4xxx: Fix incorrectly named function parameter
      scsi: qla4xxx: Fix-up incorrectly documented parameter
      scsi: lpfc: Remove unused variable 'pg_addr'
      scsi: qla4xxx: Move 'qla4_82xx_reg_tbl' to the only place its used
      scsi: pm8001: Remove a bunch of set but unused variables
      scsi: pm8001: Fix some function documentation issues
      scsi: pm8001: Fix a bunch of kerneldoc issues
      scsi: aic7xxx: Remove set but unused variables 'targ_info' and 'value'
      scsi: qla4xxx: Move 'qla4_83xx_reg_tbl' from shared header
      scsi: qla4xxx: Check return value of pci_set_mwi()
      scsi: qla4xxx: Remove set but unused variable 'func_number'
      scsi: pm8001: Add descriptions for unused 'attr' function parameters
      scsi: pm8001: Move function header and supply some missing parameter descriptions
      scsi: aic94xx: Fix kerneldoc formatting issue with 'task'
      scsi: aacraid: Add descriptions for missing parameters
      scsi: aic94xx: Fix a couple of kerneldoc formatting issues
      scsi: aacraid: Add missing description for 'dev'
      scsi: aacraid: Add missing description for 'dev'
      scsi: aacraid: Add descriptions for missing parameters
      scsi: aic7xxx: aic79xx_core: Remove a bunch of unused variables
      scsi: arcmsr: arcmsr_hba: Remove statement with no effect
      scsi: aic7xxx: Fix 'amount_xferred' set but not used issue
      scsi: aic7xxx: Remove unused variables 'wait' and 'paused'
      scsi: aic7xxx: Remove unused variable 'ahd'
      scsi: lpfc: Correct some pretty obvious misdocumentation
      scsi: be2iscsi: Add missing function parameter description
      scsi: be2iscsi: Fix misdocumentation of 'pcontext'
      scsi: be2iscsi: Fix API/documentation slip
      scsi: myrs: Demote obvious misuse of kerneldoc to standard comment blocks
      scsi: ipr: Fix struct packed-not-aligned issues
      scsi: ipr: Remove a bunch of set but checked variables
      scsi: virtio_scsi: Demote seemingly unintentional kerneldoc header
      scsi: ipr: Fix a mountain of kerneldoc misdemeanours
      scsi: pm8001: Provide descriptions for the many undocumented 'attr's
      scsi: aacraid: Fill in the very parameter descriptions for rx_sync_cmd()
      scsi: aic94xx: Fix a couple of formatting and bitrot issues
      scsi: aacraid: Fix a bunch of function header issues
      scsi: aic94xx: Document 'lseq' and repair asd_update_port_links() header
      scsi: aacraid: Demote partially documented function header
      scsi: aacraid: Remove unused variable 'status'
      scsi: aacraid: Fix logical bug when !DBG
      scsi: aacraid: Fix a few kerneldoc issues
      scsi: aacraid: Repair two kerneldoc headers
      scsi: qla4xxx: Provide a missing function param description and fix formatting
      scsi: aacraid: Fix a bunch of function doc formatting errors
      scsi: aic94xx: Repair kerneldoc formatting error and remove extra param
      scsi: pm8001: Demote obvious misuse of kerneldoc and update others
      scsi: aic94xx: Demote seemingly unintentional kerneldoc header
      scsi: aacraid: Fix a couple of small kerneldoc issues
      scsi: aacraid: Provide suggested curly braces around empty body of if()
      scsi: qedf: Demote obvious misuse of kerneldoc to standard comment blocks
      scsi: aic7xxx: Fix 'amount_xferred' set but not used issue
      scsi: aic7xxx: Remove unused variable 'targ'
      scsi: aic7xxx: Remove unused variable 'ahc'
      scsi: aic7xxx: Remove unused variable 'tinfo'
      scsi: bnx2fc: Demote obvious misuse of kerneldoc to standard comment blocks
      scsi: qedf: Remove a whole host of unused variables
      scsi: arcmsr: Remove some set but unused variables
      scsi: bnx2fc: Fix a couple of bitrotted function documentation headers
      scsi: libfc: Provide missing and repair existing function documentation
      scsi: libfc: Fix a couple of misdocumented function parameters
      scsi: libfc: Repair function parameter documentation
      scsi: qedf: Remove set but not checked variable 'tmp'
      scsi: qedf: Demote obvious misuse of kerneldoc to standard comment blocks
      scsi: bnx2fc: Repair a range of kerneldoc issues
      scsi: fcoe: Correct some kernel-doc issues
      scsi: fcoe: Fix a myriad of documentation issues
      scsi: fcoe: Fix various kernel-doc infringements
      scsi: libfc: trivial: Fix spelling mistake of 'discovery'
      scsi: scsi_transport_fc: Match HBA Attribute Length with HBAAPI V2.0 definitions
      scsi: libfc: Supply some missing kerneldoc struct/function attributes/params
      scsi: libfc: fc_disc: Fix-up some incorrectly referenced function parameters
      scsi: pcmcia: nsp_cs: Remove unused variable 'dummy'
      scsi: pcmcia: nsp_cs: Use new __printf() format notation
      scsi: aha152x: Remove unused variable 'ret'
      scsi: fdomain: Mark 'fdomain_pm_ops' as __maybe_unused

Liao Pingfang (2):
      scsi: ppa: Remove superfluous breaks
      scsi: imm: Remove superfluous breaks

Luo Jiaxing (3):
      scsi: libsas: Check link status in ATA prereset()
      scsi: libsas: Remove postreset from sas_sata_ops
      scsi: hisi_sas: Directly trigger SCSI error handling for completion errors

Maxim Levitsky (1):
      scsi: virtio-scsi: Correctly handle the case where all LUNs are unplugged

Miaohe Lin (2):
      scsi: fcoe: Use eth_zero_addr() to clear mac address
      scsi: fnic: Use eth_broadcast_addr() to assign broadcast address

Mike Christie (10):
      scsi: target: Handle short iSIDs
      scsi: target: Fix iscsi transport id buf len calculation
      scsi: target: Fix iscsi transport id buffer setup
      scsi: target: Fix iscsi transport id parsing
      scsi: target: Fix crash during SPEC_I_PT handling
      scsi: target: Fix xcopy sess release leak
      scsi: target: Check enforce_pr_isids during registration
      scsi: iscsi: Remove sessdestroylist
      scsi: iscsi: Optimize work queue flush use
      scsi: iscsi: Delay freeing target_id

Randy Dunlap (2):
      scsi: scsi_transport_iscsi: Drop a duplicated word
      scsi: advansys: docs: Eliminate duplicated word

Satya Tangirala (3):
      scsi: ufs: Add inline encryption support to UFS
      scsi: ufs: UFS crypto API
      scsi: ufs: UFS driver v2.1 spec crypto additions

Shyam Sundar (3):
      scsi: qla2xxx: Address a set of sparse warnings
      scsi: qla2xxx: SAN congestion management implementation
      scsi: qla2xxx: Change in PUREX to handle FPIN ELS requests

Stanley Chu (18):
      scsi: ufs-mediatek: Apply DELAY_AFTER_LPM quirk to Micron devices
      scsi: ufs: Introduce device quirk "DELAY_AFTER_LPM"
      scsi: ufs-mediatek: Prevent LPM operation on undeclared VCC
      scsi: ufs-mediatek: Add inline encryption support
      scsi: ufs: Fix and simplify setup_xfer_req variant operation
      scsi: ufs: Simplify completion timestamp for SCSI and query commands
      scsi: ufs: Disable WriteBooster capability for non-supported UFS devices
      scsi: ufs-mediatek: Make ufs_mtk_wait_link_state static
      scsi: ufs: Fix imprecise load calculation in devfreq window
      scsi: ufs: Add trace event for UIC commands
      scsi: ufs: Remove unused field in struct uic_command
      scsi: ufs: Clean up device vendor name and device quirk table
      scsi: ufs: Add DELAY_BEFORE_LPM quirk for Micron devices
      scsi: ufs-mediatek: Allow unbound mphy
      scsi: ufs-mediatek: Fix unbalanced clock on/off
      scsi: ufs-mediatek: Introduce low-power mode for device power supply
      scsi: ufs-mediatek: Do not gate clocks if auto-hibern8 is not entered yet
      scsi: ufs-mediatek: Fix imprecise waiting time for ref-clk control

Tomas Henzl (1):
      scsi: megaraid_sas: Clear affinity hint

Varun Prakash (5):
      scsi: libcxgbi: Remove unnecessary NULL checks for 'tdata' pointer
      scsi: cxgb4i: Remove an unnecessary NULL check for 'cconn' pointer
      scsi: target: cxgbit: Remove tx flow control code
      scsi: target: cxgbit: Check connection state before issuing hardware command
      scsi: cxgb4i: Add support for iSCSI segmentation offload

Wang Hai (1):
      scsi: dpt_i2o: Remove superfluous memset()

Wei Yongjun (2):
      scsi: target: Remove unused variable 'tpg'
      scsi: ufs: ufs-exynos: Fix return value check in exynos_ufs_init()

Xianting Tian (1):
      scsi: virtio_scsi: Remove unnecessary condition check

Xiongfeng Wang (1):
      scsi: scsi_transport_sas: Add missing newline in sysfs 'enable' attribute

Ye Bin (2):
      scsi: core: Delete unnecessary buffer allocation for every loop iteration
      scsi: core: Add missing scsi_device_put() in scsi_host_block()

YueHaibing (1):
      scsi: sd_zbc: Remove unused inline functions

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs  |  136 +++
 Documentation/scsi/advansys.rst             |    2 +-
 Documentation/scsi/scsi-parameters.rst      |    2 +-
 MAINTAINERS                                 |    2 +-
 block/blk-pm.c                              |   41 +-
 drivers/firmware/qcom_scm.c                 |  101 +++
 drivers/firmware/qcom_scm.h                 |    4 +
 drivers/s390/scsi/zfcp_ccw.c                |    7 +-
 drivers/s390/scsi/zfcp_erp.c                |    2 +-
 drivers/s390/scsi/zfcp_fc.c                 |    2 +-
 drivers/s390/scsi/zfcp_qdio.c               |    7 +-
 drivers/scsi/Kconfig                        |   16 +-
 drivers/scsi/aacraid/aachba.c               |   22 +-
 drivers/scsi/aacraid/commctrl.c             |   14 +-
 drivers/scsi/aacraid/commsup.c              |   12 +-
 drivers/scsi/aacraid/dpcsup.c               |   15 +-
 drivers/scsi/aacraid/linit.c                |    6 +-
 drivers/scsi/aacraid/nark.c                 |    1 +
 drivers/scsi/aacraid/rkt.c                  |    5 +-
 drivers/scsi/aacraid/rx.c                   |   12 +-
 drivers/scsi/aacraid/sa.c                   |   19 +-
 drivers/scsi/aacraid/src.c                  |   13 +-
 drivers/scsi/aha152x.c                      |    3 +-
 drivers/scsi/aic7xxx/aic79xx_core.c         |   20 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c          |   33 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c          |   13 +-
 drivers/scsi/aic94xx/aic94xx_dev.c          |    4 +-
 drivers/scsi/aic94xx/aic94xx_hwi.c          |    3 +-
 drivers/scsi/aic94xx/aic94xx_init.c         |    2 +-
 drivers/scsi/aic94xx/aic94xx_scb.c          |    6 +-
 drivers/scsi/aic94xx/aic94xx_seq.c          |    6 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c          |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c            |   18 +-
 drivers/scsi/arm/cumana_2.c                 |    2 +-
 drivers/scsi/arm/eesox.c                    |    2 +-
 drivers/scsi/arm/powertec.c                 |    2 +-
 drivers/scsi/be2iscsi/be_iscsi.c            |   11 +-
 drivers/scsi/be2iscsi/be_main.c             |    4 +-
 drivers/scsi/be2iscsi/be_mgmt.c             |    3 +-
 drivers/scsi/bfa/bfa_core.c                 |    2 +-
 drivers/scsi/bfa/bfa_fcpim.c                |   10 +-
 drivers/scsi/bfa/bfa_fcs_rport.c            |    3 -
 drivers/scsi/bfa/bfa_ioc.c                  |   57 +-
 drivers/scsi/bfa/bfa_ioc_ct.c               |    6 +-
 drivers/scsi/bfa/bfa_port.c                 |    4 +-
 drivers/scsi/bfa/bfa_svc.c                  |    4 +-
 drivers/scsi/bfa/bfad_bsg.c                 |  222 ++---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |   18 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c            |   22 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c            |    7 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c              |   53 +-
 drivers/scsi/bnx2i/bnx2i_init.c             |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c            |   19 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c            |    4 +
 drivers/scsi/csiostor/csio_hw.c             |    2 +-
 drivers/scsi/csiostor/csio_hw_t5.c          |    6 +-
 drivers/scsi/csiostor/csio_init.c           |    2 +-
 drivers/scsi/csiostor/csio_lnode.c          |    3 +-
 drivers/scsi/csiostor/csio_rnode.c          |    2 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c          |   17 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c          |  242 +++--
 drivers/scsi/cxgbi/libcxgbi.c               |  672 ++++++++++----
 drivers/scsi/cxgbi/libcxgbi.h               |   46 +-
 drivers/scsi/dpt_i2o.c                      |    4 -
 drivers/scsi/esas2r/esas2r.h                |    3 +-
 drivers/scsi/esas2r/esas2r_log.c            |   10 +-
 drivers/scsi/fcoe/fcoe.c                    |   10 +-
 drivers/scsi/fcoe/fcoe_ctlr.c               |   30 +-
 drivers/scsi/fcoe/fcoe_transport.c          |    4 +-
 drivers/scsi/fdomain.h                      |    2 +-
 drivers/scsi/fnic/fnic_scsi.c               |    3 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c      |    4 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |    6 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |    4 +-
 drivers/scsi/hosts.c                        |    8 +-
 drivers/scsi/hpsa.c                         |   35 +-
 drivers/scsi/hpsa.h                         |    2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c            |    2 +-
 drivers/scsi/imm.c                          |    3 -
 drivers/scsi/ipr.c                          |   90 +-
 drivers/scsi/ipr.h                          |    4 +-
 drivers/scsi/ips.c                          |   34 +-
 drivers/scsi/isci/request.c                 |    2 +-
 drivers/scsi/libfc/fc_disc.c                |    6 +-
 drivers/scsi/libfc/fc_exch.c                |    7 +-
 drivers/scsi/libfc/fc_fcp.c                 |   11 +-
 drivers/scsi/libfc/fc_lport.c               |    7 +-
 drivers/scsi/libfc/fc_rport.c               |    4 +-
 drivers/scsi/libsas/sas_ata.c               |   17 +-
 drivers/scsi/libsas/sas_expander.c          |    2 +-
 drivers/scsi/lpfc/lpfc.h                    |   15 +
 drivers/scsi/lpfc/lpfc_bsg.c                |   35 +-
 drivers/scsi/lpfc/lpfc_bsg.h                |   14 +
 drivers/scsi/lpfc/lpfc_crtn.h               |    2 +-
 drivers/scsi/lpfc/lpfc_ct.c                 |   26 +-
 drivers/scsi/lpfc/lpfc_els.c                |  143 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c            |  231 ++---
 drivers/scsi/lpfc/lpfc_hw4.h                |    5 +-
 drivers/scsi/lpfc/lpfc_init.c               |  739 +++++++++------
 drivers/scsi/lpfc/lpfc_logmsg.h             |   24 +-
 drivers/scsi/lpfc/lpfc_mbox.c               |   12 +-
 drivers/scsi/lpfc/lpfc_mem.c                |    4 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c          |   68 +-
 drivers/scsi/lpfc/lpfc_nvme.c               |  110 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c              |   96 +-
 drivers/scsi/lpfc/lpfc_scsi.c               |  125 +--
 drivers/scsi/lpfc/lpfc_sli.c                |  683 ++++++++------
 drivers/scsi/lpfc/lpfc_sli4.h               |   18 +
 drivers/scsi/lpfc/lpfc_version.h            |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c              |   86 +-
 drivers/scsi/megaraid.c                     |  222 +++--
 drivers/scsi/megaraid/megaraid_mbox.c       |    4 +-
 drivers/scsi/megaraid/megaraid_mm.c         |    1 -
 drivers/scsi/megaraid/megaraid_sas.h        |   20 +
 drivers/scsi/megaraid/megaraid_sas_base.c   |  184 ++--
 drivers/scsi/megaraid/megaraid_sas_fp.c     |   11 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   93 +-
 drivers/scsi/mesh.c                         |    8 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         |   14 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h         |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |    7 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |   16 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.h |    2 +-
 drivers/scsi/mvsas/mv_init.c                |    8 +-
 drivers/scsi/myrs.c                         |   34 +-
 drivers/scsi/pcmcia/nsp_cs.c                |    5 +-
 drivers/scsi/pm8001/pm8001_ctl.c            |   23 +-
 drivers/scsi/pm8001/pm8001_hwi.c            |   27 +-
 drivers/scsi/pm8001/pm8001_init.c           |   30 +-
 drivers/scsi/pm8001/pm8001_sas.c            |    9 +-
 drivers/scsi/pm8001/pm80xx_hwi.c            |   23 +-
 drivers/scsi/ppa.c                          |    3 -
 drivers/scsi/qedf/qedf_debugfs.c            |   18 +-
 drivers/scsi/qedf/qedf_io.c                 |   30 +-
 drivers/scsi/qedf/qedf_main.c               |   10 +-
 drivers/scsi/qedi/qedi_fw.c                 |    5 +-
 drivers/scsi/qedi/qedi_iscsi.c              |    2 +-
 drivers/scsi/qedi/qedi_main.c               |    9 +-
 drivers/scsi/qla2xxx/qla_bsg.c              |    3 +-
 drivers/scsi/qla2xxx/qla_dbg.c              |  111 +--
 drivers/scsi/qla2xxx/qla_dbg.h              |    1 +
 drivers/scsi/qla2xxx/qla_def.h              |   64 +-
 drivers/scsi/qla2xxx/qla_fw.h               |    8 +-
 drivers/scsi/qla2xxx/qla_gbl.h              |    4 +-
 drivers/scsi/qla2xxx/qla_init.c             |   48 +-
 drivers/scsi/qla2xxx/qla_inline.h           |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c             |   10 +-
 drivers/scsi/qla2xxx/qla_isr.c              |  290 +++++-
 drivers/scsi/qla2xxx/qla_mbx.c              |   64 +-
 drivers/scsi/qla2xxx/qla_nx.c               |   20 +-
 drivers/scsi/qla2xxx/qla_os.c               |   37 +-
 drivers/scsi/qla2xxx/qla_target.h           |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c          |    1 +
 drivers/scsi/qla4xxx/ql4_83xx.c             |   34 +-
 drivers/scsi/qla4xxx/ql4_83xx.h             |   17 -
 drivers/scsi/qla4xxx/ql4_bsg.c              |    4 +-
 drivers/scsi/qla4xxx/ql4_init.c             |   13 +-
 drivers/scsi/qla4xxx/ql4_iocb.c             |    2 +-
 drivers/scsi/qla4xxx/ql4_isr.c              |    6 +-
 drivers/scsi/qla4xxx/ql4_mbx.c              |    7 +-
 drivers/scsi/qla4xxx/ql4_nx.c               |   18 +-
 drivers/scsi/qla4xxx/ql4_nx.h               |   17 -
 drivers/scsi/qla4xxx/ql4_os.c               |   58 +-
 drivers/scsi/scsi.c                         |    3 -
 drivers/scsi/scsi_debug.c                   |  500 +++++++----
 drivers/scsi/scsi_lib.c                     |   62 +-
 drivers/scsi/scsi_logging.c                 |    8 +-
 drivers/scsi/scsi_pm.c                      |   10 +-
 drivers/scsi/scsi_priv.h                    |    1 -
 drivers/scsi/scsi_transport_iscsi.c         |   31 +-
 drivers/scsi/scsi_transport_sas.c           |    2 +-
 drivers/scsi/scsi_transport_srp.c           |   12 +-
 drivers/scsi/sd.c                           |    2 +-
 drivers/scsi/sd.h                           |    6 -
 drivers/scsi/sd_zbc.c                       |    3 +-
 drivers/scsi/storvsc_drv.c                  |   13 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |    1 +
 drivers/scsi/sym53c8xx_2/sym_hipd.c         |    8 +
 drivers/scsi/ufs/Kconfig                    |   22 +
 drivers/scsi/ufs/Makefile                   |    6 +-
 drivers/scsi/ufs/ufs-exynos.c               | 1297 +++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h               |  287 ++++++
 drivers/scsi/ufs/ufs-mediatek.c             |  140 ++-
 drivers/scsi/ufs/ufs-mediatek.h             |    4 +-
 drivers/scsi/ufs/ufs-qcom-ice.c             |  245 +++++
 drivers/scsi/ufs/ufs-qcom.c                 |   21 +-
 drivers/scsi/ufs/ufs-qcom.h                 |   27 +
 drivers/scsi/ufs/ufs.h                      |   38 +-
 drivers/scsi/ufs/ufs_bsg.c                  |    5 +-
 drivers/scsi/ufs/ufs_quirks.h               |   10 +-
 drivers/scsi/ufs/ufshcd-crypto.c            |  245 +++++
 drivers/scsi/ufs/ufshcd-crypto.h            |   77 ++
 drivers/scsi/ufs/ufshcd-pci.c               |   25 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c            |   27 +-
 drivers/scsi/ufs/ufshcd.c                   |  541 +++++------
 drivers/scsi/ufs/ufshcd.h                   |  105 ++-
 drivers/scsi/ufs/ufshci.h                   |   94 +-
 drivers/scsi/ufs/unipro.h                   |   33 +
 drivers/scsi/virtio_scsi.c                  |   22 +-
 drivers/target/iscsi/cxgbit/cxgbit.h        |    1 -
 drivers/target/iscsi/cxgbit/cxgbit_cm.c     |   34 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c |   24 +-
 drivers/target/iscsi/iscsi_target_nego.c    |   36 +-
 drivers/target/target_core_fabric_lib.c     |  105 ++-
 drivers/target/target_core_internal.h       |    1 +
 drivers/target/target_core_pr.c             |   61 +-
 drivers/target/target_core_tmr.c            |   36 +-
 drivers/target/target_core_transport.c      |    8 +-
 drivers/target/target_core_user.c           |  397 ++++++--
 drivers/target/target_core_xcopy.c          |   11 +-
 include/linux/qcom_scm.h                    |   19 +
 include/scsi/fc/fc_ms.h                     |    4 +-
 include/scsi/scsi_tcq.h                     |    2 +-
 include/scsi/scsi_transport_iscsi.h         |    2 +-
 include/target/iscsi/iscsi_target_core.h    |    9 +-
 include/target/target_core_backend.h        |    2 +
 include/target/target_core_base.h           |    1 +
 include/trace/events/ufs.h                  |   31 +
 include/uapi/linux/target_core_user.h       |   25 +
 include/uapi/scsi/fc/fc_els.h               |    2 +
 221 files changed, 7777 insertions(+), 3384 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-exynos.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos.h
 create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.c
 create mode 100644 drivers/scsi/ufs/ufshcd-crypto.h

James

