Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6465938E8D0
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427220; cv=none; b=Svr5V95szy+pN2qIYEzkrdjrrI9WECQ5U3LE2IUJxj7S+SnEWRL/zUvi9pqn8Wy2zyADPnkzpfuycYHMFM8oBwBnTO+J1FDcKcxikIGzWgWLlqPUKzFCbxFTgjtQzcYhDYLBHHSoC1gRgpR4Zmx6red+4OVP5DCU/DH47szdQQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427220; c=relaxed/simple;
	bh=n4tBtFZ+IMY91RgO9hTFhxKRnRr0CVodyW5KrrA/HV0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e2uOqHgbq6ZurjMXtYAgUJIfkQYy5yxwlrkvPrUQHCEDuEraIXepTkmmNsoRSqB/80kQTDZWrZDgW1QmEF9nsSeMMSxS5fTYDR4L/xwrjS81eIZrg789jI1nVy8yqOKR77X6s6a7DIHnO/087yyUwTrRpMFuc5rhcFpQmyhgRek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=AsWJPFpr; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AsWJPFpr"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWKcM1321665;
	Thu, 30 Jul 2026 09:00:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	KNgopZlJzR/pNPcMCD0e9KSCBISJlFHdpQAIRverhY=; b=AsWJPFpr/rTbzcy4A
	r844sZIjesDqQY2IeSFkHE3ffxIuJvYeI9TP9wUwMdwS1wuG/0i1U+e6YNLd/quC
	TVJBnCnlp0zOzGQ56VQz2gfZ+B+x+O5V1/Mv8YGN/OE8P9LvMidkQqLuXYkE7RDe
	ip0NtG00ruNd+K2zzLFHysgMAkoybP+2IT95VYquIq2EuO7hUrka61qte/A2yd02
	19+lprcGCOCJppO7TDqXEN2/PUIhlhhaEbeBZ+Z0D8/oed2AOCDqHCTSaHvWt3/S
	RZlxQOgCp5KDFfg7hJqMdAJLpm4B3FD0Wkz/FUeD3r1m59WXgCXS1Y3Tam8VcpKk
	RfbBQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:13 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:12 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 254C45B6953;
	Thu, 30 Jul 2026 09:00:09 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 25/33] scsi: qla2xxx: Skip NVMe LS reject IOCB when FW not started
Date: Thu, 30 Jul 2026 21:28:30 +0530
Message-ID: <20260730155838.2119230-26-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: cMl4bcGmdxL4UV_cWzAjxmIFfaWbiGsX
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX/bXGCfTj6n6g
 wDMKkoT8yzssKfhLYHOwNqIo9bgtP75oSiy+hReYkEGwFSdWBML4nlGOXumtwR+FG9IXrvHeKGM
 4QYU4dKk+44guKO4FJmoD7MDRsmhXaM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX8ay6QjA7GQAz
 NsY35icnvwFrmZ5/vkO9lVpkaum4RPc2V0biT2yZcilBYnGfLWe/Q3gxolOQ4yFHVMD8DGz0asB
 48fkgJJ129+ypseOTqrC0J0+1pLoeNuHzBqbdAGhUKVoCPtHJXaePeklUtUKnhea/pnSidjFE7c
 1MdGJYrnIeydIOZMsAp2eZXD0GXrv834nkqPsAr9tVOA09aqrxToKK3R/d6kep3e6M/tw6Po6se
 35zsL/woMgOfktAG3TFcOvo1qaVCd6jc+ftG8X9aH/RB6KLmhmXlfsOmpS8s5HZgWiusSFlKNN8
 qqT0TSoEWGDI0Xh91KcbhTbP5Up7w4LJGBQRufsBHwGfg9I4uf8BVdGo364ivk1bL68B1569xSd
 /HIVpP1ywziVfbEwgoOD/a+uXJ5g+/v33YPKENUdEZdSueZo1UcR/AAIXT6Jp1/GXaLnKgzwwts
 Ex10MHhBq/JXkDeGozA==
X-Proofpoint-ORIG-GUID: cMl4bcGmdxL4UV_cWzAjxmIFfaWbiGsX
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b750d cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=D7LrxwbwNQI63mdunOMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla_nvme_xmt_ls_rsp() bails out to the out: label when firmware is not
started (!ha->flags.fw_started), but the out: path unconditionally calls
qla_nvme_ls_reject_iocb(), which ends in qla2x00_start_iocbs() and an
unconditional doorbell write to the request queue in-pointer register.
This rings the firmware doorbell and queues an IOCB that stopped or
resetting firmware cannot consume, and touches MMIO during the reset/EEH
window where fw_started is also clear.

Only emit the LS reject IOCB (and ring the doorbell) when fw_started is
set; otherwise just clean up and return. The post-allocation failure
cases (SRB alloc / qla2x00_start_sp() failure) run with firmware started
and still send the reject. Apply the same guard to the reject emission
in qla2xxx_process_purls_pkt().

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index fc8a344ec7d8..28a04e0ff660 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -441,9 +441,11 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 	a.vp_idx = vha->vp_idx;
 	a.nport_handle = uctx->nport_handle;
 	a.xchg_address = uctx->exchange_address;
-	spin_lock_irqsave(ha->base_qpair->qp_lock_ptr, flags);
-	qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
-	spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
+	if (ha->flags.fw_started) {
+		spin_lock_irqsave(ha->base_qpair->qp_lock_ptr, flags);
+		qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
+		spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
+	}
 	kfree(uctx);
 	return rval;
 }
@@ -1321,9 +1323,14 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha, struct purex_item *item)
 		a.vp_idx = vha->vp_idx;
 		a.nport_handle = uctx->nport_handle;
 		a.xchg_address = uctx->exchange_address;
-		spin_lock_irqsave(vha->hw->base_qpair->qp_lock_ptr, flags);
-		qla_nvme_ls_reject_iocb(vha, vha->hw->base_qpair, &a, true);
-		spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr, flags);
+		if (vha->hw->flags.fw_started) {
+			spin_lock_irqsave(vha->hw->base_qpair->qp_lock_ptr,
+					  flags);
+			qla_nvme_ls_reject_iocb(vha, vha->hw->base_qpair, &a,
+						true);
+			spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr,
+					       flags);
+		}
 		list_del(&uctx->elem);
 		kfree(uctx);
 	}
-- 
2.47.3

