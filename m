Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F29F2749DF
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783079; cv=none; b=GUjs20zuiMBFkJwN+v2Rj/4RI3l1DSDaesE6JGuY4KkaL+ApAh7JAnpee/NyX42u2RA6DKqgut/lYd6/aOIJU/JgW+gT5+MCL0VxoilK0WFjiTp+zWEeQMx9fMlBGu1o1C9Dhr9scoKOreBElgz6DiqRil1zcB5gI3fkD7HIF7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783079; c=relaxed/simple;
	bh=ULU566b80R0OboYHYrByiP24s4dLt8wKTiIM0yrIq8Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MmDfCWj9Oasu1Siv403iR5g/bJ+aunYFBzAx3SuoardOm4Mah9R3sGwMj2X8stvyVzc3gF2nT3YYVWeTtk0woPLYm9kt0i/jmRU0LPWxxE+k8stqcuAVko+rzLjdhCiLsjTyBPXVH1qbioF9JrORco6VzCU0kktiSKDF382ZUig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RC/mfWOG; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RC/mfWOG"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4wAh42443057;
	Wed, 22 Jul 2026 22:04:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=zUT/vwzRtTBvRjGZiGDNQDh
	Taqo6NsodZn3t13pZI+I=; b=RC/mfWOGU73xnsZJdJ6b1OJ+cZkV16l+p+zquU7
	7ggXLJNN+/Bc3RH6lNG174EbPowblGl6+AVZpE1qqB0ohIILfZRs1og2NpuAQoAV
	uXXB7dSBqlnmiI0yrbX+DarYFMBVsY7vevo84T/TFutei7SpDSfYXiAEtsGEU6zG
	B5v14gtGbA/C5wa5n+g+1+tVpLz/yKqfnTyp6LoiT15kgARATrVptkHIryF19GMH
	5telbgYLYJWu+8ngvM+XwYy9DuqlyudJNVU4J7dmHzCcG9WCtNemkq0czSYflluG
	Y0qiF5GxOw8s4Lr0i4Cv2eHzVEcywgq6pil7mx4rBqunDEA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrkyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:04:26 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:04:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:04:25 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C19805C68E6;
	Wed, 22 Jul 2026 22:04:22 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 00/56] scsi: qla2xxx: Add QLA29xx series adapter support
Date: Thu, 23 Jul 2026 10:33:17 +0530
Message-ID: <20260723050413.3897522-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX/eo00SpFei8C
 yNrFxEGK5Oc7eHG5kvA3OxV7fBt+q3oPYtwkr6Z83bl4nD4h2MFXdkaghvbSOWOqJna6UBWGJr6
 SzW3Iw1LT6m2ukJMnuYYaSEHypCxHTECUcdvBuVAjjh5o83wYyNTHb3okRrpI3meWpdDsUXSws8
 3ISXcoITAKBYHY5PjbNAmsslwdsd1UR10oCtn5HdghQTDz6Fyv+eQdBjRurILp356Lm4tmXYcad
 1xO+McNX5wtpNrfbpYNvBMvIdL/sfG+ffQRObmmbias0X7ddGvlL98HfMe0DvZRjV6+eY6RdSOH
 yV+AP2mlgtJbH3fzOLLuJYus20/XchYFn/NnFRtyuBxcchEOpPoaSS/jyMzO45f3UdpdMTQxJJa
 jx825FsNZFebzKYnGKgRVMiwZeiZ/9I1TqaK8fHmTdlBJDJRecyDF7NDR/ea/bG7MuctGQLkqp2
 HmcXGuwCCdRcY3qK8ow==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXzXEmn18w64BK
 Xc6dfxxiDZSRwCr18H2kH1hV001Dl7Ii7RB7jPuz+BMqQXogNNVaMdb+pVanUqct3DIin/jrS1J
 iqNuktjmJohCjGSSw0EYJzs+Hwqrq/U=
X-Proofpoint-GUID: Pa-GEdehPXE8n2JBzcIFDJcHiJF8X7cx
X-Proofpoint-ORIG-GUID: Pa-GEdehPXE8n2JBzcIFDJcHiJF8X7cx
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a0da cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8
 a=ZRBccoQMm9eMLuhr6ZEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

Add support for the QLA29xx generation of Marvell QLogic Fibre Channel
HBAs (ISP2091/ISP2291/ISP2099/ISP2299). The 29xx family shares much of
its architecture with the existing 27xx/28xx adapters but introduces
128-byte request and response ring entries (up from 64 bytes), requiring
extended IOCB definitions and updated ring management throughout the
driver.

The key hardware change is the wider IOCB format: every request and
response queue entry is now 128 bytes. This propagates into every code
path that builds, submits, or processes IOCBs -- command submission,
status completion, marker, CT pass-through, ELS, logio, task management,
abort, ABTS, VP control, and NVMe.

The series is organised as follows:

Patches 01-08: Foundation and flash/firmware infrastructure
  PCI device ID registration, ISP-flags wiring, flash read/write
  interface, NVRAM configuration, queue initialisation, FC operational
  firmware load, removal of a redundant VPD flash read in the sysfs read
  path, and BSG passthrough (flash block I/O, MPI firmware load/dump).

Patches 09-11: 128-byte IOCB infrastructure
  New qla_fw29.h header with extended structure definitions, status
  continuation and marker IOCBs, and IO-path updates that select the
  correct IOCB size via the entry-size helpers.

