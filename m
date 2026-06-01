Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC0D3546DA
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 10:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309816; cv=none; b=sWr7WiIaqnI8ijGGUkBv+HBxI0moPhy+5i9ZL++SDDmGg/uXhyL1V5c6IgZBKp32ACeDahZz4LeGyFmVZejtVIE6RN3S7hW3OvEP7FzvFztAg9IKbxMO1IWbydBIKsh5e8NwylnmiB+ua8Dqozd5yfOlx3CtNni1WKJyfCtkM9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309816; c=relaxed/simple;
	bh=r4KIO4buiDg7k2NZ+aWFJ2zxuyMaUTMwhTKuI84jqAM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=axgRVJEjMILvifUgUstoQ4M+JGGcZbdK39vrDD9VgNqkzAhHnNREzQjv/xW5UN607OW7Jkh9NK/+7PwlmHn9Q3MGusm0/heNqk3HfikZGkFIS+92P2sVd/B5aU0D6HfvQOTOEKpWR5EAWfLiLrCdfnrP0M/1aYLk9lKZPVm8aQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fkd8Udnk; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fkd8Udnk"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6519qhaH962525;
	Mon, 1 Jun 2026 03:30:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=j
	ndHV5Wyt7iI6Pcg9kQZBIgr87jNTO9kQTX/J84EDR4=; b=fkd8UdnkBuriWVpoc
	6O6MQv2BPlGgwfFsw2Ob6fZp38I8oRlM8/1z3/U9D7MXrJOS2u0JsqM/wjdPNz/+
	cIQgtEKKZrgH/aU8esGiGrlfZdpva0qpnBPdXlWsdLO1a3EHgR7jdBka8y3dzmcn
	RCGYdYBWQaIj6fc96nHAdTcq75n4x0IcjRuZ9jUhpy0Umona6yQHjE/TdVtRrX6L
	Bp/va7FJN3MqGyfVphGayHUsNl+1puyKUZv5iAaftp2Y5geW1MLSpIe9v+IXoJEm
	HJ/JZ3cT5L8SqkzcKHkejihEVmlwcu0nzXJJ57eug5Tyv5iK2lZY92AaCuDgHfQM
	iWGCg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ega3b41ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 03:30:12 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Jun 2026 03:30:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Jun 2026 03:30:11 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id AEB783F7055;
	Mon,  1 Jun 2026 03:30:08 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 18/44] scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
Date: Mon, 1 Jun 2026 15:58:27 +0530
Message-ID: <20260601102853.328426-19-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260601102853.328426-1-njavali@marvell.com>
References: <20260601102853.328426-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEwNSBTYWx0ZWRfX/x31iSHM1tRY
 ueAIV8dCK9aY4eAXV4jxBd18YrF2y4CPjAwa6vLEWMd9PI7xBnVKo1NByY4BPjY3vOuZ/Jg5oHf
 4MqBDvQI7xvFeZHxXuHrstVQO3LHJpgfU1sDYwBYbH/pxMfhojFnvAzVMfIqOtZajDKrfCRIqAZ
 3b8JKJrSW9Z3q3Bn8haPQz07Cbaa4CX21416tKzfeOHzzabYrNIR0y559etb9kOwqhasWu9sleD
 4dt7+Mzj55R2RC57hxV34SiBbShQnEz777gLWusyIdGk1a5SEQ0lvv13SSE9zChLwDO9Z5i7r/g
 3XxNc3YCQu9Kkxh/SFg+PKUQoUhkxjACubbDPo6IUJxF9v52ECAZKOR8ZhWeHJwikwp9UIsu6xp
 wt6inyqRf/mQ8lMnB1ij6myPXlrC13R8CShXGoeMftGCWmvyP0yr2XOig6AzxqkG3xKECBwTwt/
 GPT3xq0wq+ovK1gZ4bA==
X-Authority-Analysis: v=2.4 cv=cLjQdFeN c=1 sm=1 tr=0 ts=6a1d5f34 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=wkAKt5TnZquKlXEkUFUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: _mfjerPybW4rgO2pEsrNV2AAWMPEfA_Y
X-Proofpoint-GUID: _mfjerPybW4rgO2pEsrNV2AAWMPEfA_Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_03,2026-05-28_03,2025-10-01_01

Add IS_QLA29XX() alongside the existing 27xx/28xx checks in
qla2x00_get_adapter_id() so that the additional mailbox
registers (buffer-to-buffer credit, SCM/EDC status) are read
on 29xx adapters.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index edd9849aa719..b89201c29df4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1772,7 +1772,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
 	if (IS_FWI2_CAPABLE(vha->hw))
 		mcp->in_mb |= MBX_19|MBX_18|MBX_17|MBX_16;
-	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw))
+	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw))
 		mcp->in_mb |= MBX_15|MBX_21|MBX_22|MBX_23;
 
 	mcp->tov = MBX_TOV_SECONDS;
@@ -1827,7 +1827,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 			}
 		}
 
-		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
+		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw)) {
 			vha->bbcr = mcp->mb[15];
 			if (mcp->mb[7] & SCM_EDC_ACC_RECEIVED) {
 				ql_log(ql_log_info, vha, 0x11a4,
-- 
2.47.3

