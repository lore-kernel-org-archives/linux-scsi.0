Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFAB3403ED;
	Sat, 19 Sep 2026 01:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781602; cv=none; b=n1jfhWI0mPwGOGDGMSIqypV7NSFnka4urNEKGAxdjlYsH8A6TmJG42nAc2m5IDwzvXbx/g7byqQk6f2pcXBcXMuNpD6sSA3AucH0E8Y+oq1o9cFT2UvqhNQZKAjA8N1Q+CF0ZIUl1aVkF7qPOhU64khROKovq6nJOA2Fd/cYUgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781602; c=relaxed/simple;
	bh=+2AcnY/qLDXKehHQ28QjSs8q+UviDM872kt8hGuGl8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ3IASm5SK4UQuM2d2RWoSgfPdPa6IyJOYCB+qz0k47MW1iwneih/eCMWMNTHz86mOG1daaEx2RJMsvjZSkDuU+vG6FSs6GAPgghDLoTrBRErYADMySw5s+I194QEyORA4mu1KQUJkShXQE0/pxHsdZRzUbGgPzu7GoA69Zkygc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lBxz+WOP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lBxz+WOP"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1WARA1677125;
	Sat, 19 Sep 2026 01:33:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AAvMCQkdZO91wfgvq
	VOlY3PB7FOIxuESr6sA/j/Mey4=; b=lBxz+WOPAndV07JLeRfY/ErHoOVbyavWV
	jWMDjDxfZp3bHq/9yqn7D1rUyabEvSO4oC0ySBFsyW5GdYWRUYg6nNU4C7c7wq39
	Z4b/k/rEpnsbpb1CetG1j6UUUsz0fnh2t7bFQ9ToO0yndi6eFeQhk8kggf05pTpA
	BgEAeK8nublTFoB/PjzfnqfwW6M78Gm3VZVBnTyW0uZli58ZP8izYKOH2WEIHrlC
	fMsQlxW9fyLs4kNi3SOtlZqbMovC5ow1aSa2xW2OGaRJVexG5BGJKlf+bUaBQm9P
	hDeK138FADDA5sTNKKb/cQytCiUykUfFpGfJWvcoz67UIePvNPjkQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gsgtd803j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1RaOW1658899;
	Sat, 19 Sep 2026 01:33:13 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gsgrgg0cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:13 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XCmo33817268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:12 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70FF558051;
	Sat, 19 Sep 2026 01:33:12 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CDF3E5805A;
	Sat, 19 Sep 2026 01:33:11 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:11 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 02/20] scsi: ibmvfc: fix trace logging for NVMe FCP commands
Date: Fri, 18 Sep 2026 18:32:48 -0700
Message-ID: <20260919013306.2948028-3-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX8pCJZxqc5wiY
 XmaOCisx1Pv7tw2WtJk+ZZdJd8ygt2tkZk3V71WTpo4WvCtQM71+lrWRNzbOqBvB6jmm8aZJNeQ
 6xE6T1vcDb9PKnKG/rxUenu3gfrxRUZT2tq6HVkymzSRv00gWheo48gkghWk7B6RL2B5GmHDsYN
 gpfoeN1BOABmASoKLBSbZv+1MaomVGzcR6a5WP4JVOLDmQVHxMC03u2dL6Jk5dhCdQuWjEfZL7/
 e3H9vDAUQS8hFTfjHvKAGFvv9ArhhEfzt2ORT8ShcFcJfaQfS5UX46cui2hMu2ZJzoAnKOFqj9y
 vug8srmgT23+0FHPAWBKivLnZcbk0mShaWmjsQFYdXYfAiwb36fo+1QUNi5xDwDI6Wvrg5CQ4bi
 KqpSEpdTsKh4S+ok3WNugVY+KTf4IzmHQM2dXXmVJkHhmJ+Mm/WHTltODBKmy8QzBlqqw6Ar7yF
 d2WIuzNduxJrQ6qZpJw==
X-Proofpoint-GUID: woipL11UiEIZ-8niWEEeDiWyIJ9VpHct
X-Proofpoint-ORIG-GUID: woipL11UiEIZ-8niWEEeDiWyIJ9VpHct
X-Authority-Analysis: v=2.4 cv=Q49HcI2a c=1 sm=1 tr=0 ts=6aade65a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=fF8LTD-R--w6NU_6X2kA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfXwV9+9MbwmJpU
 LL+tOamlcs2/XoNCr7uyGcGUgrB64MILUp5TDrEEmoKbiubriw7I9oP7miqa7ugmY4xn9Q8sKqd
 qX04j+qGDvGcGT33pAwV6i2buc9LeoM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

