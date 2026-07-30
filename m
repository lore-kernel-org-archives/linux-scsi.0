Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C8E434404
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427152; cv=none; b=oXCuyJADO8jQwcGwG1hrvulEDF7EtPY0eJFRf2AWlHGJHqqgijje/SAi775HwaoPJlXNt0THXk7DIuz4r0NFSLwxM7Z52DhRCrfdyaD1AoJBR/vkPyn99aJbZk8M9+RpPdS9g4bEPxQEKBFCeU86fhz+23pH+CoZNGIaxlyOWpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427152; c=relaxed/simple;
	bh=wWUnNsYBbNX8JsExuuzOW4F4oqnAOX2ZV79bRYUGfjs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=krnoz7lyujIeu0hk4qRTksCzra2OAfCBCPBXX5gBk3O6PMSmvtgl2fF+812NeMSbndzHUQMoxOPelhbFbY+Gd+JaJCzMCIX4aBObON2N/+kdqxa8m9b8ivZcfSK365xDGWMFYZW3ntkfm9XXKBcDyj6xUoDnrcS8ngEIHjjy5lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SuZT/O8i; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SuZT/O8i"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWLPB1321669;
	Thu, 30 Jul 2026 08:59:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=DeH+5FlOaPtbZAkTbW/sFww
	Q5gCeE7NSilenU3bX2VQ=; b=SuZT/O8iwqtelTo8Z6uSHWPzFHwrd/WkYh30qzr
	iYOcUb4/CAPB6lE7hHb3d0VylQrPlu7PnT72XU6GkM60h/bGzKzZRjvn3rkoj2Yw
	bdS/H3wpxxYPatEsAvo3p1bLg7DfBYexCFcAltvWWqV19FRtxzv0WHCLtk+vYPRs
	zZxt6j9bPGZ0MHwiTUeHIUcZamLvzOJHiuJMllE3KVo9d7r07gALnehW49NC/BDs
	ayer5+/g/o1dvsBscESSme2jOtez/cqJtwGIYyQCaZvJzg6x+1RHCkDmF+7DizC2
	k9dDNChZ/aztIj0sWu6i05XeyKSlS2JtPOKyyoisNbB0Nfw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:06 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:04 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 96F503F704A;
	Thu, 30 Jul 2026 08:59:02 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 00/33] scsi: qla2xxx: Bug fixes and hardening
Date: Thu, 30 Jul 2026 21:28:05 +0530
Message-ID: <20260730155838.2119230-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: PaU09WXpjXMYGEdelghCL5dtIvgtdgFM
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX/Clf9b4kAo7T
 I8vmRFqxrwdItCW2+lClqf4BukaZIfJKuA6GNsHJq6av1eReSdied2KP5k7mL/sVZe/UisJbXvk
 ImDNicMgIJU2coqcMKs3K7u3YDgDzaM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX4MRCcvm7qKYi
 DSOnZdnH+hAnjzz6p3fDIMpQ/EROmUQcux5QOpj0U3z0fCo/iuTfQPjbxo1bNsOLvHDmw3tAy5A
 9+Xtsqi0fgCfhVw29j/giF9mVuB/Sr3JLmDY/zIAC7gLnCzmwKQvO6yXe6t8RixmKdawHBLgAhU
 /ypy3Vgmg3pBbiTL19mAsb8krx16t7Lfbzprz9dI21eMTnffmAF2C0UqS4MwyIYI/EhKeAirj/n
 Xc+nyD+bilEAZ282JPmhSD7f2FfEbG49JoqUvo9l/75zpo4W69bbuIOnM1msyRirfVUNweNrcQl
 193AF8CQlJ8UfgzoGslj9Taw6SW5fcCEqTxaHinJ8cQYaRUnDiAYJBD2pRBPRkLK5m8rzwuYnh7
 ZI16gb+6gp4570qZEhYXM1xhO8stLt76pyAGkMx5Bg3KKiiXdkJrqtB+So6MxddmXvq2vooYsOV
 JGgdVl9GIoZX0540Qkw==
X-Proofpoint-ORIG-GUID: PaU09WXpjXMYGEdelghCL5dtIvgtdgFM
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b74ca cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=myL6R3-SexkHHt4d_jkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

This series collects bug fixes, hardening, and small cleanups for the
qla2xxx driver that are independent of the QLA29xx adapter enablement.
Most were uncovered by static analysis and fuzzing of the driver's
interrupt, mailbox, NVMe, and BSG paths; 30 of the 33 patches carry a
Fixes: tag and are marked for stable.

The series is organised as follows:

