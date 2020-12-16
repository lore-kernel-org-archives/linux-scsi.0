Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D92DAC4361B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 16:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9345C233EA
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 16:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgLPQkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 11:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgLPQkC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2020 11:40:02 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FAFC0617A6;
        Wed, 16 Dec 2020 08:39:22 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id CE916128007B;
        Wed, 16 Dec 2020 08:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1608136761;
        bh=+M/owata3KugAkwN8++mDOWxAlcbYg6Hv0yylBg5VhE=;
        h=Message-ID:Subject:From:To:Date:From;
        b=AnTIeky1j08mR2r3PE1jGgggy6vWo/a2j2LIUXOK93RJS/AbhLuRcIbqOsrKbkXdP
         4MV3KVuZWilzPOi6YoaOXQ0qN8TAOpiPOgMdTkgtaSluhgleMj97zVd5B7xsaL1OpK
         YIgUrO5nBgeV9PCPg+qtRNNdIFlKWA8XrPbdcthw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eALu-XjCXpip; Wed, 16 Dec 2020 08:39:21 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 648161280078;
        Wed, 16 Dec 2020 08:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1608136761;
        bh=+M/owata3KugAkwN8++mDOWxAlcbYg6Hv0yylBg5VhE=;
        h=Message-ID:Subject:From:To:Date:From;
        b=AnTIeky1j08mR2r3PE1jGgggy6vWo/a2j2LIUXOK93RJS/AbhLuRcIbqOsrKbkXdP
         4MV3KVuZWilzPOi6YoaOXQ0qN8TAOpiPOgMdTkgtaSluhgleMj97zVd5B7xsaL1OpK
         YIgUrO5nBgeV9PCPg+qtRNNdIFlKWA8XrPbdcthw=
Message-ID: <3d7eb46bcb309d17fe1c136c7d17154c5ec482b5.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.10+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 16 Dec 2020 08:39:20 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series consists of the usual driver updates (ufs, qla2xxx,
smartpqi, target, zfcp, fnic, mpt3sas, ibmvfc) plus a load of cleanups,
a major power management rework and a load of assorted minor updates. 
There are a few core updates (formatting fixes being the big one) but
nothing major this cycle.

We've got one obvious conflict in qla_nvme.c which is due to us having
the same patch (with different commit ids) in upstream and our pull
request ("scsi: qla2xxx: Return EBUSY on fcport deletion").

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (2):
      scsi: ufs: Allow an error return value from ->device_reset()
      scsi: ufs: Add DeepSleep feature

Ahmed S. Darwish (12):
      scsi: NCR5380: Remove context check
      scsi: myrs: Remove WARN_ON(in_interrupt())
      scsi: myrb: Remove WARN_ON(in_interrupt())
      scsi: mpt3sas: Remove in_interrupt()
      scsi: qla4xxx: Remove in_interrupt() from qla4_82xx_rom_lock()
      scsi: qla4xxx: Remove in_interrupt() from qla4_82xx_idc_lock()
      scsi: qla2xxx: Remove in_interrupt() from qla83xx-specific code
      scsi: target: tcm_qla2xxx: Remove BUG_ON(in_interrupt())
      scsi: qla2xxx: Remove in_interrupt() from qla82xx-specific code
      scsi: qla4xxx: Remove in_interrupt()
      scsi: hisi_sas: Remove preemptible()
      scsi: pm80xx: Do not sleep in atomic context

Arnd Bergmann (7):
      scsi: ufs: Fix -Wsometimes-uninitialized warning
      scsi: megaraid_sas: Simplify compat_ioctl handling
      scsi: megaraid_sas: Check user-provided offsets
      scsi: aacraid: Improve compat_ioctl handlers
      scsi: libfc: Fix enum-conversion warning
      scsi: libfc: Work around -Warray-bounds warning
      scsi: libfc: Move scsi/fc_encode.h to libfc

Arun Easi (5):
      scsi: qla2xxx: Fix device loss on 4G and older HBAs
      scsi: qla2xxx: Fix flash update in 28XX adapters on big endian machines
      scsi: qla2xxx: Fix FW initialization error on big endian machines
      scsi: qla2xxx: Fix crash during driver load on big endian machines
      scsi: qla2xxx: Fix compilation issue in PPC systems

Asutosh Das (1):
      scsi: ufs: qcom: Enable aggressive power collapse for ufs HBA

Bean Huo (1):
      scsi: ufs: Remove unnecessary if condition in ufshcd_suspend()

