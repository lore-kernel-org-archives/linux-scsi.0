Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D44B8C83026
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 16:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B324F6108B
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 16:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346271AbhIBQvJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 12:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbhIBQvI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 12:51:08 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F23C061575;
        Thu,  2 Sep 2021 09:50:09 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 1376E1280B61;
        Thu,  2 Sep 2021 09:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1630601409;
        bh=4+OmDyroQIk7Q0EWfALTynvCopM+h+kgz6x8/MSrYFk=;
        h=Message-ID:Subject:From:To:Date:From;
        b=TYaShGL/CimvX7f+Mkx3yuBiaUo7Yk6H1sllTGAJ275OBknOmNyxISCNk93bNLc2G
         CGFa/IBLGcYaA04MtAzo5n38tacNaY/43tJHRoiiRm8UmReBCnZ/gt4K7GINipqoOz
         yqEeZlpeBtXzwuzfv0vuApRcA0g7ik/6LqzOjtA0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8qIlUFOJNlS7; Thu,  2 Sep 2021 09:50:09 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id A40631280B5E;
        Thu,  2 Sep 2021 09:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1630601408;
        bh=4+OmDyroQIk7Q0EWfALTynvCopM+h+kgz6x8/MSrYFk=;
        h=Message-ID:Subject:From:To:Date:From;
        b=hzwtp9/ji1mmQmZsn9XyeOxvDNg0z+/bMc7KCYQ8guJoK4Kq3kSIIGdvFJzebVlYW
         WOFrsl7aoM2+gOoHTFZvjzjrkqd1vupdYeJVzAZZRPpSBOHcPncPgltTn1PlBHrTRI
         U14yAKfkT/0IENRAwp0rXQrBIZsVBmdfuJyJzyvQ=
Message-ID: <fc14fbbf0d7c27b7356bc6271ba2a5599d46af58.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.14+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 02 Sep 2021 09:50:07 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series consists of the usual driver updates (ufs, qla2xxx, target,
smartpqi, lpfc, mpt3sas).  The core change causing the most churn was
replacing the command request field request with a macro, allowing us
to offset map to it and remove the redundant field; the same was also
done for the tag field.  The most impactful change is  the final
removal of scsi_ioctl, which has been deprecated for over a decade.

We also picked up a non trivial conflict with the already upstream
block tree in st.c  The correct resolution is here:

https://lore.kernel.org/all/20210824163215.3f08d55c@canb.auug.org.au/

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Adrian Hunter (2):
      scsi: ufs: Fix ufshcd_request_sense_async() for Samsung KLUFG8RHDA-B2D1
      scsi: ufshcd: Fix device links when BOOT WLUN fails to probe

Alim Akhtar (1):
      scsi: ufs: ufs-exynos: Fix static checker warning

Arun Easi (5):
      scsi: qla2xxx: Fix hang on NVMe command timeouts
      scsi: qla2xxx: Fix hang during NVMe session tear down
      scsi: qla2xxx: Suppress unnecessary log messages during login
      scsi: qla2xxx: Show OS name and version in FDMI-1
      scsi: qla2xxx: Add host attribute to trigger MPI hang

Avri Altman (16):
      scsi: ufs: ufshpb: Do not report victim error in HCM
      scsi: ufs: ufshpb: Verify that 'num_inflight_map_req' is non-negative
      scsi: ufs: ufshpb: Use a correct max multi chunk
      scsi: ufs: ufshpb: Rewind the read timeout on every read
      scsi: ufs: ufshpb: Make host mode parameters configurable
      scsi: ufs: ufshpb: Add support for host control mode
      scsi: ufs: ufshpb: Do not send umap_all in host control mode
      scsi: ufs: ufshpb: Limit the number of in-flight map requests
      scsi: ufs: ufshpb: Add "cold" regions timer
      scsi: ufs: ufshpb: Add HPB dev reset response
      scsi: ufs: ufshpb: Region inactivation in host mode
      scsi: ufs: ufshpb: Make eviction depend on region's reads
      scsi: ufs: ufshpb: Add reads counter
      scsi: ufs: ufshpb: Transform set_dirty to iterate_rgn
      scsi: ufs: ufshpb: Add host control mode support to rsp_upiu
      scsi: ufs: ufshpb: Cache HPB Control mode on init

Balsundar P (1):
      scsi: smartpqi: Add PCI IDs for new ZTE controllers