Queue pairs, MSI-X, and interrupt setup/teardown
  Clamp MSI-X derived queue counts to avoid truncation, fix a
  use-after-free of qpair work on queue teardown, and quiesce the
  response IRQ before freeing the request queue.

Firmware dump, FCE trace, and flash/version paths
  Improve firmware dump data capture, serialize the flash version read in
  the reset handler, clarify the MPI optrom address/length units, fix FCE
  trace enable parsing in debugfs, and fix a use-after-free of the FCE
  trace during a firmware dump.

Probe and mailbox paths
  Fix the cs84xx use-after-free on host teardown, don't query firmware
  state while the chip is down, zero the mailbox struct in
  qla2x00_get_firmware_state(), and null out freed pointers in the
  qla2x00_mem_alloc() error path.

Response/status IOCB path
  Use memset_io() to clear the QLAFX00 request ring slot, fix response
  queue over-consumption in __qla_consume_iocb(), fix a soft lockup in
  the polling continuation IOCB signature, bound rsp_info_len to avoid an
  out-of-bounds sense-data read, avoid a req_q_map double-read in
  qla2x00_error_entry(), and reject non-SCSI SRBs on the status IOCB fast
  path.

NPIV and report-ID acquisition
  Clamp max_npiv_vports to the VP_CTRL bitmap capacity, avoid a double
  completion on async IOCB timeout, and correct vport
  handling in report ID acquisition (skip a vport under deletion, drop
  the vport reference under lock, and hold vport_slock for the host map
  update).

NVMe LS and abort handling
  Fix an abort reference leak on repeated abort, skip the NVMe LS reject
  IOCB when firmware is not started, unlink the unsolicited context
  before freeing on the LS reject error path, and serialize the
  unsolicited context list with a per-fcport lock.

BSG passthrough hardening
  Use a coherent DMA buffer for D_Port diagnostics, zero-init bsg stack
  buffers and the SFP DMA buffer to avoid information leaks, validate the
  BSG request_len before reading vendor_cmd[], and bound i2c->length in
  the I2C bsg handlers.

The final patch bumps the driver version to 12.00.00.2607b2.

The series applies on top of the qla2xxx QLA29xx series (v6, 56 patches)
on Linux 7.2-rc1.

Thanks,
Nilesh

Nilesh Javali (32):
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
  scsi: qla2xxx: Update version to 12.00.00.2607b2

Quinn Tran (1):
  scsi: qla2xxx: Improve firmware dump data capture

 drivers/scsi/qla2xxx/qla_attr.c    |   6 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |  89 ++++++++++---
 drivers/scsi/qla2xxx/qla_dbg.c     |   6 +-
 drivers/scsi/qla2xxx/qla_def.h     |   5 +
 drivers/scsi/qla2xxx/qla_dfs.c     |   4 +-
 drivers/scsi/qla2xxx/qla_fw.h      |   4 +
 drivers/scsi/qla2xxx/qla_init.c    | 195 ++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_inline.h  |  13 ++
 drivers/scsi/qla2xxx/qla_iocb.c    |   4 +-
 drivers/scsi/qla2xxx/qla_isr.c     |  72 ++++++++---
 drivers/scsi/qla2xxx/qla_mbx.c     |  23 ++--
 drivers/scsi/qla2xxx/qla_mid.c     |   6 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |  35 ++++--
 drivers/scsi/qla2xxx/qla_os.c      |  37 ++++--
 drivers/scsi/qla2xxx/qla_sup.c     |   5 +-
 drivers/scsi/qla2xxx/qla_tmpl.c    |  48 +++++--
 drivers/scsi/qla2xxx/qla_version.h |   2 +-
 17 files changed, 415 insertions(+), 139 deletions(-)


