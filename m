Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A333538645E;
	Tue, 23 Jun 2026 01:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178256; cv=none; b=CMqaNVh5sziSR5Sm/e/T1wA7azr6E/IeI1Bv4ksy06bYHpVkcRWWZIlkTKMnqxzYiuZtrZLaZJukaIICILP3Azy7vqc0+RZ9s6TxhqSDDUTx2boStMHjLnMHiEpOEP9l7gS6N1l+FRqSX01FoVCLFlb3ZUwlasyoouRRwRUxicE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178256; c=relaxed/simple;
	bh=Dx+W0a/bfnBZyJBoiSSP8iL5YnY+G/Zymd2bM07QAzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyaOZz8ViC8nP2m/yZcufjI878NFceVOpCpXcAWzC8eji/27Y+quKTzPOeBOq6oUqiT/2O07O2lx4o75K+g9k+20gYMTUzHa0q2JCOMcberEJgtRB5S9g+JGfTyP4ZqRdTX0G5WXKNlByEiSgp7BzAQL7kbLKppCFUQ57u/THnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kpvsTO5i; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kpvsTO5i"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mIPG351946;
	Tue, 23 Jun 2026 01:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+Pe7eMy18jMcMEO2i
	Y1dgSFJ0QOXCSU6InEbIX6CsEA=; b=kpvsTO5iztFzmfqr8C82R4kos9C7VXIK+
	iwXRzhfI3v6elmEiPJHvAzVcZqDSzhwGGboI3zflnxN5li7Bedpkx6gvwuo02jZO
	UG/6p2z/S+xNk22zpHeGOIytUG0wgR+l4qxQMLU8yWrU+oiXEPnhsw6P42Spb9f3
	RK5D+zyPqt0X4yjqJ9xBcjdEpX9qNQ5HWn94DJZC+84u+EeeiWH6Fu/AEzeoPxwW
	DkBh00a01EkqtySozSKFCVlPk3dIEshFjs++6FJGyzpaVAEfX0jGKvI6sb/8P6jR
	Z7ltOgH8Uys1hw2n3rduMWMlWbHWfV7utypc1SwX3MGHaZ1Otr4jg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjk4c37v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:45 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1Jnob026340;
	Tue, 23 Jun 2026 01:30:44 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7dg0qvw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:44 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UiKL25625222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:44 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12F4858052;
	Tue, 23 Jun 2026 01:30:44 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7336558056;
	Tue, 23 Jun 2026 01:30:43 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:43 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 08/29] ibmvfc: add helper for creating protocol specific discovery event
Date: Mon, 22 Jun 2026 18:30:14 -0700
Message-ID: <20260623013035.3436640-9-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX1135sYH+HrDe
 w1a5sA4O21HiQdJdCsfEz8LabNxtIxadZ2IOTnoSkoddLIAxDl0oiWT6UfxohtZVIUWtDdMPhjF
 29DfBg+DGSsDLFGcih9DSy4mXOz5CLc=
X-Proofpoint-ORIG-GUID: 7T31hUlYrZUq13Jz43nXXmNIN7vOAkzp
X-Authority-Analysis: v=2.4 cv=Oph/DS/t c=1 sm=1 tr=0 ts=6a39e1c5 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=cvol4pHx2ldDu_PevKwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX2gKhE6HALFo2
 tahSL5XrodhA8cTPxKaBsFWqLhzi8617dd0Hsq7dLWJ98zvgFU4IIbvb4Ry+NVrY34WtnzKMQ7Z
 PprlUujWUtPvvXrAhvLZSjpyJuioXuccN5l2nLKkkHtoI5599BRzyf6CFG8Fs5Kp7X74BYV5yzt
 LHQZaI0koQuNMmwCt4g2FqvUrOfwGN/3RQjs/nb2DxdyMQrhBW2txEq6qUyAIxHWF22xR/std6I
 zmfTde9SgbuMKsuhz+CpdCrZAfpTmkoI/oeaTu0szZgHPVfFBgFjYPvTUETDJ9QL3iJFvGtqjHP
 TnK17pK7JOD3E3/v7N2tvf01sbfR5s+SurTMz68jlULpCpK43hIOywgdN1HCBg/9Q6IUITzAyMM
 0YmQMILxdpR84nUUnghXT2HE/WB92IRbTZRhNRu6qw5uZvV/75xPXT0vUHa+Kyha9I1luNCFkO/
 gamCjIsBc95nMBRKw2Q==