Bjorn Andersson (1):
      scsi: ufs: Adjust logic in common ADAPT helper

Bodo Stroesser (1):
      scsi: target: tcmu: scatter_/gather_data_area() rework

Can Guo (7):
      scsi: ufs: Print host regs in IRQ handler when AH8 error happens
      scsi: ufs: Fix a race condition between ufshcd_abort() and eh_work()
      scsi: ufs: Serialize eh_work with system PM events and async scan
      scsi: ufs: Stop hardcoding the scale down gear
      scsi: ufs-qcom: Keep core_clk_unipro on while link is active
      scsi: ufs: Refactor ufshcd_setup_clocks() to remove skip_ref_clk
      scsi: ufs: Put HBA into LPM during clk gating

Colin Ian King (5):
      scsi: qla4xxx: Remove redundant assignment to variable rval
      scsi: pm8001: Remove space in a debug message
      scsi: lpfc: Fix memory leak on lcb_context
      scsi: lpfc: Remove dead code on second !ndlp check
      scsi: lpfc: Fix pointer defereference before it is null checked issue

Daniel Wagner (1):
      scsi: qla2xxx: Return EBUSY on fcport deletion

David Disseldorp (4):
      scsi: target: Return COMPARE AND WRITE miscompare offsets
      scsi: target: Split out COMPARE AND WRITE memcmp into helper
      scsi: target: Rename cmd.bad_sector to cmd.sense_info
      scsi: target: Rename struct sense_info to sense_detail

Don Brace (3):
      scsi: smartpqi: Update version to 1.2.16-012
      scsi: smartpqi: Correct pqi_sas_smp_handler busy condition
      scsi: smartpqi: Correct driver removal with HBA disks

Eric Biggers (1):
      scsi: ufs-qcom: Only select QCOM_SCM if SCSI_UFS_CRYPTO

Finn Thain (2):
      scsi: NCR5380: Reduce NCR5380_maybe_release_dma_irq() call sites
      scsi: atari_scsi: Fix race condition between .queuecommand and EH

Gustavo A. R. Silva (9):
      scsi: target: core: Fix fall-through warnings for Clang
      scsi: stex: Fix fall-through warnings for Clang
      scsi: lpfc: Fix fall-through warnings for Clang
      scsi: csiostor: Fix fall-through warnings for Clang
      scsi: aha1740: Fix fall-through warnings for Clang
      scsi: aacraid: Fix fall-through warnings for Clang
      scsi: bfa: Fix fall-through warnings for Clang
      scsi: aic94xx: Fix fall-through warnings for Clang
      scsi: aic7xxx: Fix fall-through warnings for Clang

Hannes Reinecke (4):
      scsi: core: Return BLK_STS_AGAIN for ALUA transitioning
      scsi: scsi_dh_alua: Set 'transitioning' state on Unit Attention
      scsi: scsi_dh_alua: Return BLK_STS_AGAIN for ALUA transitioning state
      scsi: block: Return status code in blk_mq_end_request()

Jaegeuk Kim (6):
      scsi: ufs: Fix clkgating on/off
      scsi: ufs: Add more contexts in the ufs tracepoints
      scsi: ufs: Use WQ_HIGHPRI for gating work
      scsi: ufs: Clear UAC for FFU and RPMB LUNs
      scsi: ufs: Atomic update for clkgating_enable
      scsi: ufs: Avoid to call REQ_CLKS_OFF to CLKS_OFF

