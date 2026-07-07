Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14D9386571
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403929; cv=none; b=XK2Ma9jnNoi//dSiPIncVzWKKELBsPNRbT6MNcjPBpsddoW71pXzd4nFi5pB3citOBkigPBg4601Vk/FSWKky/XlyanJNHIGlNOOlTfZPhAEkpSQyr2uLvhhe0SJtTNCc/3HUvVtsORq8EwnP3y39SA0fk2G0go0a0xs3R0/OWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403929; c=relaxed/simple;
	bh=SbXFodOz1elX7YcuHJGxCsmCKVBbRrOODRNoirENK1o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lqfVvg4BN2IRrAViudR0D9j/q9ImGQgu3FkshfECPd8BM1JWmISPRHMS1teC4/r63vSr07sxlpZVulCrSDxHPudKpbrVIRDRZcsMpcPt3I99B1bQCN/d1fKzUnjT7VGXDD9kkVNuRsUzBS/XljxYeiHEMLToFo6rV3NAmELa3/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HKV8kbde; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HKV8kbde"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747glV854300;
	Mon, 6 Jul 2026 22:58:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=H
	telketStdTtxwlisPA85OG7Uj1eLdZu3EYDpYhrRys=; b=HKV8kbdeKh6rGk5CS
	HE+3iEhJbG8cUiJ8n9VziOVs6YoAQ0GOK57+i0TuaF9J7Z5WsZQMLpzcEY0yRVDF
	5ums2IB6vpCJRIm9+6BSfzkD8gMLDe6WjU2Bpnj35n4P1dzErM2NYX9LFYgYriYg
	+0u+YKFNBBQpJKw/3eLsTn1/qpHV6GKFdD0UcB0EsQtztVsCj5u3+psR9crPTVA7
	lk/A4zEbzcMKLMy7fBJiCZfAtwOqlEY/JEGcX6cRW22e24TV7ieqZMSE7N8jBdZI
	zovmq5TPcVkq9fWBmYUgoRYrwQpA8VRcvBK0L6O7+8rz9vmbNhagK8iKLcI6zfqs
	FKHOw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q9k-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:44 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:43 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 5D2D23F7066;
	Mon,  6 Jul 2026 22:58:41 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 77/88] scsi: qla2xxx: Drop vport reference under lock in report ID acquisition
Date: Tue, 7 Jul 2026 11:24:24 +0530
Message-ID: <20260707055435.2680300-78-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX6VsmWLU4gfLn
 Buqh4suPHn5nZUD7yFzNQ43L00pGPD4RVeOlz9L9/APPYiZhpi/4CeP9H259acV/IVxAcR/E58q
 zbdDKlKfo9pnDWyjGJ/Rq/reNf02D/bJ28BBxT/dVGWSIxIFsdZQX6i1+l0CvXywtmEtIT2qHKy
 +rwNMMaUZFOZUwQbA/73yLXLNu+QizG8MsJh9CvKZkdSEVTwK2U74eR0AtQRxOpWucC7IGYXwtu
 /iV+pAne3ykySaPlo5u9Hcr3v/PO0WvfO/V9U/Nbro9jMfH98zZ8GqiP9YSQg0MRILVZkRdPr/h
 MuvpbEX1lCx17HbL7GyDCv4Z3cgVIf/+Cwxkv9nGXVmlyT6dyc8+WaeAdH5bpV7sxTd/pCscJis
 I9n7xt+g5cSumZIfI00aiRMTD+gjmkWaovvi0Sxj1yjWWY9Q797OK5xenTB9kLUg22ogQvzAoDv
 opmF//KtRPBUZFhnNkg==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c9594 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=B7vDQ8MdAg9om8iqQakA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX2iEcDUFdI7VD
 Hu+VaEdXDP5gH5bX4h3k2PHv7ZK/oqV0srML5ekMs9IBNVqHfNJjUyd1PTxwNvr2J00QqH4a3bx
 6os+VPs3c/6k2aGTvm4YuakgFa8cqNU=
X-Proofpoint-ORIG-GUID: Och8gXKyiLPcmhJS1Id3UHzGU8J2Uqhs
X-Proofpoint-GUID: Och8gXKyiLPcmhJS1Id3UHzGU8J2Uqhs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla24xx_report_id_acquisition() format-1 handling takes the vport
reference under vport_slock but drops it outside the lock, after setting
vp->vp_flags and vp->dpc_flags:

	set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
	set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
	set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);

	atomic_dec(&vp->vref_count);

Neither set_bit() nor atomic_dec() imply a memory barrier, so on a weakly
ordered architecture the decrement can become visible before the flag
stores. qla24xx_deallocate_vp_id() polls vref_count under vport_slock and
unlinks the vport once it reads zero, after which qla24xx_vport_delete()
frees it via scsi_host_put(). The poller could therefore observe
vref_count == 0 early and tear the vport down while the pending vp_flags/
dpc_flags stores land on freed memory.

Drop the reference under vport_slock, as is done for the matching
increment and by every other vref_count user. The unlock release pairs
with the deallocate poller's lock acquire so the flag stores are ordered
before vref_count == 0 can be observed.

Fixes: 87c20ed7521c ("scsi: qla2xxx: Hold vport reference in qla24xx_report_id_acquisition()")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index affcd87893cd..e88c3a989a51 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4290,7 +4290,9 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
 			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
 			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
 
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			atomic_dec(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 		}
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
-- 
2.47.3

