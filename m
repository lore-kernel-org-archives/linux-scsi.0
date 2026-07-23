Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C36E37E5C1;
	Thu, 23 Jul 2026 00:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764946; cv=none; b=jsPvtKpRsGVZbEefiy7MfenoK92qP/zaUZUeQSkTmC+AO8/TuhUtOP662RTvOBIYGKdMN1zdRtU6+RjnFFktfliKw7KJmBcHQH2MbtIW2GNaoRt4u0ePumpi5qH4wVGyWMngOx+qCkZpXZjbGWywtdt5XJuO7UKUrmwbQWRWBrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764946; c=relaxed/simple;
	bh=l+7f9aM9uwlGdSpVe9cpH3IYDMvh6GXfoTa5RLNPlZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qj2vut2F2ELv9HJB8AYU77HeP2q9NEdRfbE/F6ZfxjZblqj1FNG7dMLuTAzKTg+H+bFRl0kG5W1jVW5DpnTp8+nWz5VXz0HwpPa8UBpUcm8wFOUcVWFszx991ecNDO9sQl1/m0BE1Z+46lKN2jZ982Y8KXjXtbz1r1qngFH/iEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QO/aFYoO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QO/aFYoO"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBgHE3019601;
	Thu, 23 Jul 2026 00:02:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+8OllIJQnFuZpMkR4
	GBt9dgJ+A2dcKG757z4kf5zDSc=; b=QO/aFYoOnu8zSPXJl5Ttc57UtBBT+2lEM
	q3bS9ioFrBkmVxekKRz1bJ6YA/Zuf0edkL2tFo7gQCw2tG4Otm6DlBQ6ZYvvQx+k
	IdRQoRe56yCsv4aIwPeYpMlf1xxrDcGLVF1Ek/CAq3l3EP29iRfhfZO3ES0Ntwrr
	16vKdtzPelBEoefSKBphLZ6AkoTm+OsHhKElyBj55Mexwf7etEQYZexEPozp/FF0
	F7y2pX3YRHBPE36UiO+L7aaK1R1u7Th6AAFCOCxOqq8SaRuzpzKBYa+80iSyhht0
	+qFm6vWyBljizW0SrKyVaHfu08T/xI9KAbvWjhWhsuPsbl4TZUWKQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg77amx6b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnr2t021831;
	Thu, 23 Jul 2026 00:02:08 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgm6w9ujw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:08 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N027kw33686056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:07 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE70958061;
	Thu, 23 Jul 2026 00:02:06 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A70A58060;
	Thu, 23 Jul 2026 00:02:06 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:06 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 18/33] ibmvfc: add NVMe/FC Process Login support
Date: Wed, 22 Jul 2026 17:01:34 -0700
Message-ID: <20260723000149.969416-19-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723000149.969416-1-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: n_wfozIbCFxsdgqa6LDNiNfU1BNTQXok
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX6140JPHht7MN
 wexP79AAuuOO1v8gk8HSM+vC4hkOuQ9He26txAjQBYzKmzGPzSPA4YNJwgnS06RAJA3vqimb2l/
 Vf6bCG8/KtbbiA1H+nuMRqiuACIdmNU=
X-Proofpoint-GUID: n_wfozIbCFxsdgqa6LDNiNfU1BNTQXok
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfXyHhv0ABfl3pt
 Mur8s/9hsyX7GlWNHH7pZB9xqCsUDJSW2YQT383x+EipIladGiAI/yir4ZtcE5ihx+YD8oAmfyE
 S4rFehXOctKWT52uiW9lQM/YEtMhFO7OjMOVWS1JVDR0h44sIKWZzIUm/OKcImch9AcByFt+jR4
 ddDpAoN4LhVLxSh6j/H/wbMN8jcjGPXrLauR2ydsnwo6uxXLFC7a1T/IvzjUdG/kRVn683jQ+XX
 7MO3EIPbx5KlOdsRBD5QmH5XDe0EgPn3eJ/yFGL9BO/v/kVpn6Nzk+qMHGembElMS5hWpOhsb6s
 EhdzG/gK4Mr/EQ/7ngmAjntOzXFSVI7VraDXbxIecUWO3gbB3ZGXfC6kmxSFe16vwovIIsdjDwT
 KZcUjRup8JN74dsQOx4VUO+7A57n68YQsBqrBHfjAuDPJuxc88s6YhXsQHmKOXaluHF+QWh+4YV
 eGFjPhPdjk4mP/sjXpQ==
X-Authority-Analysis: v=2.4 cv=K7AS2SWI c=1 sm=1 tr=0 ts=6a615a01 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=BBChT4-wVwiCfiflK1sA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0 adultscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607220234

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
index adc146214e66..5950f143e9a1 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4090,11 +4090,12 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
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
@@ -4110,6 +4111,22 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
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
@@ -4130,9 +4147,10 @@ static void ibmvfc_tgt_prli_done(struct ibmvfc_event *evt)
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
 
@@ -4174,25 +4192,30 @@ static void ibmvfc_tgt_send_prli(struct ibmvfc_target *tgt)
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
2.55.0

