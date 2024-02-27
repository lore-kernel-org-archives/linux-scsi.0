Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29B44EB4F
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 17:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709055165; cv=none; b=XRrUAp+SRUZWeBMJ0Qc9gNwqUtH0TjnAYvpfi+vwtIS1yT/F/+CO/QaqxOwqAjTFd94LfuoV6nt9uifSeEnlK5BqWOe9ZGJUlBXRQ9gh/9xBQ+Sr7GNwkHWOrUDjyxxvIu7beM65c+b8qtw+gYbnxwJwcsJpR3FuvAhzgG9TtHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709055165; c=relaxed/simple;
	bh=pejbUCsMFv6Ahz1e1rfLpFG2VIgRapUAR917zcdIqhY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9CZ7lqS/CUFZIMm3SkOcclBaxA6ZMIbo6BsojIH+BZgwgDvZenRPvTfb2fLiJC7TAEJwckR9bSPMiAyT4Q0x6RcVQ6xNP7W1oMthqtaszaL/pZ2evOnfL1fzsxDwDV3KuLQOQ2XZQNqFEGQrRgjKuLaJUlbbI8pzokyjyo2/7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=c5MZk86U; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="c5MZk86U"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41RFhNe2005875;
	Tue, 27 Feb 2024 09:32:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=lUgV8To8DnTAkehnXhk4FSqVTTYIglG948F8nDlT3ok=; b=c5M
	Zk86Uy/akqHnHkltyW35gHAjNXmGvd7An7TruXZA4ZuK2YtURBSKkHtYLO9r7yeH
	fMs/bJzgTORS8uAylViV1Ecmj+/egGK1VTgQ/XZQjbh/jHFJFu8eFJfP+vCsa0tn
	nQzm7oX7RnfpNdfd28Y3KIUSl8WlP6Hcwv3Fp+YN+Tjqhyync7mVI+YJD9fKMejH
	uLD6xyTX60uk9vsmqqCfZz9ABkPcYENmdShlpDDIIi/xr6baBrQqJKrtaACtc4EN
	P86LnRSEawThY9V8Yy+MibbjxVp8WRP3R5DAh5YA27ggXPrYY/0sW6Eg8+sLpz8h
	jEDLuHyKEYFu8sYkFZA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3whjm68h0q-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Feb 2024 09:32:41 -0800 (PST)
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1258.12; Tue, 27 Feb 2024 09:32:39 -0800
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 27 Feb 2024 11:42:05 -0500
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Tue, 27 Feb 2024 08:42:05 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 4FD473F70C6;
	Tue, 27 Feb 2024 08:42:02 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 09/11] qla2xxx: change debug message during driver unload
Date: Tue, 27 Feb 2024 22:11:25 +0530
Message-ID: <20240227164127.36465-10-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240227164127.36465-1-njavali@marvell.com>
References: <20240227164127.36465-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: C7SJTV56gX6A-JiUNjkfLHeSxy1nTeL2
X-Proofpoint-GUID: C7SJTV56gX6A-JiUNjkfLHeSxy1nTeL2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-27_03,2024-02-27_01,2023-05-22_02

From: Saurav Kashyap <skashyap@marvell.com>

Upon driver unload, purge_mbox flag is set and the
heartbeat monitor thread detects this flag and does
not send the mailbox command down to FW with a debug
message "Error detected: purge[1] eeh[0] cmd=0x0, Exiting".
This being not a real error, change the debug message.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 21ec32b4fb28..0cd6f3e14882 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -194,7 +194,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	if (ha->flags.purge_mbox || chip_reset != ha->chip_reset ||
 	    ha->flags.eeh_busy) {
 		ql_log(ql_log_warn, vha, 0xd035,
-		       "Error detected: purge[%d] eeh[%d] cmd=0x%x, Exiting.\n",
+		       "Purge mbox: purge[%d] eeh[%d] cmd=0x%x, Exiting.\n",
 		       ha->flags.purge_mbox, ha->flags.eeh_busy, mcp->mb[0]);
 		rval = QLA_ABORTED;
 		goto premature_exit;
-- 
2.23.1

