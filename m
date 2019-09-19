Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE32FC49ED7
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 22:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B52B206C2
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 22:47:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="vzgVRP/P";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="vzgVRP/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393559AbfISWrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 18:47:32 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51544 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389023AbfISWrc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 18:47:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 84A3C8EE236;
        Thu, 19 Sep 2019 15:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1568933251;
        bh=ghyOWEL9SPud/nTuEqj3UJtVs9KYNtVDvJWLnL0VSiE=;
        h=Subject:From:To:Cc:Date:From;
        b=vzgVRP/P7kBNUwC49Gca7XUwqmrIURGxVkRXdX9BTnIn40tK9lQARXvlKtZwKKf0q
         IZzIRWtyneYRqeWAF1WADE1IhlbssPfj48x2St40so7b7WsB5Tyytrp0FgRcGI3KWT
         HAZptsaDWaSCgcu99yQPyqf7dcTGPpjOYQTIFChw=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IYXvt3rRoZGN; Thu, 19 Sep 2019 15:47:31 -0700 (PDT)
Received: from jarvis.lan (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id E52098EE0ED;
        Thu, 19 Sep 2019 15:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1568933251;
        bh=ghyOWEL9SPud/nTuEqj3UJtVs9KYNtVDvJWLnL0VSiE=;
        h=Subject:From:To:Cc:Date:From;
        b=vzgVRP/P7kBNUwC49Gca7XUwqmrIURGxVkRXdX9BTnIn40tK9lQARXvlKtZwKKf0q
         IZzIRWtyneYRqeWAF1WADE1IhlbssPfj48x2St40so7b7WsB5Tyytrp0FgRcGI3KWT
         HAZptsaDWaSCgcu99yQPyqf7dcTGPpjOYQTIFChw=
Message-ID: <1568933249.25516.10.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.3+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 19 Sep 2019 15:47:29 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is mostly update of the usual drivers: qla2xxx, ufs, smartpqi,
lpfc, hisi_sas, qedf, mpt3sas; plus a whole load of minor updates.  The
only core change this time around is the addition of request batching
for virtio.  Since batching requires an additional flag to use, it
should be invisible to the rest of the drivers.

We also have a couple of conflicts based on previously submitted fixes
through our tree in lpfc_sli4.h and qla_os.c, due to concurrent
changes, so the resolution is pretty easy.  Just in case it's also
available in this for-next tree:

https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/commit/?h=for-next&id=1a1de384df1d6acef5576901923345d03be7c877

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Andrew Vasquez (2):
      scsi: qla2xxx: Use common update-firmware-options routine for ISP27xx+
      scsi: qla2xxx: Correct error handling during initialization failures

Andy Shevchenko (1):
      scsi: scsi_debugfs: Use for_each_set_bit to simplify code

Anil Varughese (2):
      scsi: ufs: Disable local LCC in .link_startup_notify() in Cadence UFS
      scsi: ufs: Configure clock in .hce_enable_notify() in Cadence UFS

Arun Easi (2):
      scsi: qedf: Fix crash during sg_reset
      scsi: qla2xxx: Fix NVMe port discovery after a short device port loss

Avri Altman (1):
      scsi: ufs: uapi: Fix SPDX license identifier

Bart Van Assche (62):
      scsi: qla2xxx: Fix a recently introduced kernel warning
      scsi: qla2xxx: Fix a NULL pointer dereference
      scsi: qla2xxx: Simplify qla24xx_async_abort_cmd()
      scsi: qla2xxx: Remove two superfluous if-tests
      scsi: qla2xxx: Introduce qla2x00_els_dcmd2_free()
      scsi: qla2xxx: Inline the qla2x00_fcport_event_handler() function
      scsi: qla2xxx: Report invalid mailbox status codes
      scsi: qla2xxx: Remove superfluous sts_entry_* casts
      scsi: qla2xxx: Let the compiler check the type of the SCSI command context pointer
      scsi: qla2xxx: Complain if sp->done() is not called from the completion path
      scsi: qla2xxx: Make sure that aborted commands are freed
      scsi: qla2xxx: Introduce qla2xxx_get_next_handle()
      scsi: qla2xxx: Modify NVMe include directives
      scsi: qla2xxx: Make qlt_handle_abts_completion() more robust
      scsi: qla2xxx: Fix a race condition between aborting and completing a SCSI command
      scsi: qla2xxx: Introduce the function qla2xxx_init_sp()
      scsi: qla2xxx: Enable type checking for the SRB free and done callback functions
      scsi: qla2xxx: Rework key encoding in qlt_find_host_by_d_id()
      scsi: qla2xxx: Set the responder mode if appropriate for ELS pass-through IOCBs
      scsi: qla2xxx: Make it explicit that ELS pass-through IOCBs use little endian
      scsi: qla2xxx: Check secondary image if reading the primary image fails
      scsi: qla2xxx: Change the return type of qla24xx_read_flash_data()
      scsi: qla2xxx: Introduce the be_id_t and le_id_t data types for FC src/dst IDs
      scsi: qla2xxx: Complain if a soft reset fails
      scsi: qla2xxx: Use memcpy() and strlcpy() instead of strcpy() and strncpy()
      scsi: qla2xxx: Check the PCI info string output buffer size
      scsi: qla2xxx: Complain if waiting for pending commands times out
      scsi: qla2xxx: Declare fourth qla2x00_set_model_info() argument const
      scsi: qla2xxx: Always check the qla2x00_wait_for_hba_online() return value
      scsi: qla2xxx: Suppress multiple Coverity complaint about out-of-bounds accesses
      scsi: qla2xxx: Suppress a Coveritiy complaint about integer overflow
      scsi: qla2xxx: Remove unreachable code from qla83xx_idc_lock()
      scsi: qla2xxx: Fix qla24xx_process_bidir_cmd()
      scsi: qla2xxx: Simplify a debug statement
      scsi: qla2xxx: Remove dead code
      scsi: qla2xxx: Complain if parsing the version string fails
      scsi: qla2xxx: Complain if a mailbox command times out
      scsi: qla2xxx: Use strlcpy() instead of strncpy()
      scsi: qla2xxx: Do not corrupt vha->plogi_ack_list
      scsi: qla2xxx: Report the firmware status code if a mailbox command fails
      scsi: qla2xxx: Fix session lookup in qlt_abort_work()
      scsi: qla2xxx: Simplify qla24xx_abort_sp_done()
      scsi: qla2xxx: Remove two superfluous tests
      scsi: qla2xxx: Remove a superfluous pointer check
      scsi: qla2xxx: Simplify qlt_lport_dump()
      scsi: qla2xxx: Reduce the number of casts in GID list code
      scsi: qla2xxx: Verify locking assumptions at runtime
      scsi: qla2xxx: Change data_dsd into an array
      scsi: qla2xxx: Declare qla_tgt_cmd.cdb const
      scsi: qla2xxx: Reduce the scope of three local variables in qla2xxx_queuecommand()
      scsi: qla2xxx: Change the return type of qla2x00_update_ms_fdmi_iocb() into void
      scsi: qla2xxx: Declare the fourth ql_dump_buffer() argument const
      scsi: qla2xxx: Remove a superfluous forward declaration
      scsi: qla2xxx: Remove an include directive from qla_mr.c
      scsi: qla2xxx: Include the <asm/unaligned.h> header file from qla_dsd.h
      scsi: qla2xxx: Use tabs instead of spaces for indentation
      scsi: qla2xxx: Improve Linux kernel coding style conformance
      scsi: qla2xxx: Really fix qla2xxx_eh_abort()
      scsi: qla2xxx: Make qla2x00_abort_srb() again decrease the sp reference count
      scsi: core: Reduce memory required for SCSI logging
      scsi: core: Complain if scsi_target_block() fails
      scsi: core: Make scsi_internal_device_unblock_nowait() reject invalid new_state

Bean Huo (1):
      scsi: ufs: change msleep to usleep_range

Bjorn Andersson (3):
      scsi: arm64: dts: qcom: sdm845: Specify UFS device-reset GPIO
      scsi: ufs-qcom: Implement device_reset vops
      scsi: ufs: Introduce vops for resetting device

Chandrakanth Patil (1):
      scsi: megaraid_sas: Introduce module parameter for default queue depth

Christophe JAILLET (1):
      scsi: pmcraid: Fix a typo - pcmraid --> pmcraid

Chuhong Yuan (1):
      scsi: qla2xxx: Replace vmalloc + memset with vzalloc

Colin Ian King (6):
      scsi: qla2xxx: fix spelling mistake "initializatin" -> "initialization"
      scsi: fcoe: remove redundant call to skb_transport_header
      scsi: bfa: remove redundant assignment to variable error
      scsi: fnic: remove redundant assignment of variable rc
      scsi: sym53c8xx_2: remove redundant assignment to retv
      scsi: pm80xx: remove redundant assignments to variable rc

Damien Le Moal (1):
      scsi: sd: Improve unaligned completion resid message

Dan Carpenter (1):
      scsi: mpt3sas: clean up a couple sizeof() uses

Dave Carroll (1):
      scsi: smartpqi: add module param to hide vsep

Don Brace (2):
      scsi: smartpqi: bump version
      scsi: smartpqi: update copyright

Frederick Lawler (2):
      scsi: esas2r: Prefer pcie_capability_read_word()
      scsi: csiostor: Prefer pcie_capability_read_word()

Fuqian Huang (2):
      scsi: lpfc: use spin_lock_irqsave in IRQ context
      scsi: lpfc: remove redundant code

Gilbert Wu (5):
      scsi: smartpqi: add new pci ids
      scsi: smartpqi: add gigabyte controller
      scsi: smartpqi: add bay identifier
      scsi: smartpqi: add pci ids for fiberhome controller
      scsi: smartpqi: add module param for exposure order

Govindarajulu Varadarajan (1):
      scsi: fnic: fix msix interrupt allocation

Gustavo A. R. Silva (7):
      scsi: fas216: Mark expected switch fall-throughs
      scsi: wd33c93: Mark expected switch fall-through
      scsi: sun3_scsi: Mark expected switch fall-throughs
      scsi: qlogicpti: Mark expected switch fall-throughs
      scsi: ibmvfc: Mark expected switch fall-throughs
      scsi: ibmvscsi_tgt: Mark expected switch fall-throughs
      scsi: cxlflash: Mark expected switch fall-throughs

Hannes Reinecke (1):
      scsi: qedf: Use discovery list to traverse rports

Hariprasad Kelam (1):
      scsi: lpfc: remove NULL check before some freeing functions

Helge Deller (1):
      scsi: ncr53c8xx: Mark expected switch fall-through

Himanshu Madhani (5):
      scsi: qla2xxx: Update driver version to 10.01.00.19-k
      scsi: qla2xxx: Fix driver reload for ISP82xx
      scsi: qla2xxx: Fix message indicating vectors used by driver
      scsi: qla2xxx: Update driver version to 10.01.00.18-k
      scsi: qla2xxx: Fix DMA unmap leak

James Smart (46):
      scsi: lpfc: Fix reset recovery paths that are not recovering
      scsi: lpfc: fix 12.4.0.0 GPF at boot
      scsi: lpfc: Remove bg debugfs buffers
      scsi: lpfc: Resolve checker warning for lpfc_new_io_buf()
      scsi: lpfc: Update lpfc version to 12.4.0.0
      scsi: lpfc: Merge per-protocol WQ/CQ pairs into single per-cpu pair
      scsi: lpfc: Add NVMe sequence level error recovery support
      scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.
      scsi: lpfc: Add MDS driver loopback diagnostics support
      scsi: lpfc: Add first and second level hardware revisions to sysfs reporting
      scsi: lpfc: Migrate to %px and %pf in kernel print calls
      scsi: lpfc: Add simple unlikely optimizations to reduce NVME latency
      scsi: lpfc: Fix coverity warnings
      scsi: lpfc: Fix nvme first burst module parameter description
      scsi: lpfc: Fix BlockGuard enablement on FCoE adapters
      scsi: lpfc: Fix reported physical link speed on a disabled trunked link
      scsi: lpfc: Fix Max Frame Size value shown in fdmishow output
      scsi: lpfc: Fix upcall to bsg done in non-success cases
      scsi: lpfc: Fix sli4 adapter initialization with MSI
      scsi: lpfc: Fix nvme sg_seg_cnt display if HBA does not support NVME
      scsi: lpfc: Fix nvme target mode ABTSing a received ABTS
      scsi: lpfc: Fix hang when downloading fw on port enabled for nvme
      scsi: lpfc: Fix too many sg segments spamming in kernel log
      scsi: lpfc: Fix crash due to port reset racing vs adapter error handling
      scsi: lpfc: Fix deadlock on host_lock during cable pulls
      scsi: lpfc: Fix error in remote port address change
      scsi: lpfc: Fix driver nvme rescan logging
      scsi: lpfc: Fix sg_seg_cnt for HBAs that don't support NVME
      scsi: lpfc: Fix propagation of devloss_tmo setting to nvme transport
      scsi: lpfc: Fix loss of remote port after devloss due to lack of RPIs
      scsi: lpfc: Fix devices that don't return after devloss followed by rediscovery
      scsi: lpfc: Fix null ptr oops updating lpfc_devloss_tmo via sysfs attribute
      scsi: lpfc: Fix FLOGI handling across multiple link up/down conditions
      scsi: lpfc: Fix oops when fewer hdwqs than cpus
      scsi: lpfc: Fix irq raising in lpfc_sli_hba_down
      scsi: lpfc: Fix Oops in nvme_register with target logout/login
      scsi: lpfc: Fix issuing init_vpi mbox on SLI-3 card
      scsi: lpfc: Fix ADISC reception terminating login state if a NVME target
      scsi: lpfc: Fix discovery when target has no GID_FT information
      scsi: lpfc: Fix port relogin failure due to GID_FT interaction
      scsi: lpfc: Fix leak of ELS completions on adapter reset
      scsi: lpfc: Fix failure to clear non-zero eq_delay after io rate reduction
      scsi: lpfc: Fix crash on driver unload in wq free
      scsi: lpfc: Fix ELS field alignments
      scsi: lpfc: Fix PLOGI failure with high remoteport count
      scsi: lpfc: Limit xri count for kdump environment

John Garry (4):
      scsi: hisi_sas: Drop SMP resp frame DMA mapping
      scsi: hisi_sas: Drop kmap_atomic() in SMP command completion
      scsi: hisi_sas: Drop hisi_sas_hw.get_free_slot
      scsi: hisi_sas: Make max IPTT count equal for all hw revisions

John Pittman (1):
      scsi: fnic: print port speed only at driver init or speed change

Li Zhong (1):
      scsi: target: tcmu: clean the nl_cmd of the udev when nl send fails

Luo Jiaxing (13):
      scsi: hisi_sas: Add hisi_sas_debugfs_alloc() to centralise allocation
      scsi: hisi_sas: Remove some unused function arguments
      scsi: hisi_sas: Remove hisi_sas_hw.slot_complete
      scsi: hisi_sas: Remove sleep after issue phy reset if sas_smp_phy_control() fails
      scsi: hisi_sas: Directly return when running I_T_nexus reset if phy disabled
      scsi: hisi_sas: Use true/false as input parameter of sas_phy_reset()
      scsi: hisi_sas: add debugfs auto-trigger for internal abort time out
      scsi: hisi_sas: Consolidate internal abort calls in LU reset operation
      scsi: hisi_sas: Modify return type of debugfs functions
      scsi: hisi_sas: Fix out of bound at debug_I_T_nexus_reset()
      scsi: hisi_sas: Snapshot AXI and RAS register at debugfs
      scsi: hisi_sas: Snapshot HW cache of IOST and ITCT at debugfs
      scsi: hisi_sas: Fix pointer usage error in show debugfs IOST/ITCT

Mahesh Rajashekhara (1):
      scsi: smartpqi: correct hang when deleting 32 lds

Martin Wilck (3):
      scsi: scsi_dh_rdac: zero cdb in send_mode_select()
      scsi: qla2xxx: cleanup trace buffer initialization
      scsi: qla2xxx: qla2x00_alloc_fw_dump: set ha->eft

Masahiro Yamada (1):
      scsi: use __u{8,16,32,64} instead of uint{8,16,32,64}_t in uapi headers

Matt Lupfer (1):
      scsi: virtio_scsi: unplug LUNs when events missed

Minwoo Im (1):
      scsi: mpt3sas: support target smid for [abort|query] task

Murthy Bhat (2):
      scsi: smartpqi: correct REGNEWD return status
      scsi: smartpqi: add sysfs entries

Nilesh Javali (1):
      scsi: qedf: Update module description string

Nishka Dasgupta (1):
      scsi: ufs-qcom: Make structure ufs_hba_qcom_vops constant

Paolo Bonzini (2):
      scsi: virtio_scsi: implement request batching
      scsi: core: add support for request batching

Qian Cai (1):
      scsi: megaraid_sas: Fix a compilation warning

Quinn Tran (13):
      scsi: qla2xxx: Fix stale session
      scsi: qla2xxx: Fix stuck login session
      scsi: qla2xxx: Fix flash read for Qlogic ISPs
      scsi: qla2xxx: Allow NVMe IO to resume with short cable pull
      scsi: qla2xxx: Fix hang in fcport delete path
      scsi: qla2xxx: Retry fabric Scan on IOCB queue full
      scsi: qla2xxx: Fix premature timer expiration
      scsi: qla2xxx: Fix Relogin to prevent modifying scan_state flag
      scsi: qla2xxx: Reject EH_{abort|device_reset|target_request}
      scsi: qla2xxx: Skip FW dump on LOOP initialization error
      scsi: qla2xxx: Use Correct index for Q-Pair array
      scsi: qla2xxx: Fix abort timeout race condition.
      scsi: qla2xxx: Fix different size DMA Alloc/Unmap

Sakari Ailus (1):
      scsi: lpfc: Convert existing %pf users to %ps

Saurav Kashyap (11):
      scsi: qedf: Update the version to 8.42.3.0
      scsi: qedf: Fix race betwen fipvlan request and response path
      scsi: qedf: Decrease the LL2 MTU size to 2500
      scsi: qedf: Check for module unloading bit before processing link update AEN
      scsi: qedf: Initiator fails to re-login to switch after link down
      scsi: qedf: Add debug information for unsolicited processing
      scsi: qedf: Add support for 20 Gbps speed
      scsi: qedf: Interpret supported caps value correctly
      scsi: qedf: Add shutdown callback handler
      scsi: qedf: Stop sending fipvlan request on unload
      scsi: qedf: Print message during bailout conditions

Sergei Shtylyov (3):
      scsi: fdomain_isa: use CFG1_IRQ_MASK
      scsi: fdomain: use BSTAT_{MSG|CMD|IO} in fdomain_work()
      scsi: fdomain: use BCTL_RST in fdomain_reset()

Sreekanth Reddy (1):
      scsi: mpt3sas: Introduce module parameter to override queue depth

Stanley Chu (5):
      scsi: ufs: fix broken hba->outstanding_tasks
      scsi: ufs: Add history of fatal events
      scsi: ufs: Do not reset error history during host reset
      scsi: ufs: Add fatal and auto-hibern8 error history
      scsi: ufs: Change names related to error history

Suganath Prabu (12):
      scsi: mpt3sas: Update driver version to 31.100.00.00
      scsi: mpt3sas: Run SAS DEVICE STATUS CHANGE EVENT from ISR
      scsi: mpt3sas: Reduce the performance drop
      scsi: mpt3sas: Handle fault during HBA initialization
      scsi: mpt3sas: Add sysfs to know supported features
      scsi: mpt3sas: Support MEMORY MOVE Tool box command
      scsi: mpt3sas: Allow ioctls to blocked access status NVMe
      scsi: mpt3sas: Enumerate SES of a managed PCIe switch
      scsi: mpt3sas: Update MPI headers to 2.6.8 spec
      scsi: mpt3sas: Gracefully handle online firmware update
      scsi: mpt3sas: memset request frame before reusing
      scsi: mpt3sas: Add support for PCIe Lane margin

Tomas Winkler (1):
      scsi: ufs: revamp string descriptor reading

Xiang Chen (11):
      scsi: hisi_sas: Fix the conflict between device gone and host reset
      scsi: hisi_sas: Add BIST support for phy loopback
      scsi: hisi_sas: Remove redundant work declaration
      scsi: hisi_sas: Assign NCQ tag for all NCQ commands
      scsi: hisi_sas: Update all the registers after suspend and resume
      scsi: hisi_sas: Retry 3 times TMF IO for SAS disks when init device
      scsi: hisi_sas: replace "%p" with "%pK"
      scsi: hisi_sas: Remove some unnecessary code
      scsi: hisi_sas: Drop free_irq() when devm_request_irq() failed
      scsi: hisi_sas: Make slot buf minimum allocation of PAGE_SIZE
      scsi: hisi_sas: Don't bother clearing status buffer IU in task prep

YueHaibing (8):
      scsi: ufs-hisi: use devm_platform_ioremap_resource() to simplify code
      scsi: ufshcd: use devm_platform_ioremap_resource() to simplify code
      scsi: hisi_sas: use devm_platform_ioremap_resource() to simplify code
      scsi: ufs: Use kmemdup in ufshcd_read_string_desc()
      scsi: megaraid_sas: Make a bunch of functions static
      scsi: aic94xx: Remove unnecessary null check
      scsi: qla2xxx: Remove unnecessary null check
      scsi: lpfc: Remove unnecessary null check before kfree

zhengbin (6):
      scsi: fcoe: fix null-ptr-deref Read in fc_release_transport
      scsi: bnx2fc: remove set but not used variables 'task','port','orig_task'
      scsi: bnx2fc: remove set but not used variables 'lport','host'
      scsi: bnx2fc: remove set but not used variable 'fh'
      scsi: ufs: remove set but not used variable 'val'
      scsi: hisi_sas: remove set but not used variable 'irq_value'

And the diffstat:

.../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   2 +
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   2 +
 arch/arm64/boot/dts/qcom/sdm845-mtp.dts            |   2 +
 drivers/scsi/aic94xx/aic94xx_init.c                |   9 +-
 drivers/scsi/arm/fas216.c                          |   8 +
 drivers/scsi/bfa/bfad_im.c                         |   2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |   2 -
 drivers/scsi/bnx2fc/bnx2fc_hwi.c                   |  16 -
 drivers/scsi/bnx2fc/bnx2fc_io.c                    |   7 -
 drivers/scsi/csiostor/csio_wr.c                    |   8 +-
 drivers/scsi/cxlflash/main.c                       |  12 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c         |   2 +
 drivers/scsi/esas2r/esas2r_init.c                  |  13 +-
 drivers/scsi/esas2r/esas2r_ioctl.c                 |  14 +-
 drivers/scsi/fcoe/fcoe.c                           |  17 +-
 drivers/scsi/fdomain.c                             |   6 +-
 drivers/scsi/fdomain_isa.c                         |   5 +-
 drivers/scsi/fnic/fnic_debugfs.c                   |   4 +-
 drivers/scsi/fnic/fnic_fcs.c                       |  14 +-
 drivers/scsi/fnic/fnic_isr.c                       |   4 +-
 drivers/scsi/fnic/fnic_trace.c                     |   2 +-
 drivers/scsi/hisi_sas/hisi_sas.h                   |  54 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              | 982 ++++++++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |  48 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c             |  92 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             | 307 +++++--
 drivers/scsi/ibmvscsi/ibmvfc.c                     |   3 +
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |   3 +
 drivers/scsi/lpfc/lpfc.h                           |  11 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |  76 +-
 drivers/scsi/lpfc/lpfc_bsg.c                       |  29 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |  13 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |  68 +-
 drivers/scsi/lpfc/lpfc_debugfs.c                   | 228 +----
 drivers/scsi/lpfc/lpfc_debugfs.h                   |  61 +-
 drivers/scsi/lpfc/lpfc_disc.h                      |   3 +
 drivers/scsi/lpfc/lpfc_els.c                       | 116 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   | 181 ++--
 drivers/scsi/lpfc/lpfc_hw.h                        |   6 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |  34 +
 drivers/scsi/lpfc/lpfc_init.c                      | 926 +++++++++----------
 drivers/scsi/lpfc/lpfc_mem.c                       |  65 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c                 |  43 +-
 drivers/scsi/lpfc/lpfc_nvme.c                      | 389 +++++---
 drivers/scsi/lpfc/lpfc_nvmet.c                     |  28 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      | 591 ++++++++-----
 drivers/scsi/lpfc/lpfc_sli.c                       | 533 ++++++++---
 drivers/scsi/lpfc/lpfc_sli.h                       |  11 +-
 drivers/scsi/lpfc/lpfc_sli4.h                      |  50 +-
 drivers/scsi/lpfc/lpfc_version.h                   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c                     |   8 +-
 drivers/scsi/megaraid/megaraid_sas.h               |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c          | 112 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c        |  29 +-
 drivers/scsi/mpt3sas/mpi/mpi2.h                    |   5 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h               |  10 +-
 drivers/scsi/mpt3sas/mpi/mpi2_image.h              |  39 +-
 drivers/scsi/mpt3sas/mpi/mpi2_pci.h                |  13 +-
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h               |  13 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c                | 175 +++-
 drivers/scsi/mpt3sas/mpt3sas_base.h                |  30 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c                 | 178 +++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               | 196 ++--
 drivers/scsi/ncr53c8xx.c                           |   4 +
 drivers/scsi/pm8001/pm8001_sas.c                   |  13 +-
 drivers/scsi/pmcraid.c                             |   2 +-
 drivers/scsi/qedf/qedf.h                           |   1 +
 drivers/scsi/qedf/qedf_debugfs.c                   |  16 +-
 drivers/scsi/qedf/qedf_els.c                       |  38 +-
 drivers/scsi/qedf/qedf_fip.c                       |  33 +-
 drivers/scsi/qedf/qedf_io.c                        |  67 +-
 drivers/scsi/qedf/qedf_main.c                      | 178 ++--
 drivers/scsi/qedf/qedf_version.h                   |   8 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |  12 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |  23 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   3 +-
 drivers/scsi/qla2xxx/qla_def.h                     | 132 ++-
 drivers/scsi/qla2xxx/qla_dfs.c                     |   9 +-
 drivers/scsi/qla2xxx/qla_dsd.h                     |   2 +
 drivers/scsi/qla2xxx/qla_fw.h                      |   8 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |  33 +-
 drivers/scsi/qla2xxx/qla_gs.c                      | 254 +++---
 drivers/scsi/qla2xxx/qla_init.c                    | 550 +++++-------
 drivers/scsi/qla2xxx/qla_inline.h                  |  28 +-
 drivers/scsi/qla2xxx/qla_iocb.c                    | 226 ++---
 drivers/scsi/qla2xxx/qla_isr.c                     |  29 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  26 +-
 drivers/scsi/qla2xxx/qla_mid.c                     |   4 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |  67 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |  32 +-
 drivers/scsi/qla2xxx/qla_nvme.h                    |   5 +-
 drivers/scsi/qla2xxx/qla_nx.c                      |  22 +-
 drivers/scsi/qla2xxx/qla_nx.h                      |  14 +-
 drivers/scsi/qla2xxx/qla_nx2.c                     |   2 +-
 drivers/scsi/qla2xxx/qla_os.c                      | 237 +++--
 drivers/scsi/qla2xxx/qla_sup.c                     |  16 +-
 drivers/scsi/qla2xxx/qla_target.c                  | 212 ++---
 drivers/scsi/qla2xxx/qla_target.h                  |  35 +-
 drivers/scsi/qla2xxx/qla_tmpl.c                    |   7 +-
 drivers/scsi/qla2xxx/qla_version.h                 |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  27 +-
 drivers/scsi/qlogicpti.c                           |  10 +
 drivers/scsi/scsi_debugfs.c                        |   5 +-
 drivers/scsi/scsi_lib.c                            |  52 +-
 drivers/scsi/scsi_logging.c                        |  48 +-
 drivers/scsi/sd.c                                  |   1 +
 drivers/scsi/smartpqi/Kconfig                      |   2 +
 drivers/scsi/smartpqi/smartpqi.h                   |  20 +-
 drivers/scsi/smartpqi/smartpqi_init.c              | 236 ++++-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c     | 102 ++-
 drivers/scsi/sun3_scsi.c                           |   2 +
 drivers/scsi/sym53c8xx_2/sym_nvram.c               |   2 +-
 drivers/scsi/ufs/cdns-pltfrm.c                     |  40 +-
 drivers/scsi/ufs/ufs-hisi.c                        |   4 +-
 drivers/scsi/ufs/ufs-qcom.c                        |  41 +-
 drivers/scsi/ufs/ufs-qcom.h                        |   4 +
 drivers/scsi/ufs/ufs-sysfs.c                       |  18 +-
 drivers/scsi/ufs/ufs.h                             |   2 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   4 +-
 drivers/scsi/ufs/ufshcd.c                          | 281 +++---
 drivers/scsi/ufs/ufshcd.h                          |  57 +-
 drivers/scsi/virtio_scsi.c                         |  88 +-
 drivers/scsi/wd33c93.c                             |   1 +
 drivers/target/target_core_user.c                  |  20 +
 include/linux/nvme-fc-driver.h                     |   2 +
 include/scsi/scsi_cmnd.h                           |   1 +
 include/scsi/scsi_dbg.h                            |   2 -
 include/scsi/scsi_host.h                           |  16 +-
 include/uapi/scsi/scsi_bsg_fc.h                    |  54 +-
 include/uapi/scsi/scsi_bsg_ufs.h                   |   2 +-
 include/uapi/scsi/scsi_netlink.h                   |  20 +-
 include/uapi/scsi/scsi_netlink_fc.h                |  17 +-
 132 files changed, 5764 insertions(+), 3680 deletions(-)

James

