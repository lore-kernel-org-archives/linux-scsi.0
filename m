Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7FF3201
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 03:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731639802; cv=none; b=YyyMbkRxUa4bE9EkdYuGgsK4iGEdZ2T0SeyMQHeTUR68CKekEephVhpuoUp2AqI/ebg0DcIQ2x4S02lv9jT9Ciht7ArnvD+RN8au7tT5dATsVTA6Tva256+CLeitFxmt4BIs6n2+S7i5kvOxX1gvtazqKJnNMCMKbZjdFZWdcz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731639802; c=relaxed/simple;
	bh=XfyE+WVSl9fWGxsU/ibTw1scxCNTLyOJxU4hQbPkY3M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VMKsTapHKgeiGubNt1WQxgx6Bx+jd+MxCKBOtNldU9QB1Xa1TG7UoVx4qzcpyQyJKWOJlgkPXPvhNT87v1rty1exFFvsi3zjMIY3A9xoaqWNIDUFZWbOsyHpUMLZvat6bzDZQj8P2tupE66apj5gyRl8Dy6NogIXgFeEJ67I7CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=hcXlPJN0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="hcXlPJN0"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF2IWSE012771;
	Fri, 15 Nov 2024 03:03:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=nT0giV9OnZpKNZBS3u96sSDnCdXzWworwVx
	0NoontBM=; b=hcXlPJN0Ha/znQAJiLpwcSMNpHIEYH021i8z1qPDy91SRThBOQF
	SghOA37NIK/8IvaidGDqk8+q6jHCXWJegOfaRhzYaDKpLl5UxqKTszHvIhgyUIo9
	RlgGI4QiXxpNd/EcNpv/xhZik0+3uQo2U7CmtJL2J4gXY4uk0uKTDdjmwZp9JjwG
	tSAszgVRB+XB3EOxn9cpFJBW5nFUv3s3y+WPOwIIqcFQjh4pOA0fud32vfX3/vPF
	kp2qsruo1KQxHEGKb6S+PlbDO4VDnG9L5x+QcpynXL62OkHV17Eq49rL1kDFvlZl
	n8Dx4qRpftrSpayPWGs1nNThr01MVUHDjJg==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 42wwdd82s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 03:03:16 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AF32tcs019008;
	Fri, 15 Nov 2024 03:03:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 42vwj4xjh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 03:03:15 +0000
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AF33FKP019499;
	Fri, 15 Nov 2024 03:03:15 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-xiaosenh-lv.qualcomm.com [10.81.27.218])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 4AF33F7Y019485
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 Nov 2024 03:03:15 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 4148646)
	id B1C7259B; Thu, 14 Nov 2024 19:03:14 -0800 (PST)
From: Xiaosen He <quic_xiaosenh@quicinc.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: vvvvvv@google.com, quic_jianzhou@quicinc.com, quic_cang@quicinc.com,
        Xiaosen He <quic_xiaosenh@quicinc.com>
Subject: [PATCH v3] scsi: use unsigned int variables to parse partition table
Date: Thu, 14 Nov 2024 19:03:03 -0800
Message-Id: <20241115030303.2473414-1-quic_xiaosenh@quicinc.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 75nGNrquI4kZr7nbgwunouyr8W1b_O0C
X-Proofpoint-ORIG-GUID: 75nGNrquI4kZr7nbgwunouyr8W1b_O0C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=863 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411150023

signed integer overflow happened in the following multiplication,
ext_cyl*(end_head+1)*end_sector = 0x41040*(0xff+1)*0x3f = 0xffffc000,
the overflow was caught by UBSAN and caused crash to the system,
use unsigned int instead of signed int to avoid integer overflow.

Signed-off-by: Xiaosen He <quic_xiaosenh@quicinc.com>
Signed-off-by: Jian Zhou <quic_jianzhou@quicinc.com>
---
 drivers/scsi/scsicam.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsicam.c b/drivers/scsi/scsicam.c
index 910f4a7a3924..babf7f0b5178 100644
--- a/drivers/scsi/scsicam.c
+++ b/drivers/scsi/scsicam.c
@@ -126,13 +126,13 @@ int scsi_partsize(unsigned char *buf, unsigned long capacity,
 	       unsigned int *cyls, unsigned int *hds, unsigned int *secs)
 {
 	struct partition *p = (struct partition *)buf, *largest = NULL;
-	int i, largest_cyl;
-	int cyl, ext_cyl, end_head, end_cyl, end_sector;
+	int i;
+	unsigned int cyl, ext_cyl, end_head, end_cyl, end_sector, largest_cyl;
 	unsigned int logical_end, physical_end, ext_physical_end;
 
 
 	if (*(unsigned short *) (buf + 64) == 0xAA55) {
-		for (largest_cyl = -1, i = 0; i < 4; ++i, ++p) {
+		for (i = 0; i < 4; ++i, ++p) {
 			if (!p->sys_ind)
 				continue;
 #ifdef DEBUG
@@ -140,7 +140,7 @@ int scsi_partsize(unsigned char *buf, unsigned long capacity,
 			       i);
 #endif
 			cyl = p->cyl + ((p->sector & 0xc0) << 2);
-			if (cyl > largest_cyl) {
+			if ((largest == NULL) || (cyl > largest_cyl)) {
 				largest_cyl = cyl;
 				largest = p;
 			}
-- 
2.34.1

