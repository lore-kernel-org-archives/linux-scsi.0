Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C602E62D1
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361789; cv=none; b=KrQ51HLwD0dDfc0I7RrzveUnCNmZoii2Jmsu2yTzDxu9gJ1Y0xHmky8atqPah9SzWHTTp7Pn5T+2LNdVAV/1E6vaepsukmVIFNZclJiIW937+q6oTeCloRgVtDg7lUfi/1Tqgr9qz5wTkW62MXOuVh7qNedFSSBmafvmkuDoVwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361789; c=relaxed/simple;
	bh=Qk1l05sCIeTAbuemGCp1Lt7TDmOlTYLnpsfsY1i3x8w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ghHVed/2YCWS4SCjkqJvZQh0QAzwLHWSoKDnIcWvDZei1YRYQBxvRIP++UP3FrGcn3jdC4eLnjvXhNcsBDaBR/5UsyWtFoD2YZDPOe21tnqy8TxNkPGLfODAwFbN5mCUOecMhJ1XSiXxrxzObodpD4V1vpB4RuH60xzQDw5jQRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Anu1+WBS; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Anu1+WBS"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4aCml164110;
	Wed, 10 Dec 2025 02:16:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=hfIvEleHBQKrrr7BdSs7Q/J
	jHSElC5VxkrrJFrZZWh4=; b=Anu1+WBSjVBdtT7AdzJrEvVZO4P5Xij64Jc9Uv8
	Myx5FeCPlk7ofhfIX+5GSfFgBFKKyOs1XJhE/UlkuOpwT+NwihyNuGvLtZ2/+N+b
	jrJ9ABLzKVX2AlXRgOfBfLQrNaZZSuNIpm2aOqclNt0+NC0gBrEBPQTbOEHXW6ow
	vXBIAxkVa5MP7AzR24nOqjFb21V5/MI1MLIwxyHY5A4OQnl6ePzlT+Tyj8kSELwm
	dPLCjEPeubRKr9Duj9U7SnClQ6YqRwwXLLczb9D7oPR86s3HTXL3ekgYmgHf6j7T
	6kbhO7EDhIKK2NOZ4zCuGfVawgZwsWFrJIVhZTQbcJFOBtg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4axwgd167q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:19 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:16:31 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:16:31 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 043123F709D;
	Wed, 10 Dec 2025 02:16:15 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 00/12]  qla2xxx: Misc feature and bug fixes
Date: Wed, 10 Dec 2025 15:45:52 +0530
Message-ID: <20251210101604.431868-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 6OSdn9ZgcUopKBLCCIQVurPUNVtSnilB
X-Proofpoint-GUID: 6OSdn9ZgcUopKBLCCIQVurPUNVtSnilB
X-Authority-Analysis: v=2.4 cv=OIcqHCaB c=1 sm=1 tr=0 ts=69394873 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=YXPW31DPAwPrC3P8G5QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfX0Zg+SiXpQinl
 mGOBy/yTwZDEwqA39sEpjfqYRJJAZNtkGyzg8PG9NejPK04+ZHDok8KkNzquyKMKPR6TJ5XERtS
 B7SRqEbIqKu5ohJnCkEvBKLa6cmnOdkCCRtDzzHFLPUWtIrVWdCRANLD+c6iwaJ5wOP7Kxssj5T
 wkr3SLDYvLEDWIZL3kHJegNE3ZwnBkPrOmKooB4nGAf7sWHY+TjWuQZ6rs5xJbTyVmgISz0fC1T
 7z6UAY38UKz2STjROAvAm4KRkq4y+8bya4TbDc1jXLkLQJsdLExmMgOLBg73rI+2v3SkY4xI4xf
 EQInsj9KAqFAVYo7x7PWJyVYYVSRrrgDP2nR69hjfphTnS8/4fU7yda6ZRm5VAmuS8NFPaaaz9d
 P9sjqj3oVAIFiZQ+G5pW9ErElSzVkQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

Hello Martin,

Please apply the qla2xxx driver load flash FW mailbox support
along with miscellaneous bug fixes to the scsi tree at your
earliest convenience.

v3:
fix warning reported by kernel robot and Dan Carpenter
v2:
fix warning reported by kernel robot

Thanks,
Nilesh

Anil Gurumurthy (5):
  qla2xxx: Delay module unload while fabric scan in progress
  qla2xxx: free sp in error path to fix system crash
  qla2xxx: validate sp before freeing associated memory
  qla2xxx: Query FW again before proceeding with login
  qla2xxx: fix bsg_done causing double free

Himanshu Madhani (1):
  qla2xxx: Add Speed in SFP print information

Manish Rangankar (4):
  qla2xxx: Add support for 64G SFP speed
  qla2xxx: Add load flash firmware mailbox support for 28xxx
  qla2xxx: Validate MCU signature before executing MBC 03h
  qla2xxx: Add bsg interface to support firmware img validation

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.10.100-k

Shreyas Deodhar (1):
  qla2xxx: Allow recovery for tape devices

 drivers/scsi/qla2xxx/qla_bsg.c     | 147 ++++++++++++++++--
 drivers/scsi/qla2xxx/qla_bsg.h     |  12 ++
 drivers/scsi/qla2xxx/qla_def.h     |  30 +++-
 drivers/scsi/qla2xxx/qla_gbl.h     |   5 +
 drivers/scsi/qla2xxx/qla_gs.c      |  41 +++--
 drivers/scsi/qla2xxx/qla_init.c    | 232 +++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c     |  19 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     |  88 +++++++++++
 drivers/scsi/qla2xxx/qla_nx.h      |   1 +
 drivers/scsi/qla2xxx/qla_os.c      |   3 +-
 drivers/scsi/qla2xxx/qla_sup.c     |  29 ++++
 drivers/scsi/qla2xxx/qla_version.h |   8 +-
 12 files changed, 559 insertions(+), 56 deletions(-)


base-commit: e6965188f84a7883e6a0d3448e86b0cf29b24dfc
-- 
2.23.1

