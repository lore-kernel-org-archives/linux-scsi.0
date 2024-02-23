Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED524414
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 07:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708674359; cv=none; b=eNbTctkbmgdcBz0+TGir5X/AWRdteHIq1VJCvmZg8DDX2w2/CWh1Vw1W4i8Dr8SeC829Z0YlaPckb+LSmHouBBw8kIY/TntaWwx0N85HuDE+mt5d5iWFJszQh+3y29enQ96Zvv1M71Uj7QSDjJFgt1pQ7RxFBT7lVYk35fuM7SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708674359; c=relaxed/simple;
	bh=Jr+fGuWs64GJil6HJpabUrDG25yhp5tEZ/w5Cp3uC0w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UfxlY0+PQ50bcOyQaKuyOdpTzqttHACSXTTR1/eELxEF1K/2IwPDuW2cfXC1xB8+tOxJX/zY2nBUkGmFPV8LYA0Pjh3HP/UikdVUZ3jzvbI+IqIKLixpWxy7rpqKnpIDYaBMxy/EFQn7MBX3q0stXr2L7lpsh6Rkhnj6mgx4bRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=dBB8zNlL; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dBB8zNlL"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41ML8vmB003174;
	Thu, 22 Feb 2024 23:45:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=zY7bTfRfyHVWVbuGTNmc0GSoDqYJ1el5y74jwmIS5AY=; b=dBB
	8zNlL26XKYzv5zA8LnnFEljw87toNXVKN6wVZfiKLAjKCW30gUWxlVfKMChWhlRQ
	3pmYMBuwiMKxGmM87doBLMh7TM3/EwBcs6fQz+9kv3VZDK3ILfmyvjD5S0mcCYpE
	5G2UciqecAkQn86rNwHMqWLpFmJAXclfdEz+Px0uSRec3zOBKHNbnqlm+zWS7EiE
	MNNlAvBaGJ1QId3TYqT9Dcmg9qufaGgJzAFbVPvAF/qQRGg52f/TcTayK05zZrsi
	hlXNF/dnlTWs+mjyriS5jTz5FvlImcrMT+DX9nFU0vSmyT7eJO2xE9a6/iQvDge3
	+MLPBfaP4Zs/iZVMaVg==
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3wedwxht45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:45:54 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Thu, 22 Feb 2024 23:45:53 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Thu, 22 Feb
 2024 23:45:52 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 22 Feb 2024 23:45:52 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 4DA7F3F714A;
	Thu, 22 Feb 2024 23:45:50 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 09/11] qla2xxx: change debug message during driver unload
Date: Fri, 23 Feb 2024 13:15:12 +0530
Message-ID: <20240223074514.8472-10-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240223074514.8472-1-njavali@marvell.com>
References: <20240223074514.8472-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: ho63kThmnvlwiazpE5airtu4e7_qLj-V
X-Proofpoint-ORIG-GUID: ho63kThmnvlwiazpE5airtu4e7_qLj-V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02

From: Saurav Kashyap <skashyap@marvell.com>

Upon driver unload, purge_mbox flag is set and the
heartbeat monitor thread detects this flag and does
not send the mailbox command down to FW with a debug
message "Error detected: purge[1] eeh[0] cmd=0x0, Exiting".
This being not a real error, change the debug message.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
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

