Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517B21F8755;
	Tue, 28 Jul 2026 04:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785214161; cv=none; b=cc+RNTHynRzKuxY06gim/y+00KuT5sOre5qpoLbzXVVI2aGhsS85sg1q7Lv/zurnBF6CxS0ZPtgJEMMvKMaiIlYSdLsHINVD/0IQVNjtN5ipvZDooQIC5/Wys2D/Yq3eIlCGIyfVPWjmoDXW7ArD6xilDiFIk4LsaMJPxcJmmKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785214161; c=relaxed/simple;
	bh=C2ogADD7a30fMA4fZOUNicMxPiQSKkcWZ2jdJ6drJ88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGbzbti+6B5+mdsq1LTQzGIU3kx+ADLNUkFF/dnVVpYMY7z9RhK4GsSaplBA5MHv+fSUy7Ewl/JO56w3mioZwca9NKym0rehh/ydBDolvtPgM6lIpoN8ai9UudgWLzpMymTG/sO2zA2UsZ0iC0SWxPRsgR28KH1Y/4oG7njdae8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ag65K9Iw; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ag65K9Iw"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66S3mPck4032934;
	Tue, 28 Jul 2026 04:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jndN4pGsTb1NJGEsk
	eFPs7Ys/TVJ4c3Q27r58wxpMNg=; b=Ag65K9Iw1eR769XKa94PRp/gVinfssmH7
	tofFtnUZbCn9PtR3pIPtVOXtRF/2FBP5JoJjk+Am340l76MLE8A8Z56ocrVXnC0v
	gspl4eI/1cOkssB7NdN8maJsxifFN6K0zjjAjl62ID7/NSK6J484mzxRFyFZHjwQ
	BO8daRy/Trp+QpspmoZ+vlaEnJs+613ALlZ2xfCJDpF7Am3Yn/Ruy4Bb1QXtNFoj
	WSffgdMxZo9BuBHgb0yn07b5W+RuO1OE6TTkFEydo+uf0q6o/Hi69TgaZ0WL9hE6
	Krg0RsDe90zwS95hWb/pqR42LlWxnV/9RnphdECHQauy+LrHj+m1w==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0njwfn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 04:49:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66S4fR1J023252;
	Tue, 28 Jul 2026 04:49:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yh87f9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 04:49:17 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66S4nBW830474664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 04:49:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3FA4020182;
	Tue, 28 Jul 2026 04:49:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1781B20181;
	Tue, 28 Jul 2026 04:49:11 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jul 2026 04:49:11 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        =?UTF-8?q?Vasily=20Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntraeger=C2=A0?= <borntraeger@de.ibm.com>,
        =?UTF-8?q?Nihar=20Panda=C2=A0?= <nihar.panda@ibm.com>
Subject: [PATCH v2 2/3] zfcp: Trace plogi and prli within open port response as payload
Date: Tue, 28 Jul 2026 06:48:56 +0200
Message-ID: <20260728044857.2532646-3-niharp@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDA0MSBTYWx0ZWRfX8HgCWabjUww1
 nfGw3tL8I5Scz8lJg56J1R39FygRzfHjLMZccauJubRPe+OCCiXTxyR2/Q8lFTTaNU5WHxjpvq5
 3A97ni9bm6hdWv5DAejt03FjD8hTMh0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDA0MSBTYWx0ZWRfXycqSxNZumUjX
 450Po9Bqa7ofiwNE2jbPn4u55IVj6T8BTyujcvZpXvC96CZTtCOIUorpIpcAKTbBEGXyS2nsc39
 +b60IJ7kAqDL5k9W8yLYyVuvScUgmIfKMwzbS470uifL8CtqpTHPkHOQEuo/3wFtKZ57lDX6Y8G
 KkU+FN0AZWseiwxd5WPYm7OFNy5aEXExuDXKUk5TINc3NUwqOjGJJvCwjVJU2hbC9eUUp+/F1V1
 /yu2qhHAO3XFuAbkchQtKOTAEEYYnmZ94Z/lUrC0cTVRcLQuGG+hLL/2rXaE0YaY5rN6pC8+oOh
 USr9KZ4i3qElnb8PwgEEe0X1DWPKLSDGToPzDR0c/cPIHR9M1kdWZbcMXJguNRjyjZRLGoPQo5B
 dM5/UzFh+iQX33PcGuLo+WTLeEgixxNrQ9pyDMi4DT6OSt3oWCma8LmLJB2N2Z/epeJMINg7a4O
 KvFNFrD/+bRqLAPR9Cw==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a6834ce cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=lq_hjbAu-zlZwPCF-G8A:9
