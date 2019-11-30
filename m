Return-Path: <SRS0=mhd7=ZW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B41C432C0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Nov 2019 18:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9977C2075A
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Nov 2019 18:10:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="e7VDM03P";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="e7VDM03P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfK3SKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 Nov 2019 13:10:45 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53790 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726799AbfK3SKp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 30 Nov 2019 13:10:45 -0500
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C54E28EE0DF;
        Sat, 30 Nov 2019 10:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1575137444;
        bh=1L7KyCfMd2aDFMZiHNssKckJj6XbHlxqQM0SDxeCAao=;
        h=Subject:From:To:Cc:Date:From;
        b=e7VDM03PeyNkl2YuqVJceJCjpFmzhy7ZHLF3wYNxv7uHQxDSiybaR7gt1plHRnYxB
         P9gJptmqr4Cv7GHsFUo8wKsYHC5XFNO8ex8/WYzEM44xRC3zjx4mqz5Varob0qLy3b
         HlQ9RXVuQZtttR6sVvGF1ng94N+KLQANFQKiNwxM=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Lw5cnnFp0sKe; Sat, 30 Nov 2019 10:10:44 -0800 (PST)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 3BA548EE07B;
        Sat, 30 Nov 2019 10:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1575137444;
        bh=1L7KyCfMd2aDFMZiHNssKckJj6XbHlxqQM0SDxeCAao=;
        h=Subject:From:To:Cc:Date:From;
        b=e7VDM03PeyNkl2YuqVJceJCjpFmzhy7ZHLF3wYNxv7uHQxDSiybaR7gt1plHRnYxB
         P9gJptmqr4Cv7GHsFUo8wKsYHC5XFNO8ex8/WYzEM44xRC3zjx4mqz5Varob0qLy3b
         HlQ9RXVuQZtttR6sVvGF1ng94N+KLQANFQKiNwxM=
Message-ID: <1575137443.5563.18.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.4+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 30 Nov 2019 10:10:43 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is mostly update of the usual drivers: aacraid, ufs, zfcp,
NCR5380, lpfc, qla2xxx, smartpqi, hisi_sas, target, mpt3sas, pm80xx
plus a whole load of minor updates and fixes.  The two major core
changes are Al Viro's reworking of sg's handling of copy to/from user,
Ming Lei's removal of the host busy counter to avoid contention in the
multiqueue case and Damien Le Moal's fixing of residual tracking across
error handling.

We have one conflict in scsi_sysfs.c due to Paul McKenney's RCU change
(c0eaf15cd5d3 drivers/scsi: Replace rcu_swap_protected() with
rcu_replace_pointer) and an update to the sysfs parameters.  However,
the fix is pretty easy based on Paul's patch.

We're still chasing a performance regression on USB flash devices
triggered by the elimination of the legacy (non-mq) submission path,
but right at the moment it's looking like a block issue with multiqueue
and submission ordering:

https://lore.kernel.org/linux-scsi/Pine.LNX.4.44L0.1908201307540.1573-100000@iolanthe.rowland.org/

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Al Viro (8):
      scsi: sg: sg_ioctl(): get rid of access_ok()
      scsi: sg: sg_write(): get rid of access_ok()/__copy_from_user()/__get_user()
      scsi: sg: sg_read(): get rid of access_ok()/__copy_..._user()
      scsi: sg: sg_new_write(): don't bother with access_ok
      scsi: sg: sg_read(): simplify reading ->pack_id of userland sg_io_hdr_t
      scsi: sg: sg_write(): __get_user() can fail...
      scsi: sg: sg_new_write(): replace access_ok() + __copy_from_user() with copy_from_user()
      scsi: sg: sg_ioctl(): fix copyout handling

Anatol Pomazau (1):
      scsi: iscsi: Don't send data to unbound connection

Arkadiusz Drabczyk (1):
      scsi: csiostor: Fix spelling typos

Arun Easi (2):
      scsi: qla2xxx: Fix device connect issues in P2P configuration
      scsi: qla2xxx: Fix memory leak when sending I/O fails

Asutosh Das (1):
      scsi: ufs: Abort gating if clock on request is pending

Austin Kim (2):
      scsi: libcxgbi: remove unused function to stop warning
      scsi: qedf: Remove always false 'tmp_prio < 0' statement

