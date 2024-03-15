Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FC21805A
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710497189; cv=none; b=ogw8mu/DtY8AlbgO1Qf0rirtTbBGjG4gaDV+xV1DeUJxexYeSzZGB7TtSJ8BGEgRrROWmpdnHhY/+A271s/NDvznNZJZs7lbPkFLHvZaLoQT6CC0myJYslKyTU8mLckhyNQO81soStEZQGClX8fS0F19rGY66DYY7mVVoZsd4JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710497189; c=relaxed/simple;
	bh=JYTg/E0J+mH7nX35c2yMfPkUgNRhyoDFrFfaP0gze5I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sAtR4z7kz/sEexp2GhIsHUS1wcn0uhOGOvO8V/drKpldycU6WHv+waPa36N9PEs3gjjdrgjkR4cxtim5ksClvJdImh7ZWlrKlyD1guvvnHylGK+8rOyMWea/aO4tetK1vdBbr+s0tFJnC82sxsLCVLZt8GkA2sTOD5T02ZGzLT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Oc1cVvIl; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Oc1cVvIl"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42F8euim006306
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 03:06:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=pfpt0220; bh=9dLqSDt+
	3xZ8chjcc/Duv0i/d64zXJmSrpAuM7l+Ufs=; b=Oc1cVvIlVHqTYD8ZSb9u4N8X
	HuBzj5reVRSzMnHKyucbeQP1KwLlhKzyJmS3PkbcaKEU7XqCGvwrhCvD9YyJ+f4J
	njRolrhLKgPPXwrf9j6cpT/gxCbj5WZw3D+My5zSvjKDXFCQIr+2ZvCoU3bWfdNa
	qmaSZdyO5bk4Q38faeve8fjhx7QznuxXW2yhJqWCkVxX7IO5mNLb0Dz9YwF71S0F
	C+6CPTaFV6SMDGAyoL3CA9fumfdtcwvTh1Ynz7m1jFs+5ywY75tNDxUn9t2TpRqI
	/GxUIzdhFZWXWZND1w9QJqDeVFhC/+HO90lD4LLIYh/cTbvly0P2yuE6buO7Yg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3wvk1c080g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 03:06:20 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Fri, 15 Mar 2024 03:06:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Fri, 15 Mar 2024 03:06:19 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id D16843F7070;
	Fri, 15 Mar 2024 03:06:17 -0700 (PDT)
From: Saurav Kashyap <skashyap@marvell.com>
To: <martin.petersen@oracle.com>
CC: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>
Subject: [PATCH 0/3] qedf misc bug fixes 
Date: Fri, 15 Mar 2024 15:35:57 +0530
Message-ID: <20240315100600.19568-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: lc5hbZrRVyh3nXEp8nIycR-iCAFVpFgQ
X-Proofpoint-ORIG-GUID: lc5hbZrRVyh3nXEp8nIycR-iCAFVpFgQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-14_13,2024-03-13_01,2023-05-22_02

Hi Martin,

Please apply the qedf driver fixes to the
scsi tree at your earliest convenience.

Thanks,
Saurav

Saurav Kashyap (3):
  qedf: Don't process stag work during unload and recovery.
  qedf: Wait for stag work during unload.
  qedf: Memset qed_slowpath_params to zero before use.

 drivers/scsi/qedf/qedf.h      |  1 +
 drivers/scsi/qedf/qedf_main.c | 43 ++++++++++++++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

-- 
2.23.1

