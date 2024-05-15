Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A88554BFE
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 09:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715764277; cv=none; b=cFB+WPuW5jqZbN6HD5pqRkl9SbINUnHPPRngE9CTHTReh5B7B3d3KBGJFyZGtFH41ro6mZOShqrkqJEeIliPV6lK4hoQlqgVgEuE94a53fymZ0SuAwvuUKeuL64vh3M9KiiL6ZzVQCHU8lRotYgWEqd1hXsv9innxIYPXbyfDOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715764277; c=relaxed/simple;
	bh=OAC13Dfimzj+5fYReG7p7am4jk+QQeXzvw6rqKBqvhI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dHtHd23leGXKMOXev0o9xsDEcLxYAjKuxFmlotOvAVy25h9553mUZZaOySfP7p+tdnHJcSxE4SI5WV1d9JNx+xfm+ItROC5PdVHAAy2Uw/xzsbZvG5J/uLdfFUEYQRZrKzb4jAtTxVXSsJ4v0x5o1Z3L6arZlTQp4ETxVYjKzRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=GmaN2zw0; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GmaN2zw0"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44EKMs7X014314
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 02:11:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=pfpt0220; bh=uksG7LBH
	vvyjBY0dY5PnWyBgsH79e0OUdPA4JxwJYOE=; b=GmaN2zw0bL57oDEbl6paUKOv
	4N6gAPcNWCOTAWX4VZjsBq1YTtl93lcq/9MPQjR1ab8RAQe43pWZkqmMFtZlTdkB
	KNXpoGLWzieHK66VT42a6X5Pc0511LuEN7SrK7uCuTCWpZkolIfgnOKqgWxdxR3Y
	eHGZ8Ejk42gxfqFAIMmjX/EkQmjKRPdhpIfd08l8ZKbKbi1HNPaIqX9HMlZ1YZvZ
	alpFuer+MAQQs1UZ3GoKOtcazFQiKQdGh28Ahq5KIM+Pdecb3rKKEmLTy6TA+EsK
	/7LFhDXFWU+GzCN2f4JcfQ5rOFkHbjTIQYHU6Cs4lc4PdzBt08qRLT/IGvRmDA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3y3udnd9n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 02:11:08 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 15 May 2024 02:11:08 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 15 May 2024 02:11:08 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 4FA403F705C;
	Wed, 15 May 2024 02:11:06 -0700 (PDT)
From: Saurav Kashyap <skashyap@marvell.com>
To: <martin.petersen@oracle.com>
CC: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>
Subject: [PATCH v2 0/3] qedf misc bug fixes
Date: Wed, 15 May 2024 14:40:58 +0530
Message-ID: <20240515091101.18754-1-skashyap@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: sOtKa4-03P8a1DR89p1iZpiSd3oXyjTS
X-Proofpoint-GUID: sOtKa4-03P8a1DR89p1iZpiSd3oXyjTS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_04,2024-05-14_01,2023-05-22_02

Hi Martin,

Please apply the qedf driver fixes to the
scsi tree at your earliest convenience.

Thanks,
Saurav

v1->v2:
- Merged uininitalize qedf warning patch.

Saurav Kashyap (3):
  qedf: Don't process stag work during unload and recovery.
  qedf: Wait for stag work during unload.
  qedf: Memset qed_slowpath_params to zero before use.

 drivers/scsi/qedf/qedf.h      |  1 +
 drivers/scsi/qedf/qedf_main.c | 47 ++++++++++++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 3 deletions(-)

-- 
2.23.1

