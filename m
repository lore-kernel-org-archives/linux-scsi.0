Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6585F1B85D7
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 13:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731675863; cv=none; b=E+jVPd8+Xmq+QrT+KXGOumVh2eykCbZ6kTOMBdQDcIiWpOh/r+jbYgvA3lNUvc1nyFeL/SckyJyv/s237XoJi20ZMSpjPXMj5dOdkPIjJ9dO4MEN9g1mHcZpV5bypb7cetE2o5PWHZsOLvz+Xbgb3/VHZCC2HlklyFQDK2PGVys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731675863; c=relaxed/simple;
	bh=SJWNeW96/OUcLB5RiNVKx+bCIbqf9O6RTxpq0bPmS3o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q4Br2v0Vo4DMNKXV0eEoKi7hpqtBBS5PWkxS79/2qaFpB/u0De1MrmTpRsnp2pM0wqpcdKvZGDsql2Cvt2lg9xpNPJK6bJq1K75qh209LWMMPMdrgw/KFKoZZ5fWDoJx3UadcR9zyf77wn8+7bRkGvz1b/Z0kt6RmEZMD2lbUfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=gXaIUDGK; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gXaIUDGK"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF7YIBF011764;
	Fri, 15 Nov 2024 05:04:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=V
	WVKT5KNW16dqg7KVLX/7XSqpRlQTg4xH9UgbeYk2qw=; b=gXaIUDGKQEGO9+Z7j
	aNB8Vw9+GR4ELR4JZVj47v6ieeccudPNvHA65VLWWO3PSwnw+p6G/ZQ+c/oyXC90
	dR8f7nhrCaUgZsVOv30FVJl4V72DHPLQOQsBHRUl0V38rEDjVEWoVG5cabwjGjrf
	4lSu9ICmL2GVNzNI7cVDGxOV2ZC2Zta0Ra1fSceyVexU19i/c2Z3WVXQS1vB++7K
	FUEsn17RqpUYZk3fFjlV84y5hCJ8qiqDZuG+HH+2Fxuo9xjNBzd/Vj0HqggVnUS9
	2q+qoXLowq6j8wn/mMINqmbcnWg0edwjhPVekc2JICDN9IDg61csp4HCI0coL0Z0
	GxmjQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 42x2128e95-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 05:04:19 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 15 Nov 2024 05:03:45 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 05:03:45 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 9B1053F708A;
	Fri, 15 Nov 2024 05:03:43 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 6/7] qla2xxx: Supported speed displayed incorrectly for VPorts
Date: Fri, 15 Nov 2024 18:33:12 +0530
Message-ID: <20241115130313.46826-7-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20241115130313.46826-1-njavali@marvell.com>
References: <20241115130313.46826-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: eqWs2LBczhSqLFq9ij6wP10u0qfg3AP0
X-Proofpoint-ORIG-GUID: eqWs2LBczhSqLFq9ij6wP10u0qfg3AP0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

The fc_function_template for vports was missing the
.show_host_supported_speeds. The base port had the same.

Add .show_host_supported_speeds to the vport template as well.

Cc: stable@vger.kernel.org
Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2810608acd96..e6ece30c4348 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -3304,6 +3304,7 @@ struct fc_function_template qla2xxx_transport_vport_functions = {
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_supported_classes = 1,
+	.show_host_supported_speeds = 1,
 
 	.get_host_port_id = qla2x00_get_host_port_id,
 	.show_host_port_id = 1,
-- 
2.23.1

