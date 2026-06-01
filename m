Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45A63939B5
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309761; cv=none; b=Nx5pM5itlGFCjqTiH/1Mv52u5Gi3bXK13TYJf6YKq98TzUlSOYqSa90quESTQ7IOGWgdBU+EYMYIktzyKLzXUbHFyuBcN2BoJ9DYebizMUO5b1yW89GmmRgX5zRb5O2s1v7dCu67H7PcFip00x59xDsEVHtC4QxqmN4mLavW7wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309761; c=relaxed/simple;
	bh=am/gL56uUsGSb8vSUIyFoTGTFOsA7TQ7OZ4rl2wgbS0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dQsX3o6X13YDs6PTJf9uQVM5sKGnOABksSoY+yKABAd1iI4HE2NgAkXSz0jyQI+b5yECszphopA+nw/wjyk0/ETHnY8wHlvKif6KF0FTOGJytmeHrG/OcBaa5wnoOejSXm6Gbz4kYDK+4PH+97akw9XWipTHypy9Sl8GPZiy3oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=H9R1uz4h; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="H9R1uz4h"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64VLlUeT3316094;
	Mon, 1 Jun 2026 03:29:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=/h7Ubj4VERKt19P+iz0rRsT
	Qub1Hk6nazgJw+1G7E/Q=; b=H9R1uz4hqyIhXNO2FEobJqisouvGtyxUwWv5Pql
	SP3s6hH82nuyHC3KaP5TFEfTi/IjAnoEAnVTT+SCVy8xdqV/DgJQJhFnG/7OLFkB
	VtGjg/zDVCkJjfSb+rq3/uyslXX1+VPVjoZwSzHYVK+WqgqEv354u1TYQKq7xjGi
	0KGc3lC6Pc+W00NJkAreX3yY/CRi+64/R9JzZRaj/CoeEM4JJp1tPHxkoDPiRDqV
	IFTOLluLHhoIUnnLIwHZY65UDDDOqWFeLk9y0ugb17MV2Kq3dILCu55IjtOJ1mD5
	KpQzQVi8FBoRAYzjmCOfp4hI1IIUd1Hj2tPd2RS0wgUHcVw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4eggn8b8se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:29:16 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:29:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:29:14 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 454CF3F7054;
	Mon,  1 Jun 2026 03:29:12 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 00/44] scsi: qla2xxx: Add QLA29xx series adapter support
Date: Mon, 1 Jun 2026 15:58:09 +0530
Message-ID: <20260601102853.328426-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ybjXljuVm4OvRARIog6BvRPC4SOgNvh9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX/lRy7rH3IOkq
 vQ/ppiss7hYUhDuh5cwqko+5DNgL358w5E8pWTbL82zeOaMWo2C25pPWr5iEGpQxN1WcCKg82wI
 7bGZYTPkmu5QKGSkxtT45jEcODSrkbTNPqpbTEIy317yENbp+RelHvmILaB9NIHq8XLC7ZUsxI3
 AsnKtEgWtmBqv6MEb3viid66GBS7lJAg7/FsexvB1szMRwg+oY1woDRD+5wshaJakrGuvd/hKbC
 xDle1s+Bk5ULXMPuhKskk2h5jlsl2aVoQ8gMOnGB48ok1bk7FV6wyM5Hyld5JYJuQQ1hfesnVHN
 URdCzWDFB096CwPm/t91xbP2h5XjBRZwGstuXnIi+X0dO37XFx8nyfXFu3+PtufRtVWP3eBRCwf
 OjIRqxgOJmmFeitQrri+diKrmRf1FrGlSz9DXh35zBp7kCSHCCaDnb/A1ve2cZdQMcOnxwFbpzE
 N/cQkvxWCnMX12Ts0eg==
X-Proofpoint-GUID: ybjXljuVm4OvRARIog6BvRPC4SOgNvh9
X-Authority-Analysis: v=2.4 cv=ON0XGyaB c=1 sm=1 tr=0 ts=6a1d5efc cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=Ey8MH3KMaaEGQ3vbTz0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Add support for the QLA29xx generation of Marvell/QLogic
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

Nilesh Javali (29):
  scsi: qla2xxx: Skip image-set-valid attribute for 29xx
  scsi: qla2xxx: Skip unsupported sysfs attributes for 29xx
  scsi: qla2xxx: Enable get_fw_version mailbox for 29xx
  scsi: qla2xxx: Extend execute_fw mailbox to include 29xx
  scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
  scsi: qla2xxx: Enable init_firmware mailbox for 29xx
  scsi: qla2xxx: Enable get_firmware_state for 29xx
  scsi: qla2xxx: Enable serdes_word and get_resource_cnt for 29xx
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

 drivers/scsi/qla2xxx/qla_attr.c   |   26 +-
 drivers/scsi/qla2xxx/qla_bsg.c    |  440 ++++++++--
 drivers/scsi/qla2xxx/qla_bsg.h    |   34 +
 drivers/scsi/qla2xxx/qla_dbg.c    |   31 +-
 drivers/scsi/qla2xxx/qla_def.h    |  157 +++-
 drivers/scsi/qla2xxx/qla_edif.c   |   98 ++-
 drivers/scsi/qla2xxx/qla_fw.h     |  132 ++-
 drivers/scsi/qla2xxx/qla_fw29.h   |  807 +++++++++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h    |   38 +-
 drivers/scsi/qla2xxx/qla_gs.c     |  156 +++-
 drivers/scsi/qla2xxx/qla_init.c   |  660 ++++++++++++++-
 drivers/scsi/qla2xxx/qla_inline.h |  247 +++++-
 drivers/scsi/qla2xxx/qla_iocb.c   | 1255 +++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c    |  671 +++++++++------
 drivers/scsi/qla2xxx/qla_mbx.c    |  461 ++++++++---
 drivers/scsi/qla2xxx/qla_mid.c    |   50 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |  274 +++++--
 drivers/scsi/qla2xxx/qla_nvme.h   |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c     |    2 +-
 drivers/scsi/qla2xxx/qla_os.c     |  264 +++++-
 drivers/scsi/qla2xxx/qla_sup.c    |  694 +++++++++++++++-
 21 files changed, 5587 insertions(+), 914 deletions(-)
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

