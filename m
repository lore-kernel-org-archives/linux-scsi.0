Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BAAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 12:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D38661212
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Nov 2021 12:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhKEMRJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:17:09 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:53228 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhKEMRI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2021 08:17:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1636114469;
        bh=isKEJ6L09pFjS+LLNRDPYMs/dOFbsfFKQlDwBbmLVOw=;
        h=Message-ID:Subject:From:To:Date:From;
        b=DOJ/jdxqWiHgt+AZkLdo1+9N9PO6cM1Sv3vXQYlmCh4JUy4/x+E5zi93WhMb9B4AG
         mubBndPe6VbFC7ZeE+Q7cC+p0JO0GXhWph5355juEL8ZFlKR8CsjR9ASrvhn0unSAX
         41uZIB/V6rbkEtPmwRxdKsIkqn3qomOngVu4woVw=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 0CF29128058D;
        Fri,  5 Nov 2021 08:14:29 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2MRfaEYKXA7r; Fri,  5 Nov 2021 08:14:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1636114468;
        bh=isKEJ6L09pFjS+LLNRDPYMs/dOFbsfFKQlDwBbmLVOw=;
        h=Message-ID:Subject:From:To:Date:From;
        b=KWWU1We3H8QmNJsnx2lW8gZnjDWKd0L5YZ7yB7XspU1gasY/4IF2kqb2gAavBRqpn
         FwoSTFuURcP57LyE5MM8E5kLCtmOxYYkoZ0d8nrLyqklqmtDeVy7z6ExVInJglTOMC
         K615DugmOuUEPq1YEcSP7qfqcFw8LokaAA47wLZg=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 7620312805BB;
        Fri,  5 Nov 2021 08:14:28 -0400 (EDT)
Message-ID: <b13f25e87fd8d4ed027ef64aba8ebd7273c4b8b8.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.15+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 05 Nov 2021 08:14:27 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series consists of the usual driver updates (ufs, smartpqi, lpfc,
target, megaraid_sas, hisi_sas, qla2xxx) and minor updates and bug
fixes.  Notable core changes are the removal of scsi->tag which caused
some churn in obsolete drivers and a sweep through all drivers to call
scsi_done() directly instead of scsi->done() which removes a pointer
indirection from the hot path and a move to register core sysfs files
earlier, which means they're available to KOBJ_ADD processing, which
necessitates switching all drivers to using attribute groups.

There's a conflict between 35c3730a9657 ("scsi: ufs: core: Stop
clearing UNIT ATTENTIONS") in our tree and 0bf6d96cb829 ("block: remove
blk_{get,put}_request") in ufshcd.c but the fix is obviously still to
remove the modified functions.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (6):
      scsi: ufs: core: Fix synchronization between scsi_unjam_host() and ufshcd_queuecommand()
      scsi: ufs: core: Do not exit ufshcd_err_handler() unless operational or dead
      scsi: ufs: core: Do not exit ufshcd_reset_and_restore() unless operational or dead
      scsi: ufs: core: Fix task management completion
      scsi: ufs: core: Revert "scsi: ufs: Synchronize SCSI and UFS error handling"
      scsi: ufs: ufs-pci: Fix Intel LKF link stability

Ajish Koshy (3):
      scsi: pm80xx: Fix memory leak during rmmod
      scsi: pm80xx: Fix lockup in outbound queue management
      scsi: pm80xx: Fix incorrect port value when registering a device

Anders Roxell (1):
      scsi: ufs: core: SCSI_UFS_HWMON depends on HWMON=y

Arnd Bergmann (2):
      scsi: ufs: mediatek: Avoid sched_clock() misuse
      scsi: lpfc: Fix gcc -Wstringop-overread warning, again

Arun Easi (3):
      scsi: qla2xxx: Fix excessive messages during device logout
      scsi: qla2xxx: Fix kernel crash when accessing port_speed sysfs file
      scsi: qla2xxx: Fix crash in NVMe abort path

Asutosh Das (2):
      scsi: ufs: ufs-qcom: Enter and exit hibern8 during clock scaling
      scsi: ufs: core: Export hibern8 entry and exit functions

Avri Altman (2):
      scsi: ufs: core: Add temperature notification exception handling
      scsi: ufs: core: Probe for temperature notification support

Baokun Li (1):
      scsi: iscsi: Adjust iface sysfs attr detection

