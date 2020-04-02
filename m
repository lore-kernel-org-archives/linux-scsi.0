Return-Path: <SRS0=+0y/=5S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1291C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 16:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4576620737
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Apr 2020 16:06:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="hOdlDERx";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="hOdlDERx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389297AbgDBQGi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 12:06:38 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38776 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388972AbgDBQGi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 12:06:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 9FC6F8EE477;
        Thu,  2 Apr 2020 09:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1585843597;
        bh=6Y5J62ZdZtHV2Dxq0kskS293jm19WYNhBvrQvjuop3k=;
        h=Subject:From:To:Cc:Date:From;
        b=hOdlDERxUNUPjjU95pIqOx43EXMTN0oPN7nDoQBbHobKxG3eiub14y8sdnrneL0U5
         vhT1hpKYCCLxvaUkh0vPSekwja3rePQzMZ+yTTGw8azhxKdkY2vHxTbHynAxzN3MZA
         ml3jdM3/QedvaTdLyhIthFVFl+Te0wY0DORjVHq8=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wIJIwy5qEPMv; Thu,  2 Apr 2020 09:06:37 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 0C9558EE0F8;
        Thu,  2 Apr 2020 09:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1585843597;
        bh=6Y5J62ZdZtHV2Dxq0kskS293jm19WYNhBvrQvjuop3k=;
        h=Subject:From:To:Cc:Date:From;
        b=hOdlDERxUNUPjjU95pIqOx43EXMTN0oPN7nDoQBbHobKxG3eiub14y8sdnrneL0U5
         vhT1hpKYCCLxvaUkh0vPSekwja3rePQzMZ+yTTGw8azhxKdkY2vHxTbHynAxzN3MZA
         ml3jdM3/QedvaTdLyhIthFVFl+Te0wY0DORjVHq8=
Message-ID: <1585843596.9534.17.camel@HansenPartnership.com>
Subject: [GIT PULL] first round of SCSI updates for the 5.6+ merge window
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Thu, 02 Apr 2020 09:06:36 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series has a huge amount of churn because it pulls in Mauro's doc
update changing all our txt files to rst ones.  Excluding that, we have
 the usual driver updates (qla2xxx, ufs, lpfc, zfcp, ibmvfc, pm80xx,
aacraid), a treewide update for scnprintf and some other minor updates.
 The major core change is Hannes moving functions out of the aacraid
driver and into the core.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Alex Dewar (1):
      scsi: aic7xxx: aic97xx: Remove FreeBSD-specific code

Andrew Vasquez (2):
      scsi: qla2xxx: Update BPM enablement semantics.
      scsi: qla2xxx: Use a dedicated interrupt handler for 'handshake-required' ISPs

Arun Easi (1):
      scsi: qla2xxx: Handle NVME status iocb correctly

Asutosh Das (4):
      scsi: ufs-qcom: Override devfreq parameters
      scsi: ufshcd: Let vendor override devfreq parameters
      scsi: ufshcd: Update the set frequency to devfreq
      scsi: ufs: set load before setting voltage in regulators

Bart Van Assche (14):
      scsi: scsi_trace: Use get_unaligned_be24()
      scsi: st: Use get_unaligned_be24() and sign_extend32()
      scsi: treewide: Consolidate {get,put}_unaligned_[bl]e24() definitions
      scsi: c6x: Include <linux/unaligned/generic.h> instead of duplicating it
      scsi: linux/unaligned/byteshift.h: Remove superfluous casts
      scsi: ufs: Simplify two tests
      scsi: ufs: Introduce ufshcd_init_lrb()
      scsi: core: Introduce {init,exit}_cmd_priv()
      scsi: qla2xxx: Convert MAKE_HANDLE() from a define into an inline function
      scsi: qla2xxx: Fix sparse warnings triggered by the PCI state checking code
      scsi: qla2xxx: Suppress endianness complaints in qla2x00_configure_local_loop()
      scsi: qla2xxx: Simplify the code for aborting SCSI commands
      scsi: qla2xxx: Check locking assumptions at runtime in qla2x00_abort_srb()
      scsi: tcm_qla2xxx: Make qlt_alloc_qfull_cmd() set cmd->se_cmd.map_tag

Bharath Ravi (1):
      scsi: iscsi: Perform connection failure entirely in kernel space

Brian King (2):
      scsi: ibmvfc: Fix NULL return compiler warning
      scsi: ibmvfc: Avoid loss of all paths during SVC node reboot

Can Guo (10):
      scsi: ufs: Do not rely on prefetched data
      scsi: ufs: Enable block layer runtime PM for well-known logical units
      scsi: ufs-qcom: Apply QUIRK_HOST_TACTIVATE for WDC UFS devices
      scsi: ufs: Allow vendor device quirks to be applied early
      scsi: ufs-qcom: Delay specific time before gate ref clk
      scsi: ufs: Add dev ref clock gating wait time support
      scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic
      scsi: ufs: Remove the check before call setup clock notify vops
      scsi: ufs-qcom: Adjust bus bandwidth voting and unvoting
      scsi: ufs: Select INITIAL ADAPT type for HS Gear4

Christoph Hellwig (3):
      scsi: dc395x: remove dc395x_bios_param
      scsi: ufshcd: use an enum for quirks
      scsi: ufshcd: remove unused quirks