Balsundar P (7):
      scsi: aacraid: bump version
      scsi: aacraid: send AIF request post IOP RESET
      scsi: aacraid: check adapter health
      scsi: aacraid: setting different timeout for src and thor
      scsi: aacraid: fixed firmware assert issue
      scsi: aacraid: fixed IO reporting error
      scsi: aacraid: fix illegal IO beyond last LBA

Bart Van Assche (14):
      scsi: target: core: Fix a pr_debug() argument
      scsi: target: iscsi: Wait for all commands to finish before freeing a session
      scsi: target: core: Release SPC-2 reservations when closing a session
      scsi: target: core: Document target_cmd_size_check()
      scsi: lpfc: Fix lpfc_cpumask_of_node_init()
      scsi: lpfc: Fix a kernel warning triggered by lpfc_sli4_enable_intr()
      scsi: lpfc: Fix a kernel warning triggered by lpfc_get_sgl_per_hdwq()
      scsi: qla2xxx: Fix a dma_pool_free() call
      scsi: qla2xxx: Remove an include directive
      scsi: tracing: Fix handling of TRANSFER LENGTH == 0 for READ(6) and WRITE(6)
      scsi: core: scsi_trace: Use get_unaligned_be*()
      scsi: ufs: Use enum dev_cmd_type where appropriate
      scsi: ufs: Fix kernel-doc warnings
      scsi: target: Remove tpg_list and se_portal_group.se_tpg_node

Bean Huo (3):
      scsi: ufs: fix potential bug which ends in system hang
      scsi: ufs: print helpful hint when response size exceed buffer size
      scsi: ufs: delete redundant function ufshcd_def_desc_sizes()

Benjamin Block (9):
      scsi: zfcp: move maximum age of diagnostic buffers into a per-adapter variable
      scsi: zfcp: implicitly refresh config-data diagnostics when reading sysfs
      scsi: zfcp: introduce sysfs interface to read the local B2B-Credit
      scsi: zfcp: implicitly refresh port-data diagnostics when reading sysfs
      scsi: zfcp: introduce sysfs interface for diagnostics of local SFP transceiver
      scsi: zfcp: support retrieval of SFP Data via Exchange Port Data
      scsi: zfcp: add diagnostics buffer for exchange config data
      scsi: zfcp: diagnostics buffer caching and use for exchange port data
      scsi: zfcp: signal incomplete or error for sync exchange config/port data

Can Guo (4):
      scsi: ufs: Fix register dump caused sleep in atomic context
      scsi: ufs: Fix up auto hibern8 enablement
      scsi: ufs-qcom: Add reset control support for host controller
      scsi: ufs: Add device reset in link recovery path

Chandrakanth Patil (1):
      scsi: megaraid_sas: Unique names for MSI-X vectors

Colin Ian King (10):
      scsi: arcmsr: fix indentation issues
      scsi: smartpqi: clean up an indentation issue
      scsi: csiostor: clean up indentation issue
      scsi: hisi_sas: fix spelling mistake "digial" -> "digital"
      scsi: ufs: make array setup_attrs static const, makes object smaller
      scsi: ips: make array 'options' static const, makes object smaller
      scsi: fnic: make array dev_cmd_err static const, makes object smaller
      scsi: mvsas: remove redundant assignment to variable rc
      scsi: qla2xxx: remove redundant assignment to pointer host
      scsi: smartpqi: clean up indentation of a statement

Damien Le Moal (3):
      scsi: target: tcmu: Prevent memory reclaim recursion
      scsi: core: Fix scsi_get/set_resid() interface
      scsi: core: save/restore command resid for error handling

Dan Carpenter (3):
      scsi: esas2r: unlock on error in esas2r_nvram_read_direct()
      scsi: csiostor: Don't enable IRQs too early
      scsi: mpt3sas: Clean up some indenting

Daniel Wagner (2):
      scsi: qla2xxx: Remove WARN_ON_ONCE in qla2x00_status_cont_entry()
      scsi: qedf: Add port_id getter

David Disseldorp (3):
      scsi: target: remove unused extension parameters
      scsi: target: fix SendTargets=All string compares
      scsi: target: compare full CHAP_A Algorithm strings

