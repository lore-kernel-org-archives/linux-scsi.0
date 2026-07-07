Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBFA3101CE
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403711; cv=none; b=PYEfRiAXm2zmXQIIfXVG1DZbJDozZqIHSMhpOuaCOBQfnMP/ecQsUrSpyMU6O1P6xSpGztQqCcMPYmWk0csA4NXKTw3NmZoz+fJ6jiUa56xQbHLG5i7bzQbssf1FQb0h+OUVYLXXKnZwrYDBT2IIv6A/4adtQkjLInwCh7pnqPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403711; c=relaxed/simple;
	bh=wgtg3ft5CU2ho3r4qmFCBxyOm5/lxrZHSuMUvErU8Io=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i5AK/Krx0afViG5zzBoRo/ZG/LyjQmX9v+/gDPVSAK2W3lmLzRlwFWo0ZacXvUQfVK0RrLk4/pOpkc9p5wL/z2wgcMIIEBkOaoMba8JaKaGt4oIkIwW3CryqKBamgMFpzRnv8RiRyUrYgua+tM3j+vJiJ2hogWFCCrw6j/GquXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=F1wwwC77; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="F1wwwC77"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748KRt873305;
	Mon, 6 Jul 2026 22:55:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=i17JruIGLa6BNts1khxJWH1
	sb5iTgTI7oqIXtq07rlg=; b=F1wwwC77HOScLEW7SU4HRsBxWqDWJJcV0jpM+CM
	FSiK7adbD7eXshCpd062TlJWCl3o0YzZpaZaxHPXVhaOPaOTsJMx2RAdI3hrcQl6
	nYpUK5ERxWWNH4NmqZ9rMLAxQvqSv46MXarX332o3lMIuPm6XenGA882zDcTqvZI
	ezP5q0xNYhqoWMX7xWPPqZcEU6OLKpiwYQMfTXmeTG8dFvDlSn8FpMXrjobzOtlJ
	11GvXdiaBWbZBPu7vn0ULqu3u+N/XFQlvGj0+oXHxfbj+cy7jGsGpJ/4Z9IfmJ5g
	CSXYI3Txel8V8L8oyyNxZQLKF1Vu3gM1lN60sqqvo4FFN5g==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9wa9xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:00 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:54:59 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:54:59 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 9F42D3F7066;
	Mon,  6 Jul 2026 22:54:56 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 00/88] scsi: qla2xxx: Add QLA29xx series adapter support
Date: Tue, 7 Jul 2026 11:23:07 +0530
Message-ID: <20260707055435.2680300-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: JGd03WzEFTmlcoc2oLRw-qZipaGE0uWG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX6hAQoVaIPpEx
 bIwDnRpTPtB6yvKyrMbb7h4ffaHI17e0/qVETSLRM1r3/QN0hg8HseNR/yy7YrI8eUTKrxgO3WS
 3GZt0RUL3HaeKRduKh8OcfTFfJRsj/+hVe7Xh0VdHI3+9czxI/Bs9XbDKGi08EG6JvT//sCKuIi
 KxhZp7ePuLA5bAxQE3YsE3pFd6kUqDDgmZ9BdJ/5QyLOG29cvj4tC0oxa6rw4E0hLSiyrpmutWS
 WhbDbb0eTPHPuJgLA3up4f+ILVKdV39qmaa0eU4UYApmQ7wNKrb2whoL4bEiSmhj9/wXJDBWmFD
 6g69RWIuE71btKUo+6VCC6litz9KaSPdohvTt/GlG97Odc3TtxKCBoRXdcPwwPCRdPwrEzyt5eF
 u9r21hrzJEEUYEBUKwI/oXhow/FErPvo0cA/iPYHfiM+Q09UQGgYNeoEpN0D3guLwEDyz9ZtjAR
 psDyN7zCWG+/ve+4Gug==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX2Hp7YGVdfKla
 DY9g/9kT4T1CZBtJunzyjVorYxhzwqNM9B0cOUD3xcSnwO9nvee9VrzC5jIIA0kViw3Pcimwwxz
 n2PLOU0f58UN7jaXdFKyMAlwDGlU/QU=
X-Proofpoint-GUID: JGd03WzEFTmlcoc2oLRw-qZipaGE0uWG
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c94b4 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=CktCOgVc0EmJJti9HRsA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

Add support for the QLA29xx generation of Marvell QLogic
Fibre Channel HBAs (ISP2091/ISP2291/ISP2099/ISP2299).
The 29xx family shares much of its architecture with the
existing 27xx/28xx adapters but introduces 128-byte request
and response ring entries (up from 64 bytes), requiring
extended IOCB definitions and updated ring management
throughout the driver.

