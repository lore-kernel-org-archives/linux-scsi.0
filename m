Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1D8388E7C;
	Tue, 23 Jun 2026 01:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178265; cv=none; b=XdZM+3teGSrAOd9Ww77pABbZ0EssE44dxwkGNt6x+IMCyN5AkHS/pqdgEcV1B1NBRPjOupVnFkxQSdWPBABGWPIVTD5PgoMcqKhujHIoTMy+Qh9VDLcPmDqWqzLpZxAofKcBIFN7H1zto4b2yCTXTnNMQrGfa3XypHodr5AnZM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178265; c=relaxed/simple;
	bh=ZwK9IVpL/NRL+EU5mBgV+NiVrCC6LP1a2Hrrt04LM8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afTN8oLBUGqmEdeloYMISbg6j3HOeBbzBWQdcgSRTtg3s/Z6YRGjCt2/ack37+g7tWIqZ5bQoNwLmEji3z7sBGAf8g4sDFz5QhEcotjlX60XzyCh04UHYnX/nwWCAYlp7bUSZAUec5Tcxi9O07DW3Q4d/3pUf8VFT6OE06Owwqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R9aHWkqr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R9aHWkqr"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mLv6408262;
	Tue, 23 Jun 2026 01:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GtTSKcNemXN8ZXi4C
	vj1YLEKGmXxLLrjBmUaOaYNgoY=; b=R9aHWkqramWzVUDkcTXwu9CJTAL3WQBFs
	rdJFFUm1fO28dsf/laSHLk9U3wUa6kmqL5VAabuo+9ONWwJYqMXdUwKX7ETimdBz
	BmM43qF7rR3/0J4umKwUCA9kJ9aEeP5orhUTJx6PFNosmE2fp8/3d4MFjgsFkTl5
	uGDtayOuelmrZVmGvlWfMPbduGD51jEo9HwpvqvrG5oPZLnW1HGKiSArt2bkyyUS
	abmpcqxFUdYxhKbHL2wswZSd6doi3qq/3wHeg4C2txB99N8nbRX1x0KzcQQFep3W
	zIqfAdGMgbhTSQD80iUPWjNkTQ0kdiDfqSXlvogegg3LrjYEJqX/A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjc3c4qw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:50 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JhxZ014684;
	Tue, 23 Jun 2026 01:30:49 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex6ph8vm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:49 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UmrT5505622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:48 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5687C58052;
	Tue, 23 Jun 2026 01:30:48 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9EF95805A;
	Tue, 23 Jun 2026 01:30:47 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:47 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 14/29] ibmvfc: add NVMe/FC Process Login support
Date: Mon, 22 Jun 2026 18:30:20 -0700
Message-ID: <20260623013035.3436640-15-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=X4Ni7mTe c=1 sm=1 tr=0 ts=6a39e1ca cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=BBChT4-wVwiCfiflK1sA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX2RtFZgpMZ/UG
 dOwRN9uRyXp0jiuzYhwX893VA7DtL1upcToCXCvGRCu8LZ5xG44H7+iG/yC9zEgqzpdweNQ8Rtm
 uVc4dnqtRWTWJDQaX7q2UDUsEyM3lMk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX2MntAs/gOW/w
 IPtg2+rffTsK0DjQczALF2xAP4BL1UgtHDwTCYe30/Q6Om3vFZrXCYQPK0GnSOJCmmJr3KqjSYm
 bEDlnIP3EVAkW155xVvsGsRSc0ubyv8P0fCJuPPDMtcU7kbBSFn3bKJZ2lcT3L/ZPM60M2gudp2
 UgNDJNgi4IvqxsNgmfyTHLmiPSxhEaiKws/vT+SIuzq88reAOLk/+Ifg8tnDvdjT6+Bos1gZ5z9
 go0w24IeSY1gBuNt0VDGox7IJWX4vjQMyL/9UOWCRWrvE3CF8y/AOnoxpRYErG+Z5FjU9oW+5la
 xh34nE594E8Em2Hd8+Eo3BO8HK3D872rTuoeaNHhZmPP2Io9GWcArBQ9uRY2iLb6xpHsAdEsg9Z
 R3chwCvzp0gMKnBwWV4nSclH3VDLOMl5qwD5i4ROFTrEbBdl1mH/lcVoi40UdlThdSBv2cTkDPK
 ujGZ6F7KXeGEdgtxDkQ==
