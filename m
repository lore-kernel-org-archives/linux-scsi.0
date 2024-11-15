Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DB51BDAAA
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 13:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731675817; cv=none; b=pscqYelG1pXv6KY4Ned+ufXM4inPHojmBhRszpLTmiESwlpioeeP+Ah5Jo5iS0itKVFv7DBgZkyORoV/ZGLfuEltOtkX1qZPQZrx4D5PmHk3X41uP/8ElGMk1fwBjzN1xN68eehquxiKlP9zaRSewt0vBNrRMxdqJ6KgjWAkhE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731675817; c=relaxed/simple;
	bh=p1cv151XZrmn2LOLs0l52/dk8qzpjwySbIapjGyEfKY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cdifVxoj9bmJYNl4ub7R+Ocnvt/Md03OH2n+a3GiS8syLhu1iFYWLB/jmWy4kSNduT0+nDX3mYiZ/zvIl9Tq5Do7AnHGWW2f8obiBVM8A1N4JBD25Kqw30v8MJf7n9jBMYtaunUvSOXTAAIfJtMLg9zz22bI/iY582IIBHxdpyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ZLowxaj7; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZLowxaj7"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AFAFkl7021527;
	Fri, 15 Nov 2024 05:03:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=axCoklxacJ1YJv6reGzJqv2
	EPyAWWTtZVxhWz1WrGkM=; b=ZLowxaj724zLQAxOYGV8x6VWTeAq32EahzXn/Kg
	FBLcYxS9DBr0miEbuxzmkfiYI1q/VQMe9+gYlspfugFqL89sXZqDQtOrm4OyIvci
	XJmTyyNENuxlbNlPenAe3/QDwTfZqWA2X2e50CdGlvsYZEXSNnZDV43tEfzjCMvp
	20jZv42iAjsg+1C6thQKQIjYzgWhZ0+bGZQI+1GjmRU2N7DdFsXFKCb3a3tZcvqh
	vRtJlcEGXyecHCr9WXA6OkLq19q8qtO1qMSKeeoI2OMD1P1YiUEnTBgL5fz6YqJ5
	jWFwcxIezx1gLcQBMZWEObtVWR9htsRShNF2WxvrFhC9/bg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 42x4cgr6ec-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 05:03:32 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 15 Nov 2024 05:03:30 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 05:03:30 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id AAAC53F7075;
	Fri, 15 Nov 2024 05:03:27 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 0/7] qla2xxx misc. bug fixes
Date: Fri, 15 Nov 2024 18:33:06 +0530
Message-ID: <20241115130313.46826-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: YJAWlb_FXS-VN6BMFaTI4gMDexxJda-G
X-Proofpoint-ORIG-GUID: YJAWlb_FXS-VN6BMFaTI4gMDexxJda-G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01

Martin,

Please apply the qla2xxx driver miscellaneous bug fixes
to the scsi tree at your earliest convenience.

Thanks,
Nilesh

Anil Gurumurthy (1):
  qla2xxx: Supported speed displayed incorrectly for VPorts

Nilesh Javali (1):
  qla2xxx: Update version to 10.02.09.400-k

Quinn Tran (4):
  qla2xxx: fix abort in bsg timeout
  qla2xxx: Fix use after free on unload
  qla2xxx: Move FCE Trace buffer allocation to user control
  qla2xxx: Fix NVME and NPIV connect issue

Saurav Kashyap (1):
  qla2xxx: Remove check req_sg_cnt should be equal to rsp_sg_cnt.

 drivers/scsi/qla2xxx/qla_attr.c    |   1 +
 drivers/scsi/qla2xxx/qla_bsg.c     | 124 +++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_def.h     |   2 +
 drivers/scsi/qla2xxx/qla_dfs.c     | 124 ++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_gbl.h     |   3 +
 drivers/scsi/qla2xxx/qla_init.c    |  28 ++++---
 drivers/scsi/qla2xxx/qla_mid.c     |   1 +
 drivers/scsi/qla2xxx/qla_os.c      |  15 ++--
 drivers/scsi/qla2xxx/qla_version.h |   4 +-
 9 files changed, 230 insertions(+), 72 deletions(-)


base-commit: 359aeb86480da0cba043a79c87a65806f158e931
-- 
2.23.1

