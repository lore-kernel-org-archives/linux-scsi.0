Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4A62E0925;
	Thu,  9 Apr 2026 15:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775747546; cv=none; b=CAzkDq0lIEMhJG1LgU0hmrLAc86nwtXEZZNoTmYF05S5pAlsELYwIC7S+eoZDKZ4A7T5JavN1G73O4vvpCi5rNv6zTihHQ05KYN5Zw7oEYPHRpDH5fFbHGxeUpBN1RdiKRUht9PEeP88EtWSSqelLDhZprdDWZdvRe9V60fWmQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775747546; c=relaxed/simple;
	bh=CnV8MyJLR48Ex2lAFPfPQbqzqKgYYJ6egGR505ddHq4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=ekMsxx8AiVNLAWvT6X5WPhLrqO1zSs5PHTgtHWzYUNGjoNZQsOPJXlio3LUUg4e/wpasD7dJxAzmVL+OJPFiSRlf5ncehVkO8uBlQl/gblCvQJ1PIcPj656F+M6wmJYct36SdfMzdw7FVitr2bHyNwbCLKJNN31kV6A4q2ynnyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AzC/0qRE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AzC/0qRE"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639AKXiu2210127;
	Thu, 9 Apr 2026 15:12:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=W2xq41ZBnYUshroKfZ3BHqm5TUWM
	a3g7CHyCApanZKs=; b=AzC/0qREDwbURyMLpIoX5wpP39oqPxBlvGtoRttC4T61
	uZr4Trys6jWDjTmvNE4cKK3W86noNT41SjP5PjlciewAcEWNyjtEHpOmTdLpkWyN
	It/JRlnaGZHPUcZOWV6cOTmXreUkNgu/vNb+Yhw4POWjVIjqBUaIVVZVkAnwb+Ka
	6M7JyWaOAjTKHjKiyre2Qo08XfdFBXifjH+Lsx9iGvR8fQoQwZbjeFr2F+nzdZCA
	BSWDsCZtAKbkJSHg3vxpMGmAa+HSQ0RLK8a27brLTUkN7JkYur4Sb3c64Hsu6j02
	hyPFP9y5ME6QzA6VAO3c6zZIXxHiT9nEAnVilt97cg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2hmqgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 15:12:23 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 639CTbNs007892;
	Thu, 9 Apr 2026 15:12:23 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmg2m3sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Apr 2026 15:12:23 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 639FCMcb16188146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Apr 2026 15:12:22 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB8D358059;
	Thu,  9 Apr 2026 15:12:22 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3818058053;
	Thu,  9 Apr 2026 15:12:22 +0000 (GMT)
Received: from [9.61.156.97] (unknown [9.61.156.97])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Apr 2026 15:12:22 +0000 (GMT)
Message-ID: <f4f4e9a7-e3bd-4cc5-a3df-829b981ae836@linux.ibm.com>
Date: Thu, 9 Apr 2026 10:12:21 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Subject: [PATCH 2/3] scsi: fc_transport: Fix TOCTOU races and workqueue
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul.ely@broadcom.com
Cc: thinhtr@linux.ibm.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDEzNSBTYWx0ZWRfX9IM4Hcd1+TqU
 dsqMToPYiEW32KFKkEmCDdhPt62uaW+eAlYAyPFk1GwWHeqO9R4tLhREcrC/GC4Lxve6LHx8Lan
 BH9QIOqUBA08x2Xnjgvfh1IkDsaNgtCuUxIA0K5PvINYI3p0O2Gn9cXKAcYKZYjDZ2mQISLKs0c
 EgR/Kv/4JjIjOplOxLf/+cqJkvkvAxGAkC+V+m2EwV7Sw/DWdPNjd2ZInOvYS60eh9kHcTUohOn
 gaMbg3np4ZPSlT0HEeCnWZzxrsqJo+Jd/PJ4b92CeUVAxNhaACUg9jyWuQE08Ujhp2AJQqWrZ2f
 bLl59PAEUuisz6GFzred5+Bvo9l2a3YFOK6k/RNKihNd/sU0b0ZTtmktQhNrwZnvoEJOe3iP/DI
 leeWhI5uQNFRjbzTT3nJb0AtD0InpAcGT+mm3JMdlQVVcycXTNhhCF9nfk/qdkadUuNUhKGtUh6
 PrjpdSrg9G0xiuhUCzQ==
X-Proofpoint-GUID: ZqgBtRjBlSFbO0vUPkvtEotygqFh8NH2
X-Authority-Analysis: v=2.4 cv=a/wAM0SF c=1 sm=1 tr=0 ts=69d7c1d7 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=3GqcNcJgD4XTNdKLspMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ZqgBtRjBlSFbO0vUPkvtEotygqFh8NH2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1011 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604090135