Deepak Ukey (2):
      scsi: pm80xx: Modified the logic to collect fatal dump
      scsi: pm80xx: Controller fatal error through sysfs

Don Brace (1):
      scsi: smartpqi: bump version

Finn Thain (5):
      scsi: NCR5380: Add disconnect_mask module parameter
      scsi: NCR5380: Unconditionally clear ICR after do_abort()
      scsi: NCR5380: Call scsi_set_resid() on command completion
      scsi: core: Clean up SG_NONE
      scsi: atari_scsi: sun3_scsi: Set sg_tablesize to 1 instead of SG_NONE

Geert Uytterhoeven (2):
      scsi: Fix various misspellings of "connect"
      scsi: isci: Spelling s/configruation/configuration/

Himanshu Madhani (5):
      scsi: qla2xxx: Update driver version to 10.01.00.21-k
      scsi: qla2xxx: Update driver version to 10.01.00.20-k
      scsi: qla2xxx: Improve logging for scan thread
      scsi: MAINTAINERS: Update qla2xxx driver
      scsi: qla2xxx: Silence fwdump template message

James Smart (56):
      scsi: lpfc: use hdwq assigned cpu for allocation
      scsi: lpfc: Update lpfc version to 12.6.0.2
      scsi: lpfc: revise nvme max queues to be hdwq count
      scsi: lpfc: Initialize cpu_map for not present cpus
      scsi: lpfc: fix inlining of lpfc_sli4_cleanup_poll_list()
      scsi: lpfc: fix: Coverity: lpfc_cmpl_els_rsp(): Null pointer dereferences
      scsi: lpfc: fix: Coverity: lpfc_get_scsi_buf_s3(): Null pointer dereferences
      scsi: lpfc: Update lpfc version to 12.6.0.1
      scsi: lpfc: Add enablement of multiple adapter dumps
      scsi: lpfc: Change default IRQ model on AMD architectures
      scsi: lpfc: Add registration for CPU Offline/Online events
      scsi: lpfc: Clarify FAWNN error message
      scsi: lpfc: Sync with FC-NVMe-2 SLER change to require Conf with SLER
      scsi: lpfc: Fix dynamic fw log enablement check
      scsi: lpfc: Fix unexpected error messages during RSCN handling
      scsi: lpfc: Fix kernel crash at lpfc_nvme_info_show during remote port bounce
      scsi: lpfc: Fix configuration of BB credit recovery in service parameters
      scsi: lpfc: Fix duplicate unreg_rpi error in port offline flow
      scsi: lpfc: fix spelling error in MAGIC_NUMER_xxx
      scsi: lpfc: fix build error of lpfc_debugfs.c for vfree/vmalloc
      scsi: lpfc: Update lpfc version to 12.6.0.0
      scsi: lpfc: Add additional discovery log messages
      scsi: lpfc: Add FC-AL support to lpe32000 models
      scsi: lpfc: Add FA-WWN Async Event reporting
      scsi: lpfc: Add log macros to allow print by serverity or verbosity setting
      scsi: lpfc: Make FW logging dynamically configurable
      scsi: lpfc: Revise interrupt coalescing for missing scenarios
      scsi: lpfc: Remove lock contention target write path
      scsi: lpfc: Slight fast-path performance optimizations
      scsi: lpfc: fix coverity error of dereference after null check
      scsi: lpfc: Fix hardlockup in lpfc_abort_handler
      scsi: lpfc: Fix bad ndlp ptr in xri aborted handling
      scsi: lpfc: Fix SLI3 hba in loop mode not discovering devices
      scsi: lpfc: Fix lockdep errors in sli_ringtx_put
      scsi: lpfc: Fix reporting of read-only fw error errors
      scsi: lpfc: fix lpfc_nvmet_mrq to be bound by hdw queue count
      scsi: lpfc: Update lpfc version to 12.4.0.1
      scsi: lpfc: cleanup: remove unused fcp_txcmlpq_cnt
      scsi: lpfc: Complete removal of FCoE T10 PI support on SLI-4 adapters
      scsi: lpfc: Update async event logging
      scsi: lpfc: Fix list corruption detected in lpfc_put_sgl_per_hdwq
      scsi: lpfc: Fix hdwq sgl locks and irq handling
      scsi: lpfc: Fix spinlock_irq issues in lpfc_els_flush_cmd()
      scsi: lpfc: Fix list corruption in lpfc_sli_get_iocbq
      scsi: lpfc: Fix host hang at boot or slow boot
      scsi: lpfc: Fix coverity errors on NULL pointer checks
      scsi: lpfc: Fix NVMe ABTS in response to receiving an ABTS
      scsi: lpfc: Fix discovery failures when target device connectivity bounces
      scsi: lpfc: Fix GPF on scsi command completion
      scsi: lpfc: Fix locking on mailbox command completion
      scsi: lpfc: Fix device recovery errors after PLOGI failures
      scsi: lpfc: Fix rpi release when deleting vport
      scsi: lpfc: Fix NVME io abort failures causing hangs
      scsi: lpfc: Fix miss of register read failure check
      scsi: lpfc: Fix premature re-enabling of interrupts in lpfc_sli_host_down
      scsi: lpfc: Fix pt2pt discovery on SLI3 HBAs