The key hardware change is the wider IOCB format: every
request and response queue entry is now 128 bytes.
This propagates into every code path that builds, submits,
or processes IOCBs -- command submission, status completion,
marker, CT pass-through, ELS, logio, task management,
abort, ABTS, VP control, and NVMe.

The series is organised as follows:

Patches 01-08: Foundation and flash/firmware infrastructure
  PCI device ID registration, ISP-flags wiring, flash read/write
  interface, NVRAM configuration, queue initialisation, FC operational
  firmware load, removal of a redundant VPD flash read in the sysfs
  read path, and BSG passthrough (flash block I/O, MPI firmware
  load/dump).

Patches 09-11: 128-byte IOCB infrastructure
  New qla_fw29.h header with extended structure definitions, status
  continuation and marker IOCBs, and IO-path updates that select the
  correct IOCB size via the entry-size helpers.

Patches 12-24: Sysfs, mailbox commands, and core enablement
  Sysfs attribute gating for unsupported 29xx features, mailbox command
  enablement (get_fw_version, execute_fw, get_adapter_id,
  init_firmware, get_firmware_state, serdes, ELS, echo_test,
  data rate), shutdown path, ring-slot helpers, and memory allocation
  updates.

Patches 25-39: Response-path IOCB handling and final wiring
  Status continuation, status entry, CT pass-through, PUREX, ELS,
  logio, task management, abort, ABTS, VP control/config/report-ID,
  LS4 pass-through, and BSG feature gating adjustments.

Patches 40-55: bug fixes uncovered during review of the earlier
  postings -- queue teardown NULL dma_free and bitmap locking,
  endianness/bitfield cleanups, 64-bit FPM word counters, 64G/128G
  port speed setting and reporting, an edif NULL deref, Name Server
  logout detection on FWI2 adapters, VP index bounds, NVMe abort and
  LS-reject locking, a dport diagnostics info leak, a BSG job leak,
  and an unbounded FRU image count.

Patches 56-87: additional robustness and bug fixes found during
  continued review -- MSI-X derived queue-count clamping, firmware
  dump data-capture improvement, flash-version read serialisation,
  use-after-free fixes (qpair work on teardown, cs84xx on host
  teardown, FCE trace during firmware dump), firmware-state and
  mailbox hygiene, FCE trace enable parsing, QLAFX00 ring-slot init,
  error-path pointer clearing, response-queue over-consumption,
  soft-lockup polling and OOB sense-data guards, response-IRQ
  quiescing and completion-path SRB validation, NPIV vport count
  clamping and report-ID-acquisition locking/refcount fixes, NVMe
  abort/LS-reject/unsolicited-context correctness and locking, a
  coherent DMA buffer for D_Port diagnostics, and BSG passthrough
  hardening (zero-initialised stack buffers, request_len validation,
  SFP DMA zeroing, and I2C length bounds).

Patch 88: bump the driver version to 12.00.00.2607b1.

The series applies on top of the scsi tree's 7.1/scsi-queue branch.

Changes in v3:
  - Folded several standalone helper and refactor commits into the
    feature commits they support, so every 29xx enablement commit is
    self-contained and bisectable: the entry-size helper conversion,
    the marker IOCB refactor, the NVMe IOCB build-path unification,
    the NVMe ring-advance conversion, and the duplicate flash-memo
    block removal are no longer separate patches.
  - Reworked flash-version handling: dropped the standalone
    get_flash_version patch in favour of removing the redundant VPD
    flash read in the sysfs read path.
  - Added a large batch of additional robustness and bug fixes
    uncovered during continued review (patches 56-87), covering the
    completion/response path, NPIV and report-ID acquisition, NVMe
    unsolicited-context handling, and BSG passthrough hardening.
  - Bumped the driver version to 12.00.00.2607b1.
  - Added Reviewed-by: Hannes Reinecke <hare@kernel.org> to the
    reviewed 29xx enablement patches (patches 01-55).

Changes in v2:
  - Folded the standalone fix-ups posted in v1 into the feature commits
    they corrected, so the 29xx enablement commits are now individually
    correct and bisectable (no "fix the previous patch" commits in the
    middle of the series).
  - Corrected several Fixes: tags to reference the actual introducing
    commits after the above reorganisation.
  - Widened the ELS vp_index path to 16 bits to match the 29xx 9-bit
    hardware field, folded into the ELS enablement commit.