James Smart (32):
      scsi: lpfc: Correct null ndlp reference on routine exit
      scsi: lpfc: Fix variable 'vport' set but not used in lpfc_sli4_abts_err_handler()
      scsi: lpfc: Fix missing prototype for lpfc_nvmet_prep_abort_wqe()
      scsi: lpfc: Fix set but unused variables in lpfc_dev_loss_tmo_handler()
      scsi: lpfc: Fix set but not used warnings from Rework remote port lock handling
      scsi: lpfc: Fix missing prototype warning for lpfc_fdmi_vendor_attr_mi()
      scsi: lpfc: Update changed file copyrights for 2020
      scsi: lpfc: Update lpfc version to 12.8.0.6
      scsi: lpfc: Convert abort handling to SLI-3 and SLI-4 handlers
      scsi: lpfc: Convert SCSI I/O completions to SLI-3 and SLI-4 handlers
      scsi: lpfc: Convert SCSI path to use common I/O submission path
      scsi: lpfc: Enable common send_io interface for SCSI and NVMe
      scsi: lpfc: Enable common wqe_template support for both SCSI and NVMe
      scsi: lpfc: Refactor WQE structure definitions for common use
      scsi: lpfc: Fix NPIV Fabric Node reference counting
      scsi: lpfc: Fix NPIV discovery and Fabric Node detection
      scsi: lpfc: Unsolicited ELS leaves node in incorrect state while dropping it
      scsi: lpfc: Remove ndlp when a PLOGI/ADISC/PRLI/REG_RPI ultimately fails
      scsi: lpfc: Rework remote port lock handling
      scsi: lpfc: Fix refcounting around SCSI and NVMe transport APIs
      scsi: lpfc: Fix removal of SCSI transport device get and put on dev structure
      scsi: lpfc: Rework locations of ndlp reference taking
      scsi: lpfc: Rework remote port ref counting and node freeing
      scsi: lpfc: Update lpfc version to 12.8.0.5
      scsi: lpfc: Reject CT request for MIB commands
      scsi: lpfc: Add FDMI Vendor MIB support
      scsi: lpfc: Enlarge max_sectors in scsi host templates
      scsi: lpfc: Fix duplicate wq_create_version check
      scsi: lpfc: Removed unused macros in lpfc_attr.c
      scsi: lpfc: Re-fix use after free in lpfc_rq_buf_free()
      scsi: lpfc: Fix scheduling call while in softirq context in lpfc_unreg_rpi
      scsi: lpfc: Fix invalid sleeping context in lpfc_sli4_nvmet_alloc()

Jing Xiangfeng (1):
      scsi: qla4xxx: Remove redundant assignment to variable rval

Joe Perches (4):
      scsi: pm8001: Fix misindentation
      scsi: pm8001: Convert pm8001_printk() to pm8001_info()
      scsi: pm8001: Make implicit use of pm8001_ha in pm8001_printk() explicit
      scsi: pm8001: Neaten debug logging macros and uses

John Garry (1):
      scsi: hisi_sas: Reduce some indirection in v3 hw driver

Julian Wiedmann (4):
      scsi: zfcp: Handle event-lost notification for Version Change events
      scsi: zfcp: Process Version Change events
      scsi: zfcp: Clarify & assert the stat_lock locking in zfcp_qdio_send()
      scsi: zfcp: Lift Input Queue tasklet from qdio

Kaixu Xia (1):
      scsi: bnx2fc: Fix comparison to bool warning

Karan Tilak Kumar (5):
      scsi: fnic: Validate io_req before others
      scsi: fnic: Set scsi_set_resid() only for underflow
      scsi: fnic: Change shost_printk() to FNIC_MAIN_DBG()
      scsi: fnic: Avoid looping in TRANS ETH on unload
      scsi: fnic: Change shost_printk() to FNIC_FCS_DBG()

Lee Jones (22):
      scsi: hpsa: Strip out a bunch of set but unused variables
      scsi: pm8001: Remove unused variable 'value'
      scsi: dc395x: Mark 's_stat2' as __maybe_unused
      scsi: dc395x: Remove a few unused variables
      scsi: advansys: Relocate or remove unused variables
      scsi: esas2r: esas2r_main: Demote non-conformant kernel-doc header
      scsi: lpfc: lpfc_nvmet: Fix-up some formatting and doc-rot issues
      scsi: esas2r: esas2r_int: Add brackets around potentially empty if()s
      scsi: lpfc: lpfc_nvme: Fix some kernel-doc related issues
      scsi: ufs: ufshcd: Fix some function doc-rot
      scsi: lpfc: lpfc_nvme: Remove unused variable 'phba'
      scsi: esas2r: esas2r_init: Place brackets around a potentially empty if()
      scsi: esas2r: esas2r_disc: Place brackets around a potentially empty if()
      scsi: lpfc: lpfc_bsg: Provide correct documentation for a bunch of functions
      scsi: lpfc: lpfc_debugfs: Fix a couple of function documentation issues
      scsi: lpfc: lpfc_attr: Fix-up a bunch of kernel-doc misdemeanours
      scsi: lpfc: lpfc_attr: Demote kernel-doc format for redefined functions
      scsi: lpfc: lpfc_scsi: Fix a whole host of kernel-doc issues
      scsi: mpt3sas: mpt3sas_scsih: Fix function documentation formatting
      scsi: aic7xxx: aic79xx_osm: Remove unused variable 'saved_scsiid'
      scsi: pm8001: pm8001_sas: Fix strncpy() warning when space is not left for NUL
      scsi: arcmsr: Stop __builtin_strncpy complaining about a lack of space for NUL

