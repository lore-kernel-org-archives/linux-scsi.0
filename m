Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A64208B4
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 16:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709052135; cv=none; b=m/go3cFi+28ZucTB/6rrUGc9iyYD+ob17IXhzzS3Sq4SA7u9EP/FwkR99KVQbXd2MK0DOo8D36GBMQx97zr4JvFAaTOWwWknyGqA+XhXM2wsEnQ7MLhCXE8u7HFwvOtLDAaAGn6mic2GGy4tOT/4XLp73XcanUNWBOljZITJy8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709052135; c=relaxed/simple;
	bh=iXXTm04N1g9pQbDSKNAEFGWNfM6LNW1Q9esAV+tNgtU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VIZWtxLnlx6G1o0a36pDhZ1+DdA/1cq081TElULb2G8EwumoB6v01Xi5ivywt0OVRLFs+jmqkaLoAyRCnCnmttZyqWzEwfMfTRwyYwMOu4/7o3HPz8ih0aTgXjqjqlLDOOD5peFxwYmk9XcpK74ZBpXiqKR4e5Gepf6vdHCIQOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=EwL047bv; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EwL047bv"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41RG2WdX023990;
	Tue, 27 Feb 2024 08:42:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=Mi84kJTxUoC4UHEK5ocM09J7B5UFqW3O+FtdGMBtTTA=; b=EwL
	047bvdiLfQrhJ/D2+OLljpCkzNdY6TcCB3WY3zhNvGlvfsFdzN6iRZgUXnyeMl1P
	31ZTrlBWXwnHhMIyZM6EenLX7CRToUy1Y4ow61QbA8v0SpAfdTbvFLVWWX2ZXdpA
	IkzabRgguhDaZdXAPdOPBgl6g3viS9qXy+8Sxc0sK0dSG5Vx/x+P8KS7L6gScNAu
	rxRNo33Nasr478tzYrHmTbMLvVuZF2iVbsmgB0lG3OfG+O0FLmKhwT+Xkw7KdLiN
	5P+Jt4k1tpOKKv1cwvjovqsAWn4rkhOaUFs7iK7ck/uf++vjamjYkPM3onx/gMY/
	92hc2Umc37nNCoH8qyw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3whjwdg60b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Feb 2024 08:42:09 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Tue, 27 Feb
 2024 08:42:08 -0800
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 27 Feb 2024 08:42:07 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Tue, 27 Feb 2024 08:42:07 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 5EA2B3F70A9;
	Tue, 27 Feb 2024 08:42:05 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 10/11] qla2xxx: Delay IO Abort on PCI error
Date: Tue, 27 Feb 2024 22:11:26 +0530
Message-ID: <20240227164127.36465-11-njavali@marvell.com>
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
X-Proofpoint-GUID: Uovf9mtX53D4_0pak2d_s72dZO1zAiHx
X-Proofpoint-ORIG-GUID: Uovf9mtX53D4_0pak2d_s72dZO1zAiHx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-27_03,2024-02-27_01,2023-05-22_02

From: Quinn Tran <qutran@marvell.com>

Currently when PCI error is detected, IO is aborted
manually through the ABORT IOCB mechanism which is
not guaranteed to succeed.

Instead, wait for the OS or system to notify driver
to wind down IO through the pci_error_handlers api.
Set eeh_busy flag to pause all traffic and wait
for IO to drain.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 44449c70a375..76eeba435fd0 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2741,7 +2741,13 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 		return;
 
 	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
-		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
+		/* Will wait for wind down of adapter */
+		ql_dbg(ql_dbg_aer, fcport->vha, 0x900c,
+		    "%s pci offline detected (id %06x)\n", __func__,
+		    fcport->d_id.b24);
+		qla_pci_set_eeh_busy(fcport->vha);
+		qla2x00_eh_wait_for_pending_commands(fcport->vha, fcport->d_id.b24,
+		    0, WAIT_TARGET);
 		return;
 	}
 }
@@ -2763,7 +2769,11 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	vha = fcport->vha;
 
 	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
-		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
+		/* Will wait for wind down of adapter */
+		ql_dbg(ql_dbg_aer, fcport->vha, 0x900b,
+		    "%s pci offline detected (id %06x)\n", __func__,
+		    fcport->d_id.b24);
+		qla_pci_set_eeh_busy(vha);
 		qla2x00_eh_wait_for_pending_commands(fcport->vha, fcport->d_id.b24,
 			0, WAIT_TARGET);
 		return;
-- 
2.23.1

