Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC2C1EE037
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 07:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731569389; cv=none; b=AViAza0pw1L504n0QgxgFobItkbUhIIJolATaacjLx3zAgNHrBLZQDnV07/D+nxbyWmhVkNqKTDhpZC5GCXLYK8pJR4+9T97ePg98yvIN1Q7BFqbF/lXqxhwP1oZ6lkThvQijisD1skTvmxCJkQJ6OimVSvQc+3QJ4FhAmFNqYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731569389; c=relaxed/simple;
	bh=5EbDZQM1JGCfpI96RJtsU6mqVgnQAECswhsphIx5hko=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=UvD0uP2kfxx/CZaF93fpzaLAFAME0FnNmCT4M6N2f1A6AvNrOHONNbnQj+DYGb/ZPtz9anLvunCVhSVYC5qZVhlQABoRHzGLT/noOWvpoY5Q0gCmroLjBIfRJoUpsmcz20ywvYOMajPdXPTJx7j/j9evgwDGacUY6zqUlUfBt+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=j9FUCvj/; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="j9FUCvj/"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE6JA2e001025;
	Thu, 14 Nov 2024 07:29:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=DyIBLrz/XagdyJtls+gIMG8Uj4T7YE9khfE
	LCV+PKmo=; b=j9FUCvj/hzWHuhLJ4sCkyvMNo3BwUtR+eGotr6q94Vky8AkL1Tb
	cinBFDznbVKU6RiWCTpGshSaMVKE6nqMu1Dk4EDKH8CvkhgR5ErjpkTWeBzEJ0Km
	KYH+VTukWfAVADrNBXOhxIf4Fjigz7h+Eo2TwMs0LIr5vpGoWHzxW5ONq/sE5Bgm
	FpoBPt/gNAWNEZ08XaF+DlB4pilt2a+MQxbdeLIuNrkWVENDyjKFR72YRU7NbKNW
	fZJhN/prNX/9L9c84z6OFQwzk5PA0fFPDQ2lOhZyxrhZ/5cr9tghJ3XlBnAwyAVN
	ugmn44IT0FeCgRuwX1BFZS6IkTdQWQkkggg==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 42vqbm43tp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Nov 2024 07:29:43 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE7TghH011343;
	Thu, 14 Nov 2024 07:29:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 42w6fdu1af-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Nov 2024 07:29:42 +0000
Received: from NALASPPMTA01.qualcomm.com (NALASPPMTA01.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE7TgS5011338;
	Thu, 14 Nov 2024 07:29:42 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-xiaosenh-lv.qualcomm.com [10.81.27.218])
	by NALASPPMTA01.qualcomm.com (PPS) with ESMTPS id 4AE7TgRW011335
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Nov 2024 07:29:42 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 4148646)
	id 5DE8E5A3; Wed, 13 Nov 2024 23:29:42 -0800 (PST)
From: Xiaosen He <quic_xiaosenh@quicinc.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: quic_jianzhou@quicinc.com, quic_cang@quicinc.com,
        quic_xiaosenh@quicinc.com
Subject: [PATCH] scsi: use unsigned int variables to parse partition table
Date: Wed, 13 Nov 2024 23:29:39 -0800
Message-Id: <20241114072939.1832821-1-quic_xiaosenh@quicinc.com>
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
X-Proofpoint-ORIG-GUID: 9wf_NrDhrp1s2Jjwkji--6wtJqnhCLBw
X-Proofpoint-GUID: 9wf_NrDhrp1s2Jjwkji--6wtJqnhCLBw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=870
 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411140055

signed integer overflow happened in the following multiplication,
ext_cyl*(end_head+1)*end_sector = 0x41040*(0xff+1)*0x3f = 0xffffc000,
the overflow was caught by UBSAN and caused crash to the system,
use unsigned int instead of signed int to avoid integer overflow.

Signed-off-by: Xiaosen He <quic_xiaosenh@quicinc.com>
Signed-off-by: Jian Zhou <quic_jianzhou@quicinc.com>
---
 drivers/scsi/scsicam.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsicam.c b/drivers/scsi/scsicam.c
index 910f4a7a3924..544a008ea422 100644
--- a/drivers/scsi/scsicam.c
+++ b/drivers/scsi/scsicam.c
@@ -126,13 +126,14 @@ int scsi_partsize(unsigned char *buf, unsigned long capacity,
 	       unsigned int *cyls, unsigned int *hds, unsigned int *secs)
 {
 	struct partition *p = (struct partition *)buf, *largest = NULL;
-	int i, largest_cyl;
-	int cyl, ext_cyl, end_head, end_cyl, end_sector;
+	int i;
+	unsigned int largest_cyl = UINT_MAX;
+	unsigned int cyl, ext_cyl, end_head, end_cyl, end_sector;
 	unsigned int logical_end, physical_end, ext_physical_end;
 
 
 	if (*(unsigned short *) (buf + 64) == 0xAA55) {
-		for (largest_cyl = -1, i = 0; i < 4; ++i, ++p) {
+		for (i = 0; i < 4; ++i, ++p) {
 			if (!p->sys_ind)
 				continue;
 #ifdef DEBUG
@@ -140,7 +141,7 @@ int scsi_partsize(unsigned char *buf, unsigned long capacity,
 			       i);
 #endif
 			cyl = p->cyl + ((p->sector & 0xc0) << 2);
-			if (cyl > largest_cyl) {
+			if ((largest_cyl == UINT_MAX) || (cyl > largest_cyl)) {
 				largest_cyl = cyl;
 				largest = p;
 			}
-- 
2.34.1