Christophe JAILLET (1):
      scsi: aha1740: Fix an errro handling path in aha1740_probe()

Colin Ian King (2):
      scsi: lpfc: fix spelling mistake "Notication" -> "Notification"
      scsi: megaraid_sas: fix indentation issue

Daniel Wagner (1):
      scsi: qla2xxx: Remove non functional code

David Disseldorp (3):
      scsi: target: use an enum to track emulate_ua_intlck_ctrl
      scsi: target: convert boolean se_dev_attrib types to bool
      scsi: target: fix unmap_zeroes_data boolean initialisation

Deepak Ukey (1):
      scsi: pm80xx: sysfs attribute for non fatal dump

Diego Elio Pettenò (1):
      scsi: sr: remove references to BLK_DEV_SR_VENDOR, leave it enabled

Don Brace (1):
      scsi: hpsa: correct race condition in offload enabled

Ewan D. Milne (1):
      scsi: core: avoid repetitive logging of device offline messages

Frank Mayhar (1):
      scsi: iscsi: Add support for asynchronous iSCSI session destruction

Gabriel Krisman Bertazi (1):
      scsi: iscsi: Report connection state in sysfs

Geert Uytterhoeven (1):
      scsi: zorro_esp: Restore devm_ioremap() alignment

Giridhar Malavali (2):
      scsi: qla2xxx: Use FC generic update firmware options routine for ISP27xx
      scsi: qla2xxx: Avoid setting firmware options twice in 24xx_update_fw_options.

Guosong Su (1):
      scsi: core: use kobj_to_dev

Gustavo A. R. Silva (3):
      scsi: message: fusion: Replace zero-length array with flexible-array member
      scsi: Replace zero-length array with flexible-array member
      scsi: advansys: Replace zero-length array with flexible-array member

Hannes Reinecke (16):
      scsi: core: Remove cmd_list functionality
      scsi: aacraid: use scsi_host_busy_iter() in get_num_of_incomplete_fibs()
      scsi: aacraid: use scsi_host_busy_iter() to wait for outstanding commands
      scsi: core: add scsi_host_busy_iter()
      scsi: aacraid: use scsi_host_(block,unblock) to block I/O
      scsi: core: add scsi_host_(block,unblock) helper function
      scsi: aacraid: move scsi_(block,unblock)_requests out of _aac_reset_adapter()
      scsi: aacraid: replace aac_flush_ios() with midlayer helper
      scsi: aacraid: use scsi_host_complete_all_commands() to terminate outstanding commands
      scsi: aacraid: Do not wait for outstanding write commands on synchronize_cache
      scsi: dpt_i2o: use scsi_host_complete_all_commands() to abort outstanding commands
      scsi: core: add scsi_host_complete_all_commands() helper
      scsi: dpt_i2o: rename adpt_i2o_to_scsi() to adpt_i2o_scsi_complete()
      scsi: ch: remove ch_mutex()
      scsi: ch: synchronize ch_probe() and ch_open()
      scsi: ch: fixup refcounting imbalance for SCSI devices

Himanshu Madhani (11):
      scsi: qla2xxx: Update driver version to 10.01.00.25-k
      scsi: qla2xxx: Add 16.0GT for PCI String
      scsi: qla2xxx: Fix sparse warning reported by kbuild bot
      scsi: qla2xxx: Update driver version to 10.01.00.24-k
      scsi: qla2xxx: Use QLA_FW_STOPPED macro to propagate flag
      scsi: qla2xxx: Add fixes for mailbox command
      scsi: qla2xxx: Fix control flags for login/logout IOCB
      scsi: qla2xxx: Save rscn_gen for new fcport
      scsi: qla2xxx: Fix RDP response size
      scsi: qla2xxx: Show correct port speed capabilities for RDP command
      scsi: qla2xxx: Display message for FCE enabled

James Smart (13):
      scsi: lpfc: add RDF registration and Link Integrity FPIN logging
      scsi: fc: Update Descriptor definition and add RDF and Link Integrity FPINs
      scsi: lpfc: Copyright updates for 12.6.0.4 patches
      scsi: lpfc: Update lpfc version to 12.6.0.4
      scsi: lpfc: Clean up hba max_lun_queue_depth checks
      scsi: lpfc: Remove handler for obsolete ELS - Read Port Status (RPS)
      scsi: lpfc: Fix coverity errors in fmdi attribute handling
      scsi: lpfc: Fix compiler warning on frame size
      scsi: lpfc: Fix release of hwq to clear the eq relationship
      scsi: lpfc: Fix registration of ELS type support in fdmi
      scsi: lpfc: Fix broken Credit Recovery after driver load
      scsi: lpfc: Fix lpfc_io_buf resource leak in lpfc_get_scsi_buf_s4 error path
      scsi: lpfc: Fix RQ buffer leakage when no IOCBs available

Jens Remus (6):
      scsi: zfcp: log FC Endpoint Security errors
      scsi: zfcp: enhance handling of FC Endpoint Security errors
      scsi: zfcp: trace FC Endpoint Security of FCP devices and connections
      scsi: zfcp: log FC Endpoint Security of connections
      scsi: zfcp: report FC Endpoint Security in sysfs
      scsi: zfcp: auto variables for dereferenced structs in open port handler

