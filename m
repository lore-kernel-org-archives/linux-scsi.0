Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD26C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 20:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 487F2601FC
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Feb 2021 20:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhBSUof (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Feb 2021 15:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBSUod (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2021 15:44:33 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3736EC061574;
        Fri, 19 Feb 2021 12:43:53 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 6F8E8128012F;
        Fri, 19 Feb 2021 12:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1613767431;
        bh=kXII2V/u9/sr1OMzsGP36xSy8iuFwlqTQQr6OPN+Ad8=;
        h=Message-ID:Subject:From:To:Date:From;
        b=W/AlT0DoY71KxvvhBP56i5BcoaKpGk4Mi1xbMqShvqv7JwfmGb1ZE1MzNr7MvNtFo
         dWYkNKZv/RwgWDawMr3o4CoSAouYHXbQPXXl3lsz8YfMLQM+jAwXBwc13lZDHT7h83
         K0o/i1riu9a1i8V9YwxRADokUYOzyMGClktNRI6Y=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yGnc8WjStanL; Fri, 19 Feb 2021 12:43:51 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 07EC11280113;
        Fri, 19 Feb 2021 12:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1613767431;
        bh=kXII2V/u9/sr1OMzsGP36xSy8iuFwlqTQQr6OPN+Ad8=;
        h=Message-ID:Subject:From:To:Date:From;
        b=W/AlT0DoY71KxvvhBP56i5BcoaKpGk4Mi1xbMqShvqv7JwfmGb1ZE1MzNr7MvNtFo
         dWYkNKZv/RwgWDawMr3o4CoSAouYHXbQPXXl3lsz8YfMLQM+jAwXBwc13lZDHT7h83
         K0o/i1riu9a1i8V9YwxRADokUYOzyMGClktNRI6Y=
Message-ID: <7cb83383873d766c41d798948635be883ec5ed9b.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.11+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 19 Feb 2021 12:43:50 -0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series consists of the usual driver updates (ufs, ibmvfc, qla2xxx,
hisi_sas, pm80xx) plus the removal of the gdth driver (which is bound
to cause conflicts with a trivial change somewhere).  The only big
major rework of note is the one from Hannes trying to clean up our
result handling code in the drivers to make it consistent.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (2):
      scsi: ufs: ufs-debugfs: Add error counters
      scsi: docs: ABI: sysfs-driver-ufs: Add DeepSleep power mode

Ahmed S. Darwish (19):
      scsi: libsas: Remove temporarily-added _gfp() API variants
      scsi: mvsas: Switch back to original libsas event notifiers
      scsi: isci: Switch back to original libsas event notifiers
      scsi: libsas: Switch back to original event notifiers API
      scsi: pm80xx: Switch back to original libsas event notifiers
      scsi: aic94xx: Switch back to original libsas event notifiers
      scsi: hisi_sas: Switch back to original libsas event notifiers
      scsi: libsas: Add gfp_t flags parameter to event notifications
      scsi: hisi_sas: Pass gfp_t flags to libsas event notifiers
      scsi: aic94xx: Pass gfp_t flags to libsas event notifiers
      scsi: pm80xx: Pass gfp_t flags to libsas event notifiers
      scsi: libsas: Pass gfp_t flags to event notifiers
      scsi: isci: Pass gfp_t flags in isci_port_bc_change_received()
      scsi: isci: Pass gfp_t flags in isci_port_link_up()
      scsi: isci: Pass gfp_t flags in isci_port_link_down()
      scsi: mvsas: Pass gfp_t flags to libsas event notifiers
      scsi: libsas: Introduce a _gfp() variant of event notifiers
      scsi: libsas: docs: Remove notify_ha_event()
      scsi: target: core: Remove in_interrupt() check in transport_handle_cdb_direct()

Anastasia Kovaleva (2):
      scsi: target: core: Change ASCQ for residual write
      scsi: target: core: Signal WRITE residuals

Andrea Parri (Microsoft) (3):
      scsi: storvsc: Validate length of incoming packet in storvsc_on_channel_callback()
      scsi: storvsc: Resolve data race in storvsc_probe()
      scsi: storvsc: Fix max_outstanding_req_per_channel for Win8 and newer

Arnd Bergmann (1):
      scsi: megaraid_sas: Fix MEGASAS_IOC_FIRMWARE regression

Avri Altman (1):
      scsi: ufs: A tad optimization in query upiu trace

Bean Huo (15):
      scsi: ufs: Cleanup WB buffer flush toggle implementation
      scsi: ufs: Group UFS WB related flags in struct ufs_dev_info
      scsi: ufs: Remove two WB related fields from struct ufs_dev_info
      scsi: ufs: Update comment in the function ufshcd_wb_probe()
      scsi: ufs: docs: ABI: Add wb_on documentation for new entry wb_on
      scsi: ufs: Add "wb_on" sysfs node to control WB on/off
      scsi: ufs: Delete redundant if statement in ufshcd_intr()
      scsi: ufs: Remove unnecessary devm_kfree()
      scsi: ufs: Replace sprintf and snprintf with sysfs_emit
      scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM
      scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM UPIU trace
      scsi: ufs: Distinguish between query REQ and query RSP in query trace
      scsi: ufs: Don't call trace_ufshcd_upiu() in case trace poit is disabled
      scsi: ufs: Use __print_symbolic() for UFS trace string print
      scsi: ufs: Remove stringize operator '#' restriction

Bhavesh Jashnani (1):
      scsi: pm80xx: Simultaneous poll for all FW readiness

Bikash Hazarika (1):
      scsi: qla2xxx: Wait for ABTS response on I/O timeouts for NVMe

Bjorn Helgaas (2):
      scsi: lpfc: Fix 'physical' typos
      scsi: message: fusion: Fix 'physical' typos

Brian King (1):
      scsi: ibmvfc: Set default timeout to avoid crash during migration

Can Guo (7):
      scsi: ufs: Give clk scaling min gear a value
      Revert "Make sure clk scaling happens only when HBA is runtime ACTIVE"
      scsi: ufs: Refactor ufshcd_init/exit_clk_scaling/gating()
      scsi: ufs: Protect some contexts from unexpected clock scaling
      scsi: ufs: Protect PM ops and err_handler from user access through sysfs
      scsi: ufs: Fix a possible NULL pointer issue
      scsi: ufs: Correct the LUN used in eh_device_reset_handler() callback

Christophe JAILLET (1):
      scsi: pm80xx: Switch from 'pci_' to 'dma_' API

Colin Ian King (3):
      scsi: ibmvfc: Fix spelling mistake "succeded" -> "succeeded"
      scsi: pm80xx: Clean up indentation of a code block
      scsi: mpt3sas: Fix spelling mistake in Kconfig "compatiblity" -> "compatibility"

Dan Carpenter (3):
      scsi: lpfc: Fix ancient double free
      scsi: qla2xxx: Fix some memory corruption
      scsi: qla2xxx: Remove unnecessary NULL check

Dinghao Liu (2):
      scsi: fnic: Fix memleak in vnic_dev_init_devcmd2
      scsi: scsi_debug: Fix memleak in scsi_debug_init()

Enzo Matsumiya (1):
      scsi: qla2xxx: Fix description for parameter ql2xenforce_iocb_limit

Eric Curtin (1):
      scsi: lpfc: Fix kerneldoc inconsistency in lpfc_sli4_dump_page_a0()

Ewan D. Milne (1):
      scsi: sd: Suppress spurious errors when WRITE SAME is being disabled

Hannes Reinecke (36):
      scsi: ncr53c8xx: Fix typos
      scsi: ncr53c8xx: Use SAM status values
      scsi: advansys: Kill driver-defined status byte accessors
      scsi: qla2xxx: fc_remote_port_chkready() returns a SCSI result value
      scsi: storvsc: Return DID_ERROR for invalid commands
      scsi: ips: Use correct command completion on error
      scsi: wd33c93: Use SCSI status
      scsi: esp_scsi: Do not set SCSI message byte
      scsi: esp_scsi: Use host byte as last argument to esp_cmd_is_done()
      scsi: core: Add 'set_status_byte()' accessor
      scsi: dpt_i2o: Use DID_ERROR instead of INITIATOR_ERROR message
      scsi: mac53c94: Do not set invalid command result
      scsi: atp870u: Use standard definitions
      scsi: ufs: ufshcd: Do not set COMMAND_COMPLETE
      scsi: scsi_debug: Do not set COMMAND_COMPLETE
      scsi: initio: Drop internal SCSI message definition
      scsi: dc395x: Drop internal SCSI message definitions
      scsi: aic7xxx: aic79xx: Drop internal SCSI message definition
      scsi: nsp_cs: Drop internal SCSI message definition
      scsi: stex: Do not set COMMAND_COMPLETE
      scsi: hpsa: Do not set COMMAND_COMPLETE
      scsi: aacraid: Avoid setting message byte on completion
      scsi: zfcp: Do not set COMMAND_COMPLETE
      scsi: qla4xxx: Use standard SAM status definitions
      scsi: dc395: Drop private SAM status code definitions
      scsi: nsp32: Fixup status handling
      scsi: acornscsi: Use standard defines
      scsi: bfa: Drop driver-defined SCSI status codes
      scsi: aic7xxx: aic79xx: Remove driver-defined SAM status definitions
      scsi: aic7xxx: aic79xx: Kill pointless forward declarations
      scsi: aic7xxx: aic79xx: Whitespace cleanup
      scsi: atp870u: Whitespace cleanup
      scsi: 3w-sas: Whitespace cleanup
      scsi: 3w-9xxx: Whitespace cleanup
      scsi: 3w-xxxx: Whitespace cleanup
      scsi: Drop gdth driver

Jaegeuk Kim (3):
      scsi: ufs: WB is only available on LUN #0 to #7
      scsi: ufs: Fix tm request when non-fatal error happens
      scsi: ufs: Fix livelock of ufshcd_clear_ua_wluns()

James Smart (15):
      scsi: lpfc: Update lpfc version to 12.8.0.7
      scsi: lpfc: Enhancements to LOG_TRACE_EVENT for better readability
      scsi: lpfc: Implement health checking when aborting I/O
      scsi: lpfc: Fix crash when nvmet transport calls host_release
      scsi: lpfc: Fix vport create logging
      scsi: lpfc: Fix NVMe recovery after mailbox timeout
      scsi: lpfc: Fix target reset failing
      scsi: lpfc: Fix error log messages being logged following SCSI task mgnt
      scsi: lpfc: Prevent duplicate requests to unregister with cpuhp framework
      scsi: lpfc: Fix FW reset action if I/Os are outstanding
      scsi: lpfc: Use the nvme-fc transport supplied timeout for LS requests
      scsi: lpfc: Fix crash when a fabric node is released prematurely
      scsi: lpfc: Refresh ndlp when a new PRLI is received in the PRLI issue state
      scsi: lpfc: Fix auto sli_mode and its effect on CONFIG_PORT for SLI3
      scsi: lpfc: Fix PLOGI S_ID of 0 on pt2pt config

Javed Hasan (1):
      scsi: libfc: Avoid invoking response handler twice if ep is already completed

Jiapeng Zhong (2):
      scsi: qla2xxx: Simplify the calculation of variables
      scsi: qla2xxx: Assign boolean values to a bool variable

John Garry (6):
      scsi: hisi_sas: Don't check .nr_hw_queues in hisi_sas_task_prep()
      scsi: hisi_sas: Remove deferred probe check in hisi_sas_v2_probe()
      scsi: libsas: Remove notifier indirection
      scsi: MAINTAINERS: Remove intel-linux-scu@intel.com for INTEL C600 SAS DRIVER
      scsi: hisi_sas: Remove auto_affine_msi_experimental module_param
      scsi: hisi_sas: Expose HW queues for v2 hw

Kiwoong Kim (5):
      scsi: ufs: ufs-exynos: Use UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE
      scsi: ufs: Introduce a quirk to allow only page-aligned sg entries
      scsi: ufs: ufs-exynos: Apply vendor-specific values for three timeouts
      scsi: ufs: Add a quirk to permit overriding UniPro defaults
      scsi: ufs: Relocate flush of exceptional event

Lukas Bulwahn (3):
      scsi: MAINTAINERS: Adjust to reflect gdth scsi driver removal
      scsi: docs: ABI: sysfs-driver-ufs: Rectify table formatting
      scsi: sd: Remove obsolete variable in sd_remove()

Luo Jiaxing (3):
      scsi: hisi_sas: Add trace FIFO debugfs support
      scsi: hisi_sas: Flush workqueue in hisi_sas_v3_remove()
      scsi: hisi_sas: Enable debugfs support by default

Martin K. Petersen (1):
      Revert "Revert "scsi: megaraid_sas: Added support for shared host tagset for cpuhotplug""

Martin Wilck (1):
      scsi: scsi_transport_srp: Don't block target in failfast state

Muneendra Kumar (5):
      scsi: lpfc: Add support for eh_should_retry_cmd()
      scsi: scsi_transport_fc: Add store capability to rport port_state in sysfs
      scsi: scsi_transport_fc: Add a new rport state FC_PORTSTATE_MARGINAL
      scsi: core: No retries on abort success
      scsi: core: Add a new error code DID_TRANSPORT_MARGINAL in scsi.h

Nilesh Javali (2):
      scsi: qla2xxx: Update version to 10.02.00.105-k
      scsi: qedi: Correct max length of CHAP secret

Pavel Begunkov (1):
      scsi: target: file: Don't zero iter before iov_iter_bvec

Quinn Tran (1):
      scsi: qla2xxx: Fix mailbox Ch erroneous error

Randy Dunlap (2):
      scsi: ufs: Fix all Kconfig help text indentation
      scsi: ufs: ufshcd-pltfrm depends on HAS_IOMEM

René Rebe (1):
      scsi: qla1280: Fix printk regression

Roman Bolshakov (1):
      scsi: target: core: Set residuals for 4Kn devices

Saurav Kashyap (4):
      scsi: qla2xxx: Enable NVMe CONF (BIT_7) when enabling SLER
      scsi: qla2xxx: Move some messages from debug to normal log level
      scsi: qla2xxx: Add error counters to debugfs node
      scsi: qla2xxx: Implementation to get and manage host, target stats and initiator port

Sebastian Andrzej Siewior (5):
      scsi: target: core: Replace in_interrupt() usage in target_submit_cmd_map_sgls()
      scsi: target: alua: Remove in_interrupt() usage in core_alua_check_nonop_delay()
      scsi: target: iscsi: Redo iscsit_check_session_usage_count() return code
      scsi: target: iscsi: Avoid in_interrupt() usage in iscsit_check_session_usage_count()
      scsi: target: iscsi: Avoid in_interrupt() usage in iscsit_close_session()

Sergey Shtylyov (3):
      scsi: aha1542: Fix multi-line comment style
      scsi: aha1542: Kill trailing whitespace
      scsi: aha1542: Clarify 'struct ccb' comments

Shin'ichiro Kawasaki (1):
      scsi: target: tcmu: Fix use-after-free of se_cmd->priv

Stanley Chu (6):
      scsi: ufs: Clean up and refactor clk-scaling feature
      scsi: ufs: Remove redundant null checking of devfreq instance
      scsi: ufs: Refactor cancelling clkscaling works
      scsi: ufs-mediatek: Enable UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
      scsi: ufs: Relax the condition of UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
      scsi: ufs: Fix possible power drain during system suspend

Tong Zhang (1):
      scsi: lpfc: Add auto select on IRQ_POLL

Tyrel Datwyler (27):
      scsi: ibmvfc: Provide modules parameters for MQ settings
      scsi: ibmvfc: Enable MQ and set reasonable defaults
      scsi: ibmvfc: Purge SCSI channels after transport loss/reset
      scsi: ibmvfc: Send Cancel MAD down each hw SCSI channel
      scsi: ibmvfc: Add cancel mad initialization helper
      scsi: ibmvfc: Register Sub-CRQ handles with VIOS during channel setup
      scsi: ibmvfc: Send commands down HW Sub-CRQ when channelized
      scsi: ibmvfc: Set and track hw queue in ibmvfc_event struct
      scsi: ibmvfc: Advertise client support for using hardware channels
      scsi: ibmvfc: Implement channel enquiry and setup commands
      scsi: ibmvfc: Map/request irq and register Sub-CRQ interrupt handler
      scsi: ibmvfc: Define Sub-CRQ interrupt handler routine
      scsi: ibmvfc: Add handlers to drain and complete Sub-CRQ responses
      scsi: ibmvfc: Add Sub-CRQ IRQ enable/disable routine
      scsi: ibmvfc: Add alloc/dealloc routines for SCSI Sub-CRQ Channels
      scsi: ibmvfc: Add Subordinate CRQ definitions
      scsi: ibmvfc: Define hcall wrapper for registering a Sub-CRQ
      scsi: ibmvfc: Add size parameter to ibmvfc_init_event_pool()
      scsi: ibmvfc: Init/free event pool during queue allocation/free
      scsi: ibmvfc: Move event pool init/free routines
      scsi: ibmvfc: Add vhost fields and defaults for MQ enablement
      scsi: ibmvfc: Relax locking around ibmvfc_queuecommand()
      scsi: ibmvfc: Complete commands outside the host/queue lock
      scsi: ibmvfc: Define per-queue state/list locks
      scsi: ibmvfc: Make command event pool queue specific
      scsi: ibmvfc: Define generic queue structure for CRQs
      scsi: ibmvfc: Fix missing cast of ibmvfc_event pointer to u64 handle

Valdis Kletnieks (1):
      scsi: target: iscsi: Fix typo in comment

Vishakha Channapattan (1):
      scsi: pm80xx: Log SATA IOMB completion status on failure

Viswas G (1):
      scsi: pm80xx: Fix driver fatal dump failure

YANG LI (4):
      scsi: mpt3sas: Simplify bool comparison
      scsi: lpfc: Simplify bool comparison
      scsi: qedf: Simplify bool comparison
      scsi: isci: Remove the unneeded variable "status"

Yang Li (1):
      scsi: qla2xxx: Remove redundant NULL check

Ziqi Chen (2):
      scsi: ufs-qcom: Fix ufs RST_n spec violation
      scsi: ufs: core: Fix ufs clk specs violation

akshatzen (4):
      scsi: pm80xx: Fix missing tag_free in NVMD DATA req
      scsi: pm80xx: Check main config table address
      scsi: pm80xx: Check for fatal error
      scsi: pm80xx: Do not busy wait in MPI init check

dingsenjie (1):
      scsi: megaraid_mbox: Fix spelling of 'allocated'

kernel test robot (1):
      scsi: megaraid: Fix ifnullfree.cocci warnings

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs         |   47 +-
 Documentation/kbuild/makefiles.rst                 |    4 +-
 Documentation/process/magic-number.rst             |    2 -
 Documentation/scsi/libsas.rst                      |    9 +-
 Documentation/scsi/scsi-parameters.rst             |    3 -
 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 -
 MAINTAINERS                                        |    8 -
 drivers/message/fusion/lsi/mpi_cnfg.h              |    2 +-
 drivers/message/fusion/lsi/mpi_history.txt         |    2 +-
 drivers/s390/scsi/zfcp_fc.h                        |    1 -
 drivers/scsi/3w-9xxx.c                             |   56 +-
 drivers/scsi/3w-9xxx.h                             |  156 +-
 drivers/scsi/3w-sas.c                              |   52 +-
 drivers/scsi/3w-sas.h                              |  118 +-
 drivers/scsi/3w-xxxx.c                             |  251 +-
 drivers/scsi/3w-xxxx.h                             |  199 +-
 drivers/scsi/Kconfig                               |   16 +-
 drivers/scsi/Makefile                              |    2 -
 drivers/scsi/aacraid/aachba.c                      |  173 +-
 drivers/scsi/advansys.c                            |   84 +-
 drivers/scsi/aha1542.c                             |  133 +-
 drivers/scsi/aha1542.h                             |   33 +-
 drivers/scsi/aic7xxx/aic79xx.h                     |   36 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |  257 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |   20 +-
 drivers/scsi/aic7xxx/aic79xx_osm.h                 |   37 +-
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c             |    6 +-
 drivers/scsi/aic7xxx/aic79xx_proc.c                |   13 +-
 drivers/scsi/aic7xxx/aic7xxx_93cx6.c               |    4 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |  263 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |   88 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.h                 |   39 +-
 drivers/scsi/aic7xxx/aic7xxx_proc.c                |   15 +-
 drivers/scsi/aic7xxx/aiclib.h                      |   15 -
 drivers/scsi/aic7xxx/scsi_message.h                |   41 -
 drivers/scsi/aic94xx/aic94xx_scb.c                 |   24 +-
 drivers/scsi/arm/acornscsi.c                       |   14 +-
 drivers/scsi/atp870u.c                             |  451 +-
 drivers/scsi/atp870u.h                             |   14 +-
 drivers/scsi/bfa/bfa_fc.h                          |   15 -
 drivers/scsi/bfa/bfa_fcpim.c                       |    2 +-
 drivers/scsi/bfa/bfad_im.c                         |    2 +-
 drivers/scsi/dc395x.c                              |   28 +-
 drivers/scsi/dc395x.h                              |   38 -
 drivers/scsi/dpt_i2o.c                             |    2 +-
 drivers/scsi/esp_scsi.c                            |   23 +-
 drivers/scsi/fnic/vnic_dev.c                       |    8 +-
 drivers/scsi/gdth.c                                | 4322 --------------------
 drivers/scsi/gdth.h                                |  981 -----
 drivers/scsi/gdth_ioctl.h                          |  251 --
 drivers/scsi/gdth_proc.c                           |  586 ---
 drivers/scsi/gdth_proc.h                           |   18 -
 drivers/scsi/hisi_sas/Kconfig                      |    6 +
 drivers/scsi/hisi_sas/hisi_sas.h                   |   22 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   59 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |    7 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |   85 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  264 +-
 drivers/scsi/hpsa.c                                |    4 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     | 1278 ++++--
 drivers/scsi/ibmvscsi/ibmvfc.h                     |   91 +-
 drivers/scsi/initio.c                              |   64 +-
 drivers/scsi/initio.h                              |   25 -
 drivers/scsi/ips.c                                 |    9 +-
 drivers/scsi/isci/port.c                           |   11 +-
 drivers/scsi/isci/request.c                        |    4 +-
 drivers/scsi/libfc/fc_exch.c                       |   16 +-
 drivers/scsi/libsas/sas_event.c                    |   27 +-
 drivers/scsi/libsas/sas_init.c                     |   19 +-
 drivers/scsi/libsas/sas_internal.h                 |    6 +-
 drivers/scsi/lpfc/lpfc.h                           |    4 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |    9 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |    4 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |    6 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |   15 +-
 drivers/scsi/lpfc/lpfc_els.c                       |   49 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   36 +-
 drivers/scsi/lpfc/lpfc_init.c                      |  241 +-
 drivers/scsi/lpfc/lpfc_mbox.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |   21 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      |   45 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     |   33 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |   59 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |  141 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |    2 +-
 drivers/scsi/mac53c94.c                            |    1 -
 drivers/scsi/megaraid/megaraid_mbox.c              |    2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   45 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |   32 +-
 drivers/scsi/mpt3sas/Kconfig                       |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |    4 +-
 drivers/scsi/mvsas/mv_sas.c                        |   25 +-
 drivers/scsi/ncr53c8xx.c                           |   83 +-
 drivers/scsi/ncr53c8xx.h                           |   16 -
 drivers/scsi/nsp32.c                               |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c                       |   12 +-
 drivers/scsi/pcmcia/nsp_cs.h                       |   11 -
 drivers/scsi/pm8001/pm8001_hwi.c                   |   69 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   20 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   21 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |    2 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  280 +-
 drivers/scsi/pm8001/pm80xx_hwi.h                   |   17 +-
 drivers/scsi/qedf/qedf_main.c                      |    2 +-
 drivers/scsi/qedi/qedi_main.c                      |    4 +-
 drivers/scsi/qla1280.c                             |   12 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |    9 +
 drivers/scsi/qla2xxx/qla_bsg.c                     |  342 ++
 drivers/scsi/qla2xxx/qla_bsg.h                     |    5 +
 drivers/scsi/qla2xxx/qla_dbg.c                     |    1 +
 drivers/scsi/qla2xxx/qla_def.h                     |   83 +
 drivers/scsi/qla2xxx/qla_dfs.c                     |   28 +
 drivers/scsi/qla2xxx/qla_fw.h                      |   27 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   29 +
 drivers/scsi/qla2xxx/qla_gs.c                      |    1 +
 drivers/scsi/qla2xxx/qla_init.c                    |  245 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    |    8 +
 drivers/scsi/qla2xxx/qla_isr.c                     |   87 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |   18 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   93 +-
 drivers/scsi/qla2xxx/qla_os.c                      |   29 +-
 drivers/scsi/qla2xxx/qla_version.h                 |    4 +-
 drivers/scsi/qla4xxx/ql4_fw.h                      |    1 -
 drivers/scsi/qla4xxx/ql4_isr.c                     |    2 +-
 drivers/scsi/scsi_debug.c                          |    7 +-
 drivers/scsi/scsi_error.c                          |   23 +-
 drivers/scsi/scsi_lib.c                            |    1 +
 drivers/scsi/scsi_transport_fc.c                   |  118 +-
 drivers/scsi/scsi_transport_srp.c                  |    9 +-
 drivers/scsi/sd.c                                  |    6 +-
 drivers/scsi/stex.c                                |   25 +-
 drivers/scsi/storvsc_drv.c                         |   60 +-
 drivers/scsi/ufs/Kconfig                           |   15 +-
 drivers/scsi/ufs/Makefile                          |   13 +-
 drivers/scsi/ufs/ufs-debugfs.c                     |   56 +
 drivers/scsi/ufs/ufs-debugfs.h                     |   22 +
 drivers/scsi/ufs/ufs-exynos.c                      |    9 +-
 drivers/scsi/ufs/ufs-mediatek.c                    |    1 +
 drivers/scsi/ufs/ufs-qcom.c                        |   18 +-
 drivers/scsi/ufs/ufs-sysfs.c                       |  175 +-
 drivers/scsi/ufs/ufs.h                             |   52 +-
 drivers/scsi/ufs/ufshcd-crypto.c                   |    4 +-
 drivers/scsi/ufs/ufshcd.c                          |  629 +--
 drivers/scsi/ufs/ufshcd.h                          |   41 +-
 drivers/scsi/wd33c93.c                             |    6 +-
 drivers/target/iscsi/iscsi_target.c                |   20 +-
 drivers/target/iscsi/iscsi_target.h                |    2 +-
 drivers/target/iscsi/iscsi_target_erl0.c           |    2 +-
 drivers/target/iscsi/iscsi_target_login.c          |    2 +-
 drivers/target/iscsi/iscsi_target_util.c           |   11 +-
 drivers/target/iscsi/iscsi_target_util.h           |    2 +-
 drivers/target/target_core_alua.c                  |    2 -
 drivers/target/target_core_file.c                  |    2 +-
 drivers/target/target_core_transport.c             |   65 +-
 drivers/target/target_core_user.c                  |   11 +-
 include/scsi/libsas.h                              |    9 +-
 include/scsi/scsi.h                                |    2 +
 include/scsi/scsi_cmnd.h                           |    5 +
 include/scsi/scsi_host.h                           |    6 +
 include/scsi/scsi_transport_fc.h                   |    4 +-
 include/target/target_core_base.h                  |    1 +
 include/trace/events/ufs.h                         |  108 +-
 163 files changed, 5729 insertions(+), 9120 deletions(-)
 delete mode 100644 drivers/scsi/gdth.c
 delete mode 100644 drivers/scsi/gdth.h
 delete mode 100644 drivers/scsi/gdth_ioctl.h
 delete mode 100644 drivers/scsi/gdth_proc.c
 delete mode 100644 drivers/scsi/gdth_proc.h
 create mode 100644 drivers/scsi/ufs/ufs-debugfs.c
 create mode 100644 drivers/scsi/ufs/ufs-debugfs.h

James


