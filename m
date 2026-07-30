Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A3D443AAB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427180; cv=none; b=S46qJ3pVw6I03htc+ocmue+LjSqQHd91wst3aEOVgUeQvVmXcJcCGYI5vbNvFE8+RKJxCJgV6B9Jog+hWRCveM1pPzgmide0hU7k/I1UHJWcnjMLxO816b0Bhoy1c8F73T6aIU+zHnuMHIwSLbnj8jNu/5BrSPuv/ibFMPQwfq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427180; c=relaxed/simple;
	bh=ZFImb8XlJIZ1Efdibm+nRE5wJ+krOKRdycq0HqKv68I=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aYupclEbRaVJJL0uKAzUkhN/gy8jI8Q9D8U0w+z/hDrcfMiIGj9LQhj5PWj/Jk5sDYuP3LjxEecn5mh/qjdco1rBU2mLLs2admVPsb7g3w2ypbXpKVBUxo6X/M/niDcyiQZyioIS+MFrruMbjPbWWw4LojNj1QWt47gSE9MoDZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DbhANcZG; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DbhANcZG"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFX0Dn1322686;
	Thu, 30 Jul 2026 08:59:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=I
	ZJGmqlMCz7R3QgMDSsyTjWU68L4YgcSXZWtsr+18Ww=; b=DbhANcZGDc7lQ4rFe
	gtpM/VBExr/NclQVSmXOrEPhkNEzbXK0CuM5EjQD+kAGAj1InMHc8OhdE6GTQJ7t
	3By6zA7iLwb8MPFcOOUCep8lyynQw+nFiEx9ghaOOwrRHuYqX8FQozj6FeoB+DYk
	NZs4xCnGL/iPtc9I8Spp2fiQlXL4Kx1nSBJjCrxm7z3gOTo8Hjqwfs3Tys/BQv81
	A2xtWnSANRKYyd8hR44RSpWBNUInW3knTSbfNpZaUWAYlNDzr5i/MnQnrWuH5CS7
	xMDRnNJnKXDNSJPWxqB+JuQTd+vJWP0m00n6A9UzbJn5B/gnv0G7REm5va9q+y4L
	pFDKA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqgv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:34 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:34 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 168BD3F704A;
	Thu, 30 Jul 2026 08:59:31 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 11/33] scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot
Date: Thu, 30 Jul 2026 21:28:16 +0530
Message-ID: <20260730155838.2119230-12-njavali@marvell.com>
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
X-Proofpoint-GUID: ePPntnIuFap1-cu0yD9iQIrBjelDejuU
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXzXv3OHXChRXb
 a3iu1DRqFBzoLcMZVDGrab91w6z4WVVo7oPyJJ07uWWb9xyz6oNKeIDaDE0ILkI5RrKzedz5le0
 fLo0EzozfwLIBTQ42xM9ivnKPRiCfjQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX+2SyObGZ9+JO
 lFZmY7hegpYoALOjbSXnmOf9bbnIHNjaDdExCwY5HWbwmheeGH5fquEE+mp6w8UkSWx/HRQxvWl
 GO2BrIwA4KPf3cBSmlZFgAWiK8gnP1fH1DQLvLIXLccpLdajSHLZWmyziGZB/o4935bp6PGqtWr
 9XBdR5ebCKrX00M5mu9IwQt4iBZFx5wM6+ifLDhnY9lou5wi41kHTR9KEHCwp2Xnts54hjOHcfp
 7yGaOgGNVlRa756Yutc2ik2erlT5Ly2aqOWXDxrNxzWpzTo3NDPcyPLjHIH8vYjUh5fX0aokj+M
 A74qdA1X289vY6TEv7kE9yKhaRB+qNScGfXVpzMs8EfpSvoLQrooS2/kdudiTtdguzVMmPOQQ02
 Z0ZGBcOLRWaMn1YyEjyBEG10umcizBjOXoPm/XQVD0/VD+C+YJ72QoQHH/0CEwqk0b7j9wxaSiY
 tKW6KIq40P8L5yp9wrQ==
X-Proofpoint-ORIG-GUID: ePPntnIuFap1-cu0yD9iQIrBjelDejuU
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b74e6 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=BO8Li1uPneQ87O9LqqwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

For QLAFX00 the request ring is ioremapped device I/O memory
(ha->iobase + req_que_off), not DMA-coherent RAM, which is why the rest
of the FX00 path accesses it through memcpy_toio() and the wrt_reg_*
helpers. __qla2x00_alloc_iocbs() however zeroed the producer slot with a
plain memset(). On architectures such as ARM64 a regular memset() may
emit unaligned or block-zeroing instructions (e.g. DC ZVA) that are
invalid on Device memory, leading to a synchronous external abort.

Use memset_io() to clear the slot for QLAFX00, matching the I/O
accessors used elsewhere on this ring. Other adapters keep the plain
memset() on their DMA-coherent rings. The zero-fill is retained for FX00
because its IOCB builders (e.g. qlafx00_fxdisc_iocb()) copy only part of
the entry and rely on the unused tail being pre-zeroed.

Fixes: 8ae6d9c7eb10 ("[SCSI] qla2xxx: Enhancements to support ISPFx00.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c4595626c16b..88bae1166a24 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2530,11 +2530,13 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	 */
 	req->cnt -= req_cnt;
 	pkt = qla_req_ring_slot(ha, req);
-	memset(pkt, 0, qla_req_entry_size(ha));
 	if (IS_QLAFX00(ha)) {
+		memset_io((void __iomem __force *)pkt, 0,
+			  qla_req_entry_size(ha));
 		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
 		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);
 	} else {
+		memset(pkt, 0, qla_req_entry_size(ha));
 		pkt->entry_count = req_cnt;
 		pkt->handle = handle;
 	}
-- 
2.47.3