Leo Liou (1):
      scsi: ufs: Show LBA and length for UNMAP commands

Luo Jiaxing (1):
      scsi: hisi_sas: Move debugfs code to v3 hw driver

Martin Wilck (2):
      scsi: core: Replace while-loop by for-loop in scsi_vpd_lun_id()
      scsi: core: Fix VPD LUN ID designator priorities

Mauro Carvalho Chehab (1):
      scsi: doc: Fix some kernel-doc markups

Mike Christie (9):
      scsi: MAINTAINERS: Make Bodo target_core_user maintainer
      scsi: tcm_loop: Allow queues, can_queue and cmd_per_lun to be settable
      scsi: target: Make state_list per CPU
      scsi: target: Drop sess_cmd_lock from I/O path
      scsi: qla2xxx: Move sess cmd list/lock to driver
      scsi: target: Remove TARGET_SCF_LOOKUP_LUN_FROM_TAG
      scsi: qla2xxx: Drop TARGET_SCF_LOOKUP_LUN_FROM_TAG
      scsi: target: Fix cmd_count ref leak
      scsi: target: Fix LUN ref count handling

Nick Desaulniers (1):
      scsi: core: Fix -Wformat for scsi_host

Nilesh Javali (1):
      scsi: qla2xxx: Update version to 10.02.00.104-k

Qinglang Miao (2):
      scsi: iscsi: Fix inappropriate use of put_device()
      scsi: qedi: Fix missing destroy_workqueue() on error in __qedi_probe

Quinn Tran (3):
      scsi: qla2xxx: Fix N2N and NVMe connect retry failure
      scsi: qla2xxx: Tear down session if FW say it is down
      scsi: qla2xxx: Limit interrupt vectors to number of CPUs

Saurav Kashyap (5):
      scsi: qla2xxx: If fcport is undergoing deletion complete I/O with retry
      scsi: qla2xxx: Fix the call trace for flush workqueue
      scsi: qla2xxx: Handle aborts correctly for port undergoing deletion
      scsi: qla2xxx: Don't check for fw_started while posting NVMe command
      scsi: qla2xxx: Change post del message from debug level to log level

Sebastian Andrzej Siewior (1):
      scsi: message: fusion: Remove in_interrupt() usage in mptsas_cleanup_fw_event_q()

Shyam Sundar (5):
      scsi: fc: Update documentation of sysfs nodes for FPIN stats
      scsi: fc: Add mechanism to update FPIN signal statistics
      scsi: fc: Parse FPIN packets and update statistics
      scsi: fc: Add FPIN statistics to fc_host and fc_rport objects
      scsi: fc: Update formal FPIN descriptor definitions

Sreekanth Reddy (14):
      scsi: mpt3sas: Bump driver version to 35.101.00.00
      scsi: mpt3sas: Add module parameter multipath_on_hba
      scsi: mpt3sas: Handle vSES vphy object during HBA reset
      scsi: mpt3sas: Add bypass_dirty_port_flag parameter
      scsi: mpt3sas: Handling HBA vSES device
      scsi: mpt3sas: Set valid PhysicalPort in SMPPassThrough
      scsi: mpt3sas: Update hba_port objects after host reset
      scsi: mpt3sas: Get sas_device objects using device's rphy
      scsi: mpt3sas: Rename transport_del_phy_from_an_existing_port()
      scsi: mpt3sas: Get device objects using sas_address & portID
      scsi: mpt3sas: Update hba_port's sas_address & phy_mask
      scsi: mpt3sas: Rearrange _scsih_mark_responding_sas_device()
      scsi: mpt3sas: Allocate memory for hba_port objects
      scsi: mpt3sas: Define hba_port structure