X-Proofpoint-GUID: -EBkw_ivIvYjCfNynOUTMVZCv7wbzDCj
X-Proofpoint-ORIG-GUID: -EBkw_ivIvYjCfNynOUTMVZCv7wbzDCj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_01,2026-07-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280041

From: Steffen Maier <maier@linux.ibm.com>

The FCP channel optionally returns the content of PLOGI and PRLI within
open port response. This information is needed to debug unexpected open
port responses. Pack both PLOGI and PRLI information back-to-back into a
PAYload trace record of type "fsf_els" within existing HBA trace record.

The length of both parts, and thus also the offset of the second part,
are added to the corresponding HBA trace record. Be extra careful
regarding bounds checking.

Since auto port scan in multi-initiator zoning environments can cause a
lot of failed open port responses and trace is enabled by default in the
HBA trace area, chose a trace level 4 above the default of 3 for the
corresponding PAYload trace record to contain PLOGI/PRLI data. This way,
it avoids flooding the PAY area by default.

In the spirit of commit 35f040df97fa ("zfcp: retain trace level for SCSI
and HBA FSF response records"), pass the level here. For this, introduce
an additional argument 'level' for zfcp_dbf_pl_write().

zfcpdbf tool partial trace example with PLOGI/PRLI log info after changes:

PLOGI length   : 116
PRLI length    : 20
Payload time   : 2026-01-29-06:19:15:626629
PLOGI/PRLIinfo : 02000000 00000000 80000800 000a0002
                 00000000 2002000e 1115c62f 2001000e
                 1115c62f 00000000 00000000 00000000
                 00000000 80000000 00000000 00000000
                 00000000 80000000 00000000 000a0000
                 00010000 00000000 00000000 00000000
                 00000000 00000000 00000000 00000000
                 00000000 02100014 08002100 00000000
                 00000000 00000112

Reviewed-by: M Nikhil <nikh1092@linux.ibm.com>
Reviewed-by: Nihar Panda <niharp@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
Co-developed-by: Chinmaya Kajagar <chinmayk@linux.ibm.com>
Signed-off-by: Chinmaya Kajagar <chinmayk@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c | 37 ++++++++++++++++++++++++++++++------
 drivers/s390/scsi/zfcp_dbf.h |  4 +++-
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 89b859176b8b..4217b74baa38 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -4,7 +4,7 @@
  *
  * Debug traces for zfcp.
  *
- * Copyright IBM Corp. 2002, 2023
+ * Copyright IBM Corp. 2002, 2026
  */
 
 #define pr_fmt(fmt) "zfcp: " fmt
@@ -35,13 +35,18 @@ static inline unsigned int zfcp_dbf_plen(unsigned int offset)
 	return sizeof(struct zfcp_dbf_pay) + offset - ZFCP_DBF_PAY_MAX_REC;
 }
 
