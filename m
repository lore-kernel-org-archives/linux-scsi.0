Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E140D15E5DC
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784023019; cv=none; b=d1hqWZcR3jQ9Almxi7HqnvZN7bVFIRHaLb7BQqdKZ3h3yIzhqqWtVrbw4Umh0nIsLo4CrDuWr72gk03TPGjhQTHZ+a4NxgiCBETCugzL0W/b4McWL6KMKcOQueAjoN7FgdkmGWdQm/+kRS61hotV7N8FF7Cf7TiM/lXtTHZv5Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784023019; c=relaxed/simple;
	bh=z1OG++VA2DZC0ndvEW/Mn4o/qYcKQ4QDLEOG6NA0fKo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RzcuFf/GspTBd807FJzx6mgMMnPVtmsVRA4pbRRffOpwpcB8oCblKfDIhOiwhlW3sRx3L7Ct8RJgDttCg0EV7SREW0D16Y1q0LafKXXbpsFyn8SPabKc/aIsJQFofgIoWGsMRqEngYYgPByUQ3PFUexPgiQ3FNUAs/L7Pj5gPO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=a1KJ+p/r; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="a1KJ+p/r"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6UDUr2407822;
	Tue, 14 Jul 2026 02:56:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=P
	Z8KuWBuTohPk3rqHF5P7xyNSJpfEqLHxxSIDgjTm+8=; b=a1KJ+p/rEx1VtAqxP
	ljbloqwb3gVbv/2K6TwhKWnaOdly/c4ZT5YJpcWvpeoIXWkQed/pRhDlZF8gmQVZ
	rx0f2tN7WGe0ETeQC1A1Za4xCZq1IFZj3Ld56T745SBcqUCUalf3LjgoTR30ky+g
	H15ApDx1IKForN4B9bMaeYGxyVpE4KXSc3WWxVyHBQittw1GEo589/DDxVQRiHdu
	jv0Ay1N4YZqAjP8yzg1XJL0EvxP+c3a7nhm+ErGsfkz57G0wtOxoZuooS7v2Sbwk
	8tiJSHS/yrHxtjMYYB9dqdInuung9dEz7YTf3NnFbFuKtAg9VcYuZy4ek3musdY6
	4EbTg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fc6k9nqd2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:55 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:54 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:54 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id DEC6F5E6867;
	Tue, 14 Jul 2026 02:56:51 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 56/56] scsi: qla2xxx: Update version to 12.00.00.2607b1
Date: Tue, 14 Jul 2026 15:23:53 +0530
Message-ID: <20260714095353.289460-57-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: SubzKEQ3eFlG28j2xtg1IlvKbYRKuNhT
X-Proofpoint-GUID: SubzKEQ3eFlG28j2xtg1IlvKbYRKuNhT
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX60s6svP2c0IE
 tcLuo0EviWrgwuzbVE2dunLmhwqy3D5WGbRIbiZsvkbY3ADqQYbQilXVgnZu0VbUbEnZXfu3sLi
 6er775XuKPhuGyOWdYD7KsdSjoSD/AU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX3bXvIc8Z1ug0
 bxKeDZ1c4X+G9bP0oDh14cw4Aui325zBRTX4QqIq7ZjdHs9nWFa8WeKE56oyj/Njz3j8yU9T3Fm
 6ahNimRH6sxrMrax+zk8FtNU1gMwb5cWGGrMDvceFBJcMHg52aC+FbkLj+d0mPZMxI5Uw7uciJY
 xhyodenBP5LNWT3LOnC5SIMs2P+qVI7Q46XU7lusAfQfXkQ1SWF/Kxpfh76KgTII2U4XuiT/di6
 O3Aif9Kn2bToxswGi7VRDkEIUrLXn7rhwb8Ne+GfKxzyGgnMb+1ji2u6UrtkTP3hwSwGrObGwFt
 9T2Sh2C9ppPPq1PLP1S0iAKp/RpJ0EGooqckbOOwHEbU0AKzpP/sgKiqqKAnDLUsyUZpfWFFQF/
 XeP2q0+h4iGnYAF34Vz7WMMRixwTRAAPs7qzJsbsQxZ11Zfoj/ZqeUShREud1fU1jS3kxC7IIKd
 VMPmFnDgQ8Tz9D+s/AA==
X-Authority-Analysis: v=2.4 cv=ULLt2ify c=1 sm=1 tr=0 ts=6a5607e7 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=A3DpSSew800dloXByJsA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 9564beafdab7..1c0b01d70350 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.10.100-k"
+#define QLA2XXX_VERSION      "12.00.00.2607b1"
 
-#define QLA_DRIVER_MAJOR_VER	10
-#define QLA_DRIVER_MINOR_VER	02
-#define QLA_DRIVER_PATCH_VER	10
-#define QLA_DRIVER_BETA_VER	100
+#define QLA_DRIVER_MAJOR_VER	12
+#define QLA_DRIVER_MINOR_VER	00
+#define QLA_DRIVER_PATCH_VER	00
+#define QLA_DRIVER_BETA_VER	2607
-- 
2.47.3