Stanley Chu (25):
      scsi: ufs: Remove pre-defined initial voltage values of device power
      scsi: ufs-dwc: Use phy_initialization helper
      scsi: ufs-cdns: Use phy_initialization helper
      scsi: ufs: Introduce phy_initialization helper
      scsi: ufs: Remove unused setup_regulators variant function
      scsi: ufs-mediatek: Introduce event_notify implementation
      scsi: ufs: Introduce event_notify variant function
      scsi: ufs: Refine error history functions
      scsi: ufs: Add error history for abort event in UFS Device W-LUN
      scsi: ufs: ufs-qcom: Use common ADAPT configuration function
      scsi: ufs: ufs-mediatek: Use common ADAPT configuration function
      scsi: ufs: Refactor ADAPT configuration function
      scsi: ufs: ufs-hisi: Use device parameter initialization function
      scsi: ufs: ufs-exynos: Use device parameter initialization function
      scsi: ufs: ufs-qcom: Use device parameter initialization function
      scsi: ufs: ufs-mediatek: Use device parameter initialization function
      scsi: ufs: Introduce device parameter initialization function
      scsi: ufs: ufs-mediatek: Refactor performance scaling functions
      scsi: ufs: Add retry flow for failed HBA enabling
      scsi: ufs-mediatek: Add HS-G4 support
      scsi: ufs: Add enums for UniPro version higher than 1.6
      scsi: ufs-mediatek: Support option to disable auto-hibern8
      scsi: ufs-mediatek: Decouple features from platform bindings
      scsi: ufs-mediatek: Support VA09 regulator operations
      scsi: ufs-mediatek: Assign arguments with correct type

Suganath Prabu S (8):
      scsi: mpt3sas: Update driver version to 36.100.00.00
      scsi: mpt3sas: Handle trigger page after firmware update
      scsi: mpt3sas: Add persistent MPI trigger page
      scsi: mpt3sas: Add persistent SCSI sense trigger page
      scsi: mpt3sas: Add persistent Event trigger page
      scsi: mpt3sas: Add persistent Master trigger page
      scsi: mpt3sas: Add persistent trigger pages support
      scsi: mpt3sas: Sync time periodically between driver and firmware

Thomas Gleixner (1):
      scsi: message: fusion: Remove in_interrupt() usage in mpt_config()

Tom Rix (5):
      scsi: qla2xxx: Remove trailing semicolon in macro definition
      scsi: fcoe: Remove unneeded semicolon
      scsi: bnx2fc: Remove unneeded semicolon
      scsi: message: fusion: Remove unneeded break
      scsi: Remove unneeded break statements

Tyrel Datwyler (9):
      scsi: ibmvfc: Advertise client support for targetWWPN using v2 commands
      scsi: ibmvfc: Add support for target_wwpn field in v2 MADs and vfcFrame
      scsi: ibmvfc: Add FC payload retrieval routines for versioned vfcFrames
      scsi: ibmvfc: Add helper for testing capability flags
      scsi: ibmvfc: Add new fields for version 2 of several MADs
      scsi: ibmvfc: Deduplicate common ibmvfc_cmd init code
      scsi: ibmvfc: Use correlation token to tag commands
      scsi: ibmvfc: Remove trailing semicolon
      scsi: ibmvfc: Byte swap login_buf.resp values in attribute show functions

Vaibhav Gupta (30):
      scsi: pmcraid: Use generic power management
      scsi: pmcraid: Drop PCI Wakeup calls from .resume
      scsi: mvumi: Update function description
      scsi: mvumi: Use generic power management
      scsi: mvumi: Drop PCI Wakeup calls from .resume
      scsi: 3w-sas: Use generic power management
      scsi: 3w-sas: Drop PCI Wakeup calls from .resume
      scsi: 3w-9xxx: Use generic power management
      scsi: 3w-9xxx: Drop PCI Wakeup calls from .resume
      scsi: hpsa: Use generic power management
      scsi: pm_8001: Use generic power management
      scsi: pm_8001: Drop PCI Wakeup calls from .resume
      scsi: lpfc: Use generic power management
      scsi: mpt3sas_scsih: Use generic power management
      scsi: mpt3sas_scsih: Drop PCI Wakeup calls from .resume
      scsi: hisi_sas_v3_hw: Remove extra function calls for runtime pm
      scsi: hisi_sas_v3_hw: Don't use PCI helper functions
      scsi: hisi_sas_v3_hw: Drop PCI Wakeup calls from .resume
      scsi: esas2r: Use generic power management
      scsi: esas2r: Drop PCI Wakeup calls from .resume
      scsi: arcmsr: Use generic power management
      scsi: arcmsr: Drop PCI wakeup calls from .resume
      scsi: aic79xx: Use generic power management
      scsi: aic7xxx: Use generic power management
      scsi: aacraid: Use generic power management
      scsi: aacraid: Drop pci_enable_wake() from .resume
      scsi: megaraid_sas: Update function description
      scsi: megaraid_sas: Use generic power management
      scsi: megaraid_sas: Drop PCI wakeup calls from .resume
      scsi: isci: Don't use PCI helper functions