Joe Carnuccio (15):
      scsi: qla2xxx: Print portname for logging in qla24xx_logio_entry()
      scsi: qla2xxx: Fix qla2x00_echo_test() based on ISP type
      scsi: qla2xxx: Correction to selection of loopback/echo test
      scsi: qla2xxx: Use endian macros to assign static fields in fwdump header
      scsi: qla2xxx: Handle cases for limiting RDP response payload length
      scsi: qla2xxx: Add deferred queue for processing ABTS and RDP
      scsi: qla2xxx: Cleanup ELS/PUREX iocb fields
      scsi: qla2xxx: Add vendor extended FDMI commands
      scsi: qla2xxx: Add ql2xrdpenable module parameter for RDP
      scsi: qla2xxx: Add vendor extended RDP additions and amendments
      scsi: qla2xxx: Add changes in preparation for vendor extended FDMI/RDP
      scsi: qla2xxx: Add endianizer macro calls to fc host stats
      scsi: qla2xxx: Add sysfs node for D-Port Diagnostics AEN data
      scsi: qla2xxx: Move free of fcport out of interrupt context
      scsi: qla2xxx: Add beacon LED config sysfs interface

John Garry (1):
      scsi: core: Delete scsi_use_blk_mq

Luo Jiaxing (1):
      scsi: hisi_sas: Use dev_err() in read_iost_itct_cache_v3_hw()

Manish Rangankar (2):
      scsi: qedi: Add PCI shutdown handler support
      scsi: qedi: Add MFW error recovery process

Maurizio Lombardi (3):
      scsi: target: iscsi: calling iscsit_stop_session() inside iscsit_close_session() has no effect
      scsi: target: fix hang when multiple threads try to destroy the same iscsi session
      scsi: target: remove boilerplate code

Mauro Carvalho Chehab (42):
      scsi: docs: convert arcmsr_spec.txt to ReST
      scsi: docs: convert wd719x.txt to ReST
      scsi: docs: convert ufs.txt to ReST
      scsi: docs: convert tcm_qla2xxx.txt to ReST
      scsi: docs: convert sym53c8xx_2.txt to ReST
      scsi: docs: convert sym53c500_cs.txt to ReST
      scsi: docs: convert st.txt to ReST
      scsi: docs: convert smartpqi.txt to ReST
      scsi: docs: convert sd-parameters.txt to ReST
      scsi: docs: convert scsi.txt to ReST
      scsi: docs: convert scsi-parameters.txt to ReST
      scsi: docs: convert scsi_mid_low_api.txt to ReST
      scsi: docs: convert scsi-generic.txt to ReST
      scsi: docs: convert scsi_fc_transport.txt to ReST
      scsi: docs: convert scsi_eh.txt to ReST
      scsi: docs: convert scsi-changer.txt to ReST
      scsi: docs: convert qlogicfas.txt to ReST
      scsi: docs: convert ppa.txt to ReST
      scsi: docs: convert NinjaSCSI.txt to ReST
      scsi: docs: convert ncr53c8xx.txt to ReST
      scsi: docs: convert megaraid.txt to ReST
      scsi: docs: convert lpfc.txt to ReST
      scsi: docs: convert link_power_management_policy.txt to ReST
      scsi: docs: convert libsas.txt to ReST
      scsi: docs: convert hptiop.txt to ReST
      scsi: docs: convert hpsa.txt to ReST
      scsi: docs: convert g_NCR5380.txt to ReST
      scsi: docs: convert FlashPoint.txt to ReST
      scsi: docs: convert dpti.txt to ReST
      scsi: docs: convert dc395x.txt to ReST
      scsi: docs: convert cxgb3i.txt to ReST
      scsi: docs: convert BusLogic.txt to ReST
      scsi: docs: convert bnx2fc.txt to ReST
      scsi: docs: convert bfa.txt to ReST
      scsi: docs: convert aic7xxx.txt to ReST
      scsi: docs: convert aic79xx.txt to ReST
      scsi: docs: convert aha152x.txt to ReST
      scsi: docs: convert advansys.txt to ReST
      scsi: docs: convert aacraid.txt to ReST
      scsi: docs: convert 53c700.txt to ReST
      scsi: docs: include SCSI Transport SRP diagram at the doc body
      scsi: docs: Add an empty index file for SCSI documents

Merlijn Wajer (1):
      scsi: sr: get rid of sr global mutex

Michael Hernandez (2):
      scsi: qla2xxx: Return appropriate failure through BSG Interface
      scsi: qla2xxx: Improved secure flash support messages

Ming Lei (1):
      scsi: core: remove .for_blk_mq

Nitin Rawat (1):
      scsi: ufs: Resume ufs host before accessing ufs device

Peter Chang (2):
      scsi: pm80xx: Cleanup initialization loading fail path
      scsi: pm80xx: Increase request sg length

Phong Tran (1):
      scsi: aacraid: clean up warning cast-function-type