Johan Hovold (2):
      scsi: nsp_cs: enable compile-testing on 64-bit
      scsi: nsp_cs: drop redundant MODULE_LICENSE ifdef

John Garry (1):
      scsi: hisi_sas: Stop converting a bool into a bool

John Sperbeck (1):
      scsi: pm80xx: Initialize variable used as return status

Kars de Jong (1):
      scsi: zorro_esp: Limit DMA transfers to 65536 bytes (except on Fastlane)

Kevin Barnett (6):
      scsi: smartpqi: Align driver syntax with oob
      scsi: smartpqi: remove unused manifest constants
      scsi: smartpqi: fix problem with unique ID for physical device
      scsi: smartpqi: correct syntax issue
      scsi: smartpqi: change TMF timeout from 60 to 30 seconds
      scsi: smartpqi: fix controller lockup observed during force reboot

Laurence Oberman (2):
      scsi: bnx2fc: timeout calculation invalid for bnx2fc_eh_abort()
      scsi: bnx2fc: Handle scope bits when array returns BUSY or TSF

Long Li (1):
      scsi: storvsc: setup 1:1 mapping between hardware queue and CPU queue

Luo Jiaxing (14):
      scsi: hisi_sas: Record the phy down event in debugfs
      scsi: hisi_sas: Delete the debugfs folder of hisi_sas when the probe fails
      scsi: hisi_sas: Add ability to have multiple debugfs dumps
      scsi: hisi_sas: Add module parameter for debugfs dump count
      scsi: hisi_sas: Allocate memory for multiple dumps of debugfs
      scsi: hisi_sas: Add debugfs file structure for ITCT cache
      scsi: hisi_sas: Add debugfs file structure for IOST cache
      scsi: hisi_sas: Add debugfs file structure for ITCT
      scsi: hisi_sas: Add debugfs file structure for IOST
      scsi: hisi_sas: Add debugfs file structure for port
      scsi: hisi_sas: Add debugfs file structure for registers
      scsi: hisi_sas: Add debugfs file structure for DQ
      scsi: hisi_sas: Add debugfs file structure for CQ
      scsi: hisi_sas: Add timestamp for a debugfs dump

Markus Elfring (1):
      scsi: ufs-hisi: Use PTR_ERR_OR_ZERO() in ufs_hisi_get_resource()

Martin K. Petersen (1):
      Revert "scsi: qla2xxx: Fix memory leak when sending I/O fails"

Martin Wilck (2):
      scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME
      scsi: qla2xxx: initialize fc4_type_priority

Masahiro Yamada (1):
      scsi: ch: add include guard to chio.h

Maurizio Lombardi (4):
      scsi: scsi_debug: num_tgts must be >= 0
      scsi: target: iscsi: rename some variables to avoid confusion.
      scsi: target: iscsi: tie the challenge length to the hash digest size
      scsi: target: iscsi: CHAP: add support for SHA1, SHA256 and SHA3-256

Michael Hernandez (1):
      scsi: qla2xxx: Dual FCP-NVMe target port support

Milan P. Gandhi (1):
      scsi: core: Log SCSI command age with errors

