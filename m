Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058C327466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403753; cv=none; b=VjuJUDwmCOqjGPmmvT9O5NSNC5D5na7Ue+QtTcErGGcK8uuMpX76VJBu+b6FJE53uezHykqhXp1GQf0ysMeBmUGxGhqaHxiUwMGPZaXR0R/pmS0OEJN3/AE6Y74kvwhcUwRZJxBsH3loPL0ZhXC9g0HuwiSh6DKDtjQ0daTAJec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403753; c=relaxed/simple;
	bh=sSGNVTcAniB3SQQLybVTQri6+UEo5Z/VhS3CoaFj5W0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r3lDrdw9lVgvA3nd74urjdr74u7/0FgCVfmXQwEcAz1ajQJLEPAW1qerLLVdgnV7G/EHW8u5x1osQZp7Af0Bl6ONbqGKB8Zw0npEpup3/yOVZyIl0W8tE5vcO20POQ7fSWr/JMvh79ZLepx9D4o6HGWSOyLxM3CCWHPHyPyXtZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=G1rwF+LK; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="G1rwF+LK"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747g4q854303;
	Mon, 6 Jul 2026 22:55:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=U
	1syryFhpYgR/diNiRCq1fB6NgXWbXdkBZF1ozWKqYs=; b=G1rwF+LKH3p/V7OUl
	zCKXa42xfESS7HpjLuAupYW2DQ2xzPGlUIEApxKgPQeAomOo2J2MAwQ6qwI7g+/f
	+POXAZYNg8lafxmRLgRhCbmFwCn1Cl12hM9aXzqLIBn5vf/hoIxv1efvaBD1kCqz
	1XVMatDHrsL45nK6G+z/y2KLSSlcJgznc+iMISHGKAg7lBZx6uuGnxEmyJK73PFa
	b1PPpfZuCFtnBbuRmcQCCo9S4uz1kPhVsjdg/cq1BCiAZAdeRpGXaqXIk3N7JCKp
	TJLawRoqSoD60EjX+1NRN1ddCnpnshd4B2mE7t5aqOyDiTI8RKHv+/G1TYlZRbFh
	sW+Eg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:55:48 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:55:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:55:47 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 350933F7066;
	Mon,  6 Jul 2026 22:55:44 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 16/88] scsi: qla2xxx: Enable get_adapter_id mailbox for 29xx
Date: Tue, 7 Jul 2026 11:23:23 +0530
Message-ID: <20260707055435.2680300-17-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX3AO47MJexEXY
 ZsjnIkYSXguSjV2ocGfbniN4foNdN3gqz3WDCS2QzSAHo1KISxrgQjC4WDR5IyVtr8fv5dKywTq
 k1Cl/Lovhkng3WBaOV2NayJsSev7AZUuH3gk5lEt+MMBkdNvGZ7DITG68/yhRJvWyvgMo04vMX8
 i48ESqAHOqgfTdqmQVyBoe6RrHBl9IJH0XUQHl5VkEtLPZE9QhD8wbXUYUrif6sKf6n3+V97qWp
 WFRexULJfBIJlNXgVRvNPsoQQeAQocwXsu92EBPc7IVczR7MpfQo+LzZl3T+OyAjyqP72sfdkiD
 z1EmOApQMShZhm5UNTSO0M9gZmKKJIQ1fdoF4Zg8ujIHU01xnu6Syny54XjcOhszygGJk6Gb4Nb
 Oi0VZD5NvfHwS76uy3C0M2squWodxjSiB3xWZdGb4VewPorvb20YjHPUts8nUPg3FmVsEP92bVg
 i5IgDlxe0wvlBZgLiVw==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c94e4 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=wkAKt5TnZquKlXEkUFUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1MyBTYWx0ZWRfX1B8WOodUoLyr
 CpSq8NWNfOaOpEAEd3jhodq+cAt1WYJ3XQ4+5s0fWi5UFj1FdBJRiX2Jw+m/ZT7KEdDvDhp8ziq
 ZGC54X5q4//1ZdH/VMX76HSUPFcJOAI=
X-Proofpoint-ORIG-GUID: rhA824HtUzfKjbG7DkXntH_wsk3RYMzw
X-Proofpoint-GUID: rhA824HtUzfKjbG7DkXntH_wsk3RYMzw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