X-Proofpoint-GUID: 7T31hUlYrZUq13Jz43nXXmNIN7vOAkzp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Refactor discover-target event creation so it can be shared by both SCSI
and NVMe/FC discovery.

Introduce a helper that takes a protocol-specific channel group, selects
the correct discover-target opcode, and maps the corresponding discovery
buffer into the MAD.

This is a preparatory cleanup for issuing protocol-specific discovery
MADs in later patches.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 39 ++++++++++++++++++++---------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 93c32fa162f8..8186e9321af5 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -5023,6 +5023,32 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
 	wake_up(&vhost->work_wait_q);
 }
 
+static struct ibmvfc_event *ibmvfc_get_disc_event(struct ibmvfc_channels *channels)
+{
+	struct ibmvfc_discover_targets *mad;
+	struct ibmvfc_host *vhost = ibmvfc_channels_to_vhost(channels);
+	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
+
+	if (!evt)
+		return NULL;
+
+	ibmvfc_init_event(evt, ibmvfc_discover_targets_done, IBMVFC_MAD_FORMAT);
+	mad = &evt->iu.discover_targets;
+	memset(mad, 0, sizeof(*mad));
+	mad->common.version = cpu_to_be32(1);
+	if (channels->protocol == IBMVFC_PROTO_SCSI)
+		mad->common.opcode = cpu_to_be32(IBMVFC_DISC_TARGETS);
+	else
+		mad->common.opcode = cpu_to_be32(IBMVFC_DISC_NVMF_TARGETS);
+	mad->common.length = cpu_to_be16(sizeof(*mad));
+	mad->bufflen = cpu_to_be32(channels->disc_buf_sz);
+	mad->buffer.va = cpu_to_be64(channels->disc_buf_dma);
+	mad->buffer.len = cpu_to_be32(channels->disc_buf_sz);
+	mad->flags = cpu_to_be32(IBMVFC_DISC_TGT_PORT_ID_WWPN_LIST);
+
+	return evt;
+}
+
 /**
  * ibmvfc_discover_targets - Send Discover Targets MAD
  * @vhost:	ibmvfc host struct
@@ -5030,8 +5056,7 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
  **/
 static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 {
-	struct ibmvfc_discover_targets *mad;
-	struct ibmvfc_event *evt = ibmvfc_get_reserved_event(&vhost->crq);
+	struct ibmvfc_event *evt = ibmvfc_get_disc_event(&vhost->scsi_scrqs);
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 
 	if (!evt) {
@@ -5040,16 +5065,6 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 		return;
 	}
 
-	ibmvfc_init_event(evt, ibmvfc_discover_targets_done, IBMVFC_MAD_FORMAT);
-	mad = &evt->iu.discover_targets;
-	memset(mad, 0, sizeof(*mad));
-	mad->common.version = cpu_to_be32(1);
-	mad->common.opcode = cpu_to_be32(IBMVFC_DISC_TARGETS);
-	mad->common.length = cpu_to_be16(sizeof(*mad));
-	mad->bufflen = cpu_to_be32(vhost->scsi_scrqs.disc_buf_sz);
-	mad->buffer.va = cpu_to_be64(vhost->scsi_scrqs.disc_buf_dma);
-	mad->buffer.len = cpu_to_be32(vhost->scsi_scrqs.disc_buf_sz);
-	mad->flags = cpu_to_be32(IBMVFC_DISC_TGT_PORT_ID_WWPN_LIST);
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
 
 	if (!ibmvfc_send_event(evt, vhost, default_timeout))
-- 
2.54.0