Quinn Tran (10):
      scsi: qla2xxx: Set Nport ID for N2N
      scsi: qla2xxx: Remove restriction of FC T10-PI and FC-NVMe
      scsi: qla2xxx: Serialize fc_port alloc in N2N
      scsi: qla2xxx: Fix NPIV instantiation after FW dump
      scsi: qla2xxx: Fix RDP respond data format
      scsi: qla2xxx: Force semaphore on flash validation failure
      scsi: qla2xxx: add more FW debug information
      scsi: qla2xxx: fix FW resource count values
      scsi: qla2xxx: Fix FCP-SCSI FC4 flag passing error
      scsi: qla2xxx: Use correct ISP28xx active FW region

Rajan Shanmugavelu (1):
      scsi: qla2xxx: add ring buffer for tracing debug logs

Randy Dunlap (1):
      scsi: fusion: fix if-statement empty body warning

Ryan Attard (1):
      scsi: core: Allow non-root users to perform ZBC commands

Sagar Biradar (1):
      scsi: aacraid: Disabling TM path and only processing IOP reset

Sayali Lokhande (1):
      scsi: ufs: Flush exception event before suspend

Stanley Chu (15):
      scsi: ufs-mediatek: customize the delay for enabling host
      scsi: ufs: make HCE polling more compact to improve initialization latency
      scsi: ufs: allow custom delay prior to host enabling
      scsi: ufs-mediatek: use common delay function
      scsi: ufs: introduce common and flexible delay function
      scsi: ufs: use an enum for host capabilities
      scsi: ufs: fix uninitialized tx_lanes in ufshcd_disable_tx_lcc()
      scsi: ufs-mediatek: fix HOST_PA_TACTIVATE quirk for Samsung UFS Devices
      scsi: ufs: ufs-mediatek: add waiting time for reference clock
      scsi: ufs: introduce common function to disable host TX LCC
      scsi: ufs: ufs-mediatek: fix TX LCC disabling timing
      scsi: ufs: ufs-mediatek: gate ref-clk during Auto-Hibern8
      scsi: ufs: fix Auto-Hibern8 error detection
      scsi: ufs: ufs-mediatek: support linkoff state during suspend
      scsi: ufs: ufs-mediatek: ensure UniPro is not powered down before linkup

Steffen Maier (4):
      scsi: zfcp: fix fc_host attributes that should be unknown on local link down
      scsi: zfcp: wire previously driver-specific sysfs attributes also to fc_host
      scsi: zfcp: expose fabric name as common fc_host sysfs attribute
      scsi: zfcp: fix missing erp_lock in port recovery trigger for point-to-point

Takashi Iwai (8):
      scsi: smartpqi: Use scnprintf() for avoiding potential buffer overflow
      scsi: core: Use scnprintf() for avoiding potential buffer overflow
      scsi: megaraid_sas: Use scnprintf() for avoiding potential buffer overflow
      scsi: ipr: Use scnprintf() for avoiding potential buffer overflow
      scsi: gdth: Use scnprintf() for avoiding potential buffer overflow
      scsi: fnic: Use scnprintf() for avoiding potential buffer overflow
      scsi: be2iscsi: Use scnprintf() for avoiding potential buffer overflow
      scsi: aacraid: Use scnprintf() for avoiding potential buffer overflow

Viacheslav Dubeyko (1):
      scsi: target: core: add task tag to trace events

Vikram Auradkar (1):
      scsi: pm80xx: Deal with kexec reboots

Viswas G (1):
      scsi: pm80xx: Introduce read and write length for IOCTL payload structure

Wu Bo (1):
      scsi: libiscsi: Fix error count for active session

yuuzheng (1):
      scsi: pm80xx: Free the tag when mpi_set_phy_profile_resp is received


