Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6716B4DA9D0;
	Wed, 16 Sep 2026 23:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600187; cv=none; b=o/9omlqkGr3KV2u5hY9zgJvfm+7Zgju5StQIUOoOmE5dlTPkFpulAtRXcxH5wHZVClJZRmxPjVFcIfempIqjKQ4geOMQB+u6+s+KEa/sioEQPpBJtq7JsFHzoyTAouZ9uSDPiDJts592mXxIDRJPipQfoFxJBOZ23pe35HKCx3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600187; c=relaxed/simple;
	bh=ob1Y6ojFXOojBTo/vmk1j3n/LLOzsFovl+d56cRYR1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XgGQjxV73A4v9bWGk/9nnQ3I7KZVlkMAK4AwOl9ERiqT19CtmPvKkpVAsRpesY6F7OrHar9Va7PoloLcMXlzIjBoVeDVrtrHuI4QSR6yVyz6aiTsaL5O6FDGAO66msc/wQqnsWSUKnotwrzVcTePVil4TP6syUTnbdQcI0YPBbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bvRjE5Wp; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bvRjE5Wp"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1Yx4045799;
	Wed, 16 Sep 2026 23:09:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=gvNzn7
	ZMOYC+j9HE3k8E1WAb/wtbEy0YMdDUk1XNQhA=; b=bvRjE5Wpzxobgr/H2L8ery
	fwcu21es71ZKEDc9+ytS10FY5/Ko3ndPejrlhED6jMhZwdEOe5H9JRPGRKPGP9BT
	N39oP6QfsB2tERVNDMuxI6iSlhEaQRwQR34jDqbbYNsSUE2O0jKT2dig2kakNbHy
	bOHet5zL/rc6emjpDhhjpmnlcsvehl7pjfbTDOuLwiqNVSDPxTq9iKTM9UZM6nOJ
	I+3nr4m+r2TWmQWVip2l6V9isfLgj2H1ec+QGEEic5eS6N6fRpGMwys/gbeGwyF4
	Pr/t0tDLzMB8Nla/CxhSpm5yqgAmsRPQOlFHW0MAWPaeBaGJJD3QScivhOI6q+4g
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxcv6y0w-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GN0AF71699615;
	Wed, 16 Sep 2026 23:09:33 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gq03vguf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:33 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN8n8S30540400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:08:49 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2B2958056;
	Wed, 16 Sep 2026 23:09:31 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C60A458054;
	Wed, 16 Sep 2026 23:09:30 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:30 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 04/20] scsi: ibmvfc: defer NVMe local port registration out of atomic context
Date: Wed, 16 Sep 2026 16:09:05 -0700
Message-ID: <20260916230921.2204729-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916230921.2204729-1-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX5b7HQJnafCoR
 1rppFVMwr06eHsIyNNt3nJ4njmELwGuhRL49AXpsshqH7oErZDtHbfyJv8qxgUaBlpGDf/QayiS
 gmGPGqmrI1Fuq8WQDT/XwmzAfxpWr+I=
X-Proofpoint-ORIG-GUID: VraI2bhDrSm8Xey1EeNuf9m3BRH5_Wkz
X-Proofpoint-GUID: VraI2bhDrSm8Xey1EeNuf9m3BRH5_Wkz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX2MpCJMHAoGq9
 uFc04QmbJ2ME39GWulUc6WWW86hTa7e6LpXyzZB6ktjlG7Ect94CjIRh+0yYd1bMA0H6vfj942S
 eq/HLghbOJvPkEdgcb6Zmx+z4u5J/OHMaWVEGTPRrg7k9lw2MfzAbTaNMF57+c5ylsV45jnlYT6
 0F28q0FUqAMtj5YgyyOjuj4zBlGijHC6PWc1nuO+cLEG4vNXGukOBhdjxL5tRQ7+LilpLedKO6j
 oJt89AaIYRPfOarTrbyt0OC294z9sbWJVn7kjTo2kiTuKVS3IU7OOgie94vG9ATwXJ+2IZi8m42
 wNrc01mNIB5Mf33RZIYtspmjXIEgaVFtRGxLNxa8/LeIxX75QSFRv6y5/qsrp7L/uU26j/yagh2
 LQBua9sT+tzQ3/hVe31afYp0RZw2RJ3yXXZqOwlkYXKCd4ytrpVGO9TGeHbQ/cl4wci+Ezn565c
 CnD2+2Xi6HKMNBXUGgQ==
X-Authority-Analysis: v=2.4 cv=F+7C5ahN c=1 sm=1 tr=0 ts=6aab21ae cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=_eyZQ5qQRCHSa_PPBJEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 phishscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609160322

ibmvfc_fabric_login_nvme_done() is invoked under vhost->host->host_lock
via the ibmvfc_locked_done() wrapper, which acquires the spinlock with
IRQs disabled before calling the MAD completion handler.

On the IBMVFC_MAD_SUCCESS path the handler called ibmvfc_nvme_register()
directly. That function calls nvme_fc_register_localport(), which
performs GFP_KERNEL memory allocations and may sleep — both illegal
inside a spinlock-held (atomic) context — resulting in a 'scheduling
while atomic' kernel panic during NVMe/FC fabric login.

Fix this by replacing the direct call with a new do_nvme_register flag
that mirrors the existing do_nvme_login pattern already used in the
driver. The flag is consumed in ibmvfc_do_work() under the
IBMVFC_HOST_ACTION_QUERY case, which runs in the kernel thread context
(ibmvfc_work) where sleeping allocations are safe. The lock is dropped
before calling ibmvfc_nvme_register() and re-acquired on return so the
rest of the QUERY case proceeds normally.

Fixes: 4eb644adc42f ("ibmvfc: register local nvme fc port after fabric login")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 8 +++++++-
 drivers/scsi/ibmvscsi/ibmvfc.h      | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 26a73db66254..420ddb958466 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -5245,7 +5245,7 @@ static void ibmvfc_fabric_login_nvme_done(struct ibmvfc_event *evt)
 	switch (mad_status) {
 	case IBMVFC_MAD_SUCCESS:
 		fc_host_port_id(vhost->host) = be64_to_cpu(rsp->nport_id);
-		ibmvfc_nvme_register(vhost);
+		vhost->do_nvme_register = 1;
 		ibmvfc_dbg(vhost, "NVMe fabric login succeeded\n");
 		break;
 	case IBMVFC_MAD_FAILED:
@@ -6072,6 +6072,12 @@ static void ibmvfc_do_work(struct ibmvfc_host *vhost)
 			vhost->job_step(vhost);
 		break;
 	case IBMVFC_HOST_ACTION_QUERY:
+		if (vhost->do_nvme_register) {
+			vhost->do_nvme_register = 0;
+			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+			ibmvfc_nvme_register(vhost);
+			spin_lock_irqsave(&vhost->host->host_lock, flags);
+		}
 		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue)
 			ibmvfc_init_tgt(tgt, ibmvfc_tgt_query_target);
 		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue)
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index ca80ceffe53a..df0775183d72 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -1005,6 +1005,7 @@ struct ibmvfc_host {
 	unsigned int nvme_enabled:1;
 	unsigned int do_scsi_login:1;
 	unsigned int do_nvme_login:1;
+	unsigned int do_nvme_register:1;
 	unsigned int aborting_passthru:1;
 	unsigned int scan_complete:1;
 	int scan_timeout;
-- 
2.55.0

