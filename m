Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736611684B0;
	Thu, 23 Jul 2026 00:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764935; cv=none; b=rAy5wUkSj8bVcuD5Ty6Obi3lbOCZcbt61N7GyXpJQfwe1WvDmXQiF37W/AlAFtjsuc1f7HCijmZ25U1DpMb508MCU1HYcDutOxiGABSghWdqHfu6Fc2qwdpG/q1BfnNMZFvakuKWDiDWpfc6PBtxcIkvT2BBLIIT0ctvSp88NhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764935; c=relaxed/simple;
	bh=LIv8A1DVjhPDdmF4lw8uCEO/RaLC53TmvGWVnnxZjVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqmUoo15xGeZGmC17T9EvhqCcjOwFZt2X9J37SYfeQPOeTd6caPAehjnnpelAdzhu6wSjnEur5X5GJevZhLgQdhpvX/SOEkNsIfUKujAUj5R5rRsBWAxeN1Tnj+5DeS0rfklMwg8z6NkgrWW8+mSZlsRl551PzoEkfwbS08r8hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=m2vl2Yc9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="m2vl2Yc9"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIC1nf634553;
	Thu, 23 Jul 2026 00:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=JzjuO0piW/Wlabhoj
	6SakOr3QawIrQcZMn/ofM3+RiU=; b=m2vl2Yc9CTTm1ivWTyLdw6cFknOHwpvkj
	vTMMpklyg+0DdETudapUi2C454GPPO0gjVUgW0K67KoVULmQ8nGXoIpkm0R/7HQ8
	ECP2C3ZorPEycxgXKWhh9IRyaDGOCByRTNDpF/DBrrZQG32iNUesbtQu7zj4/5O/
	DnnBGJDo/FQKQdQ2tdxcx9ZprtqubJ69V/SHG+m0V9K2I6fIrMCcrsKp6KXJ1lPZ
	5rM1SEOrWwOTxo/nABP/UodlgGCDndAXTZN5Bos0/kSYyXnvUgZlghRo2QLqJfWs
	EVmfO+k3WlAuRv8c9AJLUPR9Zatt88/9IO/zWzKOkSCzY/fajG8Hw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg77kce64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnbAd009379;
	Thu, 23 Jul 2026 00:02:02 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1ghj9v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:01 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N020ks12321392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:00 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2BE1F58063;
	Thu, 23 Jul 2026 00:02:00 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C62D58061;
	Thu, 23 Jul 2026 00:01:59 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:01:59 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 09/33] ibmvfc: alloc/dealloc sub-queues for nvme channels
Date: Wed, 22 Jul 2026 17:01:25 -0700
Message-ID: <20260723000149.969416-10-tyreld@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=HJXz0Itv c=1 sm=1 tr=0 ts=6a6159fa cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=7MaZqFay8etFDbkFh6wA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX3kqUY5UjD2J5
 6wRyu46FJFxRrjTpjbyGZ1CQ92s+lD5TRu0ae0RqRFk4PPD1lIGCSQSfASVCeEjkUwMfsIsk2Ml
 jEunYab0eXutNjmW5uKv91/Q39xevSlfb29BHTV+bVYBVMAoutEpLLea0AXK/5zobONYEd9jST6
 lkRU13iAbtIut1cvU72zCmU1ujiDXY5Y56hzSnarpRjsXIEIQ/hBc/c8+RUtkf3iS12AP7PGLjE
 8hX3eg2y4jLDBLtWOlVB1SLH4RfLuAwjh9SmlANaVNRrV3G9zU6V7dfKkMB6TFbJrZmKgs6Q16U
 meuanUyuW1H2apO3u639Yi9yYREXTw8JiKrwu7ydoydBmuKaT5DOBNuxsMhW4G5YSRw8tyv9G7y
 Arg48AcCZ8thjreYU6qR1VR84KZNG6Xytz/b7GsfcaxJCtgnt1CsQPVs4vZd0YHoIwi9LluIGkB
 s5td8QXEvkNV/InoFgA==
X-Proofpoint-ORIG-GUID: V_8h92FWuiE2fwYQs9oMiTylfnaI_xJw
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX5amWqg59Owi5
 d1DRuOMBSXZaioNmgGBBetWpZ1z4BcQy/PDwrjZ9KqdXUllBgOuQPj2j53Up8m057PV7xL0Z1vD
 qZkyilirOxdnRF12O+wdMtxLIiIDLYA=
X-Proofpoint-GUID: V_8h92FWuiE2fwYQs9oMiTylfnaI_xJw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607220234

Allocate, register, deregister, and release NVMe subordinate CRQs
alongside the existing SCSI sub-CRQs.

Update the CRQ reset and re-enable paths to tear down and recreate NVMe
sub-queues, extend sub-CRQ initialization to allocate NVMe channels when
enabled, and release NVMe channel resources during adapter teardown.

This keeps the NVMe queue lifecycle aligned with the existing SCSI queue
lifecycle so both protocols are reset consistently across probe, remove,
and connection recovery.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 5b6570232df3..d8c2b56258ee 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -945,6 +945,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	unsigned long flags;
 
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
 	/* Re-enable the CRQ */
 	do {
@@ -964,6 +965,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
+	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
 	return rc;
 }
@@ -983,6 +985,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	struct ibmvfc_queue *crq = &vhost->crq;
 
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
 	/* Close the CRQ */
 	do {
@@ -1016,6 +1019,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vhost)
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
+	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
 
 	return rc;
 }
@@ -6119,6 +6123,13 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 
 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
 
+	if (vhost->nvme_enabled) {
+		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs))
+			vhost->nvme_enabled = 0;
+		else
+			ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	}
+
 	LEAVE;
 }
 
@@ -6147,8 +6158,10 @@ static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
 		return;
 
 	ibmvfc_dereg_sub_crqs(vhost, &vhost->scsi_scrqs);
-
 	ibmvfc_release_channels(vhost, &vhost->scsi_scrqs);
+
+	ibmvfc_dereg_sub_crqs(vhost, &vhost->nvme_scrqs);
+	ibmvfc_release_channels(vhost, &vhost->nvme_scrqs);
 	LEAVE;
 }
 
-- 
2.55.0

