Return-Path: <SRS0=J5Rw=3S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6B0C2D0DB
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 18:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91A5B20720
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jan 2020 18:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="RHfnHlIk";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="RHfnHlIk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgA2Sg0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jan 2020 13:36:26 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44356 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726332AbgA2Sg0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jan 2020 13:36:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 5BBDC8EE15F;
        Wed, 29 Jan 2020 10:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1580322985;
        bh=rXEsOYBraKR+rTR+abdocl/SiZCwesGUDT73p+dChPA=;
        h=Subject:From:To:Cc:Date:From;
        b=RHfnHlIkyB0YtGWXYPHSAMjejf/gY9GMG3URXFswGPzY6AmbMGD4QKQdzvWe3LwQ0
         r0+vMIMirzU26YNJFgGb3E6fgKm3SGzIuSgJHiH8tGjh/hpcgvjjYpvrSmCZofO+Gi
         uB2e1QwJjZ/54rV5KeWHDZ+6EVq0XURhnNUWm7Qc=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Aka9MTb3ajVs; Wed, 29 Jan 2020 10:36:25 -0800 (PST)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id DF7418EE0D4;
        Wed, 29 Jan 2020 10:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1580322985;
        bh=rXEsOYBraKR+rTR+abdocl/SiZCwesGUDT73p+dChPA=;
        h=Subject:From:To:Cc:Date:From;
        b=RHfnHlIkyB0YtGWXYPHSAMjejf/gY9GMG3URXFswGPzY6AmbMGD4QKQdzvWe3LwQ0
         r0+vMIMirzU26YNJFgGb3E6fgKm3SGzIuSgJHiH8tGjh/hpcgvjjYpvrSmCZofO+Gi
         uB2e1QwJjZ/54rV5KeWHDZ+6EVq0XURhnNUWm7Qc=
Message-ID: <1580322984.7790.36.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.5+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 29 Jan 2020 10:36:24 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series is slightly unusual because it includes Arnd's compat ioctl
tree here:

1c46a2cf2dbd Merge tag 'block-ioctl-cleanup-5.6' into 5.6/scsi-queue

Excluding Arnd's changes, this is mostly an update of the usual
drivers: megaraid_sas, mpt3sas, qla2xxx, ufs, lpfc, hisi_sas.  There
are a couple of core and base updates around error propagation and
atomicity in the attribute container base we use for the SCSI transport
classes.  The rest is minor changes and updates.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Aditya Pakki (1):
      scsi: libfc: remove unnecessary assertion on ep variable

Anand Lodnoor (11):
      scsi: megaraid_sas: Update driver version to 07.713.01.00-rc1
      scsi: megaraid_sas: Use Block layer API to check SCSI device in-flight IO requests
      scsi: megaraid_sas: Limit the number of retries for the IOCTLs causing firmware fault
      scsi: megaraid_sas: Do not initiate OCR if controller is not in ready state
      scsi: megaraid_sas: Re-Define enum DCMD_RETURN_STATUS
      scsi: megaraid_sas: Do not set HBA Operational if FW is not in operational state
      scsi: megaraid_sas: Do not kill HBA if JBOD Seqence map or RAID map is disabled
      scsi: megaraid_sas: Do not kill host bus adapter, if adapter is already dead
      scsi: megaraid_sas: Update optimal queue depth for SAS and NVMe devices
      scsi: megaraid_sas: Set no_write_same only for Virtual Disk
      scsi: megaraid_sas: Reset adapter if FW is not in READY state after device resume

Arnd Bergmann (22):
      Documentation: document ioctl interfaces better
      compat_ioctl: simplify up block/ioctl.c
      compat_ioctl: block: simplify compat_blkpg_ioctl()
      compat_ioctl: block: move blkdev_compat_ioctl() into ioctl.c
      compat_ioctl: move HDIO ioctl handling into drivers/ide
      compat_ioctl: scsi: handle HDIO commands from drivers
      compat_ioctl: move cdrom commands into cdrom.c
      compat_ioctl: simplify the implementation
      compat_ioctl: move sys_compat_ioctl() to ioctl.c
      compat_ioctl: scsi: move ioctl handling into drivers
      compat_ioctl: ide: floppy: add handler
      compat_ioctl: bsg: add handler
      compat_ioctl: add scsi_compat_ioctl
      compat_ioctl: block: handle cdrom compat ioctl in non-cdrom drivers
      compat_ioctl: cdrom: handle CDROM_LAST_WRITTEN
      compat_ioctl: move CDROMREADADIO to cdrom.c
      compat_ioctl: move CDROM_SEND_PACKET handling into scsi
      compat_ioctl: ubd, aoe: use blkdev_compat_ptr_ioctl
      compat_ioctl: block: add blkdev_compat_ptr_ioctl
      compat: scsi: sg: fix v3 compat read/write interface
      compat: provide compat_ptr() on all architectures
      compat: ARM64: always include asm-generic/compat.h

