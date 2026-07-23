Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04E42749DF
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783128; cv=none; b=rNmzy3ZG+yTAe9JElrGQpBLvy4/dSsY4sNmC1vZ9CBJO5WBfIif0pI87M2HBVJZEY7yoRbNVEMWPe33xxMEbwxRN6+dqbAseLmPRls+ihvtkYZD19vSh+kYr1NyjNiMS16iGLRomb2DAizlnWGF3Tg1aMxafObn+EFa9cKsGyEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783128; c=relaxed/simple;
	bh=sSGNVTcAniB3SQQLybVTQri6+UEo5Z/VhS3CoaFj5W0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q01/vAMrBWwWJ6lcSM6mtW0CLVP+avpQmYiwayiNQgNKcpIum2E4bBtOOmjp1nVmOEy0p9C0aRtiGmFDjDSZu5C3XLsiiZ96+r86Rt/ZiErt3m1+k3A7/2qb7uimucf1lxuY429Lr8PP/+f4yfX9XdQIXXYWRErFn1tMrfsX3Qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=RelRAF7l; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RelRAF7l"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4wViq2443756;
	Wed, 22 Jul 2026 22:05:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=U
	1syryFhpYgR/diNiRCq1fB6NgXWbXdkBZF1ozWKqYs=; b=RelRAF7lnslPFQF2I
	5eqiKOpe3W3EpTavjaYBq05ZwcHZyo/04AeNI3ADOEvX8j1Q2RHZ7bgF7eUf8/MR
	AjJ5NWrJkvwfafxSUcwZvEsq13SHtbT5xIBe993Jz0B10JAd69cW70sbmCZL8Dt7
	2B9OE7RFohaB3d9/1wLaEhwuRyi6dV1ZSn5m/kfbGjFRfu86GBcd9bh8UjbDBcjz
	cMVTGOo8exZLj1h0FxIKG9hOhtbWhwcDnhvFRgc07raBjhrvRa/5ILhdVlf39Kmv
	xh310N5/OQVRw8ovqJsn1VkIrSOlrOmWbHjDxm1LgPYzGzcwNpqfjhIt/X46aw72
	0eYyA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm14-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:14 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:13 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 5852B5C68E6;
	Wed, 22 Jul 2026 22:05:11 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 16/56] scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
Date: Thu, 23 Jul 2026 10:33:33 +0530
Message-ID: <20260723050413.3897522-17-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX8SsGt/a0aF3e
 f3dmeKWrZkyoFdIHI81BCHHy1Nc4om2AZXtsXBGYUqQ+S4XyB58GxSei3IeNNWkHBqQYci+WHgX
 Rt+A1xO1BHbbjM4TR2Vy8qwRbeI3vFGa8N6f2APfoPQj5I0uBdZUGsxk4McswaRJjuK10D2qWl5
 Unxdyc/5xw87yfC8tFs0seIaYQUoEDCW81rFe31S8GQUXdzCFk8F3QUdQjUKaF6T0foXAe2wHVJ
 +HLxdjW/Wy7Rcq5+YxQEX3KobDfyO53LG1CjNw7bLpwYAKL8S8uYp+L5SrFHWzeX0Gmv26N9Hh2
 dEP2MVf2lwHT931p+Go4DzzBwXAorwmJkeIKxmViZafwPjPBX9BAhN1TXIo6E9MlCgHGHzZSTRX
 uR72m9wA+oyKXeOfQS5YUni2jt3J1suTZWW6b0DVf9eb3eXfEGG9VEOvHowlNgGJQb7wIL0dmSw
 YmocEKB4GL5dCTl/iHg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX+ChYAqmCoEtK
 kUqtA0Rf/oVpttX1OoKVTmgIEtY/IOYYjufEZbgIPPfoTpVE6T1gou9R0gQRLPAazjENeI9xUWE
 rVpeu0X5Lsm0zd1l9vaogvSYhZDhrqM=
X-Proofpoint-GUID: MfzGvjwIw-Y3uxCGLxGRrbn8xIUffZFz
X-Proofpoint-ORIG-GUID: MfzGvjwIw-Y3uxCGLxGRrbn8xIUffZFz
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a10a cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=wkAKt5TnZquKlXEkUFUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

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

