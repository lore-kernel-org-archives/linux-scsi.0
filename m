Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30066388390;
	Tue, 23 Jun 2026 01:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178263; cv=none; b=C8YHYMkkRfTvTqizYupWd3SsmgkeYr37HmGGU0AH7/B94pdSIZzE5/vi7WLpHARG6DjCfsXrKuvnzOOoJSjI2xEtGe62gkomOTFsg2OR0dJV4krPPsngQrbDcs1P5rei84B7Z+FeOCe5/RvYWJTeVxlUzzSR4yc33RfnXMwSNlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178263; c=relaxed/simple;
	bh=1PX5i73VXaP20dxV9C4kQ38jpD9lnFQyft4c9G1D4+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ge1pP/57gMhNnX5Yu6OcpiulGdI1+whwaj1lLE6Ku8/ZXhl1mS/ksAVRwTsspJUfBra7GdX8FiVX3X5fYJDBSTXuSZ6Dv8besaruhRW8ZkuMZaqnjWXcD2dw9qt0Fg8iYXkXvB7+UQM5jzTD9w75aoJDZahL4029TOvSVEuhuxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oN/7B0ks; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oN/7B0ks"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mRCR550865;
	Tue, 23 Jun 2026 01:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lUcHaQeyG0kbFMmXJ
	Gyu7uR1kpkah6YkBgOsj+50H+g=; b=oN/7B0ks2/EZkP37RjNLxI6SLfEa37WTp
	Mz9Is/1NFpISTp3tsNdYoT++iuj4RGkymlJqFZQSa0LSXJfS08/BJ/ZYSu6FtElK
	Nqi07TCNGVrcuLGukg29T8YHGhDwDjNvwejd6O6NHBqAkH6ZQzihKMZ9A0ROT4q0
	l1kD9Hjs3uf9D8ST17tK3zL+dgC3VTVmn8avOIU3SOlhlZBd3ufqqnYPLpDxc+8Y
	J6/ZeWdRp2k4VlkJXcEVNh+bwEHfODi6RMuc8cPGDsMX1qCfla0CVLcTAXsP7zsT
	IlqUjZlCBK0Y7wYAMB2dZ42lWqgZH4M2XEemF3csqgC5UnA41GhKQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjhqm1s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:50 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JhxY014684;
	Tue, 23 Jun 2026 01:30:49 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex6ph8vm2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:49 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UFAn53936404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:15 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D52758062;
	Tue, 23 Jun 2026 01:30:47 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 095FA5805A;
	Tue, 23 Jun 2026 01:30:47 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:46 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 13/29] ibmvfc: add NVMe/FC Port Login support
Date: Mon, 22 Jun 2026 18:30:19 -0700
Message-ID: <20260623013035.3436640-14-tyreld@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=I4VVgtgg c=1 sm=1 tr=0 ts=6a39e1ca cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=6rG7Qs-5UubFV84h7OMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX/9HCxXJ03zg7
 0u0UNbkCb60ytlAfGrtrI5hyUSG/Wj/5uDPORUemdXOQhBLWuOBqdHzw7iigdfTDwcoXTLgFgRw
 PtY6oaVDX90jDzB56nDjByzGOwHSSYWa4eXNmerNJMV9eNXE0rxrrco94ixwYcV6OK9eRYpnsSQ
 ii5evvL72zfXwuBWejDC+/tY+nL00AAWPrVnxFhk1FJyJxL9CdAZbt9wrP4utw1tTxUI4hXajIG
 HazKfdSRpcPQWI8JlUrxdLo9AYTFAzHKeJtzmmefqb6ONoSutEHLZ6iE63W8BoK8BoGG2Q4LO8X
 atqoDbmX8rGLmFtQydlR5ageLDI1T3cb8QTfnhYPOeS7ph/F1AEYzfp0agUfsTxoNebsigIBatC
 mG8QyuaX3F4buHRFPgIGYNfKSL8qEl5Po2cRtEEOvQ5x6nJ2+UCIuGCOi645wx2oS1q352SwzRO
 MRMYnw1psJRx/lmkN9g==
X-Proofpoint-GUID: RyhtUiyP8rcXyedkmvpJbUHrgxzrPUqt
X-Proofpoint-ORIG-GUID: RyhtUiyP8rcXyedkmvpJbUHrgxzrPUqt
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX1NqtprH4si3s
 RwH1XyEZJSNry2XSUs5le3eH84lyNpP3qDCCFTh5gtEfYn9XyFqK3XyjhqasqMemz0CZ7dL/BrT
 QdqqjY4K9UrBrxbrR565tWEY9XSlFUY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230008

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
index 3e3d77e0d517..2c54d0b9add4 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -4210,7 +4210,7 @@ static void ibmvfc_tgt_plogi_done(struct ibmvfc_event *evt)
 	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 	switch (status) {
 	case IBMVFC_MAD_SUCCESS:
-		tgt_dbg(tgt, "Port Login succeeded\n");
+		tgt_dbg(tgt, "%s Port Login succeeded\n", proto_type[tgt->protocol]);
 		if (tgt->ids.port_name &&
 		    tgt->ids.port_name != wwn_to_u64(rsp->service_parms.port_name)) {
 			vhost->reinit = 1;
@@ -4238,9 +4238,9 @@ static void ibmvfc_tgt_plogi_done(struct ibmvfc_event *evt)
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
@@ -4286,7 +4286,10 @@ static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *tgt)
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
 
@@ -4295,7 +4298,7 @@ static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *tgt)
 		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
 	} else
-		tgt_dbg(tgt, "Sent port login\n");
+		tgt_dbg(tgt, "Sent %s port login\n", proto_type[tgt->protocol]);
 }
 
 /**
-- 
2.54.0

