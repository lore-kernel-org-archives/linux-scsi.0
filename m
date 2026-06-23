Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B668038654F;
	Tue, 23 Jun 2026 01:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178256; cv=none; b=NRCPFOJvYW3SIK3cE04+sbRST21aRYGaglfo4VMRQxWXnIT61V9Y2peW8qwWiYDFQ9HcP5AfTGU314raGFv1cuK5jxaYeVdCXPzitP9krcDFdNMwTIguetqyqvc+CJIomThAseVgm0KRj0X2o7evQnuPesgJxP03133fQptLlro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178256; c=relaxed/simple;
	bh=2SGKgSheeK9aRHaBOvQTGaTFjHGClYMceZbZT/DPh64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2lcTD15BasrNTST46rNShukto1z5grjie+dvFtx0jFmEl3KLzOCjK2Mc5z/p1L/vgUa54KuPtSJ1iXT4ORn4oLMFEk4zlZasXC+kes6FiTDfHyE3/PDqXvUXF0JjNoSxS2rqD8EMhIhCLCdapanaSSYzJLjUvDhLbaCxif4K1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=neHP3imE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="neHP3imE"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mWiM352267;
	Tue, 23 Jun 2026 01:30:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dWdOR6SjPiKPB+qlr
	wnAppjU67YuTiYgrIDiwzd6Ne8=; b=neHP3imEDe4YWM02IkrexbxWPOJCjeF8n
	d5z53jX4LUP832IZCCNg6hpWGjVlx+Pd3muwJHOitiJ5y80WXkxhKt4DUN/Ze1xp
	tNWbScHPtMCtbbLmzHd5QK6dKEwMZMbSmGH1kZvgKRfIGKNVIfg1yV1b9unM7YMY
	Yop99H64SmaRCcy0kHYCSMObQn1/iBoLJ9Pb99RHRMwj7wpguqn+VrmSvRr7+poO
	3fFXytBQMpKuzpo0LSKPw7YPpqpkx7VxUhrOU2fQ8FEeMLcI3K139ixNr2AdGs3W
	POTllp5nvmMAmI4zu7eydh6eK5KFDNzTf2YOtMo2BkuenfddNxQHQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjk4c37s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JgeB018382;
	Tue, 23 Jun 2026 01:30:43 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7vygn31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:43 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UfNQ21758650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:42 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D702D58052;
	Tue, 23 Jun 2026 01:30:41 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28ED658065;
	Tue, 23 Jun 2026 01:30:41 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:41 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 05/29] ibmvfc: alloc/dealloc sub-queues for nvme channels
Date: Mon, 22 Jun 2026 18:30:11 -0700
Message-ID: <20260623013035.3436640-6-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX0uWul0rJFfhn
 KD23ja/DMc4PQFVW3ZLQ6puNOoVW+9pfiD0p6s3EAiXPvB6CkdQZv0vjZI59XdWEMfcSP+LN0Yh
 zSSd8iCllg1bj+azCC6uSwjrOi//jlg=
X-Proofpoint-ORIG-GUID: e2xB8DCaSys9fmVdozT0A2izOYWS6uAt
X-Authority-Analysis: v=2.4 cv=Oph/DS/t c=1 sm=1 tr=0 ts=6a39e1c4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=7MaZqFay8etFDbkFh6wA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX+9I2iCIth+/C
 507VxPc92Q6C2cfSZtiIPqUFxrINpXg4LfwgNS49YpUAzSUwNcwmr18JUo2HZzHvfK4E40zs2ef
 Dn/83lyDEOVPvLkk1j2RBRlhrV3kevQtFS5tj9MoRbZZyJN7IkCJgJYbstCUUuI5W1KB+hNZIxq
 uRO8ylY+hHYbWo/g35gCPP0Dtx0M2K6YFhei5yyJVAYzPhPkdcICYWfW5Wf4l3tQ3sH+foM1riU
 1/8CsloRtDK/aKkYwlOWiwFRQJ3/jph1TNV/jrPBUC6QfWCKtvDr3tbbIf7MuNyHHWxhRQMYhdX
 vtxQY9uwR9YxIXwvAFBF8vvDpzOxebZutQXo2lX+R7V1E8aiuWXX1ACzWoqeXo+i3TslX6qLIpy
 y8YIVq97mvCtxqX55BT8v5mzEn1Q7KUKgyq6RKasdpVKQLhGvYJy5wrsgnPEMrcBB1jjTahVspS
 hTtzrULwEehLHhq1lYA==
X-Proofpoint-GUID: e2xB8DCaSys9fmVdozT0A2izOYWS6uAt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

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
index 5732ccf2ac1c..6f5e8b3cbfc8 100644
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
@@ -6109,6 +6113,13 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
 
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
 
@@ -6137,8 +6148,10 @@ static void ibmvfc_release_sub_crqs(struct ibmvfc_host *vhost)
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
2.54.0

