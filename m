Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7B4525A75;
	Wed, 16 Sep 2026 23:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600195; cv=none; b=lUXl0+M1/gePj2Lja7J2EqgXTYCjWohF+WEPLofB6CkQHWfyKfVMkq5PEwARc3S7W5ZOEjUXJARH7St4P3ZnAUPm1k1xv/0089Hq8U7N+5QsMdTVKKmLFqaU54Je4gH1H1eKHYUmkRgklBWbv+FqCbhiUCkLZRi4cvkYPL9/5wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600195; c=relaxed/simple;
	bh=lMnCOqW9twuqplBoKPo1DuqP9I+1zxHFDl4oiA13QZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aqtq6vTVSLPq7PVRQ18nwQtbfe9zb6d1Jd3xlpOh88+S/ymSymMQPaYMDx5vjiupKrf3IIPJcjzoCFTXVUDQjeBBDn1eV0kIDqDF18tUlrPO4wDOqAui4TEdt/yFI+UYVTaV7CFkFqIZUvemb69T5UpbQdZZVBu4QhOK/RdJBjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=H6h8ayxm; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="H6h8ayxm"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1her018055;
	Wed, 16 Sep 2026 23:09:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9D5mYXYJ/iFbWNghP
	D2J7ml+M5BIYyM8rFvM7PPc8no=; b=H6h8ayxmb21o3Z4dxgX8VAkQFUA8uko1g
	wezQXR5LBZyJj7a2oL2rTblTqT1gdBpF/giP4bHFzbkBwR/sTFHvWSjnxJF/h9ZZ
	TpBDdFGQAGjxZsd+IeuQXYzknxKYDuXtvCRPTj4N/Mn9u46KgkXWXpO0C0EafycR
	S8IEsciVURIqiJUj8qCaYDwQgRkck2djgHmwjm7y3dFy+DmhFus7Nqk1B0nDbnsG
	KMVZOIW3UbDuGBjkWUmVtdfPNCa52Ry/jF6QhOwhVQuiPkLW/QkDn9/XedIJSK4s
	nBeeOcCmvTFGlB0go5nvEkokGyfR0xWBe6vXUiL+KvwFKlc4kIXqw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf57dxk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GN0FJC1625390;
	Wed, 16 Sep 2026 23:09:49 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gpyxsgw7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:49 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9mDv16515834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:48 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7651E58056;
	Wed, 16 Sep 2026 23:09:48 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 867F758054;
	Wed, 16 Sep 2026 23:09:47 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:47 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 19/20] scsi: ibmvfc: fix concurrent SCSI and NVMe discover-targets race dropping targets
Date: Wed, 16 Sep 2026 16:09:20 -0700
Message-ID: <20260916230921.2204729-20-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916230921.2204729-1-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IHabPtbunrr8X0z-sbLDx-geB87DiOYi
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX2zKbsob9TTW+
 14SxSlj0AtS0mJi0Oebmus5UYerpUCAfZp2YeNd1lDySu6PYpM6e2Evj6vBKxfFLINirslRIpSF
 cnTopY8ZSTwhgpXjMxnT5z1tT9SUg5U=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aab21be cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=yQvEpV7r-B_hb1frPhEA:9
X-Proofpoint-ORIG-GUID: IHabPtbunrr8X0z-sbLDx-geB87DiOYi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX3SbIltLGwaql
 WEfpL88G3HqOlJ9nIVVsxTgyp+5RMP2kqulcrAGhN2bbnJb2MvZM4B88xmBPzWxj4evRAdPs+fT
 Nf7nPtFLooGQVTXbYJfJg0ZscpsD+d1PfVQ0qNtoISVJhlAx1OqQ6GNqdOh6CzP74nnAN2RAS5G
 95mlsLG8nFSLvGx+J/aJORzpPnmL6lRTB68fvdbqopv5hbb4pLJRPa73r5ZCA6ZVt+33LliUVoC
 BWEk7MsSGsjELH5BDgYIRiPrMsFoxD4z/aGqcJYBA4ab9YfA/NA3DfJmkTbyVflgBOxo5nvoN4i
 gMmpVz17tA5l9OAzb7O7HWCZ3xrpGjyMPeHU+X4x9fHkuCMRCbpf40n5aAYEcJp8LYbSeopqLOE
 xgFD6Thlcczreiu5oDHA03MSMxRwCEAOY+UZR80lzh6MC7zX32zyt3kwYEKD59L1celrBiXN2ne
 bO4qh+PJztWOFoPgAIg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160322

ibmvfc_discover_targets() sends both SCSI and NVMe discover-targets MADs
concurrently.  ibmvfc_discover_targets_done() unconditionally set
IBMVFC_HOST_ACTION_ALLOC_TGTS and woke the work thread on the first
completion to arrive.  ibmvfc_alloc_targets() then ran immediately,
reading both channels' disc_buf and num_targets fields.  If the second
MAD had not yet completed, the slower protocol's num_targets was still
zero from the previous discovery cycle, and all targets for that protocol
were silently dropped.  The second completion then attempted to transition
to ALLOC_TGTS again, but the state machine had already advanced, so the
transition was a no-op and ibmvfc_alloc_targets() was never re-run.

Fix this by adding a pending_disc:2 counter to ibmvfc_host.
ibmvfc_discover_targets() sets it to 1 before sending the SCSI MAD and
increments it to 2 before sending the NVMe MAD (skipped when NVMe is not
active, leaving the counter at 1).  ibmvfc_discover_targets_done()
decrements the counter on success and only calls
ibmvfc_set_host_action(ALLOC_TGTS) when it reaches zero, ensuring both
discovery buffers are fully written before target allocation starts.
Error paths already call ibmvfc_retry_host_init() or ibmvfc_link_down()
which reset the state machine, so they do not need to interact with the
counter.

Fixes: bffd16f59061 ("scsi: ibmvfc: add logic for protocol specific fabric logins")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 6 +++++-
 drivers/scsi/ibmvscsi/ibmvfc.h      | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index d79a6ae278a2..b0d9000b4a0d 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -5156,7 +5156,8 @@ static void ibmvfc_discover_targets_done(struct ibmvfc_event *evt)
 					      max_targets);
 		ibmvfc_dbg(vhost, "%d %s targets found\n", channels->num_targets,
 			   proto_type[channels->protocol]);
-		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
+		if (!--vhost->pending_disc)
+			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_ALLOC_TGTS);
 		break;
 	case IBMVFC_MAD_FAILED:
 		level += ibmvfc_retry_host_init(vhost);
@@ -5220,6 +5221,7 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 	}
 
 	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
+	vhost->pending_disc = 1;
 
 	if (!ibmvfc_send_event(evt, vhost, default_timeout))
 		ibmvfc_dbg(vhost, "Sent discover SCSI targets\n");
@@ -5236,6 +5238,8 @@ static void ibmvfc_discover_targets(struct ibmvfc_host *vhost)
 		return;
 	}
 
+	vhost->pending_disc++;
+
 	if (!ibmvfc_send_event(evt, vhost, default_timeout))
 		ibmvfc_dbg(vhost, "Sent discover NVMe targets\n");
 	else
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index df0775183d72..a984b81f1d23 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -1006,6 +1006,7 @@ struct ibmvfc_host {
 	unsigned int do_scsi_login:1;
 	unsigned int do_nvme_login:1;
 	unsigned int do_nvme_register:1;
+	unsigned int pending_disc:2;
 	unsigned int aborting_passthru:1;
 	unsigned int scan_complete:1;
 	int scan_timeout;
-- 
2.55.0