Ming Lei (1):
      scsi: core: avoid host-wide host_busy counter for scsi_mq

Murthy Bhat (2):
      scsi: smartpqi: fix LUN reset when fw bkgnd thread is hung
      scsi: smartpqi: fix call trace in device discovery

Navid Emamdoost (1):
      scsi: bfa: release allocated memory in case of error

Oliver Neukum (1):
      scsi: sd: Ignore a failure to sync cache due to lack of authorization

Pan Bian (3):
      scsi: bnx2i: fix potential use after free
      scsi: qla4xxx: fix double free bug
      scsi: fnic: fix use after free

Quinn Tran (15):
      scsi: qla2xxx: Fix double scsi_done for abort path
      scsi: qla2xxx: Fix driver unload hang
      scsi: qla2xxx: Fix SRB leak on switch command timeout
      scsi: qla2xxx: Do command completion on abort timeout
      scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure
      scsi: qla2xxx: Capture FW dump on MPI heartbeat stop event
      scsi: qla2xxx: Check for MB timeout while capturing ISP27/28xx FW dump
      scsi: qla2xxx: Set remove flag for all VP
      scsi: qla2xxx: Add error handling for PLOGI ELS passthrough
      scsi: qla2xxx: Fix Nport ID display value
      scsi: qla2xxx: Fix N2N link up fail
      scsi: qla2xxx: Fix N2N link reset
      scsi: qla2xxx: Optimize NPIV tear down process
      scsi: qla2xxx: Fix stale mem access on driver unload
      scsi: qla2xxx: Fix unbound sleep in fcport delete path.

Ryan Attard (1):
      scsi: core: Add sysfs attributes for VPD pages 0h and 89h

Saurav Girepunje (6):
      scsi: csiostor: Return value not required for csio_dfs_destroy
      scsi: csiostor: Fix NULL check before debugfs_remove_recursive
      scsi: pm8001: Fix Use plain integer as NULL pointer
      scsi: lpfc: Fix NULL check before mempool_destroy is not needed
      scsi: lpfc: lpfc_nvmet: Fix Use plain integer as NULL pointer
      scsi: lpfc: lpfc_attr: Fix Use plain integer as NULL pointer

Sreekanth Reddy (13):
      scsi: mpt3sas: Bump mpt3sas driver version to 32.100.00.00
      scsi: mpt3sas: Fix module parameter max_msix_vectors
      scsi: mpt3sas: Reject NVMe Encap cmnds to unsupported HBA
      scsi: mpt3sas: Use Component img header to get Package ver
      scsi: mpt3sas: Fail release cmnd if diag buffer is released
      scsi: mpt3sas: Add app owned flag support for diag buffer
      scsi: mpt3sas: Reuse diag buffer allocated at load time
      scsi: mpt3sas: clear release bit when buffer reregistered
      scsi: mpt3sas: Maintain owner of buffer through UniqueID
      scsi: mpt3sas: Free diag buffer without any status check
      scsi: mpt3sas: Fix clear pending bit in ioctl status
      scsi: mpt3sas: Display message before releasing diag buffer
      scsi: mpt3sas: Register trace buffer based on NVDATA settings

Stanley Chu (4):
      scsi: ufs-mediatek: enable auto suspend capability
      scsi: ufs: override auto suspend tunables for ufs
      scsi: core: allow auto suspend override by low-level driver
      scsi: ufs: skip shutdown if hba is not powered

Steffen Maier (3):
      scsi: zfcp: trace channel log even for FCP command responses
      scsi: zfcp: proper indentation to reduce confusion in zfcp_erp_required_act
      scsi: zfcp: fix reaction on bit error threshold notification

Subhash Jadavani (1):
      scsi: ufs: Fix error handing during hibern8 enter

Tomas Henzl (1):
      scsi: mpt3sas: change allocation option

Venkat Gopalakrishnan (1):
      scsi: ufs: Fix irq return code

Vignesh Raghavendra (2):
      scsi: ufs: Add driver for TI wrapper for Cadence UFS IP
      scsi: dt-bindings: ufs: ti,j721e-ufs.yaml: Add binding for TI UFS wrapper

