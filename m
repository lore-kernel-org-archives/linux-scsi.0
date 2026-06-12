Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAA8305673
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258041; cv=none; b=QeW4/8TrMwOm9fsgJjJn+AIvkQJXaWNKvGMy5LJisewWksuh2ppaUrSO1oT9a6tyPzywTuDisBGFBeGi/6HcKOVGUHEyY+lSohzkyqAQktHiygaTyxd8nKHOJ9Wqd4kTzhTjGNIzEVIDvAatHacte0LBaqw1K9j9ezK1DUOkAwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258041; c=relaxed/simple;
	bh=iUM6j8Na7K1/mY5BcIEVQFQiiMqYTc/ABX8UedP5n94=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=P4PZqExuPgsTddZ2nRNVJ5JaVjtIXnGYdlLnH2V7pzKp08hR67mLxQ3Zpkz0frUzaVzvOey93QBqK25bQs7CTOWnIlhmdTBrAh5ZWY1382XcomPt4PVAKx/Ql1Z/sHQuH5+xFgQQsglRNVIhmGI/xAi67iKmFR4PFRQLhWGjLso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DY9LQmoF; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DY9LQmoF"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C38x5P3678669;
	Fri, 12 Jun 2026 02:53:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=qWFreSSBt82c2ViR+emasYC
	116hxhoiY4Oks99EQPTw=; b=DY9LQmoF2n5/WdZ+vEAKKZ9eBIGf7nh4hYq+Sd8
	0ByOMUOTFquShSbazdzyZid1UwembbzWyjAReVNGY5weVP8vs8HoNEOtYhbmt0jJ
	PhDhanUAts3iNpyT2VIbibBnWTVVlNPg0pknGx/tF/kqAHiHXf79S/51CHM6waa9
	IySEjgRrac/DsqqMKtQqsGVxEhBs6LUcOShEHljwqbPC+hO5TOpa82HGLeVqJc8d
	NNMDEdRw4R7gk97XpdA6z4gJSO8MOjGnC5CEAe8sqB0m1cNuzOvFJDV8G1U0Vs/g
	Ipx9QCPUAEJP/ruj5cLncq4ZUcDn5cy+2AbfMmqdGUWfKpg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92f7-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:53:56 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:53:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:53:55 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 99F853F704D;
	Fri, 12 Jun 2026 02:53:52 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 00/60] scsi: qla2xxx: Add QLA29xx series adapter support
Date: Fri, 12 Jun 2026 15:22:33 +0530
Message-ID: <20260612095333.1666592-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: wnn8yUZf4dVqLWLJCln7XNVHw9Gj5zjW
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd734 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=4y__Q5RjsK4sF3brMMwA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX19MS2XH2o412
 NCGSKOPly7aEzWCHYqjzDN/c6wcf72cIKoxbU+aAKI3AjMk/HXwH22ExHsRTIIjKq8sJC/8Ef3X
 cCeE8BdZu0FiIJr3C0KMi8QfwPx1LPo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXzZfcxUkK2/hI
 CgmisUnedvVN0GkqbP+LTIc1XJduIPvoboI5hiePyepTXzHv9D/eFcD024d4nWobU6JnCYneUCU
 STQYzCJ7Ti5m9L0dxW7Zkk2F2qcgSNLHXxZWmEwBWUatgcb4sPUaOlcuy2mokP0Ixe7D7c6dHvB
 Ypj8cF6V3ojV7ghddyXxRoU9Zo0Eh1/2Cbjph1llvo5iSJ+f26rzYPO1ljmEfgqzIbS7I/yQESP
 lnVYUgKc3COAmw9oQBLDEA4pTQ8U9v0jwUB2uYIwMzvn5Uylvo61sl7FyG5+BDIJocPUarm/uJ6
 E0IsvRrpNDEWY2ZNktuHevrkPeaUubjD5nPPUXmrwF0EE3+IZ3m+5WlGKEdWr9/qNqA8Bfe1eiV
 J7khb03ZAkpjrF9ZKVdGAjOvp32frH39vH4Oiu15xEkepMe1UTUA9L+jGwsGuR7rhMuq1FVV39B
 RH+6tZeyJKJZ8Vj/ilg==
X-Proofpoint-GUID: wnn8yUZf4dVqLWLJCln7XNVHw9Gj5zjW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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
  firmware load, and BSG passthrough (flash block I/O, MPI firmware
  load/dump).