X-Proofpoint-ORIG-GUID: Yonw9lKXSHF-odire6mzbx1HPjjqmjXt
X-Proofpoint-GUID: Yonw9lKXSHF-odire6mzbx1HPjjqmjXt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Extend PRLI handling code to support NVMe/FC targets.

When the target protocol is NVMe/FC, issue the NVMe process login MAD,
set the NVMe FC-4 type, and populate NVMe-specific service parameters.
On completion, decode the returned PRLI service parameters and derive
the appropriate remote-port roles for NVMe initiator, target, and
discovery ports.

Keep the existing SCSI PRLI flow unchanged while allowing the common
target state machine to complete login for NVMe/FC targets.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 55 ++++++++++++++++++++---------
 drivers/scsi/ibmvscsi/ibmvfc.h      |  6 ++++
 2 files changed, 45 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 2c54d0b9add4..b45cd0183fb5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4088,11 +4088,12 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 	switch (status) {
 	case IBMVFC_MAD_SUCCESS:
-		tgt_dbg(tgt, "Process Login succeeded: %X %02X %04X\n",
-			parms->type, parms->flags, parms->service_parms);
+		tgt_dbg(tgt, "%s Process Login succeeded: %X %02X %04X\n",
+			proto_type[tgt->protocol], parms->type, parms->flags,
+			parms->service_parms);
 
+		index = ibmvfc_get_prli_rsp(be16_to_cpu(parms->flags));
 		if (parms->type == IBMVFC_SCSI_FCP_TYPE) {
-			index = ibmvfc_get_prli_rsp(be16_to_cpu(parms->flags));
 			if (prli_rsp[index].logged_in) {
 				if (be16_to_cpu(parms->flags) & IBMVFC_PRLI_EST_IMG_PAIR) {
 					tgt->need_login = 0;
@@ -4108,6 +4109,22 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
 				ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
 			else
 				ibmvfc_del_tgt(tgt);
+		} else if (parms->type == IBMVFC_NVME_FCP_TYPE) {
+			if (prli_rsp[index].logged_in) {
+				/* For FC-NVMe PRLI the Image Pair field is always set to zero (see 6.3.3) */
+				tgt->need_login = 0;
+				tgt->ids.roles = 0;
+				if (be32_to_cpu(parms->service_parms) & IBMVFC_PRLI_NVME_TARGET)
+					tgt->ids.roles |= FC_PORT_ROLE_NVME_TARGET;
+				if (be32_to_cpu(parms->service_parms) & IBMVFC_PRLI_NVME_INITIATOR)
+					tgt->ids.roles |= FC_PORT_ROLE_NVME_INITIATOR;
+				if (be32_to_cpu(parms->service_parms) & IBMVFC_PRLI_NVME_DISCOVERY)
+					tgt->ids.roles |= FC_PORT_ROLE_NVME_DISCOVERY;
+				tgt->add_rport = 1;
+			} else if (prli_rsp[index].retry)
+				ibmvfc_retry_tgt_init(tgt, ibmvfc_tgt_send_prli);
+			else
+				ibmvfc_del_tgt(tgt);
 		} else
 			ibmvfc_del_tgt(tgt);
 		break;
@@ -4128,9 +4145,10 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
 		else
 			ibmvfc_del_tgt(tgt);
 
-		tgt_log(tgt, level, "Process Login failed: %s (%x:%x) rc=0x%02X\n",
-			ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
-			be16_to_cpu(rsp->status), be16_to_cpu(rsp->error), status);
+		tgt_log(tgt, level, "%s Process Login failed: %s (%x:%x) rc=0x%02X\n",
+			proto_type[tgt->protocol], ibmvfc_get_cmd_error(be16_to_cpu(rsp->status),
+			be16_to_cpu(rsp->error)), be16_to_cpu(rsp->status),
+			be16_to_cpu(rsp->error), status);
 		break;
 	}
 
@@ -4172,25 +4190,30 @@ static void ibmvfc_tgt_send_prli(struct ibmvfc_target *tgt)
 	} else {
 		prli->common.version = cpu_to_be32(1);
 	}
-	prli->common.opcode = cpu_to_be32(IBMVFC_PROCESS_LOGIN);
+	if (tgt->protocol == IBMVFC_PROTO_SCSI) {
+		prli->common.opcode = cpu_to_be32(IBMVFC_PROCESS_LOGIN);
+		prli->parms.type = IBMVFC_SCSI_FCP_TYPE;
+		prli->parms.flags = cpu_to_be16(IBMVFC_PRLI_EST_IMG_PAIR);
+		prli->parms.service_parms = cpu_to_be32(IBMVFC_PRLI_INITIATOR_FUNC);
+		prli->parms.service_parms |= cpu_to_be32(IBMVFC_PRLI_READ_FCP_XFER_RDY_DISABLED);
+
+		if (cls3_error)
+			prli->parms.service_parms |= cpu_to_be32(IBMVFC_PRLI_RETRY);
+	} else {
+		prli->common.opcode = cpu_to_be32(IBMVFC_NVMF_PROCESS_LOGIN);
+		prli->parms.type = IBMVFC_NVME_FCP_TYPE;
+		prli->parms.service_parms = cpu_to_be32(IBMVFC_PRLI_NVME_INITIATOR);
+	}
 	prli->common.length = cpu_to_be16(sizeof(*prli));
 	prli->scsi_id = cpu_to_be64(tgt->scsi_id);
 
-	prli->parms.type = IBMVFC_SCSI_FCP_TYPE;
-	prli->parms.flags = cpu_to_be16(IBMVFC_PRLI_EST_IMG_PAIR);
-	prli->parms.service_parms = cpu_to_be32(IBMVFC_PRLI_INITIATOR_FUNC);
-	prli->parms.service_parms |= cpu_to_be32(IBMVFC_PRLI_READ_FCP_XFER_RDY_DISABLED);
-
-	if (cls3_error)
-		prli->parms.service_parms |= cpu_to_be32(IBMVFC_PRLI_RETRY);
-
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
 	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
 		vhost->discovery_threads--;
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
 	} else