ibmvfc_trc_start() and ibmvfc_trc_end() handle IBMVFC_CMD_FORMAT events
by reading SCSI-specific fields via ibmvfc_get_fcp_iu() and
ibmvfc_get_fcp_rsp(). These helpers return a pointer into the v3scsi
union member of struct ibmvfc_cmd, but NVMe FCP commands store their
command IU in the v3nvme union member. Reading SCSI FCP fields out of an
NVMe IU produces garbage trace entries (wrong opcode, lun, tmf_flags,
xfer_len, rsp_code, and scsi_status).

Fix this by gating the SCSI-specific field reads on evt->cmnd within the
IBMVFC_CMD_FORMAT branch. For NVMe FCP events (evt->fcp_req set) record
the NVMe SQE opcode from v3nvme.iu.sqe.common.opcode and the payload
length from vfc_cmd->payload_len. The common fields that are valid for
both protocols (tgt_scsi_id, vfc_cmd->status, vfc_cmd->error) are
logged unconditionally.

Fixes: 73c13e30c56f ("scsi: ibmvfc: implement nvme-fc IO command submission callback")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 31 +++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index aa7ae81df41b..6558ed3c67c4 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -250,6 +250,7 @@ static void ibmvfc_trc_start(struct ibmvfc_event *evt)
 	int index = atomic_inc_return(&vhost->trace_index) & IBMVFC_TRACE_INDEX_MASK;
 
 	entry = &vhost->trace[index];
+	memset(entry, 0, sizeof(*entry));
 	entry->evt = evt;
 	entry->time = jiffies;
 	entry->fmt = evt->crq.format;
@@ -257,11 +258,16 @@ static void ibmvfc_trc_start(struct ibmvfc_event *evt)
 
 	switch (entry->fmt) {
 	case IBMVFC_CMD_FORMAT:
-		entry->op_code = iu->cdb[0];
 		entry->scsi_id = be64_to_cpu(vfc_cmd->tgt_scsi_id);
-		entry->lun = scsilun_to_int(&iu->lun);
-		entry->tmf_flags = iu->tmf_flags;
-		entry->u.start.xfer_len = be32_to_cpu(iu->xfer_len);
+		if (evt->cmnd) {
+			entry->op_code = iu->cdb[0];
+			entry->lun = scsilun_to_int(&iu->lun);
+			entry->tmf_flags = iu->tmf_flags;
+			entry->u.start.xfer_len = be32_to_cpu(iu->xfer_len);
+		} else if (evt->fcp_req) {
+			entry->op_code = vfc_cmd->v3nvme.iu.sqe.common.opcode;
+			entry->u.start.xfer_len = evt->fcp_req->payload_length;
+		}
 		break;
 	case IBMVFC_MAD_FORMAT:
 		entry->op_code = be32_to_cpu(mad->opcode);
@@ -287,6 +293,7 @@ static void ibmvfc_trc_end(struct ibmvfc_event *evt)
 	int index = atomic_inc_return(&vhost->trace_index) & IBMVFC_TRACE_INDEX_MASK;
 
 	entry = &vhost->trace[index];
+	memset(entry, 0, sizeof(*entry));
 	entry->evt = evt;
 	entry->time = jiffies;
 	entry->fmt = evt->crq.format;
@@ -294,15 +301,19 @@ static void ibmvfc_trc_end(struct ibmvfc_event *evt)
 
 	switch (entry->fmt) {
 	case IBMVFC_CMD_FORMAT:
-		entry->op_code = iu->cdb[0];
 		entry->scsi_id = be64_to_cpu(vfc_cmd->tgt_scsi_id);
-		entry->lun = scsilun_to_int(&iu->lun);
-		entry->tmf_flags = iu->tmf_flags;
 		entry->u.end.status = be16_to_cpu(vfc_cmd->status);
 		entry->u.end.error = be16_to_cpu(vfc_cmd->error);
-		entry->u.end.fcp_rsp_flags = rsp->flags;
-		entry->u.end.rsp_code = rsp->data.info.rsp_code;
-		entry->u.end.scsi_status = rsp->scsi_status;
+		if (evt->cmnd) {
+			entry->op_code = iu->cdb[0];
+			entry->lun = scsilun_to_int(&iu->lun);
+			entry->tmf_flags = iu->tmf_flags;
+			entry->u.end.fcp_rsp_flags = rsp->flags;
+			entry->u.end.rsp_code = rsp->data.info.rsp_code;
+			entry->u.end.scsi_status = rsp->scsi_status;
+		} else if (evt->fcp_req) {
+			entry->op_code = vfc_cmd->v3nvme.iu.sqe.common.opcode;
+		}
 		break;
 	case IBMVFC_MAD_FORMAT:
 		entry->op_code = be32_to_cpu(mad->opcode);
-- 
2.55.0

