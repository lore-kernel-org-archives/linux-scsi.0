Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449541F8755;
	Tue, 28 Jul 2026 04:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785214159; cv=none; b=WR5TaNkAkcaWOlAV258AJknZyGAjpNUHIyNv4vhi9taA4QIi+tfsH4reAFbSzfxtBiK3ntSHX71BH8rd8zGeKluQFLgN311KxCtfCsmptSuuAOjiBOV5RlfqEwTRQijj7NDRVPrbcjfmGx5ejzWX/YqUbOTmhuStXdVBxX53PTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785214159; c=relaxed/simple;
	bh=cX8xCzWw719TCTxA5JGiC1GsjNZaKtOlQzPAQT8oa4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nv266Idw6yDCdtUJt8dcDqHebYyDxxzxohnP7Y4qdVhCKOnBghYrsPsBLevQ1U0/R3sIXXt2qvU7lpOzBRpQDvgu8/SdVWaLVs54hmavuYt1HTdKhrwPtdfT10xElQoogeDA2ABAaIrBj20OJkVV+zKFwOzZmVLCfIHkJHP/LPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CcPrXiqm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CcPrXiqm"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S3m35B4032237;
	Tue, 28 Jul 2026 04:49:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=N3iT6+s1UvHHi0mG9
	Lzyeh0fmDHjqD7OTI7Sc74mU1E=; b=CcPrXiqmOlXorxRexn430MRPdlkDXgwEr
	itegYKBVplECuZlCBht87uBmo1ko3AptmtDNTg9kQdz9RDZiCatvwFjOSiwiLuqx
	F/GyK8zg4C0TBlXGa+Pg8p75u9WXXJXuy+CECp/zjSd6cw4Az10sGf/wspoKOYDf
	coZNQNouIPTpAbf/Eyc9bgeana2v48AlxY/T4tfkHAv11SedIxeVxqnZvIYSC2Y1
	EfDJfgJHnWgSl6woVPf7XWl+KhUDYjVFEnTOb45lNYiMss80T2QdSo1uG+bSIdQX
	DskVZSaXbMd46BkPbNvZBPunRfPyx7icH3IP5kzcV33E56xLv1ryg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0njwfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 04:49:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66S4fK1E025701;
	Tue, 28 Jul 2026 04:49:15 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5y00yd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 04:49:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66S4n9Hf24248980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 04:49:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B884120183;
	Tue, 28 Jul 2026 04:49:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90A2820181;
	Tue, 28 Jul 2026 04:49:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jul 2026 04:49:09 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        =?UTF-8?q?Vasily=20Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntraeger=C2=A0?= <borntraeger@de.ibm.com>,
        =?UTF-8?q?Nihar=20Panda=C2=A0?= <nihar.panda@ibm.com>
Subject: [PATCH v2 1/3] zfcp: Enhance fsf status read buffer tracing
Date: Tue, 28 Jul 2026 06:48:55 +0200
Message-ID: <20260728044857.2532646-2-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728044857.2532646-1-niharp@linux.ibm.com>
References: <20260728044857.2532646-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA0MSBTYWx0ZWRfXyaA6rU6ZcFyf
 v4iZTzJq4JBa9LR1LQcxt6qQ1xNslRTfgFs0LgPMXLTgnP19ASR9riHRj7dp9jmVawKyyQscB95
 r0B7HMyA+t1DiHHLIPiOS+Lh1FJ1aLg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA0MSBTYWx0ZWRfXwbf4kJL8K8Xq
 PZ5Yy/1SNqRzG33OEIVcymYGd8GEz2k6tGyhT7yUaAo+STc8+nOnd3RCFZp9QgvWLZ4ZA/1JT6Z
 D83xYpEslePypBxuegERWg4uW5eSaG9jXhaR64ETtdfU4+auJUjhU/987MPZOtEn7m0S6cgNIe9
 Tc6optnxb3zhxadoPnob+6q9MUGvcPOcD/wtnT73e2cK6cNiSDUToEpnfoO/ojrtWFTdDCbGnwn
 IGZhfpQBRBsrCerXCqhBTaAwimbLFucTLds+Pnat+DxtoQY9yGnH1UxLtYNeU3jf9NFsaG8g5vM
 WEW2/KmnzTHxfGJiJ8IRkZJq7wgSZm5ApAXC4QTDuGk265l9zoDRivx3IHTqPgjO4hB85roDlGo
 A5VPw2yyfIGU1jVOaoggrvNU5fcWcXGGu3NzxG45okRBIXla8vB6V4qy4Xcvw6t5+8FQjtevFMk
 XTCL0pefAHdYHO1/dTQ==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a6834cc cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=Re67frvFl_FtP7PscwYA:9
