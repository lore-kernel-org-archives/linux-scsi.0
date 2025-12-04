Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D56C286417
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 15:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764861490; cv=none; b=iAO8+r95tTKnmjDZsnqLWRNK2msPrHaNrBkU2OcnHdJELoqGiV0uiwixieA4mXfO0IBJjtEvCUMCKj1JmaVr/Jbwx25T0utPi/JreNoftTMcdsiX+hsPndZGo3ZbBJhI2VJBSgaMmy1x8eFzwLJaCzeqOlA3oc3g+N0W/Yty3vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764861490; c=relaxed/simple;
	bh=7aUms6GZZ/S5anT3YxHZSRsIdF6Y7TnKK9+gT3XiP4Y=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=e29fUPxRmyWEOvqecCxgNoPZ3vt6QtNK4dX5C7uLe4x4yWddxjRR/ZVrRwMbDqmNAq1ZmmLX0Jbm/gmwgHbyTR94j52l8eR/ocYjyaB4ADeytVtNoyCKgKjffU96cf7cahI2xvN+yPseNB7M/YGVO9NFYzn0h5c9vqzSe5+GM5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QFS3RRoB; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QFS3RRoB"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B4ERClM1544799;
	Thu, 4 Dec 2025 07:17:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=qvobr4R2W7ZImlcEX1FYmu0
	wTBJs+REfNmRmo7+wFSE=; b=QFS3RRoB5h1mJriZC0xegMyUpJd7muIA8tvDcl3
	1SFhxF/WHqpKo4Vj7okb8bZ4NEebjLcSUBJ5V7aoOJBeAbI+9RgvAwZ8rkO20tp9
	60YhCse9uq7zeL4b0wrihpsQb449zY0BC9zivO+18regLUYhul/GFaAa2vN/4GO3
	FRZKOjvdaZLmNgpRANzgqL//ceGFn9XnRwt+pc0x+AZ3DjRE5Eny/SVUXVYNE0ar
	VTVWQ9nbN/K/JEeGtjcpiJ0kxKxJbn41PI2I/gbvKdxeaXZrCsW94uSSxvVYPGRt
	aKivkc2gBHBWBQ0+oI27mHm7YRRz2myLGp16/hmVMyTAUvw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4auc2ur4b3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Dec 2025 07:17:58 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 4 Dec 2025 07:18:11 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 4 Dec 2025 07:18:11 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 09DB33F7090;
	Thu,  4 Dec 2025 07:17:55 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 00/12] qla2xxx: Misc feature and bug fixes
Date: Thu, 4 Dec 2025 20:47:39 +0530
Message-ID: <20251204151751.2321801-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=A4Fh/qWG c=1 sm=1 tr=0 ts=6931a626 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=rKoHQDPYLh2N2Zu_xhUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 8aJ3JHQua7DSQABUOkQoS2Ti1VeEcL7v
X-Proofpoint-ORIG-GUID: 8aJ3JHQua7DSQABUOkQoS2Ti1VeEcL7v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDEyMyBTYWx0ZWRfX4Tbt4Kl6tGj2
 Fw2xfQBpobEa9Bfs1wNri9446ReoFH/C7gmdtv3BY4VI9DErYj8pfOQtR2FapYdHO8GFB46J4YP
 j0DJEl1xIawNApX3JE/EF7LDXLpxIxJMlzodiQ+XxhYSJHQZGXxVEnrtzz8MpWBWkfT2RFRwxbr
 pAMDVkbIyV0Oz1i9yFXBdILvvpb7KIx61a1wF6907yMGrB/6ez/FyFXa2JsJHbA1NwhvxA1Aoki
 IdhvpCxsCmDgDbI45in+huZyQPAZ3NpWtu6e64ZRrrKCh8U2qFPRyEppr451kck0O/BnDP+ozLF
 UdJ/kirg7TR1uXxszM7//zg2JcGMVMyCKdukCIeAeMNN03fG0JC7AMUJL/NrKP4On9GacsdTvd9
 p3aMKrqaHtnSVbnK4dCBWv39HOmerA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_03,2025-12-04_01,2025-10-01_01

Hello Martin,

Please apply the qla2xxx driver load flash FW mailbox support
along with miscellaneous bug fixes to the scsi tree at your
earliest convenience.

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
 drivers/scsi/qla2xxx/qla_os.c      |   5 +-
 drivers/scsi/qla2xxx/qla_sup.c     |  29 ++++
 drivers/scsi/qla2xxx/qla_version.h |   8 +-
 12 files changed, 560 insertions(+), 57 deletions(-)


base-commit: e6965188f84a7883e6a0d3448e86b0cf29b24dfc
-- 
2.23.1

