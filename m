Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3748387369
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403909; cv=none; b=jNhT1+1CEULxqK2QJ0ESP+JoqWa3s6USowO+4brJwJ3IDOz3qO+EsFoJUN49K6zm7UngH0okbucMAFtIVAWr2u/rdo1redUBeshx0eF+A+6vvYFgfFRhWGso/MvMmyZ+Y3A/ztFNfKds8j1CxsyDm1D0O0XOtpSoA5XyvJfBqFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403909; c=relaxed/simple;
	bh=HwzvYB5Oa8U8bpkuTtMkmaRSY0vNMMab5TzDhYbu7Yk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L0vucpXVzQg7+hNGQ8BtDeS3hbEUTPbv/y7HPYHhi5rG85mUjL5irdB5EazzqQ+uQZH5Jy/Oy3X/BN+PoS0pEejUL7BR4kN+6At+/Ql12ITOtPy0EkiiQDU/ewKsDsLHGcvAgVJnQqLswWJouSFIpKGxtxn/jMMEVTEBFZq5eqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Qr9/kzdD; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Qr9/kzdD"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747glN854300;
	Mon, 6 Jul 2026 22:58:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=h
	+R0iJv52mLQne+wxGHleNToBKf70ANQoaf2QbL5deE=; b=Qr9/kzdDofLemNDHB
	ty8TmstME8tNTaa1AR9sI5hJg5aN8gYy4qoYxTNH+2PH7odLN07gIXV9jf8JnCXj
	kixncfgqf2hVlxcUhuq1gx06VQ/w7oqN24gfBzD3bN5RvSDd9Zlc4Z/uzML+DlbF
	Ywq5MIbFtkORALMVmKo4V9L/ljfSsFW9Y+YrTo2VZYlxm+G2dC6tVa7tqC2hBKsM
	MZcCKX81anMOUNz808axdrVp8WIV/+HiapkExZ/qpzSCbK/wHYlJmTZQze4ucRqQ
	jUJe6dLqJBn3AQTV1C9m71P1KUE7kUm/jMlOrkyZGFutV64EhhVgl2AJCobhHe3a
	wiEPw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:24 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:23 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 479EA3F7066;
	Mon,  6 Jul 2026 22:58:21 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 70/88] scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read
Date: Tue, 7 Jul 2026 11:24:17 +0530
Message-ID: <20260707055435.2680300-71-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX5NKTB6vUeIfn
 nVMX2Vy6y3QEMEadaYf5QDSpk+LlXJLUFSI+OZYfvZa3rWZ+8PNLD9+nt7XCKwJ02rxD6b1aTKC
 HQZsjh1rijNwGIOtO6A8TnO7NR20P2LNZXG1BqT8vw82FD1y5lUyAVntDvZ4SpYumwWzgOO6hw1
 XNnjbAkz2O+WMFL0w8RHO0/B5fJKjwsyucxCINj00J/hpVhl4Kp4vmFXKdLlcb/+yzy1cZ414rN
 RZsqU0grejyl/9k8tiBaTy0Wu3RKMQt4EaROsAwWtm9HVBAcLp4icqCgxveICAQKZ1h6YXPd+xD
 j+c962KIvcb3gwEE2VNP5TpPW/KY5/c8Wv9jb+QFNA4k6nhk0P9+XdGdonRhkokeMTrJ1UnHMqv
 okhsZ0JVlWVDyNRPABcRAND2scGuWspbWN+09SacUSjm95AmkzOpluLVEPZW45nj177g/+70Rq0
 MukXElbGRMJPhmjgfDQ==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c9580 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=NicNEeuCglI7K_BArFcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXyVR2p2LGLD1l
 syqchMWecttcqtSM+b1PfxP/yjz2sQtKTXc9U4aOYr543XZa/pjIZmyhiEDVNYwsyp+ftQ3X3Io
 Z4xS3AU/Kx5JF/mfV9YHtZH/LVecfcI=
X-Proofpoint-ORIG-GUID: 4dgz2igIrpVqvSkQLqXRER3i1Un-JLsf
X-Proofpoint-GUID: 4dgz2igIrpVqvSkQLqXRER3i1Un-JLsf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

In qla2x00_status_entry(), the FWI2 status path advances sense_data and
shrinks par_sense_len by rsp_info_len:

	if (IS_FWI2_CAPABLE(ha)) {
		sense_data += rsp_info_len;
		par_sense_len -= rsp_info_len;
	}

rsp_info_len is a 32-bit value taken directly from the target's FCP
response (sf.rsp_data_len), while par_sense_len is the IOCB data area
size (28 bytes for 24xx, 60 bytes for 29xx). A hostile or buggy target
reporting an rsp_info_len larger than par_sense_len makes the unsigned
subtraction underflow to a huge value and advances sense_data out of
bounds.

The underflowed par_sense_len then defeats the cap in
qla2x00_handle_sense():

	if (sense_len > par_sense_len)
		sense_len = par_sense_len;
	memcpy(cp->sense_buffer, sense_data, sense_len);

so the memcpy reads up to SCSI_SENSE_BUFFERSIZE bytes from the
out-of-bounds sense_data pointer, leaking adjacent response-ring/heap
memory into the command's sense buffer.

Clamp rsp_info_len to par_sense_len before the subtraction so
par_sense_len can never underflow and sense_data stays within the IOCB
data area. The fix sits before the comp_status switch, covering both
qla2x00_handle_sense() call sites.

Fixes: 5544213be7b4 ("[SCSI] qla2xxx: Correct extended sense-data handling.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 497a0fef742f..91a8344fea6c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3598,6 +3598,18 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
 		/* Sense data lies beyond any FCP RESPONSE data. */
 		if (IS_FWI2_CAPABLE(ha)) {
+			/*
+			 * A hostile or buggy target may report an
+			 * rsp_info_len larger than the IOCB data area.
+			 * Clamp it so the par_sense_len subtraction cannot
+			 * underflow and walk sense_data out of bounds.
+			 */
+			if (rsp_info_len > par_sense_len) {
+				ql_log(ql_log_warn, fcport->vha, 0x3107,
+				       "Truncating bogus rsp_info_len 0x%x to 0x%x.\n",
+				       rsp_info_len, par_sense_len);
+				rsp_info_len = par_sense_len;
+			}
 			sense_data += rsp_info_len;
 			par_sense_len -= rsp_info_len;
 		}
-- 
2.47.3

