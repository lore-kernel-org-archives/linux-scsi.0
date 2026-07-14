Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED8F4446F0
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022856; cv=none; b=ROn1akYpZLOx2ZqfYmWcqyiyIB/fQ724+biEcdtd0Rx/3qf0TOpNUbFm/WBkRkGAr7KFBqqr01/AxtK7vfSun+XeZjDZke5fs3pR9OyornIGtKgiqEoR6ltJbBywlEvzmvWKK1fQ2BcjoEdtCAyLZZfGx+W4vX4YymoMo4ASkXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022856; c=relaxed/simple;
	bh=s/O2dUfV5fHrAQ1BQEmkpG52QqIEfFDZkcZNCmcmStE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lftaDGXUjv1yc+kqi8rymhmiEWEddNVM+b5i7fD7PW6wVvaG28Qc2hbmiK1TyvIBF0a+w6cAfyHBmUtQkxueS6IacKZ745xh5cz8cIo7bg3QcMr1Qk+eeonUqgopmrfihs+5QspBYTM8GEe69Idafw1hAihwfTL+rwVchlWmN8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ilRVcDCT; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ilRVcDCT"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UTmt2353993;
	Tue, 14 Jul 2026 02:54:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=Z70rbfSMJk9rcuS4+JnVnVK
	mwo2t0oNizCXG1kZBKDU=; b=ilRVcDCTos9M1AIWdWr1cH/lXu18eNndhI3PDEs
	ziYUCC+4/ckbAuSoYQwZlgu7wFIGWbg+oAUIhEnrg1LC6IzS4510h+DH0Zii6hah
	ErBLDKfSpim8G23YGvbql2948pcdvvp1AWswIYlwAHdcElHaff4ajU38m7yNKAuY
	et3BBHjE84Nn6FpY6g6E+QfJ+LbNBRi53D7H4L60Fr6lfBtL4c0CjwZ9SZJF8YqG
	Ri2UgC5Cl8545+W+TiXdjjvOiGTDyhOYtcRZXvaK6t//E6i9MNr00VHuSOZUmD8f
	FG5JlazSUwJkVMCIp0xgCx5bpQgiKSi860tdMS42fWCwHVg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fca36nhtd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:54:07 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:54:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:54:05 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2AA7B5E6867;
	Tue, 14 Jul 2026 02:54:02 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 00/56] scsi: qla2xxx: Add QLA29xx series adapter support
Date: Tue, 14 Jul 2026 15:22:57 +0530
Message-ID: <20260714095353.289460-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX/tVzy+4IXYBW
 Har3g5xXmZNm+kmviJIXokpOt07J8shKYKRaes+wk0xAvgeM3ZuPIU3CPe3IwYFsehojfAXa+jj
 T3ra/vZgJ+p6yjRkG1GGN+vPgtUNKGiCj5cBrNV3VbE0oZc2/8Z1oCDzne4LZTE66zHujxVGZBo
 a/yYoM11b3y7NofsPttbxH8FPo20VbYoutjwOmEgkeTlROrZKI0r61L+3EgL/cjXz6iHaDfTM68
 X+VbJNb+Ww9X1yrypW1Met9UGp3LziSnjRp3HChGA2y+RgCEGkPQ2zKK9scnjTZPWVeWnFl+IwC
 Wf6JmPUBkoDnBr4E5EL0VGGydsxVLyb7U5d/Og22JFG996atJPaLbRYjXkUEIHYinzjuAnfCUk2
 CwNRB2G6usJ2XG2nW+ujHpu2yvlwxrH1RkMRfd7QUjgZ4c1sfn749lEr+iAjGytoyL6MF9QVtwV
 JiS1gU1gAPj+xC/k9xA==
X-Authority-Analysis: v=2.4 cv=EeT4hvmC c=1 sm=1 tr=0 ts=6a56073f cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=mEwe1YunUMR9jZSthb4A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX3ABuMKWUXowO
 ccwmYqh352gDK8tDGWFxapUd59btJ/EVrDq2nnwLvRwNpZB8L3sDe/TnWAw442Y1mkT1TEF5vIO
 cT2nCaqHTyBAH8tYiRYkOe7eaqcz4ik=
X-Proofpoint-ORIG-GUID: cZS-gNR1qqjX_cnbgwN52f4UqLguh5qY
X-Proofpoint-GUID: cZS-gNR1qqjX_cnbgwN52f4UqLguh5qY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

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
 drivers/scsi/qla2xxx/qla_bsg.c     |  589 +++++++++++-
 drivers/scsi/qla2xxx/qla_bsg.h     |   34 +
 drivers/scsi/qla2xxx/qla_dbg.c     |   31 +-
 drivers/scsi/qla2xxx/qla_def.h     |  143 ++-
 drivers/scsi/qla2xxx/qla_dfs.c     |    4 +-
 drivers/scsi/qla2xxx/qla_edif.c    |  101 +-
 drivers/scsi/qla2xxx/qla_fw.h      |  140 ++-
 drivers/scsi/qla2xxx/qla_fw29.h    |  830 ++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h     |   42 +-
 drivers/scsi/qla2xxx/qla_gs.c      |  176 +++-
 drivers/scsi/qla2xxx/qla_init.c    |  735 +++++++++++++-
 drivers/scsi/qla2xxx/qla_inline.h  |  282 +++++-
 drivers/scsi/qla2xxx/qla_iocb.c    | 1424 ++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c     |  683 ++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c     |  476 ++++++++--
 drivers/scsi/qla2xxx/qla_mid.c     |   74 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  288 ++++--
 drivers/scsi/qla2xxx/qla_nvme.h    |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c      |    2 +-
 drivers/scsi/qla2xxx/qla_os.c      |  273 +++++-
 drivers/scsi/qla2xxx/qla_sup.c     |  783 ++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.c  |   34 +-
 drivers/scsi/qla2xxx/qla_version.h |   10 +-
 24 files changed, 6163 insertions(+), 1052 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_fw29.h


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.47.3