Vikram Auradkar (3):
      scsi: pm80xx: Tie the interrupt name to the module instance
      scsi: pm80xx: Fix dereferencing dangling pointer
      scsi: pm80xx: Convert 'long' mdelay to msleep

Vinod Koul (1):
      scsi: dt-bindings: ufs: Add sm8150 compatible string

Xiang Chen (8):
      scsi: hisi_sas: Relocate call to hisi_sas_debugfs_exit()
      scsi: hisi_sas: Return directly if init hardware failed
      scsi: hisi_sas: Check sas_port before using it
      scsi: hisi_sas: Replace in_softirq() check in hisi_sas_task_exec()
      scsi: hisi_sas: use wait_for_completion_timeout() when clearing ITCT
      scsi: hisi_sas: Set the BIST init value before enabling BIST
      scsi: hisi_sas: Don't create debugfs dump folder twice
      scsi: megaraid: disable device when probe failed after enabled device

YueHaibing (8):
      scsi: ufs: ufshcd: Remove dev_err() on platform_get_irq() failure
      scsi: csiostor: Remove set but not used variable 'rln'
      scsi: lpfc: Make lpfc_debugfs_ras_log_data static
      scsi: cxgb4i: remove set but not used variable 'ppmax'
      scsi: cxlflash: remove set but not used variable 'ioarcb'
      scsi: bfa: Make restart_bfa static
      scsi: smartpqi: remove set but not used variable 'ctrl_info'
      scsi: hisi_sas: Make three functions static

ianyar (1):
      scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check

koshyaji (1):
      scsi: smartpqi: add inquiry timeouts

peter chang (6):
      scsi: pm80xx: Do not request 12G sas speeds
      scsi: pm80xx: Cleanup command when a reset times out
      scsi: pm80xx: Fix command issue sizing
      scsi: pm80xx: Squashed logging cleanup changes
      scsi: pm80xx: Make phy enable completion as NULL
      scsi: pm80xx: Fix for SATA device discovery

zhengbin (2):
      scsi: megaraid_sas: remove unused variables 'debugBlk','fusion'
      scsi: lpfc: Make function lpfc_defer_pt2pt_acc static