Vasily Gorbik (1):
      scsi: zfcp: Remove orphaned function declarations

Viswas G (1):
      scsi: pm80xx: Make running_req atomic

Xiang Chen (1):
      scsi: hisi_sas: Fix up probe error handling for v3 hw

Xu Wang (1):
      scsi: pm8001: Remove typecast for pointer returned by kcalloc()

Zhang Changzhong (1):
      scsi: fnic: Fix error return code in fnic_probe()

Zhang Qilong (1):
      scsi: pm80xx: Fix error return in pm8001_pci_probe()

Zou Wei (1):
      scsi: be2iscsi: Mark beiscsi_attrs with static keyword

akshatzen (1):
      scsi: pm80xx: Avoid busywait in FW ready check

ching Huang (2):
      scsi: arcmsr: Ensure getting a free ccb is done under the spin_lock
      scsi: arcmsr: Configure the default command timeout value

jintae jang (1):
      scsi: ufs: Adjust ufshcd_hold() during sending attribute requests

peter chang (1):
      scsi: pm80xx: Make mpi_build_cmd locking consistent

yuuzheng (1):
      scsi: pm80xx: Fix pm8001_mpi_get_nvmd_resp() race condition

And the diffstat:

 drivers/scsi/be2iscsi/be_main.c        | 4 ++--
 drivers/scsi/bnx2i/Kconfig             | 1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 6 ++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 5 +++++
 drivers/scsi/scsi_lib.c                | 3 +--
 drivers/scsi/storvsc_drv.c             | 5 -----
 6 files changed, 15 insertions(+), 9 deletions(-)