+#define ZFCP_DBF_PAY_LEVEL 1
+
 static inline
 void zfcp_dbf_pl_write(struct zfcp_dbf *dbf, void *data, u16 length, char *area,
-		       u64 req_id)
+		       u64 req_id, int level)
 {
 	struct zfcp_dbf_pay *pl = &dbf->pay_buf;
 	u16 offset = 0, rec_length;
 
+	if (unlikely(!debug_level_enabled(dbf->pay, level)))
+		return;
+
 	spin_lock(&dbf->pay_lock);
 	memset(pl, 0, sizeof(*pl));
 	pl->fsf_req_id = req_id;
@@ -51,7 +56,7 @@ void zfcp_dbf_pl_write(struct zfcp_dbf *dbf, void *data, u16 length, char *area,
 		rec_length = min((u16) ZFCP_DBF_PAY_MAX_REC,
 				 (u16) (length - offset));
 		memcpy(pl->data, data + offset, rec_length);
-		debug_event(dbf->pay, 1, pl, zfcp_dbf_plen(rec_length));
+		debug_event(dbf->pay, level, pl, zfcp_dbf_plen(rec_length));
 
 		offset += rec_length;
 		pl->counter++;
@@ -96,7 +101,27 @@ void zfcp_dbf_hba_fsf_res(char *tag, int level, struct zfcp_fsf_req *req)
 
 	rec->pl_len = q_head->log_length;
 	zfcp_dbf_pl_write(dbf, (char *)q_pref + q_head->log_start,
-			  rec->pl_len, "fsf_res", req->req_id);
+			  rec->pl_len, "fsf_res", req->req_id,
+			  ZFCP_DBF_PAY_LEVEL);
+
+	if (q_head->fsf_command == FSF_QTCB_OPEN_PORT_WITH_DID) {
+		struct fsf_qtcb_bottom_support *q_bott =
+			&req->qtcb->bottom.support;
+		u32 plogi_len = 0, prli_len = 0;
+
+		if (q_bott->els1_length) {
+			rec->u.res.plogi_len = q_bott->els1_length;
+			plogi_len = min_t(u32, q_bott->els1_length,
+					  sizeof(q_bott->els));
+		}
+		if (q_bott->els2_length) {
+			rec->u.res.prli_len = q_bott->els2_length;
+			prli_len = min_t(u32, q_bott->els2_length,
+					 sizeof(q_bott->els) - plogi_len);
+		}
+		zfcp_dbf_pl_write(dbf, q_bott->els, plogi_len + prli_len,
+				  "fsf_els", req->req_id, 4);
+	}
 
 	debug_event(dbf->hba, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
@@ -234,7 +259,7 @@ void zfcp_dbf_hba_fsf_uss(char *tag, struct zfcp_fsf_req *req)
 
 	if (rec->pl_len)
 		zfcp_dbf_pl_write(dbf, srb->payload.data, rec->pl_len,
-				  "fsf_uss", req->req_id);
+				  "fsf_uss", req->req_id, ZFCP_DBF_PAY_LEVEL);
 log:
 	debug_event(dbf->hba, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
@@ -739,7 +764,7 @@ void zfcp_dbf_scsi_common(char *tag, int level, struct scsi_device *sdev,
 				min_t(u16, max_t(u16, rec->pl_len,
 						 ZFCP_DBF_PAY_MAX_REC),
 				      FSF_FCP_RSP_SIZE),
-				"fcp_riu", fsf->req_id);
+				"fcp_riu", fsf->req_id, ZFCP_DBF_PAY_LEVEL);
 	}
 
 	debug_event(dbf->scsi, level, rec, sizeof(*rec));
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index 44ebad8c761c..c84f076440a8 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -3,7 +3,7 @@
  * zfcp device driver
  * debug feature declarations
  *
- * Copyright IBM Corp. 2008, 2020
+ * Copyright IBM Corp. 2008, 2026
  */
 
 #ifndef ZFCP_DBF_H
@@ -140,6 +140,8 @@ struct zfcp_dbf_hba_res {
 	u8  fsf_status_qual[FSF_STATUS_QUALIFIER_SIZE];
 	u32 port_handle;
 	u32 lun_handle;
+	u32 plogi_len;
+	u32 prli_len;
 } __packed;
 
 /**
-- 
2.53.0