Bart Van Assche (143):
      scsi: core: Remove two host template members that are no longer used
      scsi: usb: Switch to attribute groups
      scsi: staging: unisys: Remove the shost_attrs member
      scsi: snic: Switch to attribute groups
      scsi: smartpqi: Switch to attribute groups
      scsi: qla4xxx: Switch to attribute groups
      scsi: qla2xxx: Switch to attribute groups
      scsi: qla2xxx: Remove a declaration
      scsi: qedi: Switch to attribute groups
      scsi: qedf: Switch to attribute groups
      scsi: pmcraid: Switch to attribute groups
      scsi: pm8001: Switch to attribute groups
      scsi: sym53c500_cs: Switch to attribute groups
      scsi: ncr53c8xx: Switch to attribute groups
      scsi: myrs: Switch to attribute groups
      scsi: myrb: Switch to attribute groups
      scsi: mvsas: Switch to attribute groups
      scsi: mpt3sas: Switch to attribute groups
      scsi: megaraid_sas: Switch to attribute groups
      scsi: megaraid_mbox: Switch to attribute groups
      scsi: lpfc: Switch to attribute groups
      scsi: isci: Switch to attribute groups
      scsi: ipr: Switch to attribute groups
      scsi: ibmvfc: Switch to attribute groups
      scsi: ibmvscsi: Switch to attribute groups
      scsi: hptiop: Switch to attribute groups
      scsi: hpsa: Switch to attribute groups
      scsi: hisi_sas: Switch to attribute groups
      scsi: fnic: Switch to attribute groups
      scsi: cxlflash: Switch to attribute groups
      scsi: csiostor: Switch to attribute groups
      scsi: bnx2i: Switch to attribute groups
      scsi: bnx2fc: Switch to attribute groups
      scsi: bfa: Switch to attribute groups
      scsi: be2iscsi: Switch to attribute groups
      scsi: arcmsr: Switch to attribute groups
      scsi: aacraid: Switch to attribute groups
      scsi: 53c700: Switch to attribute groups
      scsi: 3w-xxxx: Switch to attribute groups
      scsi: 3w-sas: Switch to attribute groups
      scsi: 3w-9xxx: Switch to attribute groups
      scsi: zfcp: Switch to attribute groups
      scsi: message: fusion: Switch to attribute groups
      scsi: RDMA/srp: Switch to attribute groups
      scsi: firewire: sbp2: Switch to attribute groups
      scsi: ata: Switch to attribute groups
      scsi: core: Register sysfs attributes earlier
      scsi: core: Remove the 'done' argument from SCSI queuecommand_lck functions
      scsi: fas216: Introduce the function fas216_queue_command_internal()
      scsi: isci: Remove a declaration
      scsi: core: Call scsi_done directly
      scsi: usb: Call scsi_done() directly
      scsi: target: tcm_loop: Call scsi_done() directly
      scsi: staging: unisys: visorhba: Call scsi_done() directly
      scsi: staging: rts5208: Call scsi_done() directly
      scsi: xen-scsifront: Call scsi_done() directly
      scsi: wd719x: Call scsi_done() directly
      scsi: wd33c93: Call scsi_done() directly
      scsi: vmw_pvscsi: Call scsi_done() directly
      scsi: virtio_scsi: Call scsi_done() directly
      scsi: ufs: Call scsi_done() directly
      scsi: sym53c8xx_2: Call scsi_done() directly
      scsi: storvsc_drv: Call scsi_done() directly
      scsi: stex: Call scsi_done() directly
      scsi: snic: Call scsi_done() directly
      scsi: smartpqi: Call scsi_done() directly
      scsi: scsi_debug: Call scsi_done() directly
      scsi: qlogicpti: Call scsi_done() directly
      scsi: qlogicfas408: Call scsi_done() directly
      scsi: qla4xxx: Call scsi_done() directly
      scsi: qla2xxx: Call scsi_done() directly
      scsi: qla1280: Call scsi_done() directly
      scsi: qedf: Call scsi_done() directly
      scsi: ps3rom: Call scsi_done() directly
      scsi: ppa: Call scsi_done() directly
      scsi: pmcraid: Call scsi_done() directly
      scsi: pcmcia: Call scsi_done() directly
      scsi: nsp32: Call scsi_done() directly
      scsi: ncr53c8xx: Call scsi_done() directly
      scsi: myrs: Call scsi_done() directly
      scsi: myrb: Call scsi_done() directly
      scsi: mvumi: Call scsi_done() directly
      scsi: mpt3sas: Call scsi_done() directly
      scsi: mpi3mr: Call scsi_done() directly
      scsi: mesh: Call scsi_done() directly
      scsi: megaraid: Call scsi_done() directly
      scsi: megaraid_sas: Call scsi_done() directly
      scsi: megaraid_mbox: Call scsi_done() directly
      scsi: mac53c94: Call scsi_done() directly
      scsi: lpfc: Call scsi_done() directly
      scsi: libsas: Call scsi_done() directly
      scsi: libiscsi: Call scsi_done() directly
      scsi: libfc: Call scsi_done() directly
      scsi: ips: Call scsi_done() directly
      scsi: ipr: Call scsi_done() directly
      scsi: initio: Call scsi_done() directly
      scsi: imm: Call scsi_done() directly
      scsi: ibmvscsi: Call scsi_done() directly
      scsi: hptiop: Call scsi_done() directly
      scsi: hpsa: Call scsi_done() directly
      scsi: fnic: Call scsi_done() directly
      scsi: fdomain: Call scsi_done() directly
      scsi: fas216: Stop using scsi_cmnd.scsi_done
      scsi: fas216: Introduce struct fas216_cmd_priv
      scsi: esp_scsi: Call scsi_done() directly
      scsi: esas2r: Call scsi_done() directly
      scsi: dpt_i2o: Call scsi_done() directly
      scsi: dc395x: Call scsi_done() directly
      scsi: cxlflash: Call scsi_done() directly
      scsi: csiostor: Call scsi_done() directly
      scsi: bnx2fc: Call scsi_done() directly
      scsi: bfa: Call scsi_done() directly
      scsi: atp870u: Call scsi_done() directly
      scsi: arcmsr: Call scsi_done() directly
      scsi: aic7xxx: Call scsi_done() directly
      scsi: aha1542: Call scsi_done() directly
      scsi: aha152x: Call scsi_done() directly
      scsi: advansys: Call scsi_done() directly
      scsi: acornscsi: Call scsi_done() directly
      scsi: aacraid: Call scsi_done() directly
      scsi: aacraid: Introduce aac_scsi_done()
      scsi: a100u2w: Call scsi_done() directly
      scsi: NCR5380: Call scsi_done() directly
      scsi: BusLogic: Call scsi_done() directly
      scsi: 53c700: Call scsi_done() directly
      scsi: 3w-xxxx: Call scsi_done() directly
      scsi: 3w-sas: Call scsi_done() directly
      scsi: 3w-9xxx: Call scsi_done() directly
      scsi: zfcp_scsi: Call scsi_done() directly
      scsi: message: fusion: Call scsi_done() directly
      scsi: ib_srp: Call scsi_done() directly
      scsi: firewire: sbp2: Call scsi_done() directly
      scsi: ata: Call scsi_done() directly
      scsi: core: Rename scsi_mq_done() into scsi_done() and export it
      scsi: core: Use a structure member to track the SCSI command submitter
      scsi: core: pm: Only runtime resume if necessary
      scsi: sd: Rename sd_resume() into sd_resume_system()
      scsi: core: pm: Rely on the device driver core for async power management
      scsi: ufs: core: Stop clearing UNIT ATTENTIONS
      scsi: core: Fix spelling in a source code comment
      scsi: ufs: core: Unbreak the reset handler
      scsi: core: Remove include <scsi/scsi_host.h> from scsi_cmnd.h
      scsi: sd_zbc: Support disks with more than 2**32 logical blocks