Thanks,
Nilesh

Anil Gurumurthy (3):
  scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx
  scsi: qla2xxx: Add extended status continuation and marker IOCBs
  scsi: qla2xxx: Update IO path to use 128-byte IOCBs for 29xx

Manish Rangankar (10):
  scsi: qla2xxx: Add 29xx series PCI device ID support
  scsi: qla2xxx: Add flash read/write interface for 29xx
  scsi: qla2xxx: Add NVRAM config support for 29xx adapters
  scsi: qla2xxx: Add 29xx support in queue initialisation path
  scsi: qla2xxx: Add FC operational firmware load for 29xx
  scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path
  scsi: qla2xxx: Add flash block read/write BSG support for 29xx
  scsi: qla2xxx: Add BSG MPI firmware load/dump for 29xx
  scsi: qla2xxx: Add LS4 pass-through IOCB handling for 29xx series
  scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support

Nilesh Javali (74):
  scsi: qla2xxx: Skip image-set-valid attribute for 29xx
  scsi: qla2xxx: Skip unsupported sysfs attributes for 29xx
  scsi: qla2xxx: Enable get_fw_version mailbox for 29xx
  scsi: qla2xxx: Extend execute_fw mailbox to include 29xx
  scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
  scsi: qla2xxx: Enable init_firmware mailbox for 29xx
  scsi: qla2xxx: Enable get_firmware_state for 29xx
  scsi: qla2xxx: Enable serdes, resource count and FCE trace for 29xx
  scsi: qla2xxx: Enable set_els_cmds and echo_test for 29xx
  scsi: qla2xxx: Add support for QLA29XX in data rate functions
  scsi: qla2xxx: Enable qla2x00_shutdown for 29xx
  scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs
  scsi: qla2xxx: Add support for QLA29XX in memory allocation
  scsi: qla2xxx: Handle sts_cont_entry_ext_t for 29xx adapters
  scsi: qla2xxx: Update handling of status entries for 29xx series
  scsi: qla2xxx: Enhance ct_entry_24xx_ext iocb handling for 29xx series
  scsi: qla2xxx: Enhance purex_entry handling for 29xx series
  scsi: qla2xxx: Update handling of ELS IOCBs for 29xx series
  scsi: qla2xxx: Add size check for ELS status entry layout on 29xx
  scsi: qla2xxx: Add 29xx extended logio IOCB support
  scsi: qla2xxx: Enhance task management IOCB handling for 29xx series
  scsi: qla2xxx: Add abort command handling for 29xx series
  scsi: qla2xxx: Enhance ABTS processing for 29xx series
  scsi: qla2xxx: Update VP control IOCB handling for 29xx series
  scsi: qla2xxx: Add build-time size check for VP config IOCB layout
  scsi: qla2xxx: Add size check for extended VP report ID entry
  scsi: qla2xxx: Fix queue teardown NULL dma_free and bitmap locking
  scsi: qla2xxx: Replace __le16 bitfields with scalar and accessors
  scsi: qla2xxx: Fix endianness annotations in vp_rpt_id_entry
    structures
  scsi: qla2xxx: Use 64-bit FPM word counters for 29xx host stats
  scsi: qla2xxx: Add 64G/128G port speed setting support
  scsi: qla2xxx: Fix 64G link speed reporting in get_data_rate
  scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
  scsi: qla2xxx: Fix Name Server logout detection on FWI2 adapters
  scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size
  scsi: qla2xxx: Check entry_status in qla24xx_modify_vp_config()
  scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()
  scsi: qla2xxx: Initialize NVMe abort_work once at submission
  scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject
  scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
  scsi: qla2xxx: Fix BSG job leak on validate flash image error path
  scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
  scsi: qla2xxx: Clamp MSI-X derived queue counts to avoid truncation
  scsi: qla2xxx: Serialize flash version read in reset handler
  scsi: qla2xxx: Fix use-after-free of qpair work on queue teardown
  scsi: qla2xxx: Clarify MPI optrom address/length units
  scsi: qla2xxx: Fix cs84xx use-after-free on host teardown
  scsi: qla2xxx: Don't query firmware state while chip is down
  scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
  scsi: qla2xxx: Fix FCE trace enable parsing in debugfs
  scsi: qla2xxx: Fix FCE trace use-after-free during firmware dump
  scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot
  scsi: qla2xxx: Null out freed pointers in qla2x00_mem_alloc() error
    path
  scsi: qla2xxx: Fix response queue over-consumption in
    __qla_consume_iocb()
  scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature
  scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read
  scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()
  scsi: qla2xxx: Quiesce response IRQ before freeing request queue
  scsi: qla2xxx: Reject non-SCSI SRB on status IOCB fast path
  scsi: qla2xxx: Clamp max_npiv_vports to VP_CTRL bitmap capacity
  scsi: qla2xxx: Avoid double completion in async IOCB timeout
  scsi: qla2xxx: Skip vport under deletion in report ID acquisition
  scsi: qla2xxx: Drop vport reference under lock in report ID
    acquisition
  scsi: qla2xxx: Hold vport_slock for host map update in report ID
    acquisition
  scsi: qla2xxx: Fix NVMe abort reference leak on repeated abort
  scsi: qla2xxx: Skip NVMe LS reject IOCB when FW not started
  scsi: qla2xxx: Unlink NVMe unsol ctx before freeing on LS reject error
  scsi: qla2xxx: Serialize NVMe unsol ctx list with a per-fcport lock
  scsi: qla2xxx: Use coherent DMA buffer for D_Port diagnostics
  scsi: qla2xxx: Zero-init bsg stack buffers to avoid info leak
  scsi: qla2xxx: Validate BSG request_len before reading vendor_cmd[]
  scsi: qla2xxx: Zero SFP DMA buffer in FRU/I2C bsg handlers
  scsi: qla2xxx: Bound i2c->length in I2C bsg handlers
  scsi: qla2xxx: Update version to 12.00.00.2607b1