and the diffstat:

 Documentation/driver-api/libata.rst                |    2 +-
 Documentation/index.rst                            |    1 +
 Documentation/scsi/{53c700.txt => 53c700.rst}      |   61 +-
 Documentation/scsi/{BusLogic.txt => BusLogic.rst}  |   89 +-
 Documentation/scsi/FlashPoint.rst                  |  176 ++
 Documentation/scsi/FlashPoint.txt                  |  163 --
 Documentation/scsi/NinjaSCSI.rst                   |  164 ++
 Documentation/scsi/NinjaSCSI.txt                   |  128 --
 Documentation/scsi/{aacraid.txt => aacraid.rst}    |   59 +-
 Documentation/scsi/{advansys.txt => advansys.rst}  |  129 +-
 Documentation/scsi/{aha152x.txt => aha152x.rst}    |   73 +-
 Documentation/scsi/aic79xx.rst                     |  593 +++++++
 Documentation/scsi/aic79xx.txt                     |  497 ------
 Documentation/scsi/aic7xxx.rst                     |  458 +++++
 Documentation/scsi/aic7xxx.txt                     |  394 -----
 Documentation/scsi/arcmsr_spec.rst                 |  907 ++++++++++
 Documentation/scsi/arcmsr_spec.txt                 |  574 ------
 Documentation/scsi/{bfa.txt => bfa.rst}            |   28 +-
 Documentation/scsi/{bnx2fc.txt => bnx2fc.rst}      |   18 +-
 Documentation/scsi/{cxgb3i.txt => cxgb3i.rst}      |   22 +-
 Documentation/scsi/{dc395x.txt => dc395x.rst}      |   79 +-
 Documentation/scsi/dpti.rst                        |   92 +
 Documentation/scsi/dpti.txt                        |   83 -
 Documentation/scsi/g_NCR5380.rst                   |   93 +
 Documentation/scsi/g_NCR5380.txt                   |   68 -
 Documentation/scsi/{hpsa.txt => hpsa.rst}          |   79 +-
 Documentation/scsi/{hptiop.txt => hptiop.rst}      |   45 +-
 Documentation/scsi/index.rst                       |   51 +
 Documentation/scsi/{libsas.txt => libsas.rst}      |  352 ++--
 ...policy.txt => link_power_management_policy.rst} |   12 +-
 Documentation/scsi/{lpfc.txt => lpfc.rst}          |   16 +-
 Documentation/scsi/{megaraid.txt => megaraid.rst}  |   47 +-
 .../scsi/{ncr53c8xx.txt => ncr53c8xx.rst}          | 1871 ++++++++++++--------
 Documentation/scsi/ppa.rst                         |   18 +
 Documentation/scsi/ppa.txt                         |   14 -
 .../scsi/{qlogicfas.txt => qlogicfas.rst}          |   17 +-
 .../scsi/{scsi-changer.txt => scsi-changer.rst}    |   36 +-
 .../scsi/{scsi-generic.txt => scsi-generic.rst}    |   75 +-
 .../{scsi-parameters.txt => scsi-parameters.rst}   |   28 +-
 Documentation/scsi/{scsi.txt => scsi.rst}          |   31 +-
 Documentation/scsi/{scsi_eh.txt => scsi_eh.rst}    |  213 ++-
 ...scsi_fc_transport.txt => scsi_fc_transport.rst} |  242 ++-
 Documentation/scsi/scsi_mid_low_api.rst            | 1334 ++++++++++++++
 Documentation/scsi/scsi_mid_low_api.txt            | 1280 -------------
 Documentation/scsi/scsi_transport_srp/Makefile     |    7 -
 Documentation/scsi/scsi_transport_srp/figures.rst  |    6 +
 Documentation/scsi/sd-parameters.rst               |   27 +
 Documentation/scsi/sd-parameters.txt               |   22 -
 Documentation/scsi/{smartpqi.txt => smartpqi.rst}  |   52 +-
 Documentation/scsi/{st.txt => st.rst}              |  301 ++--
 .../scsi/{sym53c500_cs.txt => sym53c500_cs.rst}    |    8 +-
 .../scsi/{sym53c8xx_2.txt => sym53c8xx_2.rst}      | 1131 +++++++-----
 .../scsi/{tcm_qla2xxx.txt => tcm_qla2xxx.rst}      |   26 +-
 Documentation/scsi/{ufs.txt => ufs.rst}            |   84 +-
 Documentation/scsi/wd719x.rst                      |   24 +
 Documentation/scsi/wd719x.txt                      |   21 -
 MAINTAINERS                                        |   28 +-
 arch/alpha/configs/defconfig                       |    1 -
 arch/arm/configs/rpc_defconfig                     |    1 -
 arch/arm/configs/s3c2410_defconfig                 |    1 -
 arch/c6x/include/asm/unaligned.h                   |   65 +-
 arch/ia64/configs/zx1_defconfig                    |    1 -
 arch/m68k/configs/amiga_defconfig                  |    1 -
 arch/m68k/configs/apollo_defconfig                 |    1 -
 arch/m68k/configs/atari_defconfig                  |    1 -
 arch/m68k/configs/bvme6000_defconfig               |    1 -
 arch/m68k/configs/hp300_defconfig                  |    1 -
 arch/m68k/configs/mac_defconfig                    |    1 -
 arch/m68k/configs/multi_defconfig                  |    1 -
 arch/m68k/configs/mvme147_defconfig                |    1 -
 arch/m68k/configs/mvme16x_defconfig                |    1 -
 arch/m68k/configs/q40_defconfig                    |    1 -
 arch/m68k/configs/sun3_defconfig                   |    1 -
 arch/m68k/configs/sun3x_defconfig                  |    1 -
 arch/mips/configs/bigsur_defconfig                 |    1 -
 arch/mips/configs/fuloong2e_defconfig              |    1 -
 arch/mips/configs/ip27_defconfig                   |    1 -
 arch/mips/configs/ip32_defconfig                   |    1 -
 arch/mips/configs/jazz_defconfig                   |    1 -
 arch/mips/configs/malta_defconfig                  |    1 -
 arch/mips/configs/malta_kvm_defconfig              |    1 -
 arch/mips/configs/malta_kvm_guest_defconfig        |    1 -
 arch/mips/configs/maltaup_xpa_defconfig            |    1 -
 arch/mips/configs/rm200_defconfig                  |    1 -
 arch/powerpc/configs/85xx-hw.config                |    1 -
 arch/powerpc/configs/amigaone_defconfig            |    1 -
 arch/powerpc/configs/chrp32_defconfig              |    1 -
 arch/powerpc/configs/g5_defconfig                  |    1 -
 arch/powerpc/configs/maple_defconfig               |    1 -
 arch/powerpc/configs/pasemi_defconfig              |    1 -
 arch/powerpc/configs/pmac32_defconfig              |    1 -
 arch/powerpc/configs/powernv_defconfig             |    1 -
 arch/powerpc/configs/ppc64_defconfig               |    1 -
 arch/powerpc/configs/ppc64e_defconfig              |    1 -
 arch/powerpc/configs/ppc6xx_defconfig              |    1 -
 arch/powerpc/configs/pseries_defconfig             |    1 -
 arch/powerpc/configs/skiroot_defconfig             |    1 -
 arch/sh/configs/sh03_defconfig                     |    1 -
 arch/sparc/configs/sparc64_defconfig               |    1 -
 arch/x86/configs/i386_defconfig                    |    1 -
 arch/x86/configs/x86_64_defconfig                  |    1 -
 block/scsi_ioctl.c                                 |    4 +
 drivers/message/fusion/mptlan.h                    |    5 +-
 drivers/message/fusion/mptsas.h                    |    2 +-
 drivers/nvme/host/rdma.c                           |    8 -
 drivers/nvme/target/rdma.c                         |    6 -
 drivers/s390/scsi/zfcp_dbf.c                       |   44 +-
 drivers/s390/scsi/zfcp_dbf.h                       |   32 +-
 drivers/s390/scsi/zfcp_def.h                       |    6 +-
 drivers/s390/scsi/zfcp_erp.c                       |    2 +-
 drivers/s390/scsi/zfcp_ext.h                       |   12 +-
 drivers/s390/scsi/zfcp_fsf.c                       |  290 ++-
 drivers/s390/scsi/zfcp_fsf.h                       |   23 +-
 drivers/s390/scsi/zfcp_scsi.c                      |    5 +
 drivers/s390/scsi/zfcp_sysfs.c                     |   70 +-
 drivers/scsi/BusLogic.c                            |    2 +-
 drivers/scsi/Kconfig                               |   51 +-
 drivers/scsi/aacraid/aachba.c                      |   83 +-
 drivers/scsi/aacraid/comminit.c                    |   35 +-
 drivers/scsi/aacraid/commsup.c                     |   48 +-
 drivers/scsi/aacraid/linit.c                       |  171 +-
 drivers/scsi/advansys.c                            |    2 +-
 drivers/scsi/aha152x.c                             |    4 +-
 drivers/scsi/aha1740.c                             |    1 -
 drivers/scsi/aic7xxx/Kconfig.aic79xx               |    2 +-
 drivers/scsi/aic7xxx/Kconfig.aic7xxx               |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |   22 +-
 drivers/scsi/arcmsr/arcmsr_attr.c                  |    2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c                   |    2 +-
 drivers/scsi/be2iscsi/be_mgmt.c                    |   20 +-
 drivers/scsi/ch.c                                  |   40 +-
 drivers/scsi/dc395x.c                              |   34 -
 drivers/scsi/dpt/dpti_ioctl.h                      |    2 +-
 drivers/scsi/dpt_i2o.c                             |   27 +-
 drivers/scsi/dpti.h                                |    5 +-
 drivers/scsi/fnic/fnic_trace.c                     |   58 +-
 drivers/scsi/fnic/vnic_devcmd.h                    |    2 +-
 drivers/scsi/g_NCR5380.c                           |    2 +-
 drivers/scsi/gdth_proc.c                           |    2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |    3 +-
 drivers/scsi/hosts.c                               |   65 +
 drivers/scsi/hpsa.c                                |   80 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  207 ++-
 drivers/scsi/ibmvscsi/ibmvfc.h                     |    3 +-
 drivers/scsi/ipr.c                                 |    6 +-
 drivers/scsi/ipr.h                                 |    6 +-
 drivers/scsi/isci/sas.h                            |    2 +-
 drivers/scsi/libiscsi.c                            |    9 +-
 drivers/scsi/lpfc/lpfc.h                           |   33 +-
 drivers/scsi/lpfc/lpfc_attr.c                      |    5 +-
 drivers/scsi/lpfc/lpfc_crtn.h                      |    3 +-
 drivers/scsi/lpfc/lpfc_ct.c                        |  141 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  519 +++---
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |   65 +-
 drivers/scsi/lpfc/lpfc_hw.h                        |   62 +-
 drivers/scsi/lpfc/lpfc_hw4.h                       |   19 +
 drivers/scsi/lpfc/lpfc_init.c                      |   40 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |    6 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |   16 +-
 drivers/scsi/lpfc/lpfc_version.h                   |    4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   11 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |    2 +-
 drivers/scsi/mvsas/mv_sas.h                        |    2 +-
 drivers/scsi/mvumi.h                               |    4 +-
 drivers/scsi/ncr53c8xx.c                           |    2 +-
 drivers/scsi/pcmcia/Kconfig                        |    2 +-
 drivers/scsi/pm8001/pm8001_ctl.c                   |   51 +-
 drivers/scsi/pm8001/pm8001_defs.h                  |    5 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |   22 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   80 +-
 drivers/scsi/pm8001/pm8001_sas.h                   |    7 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  155 +-
 drivers/scsi/pmcraid.h                             |    2 +-
 drivers/scsi/qedi/qedi.h                           |    3 +
 drivers/scsi/qedi/qedi_gbl.h                       |    1 +
 drivers/scsi/qedi/qedi_iscsi.c                     |   18 +
 drivers/scsi/qedi/qedi_iscsi.h                     |    1 +
 drivers/scsi/qedi/qedi_main.c                      |  104 +-
 drivers/scsi/qla2xxx/qla_attr.c                    |  133 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   36 +-
 drivers/scsi/qla2xxx/qla_dbg.c                     |   23 +-
 drivers/scsi/qla2xxx/qla_def.h                     |  387 ++--
 drivers/scsi/qla2xxx/qla_dfs.c                     |   11 +-
 drivers/scsi/qla2xxx/qla_fw.h                      |  173 +-
 drivers/scsi/qla2xxx/qla_gbl.h                     |   23 +-
 drivers/scsi/qla2xxx/qla_gs.c                      | 1707 ++++++++----------
 drivers/scsi/qla2xxx/qla_init.c                    |  202 +--
 drivers/scsi/qla2xxx/qla_iocb.c                    |   42 +-
 drivers/scsi/qla2xxx/qla_isr.c                     |  295 ++-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  388 +++-
 drivers/scsi/qla2xxx/qla_mid.c                     |   13 +-
 drivers/scsi/qla2xxx/qla_mr.c                      |   13 +-
 drivers/scsi/qla2xxx/qla_nvme.c                    |    2 +-
 drivers/scsi/qla2xxx/qla_os.c                      |  722 +++++++-
 drivers/scsi/qla2xxx/qla_sup.c                     |   13 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   38 +-
 drivers/scsi/qla2xxx/qla_target.h                  |    2 +
 drivers/scsi/qla2xxx/qla_tmpl.c                    |   17 +-
 drivers/scsi/qla2xxx/qla_tmpl.h                    |    4 +-
 drivers/scsi/qla2xxx/qla_version.h                 |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   25 +
 drivers/scsi/scsi.c                                |   18 -
 drivers/scsi/scsi_error.c                          |    1 -
 drivers/scsi/scsi_lib.c                            |   98 +-
 drivers/scsi/scsi_priv.h                           |    3 -
 drivers/scsi/scsi_scan.c                           |    1 -
 drivers/scsi/scsi_sysfs.c                          |   18 +-
 drivers/scsi/scsi_trace.c                          |    6 +-
 drivers/scsi/scsi_transport_iscsi.c                |  135 +-
 drivers/scsi/smartpqi/Kconfig                      |    2 +-
 drivers/scsi/smartpqi/smartpqi_init.c              |   22 +-
 drivers/scsi/snic/vnic_devcmd.h                    |    2 +-
 drivers/scsi/sr.c                                  |   20 +-
 drivers/scsi/sr.h                                  |    2 +
 drivers/scsi/sr_vendor.c                           |    8 -
 drivers/scsi/st.c                                  |    6 +-
 drivers/scsi/stex.c                                |    2 +-
 drivers/scsi/ufs/Kconfig                           |    2 +-
 drivers/scsi/ufs/cdns-pltfrm.c                     |    2 +-
 drivers/scsi/ufs/ufs-hisi.c                        |    2 +-
 drivers/scsi/ufs/ufs-mediatek.c                    |  141 +-
 drivers/scsi/ufs/ufs-mediatek.h                    |   15 +
 drivers/scsi/ufs/ufs-qcom.c                        |  146 +-
 drivers/scsi/ufs/ufs-sysfs.c                       |   28 +-
 drivers/scsi/ufs/ufs.h                             |    3 +
 drivers/scsi/ufs/ufs_quirks.h                      |    1 +
 drivers/scsi/ufs/ufshcd-pci.c                      |    2 +-
 drivers/scsi/ufs/ufshcd.c                          |  362 ++--
 drivers/scsi/ufs/ufshcd.h                          |  205 +--
 drivers/scsi/ufs/unipro.h                          |    7 +
 drivers/scsi/virtio_scsi.c                         |    1 -
 drivers/scsi/zorro_esp.c                           |    5 +-
 drivers/target/iscsi/iscsi_target.c                |   82 +-
 drivers/target/iscsi/iscsi_target.h                |    1 -
 drivers/target/iscsi/iscsi_target_configfs.c       |    5 +-
 drivers/target/iscsi/iscsi_target_login.c          |    5 +-
 drivers/target/target_core_configfs.c              |    4 +-
 drivers/target/target_core_device.c                |    4 +-
 drivers/target/target_core_spc.c                   |   13 +-
 drivers/target/target_core_tmr.c                   |    6 +-
 drivers/target/target_core_transport.c             |    3 +-
 drivers/target/target_core_ua.c                    |    8 +-
 drivers/usb/gadget/function/f_mass_storage.c       |    1 +
 drivers/usb/gadget/function/storage_common.h       |    5 -
 include/linux/unaligned/be_byteshift.h             |    6 +-
 include/linux/unaligned/generic.h                  |   46 +
 include/linux/unaligned/le_byteshift.h             |    6 +-
 include/scsi/iscsi_if.h                            |   11 +-
 include/scsi/scsi_bsg_iscsi.h                      |    2 +-
 include/scsi/scsi_cmnd.h                           |    1 -
 include/scsi/scsi_device.h                         |    8 +-
 include/scsi/scsi_host.h                           |   17 +-
 include/scsi/scsi_ioctl.h                          |    2 +-
 include/scsi/scsi_transport_iscsi.h                |   10 +
 include/scsi/sg.h                                  |    2 +-
 include/scsi/srp.h                                 |    8 +-
 include/target/iscsi/iscsi_target_core.h           |    2 +-
 include/target/target_core_backend.h               |    6 -
 include/target/target_core_base.h                  |   45 +-
 include/trace/events/qla.h                         |   39 +
 include/trace/events/target.h                      |   11 +-
 include/uapi/scsi/fc/fc_els.h                      |  211 ++-
 include/uapi/scsi/scsi_bsg_fc.h                    |    2 +-
 scripts/documentation-file-ref-check               |    2 +-
 264 files changed, 13027 insertions(+), 8535 deletions(-)
 rename Documentation/scsi/{53c700.txt => 53c700.rst} (75%)
 rename Documentation/scsi/{BusLogic.txt => BusLogic.rst} (93%)
 create mode 100644 Documentation/scsi/FlashPoint.rst
 delete mode 100644 Documentation/scsi/FlashPoint.txt
 create mode 100644 Documentation/scsi/NinjaSCSI.rst
 delete mode 100644 Documentation/scsi/NinjaSCSI.txt
 rename Documentation/scsi/{aacraid.txt => aacraid.rst} (83%)
 rename Documentation/scsi/{advansys.txt => advansys.rst} (73%)
 rename Documentation/scsi/{aha152x.txt => aha152x.rst} (76%)
 create mode 100644 Documentation/scsi/aic79xx.rst
 delete mode 100644 Documentation/scsi/aic79xx.txt
 create mode 100644 Documentation/scsi/aic7xxx.rst
 delete mode 100644 Documentation/scsi/aic7xxx.txt
 create mode 100644 Documentation/scsi/arcmsr_spec.rst
 delete mode 100644 Documentation/scsi/arcmsr_spec.txt
 rename Documentation/scsi/{bfa.txt => bfa.rst} (72%)
 rename Documentation/scsi/{bnx2fc.txt => bnx2fc.rst} (91%)
 rename Documentation/scsi/{cxgb3i.txt => cxgb3i.rst} (86%)
 rename Documentation/scsi/{dc395x.txt => dc395x.rst} (64%)
 create mode 100644 Documentation/scsi/dpti.rst
 delete mode 100644 Documentation/scsi/dpti.txt
 create mode 100644 Documentation/scsi/g_NCR5380.rst
 delete mode 100644 Documentation/scsi/g_NCR5380.txt
 rename Documentation/scsi/{hpsa.txt => hpsa.rst} (77%)
 rename Documentation/scsi/{hptiop.txt => hptiop.rst} (78%)
 create mode 100644 Documentation/scsi/index.rst
 rename Documentation/scsi/{libsas.txt => libsas.rst} (57%)
 rename Documentation/scsi/{link_power_management_policy.txt => link_power_management_policy.rst} (65%)
 rename Documentation/scsi/{lpfc.txt => lpfc.rst} (93%)
 rename Documentation/scsi/{megaraid.txt => megaraid.rst} (66%)
 rename Documentation/scsi/{ncr53c8xx.txt => ncr53c8xx.rst} (55%)
 create mode 100644 Documentation/scsi/ppa.rst
 delete mode 100644 Documentation/scsi/ppa.txt
 rename Documentation/scsi/{qlogicfas.txt => qlogicfas.rst} (92%)
 rename Documentation/scsi/{scsi-changer.txt => scsi-changer.rst} (87%)
 rename Documentation/scsi/{scsi-generic.txt => scsi-generic.rst} (70%)
 rename Documentation/scsi/{scsi-parameters.txt => scsi-parameters.rst} (81%)
 rename Documentation/scsi/{scsi.txt => scsi.rst} (82%)
 rename Documentation/scsi/{scsi_eh.txt => scsi_eh.rst} (73%)
 rename Documentation/scsi/{scsi_fc_transport.txt => scsi_fc_transport.rst} (74%)
 create mode 100644 Documentation/scsi/scsi_mid_low_api.rst
 delete mode 100644 Documentation/scsi/scsi_mid_low_api.txt
 delete mode 100644 Documentation/scsi/scsi_transport_srp/Makefile
 create mode 100644 Documentation/scsi/scsi_transport_srp/figures.rst
 create mode 100644 Documentation/scsi/sd-parameters.rst
 delete mode 100644 Documentation/scsi/sd-parameters.txt
 rename Documentation/scsi/{smartpqi.txt => smartpqi.rst} (67%)
 rename Documentation/scsi/{st.txt => st.rst} (79%)
 rename Documentation/scsi/{sym53c500_cs.txt => sym53c500_cs.rst} (89%)
 rename Documentation/scsi/{sym53c8xx_2.txt => sym53c8xx_2.rst} (53%)
 rename Documentation/scsi/{tcm_qla2xxx.txt => tcm_qla2xxx.rst} (57%)
 rename Documentation/scsi/{ufs.txt => ufs.rst} (79%)
 create mode 100644 Documentation/scsi/wd719x.rst
 delete mode 100644 Documentation/scsi/wd719x.txt
 create mode 100644 include/trace/events/qla.h

James

