Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9583D36A370;
	Thu, 11 Jun 2026 05:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781154383; cv=none; b=an4f1jZDVnYc+KVNR5qYIfs8LmhzOD1m2nKevzOohUbAjnLpqTeZJdSnaZTBVIf1OFSS+RqUwv3epz53QLXcfqcsOZ88HFoj0Uq31lHUisFvv/dcU3t3LvcWttgZw+9Q/Y/S9Gk+u1VGl0/JGXf9HYgi9Mhyb7xIB05LYbMBxo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781154383; c=relaxed/simple;
	bh=uIapTTZpCn0m+4++O2QHok5l3en4vDdg82IYQGQvpUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mldaIRJuZpOEuH4/mOPfXcADYAUrh9KLfjmSdHiuzv3tTn0G1LoigMLboN/Lys/oqqQMz6TWGaYsNKHMxuaECku6mbjmRf5Muy4po/D0B2zyIz8sg+eV/YjNOs4SRE9T+NOKy7Lqz3cLYMonU++npYtXb6WZa49deRHn1T+Pau8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jiX+gY8t; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jiX+gY8t"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65AJu4Dv4146517;
	Thu, 11 Jun 2026 05:06:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=xAMQGYRTN5cLUuUg6
	6WIZowzl56yMmcOT2kXcIS/vkM=; b=jiX+gY8tOqdOTgo/yavwl1BKvCFKQc7Jv
	ppTNbUP45UrLUB8V/xx6GZAr/OVOx30xnAOl7tJjmfFZCMH5YU+x5oe8Gqi81bIo
	MJKX9rzcaZzb2gTxWMPZOdNoa1DTVvTYB2JystIpfLbHXBrUxeUbvim8lqE/xUBF
	FLMucENxdgVa2Sb+WV1hFYi/Bug69DabApvnsEgZx3uEf9+u0yj0dX3/lW8Sn0lw
	m8ZT5//ZjBCDWrt9wrjMAxReqn2pTg1gMcmw3dpjoGBDhB3shLZPEPe5+GOjKD6e
	UBwd/4UKFGCMlzssy/OF9ZwMBpDGZRHhFC5Punc4uB0l4fuXOFHww==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8c1gyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 05:06:13 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65B54dHL031672;
	Thu, 11 Jun 2026 05:06:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4eqe08hq70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 05:06:12 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65B566aB17105216
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jun 2026 05:06:06 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3489A20043;
	Thu, 11 Jun 2026 05:06:06 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F7DD20040;
	Thu, 11 Jun 2026 05:06:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jun 2026 05:06:06 +0000 (GMT)
From: Nihar Panda <niharp@linux.ibm.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>
Subject: [PATCH 2/3] zfcp: Trace plogi and prli within open port response as payload
Date: Thu, 11 Jun 2026 07:05:24 +0200
Message-ID: <20260611050550.796772-4-niharp@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDA0NyBTYWx0ZWRfXzf//vXzO65JF
 0VDDx7dxCOK3PZ6INFJ/m0M6a/X2qmIXFZUMCJkIA7RQml1JHAUOjMtkrSAMCluPyjI0XUWT84n
 VFPOaPj+FcRm9TeSvcZoiA6yEx+azKk=
X-Authority-Analysis: v=2.4 cv=AYCB2XXG c=1 sm=1 tr=0 ts=6a2a4245 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=lq_hjbAu-zlZwPCF-G8A:9
X-Proofpoint-GUID: -1E6TPEtYZOZ9HUyzRD0vAQBSWJYGCr-
X-Proofpoint-ORIG-GUID: -1E6TPEtYZOZ9HUyzRD0vAQBSWJYGCr-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDA0NyBTYWx0ZWRfX3/p6Vy1yFwy4
 p+uuhIzZIlC4vSrOPDxzyMie5i/y1+slFqlNgRf3dGBxarjDrJoHNpt5RYSg2x957USHHGLAdrV
 xRNYSFqXTNrUUg1Fd5bgfn0DNj5lk2regl3pFWsFuwj+gaCVvuaeyfWpU9FSF1B8pIVfATdXSD8
 a0uad30N//lhnK55Vq2o8LytziMuMIaXlUgmjsAgmTIdRpe/oQ4pjXMldMIpIRZCkRylRosmn5v
 JNxauUa10RbOMy7F/iJiKuko1kjMHN0jsiXU1gSjnzOVlmLOEerEGUGQ5VLeA7FxP3zJrOKZnas
 tP+IC2L6RF004YQcX36edS0sBGh79EuflO4pAks0LXXHnma7wlf7fweiv6vj7aF8Lf3bw0reRQm
 etvwDvoj/w0KRD7aLCTtQFQtS4GmWyQPGBVych6tY3QaZFcNGAe4JmN/Q6uq8DxDeGCeMgFejbI
 DHpZUnClkyotDi+34mg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110047

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
Signed-off-by: Nihar Panda <niharp@linux.ibm.com>
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

