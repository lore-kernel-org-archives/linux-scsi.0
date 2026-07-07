Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FAC27466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403936; cv=none; b=MJDz2fY3/Ejj0/JpPnPcFoV6FcFk9xw4er7Z7pyrL57/mQ/2mXieY38PVjYPShFRHJhXSVQui9Vi773wGFp9QNwYAc5J95Ozp6JytT4bgf7nwgA5Myy6/OSfl+iwF53Ydx2rkM1lcVw+p1B+Wiw25lBx8xHEoAhf511kecC80Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403936; c=relaxed/simple;
	bh=n4tBtFZ+IMY91RgO9hTFhxKRnRr0CVodyW5KrrA/HV0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FtqBz9fh4QCQajQhyhOiBa64EYW0qmNf2j/Nqu9I2Hh2DjPplRnjJWlzDB1QVBlx59Uxg4Sl/8nL4MecBegyRB+7Z2GiXrYHgAIpY2LfQmwp0WAIOD2DF5jru4jTWobgO3uNjtMR8YRRQjkPpCe1s4jN6idKRTnmoC+NKU+GoO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=eMLeBhJ6; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="eMLeBhJ6"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748KSN873305;
	Mon, 6 Jul 2026 22:58:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=d
	KNgopZlJzR/pNPcMCD0e9KSCBISJlFHdpQAIRverhY=; b=eMLeBhJ6Tla4zXZgr
	EfqieUqv0nC+E+ogFKzkWUDWkiaqFUJFwd32rj16fu6sSE2u5FXYOFASdNEiRee4
	VqNFnQOEbeobvhUJNOXpsHqFz82kp26M7PDVWab53OjGxd494xd2OdZwvf38L+1r
	XP1PG/AbDeujJigP6jetItVTA8M6ZPC0+0eUwPbpW71fpfv/WRre+Do9kPXcfdmq
	44RJYcBKqNzmjvl89XrqkmtlcR05YIkCzRH0P4pM/mFdEQLtMvemt9skMSSbjZfC
	zyrW5CZNrWmzd5axWXBN3giSBm2rgLoGarHSTxTSC2xptOIrde0ny12vPHI6ODxJ
	/NbSg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waabx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:53 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:52 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id E370D3F7066;
	Mon,  6 Jul 2026 22:58:49 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 80/88] scsi: qla2xxx: Skip NVMe LS reject IOCB when FW not started
Date: Tue, 7 Jul 2026 11:24:27 +0530
Message-ID: <20260707055435.2680300-81-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ZBQvw5Qf4Yoeb2Q658iEm1O-cOaTLv1x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX8nTlpFoE4yvR
 pFOqO7KKP9GcTcIlY6FETcSo6tG/O3oqlkOVFSxnRoVmvp2GBrgWMGnErCCJTFNhJCLIiE8l/vq
 gdn1mFAdbODw033sVfwy3hSKd3cp5ezMGiByfUVNZesfFR1gRRrtBRrRWvtXO3GLUgSNIk3YNhK
 dLfPvy0RpXmBaPPOAXIwrkuaZ+MosDLKkSohURpBX5fsP+6598tmeQAVCKJ60Ob+K5JB5Z+dGoQ
 ghjaIc+oIlWM9eOhnx2r0CudtSYJpUehQ5TlCqmP9pmE/Q9bVY3ooUbbYOE7Em7GP9//aGhPCWc
 1POO52gsI+uuFkv7oDYDkWDPP8MS6lXqPO1ht/WQwRuN4mfzvWeDJscr/rKvy9S/FojlDryFtnE
 2aFlNWRzZoFNUJl33ixq5ZkXt6+nDEV423GASkXq4dSBI6lTgij93n8+JjAnD/wyoM1+jyD9OFt
 oHeSDgD/FbJVu1aasrQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX3a2MeSq+tisB
 1u64R50whM2m1+b4uJTrJ+0/vF9tT2WinUL/UcxkcsyLzFXuP4H09ph+BszcfwqSZQtor9JfG37
 LSK6bO3UJOwkx1cQ4NmMMqC8gffb5bg=
X-Proofpoint-GUID: ZBQvw5Qf4Yoeb2Q658iEm1O-cOaTLv1x
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c959d cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=D7LrxwbwNQI63mdunOMA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