Fix the TOCTOU races in workqueue access, use READ_ONCE() in
fc_queue_work(), fc_flush_work(), fc_queue_devloss_work(), and
fc_flush_devloss().

The workqueue destruction in fc_remove_host() uses WRITE_ONCE() to set
the pointer to NULL to prevents new work, flushing the work queued
before NULL, then safely destroying it.

Signed-off-by: Thinh Tran <thinhtr@linux.ibm.com>
Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
---
  drivers/scsi/scsi_transport_fc.c | 36 ++++++++++++++++++++++----------
  1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c 
b/drivers/scsi/scsi_transport_fc.c
index 3a821afee9bc..123b22b52640 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2774,16 +2774,18 @@ EXPORT_SYMBOL(fc_release_transport);
  static int
  fc_queue_work(struct Scsi_Host *shost, struct work_struct *work)
  {
-	if (unlikely(!fc_host_work_q(shost))) {
+	struct workqueue_struct *wq = READ_ONCE(fc_host_work_q(shost));
+
+	if (unlikely(!wq)) {
  		printk(KERN_ERR
  			"ERROR: FC host '%s' attempted to queue work, "
  			"when no workqueue created.\n", shost->hostt->name);
  		dump_stack();
-
  		return -EINVAL;
  	}

-	return queue_work(fc_host_work_q(shost), work);
+	/* Use local copy to prevent TOCTOU race */
+	return queue_work(wq, work);
  }

  /**
@@ -2793,7 +2795,9 @@ fc_queue_work(struct Scsi_Host *shost, struct 
work_struct *work)
  static void
  fc_flush_work(struct Scsi_Host *shost)
  {
-	if (!fc_host_work_q(shost)) {
+	struct workqueue_struct *wq = READ_ONCE(fc_host_work_q(shost));
+
+	if (!wq) {
  		printk(KERN_ERR
  			"ERROR: FC host '%s' attempted to flush work, "
  			"when no workqueue created.\n", shost->hostt->name);
@@ -2801,7 +2805,8 @@ fc_flush_work(struct Scsi_Host *shost)
  		return;
  	}

-	flush_workqueue(fc_host_work_q(shost));
+	/* Use local copy to prevent TOCTOU race */
+	flush_workqueue(wq);
  }

  /**
@@ -2818,16 +2823,18 @@ static int
  fc_queue_devloss_work(struct Scsi_Host *shost, struct fc_rport *rport,
  		      struct delayed_work *work, unsigned long delay)
  {
-	if (unlikely(!rport->devloss_work_q)) {
+	struct workqueue_struct *wq = READ_ONCE(rport->devloss_work_q);
+
+	if (unlikely(!wq)) {
  		printk(KERN_ERR
  			"ERROR: FC host '%s' attempted to queue work, "
  			"when no workqueue created.\n", shost->hostt->name);
  		dump_stack();
-
  		return -EINVAL;
  	}

-	return queue_delayed_work(rport->devloss_work_q, work, delay);
+	/* Use local copy to prevent TOCTOU race */
+	return queue_delayed_work(wq, work, delay);
  }

  /**
@@ -2838,7 +2845,9 @@ fc_queue_devloss_work(struct Scsi_Host *shost, 
struct fc_rport *rport,
  static void
  fc_flush_devloss(struct Scsi_Host *shost, struct fc_rport *rport)
  {
-	if (unlikely(!rport->devloss_work_q)) {
+	struct workqueue_struct *wq = READ_ONCE(rport->devloss_work_q);
+
+	if (unlikely(!wq)) {
  		printk(KERN_ERR
  			"ERROR: FC host '%s' attempted to flush work, "
  			"when no workqueue created.\n", shost->hostt->name);
@@ -2846,7 +2855,7 @@ fc_flush_devloss(struct Scsi_Host *shost, struct 
fc_rport *rport)
  		return;
  	}

-	flush_workqueue(rport->devloss_work_q);
+	flush_workqueue(wq);
  }


@@ -2905,7 +2914,12 @@ fc_remove_host(struct Scsi_Host *shost)
  	/* flush all stgt delete, and rport delete work items, then kill it  */
  	if (fc_host->work_q) {
  		work_q = fc_host->work_q;
-		fc_host->work_q = NULL;
+		/* Prevent new work from being queued by setting work_q to NULL */
+		WRITE_ONCE(fc_host->work_q, NULL);
+		/* Ensures NULL is visible to other CPUs before flush */
+		smp_mb();
+		/* Flush any work that was queued before NULL assignment */
+		flush_workqueue(work_q);
  		destroy_workqueue(work_q);
  	}
  }
-- 
2.52.0