Bean Huo (3):
      scsi: ufs: core: Remove return statement in void function
      scsi: ufs: core: Fix ufshcd_probe_hba() prototype to match the definition
      scsi: ufs: core: Fix NULL pointer dereference

Bikash Hazarika (1):
      scsi: qla2xxx: Add support for mailbox passthru

Bodo Stroesser (1):
      scsi: target: tcmu: Allocate zeroed pages for data area

Cai Huoqing (2):
      scsi: aic7xxx: Fix a function name in comments
      scsi: lpfc: Fix a function name in comments

ChanWoo Lee (2):
      scsi: ufs: ufs-qcom: Remove unneeded variable 'err'
      scsi: ufs: ufshpb: Remove unused parameters

Chi Minghao (1):
      scsi: lpfc: Remove unneeded variable

Christoph Hellwig (2):
      scsi: target: core: Stop using bdevname()
      scsi: aha1542: Use memcpy_{from,to}_bvec()

Christophe JAILLET (1):
      scsi: elx: efct: Switch from 'pci_' to 'dma_' API

Colin Ian King (8):
      scsi: 3w-xxx: Remove redundant initialization of variable retval
      scsi: lpfc: Return NULL rather than a plain 0 integer
      scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"
      scsi: target: Fix spelling mistake "CONFLIFT" -> "CONFLICT"
      scsi: qla2xxx: Remove redundant initialization of pointer req
      scsi: mpt3sas: Clean up some inconsistent indenting
      scsi: megaraid: Clean up some inconsistent indenting
      scsi: sr: Fix spelling mistake "does'nt" -> "doesn't"

Daejun Park (1):
      scsi: ufs: ufshpb: Use proper power management API

Damien Le Moal (3):
      scsi: sd: Fix sd_do_mode_sense() buffer length handling
      scsi: core: Fix scsi_mode_select() buffer length handling
      scsi: core: Fix scsi_mode_sense() buffer length handling

Dan Carpenter (6):
      scsi: mpi3mr: Use scnprintf() instead of snprintf()
      scsi: csiostor: Uninitialized data in csio_ln_vnp_read_cbfn()
      scsi: mpi3mr: Clean up mpi3mr_print_ioc_info()
      scsi: elx: efct: Delete stray unlock statement
      scsi: lpfc: Use correct scnprintf() limit
      scsi: lpfc: Fix sprintf() overflow in lpfc_display_fpin_wwpn()

Ding Hui (1):
      scsi: libiscsi: Move ehwait initialization to iscsi_session_setup()

Dmitry Bogdanov (11):
      scsi: target: usb: Replace enable attr with ops.enable
      scsi: target: ibm_vscsi: Replace enable attr with ops.enable
      scsi: target: srpt: Replace enable attr with ops.enable
      scsi: target: sbp: Replace enable attr with ops.enable
      scsi: target: qla2xxx: Replace enable attr with ops.enable
      scsi: target: iscsi: Replace tpg enable attr with ops.enable
      scsi: target: core: Add common tpg/enable attribute
      scsi: efct: Decrease area under spinlock
      scsi: efct: Fix nport free
      scsi: efct: Add state in nport sm trace printout
      scsi: qla2xxx: Restore initiator in dual mode

Don Brace (3):
      scsi: smartpqi: Update version to 2.1.12-055
      scsi: smartpqi: Add TEST UNIT READY check for SANITIZE operation
      scsi: smartpqi: Update device removal management