Bart Van Assche (72):
      scsi: core: Remove the request member from struct scsi_cmnd
      scsi: usb-storage: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: tcm_loop: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: xen-scsifront: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: virtio_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: ufs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: sym53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: sun3_scsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: stex: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: snic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: smartpqi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: scsi_debug: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: qlogicpti: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: qla4xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: qla2xxx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: qla1280: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: qedi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: qedf: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: ncr53c8xx: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: myrs: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: myrb: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: mvumi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: mpt3sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: mpi3mr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: megaraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: lpfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: libsas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: ips: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: ibmvscsi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: ibmvfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: hpsa: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: hisi_sas: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: fnic: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: dpt_i2o: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: cxlflash: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: csiostor: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: bnx2i: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: aha1542: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: advansys: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: aacraid: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: NCR5380: Use sc_data_direction instead of rq_data_dir()
      scsi: 53c700: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: zfcp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: RDMA/srp: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: RDMA/iser: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: ata: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: scsi_transport_spi: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: scsi_transport_fc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: sr: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: sd: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: core: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: core: Introduce the scsi_cmd_to_rq() function
      scsi: ufs: Add fault injection support
      scsi: ufs: Retry aborted SCSI commands instead of completing these successfully
      scsi: ufs: Synchronize SCSI and UFS error handling
      scsi: ufs: Request sense data asynchronously
      scsi: ufs: Fix the SCSI abort handler
      scsi: ufs: Optimize SCSI command processing
      scsi: ufs: Optimize serialization of setup_xfer_req() calls
      scsi: ufs: Revert "Utilize Transfer Request List Completion Notification Register"
      scsi: ufs: Inline ufshcd_outstanding_req_clear()
      scsi: ufs: Remove several wmb() calls
      scsi: ufs: Improve static type checking for the host controller state
      scsi: ufs: Verify UIC locking requirements at runtime
      scsi: ufs: Remove ufshcd_valid_tag()
      scsi: ufs: Use DECLARE_COMPLETION_ONSTACK() where appropriate
      scsi: ufs: Rename the second ufshcd_probe_hba() argument
      scsi: ufs: Only include power management code if necessary
      scsi: ufs: Reduce power management code duplication
      scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()
      scsi: iser: Use scsi_get_sector() instead of scsi_get_lba()
      scsi: core: Introduce scsi_get_sector()

Bean Huo (3):
      scsi: ufs: core: Add lu_enable sysfs node
      scsi: ufs: core: Add L2P entry swap quirk for Micron UFS
      scsi: ufs: core: Remove redundant call in ufshcd_add_command_trace()

Bill Wendling (1):
      scsi: qla2xxx: Remove unused variable 'status'

Bodo Stroesser (1):
      scsi: target: tcmu: Add new feature KEEP_BUF

Christian Loehle (1):
      scsi: sd: Do not exit sd_spinup_disk() quietly

Christoph Hellwig (32):
      scsi: bsg-lib: Fix commands without data transfer in bsg_transport_sg_io_fn()
      scsi: bsg: Fix commands without data transfer in scsi_bsg_sg_io_fn()
      scsi: bsg: Move the whole request execution into the SCSI/transport handlers
      scsi: block: Remove the remaining SG_IO-related fields from struct request_queue
      scsi: block: Remove BLK_SCSI_MAX_CMDS
      scsi: bsg: Simplify device registration
      scsi: sr: cdrom: Move cdrom_read_cdda_bpc() into the sr driver
      scsi: scsi_ioctl: Unexport sg_scsi_ioctl()
      scsi: scsi_ioctl: Factor SG_IO handling into a helper
      scsi: scsi_ioctl: Factor SCSI_IOCTL_GET_IDLUN handling into a helper
      scsi: scsi_ioctl: Consolidate the START STOP UNIT handling
      scsi: scsi_ioctl: Remove a very misleading comment
      scsi: core: Rename CONFIG_BLK_SCSI_REQUEST to CONFIG_SCSI_COMMON
      scsi: scsi_ioctl: Move the "block layer" SCSI ioctl handling to drivers/scsi
      scsi: scsi_ioctl: Simplify SCSI passthrough permission checking
      scsi: scsi_ioctl: Move scsi_command_size_tbl to scsi_common.c
      scsi: scsi_ioctl: Remove scsi_req_init()
      scsi: bsg: Move bsg_scsi_ops to drivers/scsi/
      scsi: bsg: Decouple from scsi_cmd_ioctl()
      scsi: block: Add a queue_max_bytes() helper
      scsi: scsi_ioctl: Call scsi_cmd_ioctl() from scsi_ioctl()
      scsi: scsi_ioctl: Remove scsi_verify_blk_ioctl()
      scsi: scsi_ioctl: Remove scsi_cmd_blk_ioctl()
      scsi: cdrom: Remove the call to scsi_cmd_blk_ioctl() from cdrom_ioctl()
      scsi: st: Simplify ioctl handling
      scsi: core: Remove scsi_compat_ioctl()
      scsi: sg: Consolidate compat ioctl handling
      scsi: ch: Consolidate compat ioctl handling
      scsi: sd: Consolidate compat ioctl handling
      scsi: sr: Consolidate compat ioctl handling
      scsi: bsg: Remove support for SCSI_IOCTL_SEND_COMMAND
      scsi: aacraid: Remove an unused include

