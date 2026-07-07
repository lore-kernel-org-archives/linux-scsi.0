Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DF1386571
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403902; cv=none; b=miL53Si8OO9/O6BzFVYW0fUW3rz0l9Au0Dui0AncVWsqKf1DBWvAp3Ikf8znIsQ9XVxVC5QtLO8NyXZosDFFE9HUOUhjruJJiGlosPrGNFBPpcyhm4cZTdyBF0E/N1k2cIpsurcN11pMK9YCW4vM6Jcj1S0uglD9QAC2Ned0Zmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403902; c=relaxed/simple;
	bh=F2ZZ81yp5ojbKVe7mPye7IuPD13ES/RuHjHaWjCk++M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WqmJKaBbkDDlR94+d6mKndHws/0kt1SvhgQ0lPBhnFLSTBPpqz6hADs0AqSXj+JisbZPwbaXA1XdVgVZgE6s+pgBuCiGcK9supl057j6AZqSrwJIVYdT3tM8tQkYiOjU4+2AAo837wne52N8ofQALKrw4wdj+i/bS8otgk/hBzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HYw5WEOo; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HYw5WEOo"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748cO51656126;
	Mon, 6 Jul 2026 22:58:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=S
	9U8dYbgno2QqL3r0k134EZn5ZmZYZ49EjiIu/HKl4U=; b=HYw5WEOou/hfmn5Vj
	0Zsuj+bnHl2bt4JA/w7warqNMkLbHnkKt3EE+wxxxt8dN80KvYGs2oh0qB0sAhYa
	idnZWfqHqs6fCG/LF0LFEHo5nIjSfrsXh4UC80YKmZsxXtki3w7Y1/mbbqDPHBin
	X/3DWfWPncwidd8dUSFTAWXn1xRHFIYjxqxmljgMlse9EM+hkTwnh4U2N2clvk2W
	kiIXSPWuB/vMNOPpKM9h7SILd6Ng7veUw88vD2DAVOjaldRcef8I9K7Z0SBFq+td
	EMZSLWdncotcz/Ma69OyXVP5QV8Nw+sFzuBGIm0FK1FhPxR92Ao8uHjAMVL7X7/5
	v/HEw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:18 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:18 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 922FD3F7082;
	Mon,  6 Jul 2026 22:58:15 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 68/88] scsi: qla2xxx: Fix response queue over-consumption in __qla_consume_iocb()
Date: Tue, 7 Jul 2026 11:24:15 +0530
Message-ID: <20260707055435.2680300-69-njavali@marvell.com>
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
X-Proofpoint-GUID: Xl4Z0Q_PqAPgHl-GRN-4gegZisZRU5QF
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c957a cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=jYQLoAwodYzKmHOAwrYA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Xl4Z0Q_PqAPgHl-GRN-4gegZisZRU5QF
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX24e4iarACGXb
 +IHAnOOf43TydQcjop9EBFwq6TKszIsPrGW3S0LEbrp5V9ySk5PWQDucXDzAgL+WsWoTbBuYXHl
 8ljWQzKP3UFESRqn/GWxdQeWG7LmsmE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX970KJDzSHL20
 ymtSIw95h0eI+xARKS2m79rhLVUHiSZefZuONL/IJzG/P53xpXLxpCAp5O0oDAliAs9pllQGpRj
 JoIC7aaHBWMCW4p/vFt/UWqhfanSZZvTci0C73UGQLeBedw4T9kHrUdFF5Ufa9JO8k4JotOAU73
 kt1TjWOSul53tfY9shwcSD6PgByWouogw0z/4pVI+ZxIi0s4N2+/LU0Q5MgxknZ+CJMNnEZbZaR
 0xzMfA1iICfSrqCeQNYCduZD89Mi3U2Wui0fURrRNlVD8OB1yJWr7Oi//yo3/9z2PDDBU4KRh32
 SVejIRm+HY6dz/8SMWcOpAzEYRy4aDm4BbRTlzsjU8eVNtN6B2UPMjl2KzSHClRSvy9JyErrWBe
 RWjGQSquA+p6/Sgst9UyDCK8XELZYamj7A8aAMdXi3Bc8K5JaFe+KbfmBYZddAPihwymI6ZFaXI
 7giRrd+nKvk6wFFnhKw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla24xx_process_response_queue() advances ring_ptr past the head IOCB
before dispatching, so by the time __qla_consume_iocb() runs, ring_ptr
already points at the first continuation IOCB. The function however
looped purex->entry_count times starting at ring_ptr. As entry_count
includes the head, this consumed one entry too many: it stamped
RESPONSE_PROCESSED on the next, unrelated IOCB and advanced the ring
past it, silently dropping a legitimate firmware response. The head
IOCB's signature was also never marked.

Mark the head processed and account for it, then consume only the
entry_count - 1 continuation IOCBs, matching __qla_copy_purex_to_buffer().

Fixes: fac2807946c1 ("scsi: qla2xxx: edif: Add extraction of auth_els from the wire")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index bca052fb3c8b..c36a2c69c219 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -259,6 +259,17 @@ void __qla_consume_iocb(struct scsi_qla_host *vha,
 	struct purex_entry_24xx *purex = *pkt;
 
 	entry_count_remaining = purex->entry_count;
+
+	/*
+	 * The caller already advanced ring_ptr past the head IOCB, so mark
+	 * the head processed and account for it here, then consume only the
+	 * continuation IOCBs that follow.
+	 */
+	((response_t *)purex)->signature = RESPONSE_PROCESSED;
+	/* flush signature */
+	wmb();
+	--entry_count_remaining;
+
 	while (entry_count_remaining > 0) {
 		new_pkt = rsp_q->ring_ptr;
 		*pkt = new_pkt;
-- 
2.47.3

