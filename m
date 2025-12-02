Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8D42FD684
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 06:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764655681; cv=none; b=Ez8JG9WR94Qrch9k2CQDS8RODaj5HdSNPOCMsUtA9nnwgw101sWn9rfft4BEurqUgvyg8HKtB6k9ReZCr9zfK0d39TZEmtJJdk+rEWP0mevTYpO2G98GSPYMg7kgapzqggJO4DkNBRLuNpm12WOiE98m3SsCbZGhSrzdbC94x7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764655681; c=relaxed/simple;
	bh=QjpQWpqmTCwudw2fd3+COi1Q386/Cfq71QINXpwTOG0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c2zG5LtoAVoZfuUQPW6GQIG8hzRj2a5gJ+4ZtSTAn6eqzwaszLjBw1GytHmSViCJ3JGUaIjojRvi8GjSwRxu5ZAmGsiGBD0NCWubZM3JveTPrgy+d1KC6wX+ArJSphf5DTbAf13NhY+ru2XEPeigFNcnayHResaT+S5HmFSOJiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=V82lRJDv; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="V82lRJDv"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1NSstm2366051;
	Mon, 1 Dec 2025 22:07:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=rcsvZ9mXbPn21/13qdPySOn
	EMBRqXvb24UqdH32IJ9g=; b=V82lRJDvgoWovHZ4DOF/aXgq/vopOr1DdSwRWu8
	87zNqMvZFEUReqq/HkDgxqMAMUvUl7Bm+JGnA6EwwIAjsPu0BnTQjrOzGaBzy1fT
	WzG/DOB4vo2uZVncuRYb8DVDoUpM8CMUTUFkPzE7ZFyBjPeeeStB+2nCkBEUH5hQ
	nncpIVgFAcT3RfBvZ4i3IYKpyhhYXyhqY9NybcNrfjLySzMS2Nvqpc+LWNJKA5H2
	9LJhWlXEG6H1PoIrN4dHLUse/VR8D+IKGz024Uxjup+JzIKkmLGy2IZ5YsTkxCiW
	iccXWfJ3GpZxl84VnIQub5hIL6y9mJUDayJwSu5NO2i0i+w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4asmqh8njf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 22:07:57 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 22:08:09 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 22:08:09 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 8F8755B693D;
	Mon,  1 Dec 2025 21:44:59 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 00/12] qla2xxx: Misc feature and bug fixes
Date: Tue, 2 Dec 2025 11:14:32 +0530
Message-ID: <20251202054444.1711778-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=HMnO14tv c=1 sm=1 tr=0 ts=692e823d cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=rKoHQDPYLh2N2Zu_xhUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 4KUZWFaxyjeGj9Dz7ifECLe71hxv0lkm
X-Proofpoint-GUID: 4KUZWFaxyjeGj9Dz7ifECLe71hxv0lkm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0NiBTYWx0ZWRfX6OIWN7YND0Uh
 b/Ccwy0z/ATEwne4dp4zskxFI/ToBVo8sVjBhipbfbj8LUm/YrayJ8cyGAsWHxmf5ly9fLRVvbS
 Y7RJHXsvjEodjYozGjVVtj2P6AZnkc7yfeA5LMNFqj6N8+hFbeFMYbSqcGKBhr0uFmw2dwNx7wL
 83FujrbTo7EwkV2ybJ52I8U3aKQ3JF4a92H4JjBj2n/ng1kQrPE+EkAR1UpCHk9uZg0FcsvsAgt
 JvbkWy9WYl5erz1mx7K7W2RUAPkwP4FIiYWQwPEZaPdii8wEC3i39ppAylE5srqfJN8UBAxu/JK
 YfA9LCqAkF2XKp0/o5RdJDLEkZOTou+po7Xhzyth6xDNYBtr9sNMS8Fed01861LAJYvgAF3cO6h
 slaYmWFIGu5xzLNBy+ZbKqhzafcSMA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

Hello Martin,

Please apply the qla2xxx driver load flash FW mailbox support
along with miscellaneous bug fixes to the scsi tree at your
earliest convenience.

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
 drivers/scsi/qla2xxx/qla_os.c      |   5 +-
 drivers/scsi/qla2xxx/qla_sup.c     |  29 ++++
 drivers/scsi/qla2xxx/qla_version.h |   8 +-
 12 files changed, 560 insertions(+), 57 deletions(-)


base-commit: e6965188f84a7883e6a0d3448e86b0cf29b24dfc
-- 
2.23.1

