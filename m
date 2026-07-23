Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D13231ED68
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783237; cv=none; b=ObSKLKykmoOW1Lfh/YbZO1v8y/9/XRTvLmibwQ/smJ6BordgkIj2+ABNMeLPt4WYjsXmOSV5oQggx8Pt4bbCXJdabrallB22EG2HvAl1worvRcfBS7YAYWHSVSl8LdKsPUKtft6QK4GjeoNn6pduKznch2wDxuWcPwpdxXB+SbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783237; c=relaxed/simple;
	bh=8EFJVBpLd9yVK+B/EWVFlt4qfAyHG0OgNl+9icrZYIQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L+ml6hIs0Ud0LitiUlbHjj9IIVMxJKlN1f7BrOnCdW/4X+YmKUk+nEKL29lYeMZjrncS/9R1kOcIDGSbe+m9veqBe2S25P+41FrdX5MA2VxfP5/olspnPvCP0VUVx+VaSybC05fwc/L6uNOu9kbz8dkNu23y6DJBRqseV1pfRJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=gYrBiWrC; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gYrBiWrC"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4w0EB422579;
	Wed, 22 Jul 2026 22:07:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=1
	/GEZ4C5NmGKWyDf1qbY8ZcOKdqrA0zvifLdQXLS3Ys=; b=gYrBiWrCKCXQ6NMtB
	hSMY+ven308yDtZCIZMDiGnM3BCL73U/HlyDNlPKqjhOA2l5tcSDrkc14PKFHf/D
	jNAu6Vuq9AgdNepnIcapib2tV10lFmEMBnQl68Dt7/0R3IMjZJmyj9+IOJWG23QF
	tRKBFqoiSK3Fual9VV7UVjesuvZZpltD9rjaLyfYcQo6RpXotteT1h1SYFWysvwu
	syMaPqP66GIOqbSX/Z1dsLf6Oskvt7ayzuC5Nwo/C3GdYwNQHAlprVLODOfacoPa
	CbecsNpJZbxdkLWWDvnjWvsdNEh+PSGthwV4blwvQjeaF7YNvfwEo8vNh7G7Pnft
	53dYA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fjjf8c8jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:07:12 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:07:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:07:11 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 21E4E5C68E9;
	Wed, 22 Jul 2026 22:07:08 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 56/56] scsi: qla2xxx: Update version to 12.00.00.2607b1
Date: Thu, 23 Jul 2026 10:34:13 +0530
Message-ID: <20260723050413.3897522-57-njavali@marvell.com>
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
X-Proofpoint-GUID: o6JkrtkUIBfPpeqyqFP0OuxPofuRG-2Q
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfXxj8OJsbuNdNQ
 zQWsRL3Gb/vTL3gw5i9Q1CmhvEWZY7A2NUWkimng09nZne/2ZD5tQMlaNb7qJDfB9etsUxdRHU7
 +eM6NM1LDwG0BLxmpx5zXzVLHe8hKHw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX+CJhv6Tu/BJi
 woheI02Qn9Gmm+fuU9mXLhA3vUQvh2VTCgBRhjJojUo1vXl01L3JQLhk4eeF+LD0Ti4ImIW5CvI
 LAp/QxslEckpnaZpmuPTZJYTZVI0hOBbqvFb6b9pZque6z4NdDYm+UZf7PFwJ0hyJyvT2DH/Vss
 Qlz65j3ZCecd11fxxHWWdxRnVYQ8xHl9rzOnX7r2HiKUML9kXB5l91PYM15iMKnjUs8S2C+A04W
 DrjzpHX5JmmgELEHdVsZSXv5qXx8gAAdbNjLfiRfX8nzQjliH2MDtbmm8Vgn7YBTT41k2IlnyDB
 t9h3RqMw34UCwfLn8AjedAGIMneAOU7U5y468F+rcJDiD66R8IIkrDuj0WbgDGbPhXZxmmFJcfB
 8B7jHVU2sda4qKsMUBk21ig0SmrtaGoPFTYwXVwdzFXh0bcIlckl7z9sz1Ozl0qI1FVsAyVX17s
 NMqmSF+UJk8ndghS/Fw==
X-Authority-Analysis: v=2.4 cv=Rov16imK c=1 sm=1 tr=0 ts=6a61a180 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=A3DpSSew800dloXByJsA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: o6JkrtkUIBfPpeqyqFP0OuxPofuRG-2Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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