Guo Zhi (1):
      scsi: advansys: Fix kernel pointer leak

Gustavo A. R. Silva (1):
      scsi: target: tcmu: Use struct_size() helper in kmalloc()

Hannes Reinecke (3):
      scsi: core: Remove 'current_tag'
      scsi: acornscsi: Remove tagged queuing vestiges
      scsi: fas216: Kill scmd->tag

Heiner Kallweit (1):
      scsi: sd: Make sd_spinup_disk() less noisy

Helge Deller (1):
      scsi: ncr53c8xx: Remove unused retrieve_from_waiting_list() function

Igor Pylypiv (2):
      scsi: pm80xx: Fix misleading log statement in pm8001_mpi_get_nvmd_resp()
      scsi: pm80xx: Replace open coded check with dev_is_expander()

Jaegeuk Kim (1):
      scsi: ufs: core: Retry START_STOP on UNIT_ATTENTION

James Smart (29):
      scsi: lpfc: Update lpfc version to 14.0.0.3
      scsi: lpfc: Allow fabric node recovery if recovery is in progress before devloss
      scsi: lpfc: Fix link down processing to address NULL pointer dereference
      scsi: lpfc: Allow PLOGI retry if previous PLOGI was aborted
      scsi: lpfc: Fix use-after-free in lpfc_unreg_rpi() routine
      scsi: lpfc: Correct sysfs reporting of loop support after SFP status change
      scsi: lpfc: Wait for successful restart of SLI3 adapter during host sg_reset
      scsi: lpfc: Revert LOG_TRACE_EVENT back to LOG_INIT prior to driver_resource_setup()
      scsi: lpfc: Fix memory overwrite during FC-GS I/O abort handling
      scsi: lpfc: Add support for optional PLDV handling
      scsi: lpfc: Fix mailbox command failure during driver initialization
      scsi: lpfc: Update lpfc version to 14.0.0.2
      scsi: lpfc: Improve PBDE checks during SGL processing
      scsi: lpfc: Zero CGN stats only during initial driver load and stat reset
      scsi: lpfc: Fix I/O block after enabling managed congestion mode
      scsi: lpfc: Adjust bytes received vales during cmf timer interval
      scsi: lpfc: Fix EEH support for NVMe I/O
      scsi: lpfc: Fix FCP I/O flush functionality for TMF routines
      scsi: lpfc: Fix NVMe I/O failover to non-optimized path
      scsi: lpfc: Don't remove ndlp on PRLI errors in P2P mode
      scsi: lpfc: Fix rediscovery of tape device after LIP
      scsi: lpfc: Fix hang on unload due to stuck fport node
      scsi: lpfc: Fix premature rpi release for unsolicited TPLS and LS_RJT
      scsi: lpfc: Don't release final kref on Fport node while ABTS outstanding
      scsi: lpfc: Fix list_add() corruption in lpfc_drain_txq()
      scsi: elx: efct: Do not hold lock while calling fc_vport_terminate()
      scsi: lpfc: Fix compilation errors on kernels with no CONFIG_DEBUG_FS
      scsi: lpfc: Fix CPU to/from endian warnings introduced by ELS processing
      scsi: elx: efct: Fix void-pointer-to-enum-cast warning for efc_nport_topology

Jens Axboe (1):
      scsi: Remove SCSI CDROM MAINTAINERS entry

Jiapeng Chong (2):
      scsi: mpt3sas: Make mpt3sas_dev_attrs static
      scsi: ses: Fix unsigned comparison with less than zero

John Garry (4):
      scsi: acornscsi: Remove scsi_cmd_to_tag() reference
      scsi: core: Delete scsi_{get,free}_host_dev()
      scsi: libsas: Co-locate exports with symbols
      scsi: hisi_sas: Stop printing queue count in v3 hardware probe

Jonathan Hsu (1):
      scsi: ufs: Fix illegal offset in UPIU event trace

Kevin Barnett (2):
      scsi: smartpqi: Fix duplicate device nodes for tape changers
      scsi: smartpqi: Update LUN reset handler

Konstantin Shelekhin (1):
      scsi: target: core: Make logs less verbose

Krzysztof Kozlowski (1):
      scsi: ufs: exynos: Unify naming

Len Baker (2):
      scsi: advansys: Prefer struct_size() over open-coded arithmetic
      scsi: elx: libefc: Prefer kcalloc() over open coded arithmetic

Li Feng (1):
      scsi: target: Remove unused function arguments

Luis Chamberlain (2):
      scsi: sr: Add error handling support for add_disk()
      scsi: sd: Add error handling support for add_disk()

Luo Jiaxing (4):
      scsi: hisi_sas: Disable SATA disk phy for severe I_T nexus reset failure
      scsi: libsas: Export sas_phy_enable()
      scsi: hisi_sas: Increase debugfs_dump_index after dump is completed
      scsi: hisi_sas: Rename HISI_SAS_{RESET -> RESETTING}_BIT

Mahesh Rajashekhara (2):
      scsi: smartpqi: Avoid failing I/Os for offline devices
      scsi: smartpqi: Add controller handshake during kdump

Manish Rangankar (1):
      scsi: qla2xxx: Move heartbeat handling from DPC thread to workqueue