Colin Ian King (12):
      scsi: snic: Fix spelling mistake 'progres' -> 'progress'
      scsi: pm8001: Remove redundant initialization of variable 'rv'
      scsi: ufs: ufshpb: Remove redundant initialization of variable 'lba'
      scsi: elx: efct: Remove redundant initialization of variable 'ret'
      scsi: snic: Remove redundant assignment to variable ret
      scsi: ufs: Fix unsigned int compared with less than zero
      scsi: qla2xxx: Remove redundant initialization of variable num_cnt
      scsi: BusLogic: Use %X for u32 sized integer rather than %lX
      scsi: qla2xxx: Fix spelling mistakes "allloc" -> "alloc"
      scsi: target: Remove redundant assignment to variable ret
      scsi: lpfc: Remove redundant assignment to pointer pcmd
      scsi: qla2xxx: Remove redundant continue statement in a for-loop

Daejun Park (4):
      scsi: ufs: ufshpb: Add HPB 2.0 support
      scsi: ufs: ufshpb: Prepare HPB read for cached sub-region
      scsi: ufs: ufshpb: L2P map management for HPB read
      scsi: ufs: ufshpb: Introduce Host Performance Buffer feature

Damien Le Moal (1):
      scsi: mpt3sas: Introduce sas_ncq_prio_supported sysfs sttribute

Dan Carpenter (4):
      scsi: qedf: Fix error codes in qedf_alloc_global_queues()
      scsi: qedi: Fix error codes in qedi_alloc_global_queues()
      scsi: smartpqi: Fix an error code in pqi_get_raid_map()
      scsi: qla2xxx: Fix use after free in debug code

David Disseldorp (4):
      scsi: target: core: Drop unnecessary se_cmd ASC/ASCQ members
      scsi: target: sbp: Drop incorrect ASC/ASCQ usage
      scsi: target: core: Avoid using lun_tg_pt_gp after unlock
      scsi: target: Fix NULL dereference on XCOPY completion

Dmitry Bogdanov (1):
      scsi: target: Fix protect handling in WRITE SAME(32)

Don Brace (3):
      scsi: smartpqi: Update version to 2.1.10-020
      scsi: smartpqi: Change Kconfig menu entry to Microchip
      scsi: smartpqi: Change driver module macros to Microchip

Dwaipayan Ray (1):
      scsi: qla4xxx: Convert uses of __constant_cpu_to_<foo> to cpu_to_<foo>

Guoqing Jiang (1):
      scsi: libsas: Drop BLK_DEV_BSGLIB selection

Gustavo A. R. Silva (1):
      scsi: smartpqi: Replace one-element array with flexible-array member

Halil Pasic (1):
      scsi: core: scsi_ioctl: Fix error code propagation in SG_IO

Hannes Reinecke (7):
      scsi: ncr53c8xx: Remove unused code
      scsi: ncr53c8xx: Complete all commands during bus reset
      scsi: ncr53c8xx: Remove 'sync_reset' argument from ncr_reset_bus()
      scsi: qla2xxx: Open-code qla2xxx_eh_device_reset()
      scsi: qla2xxx: Open-code qla2xxx_eh_target_reset()
      scsi: qla2xxx: Do not call fc_block_scsi_eh() during bus reset
      scsi: ibmvfc: Do not wait for initial device scan

Harshvardhan Jha (1):
      scsi: megaraid_mm: Fix end of loop tests for list_for_each_entry()

Igor Pylypiv (1):
      scsi: pm80xx: Fix TMF task completion race condition

