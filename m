Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050C51922E3
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720631478; cv=none; b=FO6oZVbuVYEetrZPSyF5bUvKcUJKw3G2jhNkLmmgyk5K0JJ8KPGiQb7Vrv5CUhol9W663Nu+YzWuT9G2FFGKwXUfw9QEd7o6jcg2O7t+gjebmUQp9HQ9PyIieMk/QnGHjyJv3ZKN+E4PRmQOeMWPhzFd5kvJtjS1cGs/Gh9yCS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720631478; c=relaxed/simple;
	bh=QkzcLhdamFsoXkVkFtyRdIk9yEJpIwWg9UeU8eC5w3A=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UgmgDTr7QPpEqJImmmtNLftnrX42nCcb0SEZO0MFyK9I3OlsiS4VnJGzQvwqmZZkIpNr6l4nrId+GcmmP14RWj6ZyRURjaZaFdQet0wfgFDgN2lNhdBhpIehaGa8YZoIL42RwpQzUu4Sa7ptOpNHzAUZEeLcXXgR670ss0XduPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=NmEzCTlQ; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="NmEzCTlQ"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A9lB4f023801;
	Wed, 10 Jul 2024 10:11:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=qh4jl9O1U34YHg8zORDlWoq
	YIByiD9/NSo1r6CK8d18=; b=NmEzCTlQ95SgfSsolpdiW7e3LjLzVZ8jYxNzlxy
	49OvAgLNoyccevr10Yi0B6+JQXgDQobofinTU/TqFruq4uxxLtOylUabU+04n/tF
	186D6kK1dDRIOtOJEDRCLlTpaoh8p4M+RRsojPgJmeSU02WKIa2b5WbsgNRZBLbp
	sHXzereHek7c5dZFC7uJ+PDwjMMqPm9+vfO/5bRUqFUbtfaf0/CTjKE2elfIhRVF
	F3StESULkJ3Y/YCyZZoyfMGoRzYx87PAMvgsCPMbIfq4NcM9ngf6mZkqLtEg3+XX
	pgC7QnJiNv5cK5bKMSE4RSy2ONtBhqvSG6aDnehh0L9D9Kg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 409qyf21kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 10:11:13 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 10 Jul 2024 10:11:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 10:11:12 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id B855B3F7093;
	Wed, 10 Jul 2024 10:11:09 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 00/11] qla2xxx misc. bug fixes
Date: Wed, 10 Jul 2024 22:40:46 +0530
Message-ID: <20240710171057.35066-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: p8LC8edJzyD5C8qd1BesKb5YbV6u65Dt
X-Proofpoint-GUID: p8LC8edJzyD5C8qd1BesKb5YbV6u65Dt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_12,2024-07-10_01,2024-05-17_01

Martin,

Please apply the qla2xxx driver miscellaneous bug fixes
to the scsi tree at your earliest convenience.

v2:
- Fix smatch warn, val_is_in_range() warn: always true condition '(val <= 4294967295) => (0-u32max <= u32max)'
- Fix smatch warn, qla24xx_get_flash_version() warn: missing error code? 'ret'

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
 drivers/scsi/qla2xxx/qla_inline.h  |   8 +
 drivers/scsi/qla2xxx/qla_mid.c     |   2 +-
 drivers/scsi/qla2xxx/qla_nvme.c    |   5 +-
 drivers/scsi/qla2xxx/qla_os.c      |  19 +-
 drivers/scsi/qla2xxx/qla_sup.c     | 108 +++++--
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 11 files changed, 452 insertions(+), 374 deletions(-)


base-commit: e8a1d87b7983b461d1d625e2973cdaadc0bd8ff5
-- 
2.23.1