Patches 09-13: 128-byte IOCB infrastructure
  New qla_fw29.h header with extended structure definitions, status
  continuation and marker IOCBs, removal of duplicate flash memo
  block defines, IO-path updates to select the correct IOCB size, and
  introduction of entry-size helper functions that centralise the
  IS_QLA29XX() dispatch pattern.

Patches 14-26: Sysfs, mailbox commands, and core enablement
  Sysfs attribute gating for unsupported 29xx features, mailbox command
  enablement (get_fw_version, execute_fw, get_adapter_id,
  init_firmware, get_firmware_state, serdes, ELS, echo_test,
  data rate), shutdown path, ring-slot helpers, and memory allocation
  updates.

Patches 27-44: Response-path IOCB handling and final wiring
  Marker, status continuation, status entry, CT pass-through, PUREX,
  ELS, logio, task management, abort, ABTS, VP control/config/report-ID,
  NVMe IOCB unification, LS4 pass-through, NVMe ring advance
  conversion, and BSG feature gating adjustments.

Patches 45-60: the tail of the series carries bug fixes uncovered
  during review of v1 patchset (64G/128G speed reporting,
  VP index bounds, Name Server logout detection, NVMe
  abort/LS-reject locking, a BSG job leak, an info leak,
  and an edif NULL deref).

The series applies on top of the scsi tree's 7.1/scsi-queue branch.

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

Anil Gurumurthy (5):
  scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx
  scsi: qla2xxx: Add extended status continuation and marker IOCBs
  scsi: qla2xxx: Remove duplicate flash memo block definitions
  scsi: qla2xxx: Update IO path to use 128-byte IOCBs for 29xx
  scsi: qla2xxx: Replace IS_QLA29XX() size checks with entry-size
    helpers

Manish Rangankar (10):
  scsi: qla2xxx: Add 29xx series PCI device ID support
  scsi: qla2xxx: Add flash read/write interface for 29xx
  scsi: qla2xxx: Add NVRAM config support for 29xx adapters
  scsi: qla2xxx: Add get_flash_version support for 29xx adapters
  scsi: qla2xxx: Add 29xx support in queue initialisation path
  scsi: qla2xxx: Add FC operational firmware load for 29xx
  scsi: qla2xxx: Add flash block read/write BSG support for 29xx
  scsi: qla2xxx: Add BSG MPI firmware load/dump for 29xx
  scsi: qla2xxx: Add LS4 pass-through IOCB handling for 29xx series
  scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support

Nilesh Javali (45):
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
  scsi: qla2xxx: Refactor marker IOCB handling for 29xx series
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
  scsi: qla2xxx: Unify NVMe IOCB build path for 29xx and legacy adapters
  scsi: qla2xxx: Convert NVMe ring advance to use qla_req_ring_advance()
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

 drivers/scsi/qla2xxx/qla_attr.c   |   55 +-
 drivers/scsi/qla2xxx/qla_bsg.c    |  475 +++++++++--
 drivers/scsi/qla2xxx/qla_bsg.h    |   34 +
 drivers/scsi/qla2xxx/qla_dbg.c    |   31 +-
 drivers/scsi/qla2xxx/qla_def.h    |  140 +++-
 drivers/scsi/qla2xxx/qla_dfs.c    |    4 +-
 drivers/scsi/qla2xxx/qla_edif.c   |  104 ++-
 drivers/scsi/qla2xxx/qla_fw.h     |  140 +++-
 drivers/scsi/qla2xxx/qla_fw29.h   |  830 ++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |   40 +-
 drivers/scsi/qla2xxx/qla_gs.c     |  174 +++-
 drivers/scsi/qla2xxx/qla_init.c   |  692 ++++++++++++++-
 drivers/scsi/qla2xxx/qla_inline.h |  247 +++++-
 drivers/scsi/qla2xxx/qla_iocb.c   | 1304 +++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c    |  756 +++++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c    |  482 ++++++++---
 drivers/scsi/qla2xxx/qla_mid.c    |   74 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |  288 +++++--
 drivers/scsi/qla2xxx/qla_nvme.h   |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c     |    2 +-
 drivers/scsi/qla2xxx/qla_os.c     |  273 +++++-
 drivers/scsi/qla2xxx/qla_sup.c    |  761 ++++++++++++++++-
 drivers/scsi/qla2xxx/qla_target.c |   17 +-
 23 files changed, 5920 insertions(+), 1007 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_fw29.h


base-commit: f9a7112b50efe8e115ca335ff57ed7504646a734
-- 
2.47.3

