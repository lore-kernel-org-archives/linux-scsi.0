Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33575258CE5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258098; cv=none; b=sIxRfNtZfQF6Gs1819iMfLKulDqIWBQpx9EB0tVi8NlyWsO5ryt0Rp2pWKFUFLYcDXRk0XsVo8jdE1GKHHBqGEVqRp526rj0OWsvnOnAPSONLkv10wg8i4vRCaiodoHJX6aAaP96L6X7hBPgG7MmgdABypnQBNt8nmps4fwfGII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258098; c=relaxed/simple;
	bh=WComlSeMueb97wvB9SpseDxTOvbXPmPXkYQpcZlboRk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PlzR+r4frJP+8pob2Nynhb/R9pCCVCfNwRU3Y+pq8zpxxXqSu/UVcp+rGBiBnjICA7YyHaNyonq3ANimqFzFt1K+hyKGSObpNZOLajpJdOKSyc98/T6Vhr0uKhwuth3RyZjJ7AfXaDhxCVdUVa/LLdjpCWxyodyU0QLMXcf4KQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=YfIBut7C; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YfIBut7C"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C399xu3678829;
	Fri, 12 Jun 2026 02:54:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=w
	t59MR3E2w/T6L1fuIqoAmKjj4Tqmx5uUlzL0WpfDeM=; b=YfIBut7CfSP3a861I
	tTWzGnYWqjGeA77qk7gigd/DNhJEGXzg7/cwIPWrS16o1xcTRCLGB6zPhiwwJMrv
	eJVXIp73aMG39hqgdmbX53bRXuWfyf/IiHBndTHas27cC7equZ0S6A2PAByra89p
	F5In6WoXxF9WEBiQfOrR+b+bhfDpQyX6hPn3Uln/1wJLmqtAH7gDaBCxDbKyZ15K
	MYSm6WwQhrgerymHJteQdR8EfI+wZWUG4VzC/N09hYF3j+UTldLmPB/rtTBjxoCN
	l8xA/1l5MqGxs9Fz11DFfKo9wtEeyj7h6yIey0Y4aNjHctx4Vdewu3ye7qMn8E97
	6OOAg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92hc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:53 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:51 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A5C153F7040;
	Fri, 12 Jun 2026 02:54:49 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 18/60] scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
Date: Fri, 12 Jun 2026 15:22:51 +0530
Message-ID: <20260612095333.1666592-19-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: -GV2Na-Dcz5hIe9ZhoHNZvKYvV8dUEq1
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd76d cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=wkAKt5TnZquKlXEkUFUA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXyMt7+vdwhWH3
 1DHvlnmEUkJRIbvpa4B7mbYRY2Rz/YRsbWM4Et6QuIglNcy+yC23Ko0hg6wjjYuAsYHnRbNSr5E
 oDSb2yMLqClN0zUZPmT1+i5NV4Dxwdg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX47sihDeAuZaA
 l+IeQgLz+O0ZrGhMFD0SVCIztYJHJf9k+Rd7jXUZO2MAC0rAeYEmQHkQqDL6Zh5s0QPI/jk8Hhh
 Efh/vNvH1XGYQ2pq8uAPOUJvh/DWODOuhpdSuWHhM/zcYSoC6/7XMOC/27cKXnRnNW1WI0gP9Qz
 ZrVDbnSbKJnoLAzmtDbRTLU5rlSbk9qNXamUdFZlXVrK0p/Zi2lUEDaxZk+vow13UWQRs1uLMcd
 ZNXpJgxiH7E813I3N61NN0NkEW9PfiM9mesSkECpSy/SzhUMIBczKE75t95ynWkkKhsEqsK4qL1
 guIQAjK9wdcIOK+qx4KZWQvYa+9+z+bS6CQTRf4gMv4jvWu7qeWKAPLeOdAXnazsz5+AtpOTdMB
 vlTbnpHedjTVCSKlnUV/PTGZPKEGTckHAs8CfiLTlKzOXVqVQktvXJqOYjeYM/40RaN9NNQd6wg
 ofFmDhPCrDd9IxRQIpw==
X-Proofpoint-GUID: -GV2Na-Dcz5hIe9ZhoHNZvKYvV8dUEq1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

Add IS_QLA29XX() alongside the existing 27xx/28xx checks in
qla2x00_get_adapter_id() so that the additional mailbox
registers (buffer-to-buffer credit, SCM/EDC status) are read
on 29xx adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 52d70b61654c..3fc08120fdf1 100644
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

