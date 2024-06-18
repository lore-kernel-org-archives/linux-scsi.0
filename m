Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB2F16B749
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 13:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717879; cv=none; b=MO6LwsVAR8bdjYNZD/Kf/gVuJ1UN1s1I3PM9cyNGtViIvQaL07K+wNR3PvKJL3495cCjHmYK6U6bvzpQc5D8rMbo5thb3zOhJ92ayp3tf4qxIO3Xp/dr9vTlKxGjCJv/IcGoDN06kXoBuBG1+Ey7S2h65Hmz871a5wIVUBw0NyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717879; c=relaxed/simple;
	bh=g8/VWhlPC1XNYheBKKPKXMciHtMhdmnkLO7yoylj4So=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mR4ry4dbaKGabuxMRTNDWkve0MUWTXIUq/wSQPOvkquf3ONB67p0XS5TuqsjPM3MPqgVx07ATLLjQb1djub9eGc2ycXq6Nwvgmeat5vznhnB0H1YIyc5IQO92W9rUdPq2Soycg+OFgLY+kMQxgZHLddKiTdffmXeaE7b/k0qs5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Y+AyG2tZ; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Y+AyG2tZ"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45IBiHKJ016978;
	Tue, 18 Jun 2024 06:37:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=T+Z6v/zVNwG4R37LX48co3Y
	a/1DWPIjMYRtmE8192Bw=; b=Y+AyG2tZI8dWOI2+wpWdhMRSgbi0/y6kbmEF6lQ
	83OxBjVySxPnrBzNouvTZ6ZcOm33YjKgbmTrLDrPlVMY8YP/jxd/oHk3JKyROv4x
	AJE+2E7ihdjW8VyZtoUFGeQFDeH10BDVp8zWfxQ+DRcbdDKxF35XhfgObnwhwxkt
	J9K6eH+XkjtlHcFMUmkE1kZJYVQS0/a0/kA0cUh7OBnEb+hnWTVWxKJgISAsnFRl
	hl/K/0F/k2/JLetFvXlcCzRGY2dioxjWLFZDm9syM7eLOFIT/mYKCmdd4KdHSuQW
	ejFzEXAIWvI2LpY1FlA9T5QpJ/k4W5q13Got1h5fG6MD7UA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3yu0nwt3m4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 06:37:54 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 18 Jun 2024 06:37:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 18 Jun 2024 06:37:53 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id CEB7E3F706D;
	Tue, 18 Jun 2024 06:37:50 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 00/11] qla2xxx misc. bug fixes
Date: Tue, 18 Jun 2024 19:07:28 +0530
Message-ID: <20240618133739.35456-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: k5W7aXYVWXdjN6QFNSzG3vbKZr8fNsd5
X-Proofpoint-ORIG-GUID: k5W7aXYVWXdjN6QFNSzG3vbKZr8fNsd5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01

Martin,

Please apply the qla2xxx driver miscellaneous bug fixes
to the scsi tree at your earliest convenience.

Thanks,
Nilesh

Manish Rangankar (1):
  qla2xxx: During vport delete send async logout explicitly

Nilesh Javali (2):
  qla2xxx: validate nvme_local_port correctly
  qla2xxx: Update version to 10.02.09.300-k

Quinn Tran (4):
  qla2xxx: unable to act on RSCN for port online
  qla2xxx: Fix flash read failure
  qla2xxx: Reduce fabric scan duplicate code
  qla2xxx: Use QP lock to search for bsg

Saurav Kashyap (1):
  qla2xxx: Return ENOBUFS if sg_cnt is more than one for ELS cmds

Shreyas Deodhar (3):
  qla2xxx: Fix for possible memory corruption
  qla2xxx: complete command early within lock
  qla2xxx: Fix optrom version displayed in FDMI

 drivers/scsi/qla2xxx/qla_bsg.c     |  98 +++---
 drivers/scsi/qla2xxx/qla_def.h     |  17 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   6 +-
 drivers/scsi/qla2xxx/qla_gs.c      | 467 +++++++++++++----------------
 drivers/scsi/qla2xxx/qla_init.c    |  92 ++++--
 drivers/scsi/qla2xxx/qla_inline.h  |  18 ++
 drivers/scsi/qla2xxx/qla_mid.c     |   2 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |   5 +-
 drivers/scsi/qla2xxx/qla_os.c      |  19 +-
 drivers/scsi/qla2xxx/qla_sup.c     | 100 ++++--
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 11 files changed, 458 insertions(+), 370 deletions(-)


base-commit: e8a1d87b7983b461d1d625e2973cdaadc0bd8ff5
-- 
2.23.1

