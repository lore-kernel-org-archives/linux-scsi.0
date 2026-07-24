Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCCD768EA;
	Fri, 24 Jul 2026 05:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784871611; cv=none; b=payBSdkiNdH3rS8IStw3ptQgUJX13ZHYtgz+YGiubYyRXDyCehce1FKHQRRaJjMCa85SV8L74MSLpdusBQNFQWuxDqIgaYncE7AwiQj6g6ibB4HREWWfkos1snVwEDHJHjRkm+MhJa5EA3iQrmBDrh7mGMYTX78nt5rvphsUZyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784871611; c=relaxed/simple;
	bh=C2ogADD7a30fMA4fZOUNicMxPiQSKkcWZ2jdJ6drJ88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQnTe4TJcCqmb/Uf3KpOk67AT+dCUp5ptG6DorTUvWH1/eFyga8fa5k/BsTmnoEBfPSSUmSrSn9V1ZNbXzQEuHJAQjxLfggCnomVc14Ch+pK7Qu5zMc6G5Tqc6+PvZwaIUMHBIIyttwtqvsYcJwdXxl2caIlfCYcUjF+ELBOKRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=joAylmnq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="joAylmnq"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66O5BcLE903436;
	Fri, 24 Jul 2026 05:40:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jndN4pGsTb1NJGEsk
	eFPs7Ys/TVJ4c3Q27r58wxpMNg=; b=joAylmnqul0vhvIjQSnaR97fu/H38WFFb
	7KgVBXDN3JOKjkpT/FmOhoEAfjVc0/lraiGWq9l1RZHPwELVoyMLk0HIdl2XSISq
	Ubt85JSqZZebq3hHCkgNl5FFApacuAJWFQa8aNE3KyEoeN4VlFnsgZxSRoNphj9s
	tT24mfywbwHw+gYHfamGVMF5bdginz8hY6PRIPC+dQytDRdvxRtbgireColYNHXU
	9SdnrYuZ93B1u+K52ffLWB+hWkKXeNizSYHQ1VydEtIlRmdu+YpluLe8w6Ej7+Lf
	FLf8xSNPFhvu4Wh6pgl+uVVRYCmh69GuY6EOc1B8L2pl81N+HhN2w==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abu8dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 05:40:06 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66O5YnE3000984;
	Fri, 24 Jul 2026 05:40:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgktqfs8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 24 Jul 2026 05:40:05 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66O5dxYn9896278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Jul 2026 05:39:59 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AC27D201AA;
	Fri, 24 Jul 2026 05:39:59 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8500D201A9;
	Fri, 24 Jul 2026 05:39:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 24 Jul 2026 05:39:59 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        =?UTF-8?q?Vasily=20Gorbik=C2=A0?= <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        =?UTF-8?q?Christian=20Borntraeger=C2=A0?= <borntraeger@de.ibm.com>,
        =?UTF-8?q?Nihar=20Panda=C2=A0?= <nihar.panda@ibm.com>
Subject: [PATCH 2/4] zfcp: Trace plogi and prli within open port response as payload
Date: Fri, 24 Jul 2026 07:39:32 +0200
Message-ID: <20260724053934.2781087-3-niharp@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI0MDA0NSBTYWx0ZWRfX1Cz3ncdykWZA
 dx0SbF0p6UX+py6enET5PG2v41woFeDG/lDbO1F6/e8nfBvU/weZmkRO6iVg+KMbctoN9+qp53i
 ybeXj1bupWyO9katsG1mDqRqYbss7ZoabzN1IvbE3A4qEHNZp3OcmTqsHkbUOToNsq7Mz+zQC+U
 c/DSOhZt23EEF9S5Obru3wIwQ3GUILWKBA6DnaEfiRqFRQOxl2+8SIuzumCN6vBtpt9nGL52EfE
 7LnyImXA4i0nxfqZg8XkcYgNbTaDMHLdCoj2bBbd0l0lk1OPLQsUAqjGjr1VBKDEiwXxx9LSZ5k
 w4TZa2z00dDXeD2oD2NYtmNEsGQztwnITMEi/kIHbo8y3D3aaHgP/VG+EMtrv2DQGSI2ket2qA0
 e1dhcG1KP/gTn1602tk9VXd2/uZHKqOAdTE37KzXaQyuIelqad+o4AoaWS4Tucq9RShe8+aCHqG
 9jrEwU59dGodL38Ulpw==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a62fab6 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=lq_hjbAu-zlZwPCF-G8A:9
X-Proofpoint-ORIG-GUID: GByFbkTK4Vrh2UnXObKHDplyAuPfe298
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI0MDA0NSBTYWx0ZWRfX1x+xej5d+8Zx
 MmIf+ElOCF0oRHUG8ITmQciv6ICZjV3pQ7pcn0lrdjicSTmW2/1RVejI0APBAaCszmmGtOTmpS7
 IsQ/tiRWkYTpnjx3xcpZO3A/4ZNfazU=
X-Proofpoint-GUID: GByFbkTK4Vrh2UnXObKHDplyAuPfe298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-24_01,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607240045

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

