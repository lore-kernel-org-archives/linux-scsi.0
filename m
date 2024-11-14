Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5343A18BC2C
	for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2024 12:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731586238; cv=none; b=mU+JqyDNw0QYw3gMUKNUTGHCqgKEq9E2Zu0IM/Fk1fI0XhAqAoijDbwJeS7zBS/AJvfsEb4LziumIPh3xjr8exHQGiFut6gjDa5Ic71MuEKc94tif4NYNDoUu/mXqv+ivcZ5Gr08vhKum9wIoKyCUeecGP7f42lyndK61ZVfgnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731586238; c=relaxed/simple;
	bh=ccbL6ZorY2wCB5YPVVlRXkCUbXSD2FrtgUQ0o9ksPGk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dFwlq5FXfWLOzUrFkKtzbfPwd1oNrPLbQZllrDhIF1JJBWiTDZD6IW18nFgS9vqbJAw2YjtdRZ3vDWgNzs/z9kwJlsaDiMczRorMjVMUdPhcysRa8FeCMU2/wvRj3JqU7/9DV7sBmWZalujMlWS773av1e3ARnzfyScUE59qci0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=qualcomm.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=I68v1aEQ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="I68v1aEQ"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE6l0bX028186;
	Thu, 14 Nov 2024 12:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=S3bThCwFUBa2oujGW0xdc38Z87JJK4cUU1s
	VCYPeMEg=; b=I68v1aEQbCe8TYWHJxgchwJCEplf9eF7iJyyHwC087uU2jr5DSR
	6RqP7y7FZm4v6g0OAo/p4Ipwd3r2nEEqQ7DUzN36QPkqUgLO3iLTj4sTTiMfW87i
	xHY89DadfKxnqb/M/nh9jKr0UMc124CYrkTBfHlkKLs9TsdPbtyvUoc3nZ0QPQjm
	m+e650PmmQFIuquHC/H/aYyXPvPv8NLs3MPfGE7h4NqLFNjxzUXLhuXAt7wb2Ky9
	ZoyVjTG9JUaqtkZkWCjpc745dOIPPx+qe1auZrJEKXhVumC4vS77lbG+8B+w2zhv
	3SljLl6wBILVMM1aYwpo/XBL/4XJKxph32w==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 42w10juh5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Nov 2024 12:10:31 +0000 (GMT)
Received: from pps.filterd (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AECAUM3012895;
	Thu, 14 Nov 2024 12:10:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 42vwj4rwej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Nov 2024 12:10:30 +0000
Received: from NALASPPMTA03.qualcomm.com (NALASPPMTA03.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AECATIs012889;
	Thu, 14 Nov 2024 12:10:29 GMT
Received: from hu-devc-lv-u22-c.qualcomm.com (hu-xiaosenh-lv.qualcomm.com [10.81.27.218])
	by NALASPPMTA03.qualcomm.com (PPS) with ESMTPS id 4AECATfI012888
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Nov 2024 12:10:29 +0000
Received: by hu-devc-lv-u22-c.qualcomm.com (Postfix, from userid 4148646)
	id 9B2D959C; Thu, 14 Nov 2024 04:10:29 -0800 (PST)
From: Xiaosen He <quic_xiaosenh@quicinc.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: vvvvvv@google.com, quic_jianzhou@quicinc.com, quic_cang@quicinc.com,
        Xiaosen He <quic_xiaosenh@quicinc.com>
Subject: [PATCH v2] scsi: use unsigned int variables to parse partition table
Date: Thu, 14 Nov 2024 04:10:26 -0800
Message-Id: <20241114121026.1951543-1-quic_xiaosenh@quicinc.com>
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
X-Proofpoint-ORIG-GUID: bCboiOfR9uWoaclMnjGXZLRVNNY3HxLu
X-Proofpoint-GUID: bCboiOfR9uWoaclMnjGXZLRVNNY3HxLu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=870
 impostorscore=0 lowpriorityscore=0 phishscore=0 clxscore=1011 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411140095

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
index 910f4a7a3924..df33b2a147f8 100644
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
+			if ((largest == NULL) || (cyl > largest_cyl)) {
 				largest_cyl = cyl;
 				largest = p;
 			}
-- 
2.34.1