-		tgt_dbg(tgt, "Sent process login\n");
+		tgt_dbg(tgt, "%s Sent process login\n", proto_type[tgt->protocol]);
 }
 
 /**
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 67f546ff092e..66025e6ffeed 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -381,6 +381,7 @@ struct ibmvfc_move_login {
 struct ibmvfc_prli_svc_parms {
 	u8 type;
 #define IBMVFC_SCSI_FCP_TYPE		0x08
+#define IBMVFC_NVME_FCP_TYPE		0x28
 	u8 type_ext;
 	__be16 flags;
 #define IBMVFC_PRLI_ORIG_PA_VALID			0x8000
@@ -396,6 +397,11 @@ struct ibmvfc_prli_svc_parms {
 #define IBMVFC_PRLI_TARGET_FUNC			0x00000010
 #define IBMVFC_PRLI_READ_FCP_XFER_RDY_DISABLED	0x00000002
 #define IBMVFC_PRLI_WR_FCP_XFER_RDY_DISABLED	0x00000001
+#define IBMVFC_PRLI_NVME_PI_CTRL		0x00000200
+#define IBMVFC_PRLI_NVME_SLER			0x00000100
+#define IBMVFC_PRLI_NVME_INITIATOR		0x00000020
+#define IBMVFC_PRLI_NVME_TARGET			0x00000010
+#define IBMVFC_PRLI_NVME_DISCOVERY		0x00000008
 } __packed __aligned(4);
 
 struct ibmvfc_process_login {
-- 
2.54.0

