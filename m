Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90DD26E6F2;
	Thu, 11 Jun 2026 05:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781154380; cv=none; b=ENnY7QVMrJ/PQ7Da+EnAUnwojXMRajCkCpaeC6DgIhIgqeST5jfXFctnWOfNT0IHUHjYu3mCltUXiTaIzk/K06Ej9LZf0XScZNzI3n66x48nzWB3DpnWo8559FHwQlE2GjgeqXFVFs3LmqyvN5BuNfqhbsHFIMDiT+ODgFZj0jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781154380; c=relaxed/simple;
	bh=Axo7PVv3pGQs6+INWSj8o2vO7n3fItAFqMh8cY9tb5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/kYPA9/7Xmmr9JBhVGPP8gNER0NQST1owKPs4GMuWBoMTXBzCUrNuBuC5MmqE7w7MstopjARwqV76tE0wf7jPZwymdpmVVchOtel9/M3+CDR9bMmO2y4v9upT4Kr+HT7IUE2XBj/eFd5O/1zALv9OFobxJzC8nUds+DdaMNyyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QKMTAJfa; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QKMTAJfa"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65AJu9La1363976;
	Thu, 11 Jun 2026 05:06:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=iOSiEPzW6LrSTC74J
	6Mx+t3mhTtKlp5lppET1rreBxk=; b=QKMTAJfaE0++i3gjyyYgJR2zQqkTHERDl
	BRZso5IDNjTQum5I1rLTsA4TOIFg3et+rQaQ4MqbkhsNhS4xkHnbtrjX8xWSpsTw
	1IOmk7p0UQbr5usaRClOXt1izeYUg3hEXIJRaqIwMZ/J1a1mysly3iEhkjiuDQQh
	YNWGkBUmaGfyPPfde59ubn6uT6Gix8ikcTVp4fxpo1yuhMIBBWE1V5DznD6Cs4Tu
	l0UzWiQqwQLykwk8Dse3ukFyu4N7YHsuDYhpq11MBDee3OZVGwdkR5RyO1G/nsuG
	YYeC5nk6MPPUjaCsb12Xfm2WN+PgsUpULm/hJUAdkpJisPFr9e+ug==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8dsg1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 05:06:10 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65B54ee9025801;
	Thu, 11 Jun 2026 05:06:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eqe09hqb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 05:06:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65B564TP51380596
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jun 2026 05:06:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 315F320043;
	Thu, 11 Jun 2026 05:06:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B28020040;
	Thu, 11 Jun 2026 05:06:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jun 2026 05:06:03 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>
Subject: [PATCH 1/3] zfcp: Enhance fsf status read buffer tracing
Date: Thu, 11 Jun 2026 07:05:23 +0200
Message-ID: <20260611050550.796772-3-niharp@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611050550.796772-1-niharp@linux.ibm.com>
References: <20260611050550.796772-1-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2BbeEqLxxrrhKGtBD4FLwAnXOIfuZO3L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDA0MiBTYWx0ZWRfX8Whj4mIw+zCY
 BT2xWdzzdIvTz6v/JhlczJJSWmW7m4SNrDzcsSc4syuLYCCYCZPXap8eDs4HbZ5YJ+ni0BPkA6O
 OC8LBKhLscdjtRRIyM0Jg36cDSjH30dYJzlfMx/y7tuSaEc7TZKeGEVsUBL4D+x/n4nuE6r53wC
 OYor8N8Oe7jr6prGJvKCEjNSpeI2coj2xFCK+2NOpXTFesVvXeQn7Ggpxr2qZdKCV6YOOj64wCb
 7U3zU0g7Yn6HCKCTr3yhgSeKJfxkTX22se762Bb2DvpYn0RD0h7W8ZXMR8QCy16HGE1lr4fAAvk
 UcwkIqbVdiJ/YhGNPTuVQD2ONxK5WSVCq7oddGSi15YmQB9zVD854X2eceiNsG7Vvtz8f+jskmC
 zCDz1TRqkDy18xmRFpgoYz48/+R90M7X9z/li7qbEEB+3iQk+xkKb6t7R2k7XFgko0xKda7dNpE
 WjwHTUfoHlV6DNl7QyA==
X-Authority-Analysis: v=2.4 cv=DPu/JSNb c=1 sm=1 tr=0 ts=6a2a4242 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=Re67frvFl_FtP7PscwYA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDA0MiBTYWx0ZWRfX8mWpeVBJUpCN
 IZiokxymJU9MOPZE0J/s7i+BMxC7NI6jz18WFTt3kwQRPKlKZTBhQ+VpLjCs3k1SPtg9YpkQvoH
 luZ6Vxf4zXfwgslxlYe2IvmNfo0Y1kA=
X-Proofpoint-ORIG-GUID: 2BbeEqLxxrrhKGtBD4FLwAnXOIfuZO3L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110042

From: Chinmaya Kajagar <chinmayk@linux.ibm.com>

SRB trace records are logged through hba trace event zfcp_dbf_hba_fsf_uss.
Presently, this trace event has few missing fields in fsf status read 
buffer trace records. To fully trace incoming fsf status read buffer (SRB),
the remaining fields are needed to be added to zfcp_dbf_hba_uss structure.

Append all the remaining SRB fields to the existing unsolicited status 
trace records.

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
Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
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