Martin Kepplinger (1):
      scsi: sd: Print write through due to no caching mode page as warning

Maurizio Lombardi (1):
      scsi: target: Fix the pgr/alua_support_store functions

MichelleJin (1):
      scsi: fcoe: Use netif_is_bond_master() instead of open code

Mike Christie (6):
      scsi: target: Perform ALUA group changes in one step
      scsi: target: Replace lun_tg_pt_gp_lock with rcu in I/O path
      scsi: target: Fix alua_tg_pt_gps_count tracking
      scsi: target: Fix ordered tag handling
      scsi: target: Fix ordered CMD_T_SENT handling
      scsi: iscsi: Fix iscsi_task use after free

Mike McGowen (3):
      scsi: smartpqi: Add 3252-8i PCI id
      scsi: smartpqi: Fix boot failure during LUN rebuild
      scsi: smartpqi: Add extended report physical LUNs

Ming Lei (1):
      scsi: sd: Free scsi_disk device via put_device()

Muneendra Kumar (1):
      scsi: documentation: Document Fibre Channel sysfs node for appid

Murthy Bhat (1):
      scsi: smartpqi: Capture controller reason codes

Naohiro Aota (1):
      scsi: sd_zbc: Ensure buffer size is aligned to SECTOR_SIZE

Nathan Chancellor (1):
      scsi: st: Add missing break in switch statement in st_ioctl()

Nilesh Javali (1):
      scsi: qla2xxx: Update version to 10.02.07.100-k

Peter Wang (3):
      scsi: ufs: ufs-mediatek: Fix wrong location for ref-clk delay
      scsi: ufs: mediatek: Support vops pre suspend to disable auto-hibern8
      scsi: ufs: ufs-mediatek: Change dbg select by check IP version

Quinn Tran (2):
      scsi: qla2xxx: Fix use after free in eh_abort path
      scsi: qla2xxx: edif: Use link event to wake up app

Rahul Lakkireddy (1):
      scsi: csiostor: Add module softdep on cxgb4

Saurav Kashyap (2):
      scsi: qla2xxx: Check for firmware capability before creating QPair
      scsi: qla2xxx: Display 16G only as supported speeds for 3830c card

Shreyas Deodhar (1):
      scsi: qla2xxx: Call process_response_queue() in Tx path

Sohaib Mohamed (1):
      scsi: Documentation: Fix typo in sysfs-driver-ufs

Sreekanth Reddy (2):
      scsi: scsi_transport_sas: Add 22.5 Gbps link rate definitions
      scsi: mpt3sas: Call cpu_relax() before calling udelay()

Srinivas Kandagatla (1):
      scsi: ufs: ufshcd-pltfrm: Fix memory leak due to probe defer

Stanley Chu (2):
      scsi: ufs: ufs-mediatek: Fix build error caused by use of sched_clock()
      scsi: ufs: ufs-mediatek: Introduce default delay for reference clock

Sumit Saxena (3):
      scsi: megaraid_sas: Driver version update to 07.719.03.00-rc1
      scsi: megaraid_sas: Add helper functions for irq_context
      scsi: megaraid_sas: Fix concurrent access to ISR between IRQ polling and real interrupt

Tong Zhang (1):
      scsi: dc395: Fix error case unwinding

Tyrel Datwyler (1):
      scsi: ibmvscsi: Use GFP_KERNEL with dma_alloc_coherent() in initialize_event_pool()

Varun Prakash (2):
      scsi: target: cxgbit: Enable Delayed ACK
      scsi: target: cxgbit: Increase max DataSegmentLength

Viswas G (1):
      scsi: pm80xx: Correct inbound and outbound queue logging

Wen Xiong (1):
      scsi: ses: Retry failed Send/Receive Diagnostic commands

Xiang Chen (4):
      scsi: hisi_sas: Wait for phyup in hisi_sas_control_phy()
      scsi: hisi_sas: Initialise devices in .slave_alloc callback
      scsi: hisi_sas: Replace del_timer() calls with del_timer_sync()
      scsi: hisi_sas: Use managed PCI functions

Ye Bin (2):
      scsi: scsi_debug: Fix out-of-bound read in resp_report_tgtpgs()
      scsi: scsi_debug: Fix out-of-bound read in resp_readcap16()

Zenghui Yu (1):
      scsi: bsg: Fix device unregistration

jing yangyang (1):
      scsi: megaraid: Fix Coccinelle warning

