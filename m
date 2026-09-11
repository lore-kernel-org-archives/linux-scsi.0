Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8323C3C06;
	Fri, 11 Sep 2026 02:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789092508; cv=none; b=Ci9BZFHLYO3c0Au0+oK2O2oJUshReWYIAYTzUjI+a40Wa+Ewxoq+yFsLQXRJB7X4dwF6nNMtS8I3+W23aAq2Zzt4o6ZqBG1ssso0BkebP/gnAIjYLnJvNwfYDenh2SdOoxWtEtyO0JM5UG+0cYdGJktc9VSF1/PM/n6G6f7SGOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789092508; c=relaxed/simple;
	bh=9qD3huhzPJ6kQpb04F2WEeP5N1J95nYBIWAjm6IYUGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTHk0v68CYe3pBs4PwA9GMVM/zIskYivvwShYGCn0vbPRaVcXccIE78z9oQ5xdyGky3wTGw9a1VmdKAO9I3dLruC2b8S/Ipyqe9gPTnOWbE/ik8Wv/1mVxm9YcBL+Ddi0/vc1T/KaPJuexQr6SjQem7SnEPf9x6LGraBbqxbGdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jADBRVpW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jADBRVpW"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12Nwa3366925;
	Fri, 11 Sep 2026 02:08:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=hB/jsEmW11ikjkO8k
	0FYDltf+WJSh6vxZDEuJtTTnCI=; b=jADBRVpWAQAiJC1rTaYxTceFG0MskgC63
	U1gEHeYpjWCNatCZHgGxSl97WrosQLPGluLnqx00rhtI80bu4Tc38h5PvWhDjyee
	Xr+7AwPdKPo9T72DCsOL3cosAKiAn33FVrxaX6vMHNhlAoGYTf+OHCoip6nZoyLf
	BvCiWSzzMjycBcZIZ0jSPtQyGF8oG7OafLsUFHEecEN1U0EpbNMf8KB4lawoveDF
	jiRNkvJnxUIx/LSoClmhksLWyoZbr0ujfdkKaU03SMaXtm31nMuFN/lLJv85F4fK
	0wOvIjsZC7pNAeMRFd2qiAk0vXukp1AfIlWR6bao23l7RsXAfF5og==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8q8puu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B152NZ892168;
	Fri, 11 Sep 2026 02:08:20 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvtfbu7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:20 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B28JA530999148
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:08:19 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A8E75805A;
	Fri, 11 Sep 2026 02:08:19 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91FA15805E;
	Fri, 11 Sep 2026 02:08:18 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:08:18 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v9 2/9] scsi: ibmvfc: add NOOP command support
Date: Thu, 10 Sep 2026 19:08:08 -0700
Message-ID: <20260911020817.1033789-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kWEKGaODSiopfrF8Rnlop1f3FMrec0v6
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX0WUElv4LdYJk
 RpUPcJb0xMBZfJwVV8zaJzHCe1Oql+fcXWkbt9p075zQlubn8COHs3De5OjrFuXl8JIFu2eEkQ8
 MLkq+qRtEk3bfifzdTJbnwUMGnTJ2ac=
X-Authority-Analysis: v=2.4 cv=E/dYNqdl c=1 sm=1 tr=0 ts=6aa36294 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=dMUBAgKGejxRm0SXrm0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfXzAA7Bq0EeXuK
 2zaI0FLwlDucSZNgXzStI2ApNpq8olEFWnLYMyFABCvDD+hw/NFLoK6IXz+KLr8CLW9rg5HF2LO
 wLx6pVQX0IZlmSms690PU/OFinwFp5qEoUX5VbwyOBYAPJOnKd88lghtzzA/R+0AUMIn3Ms5Bkd
 INnBkQs8pCI8RgL9QIURb183kTSCyM97r11dVCNNVb42ekwRZK1kmm0r7DZHJjCf4BvezTGpdxA
 9c6d+nw0kFEmT7DhgYiepgIFT///ukgynrZ0tjhjmQro+eWaT3wiKjC6OCs9iq816m1EIpF/DIq
 Hel8/CBKiK09ZqDtCxAqQVI/YnKnKkZq7rD1SpKrglsEJZLq5VbuQiCokuw1ljH52gMTF7LXIxM
 8ME+NJ0sQujrO9TeZVrkByJ6BzkrnegibiZBIY7Lf0p9wHFccMJWFG8wHP0le1r/u636tZJkIps
 9nR/kobbmpXG0sCwlUA==
X-Proofpoint-GUID: kWEKGaODSiopfrF8Rnlop1f3FMrec0v6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110024

From: Dave Marquardt <davemarq@linux.ibm.com>

Add support for handling IBMVFC_NOOP format CRQ messages from the
VIOS partner.

Advertise the client's ability to handle NOOP commands by setting the
IBMVFC_CAN_USE_NOOP_CMD capability in ibmvfc_set_login_info().

Handle and ignore IBMVFC_NOOP format messages in both ibmvfc_handle_crq()
and ibmvfc_handle_scrq(). In both handlers, log a rate-limited error if a
NOOP is received while in the IBMVFC_ACTIVE state without the partner
having advertised IBMVFC_SUPPORT_NOOP_CMD.

In ibmvfc_handle_scrq(), also fix a typo ("Got and invalid" -> "Got an
invalid"), add a missing return on invalid message types, and guard
against null event pointers before processing CRQ responses.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 5259a80958ce..6b2eb82ceb98 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1578,7 +1578,9 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 		login_info->flags |= cpu_to_be16(IBMVFC_CLIENT_MIGRATED);
 
 	login_info->max_cmds = cpu_to_be32(max_cmds);
-	login_info->capabilities = cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN);
+	login_info->capabilities =
+		cpu_to_be64(IBMVFC_CAN_MIGRATE | IBMVFC_CAN_SEND_VF_WWPN |
+			    IBMVFC_CAN_USE_NOOP_CMD);
 
 	if (vhost->mq_enabled || vhost->using_channels) {
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_CHANNELS);
@@ -3695,6 +3697,14 @@ static void ibmvfc_handle_crq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost,
 	if (crq->format == IBMVFC_ASYNC_EVENT)
 		return;
 
+	if (crq->format == IBMVFC_NOOP) {
+		if (vhost->state == IBMVFC_ACTIVE &&
+		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
+			dev_err_ratelimited(vhost->dev,
+					    "Received unexpected NOOP command from partner\n");
+		return;
+	}
+
 	/* The only kind of payload CRQs we should get are responses to
 	 * things we send. Make sure this response is to something we
 	 * actually sent
@@ -4225,7 +4235,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
 	case IBMVFC_CRQ_XPORT_EVENT:
 		return;
 	default:
-		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
+		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid);
+		return;
+	}
+
+	if (crq->format == IBMVFC_NOOP) {
+		if (vhost->state == IBMVFC_ACTIVE &&
+		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
+			dev_err_ratelimited(vhost->dev,
+					    "Received unexpected NOOP command from partner\n");
+		return;
+	}
+
+	if (unlikely(!evt)) {
+		dev_err(vhost->dev, "Received null event\n");
 		return;
 	}
 
-- 
2.55.0

