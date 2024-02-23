Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4C4168A4
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2024 07:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708674363; cv=none; b=AdxTwAHYfpw5Y7vQsiThEsmtOX9II5iHTwTOAZ/EBtYCqqUe+r8uHKG5JQOPXy1zBAFsFwg2qifU00XWe69krOvFr3zFFTzElPgpVE5HBZ2V9SyRfC4xRNQ8XvZMmog8Cym9/nHNulW8gRT/ef4LZHFBqCiyiHT5BhpZvZ71MFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708674363; c=relaxed/simple;
	bh=LvJl4JQa9yv6d4abKcaAahHyBlawdqs5GX3G8LU3dVA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NPVFnTAZmblDx/w3c/6RrJ/BB3Kqh+tiYIwNqzOz1r/3LJhCMf/AtY1OTzEqNvq6KDi8AtJRcOG+xeNcadFPmuojWS4PID2CfrKAvDDD7UmRzeYXw1Rm0d6wvlfPQX4yz5V9q2cRpGLop3EdTGmhadTO0VxuYECe3jtHWcdDqjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=EMa7NE1T; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="EMa7NE1T"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41ML8pek003065;
	Thu, 22 Feb 2024 23:45:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=BuOOxGN7igXfI66E1iRoiQ9A1pzwr2Iwhw8AnBeZ+yo=; b=EMa
	7NE1TsAqQKdQrzNeTuWPSl+tnjRFXsECDvvUfkDMMiXww1sCbrym2A9BM/OoiRNO
	cNxuV53GvP6/RLS8s3x3uwO6LTxZFO9HqpKEswQGZOQdA/2IQEXnoE5sM3b/xyGh
	2E4K7JSUK2WnMtApi2u+Z+1z8QU9brWYtX78nVItWO/gwjL2babbx0q4fLYmRmJh
	b074tDv4psdWZ3Dne/bld1PYpn+IPgsr6xXLIjr3lro27QEcvk+eDM51sAwDeakr
	JTfQEkL3CpqRxOyWKwC7uJOHV40QS3A8JRuwy1Ro7xnPX60wQIVajHfuKR54LSkg
	Gdv+rhNld7V3l8tKFqw==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3wedwxht4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 22 Feb 2024 23:45:57 -0800 (PST)
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 22 Feb
 2024 23:45:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 22 Feb 2024 23:45:55 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 53B6D3F714A;
	Thu, 22 Feb 2024 23:45:53 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 10/11] qla2xxx: Delay IO Abort on PCI error
Date: Fri, 23 Feb 2024 13:15:13 +0530
Message-ID: <20240223074514.8472-11-njavali@marvell.com>
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
X-Proofpoint-GUID: RCD9gGMiXKSOWsGwoXZ49e5SM7Ti43kj
X-Proofpoint-ORIG-GUID: RCD9gGMiXKSOWsGwoXZ49e5SM7Ti43kj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-22_15,2024-02-22_01,2023-05-22_02

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