X-Proofpoint-GUID: DiIsChWvRqPT1bgQr1LCxsAzWtUUiLqJ
X-Proofpoint-ORIG-GUID: DiIsChWvRqPT1bgQr1LCxsAzWtUUiLqJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_01,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280041

From: Chinmaya Kajagar <chinmayk@linux.ibm.com>

SRB trace records are logged through hba trace event zfcp_dbf_hba_fsf_uss.
Presently, this trace event has few missing fields in fsf status read buffer
trace records. To fully trace incoming fsf status read buffer (SRB), the
remaining fields are needed to be added to zfcp_dbf_hba_uss structure.

Append all the remaining SRB fields to the existing unsolicited status trace
records.

Extend driver to get 3 bytes source id s_id value from fsf status read
buffer's existing reserved field res3.

To display this change, we also change the external tool `zfcpdbf` in the
s390-tools package.

zfcpdbf tool trace example for HBA area after changes:

Timestamp      : 2025-08-22-05:52:04:171750
Area           : HBA
Subarea        : 00
Level          : 2
Exception      : -
CPU ID         : 0003
Caller         : 0x0000021e278c07c8
Record ID      : 2
Tag            : fssrh_4
Description    : fssrh_4 HBA, FSF unsolicited status
Request ID     : 0x0000000000004bfc
Request status : 0x00000000
FSF cmnd       : 0x00006305
FSF sequence no: 0x00000000
SRB stat type  : 0x00000002
SRB stat sub   : 0x00000000
SRB D_ID       : 0x00fffffd
SRB LUN        : 0x0000000000000000
SRB q-design.  : 0x0000000000000000
SRB length     : 0x0000004c
SRB res1       : 00000000
SRB res2       : 00
SRB class      : 0x00000000
SRB res3       : 00
SRB S_ID       : 0x0033c048
SRB res4       : 00000000 00000000 00000000 00000000
                 00000000
SRB pay length : 12
Payload time   : 2025-08-22-05:52:04:171743
SRB info       : 6104000c 0033c024 0033c02e

Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Chinmaya Kajagar <chinmayk@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |  7 +++++++
 drivers/s390/scsi/zfcp_dbf.h | 14 ++++++++++++++
 drivers/s390/scsi/zfcp_fsf.h |  4 +++-
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 71f625926ae1..89b859176b8b 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -220,6 +220,13 @@ void zfcp_dbf_hba_fsf_uss(char *tag, struct zfcp_fsf_req *req)
 	rec->u.uss.lun = srb->fcp_lun;
 	memcpy(&rec->u.uss.queue_designator, &srb->queue_designator,
 	       sizeof(rec->u.uss.queue_designator));
+	rec->u.uss.length = srb->length;
+	rec->u.uss.res1 = srb->res1;
+	rec->u.uss.res2 = srb->res2;
+	rec->u.uss.class = srb->class;
+	rec->u.uss.res3 = srb->res3;
+	rec->u.uss.s_id = ntoh24(srb->s_id);
+	memcpy(&rec->u.uss.res4, &srb->res4, sizeof(rec->u.uss.res4));
 
 	/* status read buffer payload length */
 	rec->pl_len = (!srb->length) ? 0 : srb->length -
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index 4d1435c573bc..44ebad8c761c 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -149,6 +149,13 @@ struct zfcp_dbf_hba_res {
  * @d_id: destination ID
  * @lun: logical unit number
  * @queue_designator: queue designator
+ * @length: buffer length
+ * @res1: reserved field 1
+ * @res2: reserved field 2
+ * @class: class of service
+ * @res3: reserved field 3
+ * @s_id: source ID
+ * @res4: reserved field 4
  */
 struct zfcp_dbf_hba_uss {
 	u32 status_type;
@@ -156,6 +163,13 @@ struct zfcp_dbf_hba_uss {
 	u32 d_id;
 	u64 lun;
 	u64 queue_designator;
+	u32 length;
+	u32 res1;
+	u8 res2;
+	u32 class;
+	u8 res3;
+	u32 s_id;
+	u8 res4[20];
 } __packed;
 
 /**
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 5e6b601af980..4b92e85ec71d 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -246,7 +246,9 @@ struct fsf_status_read_buffer {
 	u8 d_id[3];
 	u32 class;
 	u64 fcp_lun;
-	u8  res3[24];
+	u8 res3;
+	u8 s_id[3];
+	u8 res4[20];
 	union {
 		u8  data[FSF_STATUS_READ_PAYLOAD_SIZE];
 		u32 word[FSF_STATUS_READ_PAYLOAD_SIZE/sizeof(u32)];
-- 
2.53.0

