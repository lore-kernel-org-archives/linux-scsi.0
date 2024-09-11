Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CA51BBBFE
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 20:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085579; cv=none; b=b2RzvRb9OFZo0eBc4uoH7PEcDnLuYtU4Le6fWrcWICJilURi2GULcgjtiie9x2fFBlcm/zsmdsDq0iMbenx6K2f3TAJGpd9/Xfy0Lg8Ze1mxfq60fc4L8qNhwj2ROGA66xmBSyPAorcquxba3Eb4TYtB+TBL+wU+peF83on/Tg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085579; c=relaxed/simple;
	bh=AxrZkBM4T15MxKMDxb9xeBAgee7VFlRxEGLQfC7Nu+w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GhAWCF9W3/SEK2JQKlVsL0uDpI1v1OcDyEeX/CoFnNxoCcx6CogB2tXxlY3m6Psxb4ul7YTcLNdz8xe4IWgbDUQzXeEC7yuloMJsMfSoSYUi+uPO2mdbucpdgjRKPNOESTVRWNYoNWQQ33ws9ZlPZT3jr+IzeGEMS+ovsDEYkvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=dwO5eQPM; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="dwO5eQPM"
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48BHjGDv027790
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=s2048-2021-q4; bh=LvD
	NngJGsWnatCyWW6vNi4OaEo2CnYyawxAlUHXUK4s=; b=dwO5eQPMAfqEQrJAdFF
	BQlrSXYCdox1DnS1KkpEbEQBR5EeLwwUDKkMnddw9N4Zof64jlTMsxaCUKbZIoj1
	grEUaZLsN49oyz+5IaKqcD6NOPmGFcCsKlS2RiGCoivMqHrd6D3pOx9H6QHfI5ut
	IQA+lHImKmoIkzO1fp6edRzx/nZ1thLlo6rYmT+yRcwAij5SNE/O0vwsSESc3uPl
	7PsrJSs9Y3JvK+nYZDFGfTe39USN9P4DsN6r3If6ouRGCVTjLl7MvWmf4wVICXDq
	swKzFfjiKw0stqYtRQ9F2ZHKC0Pf3dSQgg9Q7yRzVHgEf87GgwjRotdWh9Q5/CYL
	NOQ==
Received: from maileast.thefacebook.com ([163.114.130.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41k61wn0k0-8
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 13:12:57 -0700 (PDT)
Received: from twshared18321.17.frc2.facebook.com (2620:10d:c0a8:1c::1b) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Wed, 11 Sep 2024 20:12:56 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id B204112E5EDA2; Wed, 11 Sep 2024 13:12:41 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>, <sagi@grimberg.me>
CC: Keith Busch <kbusch@kernel.org>
Subject: [PATCHv4 00/10] block integrity merging and counting
Date: Wed, 11 Sep 2024 13:12:30 -0700
Message-ID: <20240911201240.3982856-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4EjS84f8CG7b9CV31iDyTuHNDyRqSvrJ
X-Proofpoint-GUID: 4EjS84f8CG7b9CV31iDyTuHNDyRqSvrJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-11_01,2024-09-09_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

Some fixes and cleanups to counting integrity segments when metadata is
used. This addresses merging issues when integrity data is present.

Changes from v3:

  Unconditionally define nr_integrity_segments. (Christoph)

  Dropped the "simplify" patches and the queue limits checks; they are
  not correct under some conditions. (Christoph)

  Fix a commit message typo. (Anuj)

  Reordered the driver patches to appear after the integrity segment
  count is accurate.

  Added a patch (5/9) that accounts for user mapped integrity segments.

  Added reviews.

Keith Busch (10):
  blk-mq: unconditional nr_integrity_segments
  blk-mq: set the nr_integrity_segments from bio
  blk-integrity: properly account for segments
  blk-integrity: consider entire bio list for merging
  block: provide a request helper for user integrity segments
  block: provide helper for nr_integrity_segments
  scsi: use request helper to get integrity segments
  nvme-rdma: use request helper to get integrity segments
  block: unexport blk_rq_count_integrity_sg
  blk-integrity: improved sg segment mapping

 block/bio-integrity.c         |  1 -
 block/blk-integrity.c         | 36 ++++++++++++++++++++++++-----------
 block/blk-merge.c             |  4 ++++
 block/blk-mq.c                |  5 +++--
 drivers/nvme/host/ioctl.c     |  6 ++----
 drivers/nvme/host/rdma.c      |  6 +++---
 drivers/scsi/scsi_lib.c       | 12 +++---------
 include/linux/blk-integrity.h | 13 +++++++++----
 include/linux/blk-mq.h        |  8 +++++---
 9 files changed, 54 insertions(+), 37 deletions(-)

--=20
2.43.5