James Smart (43):
      scsi: lpfc: Copyright updates for 14.0.0.1 patches
      scsi: lpfc: Update lpfc version to 14.0.0.1
      scsi: lpfc: Add bsg support for retrieving adapter cmf data
      scsi: lpfc: Add cmf_info sysfs entry
      scsi: lpfc: Add debugfs support for cm framework buffers
      scsi: lpfc: Add support for maintaining the cm statistics buffer
      scsi: lpfc: Add rx monitoring statistics
      scsi: lpfc: Add support for the CM framework
      scsi: lpfc: Add cmfsync WQE support
      scsi: lpfc: Add support for cm enablement buffer
      scsi: lpfc: Add cm statistics buffer support
      scsi: lpfc: Add EDC ELS support
      scsi: lpfc: Expand FPIN and RDF receive logging
      scsi: lpfc: Add MIB feature enablement support
      scsi: lpfc: Add SET_HOST_DATA mbox cmd to pass date/time info to firmware
      scsi: fc: Add EDC ELS definition
      scsi: lpfc: Fix possible ABBA deadlock in nvmet_xri_aborted()
      scsi: lpfc: Copyright updates for 14.0.0.0 patches
      scsi: lpfc: Update lpfc version to 14.0.0.0
      scsi: lpfc: Add 256 Gb link speed support
      scsi: lpfc: Revise Topology and RAS support checks for new adapters
      scsi: lpfc: Fix cq_id truncation in rq create
      scsi: lpfc: Add PCI ID support for LPe37000/LPe38000 series adapters
      scsi: lpfc: Copyright updates for 12.8.0.11 patches
      scsi: lpfc: Update lpfc version to 12.8.0.11
      scsi: lpfc: Skip issuing ADISC when node is in NPR state
      scsi: lpfc: Skip reg_vpi when link is down for SLI3 in ADISC cmpl path
      scsi: lpfc: Call discovery state machine when handling PLOGI/ADISC completions
      scsi: lpfc: Delay unregistering from transport until GIDFT or ADISC completes
      scsi: lpfc: Enable adisc discovery after RSCN by default
      scsi: lpfc: Use PBDE feature enabled bit to determine PBDE support
      scsi: lpfc: Clear outstanding active mailbox during PCI function reset
      scsi: lpfc: Fix KASAN slab-out-of-bounds in lpfc_unreg_rpi() routine
      scsi: lpfc: Remove REG_LOGIN check requirement to issue an ELS RDF
      scsi: lpfc: Fix memory leaks in error paths while issuing ELS RDF/SCR request
      scsi: lpfc: Fix NULL ptr dereference with NPIV ports for RDF handling
      scsi: lpfc: Keep NDLP reference until after freeing the IOCB after ELS handling
      scsi: lpfc: Fix target reset handler from falsely returning FAILURE
      scsi: lpfc: Discovery state machine fixes for LOGO handling
      scsi: lpfc: Fix function description comments for vmid routines
      scsi: lpfc: Improve firmware download logging
      scsi: lpfc: Remove use of kmalloc() in trace event logging
      scsi: lpfc: Fix NVMe support reporting in log message

Jason Yan (1):
      scsi: libsas: Allow libsas to include SCSI header files directly

John Garry (5):
      scsi: qla1280: Stop using scsi_cmnd.tag
      scsi: core: Remove scsi_cmnd.tag
      scsi: ibmvfc: Stop using scsi_cmnd.tag
      scsi: fnic: Stop setting scsi_cmnd.tag
      scsi: wd719: Stop using scsi_cmnd.tag

Kashyap Desai (1):
      scsi: mpi3mr: Set up IRQs in resume path

Keoseong Park (3):
      scsi: ufs: ufshpb: Fix typo in comments
      scsi: ufs: ufshpb: Fix possible memory leak
      scsi: ufs: Refactor ufshcd_is_intr_aggr_allowed()

Kevin Barnett (1):
      scsi: smartpqi: Update copyright notices

Li Manyi (1):
      scsi: sr: Return correct event when media event code is 3

Maciej W. Rozycki (2):
      scsi: BusLogic: Avoid unbounded vsprintf() use
      scsi: BusLogic: Fix missing pr_cont() use

Mahesh Rajashekhara (1):
      scsi: smartpqi: Add PCI IDs for H3C P4408 controllers

Martin K. Petersen (14):
      scsi: mpt3sas: Use the proper SCSI midlayer interfaces for PI
      scsi: lpfc: Use the proper SCSI midlayer interfaces for PI
      scsi: mpi3mr: Use the proper SCSI midlayer interfaces for PI
      scsi: isci: Use the proper SCSI midlayer interfaces for PI
      scsi: core: Add helper to return number of logical blocks in a request
      scsi: ufs: ufshpb: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: storvsc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
      scsi: ufs: core: Use scsi_get_lba() to get LBA
      scsi: core: Make scsi_get_lba() return the LBA
      scsi: scsi_debug: Improve RDPROTECT/WRPROTECT handling
      scsi: scsi_debug: Remove dump_sector()
      scsi: zfcp: Use the proper SCSI midlayer interfaces for PI
      scsi: qla2xxx: Use the proper SCSI midlayer interfaces for PI
      scsi: core: Add scsi_prot_ref_tag() helper

Martin Kepplinger (3):
      scsi: core: Add BLIST_IGN_MEDIA_CHANGE for Ultra HS-SD/MMC USB card readers
      scsi: sd: REQUEST SENSE for BLIST_IGN_MEDIA_CHANGE devices in runtime_resume()
      scsi: core: Add new flag BLIST_IGN_MEDIA_CHANGE

Masahiro Yamada (1):
      scsi: core: Fix missing FORCE for scsi_devinfo_tbl.c build rule

