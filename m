Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691AD15E5DC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023007; cv=none; b=mGwS4Jkvt3p/SEdN/YGpmuf5gC0T9cftCkLrvop7zyBHbrLTUd1Pk3C4+ib40E/tAJljVvfP/XCxRI2CCCzp25XiLOyIsk8E/GKbzZLygENkNAg2cjjy02nWBgfWiLr4FzzntT3iGtTvgsD+iatckrvottBZngQVK4y/6VCDz4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023007; c=relaxed/simple;
	bh=4hVD2Lnyt9WR0canBKBLDa32HYdb0zOjjhM/XcIp+pY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NwKw5WyOd1Gxf1nFxMKgPsrXVsbZ5bqvLBX+qvpzZwBphv3has2bu+YDE/5n2N89um6RIhk/Zh2E/aV3miYewnfvmCgjPink8VaoKbUQyJhDxm++g74s8w0nidny+INBVHMwVDxZyXIm3kpDKTEoQW9/w2MzxoYbTwE9KJxmXJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=KoVkczF+; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KoVkczF+"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6Ui4R3693332;
	Tue, 14 Jul 2026 02:56:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=X
	Xx+80u88xwIUxcMdg52XhKTAJ+dfi+7FHGzyEm6Q2c=; b=KoVkczF+a48OEvVZg
	hEZ2YLzFkE+DYeFFgs06UJ5GGuyvmxYAAih2PlKukZsbK5o6/eAa8mzjYiuHsn14
	aT56YbP76krGDWzyAD/0NT97+bMCitPRvpCv4T/8E6QSfTPVCQl2rlS9l9KlvKOx
	6zisvLs9VGQQ04lhrPE+/QwjBiOaJ0uPe1TLSP4MMHAviRwfspztPNPlJJ3+Scsu
	6Efivi25fdJAd7Y8loI8zdxQN1hdBiOKVkx8Zhs8u/SmQdxGWq489J2F6KgLHGDa
	HDMOleviAXx6UWDs3NklhKtUipUnWo9Six+g5nkMgrJVBOHTUkHzjyGmaas78LNS
	gXWQQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8yy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:43 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:42 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 50C4C5E6867;
	Tue, 14 Jul 2026 02:56:40 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 52/56] scsi: qla2xxx: Hold qpair lock when sending NVMe LS reject
Date: Tue, 14 Jul 2026 15:23:49 +0530
Message-ID: <20260714095353.289460-53-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Vq2GFgF7RNXf5IGwz2KdpqCkIwF99dPe
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a5607db cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=m9MgVfr9m7VbzoiWWp0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Vq2GFgF7RNXf5IGwz2KdpqCkIwF99dPe
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX7pt3dHEj78oy
 rVFHap1hZBTZPZxYrDSZhpfVa1XfbISdcqt+cF8nWYdoOoh/cqv1WDXV0OZfgxpGSF3WjzwoWtT
 OCBYKUIp6SfIJ5cBpLWJ/Vdp/W8KAP0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX4TYvV8kcXC4b
 tLR1+6zqgoK05i/maDjJdfpk8z++NxHQLxcvWeCWaXw/j0Z1ZyV0OnfWeXuaz/A70it8OGDnIj+
 Qoj99p7ou3xwp1ea67Mp5yvlVqR/d7izij5nDMtjR9b9qj0u5yxxqYNoQvAvHnSAX4jVLWcuNnP
 k+oBtPvCU1yunNVsqFvXxKABGiOIdJv8SUCVOhIi7oz9//N9dWw5zzlq7Hlh2fUH6sT6uBObcOY
 urxVTcbVzlggYUPeBDafoovzXIkVRS1p++rFGYTBMKWzHPUDbgD+6aGAgQmGTwVIigyVn+16nLO
 l0EW3iudUby9d4sbH8wYglNNxo0JRtq8ipCcqQuSw/JpKVRCB3uUQp4uA2snRR69LX0Zff5oWCK
 dFS+rNlX4YW7SIuUdAnZR0CgMqOM3q9Qq4zmVa2moR1XH4ohlSeUTpDTigmb78yDnYRRuRHs+QF
 WyqqLEPo9rCUWIKpeng==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

qla_nvme_ls_reject_iocb() allocates from and advances the request ring
through __qla2x00_alloc_iocbs() (which assumes the hardware_lock is held)
and qla2x00_start_iocbs() (which advances the ring and rings the
request-in doorbell), but takes no lock itself. Two of its callers invoke
it without the producer lock held:

  - qla_nvme_xmt_ls_rsp(), the NVMe-FC .xmt_ls_rsp transport callback, on
    its error path, and
  - qla2xxx_process_purls_pkt(), run from the purex work/DPC context.

Both use ha->base_qpair, whose qp_lock_ptr is hardware_lock, so they can
run concurrently with normal I/O submission on the base ring and corrupt
the ring producer state, leading to duplicated or dropped commands. The
third caller, qla2xxx_process_purls_iocb(), runs inside
qla24xx_process_response_queue() with the qpair lock already held and is
safe; that is also why the lock cannot be taken inside the helper itself
(it would recursively re-acquire hardware_lock on the response path).

Take qp_lock_ptr around the two unlocked callers and document the helper
as caller-locked. Both run in process context, so spin_lock_irqsave() is
used and nothing in the locked region sleeps.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 3b2f255a5d7d..8dc6df6c2e1c 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -374,6 +374,7 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
 	uint8_t cnt = 0;
+	unsigned long flags;
 
 	if (!fcport || fcport->deleted)
 		goto out;
@@ -440,7 +441,9 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 	a.vp_idx = vha->vp_idx;
 	a.nport_handle = uctx->nport_handle;
 	a.xchg_address = uctx->exchange_address;
+	spin_lock_irqsave(ha->base_qpair->qp_lock_ptr, flags);
 	qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
+	spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
 	kfree(uctx);
 	return rval;
 }
@@ -1243,6 +1246,10 @@ static void qla_nvme_lsrjt_pt_iocb(struct scsi_qla_host *vha,
 	}
 }
 
+/*
+ * Allocates from and advances the request ring, so the caller must hold
+ * qp->qp_lock_ptr (the response-queue caller already holds it).
+ */
 static int
 qla_nvme_ls_reject_iocb(struct scsi_qla_host *vha, struct qla_qpair *qp,
 			struct qla_nvme_lsrjt_pt_arg *a, bool is_xchg_terminate)
@@ -1299,6 +1306,7 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha, struct purex_item *item)
 {
 	struct qla_nvme_unsol_ctx *uctx = item->purls_context;
 	struct qla_nvme_lsrjt_pt_arg a;
+	unsigned long flags;
 	int ret = 1;
 
 #if (IS_ENABLED(CONFIG_NVME_FC))
@@ -1311,7 +1319,9 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha, struct purex_item *item)
 		a.vp_idx = vha->vp_idx;
 		a.nport_handle = uctx->nport_handle;
 		a.xchg_address = uctx->exchange_address;
+		spin_lock_irqsave(vha->hw->base_qpair->qp_lock_ptr, flags);
 		qla_nvme_ls_reject_iocb(vha, vha->hw->base_qpair, &a, true);
+		spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr, flags);
 		list_del(&uctx->elem);
 		kfree(uctx);
 	}
-- 
2.47.3

