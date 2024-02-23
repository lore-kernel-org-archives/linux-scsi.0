Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571E91401D
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 07:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708674352; cv=none; b=VVE6jka6XwOjtf8Op4+4Fe835SSbrY7relz3pHGJ/xFMmpqUTdQv1s7BvlB6tVHSw5+HoNi+f4AeNPK2m58GOeIhjbIVGDHiyHpdPr3Ic5DPMaEfWY9ktHJikuDacH5baUa7g9kD96aNmUX3w8m5f7RolweKAT0hOOlpuiKmWk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708674352; c=relaxed/simple;
	bh=TKuXkygBXZrMoD3Rkanddk4xjwMWOWoVCrI3qAimn+g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DWxy0g5PyQfRiVDFCnMX/aFW6eMCgQ3rbybU6kQSbhdb36XW+3FkLo0sd2cbyGtYL5RmIkWSfano80WtRzfKlRcnRr/qUnDkuOory8K3vzreTTwWGAJHVmAVmHeJ5769MnXt+2o/loPxa86C1402thYl0AimUBx7xXuiKcQeq9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=disejp3M; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="disejp3M"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41ML8vmA003174;
	Thu, 22 Feb 2024 23:45:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	pfpt0220; bh=070SwO61Cc+ea9J0KiZZjhrWcSW2joN0p9lc8kz4hLU=; b=dis
	ejp3MqVJ2ZjwlSWoNBPzU8WrmLqtCCg8j6+5Mtz/6VafqDkeazcVC62sTe007ATU
	EAWD7i+7mEd/YBxTvaJ+OeYuvsGqneUOdE6SPDE98QP2G1sjZz0aj87nY8xTaeIv
	A31sB27btDhynLmo5lbdvKyS7uMid1WurE8pvsbKZ8y2ZgmKJqlMtPI+j7Mlp0Wv
	/yu2eB0xdaGSBoFy9jnUX1nBAAZOKPSCzL2dmTu7p3fFvDo9HKSsrGXgohIC6T1i
	R9q5+HDlM9D6cdOzOrm2/hZFwCKVeQVgCs/RD1KpDEcGnroGi6OKqq7OZkq7n+pn
	WMzj2tnxjEUpZTGQC0w==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3wedwxht3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:45:48 -0800 (PST)
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 22 Feb
 2024 23:45:46 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 22 Feb 2024 23:45:46 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 45AEC3F7151;
	Thu, 22 Feb 2024 23:45:44 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 07/11] qla2xxx: Fix double free of the ha->vp_map pointer.
Date: Fri, 23 Feb 2024 13:15:10 +0530
Message-ID: <20240223074514.8472-8-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240223074514.8472-1-njavali@marvell.com>
References: <20240223074514.8472-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: EaUYJE5tFhYTcyzrY-xLuVXdfJONozGS
X-Proofpoint-ORIG-GUID: EaUYJE5tFhYTcyzrY-xLuVXdfJONozGS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02

From: Saurav Kashyap <skashyap@marvell.com>

Coverity scan reported potential risk of double free
of the pointer ha->vp_map.
ha→vp_map was freed in qla2x00_mem_alloc(), and again
freed in function qla2x00_mem_free(ha).

Assign NULL to vp_map and kfree take care of NULL.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b3bb974ae797..1e2f52210f60 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4602,6 +4602,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	ha->init_cb_dma = 0;
 fail_free_vp_map:
 	kfree(ha->vp_map);
+	ha->vp_map = NULL;
 fail:
 	ql_log(ql_log_fatal, NULL, 0x0030,
 	    "Memory allocation failure.\n");
-- 
2.23.1

