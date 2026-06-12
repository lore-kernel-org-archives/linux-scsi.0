Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C51385D8D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258178; cv=none; b=MIfjaolhGzvfLAK6u9S4uuzZ5MDjvNyMtPocC2Pxrzs2igM4Y/tetssekvOHSiCM1FYXWi+KM6hCyMwHkPiUxsSEyVVMgp9g9DOO+chjZfphi/JFA13Bb1Mcgxq9b3uBdAY0/UHOuzx+6eivNf0r4z+GqqsBJktZ4fS4sGuxCyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258178; c=relaxed/simple;
	bh=D4OpjH8CEy95h8NB3camy+fk+yEM+WiJYGE58Qvb/kc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N3F6T5bBkgLem/uDDS+uyXhuM84L71JW8o6JjV95bPFg+5cLO3RQcw3tOiC1RH9/+NfHhTCyeIK6bbvvp28bB4GUsbpaVaoWgtZmcnY9YWHoVxc10TRi81nlCbyoXddy4UjeKqBIORthz9J0oufihaSuVcdFwW4jlRJ785CoVh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=KFarJriW; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KFarJriW"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C38x5Y3678669;
	Fri, 12 Jun 2026 02:56:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=F
	3L7uN8yZ68nM830VC7x91DM0brjsi1rgwvaMJ29jJo=; b=KFarJriW2oovVCSYO
	soWQf0upnCrjJ7jG1VNRXE1GlihYeh18ZO/57mNINIWWLGhhvyjgEJniMqQZcqtk
	be5OGEcVSOISwTmcuPZkERSQiMmD67mSgNY63RF6lfILRnH4VtVbHw589XVNZXJI
	YjXu3wmCfAWchQszlp0EN38JVKg32SjwB70TdXtCGOs/mVhq64F3ogK4nXzoHILa
	tkYCTwCCVv//ECeGg274Xn24Go9DBuq/egGVVGcE035YEr1WAPdsOOHIRtRcoeVp
	V5pzDGqJ3n0aXoQdwIGTHNXjQivan62ILkTztRFdU9OZbZuTTisOnIBvfHpEo4Xr
	VIyLg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92n6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:12 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:11 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3FAB03F7040;
	Fri, 12 Jun 2026 02:56:08 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 43/60] scsi: qla2xxx: Convert NVMe ring advance to use qla_req_ring_advance()
Date: Fri, 12 Jun 2026 15:23:16 +0530
Message-ID: <20260612095333.1666592-44-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: rSd6RelJKhecKaXgy64jXZkLnqPvVtaX
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd7bc cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=mV1yb0a6uopjf6N9HjEA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX093UqDJEO+JX
 iL3wKKGBz50xWZlVgv+hYQA1ccFLbq4AS2r7n88QqrRgGBx05pU54iUPytpjG9sSdA4ugjDtDzN
 /XNeP5fWB1qW2Z6LT+jKkTl5PaxOxFY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX8guqsNDIXWQN
 0fzM9/8BtUFSo+WSLLphRo9ABep2C/jcy1nvfPh9DHZdyC/S3E/Rj2rgw/ckTihNyOeeNpdGyos
 UOKmfG5VW0212XOyHmWF2gIbxbFrmt37og90xy/dw4dKh/MpEJ4U79tW8ZVy1+CjE3miJ7gkzoR
 f8ROlkZMKMWGdvSaYxnLnZRlxTDWSPhh1DordfcJXpOKBlIEizjSKNc3xtJIi6Qem7yUgG5Zg++
 7kdL6kV4JdnFyE6vIIGGFXxkkR9zaGovcjKA/ckuFHp1IcHuXQSjrgCrFcgK2obKRpoAF/XAZSb
 rK00l2p0ux+11rtwAelbMLYBvGToXicHu56gHCnaraoIqaxoVmuYX01aYtr7yXdvZK693nGc1pV
 GBB+KKemuZ1pyUKcfLi6h8SMPeOOOfhWBAkFOqOWxoRGGaQDeoG63V7cpz/5tJLy8lbvYCW/ZQV
 Mk3UnD6N71KsvX2VXKA==
X-Proofpoint-GUID: rSd6RelJKhecKaXgy64jXZkLnqPvVtaX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Replace the open-coded IS_QLA29XX() ring_ext_ptr/ring_ptr advancement
in qla2x00_start_nvme_mq() with the qla_req_ring_advance() helper,
removing 16 lines of duplicated logic.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 61a8e9162135..0038b6274d44 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -798,22 +798,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	wmb();
 
 	/* Adjust ring index. */
-	req->ring_index++;
-	if (IS_QLA29XX(ha)) {
-		if (req->ring_index == req->length) {
-			req->ring_index = 0;
-			req->ring_ext_ptr = req->ring_ext;
-		} else {
-			req->ring_ext_ptr++;
-		}
-	} else {
-		if (req->ring_index == req->length) {
-			req->ring_index = 0;
-			req->ring_ptr = req->ring;
-		} else {
-			req->ring_ptr++;
-		}
-	}
+	qla_req_ring_advance(ha, req);
 
 	/* ignore nvme async cmd due to long timeout */
 	if (!nvme->u.nvme.aen_op)
-- 
2.47.3

