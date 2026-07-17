Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928023F23D7
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302202; cv=none; b=W2uKjZ6+A5OpLYj55906ezb5IVatnlyutDGdelirhZOnnDDpNXUMR1poQRI/PhqeRjUASnOZ00N0KimYLGNbY+PejvzI/v954Lw0uL7O4kFGwJxyMQ3vFQNtXXQXlbPNDhKTNDVIzVStMeyaKChNs0NVINt6vFbrLsE6gR0DsvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302202; c=relaxed/simple;
	bh=sSGNVTcAniB3SQQLybVTQri6+UEo5Z/VhS3CoaFj5W0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bNPqZJR/BOZsMPurEcA2LW1TPH8IvToKrzcw4io9oKGgi0uLEPIbVV+1f3ITPE1ca5bwlVI2mrSEMdW8qjNXlyb1zVJoTTYwWayktdKqY3380F24zdc/T2eHQlub94T/dyPTU2edEn3WmQbhqTJXbj/YzcCWA2ho2gI2zJ33oF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Q3AM+5dU; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Q3AM+5dU"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE5tAH113139;
	Fri, 17 Jul 2026 08:29:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=U
	1syryFhpYgR/diNiRCq1fB6NgXWbXdkBZF1ozWKqYs=; b=Q3AM+5dUsI4gqISkz
	xqG4lmUU2Y1ZBcmaGv6QUvMt1/hxtCFD2jjI2CDClMffgKZdWkTxPU3Xusj4aiv4
	g9FQw29KCH3z1aWTOk5ov98LXqr3VmHkxw75mjEz3LF9eS8svNX+a42zu3BsZnWv
	NDQcONb7+Dg1PolCHwHv5pmqCMKarp4tKRI5fZU0U5fwTvz/p4jOD18l3RU9mi9S
	rN8XXzfVu79o+nhTvcr0e+9w1kCe+M51StAQB8v7fhWywsehz0RT1pA6psgTXlgi
	jt4d2qAzmEowhjyou5NImP0MHBVhnT96MzCB/YF3O1oElgN8H543XlIihyyiN6ZT
	s+sqA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fetcbn14u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:29:58 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:29:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:29:57 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2230B5B693B;
	Fri, 17 Jul 2026 08:29:54 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 16/56] scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
Date: Fri, 17 Jul 2026 20:58:24 +0530
Message-ID: <20260717152904.3155730-17-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IFe_Y5DuwFQSlBWMhXW0KwrKHEC1bP_a
X-Authority-Analysis: v=2.4 cv=Y7jIdBeN c=1 sm=1 tr=0 ts=6a5a4a76 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=wkAKt5TnZquKlXEkUFUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX2s/HLovPM52W
 0j/VoM0ONOnmTRvsNJHzQHYGMu/jEab/9ZZeP+/6sWZD3oCeqERAozNdNuZgnum+iOIHOgSHUeq
 WZdmgpktkWJ7JxrD45nc+DS4witY62Q=
X-Proofpoint-GUID: IFe_Y5DuwFQSlBWMhXW0KwrKHEC1bP_a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX0/3VDb35G2PW
 /ODsM7K38o4dtX6IOU6+yn7ovt/tr0ja5p2bXLLkMezcH/efi4D8r3htL9KxiZjr/j6Ob6MS1sK
 YyUpOHNxdRyoG1c5GyRGogM0q2IjM9PZH4AwwjNTGh6r/UOAyhto+kYaDvmRqszGLwl+ddt5igH
 rXu5FTyye2el/+PNoI3tdFwBnq7fvy3qRQdM1NLQ2rIh77D8zcpZooCvyw40lPhYQF8HlJSTDYa
 u922lfQoyQMUIuv6xs26un5DziBC+F9Rfz8kf2GVUXKhlUx4l9/H7A8zFOnVq7D74P9CsLgrUOV
 OJjW9sLtJGHauGhjJ0faIMXMXmHL3iz1b2eLX2Ri7EXjiOYehqs/bA6LYERZHeo4adHwZLj/Mgy
 pnTybdCdGvwpPQd425wJqBQ5Vw4xKaqBOGXsUWUy0uE9S0cifz7ElrfspBWcK1AYVAArsc8z4+n
 Y517tcVrXAw8XnMArhA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

Add IS_QLA29XX() alongside the existing 27xx/28xx checks in
qla2x00_get_adapter_id() so that the additional mailbox
registers (buffer-to-buffer credit, SCM/EDC status) are read
on 29xx adapters.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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