Asutosh Das (1):
      scsi: ufs: Recheck bkops level if bkops is disabled

Bart Van Assche (12):
      scsi: qla2xxx: Fix a NULL pointer dereference in an error path
      scsi: ufs: Remove the SCSI timeout handler
      scsi: ufs: Fix a race condition in the tracing code
      scsi: ufs: Make ufshcd_prepare_utp_scsi_cmd_upiu() easier to read
      scsi: ufs: Make ufshcd_add_command_trace() easier to read
      scsi: ufs: Fix indentation in ufshcd_query_attr_retry()
      scsi: qla2xxx: Use get_unaligned_*() instead of open-coding these functions
      scsi: qla2xxx: Fix the endianness of the qla82xx_get_fw_size() return type
      scsi: qla2xxx: Improve readability of the code that handles qla_flt_header
      scsi: core: Fix a compiler warning triggered by the SCSI logging code
      scsi: ufs: Use blk_{get,put}_request() to allocate and free TMFs
      scsi: ufs: Avoid busy-waiting by eliminating tag conflicts

Bean Huo (9):
      scsi: ufs: Use UFS device indicated maximum LU number
      scsi: ufs: Add max_lu_supported in struct ufs_dev_info
      scsi: ufs: Delete is_init_prefetch from struct ufs_hba
      scsi: ufs: Inline two functions into their callers
      scsi: ufs: Move ufshcd_get_max_pwr_mode() to ufshcd_device_params_init()
      scsi: ufs: Split ufshcd_probe_hba() based on its called flow
      scsi: ufs: Delete struct ufs_dev_desc
      scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails
      scsi: ufs: delete unused structure filed tr

Can Guo (8):
      scsi: ufs: Do not free irq in suspend
      scsi: ufs: Do not clear the DL layer timers
      scsi: ufs: Release clock if DMA map fails
      scsi: ufs: Use DBD setting in mode sense
      scsi: core: Adjust DBD setting in MODE SENSE for caching mode page per LLD
      scsi: ufs: Complete pending requests in host reset and restore path
      scsi: ufs: Avoid messing up the compl_time_stamp of lrbs
      scsi: ufs: Update VCCQ2 and VCCQ min/max voltage hard codes

Chen Zhou (3):
      scsi: initio: make initio_state_7() static
      scsi: ibmvscsi_tgt: remove set but not used variables 'iue' and 'sd'
      scsi: sym53c8xx: fix typos in comments

Colin Ian King (1):
      scsi: BusLogic: use %lX for unsigned long rather than %X

Damien Le Moal (2):
      scsi: sd_zbc: Rename sd_zbc_check_zones()
      scsi: sd_zbc: Simplify sd_zbc_check_zones()

Dan Carpenter (2):
      scsi: ufs: Simplify a condition
      scsi: ufs: Unlock on a couple error paths

Gabriel Krisman Bertazi (3):
      scsi: iscsi: Fail session and connection on transport registration failure
      scsi: drivers: base: Propagate errors through the transport component
      scsi: drivers: base: Support atomic version of attribute_container_device_trigger

Himanshu Madhani (3):
      scsi: qla2xxx: Update driver version to 10.01.00.22-k
      scsi: qla2xxx: Fix update_fcport for current_topology
      scsi: qla2xxx: Remove defer flag to indicate immeadiate port loss

James Smart (10):
      scsi: lpfc: Update lpfc version to 12.6.0.3
      scsi: lpfc: Fix improper flag check for IO type
      scsi: lpfc: Fix MDS Latency Diagnostics Err-drop rates
      scsi: lpfc: Fix unmap of dpp bars affecting next driver load
      scsi: lpfc: Fix disablement of FC-AL on lpe35000 models
      scsi: lpfc: Fix ras_log via debugfs
      scsi: lpfc: Fix Fabric hostname registration if system hostname changes
      scsi: lpfc: Fix missing check for CSF in Write Object Mbox Rsp
      scsi: lpfc: Fix: Rework setting of fdmi symbolic node name registration
      scsi: lpfc: Fix incomplete NVME discovery when target

Joe Carnuccio (1):
      scsi: qla2xxx: Add D-Port Diagnostic reason explanation logs

John Garry (2):
      scsi: hisi_sas: Rename hisi_sas_cq.pci_irq_mask
      scsi: libsas: Tidy SAS address print format

