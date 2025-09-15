Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D99277814;
	Mon, 15 Sep 2025 18:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757961512; cv=none; b=KzepeQjcmxAaQE9/qE11PaRclFc5V+hsZZy82yXzPvEoV+aMhSCZHax2vy6YGYqhXqOfbBkD6qDAJe3gQHiSu4HgGbSmAOTGAhf828wnZGvcZiLzMWNAhdgMPrFJ+5aEPXRIOPH2UaAydzUYN3K0BsrP7pfZasO8PqKN4k6x+N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757961512; c=relaxed/simple;
	bh=PD4ml/kKgQapP5VRNYxsB/4ndnacacUwgx1YD5Dy+HU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=M1BO13YlCyvryXnEBeyoBTjZxPJ79sHpbGWB0d23OSzQp0TCbkmslkFetYocvjlN6THj42UNmNyeZPsbTiDSEtdh9LW/2aarq1ocsCmVpl1ZCvB9u0vTMisvFLrT9MuFVZbMUig3j1uwkVWgLzUYqn+fRF4w0ideeUseQ+h1ZUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gUCVroGw; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gUCVroGw"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FFSmIY027471;
	Mon, 15 Sep 2025 18:38:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=VqyqwvnFCAn1NBpp
	RidUOvsJe9fID2sfWBF8Tr5hVfg=; b=gUCVroGwdH7JpteKmz3b3PMOyy5SK2dG
	f4iBPJuqdcUj50isOtSzTl3M6dzEEUOkdI3xkJgbhm+xoNhd/NUH9zDzT8Zucn1M
	xosuwlIOFMIHYrPMEVhy824u4Ma0EE1Y6C5C9JEYyDGTDET6sXI3H73rarqdFeGi
	geNvOC2rKfMGRi/CCcSQ6ZxF8E4EoQmwiQLMygfYqrao97A9D+XdBjbWVdZgjzaI
	Lia9MvoHxEYP7ASaTMoDJlNIsjHBSnnxbqX0m9Dqht0AwUd2NgisTo2cK3c00Crf
	aXUu9lTIwA7xMGFmM0hSxCEv8G9R+5R5B8dwL4azUOW02uQFiFVyTA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494y1fk1h6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 18:38:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FH2GnZ037309;
	Mon, 15 Sep 2025 18:38:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2hntjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 18:38:02 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58FIc2QC025147;
	Mon, 15 Sep 2025 18:38:02 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 494y2hntj3-1;
	Mon, 15 Sep 2025 18:38:02 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: martin.petersen@oracle.com, hare@suse.de,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: libfc: Fix potential buffer overflow in fc_ct_ms_fill()
Date: Mon, 15 Sep 2025 11:37:57 -0700
Message-ID: <20250915183759.768036-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_07,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509150175
X-Proofpoint-ORIG-GUID: 9nY-z1dU8vZhaJcC-JXL_JjObV50L3Ok
X-Authority-Analysis: v=2.4 cv=KNpaDEFo c=1 sm=1 tr=0 ts=68c85d23 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=vxlFMlNojV4MJXLBM2cA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12083
X-Proofpoint-GUID: 9nY-z1dU8vZhaJcC-JXL_JjObV50L3Ok
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxMiBTYWx0ZWRfX+fCqioRXASWG
 4WCMNH69AczVZa8JnB3+ClJsiZ0gA2lRlf2YRZbRek7FgMqVVYP8b1Il/tI1iVRaijnCLDqT2rQ
 0TUk+x9oMfNqp2x0KCCrsyzAN74EkgyLZBZ0degO9BbB/KufUz8n8d/9UTHgfcxFFYdzi5pGQwX
 vqRhkYhfpF5Q0xZKz7iakhHobD2CjPcfp/+pV1cXjpDwkhQuG7fef89YnESGly8H6r+eKGqaCaK
 Hd8QNc23hKcC0SKtl86Z8SAp/maNk+iGl0zdPhI6TtEvO9NlUSnBt0dQ5aEgRjw7yzMM/G1xOjS
 v1mwosLSjPPjMDG5c+Nk5TI/xe4mjxsLPQRKGhIEVM9W6CBw+uHovlA0jEgI0CDrg2ZUI1fmaZN
 lgGPPw/AU8KDJD1VsuSQd0QVwDMeAg==

The fc_ct_ms_fill() helper currently formats the OS name and version
into entry->value using "%s v%s". Since init_utsname()->sysname and
->release are unbounded strings, snprintf() may attempt to write more
than FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN bytes, triggering a
-Wformat-truncation warning with W=1.

In file included from drivers/scsi/libfc/fc_elsct.c:18:
drivers/scsi/libfc/fc_encode.h: In function ‘fc_ct_ms_fill.constprop’:
drivers/scsi/libfc/fc_encode.h:359:30: error: ‘%s’ directive output may
be truncated writing up to 64 bytes into a region of size between 62
and 126 [-Werror=format-truncation=]
  359 |                         "%s v%s",
      |                              ^~
  360 |                         init_utsname()->sysname,
  361 |                         init_utsname()->release);
      |                         ~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/libfc/fc_encode.h:357:17: note: ‘snprintf’ output between
3 and 131 bytes into a destination of size 128
  357 |                 snprintf((char *)&entry->value,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  358 |                         FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN,
      |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  359 |                         "%s v%s",
      |                         ~~~~~~~~~
  360 |                         init_utsname()->sysname,
      |                         ~~~~~~~~~~~~~~~~~~~~~~~~
  361 |                         init_utsname()->release);
      |                         ~~~~~~~~~~~~~~~~~~~~~~~~

Fix this by using "%.62s v%.62s", which ensures both sysname and
release are truncated to fit within the 64-byte field defined by
FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/scsi/libfc/fc_encode.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_encode.h b/drivers/scsi/libfc/fc_encode.h
index 02e31db31d68..e046091a549a 100644
--- a/drivers/scsi/libfc/fc_encode.h
+++ b/drivers/scsi/libfc/fc_encode.h
@@ -356,7 +356,7 @@ static inline int fc_ct_ms_fill(struct fc_lport *lport,
 		put_unaligned_be16(len, &entry->len);
 		snprintf((char *)&entry->value,
 			FC_FDMI_HBA_ATTR_OSNAMEVERSION_LEN,
-			"%s v%s",
+			"%.62s v%.62s",
 			init_utsname()->sysname,
 			init_utsname()->release);
 
-- 
2.50.1

