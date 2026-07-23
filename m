Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13177280035;
	Thu, 23 Jul 2026 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764937; cv=none; b=kdYggVjvjRdVqNoPjQrZrYtdxRLkEdEPh3REYCZ/fXbSL546vEHm+0HKt9CsLeUzx6WV93qJVXSmAPCJFvpHoA3/7JB+3F/L2ZzVnqWY+rH8GWRr/gII6KWTKZlGC+pbV2srZ/ow6+Hl26NfnJeiJUdBTgxzeCxJJBDSY/Fls+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764937; c=relaxed/simple;
	bh=1FmI0xZDxl0OUKydPNlL9j035hNUnbMb+0Od8wi8Sj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miYpP5LPCoMTT0Bo0vBdN78kHpAgfolMVBYGGuwf3J9/8aK5rgj99/J7uuJR6RTsC6IJVw2NI0Oiqv6Imfbcpce6KAhzLuP/vRyPriBbJh+hFEYpOJLU/5oJSvUx79N5rpp41Unjnafp/a333wO1/xIodiS2QHsJ/0MzaOgJ5Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dDcASaBv; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dDcASaBv"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBr4a606181;
	Thu, 23 Jul 2026 00:02:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=5T3t5wko42x8GZLKI
	QnyK5Y8+nUeiQvsNZVby6tzL18=; b=dDcASaBvQRurdagr6lshMen6sM6gprevE
	z1eUDIYAlI00Zlce1esdNAXPIM3w6TKspfKhYKT+arO0vs0KasLtwhK9CM4XFKfg
	hazx1w5W2b4dT9WyCfH77HEZGSqLQmUTTFajTle4Tt7FHLwfHH1+vLXpm9PtGco7
	f3YGPt2pWUc+zaDECdmVfeSeIoibwmkiFqY+U7V66N0KgCVO40C6yD7zK91ZSFU8
	p7loNv0Q8O4MutST+Z8HhfARcx/fAEjOpd+Sz3RYv1h6gZMs7DTKg7LIr8scOSOU
	G1qAV4/k9eb1LMsKHB9D4uDwTOyDpmRzovtfj/LePIt/OwMn7hBQw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg78gcc0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnaeO009366;
	Thu, 23 Jul 2026 00:02:08 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1ghjaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:08 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N026Q129033148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:06 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C9FA58056;
	Thu, 23 Jul 2026 00:02:06 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8257558063;
	Thu, 23 Jul 2026 00:02:05 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:05 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 17/33] ibmvfc: add NVMe/FC Port Login support
Date: Wed, 22 Jul 2026 17:01:33 -0700
Message-ID: <20260723000149.969416-18-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX/yc3bPWMh8N7
 1XYE51KdIriGcxIBHRB/RmRZarOEol//Qw0IHBBIWXU22O58JunrktRgSuuh9O5zChQBYzi/3vx
 bortUrdB/0/ZYS0Q2cMwod7J2EqpVr0puDx1C4cVmJvJEGLfZqJ2db80XN21ltBMAlBwZY6wCRD
 Q3Pi43SGhVro1jKjshcTym4JDQEK27FHGuzQNbMYpcYe3gRQ0oBxKt0hsqF+fRotJlImDhBPmau
 yi/IQrKvfsfmU1Qq3TnAPZJ+YnSUHe7PJzqG02w1+1SIAZi4ey213mDp3P/4DMhfcxGsZ7sadw2
 bZE+yfhtxFXVRmJXiuxEbgZqBJrXUxyCRcJBbFDhZf+///r1j7viRGsiordqJzsSpgmcWh9Y0hb
 M/4c+ux65fDjyeybwwhX4jQyVLdM6pqThHUohuZ6HzanXmD5SSTQH+xdWHCKLKSNqc4t73+NoBU
 WTYGu7jwlWG/MuOCrpw==
X-Proofpoint-GUID: jsa1z3KzLTsohhNb5xsmBti4VSF2vDV7
X-Authority-Analysis: v=2.4 cv=MelcfZ/f c=1 sm=1 tr=0 ts=6a615a00 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=6rG7Qs-5UubFV84h7OMA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX1/f5J2uBAf/T
 IuJgLaceccSGcrq6f39OgDHorqS45eyyxfBRMzkNGf//BCWlHQYI8iP7ZVE0qIbh881hF/ma5Js
 3bJFx4EYCrpHIRkd647bsTrYHE455aY=
X-Proofpoint-ORIG-GUID: jsa1z3KzLTsohhNb5xsmBti4VSF2vDV7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

Expand the target login path to issue the NVMe/FC-specific port login
MAD for NVMe targets.

Select the correct PLOGI MAD opcode based on the target protocol and
include the protocol name in success and failure logging. The rest of
the target login flow remains shared with the existing SCSI
implementation.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 66fcff7ac834..adc146214e66 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4212,7 +4212,7 @@ static void ibmvfc_tgt_plogi_done(struct ibmvfc_event *evt)
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 	switch (status) {
 	case IBMVFC_MAD_SUCCESS:
-		tgt_dbg(tgt, "Port Login succeeded\n");
+		tgt_dbg(tgt, "%s Port Login succeeded\n", proto_type[tgt->protocol]);
 		if (tgt->ids.port_name &&
 		    tgt->ids.port_name != wwn_to_u64(rsp->service_parms.port_name)) {
 			vhost->reinit = 1;
@@ -4240,9 +4240,9 @@ static void ibmvfc_tgt_plogi_done(struct ibmvfc_event *evt)
 		else
 			ibmvfc_del_tgt(tgt);
 
-		tgt_log(tgt, level, "Port Login failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
-			ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
-					     be16_to_cpu(rsp->status), be16_to_cpu(rsp->error),
+		tgt_log(tgt, level, "%s Port Login failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
+			proto_type[tgt->protocol], ibmvfc_get_cmd_error(be16_to_cpu(rsp->status),
+			be16_to_cpu(rsp->error)), be16_to_cpu(rsp->status), be16_to_cpu(rsp->error),
 			ibmvfc_get_fc_type(be16_to_cpu(rsp->fc_type)), be16_to_cpu(rsp->fc_type),
 			ibmvfc_get_ls_explain(be16_to_cpu(rsp->fc_explain)), be16_to_cpu(rsp->fc_explain), status);
 		break;
@@ -4288,7 +4288,10 @@ static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *tgt)
 	} else {
 		plogi->common.version = cpu_to_be32(1);
 	}
-	plogi->common.opcode = cpu_to_be32(IBMVFC_PORT_LOGIN);
+	if (tgt->protocol == IBMVFC_PROTO_SCSI)
+		plogi->common.opcode = cpu_to_be32(IBMVFC_PORT_LOGIN);
+	else
+		plogi->common.opcode = cpu_to_be32(IBMVFC_NVMF_PORT_LOGIN);
 	plogi->common.length = cpu_to_be16(sizeof(*plogi));
 	plogi->scsi_id = cpu_to_be64(tgt->scsi_id);
 
@@ -4297,7 +4300,7 @@ static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *tgt)
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
 	} else
-		tgt_dbg(tgt, "Sent port login\n");
+		tgt_dbg(tgt, "Sent %s port login\n", proto_type[tgt->protocol]);
 }
 
 /**
-- 
2.55.0