Patches 12-24: Sysfs, mailbox commands, and core enablement
  Sysfs attribute gating for unsupported 29xx features, mailbox command
  enablement (get_fw_version, execute_fw, get_adapter_id, init_firmware,
  get_firmware_state, serdes, ELS, echo_test, data rate), shutdown path,
  ring-slot helpers, and memory allocation updates.

Patches 25-39: Response-path IOCB handling and final wiring
  Status continuation, status entry, CT pass-through, PUREX, ELS, logio,
  task management, abort, ABTS, VP control/config/report-ID, LS4
  pass-through, and BSG feature gating adjustments.

Patches 40-55: bug fixes uncovered during review of the earlier postings
  -- queue teardown NULL dma_free and bitmap locking, endianness/bitfield
  cleanups, 64-bit FPM word counters, 64G/128G port speed setting and
  reporting, an edif NULL deref, Name Server logout detection on FWI2
  adapters, VP index bounds, NVMe abort and LS-reject locking, a dport
  diagnostics info leak, a BSG job leak, and an unbounded FRU image count.

Patch 56: bump the driver version to 12.00.00.2607b1.

The series applies on top of Linux 7.2-rc1.

Changes in v6:
  - No functional change to the 29xx enablement. Dropped the
    image_length-based flash-region bounds check that had been folded into
    the flash block read/write BSG support commit (patch 07). image_length
    is the size of the image currently stored in a region, not the region's
    writable capacity, so the check falsely rejected legitimate flash
    updates that write a new, larger image (e.g. a region 0xd3 write of
    0x99404 bytes). Firmware already enforces region isolation via the
    region-relative address, so the check added no correct protection.
    Removed the qla29xx_validate_flash_region() helper and its two callers,
    dropped the qla29xx_get_flash_region() export from qla_gbl.h, and
    restored the function to static in qla_sup.c.

Changes in v5:
  - No functional change from v4. Folded the static-analysis and
    kernel test robot cleanups into the feature commits they touch, so
    every commit stays self-contained and bisectable:
    - removed set-but-unused variables (chunk_count in the flash
      read/write interface, vha/ha in the 128-byte IO path);
    - fixed kernel-doc parameter lists (added @ha and @data_sz, dropped
      the excess @bundling description);
    - corrected the control_flags endianness annotation to
      cpu_to_le16(CF_DATA_SEG_DESCR_ENABLE);
    - relocated a misplaced out_29xx label flagged by sparse; and
    - fixed two checkpatch indentation warnings on ql_dbg() calls.
  - Added Reported-by: kernel test robot <lkp@intel.com> and the
    matching Closes: links to the four affected commits.

Changes in v4:
  - Folded the follow-up robustness and bug-fix commits that were posted
    as separate patches in v3 into the feature commits they correct,
    resolving their Fixes: tags by squashing, so every commit in the
    series is self-contained and bisectable with no "fix the previous
    patch" commits. The posting is now 56 patches (down from 88).
  - Dropped fixes to pre-existing driver code that are independent of the
    29xx series (e.g. the firmware-dump data-capture change) from this
    posting; they will be submitted separately.
  - Rebased the series onto Linux 7.2-rc1.

Changes in v3:
  - Folded several standalone helper and refactor commits into the
    feature commits they support, so every 29xx enablement commit is
    self-contained and bisectable: the entry-size helper conversion, the
    marker IOCB refactor, the NVMe IOCB build-path unification, the NVMe
    ring-advance conversion, and the duplicate flash-memo block removal
    are no longer separate patches.
  - Reworked flash-version handling: dropped the standalone
    get_flash_version patch in favour of removing the redundant VPD flash
    read in the sysfs read path.
  - Added a large batch of additional robustness and bug fixes uncovered
    during continued review, covering the completion/response path, NPIV
    and report-ID acquisition, NVMe unsolicited-context handling, and BSG
    passthrough hardening.
  - Bumped the driver version to 12.00.00.2607b1.
  - Added Reviewed-by: Hannes Reinecke <hare@kernel.org> to the reviewed
    29xx enablement patches.

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

Nilesh Javali (43):
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
  scsi: qla2xxx: Update version to 12.00.00.2607b1

 drivers/scsi/qla2xxx/qla_attr.c    |   57 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |  537 ++++++++++-
 drivers/scsi/qla2xxx/qla_bsg.h     |   34 +
 drivers/scsi/qla2xxx/qla_dbg.c     |   31 +-
 drivers/scsi/qla2xxx/qla_def.h     |  143 ++-
 drivers/scsi/qla2xxx/qla_dfs.c     |    4 +-
 drivers/scsi/qla2xxx/qla_edif.c    |  101 +-
 drivers/scsi/qla2xxx/qla_fw.h      |  140 ++-
 drivers/scsi/qla2xxx/qla_fw29.h    |  830 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h     |   40 +-
 drivers/scsi/qla2xxx/qla_gs.c      |  176 +++-
 drivers/scsi/qla2xxx/qla_init.c    |  735 +++++++++++++-
 drivers/scsi/qla2xxx/qla_inline.h  |  282 +++++-
 drivers/scsi/qla2xxx/qla_iocb.c    | 1419 ++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c     |  676 ++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c     |  476 ++++++++--
 drivers/scsi/qla2xxx/qla_mid.c     |   74 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  288 ++++--
 drivers/scsi/qla2xxx/qla_nvme.h    |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c      |    2 +-
 drivers/scsi/qla2xxx/qla_os.c      |  273 +++++-
 drivers/scsi/qla2xxx/qla_sup.c     |  781 ++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.c  |   34 +-
 drivers/scsi/qla2xxx/qla_version.h |   10 +-
 24 files changed, 6099 insertions(+), 1048 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_fw29.h


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.47.3

