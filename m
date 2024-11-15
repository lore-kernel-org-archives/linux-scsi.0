Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED75CA5B
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 13:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731675862; cv=none; b=SBDneG3J2Sly+kSqFSe118KYN3cIBmMdCE6EirOLJL03vbKFuBDYpfEQngxSUHOCry967AwVI8J3FiwUsOfX7VS9XMYp7y6rwuxzrua9mTHgb80MIoMob74x8MxI6elc/pazLm7fiYpkDStE7tbPz7m8tt6Uq1q+fnnJhwq5Ndo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731675862; c=relaxed/simple;
	bh=+1gzC6uZWQan/DnF0CabG9Qkq/CF0Ht96rvsQrF+XdM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pF4aEeJDxzYQj9xly+u1bBTUVsMnkcPUu3nrhpXW6vA484Cgq5ClU38FK02OkbMhq96wPdtXru4JKDtA3pv7KBd1d2O/3aZ0ZVAHNega8pzWfC6BHVZqBQz0XAj5xVW7/UqXjZENC9J0E76TzKVtBNMYeVB+xWAPBMs+Y0E2pYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DQR4G8iB; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DQR4G8iB"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF7YIBE011764;
	Fri, 15 Nov 2024 05:04:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Z
	D/c2GCdicom9JNUhqK7dB6uGRKQXzt20Ft1PtiCJ5g=; b=DQR4G8iBmqCT9s0sn
	SDPWgFiRm21yi6+XF/jZDedg/Hk0mA792klFv+LzudPpKffE56fxFswPwE4CNwQp
	x5t1ZImpp+mbwbh2Zm72TirZtAfTVPemawI1VsShlrHOIDvHvChhjW92B3OzSk6F
	KA78IfOhe7E0A0cIIRH6tU84jiGzcpwtXPKegFF2apc1/Ec3k8j7IjIlW5kKYCjm
	5dURfH3/jEFGld7JcTdaRptArMULIonvn5ZPtXbLSyXhOtxkyk5fiNnGxNoJegkj
	PN3s+MeF/GmTPRE+mfTqYDo9jqENfBys1Zj24seZXEXtK38gn1VgF33ZZ7vWowtI
	27CjA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 42x2128e95-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 05:04:19 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 15 Nov 2024 05:03:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 05:03:43 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id F254D3F7075;
	Fri, 15 Nov 2024 05:03:40 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 5/7] qla2xxx: Fix NVME and NPIV connect issue
Date: Fri, 15 Nov 2024 18:33:11 +0530
Message-ID: <20241115130313.46826-6-njavali@marvell.com>
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
X-Proofpoint-GUID: frbKb_ViYtY_dOxtcykxJ9GPXpaNmH_z
X-Proofpoint-ORIG-GUID: frbKb_ViYtY_dOxtcykxJ9GPXpaNmH_z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.687,Hydra:6.0.235,FMLib:17.0.607.475
 definitions=2020-10-13_15,2020-10-13_02,2020-04-07_01

From: Quinn Tran <qutran@marvell.com>

NVME controller fails to send connect command due to failure to locate
hw context buffer for NVME queue 0 (blk_mq_hw_ctx, hctx_idx=0). The cause
of the issue is NPIV host did not initialize the vha->irq_offset field.
This field is given to blk-mq (blk_mq_pci_map_queues) to help locate
the beginning of IO Queues which in turn help locate NVME queue 0.

Initialize this field to allow NVME to work properly with NPIV host.

 kernel: nvme nvme5: Connect command failed, errno: -18
 kernel: nvme nvme5: qid 0: secure concatenation is not supported
 kernel: nvme nvme5: NVME-FC{5}: create_assoc failed, assoc_id 2e9100 ret 401
 kernel: nvme nvme5: NVME-FC{5}: reset: Reconnect attempt failed (401)
 kernel: nvme nvme5: NVME-FC{5}: Reconnect attempt in 2 seconds

Cc: stable@vger.kernel.org
Fixes: f0783d43dde4 ("scsi: qla2xxx: Use correct number of vectors for online CPUs")
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mid.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 76703f2706b8..79879c4743e6 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -506,6 +506,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 		return(NULL);
 	}
 
+	vha->irq_offset = QLA_BASE_VECTORS;
 	host = vha->host;
 	fc_vport->dd_data = vha;
 	/* New host info */
-- 
2.23.1