Quinn Tran (1):
  scsi: qla2xxx: Improve firmware dump data capture

 drivers/scsi/qla2xxx/qla_attr.c    |   63 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |  608 +++++++++++--
 drivers/scsi/qla2xxx/qla_bsg.h     |   34 +
 drivers/scsi/qla2xxx/qla_dbg.c     |   37 +-
 drivers/scsi/qla2xxx/qla_def.h     |  145 +++-
 drivers/scsi/qla2xxx/qla_dfs.c     |    8 +-
 drivers/scsi/qla2xxx/qla_edif.c    |  101 ++-
 drivers/scsi/qla2xxx/qla_fw.h      |  144 ++-
 drivers/scsi/qla2xxx/qla_fw29.h    |  830 ++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h     |   40 +-
 drivers/scsi/qla2xxx/qla_gs.c      |  176 +++-
 drivers/scsi/qla2xxx/qla_init.c    |  919 +++++++++++++++++---
 drivers/scsi/qla2xxx/qla_inline.h  |  295 ++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    | 1303 ++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c     |  755 ++++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c     |  499 ++++++++---
 drivers/scsi/qla2xxx/qla_mid.c     |   78 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  315 +++++--
 drivers/scsi/qla2xxx/qla_nvme.h    |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c      |    2 +-
 drivers/scsi/qla2xxx/qla_os.c      |  310 +++++--
 drivers/scsi/qla2xxx/qla_sup.c     |  784 ++++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.c  |   34 +-
 drivers/scsi/qla2xxx/qla_tmpl.c    |   48 +-
 drivers/scsi/qla2xxx/qla_version.h |   10 +-
 25 files changed, 6388 insertions(+), 1154 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_fw29.h


base-commit: 1801c8284d34d7927f1a158226e427c195936746
prerequisite-patch-id: 9cdf671a5c422facf4cee5626701f9135d076122
prerequisite-patch-id: 807b23211a696e9f032ae85b037aafeb08501768
prerequisite-patch-id: 1145e5762d000b371299b981054a7baabbbede6e
prerequisite-patch-id: ad6f2e8fdf93cc1341470516aee8ccdee0d99cfb
prerequisite-patch-id: 6df17c866b242df13f50eba6cd81f26d4dc0656c
prerequisite-patch-id: 05d09642756af9c90cd8568d63496c676ace66f0
prerequisite-patch-id: 85252984f56a31690f027b735594caf003738e27
prerequisite-patch-id: 86b571d585d2dd9f783220df2bb1baeab0c7dc2b
prerequisite-patch-id: 44f65619d39d4e5f1dd56a898ee6156238a6b3b7
prerequisite-patch-id: 412cfca3d3695325b90a70a56f998e26d34cf5bd
prerequisite-patch-id: 368f0039bdb590ec70f83327ed6c82028342367f
prerequisite-patch-id: 0af9e8e1b40955fb0f513f973db167ff469dd45f
-- 
2.47.3

