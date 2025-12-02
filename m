Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D382FF17F
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 06:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764655457; cv=none; b=n1y0me/iuSYkXuyYh9KZY8XnFNXd+DQsURp+7Z8iraaMQaLEbQcsBDjRuJKqvS7j+q+5PlXwMYIikqkGUA4YLP80VtNc/ley5hAbWZWGMI5RtCF6toSk7q4uc1LiddDcWYloT1H/jutqCPl4h2B0/1j2fsr1ghBtil7nJoBX4x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764655457; c=relaxed/simple;
	bh=QjpQWpqmTCwudw2fd3+COi1Q386/Cfq71QINXpwTOG0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sQShsa6yFT5a63XV15d42MZxm9lcPrjiA5P+1LBIzaMTlUPOtr0sjEVsVmnVCjZ9WWEeQ7Ge7iH0mQXKbGrP7/Nn+kEuk88BWeW2mkQr4BCgwr05XTwL4oIbkvyk6c6ahTMruVMc9nio45PbykNpagX2TVd9/Gq0c4+3bKlloLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ZeBU75rn; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZeBU75rn"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1NaDNV857994;
	Mon, 1 Dec 2025 22:04:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=rcsvZ9mXbPn21/13qdPySOn
	EMBRqXvb24UqdH32IJ9g=; b=ZeBU75rn2TKY+q1HKL88N7XhfMMtO/HT39OmQNy
	avOx6n1kAowQ+SC6KVsY4E4MrMcFsuzOwBDucuE4kLuCwvfVLs2IuqNZR8Wv9Zqe
	QYP9OLCJkDlduZc23WVfQcKJ1qnRVjPliU81vKKdfhNccDJ11n9xCRCK+MmEsDix
	hTbnJnt6G8k/CD8LERIK8LWfA7P8Z1yYF3vLSOu5ta5a6hJAN8yUv2/RZHd3dS0d
	l5jxi52hlixlMffOj6AOHDRMZUWNrTtAZxcFDcAJYekG+kxNihbYzYFOQTeOy7pC
	57r4ovQalt6fvEB4G4tD1rPnRxjLdpzRcxxBqc182jOLpCw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4asmu4gmgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 22:04:11 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 22:04:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 22:04:23 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 14C3C5B6975;
	Mon,  1 Dec 2025 22:04:07 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 00/12] qla2xxx: Misc feature and bug fixes
Date: Tue, 2 Dec 2025 11:33:55 +0530
Message-ID: <20251202060355.1713302-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: J9czMY4jU39vDpK6pl2Nz0G-C4QhVrLz
X-Authority-Analysis: v=2.4 cv=NPzYOk6g c=1 sm=1 tr=0 ts=692e815b cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=rKoHQDPYLh2N2Zu_xhUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0NiBTYWx0ZWRfX3aB8DysiIjxX
 btuAzGMXR7zVNULKFMG2GL6OPkZlLcLvDdlvds3s72v157yMgBolIN4Eu0MtmQjT1gBfvQbBED+
 LxCjHByeUJCUMeScq6m1Ie3fakpZxkv9KWMfYCfb3BL89efwAmkCvAr0sZzFYAimzGlvOxLGP6P
 W2G5ZILmMz0kTt+qF+oE/9L3ErBSlVXp8mD5h7K5Rj5Lvt3VoPjJNJRJuVaxYGgGdz+0gBlcgR8
 SN6/RdJXJ9IlkIiBLba8Kf+hHNf+qIxeyQUzQZvFWmqQ5uRxgj3a1hmwt7AkLW49VrG3gDFZUDq
 r9zmBwFcXuNbYxMd69IBJUUHWRYgLJWCd68nCyfnfqAaECOeAAqu72R2paKcRnf3EerXouch2AZ
 2L1UJrwnWhbZo8nFaxco/Vf6bxO/dg==
X-Proofpoint-GUID: J9czMY4jU39vDpK6pl2Nz0G-C4QhVrLz
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

