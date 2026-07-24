Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26512768EA;
	Fri, 24 Jul 2026 05:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784871603; cv=none; b=u3x48Ozu1DEJT78A8YHrEl9Jm8YKzt7hkjtQmpjIcFhB3VdAA+SftU4deqWQ7XXbHYJd/ypa7iz5gHbLp9KgKewzM+Kym7WKlzIzayuRYkIMP2n7BTzoM+w9h9+LgjnPscqogF2kuz9Vzz4tgkHJhHhyFDt6qrLMTst0sE7bxwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784871603; c=relaxed/simple;
	bh=cX8xCzWw719TCTxA5JGiC1GsjNZaKtOlQzPAQT8oa4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZkpF3uLu8lDzq+T0fitMd4pv7NwjJ9SfU1uZkEh4mBRLOUKnr6EpiL3oZ8f0GAKmfC+3vJPmhDoToQkU5duRTgqLvkFVgPyosUD8ZnICwuFVtCUKkFmvxuYdwHUfJYwxFOYliiO4zAxykMcDNUpUPHjC6xPZXXLa0xsdYQdbyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JTd4rJ16; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JTd4rJ16"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O5C5Dm798515;
	Fri, 24 Jul 2026 05:40:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=N3iT6+s1UvHHi0mG9
	Lzyeh0fmDHjqD7OTI7Sc74mU1E=; b=JTd4rJ1684cheI4GBICWJdWjM4c9fskkP
	1r0h0hTYRuCfKfOSI956m5ylItJTcLMOEOk/8//Om/jO5vbuRJSUFP9vFLjP7RcS
	d8h/39zKpUlSurzzFQs4h7oiNiEC2OS8syiRZrABCRdTAQTywG3CRxIxngVgZ1LF
	7dUtmAlqE+hNobfMR+fKoD1uV6MCMMxGQ1qHOyTbQY6m5EUHKj4UAfch8wmBexrH
	1v/+pzJQgbDAx8DApeVutWRmyXFfRpTg+6nU+NZvJk6M4f/3H280s5LdrMGwWKIH
	b5W5XZA0nsSryPQ+FmGp9gsrr1BJOl2egTEkdgtiY3Yplz5gB4xIA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg78gjh0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 05:39:59 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66O5YeF9031985;
	Fri, 24 Jul 2026 05:39:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgpgyqb1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 05:39:58 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66O5drSW44040584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 05:39:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F81D201AB;
	Fri, 24 Jul 2026 05:39:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37CCD201A9;
	Fri, 24 Jul 2026 05:39:53 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 Jul 2026 05:39:50 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        =?UTF-8?q?Vasily=20Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntraeger=C2=A0?= <borntraeger@de.ibm.com>,
        =?UTF-8?q?Nihar=20Panda=C2=A0?= <nihar.panda@ibm.com>
Subject: [PATCH 1/4] zfcp: Enhance fsf status read buffer tracing
Date: Fri, 24 Jul 2026 07:39:31 +0200
Message-ID: <20260724053934.2781087-2-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724053934.2781087-1-niharp@linux.ibm.com>
References: <20260724053934.2781087-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA0NSBTYWx0ZWRfX0waz9uf7TpZN
 505PI26YcW1/i4Qpb4l3Rf4oxyAJWw/cBVbh9a8xIgIhRSKo3iCaa2AVQzZRkOwrsoXfx25837/
 tzF+cARt0uEkuxWYWTV9K5DHkUNzE0HNeAlyA+QY/mabbo3qGYantZfmseMK/rQ7xIh1b7t4WTI
 FnxJBYas5HzV5SL3oZ6iLxkBlMY9PRXwKGjq/pfkZvKnj8G5bBSlumjXGV92tUmDJmnouxBsswo
 /tf2isbNmlgc1AJzVxUq2JgaxBTZMKGigDPkE2iKmkzQyDLnGgkwpTH5kWlk7u9ycoorU54+esU
 MlpsFptW3HMTuPxLLIy2Ml/8KclbJSnIqKiMLGJxnDFQyjwdhRhcx4+NroIl+wgk6rFRntODbrk
 sugEYZ18ZS+nd1PJ1fbO3d3rxuVGqJFjh3mkR5I2YTA88cH68f4vSnLiGOqVqRSu4ZqypBkzg2h
 2C0U+AkgaVlDdubK6jQ==
X-Proofpoint-GUID: r3fKY9GWliiyCV9FcvcudR5uoMxZ9LJg
X-Authority-Analysis: v=2.4 cv=MelcfZ/f c=1 sm=1 tr=0 ts=6a62faaf cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=Re67frvFl_FtP7PscwYA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA0NSBTYWx0ZWRfXxAEnFfuiDtbR
 xSm1Mvz4ldNaZP131HGWwFPm1oAlArLc8y7rmRq77+m5bEHkcynD6/zyZznYnP9zbV6ZOddKWVj
 H+s3rYszE+1KUmYFKXBBL/Pk+hXv43c=
X-Proofpoint-ORIG-GUID: r3fKY9GWliiyCV9FcvcudR5uoMxZ9LJg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240045

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