Mike Christie (2):
      scsi: be2iscsi: Fix use-after-free during IP updates
      scsi: iscsi: Fix iface sysfs attr detection

Mike McGowen (2):
      scsi: smartpqi: Fix ISR accessing uninitialized data
      scsi: smartpqi: Add PCI ID for new ntcom controller

Murthy Bhat (1):
      scsi: smartpqi: Add SCSI cmd info for resets

Nilesh Javali (3):
      scsi: qla2xxx: Update version to 10.02.06.200-k
      scsi: qla2xxx: Update version to 10.02.06.100-k
      scsi: qla2xxx: Update version to 10.02.00.107-k

Quinn Tran (23):
      scsi: qla2xxx: Fix NVMe session down detection
      scsi: qla2xxx: Fix NVMe retry
      scsi: qla2xxx: Fix NVMe | FCP personality change
      scsi: qla2xxx: edif: Do secure PLOGI when auth app is present
      scsi: qla2xxx: edif: Add N2N support for EDIF
      scsi: qla2xxx: edif: Fix EDIF enable flag
      scsi: qla2xxx: edif: Reject AUTH ELS on session down
      scsi: qla2xxx: edif: Fix stale session
      scsi: qla2xxx: Fix NPIV create erroneous error
      scsi: qla2xxx: Fix unsafe removal from linked list
      scsi: qla2xxx: Fix port type info
      scsi: qla2xxx: Add debug print of 64G link speed
      scsi: qla2xxx: Adjust request/response queue size for 28xx
      scsi: qla2xxx: edif: Increment command and completion counts
      scsi: qla2xxx: edif: Add encryption to I/O path
      scsi: qla2xxx: edif: Add doorbell notification for app
      scsi: qla2xxx: edif: Add detection of secure device
      scsi: qla2xxx: edif: Add authentication pass + fail bsgs
      scsi: qla2xxx: edif: Add key update
      scsi: qla2xxx: edif: Add extraction of auth_els from the wire
      scsi: qla2xxx: edif: Add send, receive, and accept for auth_els
      scsi: qla2xxx: edif: Add getfcinfo and statistic bsgs
      scsi: qla2xxx: edif: Add start + stop bsgs

Saurav Kashyap (4):
      scsi: qla2xxx: Sync queue idx with queue_pair_map idx
      scsi: qla2xxx: Changes to support kdump kernel for NVMe BFS
      scsi: qla2xxx: Changes to support kdump kernel
      scsi: qla2xxx: Changes to support FCP2 Target

Sergey Samoylenko (2):
      scsi: target: Fix sense key for invalid EXTENDED COPY request
      scsi: target: Allows backend drivers to fail with specific sense codes

Shai Malin (1):
      scsi: qedi: Add support for fastpath doorbell recovery

Sreekanth Reddy (4):
      scsi: mpt3sas: Bump driver version to 38.100.00.00
      scsi: mpt3sas: Add io_uring iopoll support
      scsi: core: Avoid printing an error if target_alloc() returns -ENXIO
      scsi: mpt3sas: Transition IOC to Ready state during shutdown

Suganath Prabu S (2):
      scsi: mpt3sas: Update driver version to 39.100.00.00
      scsi: mpt3sas: Use firmware recommended queue depth

Tuo Li (1):
      scsi: target: pscsi: Fix possible null-pointer dereference in pscsi_complete_cmd()

Tyrel Datwyler (1):
      scsi: ibmvfc: Fix command state accounting and stale response detection

Vincent Palomares (1):
      scsi: ufs: Allow async suspend/resume callbacks

Wei Li (1):
      scsi: fdomain: Fix error return code in fdomain_probe()

Ye Bin (1):
      scsi: scsi_dh_rdac: Avoid crash during rdac_bus_attach()

kernel test robot (1):
      scsi: qla2xxx: edif: Fix returnvar.cocci warnings

