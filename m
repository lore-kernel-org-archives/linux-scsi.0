Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853C213212A
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 18:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726252158; cv=none; b=d4P+12f+LA295KfwWMSSKchGZ+l0Adw5U5YhJLdICMkQFLgaz6QFbob9vpC4T0Hr6pNObPo30DuFSH4HZiFZkoeiZrsNz9B0OWBa7tHEFQTJw6ufRogcmFjmHz/9/7rHSB8deEFtN+1xYOMk2tJkZG94XBBHMn1adOitIsLMfww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726252158; c=relaxed/simple;
	bh=eIXOszwJIaTt2ApvNGA+AQrdpcUa4ECXIJNPnsA5dwk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j/4StP88O0V/KmqXaxEv4RbVlDgSU0xu0mJiavBKVfS+sYeRZ9XO/K+T7VrFKdt6Saq7rm/bha7ZMvr/FAWjtwsI2JkZ+QVOjuvbh1IfSMtPmWs4zcDhhkHrdhELM3n0g2bRi48x9ujAuZdsxifH0jFlVCJkOr1v6ZhygD7OWCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=R7owH2/Y; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="R7owH2/Y"
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DI2LlX003051
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=s2048-2021-q4; bh=/V+
	SQCa2TzW8MFzEkXVSlXsp7/37DTm/d7GB3FIFO3s=; b=R7owH2/YW1ioGYQXpUm
	E6nWvgKbwyT+UR5+hMdzVUr1dXh/hr402fZifZUtcggoO0KKgd0howyrhb5wl5XR
	GTq3fl5bWp9Hx0kQMsEA3n+CBvRQPe9pbzGXoNacgvP568JC1Twl6D6CgA19ig9d
	nUM1yz0RrqcsxTTKEuPmp8zAIiJBVp/hyWkWSrMbDgNSwBHSVj5t7hlP+cCiS5mD
	RycnwdMV6NhUuZpM4l++3mtRSJsNw3qXU85Ut/FAChqsYPcI3lx57PQ2D3ZfRecn
	ndcMNZkEoiu1ptieZuyoNt3keAKw3l503sldbL+R6n2ED5fi3xzPGzK0Iy0dkVzx
	pIA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 41kha4qjc4-14
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:29:16 -0700 (PDT)
Received: from twshared32638.07.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Fri, 13 Sep 2024 18:29:10 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 518A912F91041; Fri, 13 Sep 2024 11:29:03 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <axboe@kernel.dk>, <hch@lst.de>, <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>
CC: <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv5 0/9] block integrity merging and counting
Date: Fri, 13 Sep 2024 11:28:45 -0700
Message-ID: <20240913182854.2445457-1-kbusch@meta.com>
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
X-Proofpoint-GUID: tyOcRlalM58RjAVqhzHxNHdv1Bt6oaoh
X-Proofpoint-ORIG-GUID: tyOcRlalM58RjAVqhzHxNHdv1Bt6oaoh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01

From: Keith Busch <kbusch@kernel.org>

Some fixes and cleanups to counting integrity segments when metadata is
used. This addresses merging issues when integrity data is present.

Changes from v3:

  Dropped the trivial nr_integerity_segments helper

  Fixed sg mapping sanity check

  Added reviews

  Fixed commit log typos

Keith Busch (9):
  blk-mq: unconditional nr_integrity_segments
  blk-mq: set the nr_integrity_segments from bio
  blk-integrity: properly account for segments
  blk-integrity: consider entire bio list for merging
  block: provide a request helper for user integrity segments
  scsi: use request to get integrity segments
  nvme-rdma: use request to get integrity segments
  block: unexport blk_rq_count_integrity_sg
  blk-integrity: improved sg segment mapping

 block/bio-integrity.c         |  1 -
 block/blk-integrity.c         | 36 ++++++++++++++++++++++++-----------
 block/blk-merge.c             |  4 ++++
 block/blk-mq.c                |  5 +++--
 drivers/nvme/host/ioctl.c     |  6 ++----
 drivers/nvme/host/rdma.c      |  6 +++---
 drivers/scsi/scsi_lib.c       | 12 +++---------
 include/linux/blk-integrity.h | 15 +++++++++++----
 include/linux/blk-mq.h        |  3 ---
 9 files changed, 51 insertions(+), 37 deletions(-)

--=20
2.43.5

