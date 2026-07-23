Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB86B360EF9;
	Thu, 23 Jul 2026 00:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764943; cv=none; b=m1jVNdaT+83sTg+S26g2Y86D2AHtKJC3WSVy0/4tYAiRoePMip23wKYtwpBTC78o5TcdcO6DN4KUcLmzoo/TTFJKOcsu1xmcR3F9hR9RAWoHJo7ZVZPhG69Vt422CwOAF9/6Bfb8ld0MBJLJ/kb5W/2VOGRwqH3rBG+i5Q/XFho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764943; c=relaxed/simple;
	bh=rSIblivDt/BmBKpzCS8ZCThGbbde0mHfR0rFh0FLQs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPE6CCsFLjm4HQ4Vcm4ftpDVZjIqw6qNjBc838cyGraOlRKjiJrUz5Pbd+s6nN3Z0zunfXVnKikC5Mljp/nY8mSz5L8zmUShLp64O0G1J4swHTgb31jn1Sv8AdD/ooxBj6wGb/7E4RSWHruHRg+le7wjsIflq5ledC13BHDXZs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eYU8SD0F; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eYU8SD0F"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBuWI713174;
	Thu, 23 Jul 2026 00:02:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/J48jdanjixDF2dUb
	fBjqE0vgyyWu4PVAZaKChOMabk=; b=eYU8SD0FKpdoRNnt9KoK5D3CIa9/bzXpm
	6v/XBqA8b9TqYJrh774WKTVcypVcKLxyc3I7REmGQn0JHBHtkkFlCCEasVuttyCH
	8DjnrwMoI20ZoZnYiU+GddYdZTzsZP86DS2S+TS2UCWnqYeohQWXCmrj17Z0g+x6
	rHxLbBj/rtY8zEYihawiR8CR0dUzHkILj9ubLUGnpBeTCNLsG3VWdr3ib34KCHgx
	VdMQMtNQzs14UACfJaGvvj8XY3gYPzo1DAN4terfinoKDyy4bpLEaTUkJbPkm4b2
	QqQBPif/b7lcl222gIvETpY8TMsI1IH7Mg3ied6lQWovoXlFtd9lA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7914xpw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:06 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnr2r021831;
	Thu, 23 Jul 2026 00:02:05 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgm6w9ujk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:05 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N024HV30671360
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:04 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C44F58063;
	Thu, 23 Jul 2026 00:02:04 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0940A58060;
	Thu, 23 Jul 2026 00:02:04 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:03 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 15/33] ibmvfc: send NVMe target discovery MAD
Date: Wed, 22 Jul 2026 17:01:31 -0700
Message-ID: <20260723000149.969416-16-tyreld@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: ZTwC0VCp6K9EbmREQ65I2aQHjOnpRmiZ
X-Authority-Analysis: v=2.4 cv=V6RNF+ni c=1 sm=1 tr=0 ts=6a6159ff cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=tsEFHN6dr6_4AEcdNwsA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX1juZ5ywvBmXM
 JoMxT+DEbENrLpN88D4dqpCtXUS95E3rxmLxXjGSM0NlFDo/arYQ9P/kP2oFT8kBpslGokuHclc
 dKje+aTCEBUqOvGTgh/ZR83h+lFWj8Q=
X-Proofpoint-GUID: ZTwC0VCp6K9EbmREQ65I2aQHjOnpRmiZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX/S0rGFDiFBY7
 CaoFJwQlhWdqFpST9m5Qbzmb6pJbkjt0EqH9u2Ep7yW/6j51SKyLwMT4VKQvZvlGxWwJlrmJPlA
 mgIU8X+SbEYQxVhAaN9RqYm+YqJVA9Hov7fz98ajqRMefgwIGtKahZLyOTeM5AvXkjgYxrcQ5Uu
 YIrnDm+BZFJ30jpUwEOcDpJsDA7lgMfpyJJfeaTc1d05Unx3oNxOSLM8EkrnylqLrv6EE6AFOQk
 bpENCRD0neXoYJhIBR5KV5qRvMmRauf+f6P+kq7mfb6b5QqRaUUYH8Lk7cf0Mj7UUlcdInBiSXC
 32hNjywEaNERyd+/WffUJJ/AQhi3zswI3l3qDxHxwMPKgtzkFE5fj+4FUVin5Ei51LbI4iW5Stx
 cjcPvj84nN00w98TTFxVbsoA/v+nVcq9eoKcg7CmrXGO2rkokMpTaMqOAs2ebh2+72mnU2B9VHC
 ABH8uwoFXO6OFc8IVyA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

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
index a700e2554e69..1d2a88e9fe94 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -173,6 +173,11 @@ static const struct {
 	{ IBMVFC_FC_SCSI_ERROR, IBMVFC_COMMAND_FAILED, DID_ERROR, 0, 1, "PRLI to device failed." },
 };
 
+static const char *proto_type[] = {
+	"SCSI",
+	"NVMe",
+};
+
 static void ibmvfc_npiv_login(struct ibmvfc_host *);
 static void ibmvfc_tgt_send_prli(struct ibmvfc_target *);
 static void ibmvfc_tgt_send_plogi(struct ibmvfc_target *);
@@ -5011,19 +5016,30 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
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
@@ -5076,7 +5092,7 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 	int level = IBMVFC_DEFAULT_LOG_LEVEL;
 
 	if (!evt) {
-		ibmvfc_log(vhost, level, "Discover Targets failed: no available events\n");
+		ibmvfc_log(vhost, level, "Discover SCSI Targets failed: no available events\n");
 		ibmvfc_hard_reset_host(vhost);
 		return;
 	}
@@ -5084,9 +5100,29 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
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
2.55.0