Kars de Jong (2):
      scsi: esp_scsi: Add support for FSC chip
      scsi: esp_scsi: Correct ordering of PCSCSI definition in esp_rev enum

Luo Jiaxing (3):
      scsi: hisi_sas: Add prints for v3 hw interrupt converge and automatic affinity
      scsi: hisi_sas: Modify the file permissions of trigger_dump to write only
      scsi: hisi_sas: Replace magic number when handle channel interrupt

Nathan Chancellor (3):
      scsi: csiostor: Adjust indentation in csio_device_reset
      scsi: aic7xxx: Adjust indentation in ahc_find_syncrate
      scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free

Nick Black (1):
      scsi: iscsi: Don't destroy session if there are outstanding connections

Nishad Kamdar (2):
      scsi: ufs: sysfs: Use the correct style for SPDX License Identifier
      scsi: mylex: Use the correct style for SPDX License Identifier

Quinn Tran (7):
      scsi: qla2xxx: Fix mtcp dump collection failure
      scsi: qla2xxx: Fix stuck session in GNL
      scsi: qla2xxx: Fix RIDA Format-2
      scsi: qla2xxx: Consolidate fabric scan
      scsi: qla2xxx: Fix stuck login session using prli_pend_timer
      scsi: qla2xxx: Use common routine to free fcport struct
      scsi: qla2xxx: Fix fabric scan hang

Sheeba B (2):
      scsi: ufs: Power off hook for Cadence UFS driver
      scsi: ufs: Update L4 attributes on manual hibern8 exit in Cadence UFS.

Shyam Sundar (3):
      scsi: qla2xxx: Correct fcport flags handling
      scsi: qla2xxx: Cleanup unused async_logout_done
      scsi: qla2xxx: Add a shadow variable to hold disc_state history of fcport

Sreekanth Reddy (10):
      scsi: mpt3sas: Update drive version to 33.100.00.00
      scsi: mpt3sas: Remove usage of device_busy counter
      scsi: mpt3sas: Print function name in which cmd timed out
      scsi: mpt3sas: Optimize mpt3sas driver logging
      scsi: mpt3sas: print in which path firmware fault occurred
      scsi: mpt3sas: Handle CoreDump state from watchdog thread
      scsi: mpt3sas: Add support IOCs new state named COREDUMP
      scsi: mpt3sas: renamed _base_after_reset_handler function
      scsi: mpt3sas: Add support for NVMe shutdown
      scsi: mpt3sas: Update MPI Headers to v02.00.57

Stanley Chu (18):
      scsi: ufs-mediatek: enable low-power mode for hibern8 state
      scsi: ufs: export some functions for vendor usage
      scsi: ufs-mediatek: add dbg_register_dump implementation
      scsi: ufs-mediatek: add apply_dev_quirks variant operation
      scsi: ufs: pass device information to apply_dev_quirks
      scsi: ufs: remove "errors" word in ufshcd_print_err_hist()
      scsi: ufs: add device reset history for vendor implementations
      scsi: ufs: fix empty check of error history
      scsi: ufs-mediatek: configure and enable clk-gating
      scsi: ufs-mediatek: configure customized auto-hibern8 timer
      scsi: ufs: export ufshcd_auto_hibern8_update for vendor usage
      scsi: ufs-mediatek: introduce reference clock control
      scsi: ufs-mediatek: add device reset implementation
      scsi: soc: mediatek: add header for SiP service interface
      scsi: ufs: use ufshcd_vops_dbg_register_dump for vendor specific dumps
      scsi: ufs: unify scsi_block_requests usage
      scsi: ufs: disable interrupt during clock-gating
      scsi: ufs: disable irq before disabling clocks

Thomas Bogendoerfer (2):
      scsi: qla1280: Make checking for 64bit support consistent
      scsi: qla1280: Fix dma firmware download, if dma address is 64bit

Thomas Hellstrom (2):
      scsi: vmw_pvscsi: Silence dma mapping errors
      scsi: vmw_pvscsi: Fix swiotlb operation

Xiang Chen (2):
      scsi: hisi_sas: replace spin_lock_irqsave/spin_unlock_restore with spin_lock/spin_unlock
      scsi: hisi_sas: use threaded irq to process CQ interrupts

YueHaibing (1):
      scsi: lpfc: Make lpfc_defer_acc_rsp static