base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
prerequisite-patch-id: 66f1e857c5c541b44c44c84f0435f5ae694cd352
prerequisite-patch-id: a10016425fce97adb39b7c9f4e16957eb9fa2bbf
prerequisite-patch-id: 5638c8253ef25fdbdb693f187ebf4aca164a53bb
prerequisite-patch-id: 5fd0239f192c5a70b72fd792f963b35279586bf3
prerequisite-patch-id: d670db315c2f7616da067a9c598c026d3d02a72c
prerequisite-patch-id: 089e6ca8556eff71f73e4b0b3b38e227a64e7a8a
prerequisite-patch-id: d9fd72003f9c0f97a0a767352f85ff437423c0dd
prerequisite-patch-id: b537af431e09ba282ddbbab7de129a4df96462bf
prerequisite-patch-id: ef008cebf8c927f411895f21a93c9069b333b652
prerequisite-patch-id: d6ff17f825e353b2caea629baee1cbc58e16e5e7
prerequisite-patch-id: d2038244d4a8cce08f259193041b967cb4ef4ca6
prerequisite-patch-id: 1bf075ed572822ab7579ad2b7c4aab4c032fcb17
prerequisite-patch-id: 2a8b1b21a31bf85364cd7073e536d3020fc5c4ce
prerequisite-patch-id: 16f0e4175b832f16429f5de87a066de70895f779
prerequisite-patch-id: ad1e5c20ae62c396770122eb009a97b412c08e84
prerequisite-patch-id: 8dc8524dd7e3da7c97f4522c51ed478b79bd0a60
prerequisite-patch-id: 291dfd641efce49ca7ab983c5b8c64febfe307ca
prerequisite-patch-id: 064bf1f6e6da602f8356a7ee35b481a275890d96
prerequisite-patch-id: af35378d8f9b58e3ffa080ac27357ce2a4b2aeec
prerequisite-patch-id: 8623dc9b2d9ab9d07ced7fa9f4c5c649e3f036c8
prerequisite-patch-id: 52ed04f7a9c3cac327fa0235fab899335a128363
prerequisite-patch-id: ef93f470d241eaa9e86f4db1421b99687d22f5e6
prerequisite-patch-id: 3a19f5ba3798c0bbc7047070a45e7a62877319b4
prerequisite-patch-id: 6da0949a6775445497bbace21164ae15041bc4b6
prerequisite-patch-id: 0b301f1d06ca9975230e435c613d2c4f7f78d02e
prerequisite-patch-id: 2ac2f4c5f34d759a701ffea19e2f69a68ef83351
prerequisite-patch-id: 2966bec1fb19ff8d36bcd699d48e8cb3ed2e4e21
prerequisite-patch-id: 75ace74de11917bb5a11b1c42563ddd9db594f08
prerequisite-patch-id: f12a610ede731a7d35a5ea0f860f78f833b2c6b0
prerequisite-patch-id: 96ccc66d0453f29a69b2244173a7561c661919f6
prerequisite-patch-id: 5d204a6aabec64593b4e3bd79d741d550a03b8cf
prerequisite-patch-id: 06e52cc37105e4151f0a56ea2b4a9f5cfe3e4c7b
prerequisite-patch-id: c0d0d2f057ecdd0312f680f5b75b11edf1034a27
prerequisite-patch-id: 7573db59b84ad4e1a1fd9961cff0ed62f2420383
prerequisite-patch-id: 08725130a6f128f6619eca4e326b7f79b2c001a6
prerequisite-patch-id: 268c107f1e71cc790154939fe98dee493a74a6f7
prerequisite-patch-id: e071b465300f26cf0fa73d1c5ea5714a410b8698
prerequisite-patch-id: d73b83500639494fce110c269fd2a4586a79ef59
prerequisite-patch-id: 30a4e9270bab0316d0951ad49516b8ee27866c3f
prerequisite-patch-id: 17b5595c786875e0baafad2d72efb780698ba7fd
prerequisite-patch-id: f532ad2a90127ff323d1042ffe627f96d50ba024
prerequisite-patch-id: 56a601420cbe264384b37abdff28438c64055769
prerequisite-patch-id: 7b8df4b25162742447d879cbc70c514ed07a59d1
prerequisite-patch-id: eb9c50d47882057aac8ebbdf4db5cd4708881c37
prerequisite-patch-id: b13cb77c2941d6a914e0590f5334197a59cc8efb
prerequisite-patch-id: f29d36b73d29cafab251da268bfa24d2619db7c4
prerequisite-patch-id: 5c835f539357a54f92321a8f8bc3e0231b0cf875
prerequisite-patch-id: 54d1b521971e052e15a8adf7d804d2de725afc4a
prerequisite-patch-id: bdbf9290d186914aab1f1995cb1d517ebca803c4
prerequisite-patch-id: 6d3c080e7078f612b28319f0c4c5e432bea99262
prerequisite-patch-id: ccdc3ed2515919d51f497d2933d002fa78923e30
prerequisite-patch-id: 853f939f5dfd7d3a82e7a673ba6a8a231b6ba84a
prerequisite-patch-id: c04850b87d8122792e919840bdafb46a7baa8998
prerequisite-patch-id: 8e3485fdc5e43c883f080315e875fc525c053082
prerequisite-patch-id: 72833e5cfa0e8b92edabb760243b6c5eb119e8e4
prerequisite-patch-id: dcaccf685f03d118656accaae9811df505ab7b4a
-- 
2.47.3