lijinlin (1):
      scsi: core: Fix capacity set to zero after offlinining device

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs     |  236 ++
 block/Kconfig                                  |   26 +-
 block/Makefile                                 |    3 +-
 block/blk-mq.c                                 |    2 -
 block/bsg-lib.c                                |   90 +-
 block/bsg.c                                    |  463 +---
 block/scsi_ioctl.c                             |  890 ------
 drivers/ata/libata-eh.c                        |    5 +-
 drivers/ata/libata-scsi.c                      |   10 +-
 drivers/ata/pata_falcon.c                      |    4 +-
 drivers/base/core.c                            |    2 +
 drivers/block/Kconfig                          |    3 +-
 drivers/block/paride/Kconfig                   |    1 -
 drivers/cdrom/cdrom.c                          |   78 +-
 drivers/infiniband/ulp/iser/iser_memory.c      |    2 +-
 drivers/infiniband/ulp/iser/iser_verbs.c       |    2 +-
 drivers/infiniband/ulp/srp/ib_srp.c            |    9 +-
 drivers/s390/scsi/zfcp_fsf.c                   |    6 +-
 drivers/scsi/53c700.c                          |    2 +-
 drivers/scsi/BusLogic.c                        |    8 +-
 drivers/scsi/Kconfig                           |   18 +-
 drivers/scsi/Makefile                          |    9 +-
 drivers/scsi/NCR5380.c                         |    6 +-
 drivers/scsi/aacraid/aachba.c                  |    3 +-
 drivers/scsi/aacraid/commsup.c                 |    2 +-
 drivers/scsi/advansys.c                        |    4 +-
 drivers/scsi/aha1542.c                         |    6 +-
 drivers/scsi/be2iscsi/be_mgmt.c                |   84 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                 |    2 +-
 drivers/scsi/ch.c                              |   73 +-
 drivers/scsi/csiostor/csio_scsi.c              |    6 +-
 drivers/scsi/cxlflash/main.c                   |    2 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c     |    4 +-
 drivers/scsi/dpt_i2o.c                         |    4 +-
 drivers/scsi/elx/efct/efct_lio.c               |    2 +-
 drivers/scsi/fnic/fnic_scsi.c                  |   51 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c          |    4 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c         |    2 +-
 drivers/scsi/hpsa.c                            |    6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                 |   34 +-
 drivers/scsi/ibmvscsi/ibmvfc.h                 |    2 +
 drivers/scsi/ibmvscsi/ibmvscsi.c               |    2 +-
 drivers/scsi/ips.c                             |    2 +-
 drivers/scsi/isci/request.c                    |    4 +-
 drivers/scsi/libsas/Kconfig                    |    1 -
 drivers/scsi/libsas/Makefile                   |    2 +-
 drivers/scsi/libsas/sas_ata.c                  |    6 +-
 drivers/scsi/libsas/sas_discover.c             |    2 +-
 drivers/scsi/libsas/sas_expander.c             |    2 +-
 drivers/scsi/libsas/sas_host_smp.c             |    2 +-
 drivers/scsi/libsas/sas_init.c                 |    2 +-
 drivers/scsi/libsas/sas_phy.c                  |    2 +-
 drivers/scsi/libsas/sas_port.c                 |    2 +-
 drivers/scsi/libsas/sas_scsi_host.c            |    8 +-
 drivers/scsi/lpfc/lpfc.h                       |  253 +-
 drivers/scsi/lpfc/lpfc_attr.c                  |  247 +-
 drivers/scsi/lpfc/lpfc_bsg.c                   |   89 +
 drivers/scsi/lpfc/lpfc_bsg.h                   |   10 +-
 drivers/scsi/lpfc/lpfc_crtn.h                  |   30 +
 drivers/scsi/lpfc/lpfc_ct.c                    |   27 +-
 drivers/scsi/lpfc/lpfc_debugfs.c               |  223 ++
 drivers/scsi/lpfc/lpfc_debugfs.h               |   11 +-
 drivers/scsi/lpfc/lpfc_disc.h                  |    9 +-
 drivers/scsi/lpfc/lpfc_els.c                   | 1193 +++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c               |  221 +-
 drivers/scsi/lpfc/lpfc_hw.h                    |    5 +-
 drivers/scsi/lpfc/lpfc_hw4.h                   |  275 +-
 drivers/scsi/lpfc/lpfc_ids.h                   |    4 +-
 drivers/scsi/lpfc/lpfc_init.c                  | 1495 +++++++++-
 drivers/scsi/lpfc/lpfc_logmsg.h                |    5 +-
 drivers/scsi/lpfc/lpfc_mbox.c                  |    5 +-
 drivers/scsi/lpfc/lpfc_mem.c                   |   15 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c             |   43 +-
 drivers/scsi/lpfc/lpfc_nvme.c                  |   54 +-
 drivers/scsi/lpfc/lpfc_nvme.h                  |    9 +-
 drivers/scsi/lpfc/lpfc_nvmet.c                 |   11 +-
 drivers/scsi/lpfc/lpfc_scsi.c                  |  396 ++-
 drivers/scsi/lpfc/lpfc_scsi.h                  |    6 +-
 drivers/scsi/lpfc/lpfc_sli.c                   |  966 ++++++-
 drivers/scsi/lpfc/lpfc_sli.h                   |    2 +
 drivers/scsi/lpfc/lpfc_sli4.h                  |    5 +-
 drivers/scsi/lpfc/lpfc_version.h               |    2 +-
 drivers/scsi/megaraid/megaraid_mm.c            |   21 +-
 drivers/scsi/megaraid/megaraid_sas_base.c      |    4 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c    |   10 +-
 drivers/scsi/mpi3mr/mpi3mr.h                   |   19 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c                |   37 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c                |   76 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c            |  349 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h            |   40 +-
 drivers/scsi/mpt3sas/mpt3sas_config.c          |   37 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c             |   24 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c           |  167 +-
 drivers/scsi/mvumi.c                           |    2 +-
 drivers/scsi/myrb.c                            |   11 +-
 drivers/scsi/myrs.c                            |   11 +-
 drivers/scsi/ncr53c8xx.c                       |  203 +-
 drivers/scsi/pcmcia/fdomain_cs.c               |    4 +-
 drivers/scsi/pm8001/pm8001_hwi.c               |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c               |   32 +-
 drivers/scsi/qedf/qedf_io.c                    |    8 +-
 drivers/scsi/qedf/qedf_main.c                  |   10 +-
 drivers/scsi/qedi/qedi_fw.c                    |   23 +-
 drivers/scsi/qedi/qedi_iscsi.c                 |   36 +-
 drivers/scsi/qedi/qedi_iscsi.h                 |    1 +
 drivers/scsi/qedi/qedi_main.c                  |   14 +-
 drivers/scsi/qla1280.c                         |    7 +-
 drivers/scsi/qla2xxx/Makefile                  |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c                |   42 +-
 drivers/scsi/qla2xxx/qla_bsg.c                 |   90 +-
 drivers/scsi/qla2xxx/qla_bsg.h                 |    3 +
 drivers/scsi/qla2xxx/qla_dbg.c                 |    3 +-
 drivers/scsi/qla2xxx/qla_dbg.h                 |    1 +
 drivers/scsi/qla2xxx/qla_def.h                 |  221 +-
 drivers/scsi/qla2xxx/qla_edif.c                | 3461 ++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_edif.h                |  136 +
 drivers/scsi/qla2xxx/qla_edif_bsg.h            |  220 ++
 drivers/scsi/qla2xxx/qla_fw.h                  |   13 +-
 drivers/scsi/qla2xxx/qla_gbl.h                 |   51 +-
 drivers/scsi/qla2xxx/qla_gs.c                  |   19 +-
 drivers/scsi/qla2xxx/qla_init.c                |  347 ++-
 drivers/scsi/qla2xxx/qla_inline.h              |   16 +
 drivers/scsi/qla2xxx/qla_iocb.c                |  163 +-
 drivers/scsi/qla2xxx/qla_isr.c                 |  357 ++-
 drivers/scsi/qla2xxx/qla_mbx.c                 |   59 +-
 drivers/scsi/qla2xxx/qla_mid.c                 |   49 +-
 drivers/scsi/qla2xxx/qla_nvme.c                |   77 +-
 drivers/scsi/qla2xxx/qla_nx.c                  |    2 -
 drivers/scsi/qla2xxx/qla_os.c                  |  257 +-
 drivers/scsi/qla2xxx/qla_sup.c                 |    1 -
 drivers/scsi/qla2xxx/qla_target.c              |  196 +-
 drivers/scsi/qla2xxx/qla_target.h              |   19 +-
 drivers/scsi/qla2xxx/qla_version.h             |    6 +-
 drivers/scsi/qla4xxx/ql4_init.c                |    4 +-
 drivers/scsi/qla4xxx/ql4_iocb.c                |    4 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                 |   30 +-
 drivers/scsi/qla4xxx/ql4_nx.c                  |   10 +-
 drivers/scsi/qla4xxx/ql4_os.c                  |   14 +-
 drivers/scsi/qlogicpti.c                       |    2 +-
 drivers/scsi/scsi.c                            |    2 +-
 drivers/scsi/scsi_bsg.c                        |  106 +
 drivers/scsi/scsi_common.c                     |    9 +
 drivers/scsi/scsi_debug.c                      |  125 +-
 drivers/scsi/scsi_devinfo.c                    |    1 +
 drivers/scsi/scsi_error.c                      |   16 +-
 drivers/scsi/scsi_ioctl.c                      |  851 +++++-
 drivers/scsi/scsi_lib.c                        |   37 +-
 drivers/scsi/scsi_logging.c                    |   18 +-
 drivers/scsi/scsi_priv.h                       |    3 +
 drivers/scsi/scsi_scan.c                       |    8 +-
 drivers/scsi/scsi_sysfs.c                      |   33 +-
 drivers/scsi/scsi_transport_fc.c               |    2 +-
 drivers/scsi/scsi_transport_iscsi.c            |   90 +-
 drivers/scsi/scsi_transport_spi.c              |    2 +-
 drivers/scsi/sd.c                              |  125 +-
 drivers/scsi/sd_zbc.c                          |   10 +-
 drivers/scsi/sg.c                              |   33 +-
 drivers/scsi/smartpqi/Kconfig                  |    8 +-
 drivers/scsi/smartpqi/smartpqi.h               |    8 +-
 drivers/scsi/smartpqi/smartpqi_init.c          |   72 +-
 drivers/scsi/smartpqi/smartpqi_sas_transport.c |    4 +-
 drivers/scsi/smartpqi/smartpqi_sis.c           |    4 +-
 drivers/scsi/smartpqi/smartpqi_sis.h           |    4 +-
 drivers/scsi/snic/snic_scsi.c                  |   14 +-
 drivers/scsi/sr.c                              |  145 +-
 drivers/scsi/st.c                              |   72 +-
 drivers/scsi/stex.c                            |    6 +-
 drivers/scsi/storvsc_drv.c                     |    4 +-
 drivers/scsi/sun3_scsi.c                       |    5 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c            |    4 +-
 drivers/scsi/ufs/Kconfig                       |   16 +
 drivers/scsi/ufs/Makefile                      |    2 +
 drivers/scsi/ufs/cdns-pltfrm.c                 |    7 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c             |   32 +-
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c          |    7 +-
 drivers/scsi/ufs/ufs-exynos.c                  |   11 +-
 drivers/scsi/ufs/ufs-exynos.h                  |    2 +-
 drivers/scsi/ufs/ufs-fault-injection.c         |   70 +
 drivers/scsi/ufs/ufs-fault-injection.h         |   24 +
 drivers/scsi/ufs/ufs-hisi.c                    |    7 +-
 drivers/scsi/ufs/ufs-mediatek.c                |    7 +-
 drivers/scsi/ufs/ufs-qcom.c                    |    7 +-
 drivers/scsi/ufs/ufs-sysfs.c                   |   25 +-
 drivers/scsi/ufs/ufs.h                         |   54 +-
 drivers/scsi/ufs/ufs_quirks.h                  |    6 +
 drivers/scsi/ufs/ufshcd-pci.c                  |   48 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c               |   47 -
 drivers/scsi/ufs/ufshcd-pltfrm.h               |   18 -
 drivers/scsi/ufs/ufshcd.c                      |  634 +++--
 drivers/scsi/ufs/ufshcd.h                      |  107 +-
 drivers/scsi/ufs/ufshci.h                      |    1 -
 drivers/scsi/ufs/ufshpb.c                      | 2933 ++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h                      |  323 +++
 drivers/scsi/virtio_scsi.c                     |    4 +-
 drivers/scsi/wd719x.c                          |    8 +-
 drivers/scsi/xen-scsifront.c                   |    2 +-
 drivers/target/Kconfig                         |    2 +-
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c       |    2 +-
 drivers/target/loopback/tcm_loop.c             |    8 +-
 drivers/target/sbp/sbp_target.c                |    4 +-
 drivers/target/target_core_alua.c              |   94 +-
 drivers/target/target_core_iblock.c            |    2 +-
 drivers/target/target_core_pscsi.c             |   18 +-
 drivers/target/target_core_sbc.c               |   35 +-
 drivers/target/target_core_transport.c         |   50 +-
 drivers/target/target_core_user.c              |  150 +-
 drivers/target/target_core_xcopy.c             |   26 +-
 drivers/usb/storage/transport.c                |    2 +-
 fs/nfsd/Kconfig                                |    2 +-
 include/linux/blkdev.h                         |   33 +-
 include/linux/bsg-lib.h                        |    1 +
 include/linux/bsg.h                            |   38 +-
 include/linux/cdrom.h                          |    6 +-
 include/scsi/scsi_cmnd.h                       |   39 +-
 include/scsi/scsi_device.h                     |   22 +-
 include/scsi/scsi_devinfo.h                    |    6 +-
 include/scsi/scsi_ioctl.h                      |    9 +-
 include/scsi/scsi_request.h                    |    2 -
 include/target/target_core_backend.h           |    1 +
 include/target/target_core_base.h              |   10 +-
 include/uapi/linux/target_core_user.h          |    2 +
 include/uapi/scsi/fc/fc_els.h                  |  106 +
 222 files changed, 17535 insertions(+), 4196 deletions(-)
 delete mode 100644 block/scsi_ioctl.c
 create mode 100644 drivers/scsi/qla2xxx/qla_edif.c
 create mode 100644 drivers/scsi/qla2xxx/qla_edif.h
 create mode 100644 drivers/scsi/qla2xxx/qla_edif_bsg.h
 create mode 100644 drivers/scsi/scsi_bsg.c
 create mode 100644 drivers/scsi/ufs/ufs-fault-injection.c
 create mode 100644 drivers/scsi/ufs/ufs-fault-injection.h
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

James