And the diffstat:

 Documentation/ABI/testing/sysfs-class-fc        |  27 ++
 Documentation/ABI/testing/sysfs-driver-ufs      |   2 +-
 MAINTAINERS                                     |   7 -
 block/bsg.c                                     |  23 +-
 drivers/ata/ahci.h                              |   8 +-
 drivers/ata/ata_piix.c                          |   8 +-
 drivers/ata/libahci.c                           |  52 ++-
 drivers/ata/libata-sata.c                       |  21 +-
 drivers/ata/libata-scsi.c                       |  29 +-
 drivers/ata/pata_macio.c                        |   2 +-
 drivers/ata/sata_mv.c                           |   2 +-
 drivers/ata/sata_nv.c                           |   4 +-
 drivers/ata/sata_sil24.c                        |   2 +-
 drivers/firewire/sbp2.c                         |  10 +-
 drivers/infiniband/ulp/srp/ib_srp.c             |  59 ++-
 drivers/infiniband/ulp/srpt/ib_srpt.c           |  38 +-
 drivers/message/fusion/mptfc.c                  |   8 +-
 drivers/message/fusion/mptsas.c                 |   4 +-
 drivers/message/fusion/mptscsih.c               |  46 +-
 drivers/message/fusion/mptscsih.h               |   2 +-
 drivers/message/fusion/mptspi.c                 |   6 +-
 drivers/s390/scsi/zfcp_ext.h                    |   4 +-
 drivers/s390/scsi/zfcp_fsf.c                    |   2 +-
 drivers/s390/scsi/zfcp_scsi.c                   |   8 +-
 drivers/s390/scsi/zfcp_sysfs.c                  |  52 ++-
 drivers/scsi/3w-9xxx.c                          |  18 +-
 drivers/scsi/3w-sas.c                           |  18 +-
 drivers/scsi/3w-xxxx.c                          |  26 +-
 drivers/scsi/53c700.c                           |  20 +-
 drivers/scsi/BusLogic.c                         |  13 +-
 drivers/scsi/NCR5380.c                          |  12 +-
 drivers/scsi/a100u2w.c                          |   5 +-
 drivers/scsi/aacraid/aachba.c                   |  53 ++-
 drivers/scsi/aacraid/linit.c                    |  38 +-
 drivers/scsi/advansys.c                         |  14 +-
 drivers/scsi/aha152x.c                          |  29 +-
 drivers/scsi/aha1542.c                          |  16 +-
 drivers/scsi/aha1740.c                          |   4 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c              |   6 +-
 drivers/scsi/aic7xxx/aic79xx_osm.h              |   2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c              |   6 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.h              |   2 +-
 drivers/scsi/arcmsr/arcmsr.h                    |   2 +-
 drivers/scsi/arcmsr/arcmsr_attr.c               |  33 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                |  22 +-
 drivers/scsi/arm/Kconfig                        |  11 -
 drivers/scsi/arm/acornscsi.c                    | 123 ++---
 drivers/scsi/arm/arxescsi.c                     |   1 +
 drivers/scsi/arm/cumana_2.c                     |   1 +
 drivers/scsi/arm/eesox.c                        |   1 +
 drivers/scsi/arm/fas216.c                       |  57 +--
 drivers/scsi/arm/fas216.h                       |  10 +
 drivers/scsi/arm/powertec.c                     |   2 +-
 drivers/scsi/arm/queue.c                        |   2 +-
 drivers/scsi/atp870u.c                          |  17 +-
 drivers/scsi/be2iscsi/be_main.c                 |  21 +-
 drivers/scsi/bfa/bfad_attr.c                    |  68 +--
 drivers/scsi/bfa/bfad_im.c                      |  16 +-
 drivers/scsi/bfa/bfad_im.h                      |   4 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c               |   8 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |   8 +-
 drivers/scsi/bnx2i/bnx2i.h                      |   2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c                |   2 +-
 drivers/scsi/bnx2i/bnx2i_sysfs.c                |  15 +-
 drivers/scsi/csiostor/csio_init.c               |   1 +
 drivers/scsi/csiostor/csio_lnode.c              |   2 +-
 drivers/scsi/csiostor/csio_scsi.c               |  32 +-
 drivers/scsi/cxlflash/main.c                    |  46 +-
 drivers/scsi/dc395x.c                           |  12 +-
 drivers/scsi/dpt_i2o.c                          |  13 +-
 drivers/scsi/elx/efct/efct_driver.c             |   6 +-
 drivers/scsi/elx/efct/efct_lio.c                |   8 +-
 drivers/scsi/elx/efct/efct_scsi.c               |   6 +-
 drivers/scsi/elx/libefc/efc.h                   |   2 +-
 drivers/scsi/elx/libefc/efc_cmds.c              |   7 +-
 drivers/scsi/elx/libefc/efc_device.c            |   7 +-
 drivers/scsi/elx/libefc/efc_fabric.c            |   5 +-
 drivers/scsi/elx/libefc/efclib.h                |   1 +
 drivers/scsi/esas2r/esas2r_main.c               |   8 +-
 drivers/scsi/esp_scsi.c                         |  12 +-
 drivers/scsi/fcoe/fcoe.c                        |   2 +-
 drivers/scsi/fdomain.c                          |   2 +-
 drivers/scsi/fnic/fnic.h                        |   2 +-
 drivers/scsi/fnic/fnic_attrs.c                  |  17 +-
 drivers/scsi/fnic/fnic_main.c                   |   2 +-
 drivers/scsi/fnic/fnic_scsi.c                   | 122 +++--
 drivers/scsi/hisi_sas/hisi_sas.h                |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c           | 113 +++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c          |  23 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c          |  35 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c          |  62 ++-
 drivers/scsi/hosts.c                            |  17 +-
 drivers/scsi/hpsa.c                             |  56 +--
 drivers/scsi/hptiop.c                           |  20 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                  |  30 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                |  28 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c        |  42 +-
 drivers/scsi/imm.c                              |   6 +-
 drivers/scsi/initio.c                           |   7 +-
 drivers/scsi/ipr.c                              |  48 +-
 drivers/scsi/ips.c                              |  31 +-
 drivers/scsi/isci/init.c                        |   8 +-
 drivers/scsi/isci/task.h                        |   4 -
 drivers/scsi/libfc/fc_fcp.c                     |   6 +-
 drivers/scsi/libiscsi.c                         |  22 +-
 drivers/scsi/libsas/sas_init.c                  |   8 +-
 drivers/scsi/libsas/sas_scsi_host.c             |  27 +-
 drivers/scsi/lpfc/lpfc.h                        |   1 +
 drivers/scsi/lpfc/lpfc_attr.c                   | 324 ++++++-------
 drivers/scsi/lpfc/lpfc_crtn.h                   |   7 +-
 drivers/scsi/lpfc/lpfc_disc.h                   |  12 +-
 drivers/scsi/lpfc/lpfc_els.c                    |  71 ++-
 drivers/scsi/lpfc/lpfc_hbadisc.c                | 144 +++++-
 drivers/scsi/lpfc/lpfc_hw4.h                    |   6 +-
 drivers/scsi/lpfc/lpfc_init.c                   | 155 ++++++-
 drivers/scsi/lpfc/lpfc_nvme.c                   |  72 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c                  |  44 +-
 drivers/scsi/lpfc/lpfc_scsi.c                   | 140 +++---
 drivers/scsi/lpfc/lpfc_sli.c                    | 213 ++++++---
 drivers/scsi/lpfc/lpfc_sli4.h                   |   2 +
 drivers/scsi/lpfc/lpfc_version.h                |   2 +-
 drivers/scsi/mac53c94.c                         |   6 +-
 drivers/scsi/megaraid.c                         |  24 +-
 drivers/scsi/megaraid/megaraid_mbox.c           |  28 +-
 drivers/scsi/megaraid/megaraid_sas.h            |   4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c       |  47 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c     |  56 ++-
 drivers/scsi/mesh.c                             |  18 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                 |  32 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                 |  26 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c             |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h             |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c              |  86 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            |  29 +-
 drivers/scsi/mvsas/mv_init.c                    |  12 +-
 drivers/scsi/mvumi.c                            |   4 +-
 drivers/scsi/myrb.c                             |  60 +--
 drivers/scsi/myrs.c                             |  50 +-
 drivers/scsi/ncr53c8xx.c                        |  39 +-
 drivers/scsi/nsp32.c                            |   7 +-
 drivers/scsi/pcmcia/nsp_cs.c                    |   7 +-
 drivers/scsi/pcmcia/sym53c500_cs.c              |  14 +-
 drivers/scsi/pm8001/pm8001_ctl.c                |  70 +--
 drivers/scsi/pm8001/pm8001_hwi.c                |  12 +-
 drivers/scsi/pm8001/pm8001_init.c               |  14 +-
 drivers/scsi/pm8001/pm8001_sas.c                |  15 +
 drivers/scsi/pm8001/pm8001_sas.h                |   8 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                |  63 ++-
 drivers/scsi/pmcraid.c                          |  27 +-
 drivers/scsi/ppa.c                              |   6 +-
 drivers/scsi/ps3rom.c                           |   8 +-
 drivers/scsi/qedf/qedf.h                        |   2 +-
 drivers/scsi/qedf/qedf_attr.c                   |  15 +-
 drivers/scsi/qedf/qedf_io.c                     |  19 +-
 drivers/scsi/qedf/qedf_main.c                   |   2 +-
 drivers/scsi/qedi/qedi_gbl.h                    |   2 +-
 drivers/scsi/qedi/qedi_iscsi.c                  |   2 +-
 drivers/scsi/qedi/qedi_sysfs.c                  |  15 +-
 drivers/scsi/qla1280.c                          |   8 +-
 drivers/scsi/qla2xxx/qla_attr.c                 | 149 +++---
 drivers/scsi/qla2xxx/qla_bsg.c                  |  48 ++
 drivers/scsi/qla2xxx/qla_bsg.h                  |   7 +
 drivers/scsi/qla2xxx/qla_def.h                  |   4 +-
 drivers/scsi/qla2xxx/qla_gbl.h                  |   8 +-
 drivers/scsi/qla2xxx/qla_gs.c                   |   3 +-
 drivers/scsi/qla2xxx/qla_init.c                 |  20 +-
 drivers/scsi/qla2xxx/qla_isr.c                  |   4 +-
 drivers/scsi/qla2xxx/qla_mbx.c                  |  35 +-
 drivers/scsi/qla2xxx/qla_nvme.c                 |  20 +-
 drivers/scsi/qla2xxx/qla_os.c                   | 103 ++---
 drivers/scsi/qla2xxx/qla_version.h              |   6 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c              |  73 +--
 drivers/scsi/qla4xxx/ql4_attr.c                 |  41 +-
 drivers/scsi/qla4xxx/ql4_glbl.h                 |   3 +-
 drivers/scsi/qla4xxx/ql4_os.c                   |   6 +-
 drivers/scsi/qlogicfas408.c                     |   7 +-
 drivers/scsi/qlogicpti.c                        |   7 +-
 drivers/scsi/scsi.c                             |   8 -
 drivers/scsi/scsi_debug.c                       |  19 +-
 drivers/scsi/scsi_error.c                       |  17 +-
 drivers/scsi/scsi_lib.c                         |  64 ++-
 drivers/scsi/scsi_pm.c                          | 105 +----
 drivers/scsi/scsi_priv.h                        |   7 +-
 drivers/scsi/scsi_scan.c                        |  74 +--
 drivers/scsi/scsi_sysfs.c                       |  54 +--
 drivers/scsi/scsi_transport_iscsi.c             |   8 +-
 drivers/scsi/scsi_transport_sas.c               |   1 +
 drivers/scsi/sd.c                               |  52 ++-
 drivers/scsi/sd_zbc.c                           |   8 +-
 drivers/scsi/ses.c                              |  24 +-
 drivers/scsi/smartpqi/smartpqi.h                |  61 ++-
 drivers/scsi/smartpqi/smartpqi_init.c           | 588 +++++++++++++++++-------
 drivers/scsi/smartpqi/smartpqi_sas_transport.c  |   6 +-
 drivers/scsi/smartpqi/smartpqi_sis.c            |  60 ++-
 drivers/scsi/smartpqi/smartpqi_sis.h            |   4 +-
 drivers/scsi/snic/snic.h                        |   2 +-
 drivers/scsi/snic/snic_attrs.c                  |  19 +-
 drivers/scsi/snic/snic_main.c                   |   2 +-
 drivers/scsi/snic/snic_scsi.c                   |  33 +-
 drivers/scsi/sr.c                               |   7 +-
 drivers/scsi/sr_ioctl.c                         |   2 +-
 drivers/scsi/st.c                               |   1 +
 drivers/scsi/stex.c                             |  10 +-
 drivers/scsi/storvsc_drv.c                      |   4 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c             |   6 +-
 drivers/scsi/ufs/Kconfig                        |  19 +-
 drivers/scsi/ufs/Makefile                       |   1 +
 drivers/scsi/ufs/ufs-exynos.c                   |   6 +-
 drivers/scsi/ufs/ufs-hisi.c                     |   6 +-
 drivers/scsi/ufs/ufs-hwmon.c                    | 210 +++++++++
 drivers/scsi/ufs/ufs-mediatek.c                 | 111 ++++-
 drivers/scsi/ufs/ufs-mediatek.h                 |  27 ++
 drivers/scsi/ufs/ufs-qcom.c                     |  21 +-
 drivers/scsi/ufs/ufs.h                          |   7 +
 drivers/scsi/ufs/ufshcd-pci.c                   |  78 ++++
 drivers/scsi/ufs/ufshcd-pltfrm.c                |   4 +-
 drivers/scsi/ufs/ufshcd.c                       | 512 +++++++++------------
 drivers/scsi/ufs/ufshcd.h                       |  49 +-
 drivers/scsi/ufs/ufshpb.c                       |  15 +-
 drivers/scsi/virtio_scsi.c                      |  11 +-
 drivers/scsi/vmw_pvscsi.c                       |   9 +-
 drivers/scsi/wd33c93.c                          |  18 +-
 drivers/scsi/wd719x.c                           |   4 +-
 drivers/scsi/xen-scsifront.c                    |   4 +-
 drivers/staging/rts5208/rtsx.c                  |   9 +-
 drivers/staging/unisys/visorhba/visorhba_main.c |  20 +-
 drivers/target/iscsi/cxgbit/cxgbit_cm.c         |   8 +-
 drivers/target/iscsi/cxgbit/cxgbit_main.c       |  17 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c     |  28 +-
 drivers/target/iscsi/iscsi_target_configfs.c    |  91 ++--
 drivers/target/loopback/tcm_loop.c              |   4 +-
 drivers/target/sbp/sbp_target.c                 |  30 +-
 drivers/target/target_core_alua.c               |  83 ++--
 drivers/target/target_core_configfs.c           |  33 +-
 drivers/target/target_core_device.c             |   2 +
 drivers/target/target_core_fabric_configfs.c    |  78 +++-
 drivers/target/target_core_iblock.c             |   4 +-
 drivers/target/target_core_internal.h           |   1 +
 drivers/target/target_core_pr.c                 |   2 +-
 drivers/target/target_core_transport.c          |  94 ++--
 drivers/target/target_core_user.c               |   7 +-
 drivers/target/target_core_xcopy.c              |  14 +-
 drivers/usb/gadget/function/f_tcm.c             |  31 +-
 drivers/usb/image/microtek.c                    |   5 +-
 drivers/usb/storage/scsiglue.c                  |  13 +-
 drivers/usb/storage/uas.c                       |  13 +-
 drivers/usb/storage/usb.c                       |   4 +-
 include/linux/libata.h                          |   8 +-
 include/scsi/libsas.h                           |   1 +
 include/scsi/scsi_cmnd.h                        |  14 +-
 include/scsi/scsi_device.h                      |   7 +-
 include/scsi/scsi_host.h                        |  27 +-
 include/scsi/scsi_transport_sas.h               |   1 +
 include/target/target_core_base.h               |   9 +-
 include/target/target_core_fabric.h             |   1 +
 255 files changed, 4507 insertions(+), 3137 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-fc
 create mode 100644 drivers/scsi/ufs/ufs-hwmon.c

James


