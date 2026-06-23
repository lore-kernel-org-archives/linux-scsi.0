Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC32388369;
	Tue, 23 Jun 2026 01:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178261; cv=none; b=ZY88cgP/owJPDQJDu8C3m1Jc1+TcnR+D/Xgt7IRJlWgnAu1M5NvJDMug5D0Pl02crvhtCg0GuLTANOu8FaBusXJw7dsvBoqMKr5FnKpJP7ZBas1i7XIp2cx82LUaxaW9ZnalsvV9knvFgkIl7kZKH0LDTMzQJGkzIrzn6gvHcp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178261; c=relaxed/simple;
	bh=Y8WXa7edePBEuYTt/0TfDKQ4cp327ercJmnETvUeu7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaPwgrszIvOzsLsGXfLXZIIdt/Sm1sfksjKrvz4b/ClORXTn+8vY7i6U+5S/QLA7Dcx1gATwdJRsEZmnTW0RHfMJonBfzd5rakAooDWR1z+mFJ12pXYSxVsy0fCQA9Ty9qhjldM+cNQbFrMCZweeWUJeeIar0OA2zmKL2vCMUbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=laLn4NZk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="laLn4NZk"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mSgk408400;
	Tue, 23 Jun 2026 01:30:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Zu8lwfbk9k9is7Ycl
	JbcGJ3+4qEinXCiBBVns9VlEeA=; b=laLn4NZkQv+MhKg2PWXPq3Xo4QNQ2Gebz
	lz0sN5/lXzoeEz6mzmw70OHXiyr3qzri81oMRAXdT00JYgrHzk7e3x6prJEj4Rsw
	uAyQYq4oIPIJSi8l4VHy9kAbR+ksD/5Vrp/6bDKNi+QKOOcxxatCuMhuJPvjeA6q
	XoxCDK+/wy29gikmuSPsCXKsT24pgDkE1yfEJyQryx5FVSrzNRgb0ECAGz407smh
	EL1kpghz4hQX+w6OpTapnuJBwDnUleVaf+MUx5Wj/aN87MrkrqyvJJt1GqLUp2px
	Br2E8Un27onBncuoeFFZgU0O3mPjBLUKsdh1sx6wBQ5wVvFDm3s3g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjc3c4qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:49 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1K2rJ026922;
	Tue, 23 Jun 2026 01:30:48 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7dg0qw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:48 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UkqX26804888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:46 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3547158056;
	Tue, 23 Jun 2026 01:30:46 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95C6A5805A;
	Tue, 23 Jun 2026 01:30:45 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:45 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 11/29] ibmvfc: send NVMe target discovery MAD
Date: Mon, 22 Jun 2026 18:30:17 -0700
Message-ID: <20260623013035.3436640-12-tyreld@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=X4Ni7mTe c=1 sm=1 tr=0 ts=6a39e1c9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=tsEFHN6dr6_4AEcdNwsA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX6T/5fQTLucSh
 +eebV89qXi02k3BBOTvEoQSiTXqZHTLP7LKGUWYZuEdMLKY8Hqq26HXuYe7gSpnsBd243hJ8Bv8
 tcgFgUjj0xH4o+4+CVHJKhD2lPLv09o=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX9MJrW9BLe3c3
 JnksEMFsCLtItXKPM4eemGkcQlJYSYchAUCX59E0njyHRsGHJ/hCZqmpnGIJQAzlTSqlzcOBWrj
 YvgcBJqRcQabNCnLWHET2VM1zmSd5ktAYwpu6iY6TzHkTUfghiE8htWSpUzbYGh7dTO3GwwDUpw
 /q8t7ItNjYm3BoC4ZtUlSMUSiOmbyTAWIOcqjuaCj9A5ozGnLGDTkR73Ypwmj8XicT/2bdIlApg
 Nm6S2s9VTWNx0bzSzGEOCVJFoqdF4DiPuwRpNOAzOYD2ZQXpem1AcpDMY+W5NB9tt4TfA3y+8dh
 XqYX8JBHhZZIWovC6KAUDcXBXPunXfq9RjkTbS3UFdQjevE5b1/j7NttgXRB8mwrKP6XUDx+6kj
 A2ANo1TgGJqmdKdphNOfqF0P5o6x6K2rYhGW+zO4qc9i83WYdYDSSq1Vd9SxXr0ABJ4cM/5wxnG
 RyzDL8nWSeiyk1oNP2A==