And the diffstat:

 Documentation/core-api/index.rst            |   1 +
 Documentation/core-api/ioctl.rst            | 253 ++++++++++
 arch/arm64/include/asm/compat.h             |  22 +-
 arch/mips/include/asm/compat.h              |  18 -
 arch/parisc/include/asm/compat.h            |  17 -
 arch/powerpc/include/asm/compat.h           |  17 -
 arch/powerpc/oprofile/backtrace.c           |   2 +-
 arch/s390/include/asm/compat.h              |   6 +-
 arch/sparc/include/asm/compat.h             |  17 -
 arch/um/drivers/ubd_kern.c                  |   1 +
 arch/x86/include/asm/compat.h               |  17 -
 block/Makefile                              |   1 -
 block/bsg.c                                 |   1 +
 block/compat_ioctl.c                        | 427 -----------------
 block/ioctl.c                               | 319 ++++++++++---
 block/scsi_ioctl.c                          | 214 +++++----
 drivers/ata/libata-scsi.c                   |   9 +
 drivers/base/attribute_container.c          | 103 ++++
 drivers/base/transport_class.c              |  11 +-
 drivers/block/aoe/aoeblk.c                  |   1 +
 drivers/block/floppy.c                      |   3 +
 drivers/block/paride/pcd.c                  |   3 +
 drivers/block/paride/pd.c                   |   1 +
 drivers/block/paride/pf.c                   |   1 +
 drivers/block/pktcdvd.c                     |  26 +-
 drivers/block/sunvdc.c                      |   1 +
 drivers/block/virtio_blk.c                  |   3 +
 drivers/block/xen-blkfront.c                |   1 +
 drivers/cdrom/cdrom.c                       |  35 +-
 drivers/cdrom/gdrom.c                       |   3 +
 drivers/ide/ide-cd.c                        |  38 ++
 drivers/ide/ide-disk.c                      |   1 +
 drivers/ide/ide-floppy.c                    |   4 +
 drivers/ide/ide-floppy.h                    |   2 +
 drivers/ide/ide-floppy_ioctl.c              |  35 ++
 drivers/ide/ide-gd.c                        |  17 +
 drivers/ide/ide-ioctls.c                    |  47 +-
 drivers/ide/ide-tape.c                      |  11 +
 drivers/scsi/BusLogic.c                     | 110 ++---
 drivers/scsi/aic7xxx/aic7xxx_core.c         |   2 +-
 drivers/scsi/aic94xx/aic94xx_init.c         |   3 +
 drivers/scsi/ch.c                           |   9 +-
 drivers/scsi/csiostor/csio_scsi.c           |   2 +-
 drivers/scsi/esp_scsi.c                     |  22 +-
 drivers/scsi/esp_scsi.h                     |  41 +-
 drivers/scsi/hisi_sas/hisi_sas.h            |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  74 ++-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c      |   3 +
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |  41 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  57 ++-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c    |   5 -
 drivers/scsi/initio.c                       |   2 +-
 drivers/scsi/ipr.c                          |   3 +
 drivers/scsi/isci/init.c                    |   3 +
 drivers/scsi/iscsi_tcp.c                    |   4 +
 drivers/scsi/libsas/sas_ata.c               |   2 +-
 drivers/scsi/libsas/sas_discover.c          |   2 +-
 drivers/scsi/libsas/sas_expander.c          |   4 +-
 drivers/scsi/libsas/sas_internal.h          |   2 +-
 drivers/scsi/libsas/sas_port.c              |   2 +-
 drivers/scsi/libsas/sas_scsi_host.c         |   8 +-
 drivers/scsi/libsas/sas_task.c              |   2 +-
 drivers/scsi/lpfc/lpfc.h                    |   2 +
 drivers/scsi/lpfc/lpfc_attr.c               |   9 +-
 drivers/scsi/lpfc/lpfc_crtn.h               |   2 +-
 drivers/scsi/lpfc/lpfc_ct.c                 |  88 ++--
 drivers/scsi/lpfc/lpfc_debugfs.c            |  11 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |   5 +
 drivers/scsi/lpfc/lpfc_hw4.h                |   3 +
 drivers/scsi/lpfc/lpfc_init.c               |  12 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c          | 108 ++++-
 drivers/scsi/lpfc/lpfc_scsi.c               |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c                |  25 +-
 drivers/scsi/lpfc/lpfc_version.h            |   2 +-
 drivers/scsi/megaraid/megaraid_sas.h        |  17 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  95 +++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 134 ++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  18 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h             |   6 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h        |  19 +-
 drivers/scsi/mpt3sas/mpi/mpi2_image.h       |   7 +
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h         |   8 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c         | 340 ++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  45 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c       |  39 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |  46 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 220 +++++++--
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |  11 +-
 drivers/scsi/mvsas/mv_init.c                |   3 +
 drivers/scsi/myrb.h                         |   4 +-
 drivers/scsi/myrs.h                         |   4 +-
 drivers/scsi/pm8001/pm8001_init.c           |   3 +
 drivers/scsi/qla1280.c                      |  20 +-
 drivers/scsi/qla1280.h                      |   2 +
 drivers/scsi/qla2xxx/qla_bsg.c              |  11 +-
 drivers/scsi/qla2xxx/qla_dbg.c              |   2 +-
 drivers/scsi/qla2xxx/qla_def.h              |  22 +-
 drivers/scsi/qla2xxx/qla_fw.h               |  50 +-
 drivers/scsi/qla2xxx/qla_gbl.h              |  11 +-
 drivers/scsi/qla2xxx/qla_gs.c               |   6 +-
 drivers/scsi/qla2xxx/qla_init.c             | 175 ++++---
 drivers/scsi/qla2xxx/qla_inline.h           |  24 +
 drivers/scsi/qla2xxx/qla_iocb.c             |  51 +-
 drivers/scsi/qla2xxx/qla_isr.c              |  60 ++-
 drivers/scsi/qla2xxx/qla_mbx.c              |   3 +-
 drivers/scsi/qla2xxx/qla_mid.c              |   6 +-
 drivers/scsi/qla2xxx/qla_mr.c               |  16 +-
 drivers/scsi/qla2xxx/qla_nx.c               |  15 +-
 drivers/scsi/qla2xxx/qla_os.c               |  66 +--
 drivers/scsi/qla2xxx/qla_sup.c              |  11 +-
 drivers/scsi/qla2xxx/qla_target.c           |  47 +-
 drivers/scsi/qla2xxx/qla_target.h           |   3 +-
 drivers/scsi/qla2xxx/qla_version.h          |   2 +-
 drivers/scsi/qla4xxx/ql4_os.c               |   2 +-
 drivers/scsi/scsi_ioctl.c                   |  54 ++-
 drivers/scsi/scsi_lib.c                     |   2 +
 drivers/scsi/scsi_logging.h                 |   2 +-
 drivers/scsi/scsi_transport_iscsi.c         |  44 +-
 drivers/scsi/sd.c                           |  50 +-
 drivers/scsi/sd_zbc.c                       |  38 +-
 drivers/scsi/sg.c                           | 170 +++----
 drivers/scsi/sr.c                           |  53 ++-
 drivers/scsi/st.c                           |  51 +-
 drivers/scsi/sym53c8xx_2/sym_nvram.c        |   4 +-
 drivers/scsi/ufs/cdns-pltfrm.c              | 107 +++++
 drivers/scsi/ufs/ufs-mediatek.c             | 206 +++++++-
 drivers/scsi/ufs/ufs-mediatek.h             |  32 ++
 drivers/scsi/ufs/ufs-sysfs.c                |  22 +-
 drivers/scsi/ufs/ufs-sysfs.h                |   4 +-
 drivers/scsi/ufs/ufs.h                      |  31 +-
 drivers/scsi/ufs/ufs_quirks.h               |   9 +-
 drivers/scsi/ufs/ufshcd.c                   | 715 +++++++++++++++-------------
 drivers/scsi/ufs/ufshcd.h                   |  34 +-
 drivers/scsi/ufs/unipro.h                   |  11 +
 drivers/scsi/vmw_pvscsi.c                   |  20 +-
 drivers/target/tcm_fc/tfc_io.c              |   1 -
 fs/Makefile                                 |   2 +-
 fs/compat_ioctl.c                           | 261 ----------
 fs/internal.h                               |   6 -
 fs/ioctl.c                                  | 131 +++--
 include/linux/attribute_container.h         |   7 +
 include/linux/blkdev.h                      |   7 +
 include/linux/compat.h                      |  18 +
 include/linux/falloc.h                      |   2 -
 include/linux/fs.h                          |   4 -
 include/linux/ide.h                         |   2 +
 include/linux/libata.h                      |   6 +
 include/linux/soc/mediatek/mtk_sip_svc.h    |  25 +
 include/linux/transport_class.h             |   6 +-
 include/scsi/scsi_device.h                  |   1 +
 include/scsi/scsi_ioctl.h                   |   1 +
 include/scsi/sg.h                           |  30 ++
 include/uapi/scsi/scsi_bsg_ufs.h            |   3 +-
 153 files changed, 3823 insertions(+), 2342 deletions(-)
 create mode 100644 Documentation/core-api/ioctl.rst
 delete mode 100644 block/compat_ioctl.c
 delete mode 100644 fs/compat_ioctl.c
 create mode 100644 include/linux/soc/mediatek/mtk_sip_svc.h

James
