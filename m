Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573C5267B07
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783127; cv=none; b=isOk6vqPykTcys3TLZf8nNTaHr28JPfLNxyQHrve8Mld5L0omQQ3gy9YnkTi0ABNeYudyF6KUExAeoV0yyEhZVrOuS6wrBoOcdEpsLc6luBFbanboVhBOOAZnLFqWFUpj0dmOwSf/r2uDn/V/UYlOxEXWFvY1rpXNVcZi2ARSv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783127; c=relaxed/simple;
	bh=O5knRtT+d97oCfAoqril+LE95roCfgFhwer7GA3+d2k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/zXUY2BDUmre3HNf/1s+H5SYoTlEOb4jYKjaHBLUBB28zf14qNIslaTYjhB+WEO7hRYILti7s+zL6UdvvMsgaws7IxRELLrIqjFOl+E+T0032CVIO3YI/5KsMNk+1HOk59G+Sn1l978WKODaE/RKOS33WoC64x+EjyZL5zE6bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Rk0A4zS7; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Rk0A4zS7"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vx2W422563;
	Wed, 22 Jul 2026 22:05:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=e
	2A8NhhoajjTOzRyvwUE8lXT41UBpCY22R46x4J7zlI=; b=Rk0A4zS706iJ9VGMs
	bvD22JepvR124bTn+UmT8yzu+JzBe7/j8ut+McrVwKF8sCzJwQPziC2XTe2nTiXK
	4uEmx02PSaSzjXG5LRr6ISXgvk9qGamfjugizETqokIoGxR/GiEUGNIGyS5PAzJB
	R/n2iqRL4Ww1xwELzdgvgBdi81lgBVYK4hQmhCq30cnPEVuey7fJEjomYbQqbi9F
	N1rQS7jELnrwwQrL6czKRO+BBlZ2yLGZTEj51gPTEvmsq6ZM6n8MTlFWMsk5ZoZD
	VTjKGJHGzTTfRdB2jLTfet+9NlokjfrBFOF11NIbsxp0Zr6o0CU5y/fkP8ensVmi
	FOdVg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:05:17 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:05:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:05:16 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 32EC55C68E6;
	Wed, 22 Jul 2026 22:05:13 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 17/56] scsi: qla2xxx: Enable init_firmware mailbox for 29xx
Date: Thu, 23 Jul 2026 10:33:34 +0530
Message-ID: <20260723050413.3897522-18-njavali@marvell.com>
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
X-Proofpoint-GUID: dAy-0BWkLz5v9crJ9FbYevAnn2cJw642
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX++E6/YBfGeOv
 Nz4uNrysCN4yMzGSU+ePv3AMljY83h5crarq8DIfHXYEDvqrDcuX2ezYXQ8U9Sny3EpuLZ90owl
 S5xBf2G1QcnO9bazCuQVyqln/x8HVKY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXz2rCIC5T2ziI
 asgzFQa2xTu1vRU+/MYw2AVABmYjCiRq3EbNsRNcwzvr1p+FqzeXQhjCFaijk5crdiRUQeeC++9
 8nsH8aIOl2G10vIlLWCxt7Xn47dn/Zy8GGG4yT0KXer2AoxvH1fabtfZn5uwEWcUenGV4oMPJdw
 rVUj2xfOS5T2YJcxG3Jpe6yJH1hdzX6IPzqOc2NC/A0eoE7NyO3hBVQMybhcB+aP6mp7w5qFVwF
 /6PBWZlVZP/97wS9iQMJY4OcjsfNYbwuO9e6Cpps19sIi+KXK7gfAmI4q+xqq63oISLCijMKH9y
 1z0qnrgUqfyJfH5TfRdembPtPyryAR1S2z1Ri/ZWNk2WcGBkRxqxOgPfUgDYiG9/0zcBKfVihf4
 O0ESs/IUhdDdNLgL4DV9Zs2oMCCQKj9S5zpLa8M5+41L+J/DySHs0CMWJ8ac8Zly/i7DCU/SU/V
 lZ33bg4Y3FeK1ltdC2Q==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a10d cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=D95N2Pj2omZygidu6DcA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: dAy-0BWkLz5v9crJ9FbYevAnn2cJw642
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

The init_firmware mailbox command needs 29xx adapter support for reading
back SFP information via mb3 and for validating SFP status on successful
firmware initialization. Add IS_QLA29XX() checks alongside the existing
27xx/28xx checks.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3fc08120fdf1..9c78aa66e12b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1968,7 +1968,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 
 	/* 1 and 2 should normally be captured. */
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
-	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
+	if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha))
 		/* mb3 is additional info about the installed SFP. */
 		mcp->in_mb  |= MBX_3;
 	mcp->buf_size = size;
@@ -1992,7 +1992,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 			    0x0104d, ha->ex_init_cb, sizeof(*ha->ex_init_cb));
 		}
 	} else {
-		if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
 			if (mcp->mb[2] == 6 || mcp->mb[3] == 2)
 				ql_dbg(ql_dbg_mbx, vha, 0x119d,
 				    "Invalid SFP/Validation Failed\n");
-- 
2.47.3