X-Proofpoint-ORIG-GUID: ae8TdaSVn_s0-OghHjUSUnorX6U4mgTT
X-Proofpoint-GUID: ae8TdaSVn_s0-OghHjUSUnorX6U4mgTT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Extend target discovery to send protocol-specific discover-target MADs
for NVMe/FC.

Use the protocol-aware discovery helper to build an NVMe discover-target
request, submit it when NVMe/FC support is active, and process the
returned target count using the NVMe channel group's discovery buffer.

This allows the driver to discover NVMe/FC targets in parallel with the
existing SCSI discovery flow while keeping protocol-specific target data
separate.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 50 +++++++++++++++++++++++++----
 1 file changed, 43 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index efac82c48258..53480d150042 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -173,6 +173,11 @@ static const struct {
 	{ IBMVFC_FC_SCSI_ERROR, IBMVFC_COMMAND_FAILED, DID_ERROR, 0, 1, "PRLI to device failed." },
 };
 
+const char *proto_type[] = {
+	"SCSI",
+	"NVMe",
+};
+
 static void ibmvfc_npiv_login(struct ibmvfc_host *);
 static void ibmvfc_tgt_send_prli(struct ibmvfc_target *);
 static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *);
@@ -5001,19 +5006,30 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_discover_targets *rsp = &evt->xfer_iu->discover_targets;
+	struct ibmvfc_channels *channels;
 	u32 mad_status = be16_to_cpu(rsp->common.status);
+	u32 opcode = be32_to_cpu(rsp->common.opcode);
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 
+	if (opcode == IBMVFC_DISC_TARGETS)
+		channels = &vhost->scsi_scrqs;
+	else
+		channels = &vhost->nvme_scrqs;
+
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
-		ibmvfc_dbg(vhost, "Discover Targets succeeded\n");
-		vhost->scsi_scrqs.num_targets = min_t(u32, be32_to_cpu(rsp->num_written),
-						      max_targets);
+		ibmvfc_dbg(vhost, "Discover %s Targets succeeded\n",
+			   proto_type[channels->protocol]);
+		channels->num_targets = min_t(u32, be32_to_cpu(rsp->num_written),
+					      max_targets);
+		ibmvfc_dbg(vhost, "%d %s targets found\n", channels->num_targets,
+			   proto_type[channels->protocol]);
 		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
 		break;
 	case IBMVFC_MAD_FAILED:
 		level += ibmvfc_retry_host_init(vhost);
-		ibmvfc_log(vhost, level, "Discover Targets failed: %s (%x:%x)\n",
+		ibmvfc_log(vhost, level, "Discover %s Targets failed: %s (%x:%x)\n",
+			   proto_type[channels->protocol],
 			   ibmvfc_get_cmd_error(be16_to_cpu(rsp->status), be16_to_cpu(rsp->error)),
 			   be16_to_cpu(rsp->status), be16_to_cpu(rsp->error));
 		break;
@@ -5066,7 +5082,7 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 
 	if (!evt) {
-		ibmvfc_log(vhost, level, "Discover Targets failed: no available events\n");
+		ibmvfc_log(vhost, level, "Discover SCSI Targets failed: no available events\n");
 		ibmvfc_hard_reset_host(vhost);
 		return;
 	}
@@ -5074,9 +5090,29 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
 
 	if (!ibmvfc_send_event(evt, vhost, default_timeout))
-		ibmvfc_dbg(vhost, "Sent discover targets\n");
+		ibmvfc_dbg(vhost, "Sent discover SCSI targets\n");
 	else
-		ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
+		goto link_down;
+
+	if (!ibmvfc_nvme_active(vhost))
+		return;
+
+	evt = ibmvfc_get_disc_event(&vhost->nvme_scrqs);
+	if (!evt) {
+		ibmvfc_log(vhost, level, "Discover NVMe Targets failed: no available events\n");
+		ibmvfc_hard_reset_host(vhost);
+		return;
+	}
+
+	if (!ibmvfc_send_event(evt, vhost, default_timeout))
+		ibmvfc_dbg(vhost, "Sent discover NVMe targets\n");
+	else
+		goto link_down;
+
+	return;
+
+link_down:
+	ibmvfc_link_down(vhost, IBMVFC_LINK_DEAD);
 }
 
 static void ibmvfc_fabric_login_nvme_done(struct ibmvfc_event *evt)
-- 
2.54.0