jejb@jarvis:~/git/scsi> gitdiffstat misc
 Documentation/ABI/testing/sysfs-class-fc_host      |   23 +
 .../ABI/testing/sysfs-class-fc_remote_ports        |   23 +
 MAINTAINERS                                        |    9 +
 block/blk-mq.c                                     |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |    6 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    2 +-
 drivers/message/fusion/mptbase.c                   |   15 +-
 drivers/message/fusion/mptfc.c                     |    2 +-
 drivers/message/fusion/mptsas.c                    |   45 +-
 drivers/message/fusion/mptsas.h                    |    1 +
 drivers/message/fusion/mptscsih.c                  |    2 +-
 drivers/message/fusion/mptspi.c                    |    2 +-
 drivers/s390/scsi/zfcp_aux.c                       |   11 +
 drivers/s390/scsi/zfcp_def.h                       |    1 +
 drivers/s390/scsi/zfcp_ext.h                       |    2 -
 drivers/s390/scsi/zfcp_fsf.c                       |   19 +
 drivers/s390/scsi/zfcp_fsf.h                       |   11 +
 drivers/s390/scsi/zfcp_qdio.c                      |   47 +
 drivers/s390/scsi/zfcp_qdio.h                      |    2 +
 drivers/scsi/3w-9xxx.c                             |   30 +-
 drivers/scsi/3w-sas.c                              |   32 +-
 drivers/scsi/NCR5380.c                             |   92 +-
 drivers/scsi/NCR5380.h                             |    3 +-
 drivers/scsi/aacraid/commctrl.c                    |   22 +-
 drivers/scsi/aacraid/commsup.c                     |    1 +
 drivers/scsi/aacraid/linit.c                       |   95 +-
 drivers/scsi/advansys.c                            |   16 +-
 drivers/scsi/aha1740.c                             |    1 +
 drivers/scsi/aic7xxx/aic79xx.h                     |   12 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |   12 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |    3 +-
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c             |   43 +-
 drivers/scsi/aic7xxx/aic79xx_pci.c                 |    6 +-
 drivers/scsi/aic7xxx/aic7xxx.h                     |   10 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |   10 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c             |   46 +-
 drivers/scsi/aic7xxx/aic7xxx_pci.c                 |    4 +-
 drivers/scsi/aic94xx/aic94xx_scb.c                 |    2 +
 drivers/scsi/aic94xx/aic94xx_task.c                |    3 +-
 drivers/scsi/arcmsr/arcmsr.h                       |    1 +
 drivers/scsi/arcmsr/arcmsr_hba.c                   |   55 +-
 drivers/scsi/atari_scsi.c                          |   10 +-
 drivers/scsi/be2iscsi/be_main.c                    |    2 +-
 drivers/scsi/be2iscsi/be_mgmt.c                    |    4 -
 drivers/scsi/bfa/bfa_fcs_lport.c                   |    2 +-
 drivers/scsi/bfa/bfa_ioc.c                         |    6 +-
 drivers/scsi/bnx2fc/bnx2fc.h                       |    1 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    6 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |    1 -
 drivers/scsi/csiostor/csio_wr.c                    |    1 +
 drivers/scsi/dc395x.c                              |   15 +-
 drivers/scsi/device_handler/scsi_dh_alua.c         |   10 +-
 drivers/scsi/esas2r/esas2r.h                       |    5 +-
 drivers/scsi/esas2r/esas2r_disc.c                  |    3 +-
 drivers/scsi/esas2r/esas2r_init.c                  |   53 +-
 drivers/scsi/esas2r/esas2r_int.c                   |    8 +-
 drivers/scsi/esas2r/esas2r_main.c                  |   11 +-
 drivers/scsi/fcoe/fcoe.c                           |    3 +-
 drivers/scsi/fcoe/fcoe_sysfs.c                     |    4 +-
 drivers/scsi/fnic/fnic.h                           |    3 +-
 drivers/scsi/fnic/fnic_fcs.c                       |   10 +-
 drivers/scsi/fnic/fnic_main.c                      |    3 +
 drivers/scsi/fnic/fnic_scsi.c                      |   17 +-
 drivers/scsi/g_NCR5380.c                           |   12 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |   28 -
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 1390 +---------------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 1295 ++++++++++++++-
 drivers/scsi/hpsa.c                                |   38 +-
 drivers/scsi/hptiop.c                              |    1 -
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  195 ++-
 drivers/scsi/ibmvscsi/ibmvfc.h                     |   28 +-
 drivers/scsi/ipr.c                                 |    1 -
 drivers/scsi/isci/init.c                           |   18 +-
 drivers/scsi/isci/phy.c                            |    2 -
 drivers/scsi/iscsi_tcp.c                           |    4 +-
 drivers/scsi/libfc/fc_elsct.c                      |    2 +-
 {include/scsi => drivers/scsi/libfc}/fc_encode.h   |   60 +-
 drivers/scsi/libfc/fc_exch.c                       |    3 +-
 drivers/scsi/libfc/fc_fcp.c                        |    2 +-
 drivers/scsi/libfc/fc_libfc.c                      |    2 +-
 drivers/scsi/libfc/fc_lport.c                      |    2 +-
 drivers/scsi/libfc/fc_rport.c                      |    2 +-
 drivers/scsi/libiscsi.c                            |    2 +-
 drivers/scsi/lpfc/lpfc.h                           |   15 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |   89 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |  139 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   18 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |  452 ++++-
 drivers/scsi/lpfc/lpfc_debugfs.c                   |   23 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |   47 +-
 drivers/scsi/lpfc/lpfc_els.c                       | 1298 ++++++++-------
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  797 +++------
 drivers/scsi/lpfc/lpfc_hw.h                        |    7 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |   22 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  290 ++--
 drivers/scsi/lpfc/lpfc_mem.c                       |   11 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  215 +--
 drivers/scsi/lpfc/lpfc_nvme.c                      |  381 ++---
 drivers/scsi/lpfc/lpfc_nvme.h                      |    4 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   77 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      | 1177 +++++++++----
 drivers/scsi/lpfc/lpfc_sli.c                       |  744 ++++++---
 drivers/scsi/lpfc/lpfc_sli.h                       |    7 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |   14 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    4 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |  128 +-
 drivers/scsi/mac_scsi.c                            |   10 +-
 drivers/scsi/megaraid/megaraid_sas.h               |    2 -
 drivers/scsi/megaraid/megaraid_sas_base.c          |  188 +--
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  437 ++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |  145 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c              |  760 +++++++++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 |    6 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               | 1285 +++++++++++++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |  312 +++-
 drivers/scsi/mpt3sas/mpt3sas_trigger_pages.h       |   94 ++
 drivers/scsi/mvumi.c                               |   50 +-
 drivers/scsi/myrb.c                                |    1 -
 drivers/scsi/myrs.c                                |    1 -
 drivers/scsi/pcmcia/nsp_cs.c                       |    2 -
 drivers/scsi/pm8001/pm8001_ctl.c                   |    7 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   | 1456 +++++++----------
 drivers/scsi/pm8001/pm8001_init.c                  |  164 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |  149 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |   47 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   | 1728 +++++++++-----------
 drivers/scsi/pm8001/pm80xx_hwi.h                   |    6 +
 drivers/scsi/pmcraid.c                             |   44 +-
 drivers/scsi/qedf/qedf.h                           |    1 -
 drivers/scsi/qedi/qedi_main.c                      |    4 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   10 +-
 drivers/scsi/qla2xxx/qla_gs.c                      |    8 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   77 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |   34 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   10 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   14 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |   27 +-
 drivers/scsi/qla2xxx/qla_nx2.c                     |    4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   53 +-
 drivers/scsi/qla2xxx/qla_sup.c                     |   10 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   24 +-
 drivers/scsi/qla2xxx/qla_target.h                  |    1 +
 drivers/scsi/qla2xxx/qla_tmpl.c                    |    9 +-
 drivers/scsi/qla2xxx/qla_tmpl.h                    |    2 +-
 drivers/scsi/qla2xxx/qla_version.h                 |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   72 +-
 drivers/scsi/qla4xxx/ql4_def.h                     |    4 +-
 drivers/scsi/qla4xxx/ql4_glbl.h                    |    1 -
 drivers/scsi/qla4xxx/ql4_nx.c                      |   95 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |    3 -
 drivers/scsi/scsi_devinfo.c                        |    3 +-
 drivers/scsi/scsi_lib.c                            |  149 +-
 drivers/scsi/scsi_sysfs.c                          |    2 +-
 drivers/scsi/scsi_transport_fc.c                   |  417 ++++-
 drivers/scsi/scsi_transport_iscsi.c                |    4 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   14 +-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c     |    1 -
 drivers/scsi/st.c                                  |    1 -
 drivers/scsi/stex.c                                |    1 +
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |    1 -
 drivers/scsi/ufs/Kconfig                           |    2 +-
 drivers/scsi/ufs/cdns-pltfrm.c                     |    3 +-
 drivers/scsi/ufs/ufs-exynos.c                      |   15 +-
 drivers/scsi/ufs/ufs-exynos.h                      |   13 -
 drivers/scsi/ufs/ufs-hisi.c                        |   13 +-
 drivers/scsi/ufs/ufs-hisi.h                        |   13 -
 drivers/scsi/ufs/ufs-mediatek-trace.h              |   36 +
 drivers/scsi/ufs/ufs-mediatek.c                    |  265 ++-
 drivers/scsi/ufs/ufs-mediatek.h                    |   34 +-
 drivers/scsi/ufs/ufs-qcom.c                        |   40 +-
 drivers/scsi/ufs/ufs-qcom.h                        |   11 -
 drivers/scsi/ufs/ufs-sysfs.c                       |    7 +
 drivers/scsi/ufs/ufs.h                             |    1 +
 drivers/scsi/ufs/ufshcd-dwc.c                      |   11 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   38 +-
 drivers/scsi/ufs/ufshcd-pltfrm.h                   |    1 +
 drivers/scsi/ufs/ufshcd.c                          |  500 ++++--
 drivers/scsi/ufs/ufshcd.h                          |  151 +-
 drivers/scsi/ufs/unipro.h                          |    6 +-
 drivers/target/loopback/tcm_loop.c                 |   14 +-
 drivers/target/target_core_device.c                |   59 +-
 drivers/target/target_core_iblock.c                |    1 +
 drivers/target/target_core_pr.c                    |    1 +
 drivers/target/target_core_sbc.c                   |  139 +-
 drivers/target/target_core_tmr.c                   |  166 +-
 drivers/target/target_core_tpg.c                   |    2 +-
 drivers/target/target_core_transport.c             |  170 +-
 drivers/target/target_core_user.c                  |  164 +-
 drivers/target/tcm_fc/tfc_cmd.c                    |    3 +-
 drivers/target/tcm_fc/tfc_io.c                     |    1 -
 drivers/target/tcm_fc/tfc_sess.c                   |    2 +-
 include/scsi/fc_frame.h                            |   30 +
 include/scsi/scsi_transport_fc.h                   |   36 +
 include/target/target_core_base.h                  |   22 +-
 include/target/target_core_fabric.h                |    2 +-
 include/trace/events/ufs.h                         |   24 +-
 include/uapi/scsi/fc/fc_els.h                      |  114 +-
 197 files changed, 11891 insertions(+), 8121 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_host
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc_remote_ports
 rename {include/scsi => drivers/scsi/libfc}/fc_encode.h (94%)
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_trigger_pages.h
 create mode 100644 drivers/scsi/ufs/ufs-mediatek-trace.h

James