And the diffstat:

 .../devicetree/bindings/ufs/ti,j721e-ufs.yaml      |  68 ++
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   1 +
 Documentation/scsi/scsi_mid_low_api.txt            |   3 +-
 MAINTAINERS                                        |   2 +-
 drivers/ata/pata_arasan_cf.c                       |   1 -
 drivers/s390/scsi/Makefile                         |   2 +-
 drivers/s390/scsi/zfcp_aux.c                       |  12 +-
 drivers/s390/scsi/zfcp_dbf.c                       |   8 +-
 drivers/s390/scsi/zfcp_def.h                       |   4 +-
 drivers/s390/scsi/zfcp_diag.c                      | 305 +++++++
 drivers/s390/scsi/zfcp_diag.h                      | 101 +++
 drivers/s390/scsi/zfcp_erp.c                       |   4 +-
 drivers/s390/scsi/zfcp_ext.h                       |   1 +
 drivers/s390/scsi/zfcp_fsf.c                       |  89 +-
 drivers/s390/scsi/zfcp_fsf.h                       |  21 +-
 drivers/s390/scsi/zfcp_scsi.c                      |   4 +-
 drivers/s390/scsi/zfcp_sysfs.c                     | 170 +++-
 drivers/scsi/NCR5380.c                             |  37 +-
 drivers/scsi/aacraid/aachba.c                      |  11 +-
 drivers/scsi/aacraid/aacraid.h                     |  23 +-
 drivers/scsi/aacraid/comminit.c                    |   5 +
 drivers/scsi/aacraid/commsup.c                     |  21 +-
 drivers/scsi/aacraid/linit.c                       |  35 +-
 drivers/scsi/aacraid/src.c                         |  10 +
 drivers/scsi/arcmsr/arcmsr_hba.c                   |   6 +-
 drivers/scsi/arm/acornscsi.c                       |   4 +-
 drivers/scsi/atari_scsi.c                          |   6 +-
 drivers/scsi/atp870u.c                             |   2 +-
 drivers/scsi/bfa/bfad.c                            |   3 +-
 drivers/scsi/bfa/bfad_attr.c                       |   4 +-
 drivers/scsi/bnx2fc/57xx_hsi_bnx2fc.h              |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |  31 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                   |   2 +-
 drivers/scsi/csiostor/csio_hw.c                    |  20 +-
 drivers/scsi/csiostor/csio_init.c                  |   7 +-
 drivers/scsi/csiostor/csio_lnode.c                 |  18 +-
 drivers/scsi/csiostor/csio_mb.c                    |   2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c                 |   2 -
 drivers/scsi/cxgbi/libcxgbi.c                      |  28 -
 drivers/scsi/cxlflash/main.c                       |   2 -
 drivers/scsi/esas2r/esas2r_flash.c                 |   1 +
 drivers/scsi/fnic/fnic_scsi.c                      |   3 +-
 drivers/scsi/fnic/vnic_dev.c                       |   2 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |  67 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 378 +++++---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  13 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |  30 +-
 drivers/scsi/hosts.c                               |  19 +-
 drivers/scsi/ips.c                                 |   2 +-
 drivers/scsi/isci/port_config.c                    |   2 +-
 drivers/scsi/isci/remote_device.c                  |   2 +-
 drivers/scsi/iscsi_tcp.c                           |   8 +
 drivers/scsi/lpfc/lpfc.h                           |  40 +-
 drivers/scsi/lpfc/lpfc_attr.c                      | 298 +++++--
 drivers/scsi/lpfc/lpfc_bsg.c                       |  18 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |   7 +
 drivers/scsi/lpfc/lpfc_ct.c                        |  28 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   | 118 ++-
 drivers/scsi/lpfc/lpfc_els.c                       |  57 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   | 200 +++--
 drivers/scsi/lpfc/lpfc_hw4.h                       |  31 +-
 drivers/scsi/lpfc/lpfc_init.c                      | 954 ++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_logmsg.h                    |  17 +
 drivers/scsi/lpfc/lpfc_mbox.c                      |   1 +
 drivers/scsi/lpfc/lpfc_mem.c                       |   3 -
 drivers/scsi/lpfc/lpfc_nportdisc.c                 | 149 +++-
 drivers/scsi/lpfc/lpfc_nvme.c                      |  85 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                     | 103 +--
 drivers/scsi/lpfc/lpfc_nvmet.h                     |   2 -
 drivers/scsi/lpfc/lpfc_scsi.c                      |  43 +-
 drivers/scsi/lpfc/lpfc_sli.c                       | 391 +++++++--
 drivers/scsi/lpfc/lpfc_sli.h                       |   3 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |  42 +-
 drivers/scsi/lpfc/lpfc_version.h                   |   2 +-
 drivers/scsi/mac_scsi.c                            |   2 +-
 drivers/scsi/megaraid.c                            |   4 +-
 drivers/scsi/megaraid/megaraid_sas.h               |   3 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |   8 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c            |   7 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                |  36 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |  15 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 | 344 +++++++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.h                 |   9 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c        |  12 +-
 drivers/scsi/mvsas/mv_sas.c                        |   2 +-
 drivers/scsi/ncr53c8xx.c                           |   2 +-
 drivers/scsi/nsp32.c                               |   2 +-
 drivers/scsi/pcmcia/Kconfig                        |   2 +-
 drivers/scsi/pcmcia/nsp_cs.c                       |   2 -
 drivers/scsi/pm8001/pm8001_ctl.c                   |  20 +
 drivers/scsi/pm8001/pm8001_hwi.c                   | 131 ++-
 drivers/scsi/pm8001/pm8001_init.c                  |  36 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |  70 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |  24 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   | 451 +++++++---
 drivers/scsi/pm8001/pm80xx_hwi.h                   |   3 +
 drivers/scsi/qedf/qedf_dbg.h                       |   2 +-
 drivers/scsi/qedf/qedf_main.c                      |  10 +-
 drivers/scsi/qedi/qedi_dbg.h                       |   2 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |   6 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  38 +-
 drivers/scsi/qla2xxx/qla_fw.h                      |   2 +
 drivers/scsi/qla2xxx/qla_gbl.h                     |   1 +
 drivers/scsi/qla2xxx/qla_gs.c                      |  69 +-
 drivers/scsi/qla2xxx/qla_init.c                    | 197 +++--
 drivers/scsi/qla2xxx/qla_inline.h                  |  12 +
 drivers/scsi/qla2xxx/qla_iocb.c                    | 113 ++-
 drivers/scsi/qla2xxx/qla_isr.c                     |  38 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  38 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |  43 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |   4 +-
 drivers/scsi/qla2xxx/qla_os.c                      | 190 ++--
 drivers/scsi/qla2xxx/qla_target.c                  |  28 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |  29 +-
 drivers/scsi/qla2xxx/qla_version.h                 |   2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                     |   3 -
 drivers/scsi/scsi.c                                |   6 +-
 drivers/scsi/scsi_debug.c                          |   9 +-
 drivers/scsi/scsi_error.c                          |   3 +
 drivers/scsi/scsi_lib.c                            |  45 +-
 drivers/scsi/scsi_logging.c                        |  10 +-
 drivers/scsi/scsi_priv.h                           |   2 +-
 drivers/scsi/scsi_sysfs.c                          |  22 +-
 drivers/scsi/scsi_trace.c                          | 124 +--
 drivers/scsi/sd.c                                  |   7 +-
 drivers/scsi/sg.c                                  |  98 +--
 drivers/scsi/smartpqi/smartpqi.h                   |  77 +-
 drivers/scsi/smartpqi/smartpqi_init.c              | 437 ++++++----
 drivers/scsi/smartpqi/smartpqi_sas_transport.c     |  22 +-
 drivers/scsi/storvsc_drv.c                         |   3 +-
 drivers/scsi/sun3_scsi.c                           |   4 +-
 drivers/scsi/ufs/Kconfig                           |  10 +
 drivers/scsi/ufs/Makefile                          |   1 +
 drivers/scsi/ufs/ti-j721e-ufs.c                    |  90 ++
 drivers/scsi/ufs/ufs-hisi.c                        |   5 +-
 drivers/scsi/ufs/ufs-mediatek.c                    |   3 +
 drivers/scsi/ufs/ufs-qcom.c                        |  53 ++
 drivers/scsi/ufs/ufs-qcom.h                        |   3 +
 drivers/scsi/ufs/ufs-sysfs.c                       |  15 +-
 drivers/scsi/ufs/ufs_bsg.c                         |   1 +
 drivers/scsi/ufs/ufshcd-dwc.c                      |   2 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   1 -
 drivers/scsi/ufs/ufshcd.c                          | 217 +++--
 drivers/scsi/ufs/ufshcd.h                          |  12 +
 drivers/scsi/ufs/ufshci.h                          |   2 +-
 drivers/scsi/zorro_esp.c                           |  11 +-
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c           |   3 -
 drivers/target/iscsi/iscsi_target.c                |  24 +-
 drivers/target/iscsi/iscsi_target_auth.c           | 232 +++--
 drivers/target/iscsi/iscsi_target_auth.h           |  17 +-
 drivers/target/iscsi/iscsi_target_parameters.h     |   3 -
 drivers/target/target_core_fabric_lib.c            |   2 +-
 drivers/target/target_core_tpg.c                   |  12 -
 drivers/target/target_core_transport.c             |  28 +
 drivers/target/target_core_user.c                  |   6 +-
 drivers/target/target_core_xcopy.c                 |   1 -
 drivers/usb/storage/ene_ub6250.c                   |   2 +-
 drivers/usb/storage/transport.c                    |   3 +-
 drivers/usb/storage/uas.c                          |   1 -
 include/scsi/iscsi_proto.h                         |   1 +
 include/scsi/scsi_cmnd.h                           |   5 +-
 include/scsi/scsi_device.h                         |   5 +-
 include/scsi/scsi_eh.h                             |   1 +
 include/scsi/scsi_host.h                           |  19 +-
 include/target/target_core_base.h                  |   1 -
 include/uapi/linux/chio.h                          |  11 +-
 168 files changed, 5830 insertions(+), 2060 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ti,j721e-ufs.yaml
 create mode 100644 drivers/s390/scsi/zfcp_diag.c
 create mode 100644 drivers/s390/scsi/zfcp_diag.h
 create mode 100644 drivers/scsi/ufs/ti-j721e-ufs.c

James

