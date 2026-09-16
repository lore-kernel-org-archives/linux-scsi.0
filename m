Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84F94D2ED3;
	Wed, 16 Sep 2026 23:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600189; cv=none; b=RlEnAOLUU87qQI/Bj9HWuXI9WKHIQeUwUzpPEtdVByxMQ9O+fxAE+Tvb+WRC6wuBeFNNmSE+UgtLBYFxvTzo1gC115HpsnT26Sv9vNYDLzGNceWXcmJEubpiLvgm8y3Yy2C5V8aMkkfD/MULybPM3uuUz/4iQtms6pTkcrKBJJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600189; c=relaxed/simple;
	bh=QLHsUXqM9vwACQY9WbAi62rdPJpF6koQoxLjZ+p2NpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ccrz9jtxgvmG0wMicgna3e0pCkkuF9LYrFXTY6bOApgkCBJmWJtiL6hplgSC0KgX6k4EvRkwU6DUIT32EK35acWXTI8PPaWRWA05qchUCh3c9+JUPS/UlqCA/0CJ5P6ndLJH4UY7iu1j8Xoi8bmSVdcvjn8ofrmIoAkczMcC5wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SGC2Nhkj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SGC2Nhkj"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1cui3041282;
	Wed, 16 Sep 2026 23:09:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lz9ly8gVAyNDFvujV
	Nl5Lid0gT/rZwvTUjaa6S5a1Wg=; b=SGC2NhkjrFnzYLhrVSH4GsuLv3s/kLgZk
	ulzuFdDx+TVSWzq7jIStQsVTf3gCa6IOji8Euoq5sZot43h/6RXjUK6v+mzRCGU7
	8Bv6wOnt6fMmjv6sIVSi8ROAwXrb8B0bxKq+5rXJGve644KoZ4y4jleQj4mQeEbS
	2NfkMxSjAnWZpJZOawt966mVI0+t2IeW6abtoQD1tdfS+J4d1EYoyJvij0xQPlYa
	174g7vdg7vOSgpBTymRdvauXOFF7mWTJNQb2m1tYu7tLJObke28Elb8a6eaEfQfm
	CUFz1TQYIPU7Zcgx1CYHBQXQpFv3JOuzIU9l0Lwhc12EfUDEviOPg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmw5e73jn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:42 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GMub101625387;
	Wed, 16 Sep 2026 23:09:42 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gpyxsgw72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:42 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9eSm29229776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:41 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFA4458056;
	Wed, 16 Sep 2026 23:09:40 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB6E058064;
	Wed, 16 Sep 2026 23:09:39 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:39 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 12/20] scsi: ibmvfc: fix data race on tgt->nvme_remote_port
Date: Wed, 16 Sep 2026 16:09:13 -0700
Message-ID: <20260916230921.2204729-13-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX7g2zcNPj3kIz
 apkQxaYyKRT9TjG8nu6+rQymn99V6r84d9+A31hxinyE70XP4mI1EG6SsgxwaPX1Xuzdaiu+Vba
 iR2jCDMjkw8RnCmNLJTEcb/uHucL8e7CoSJU2nh9xLnTvIwYWNzH/QnnKa3aRCV5+v3Cfh6Ywn4
 6VVuW+Z6gd3+R/CociMcUhfGIDCrhbDpa5HdMSHFpRKKTR3bfdm6dULJbQueGC7aXjYpU2vDeKj
 oAb8wVcaLSZC5cTVpsOVdnbraWFFcF9n5ch8akhD6QgJ7BYCyaeOrIkm/te8VydJoMnZ942PyCo
 V5gACu8dsCa0KXfrrJJ2Uf6BnPxAI0s6ZhvSqewcX2j+7oZ4eNef55U1ywMY9qRcuwDivraHFQv
 VGMx1Wt1gttwC6KtXl8YahxLb9a3z+jewBHhIx6STEf9BldXkwOsysmkyHu7nZgJwnChzohwRLn
 SrLKPkpzl2CZpxWOe/Q==
X-Authority-Analysis: v=2.4 cv=E/NYNqdl c=1 sm=1 tr=0 ts=6aab21b6 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=J1oym3C9a2iPP8IqlnUA:9
X-Proofpoint-ORIG-GUID: LhIRzOGqQl8No8OluDWtJb67UTx3gVSw
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfXxNjpU8pdZIcl
 4CU9DhpylhGdHDms/RydYkN9FhTTOPw8MzUkvnYOProt/dPu5Z3lDNJzDgfE3pBiVLZ//kRX8f9
 1QItLP6X7MiM81BGKjwPjAgRSp2+0Sg=
X-Proofpoint-GUID: LhIRzOGqQl8No8OluDWtJb67UTx3gVSw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0
 adultscore=0 clxscore=1015 bulkscore=0 malwarescore=0 suspectscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160322

tgt->nvme_remote_port is written in two places without holding host_lock:

1. ibmvfc_nvme_register_remoteport() calls nvme_fc_register_remoteport()
   and stores the result directly into tgt->nvme_remote_port with no lock
   held, racing against locked readers in ibmvfc_tgt_add_nvme_rport() and
   ibmvfc_do_work().

2. The ibmvfc_nvme_remoteport_delete() callback writes
   tgt->nvme_remote_port = NULL from the NVMe core's thread context with
   no lock held, again racing against every locked reader of the field.

All readers of tgt->nvme_remote_port acquire host_lock before reading the
field, so both writers must do the same.

For ibmvfc_nvme_register_remoteport(): nvme_fc_register_remoteport() may
sleep so it must be called before acquiring the spinlock. Use a local
pointer to capture the result, then take host_lock and store the pointer
into tgt->nvme_remote_port and set ->private under the lock.

For ibmvfc_nvme_remoteport_delete(): acquire host_lock around the
tgt->nvme_remote_port = NULL store. The callback is always invoked after
ibmvfc_nvme_unregister_remoteport() drops host_lock before waiting for
completion, so taking the lock here is safe.

Fixes: 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in work thread")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
index 7fdf27fbe7e7..d9f280c658eb 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -26,8 +26,11 @@ static void ibmvfc_nvme_localport_delete(struct nvme_fc_local_port *lport)
 static void ibmvfc_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
 {
 	struct ibmvfc_target *tgt = rport->private;
+	unsigned long flags;
 
+	spin_lock_irqsave(&tgt->vhost->host->host_lock, flags);
 	tgt->nvme_remote_port = NULL;
+	spin_unlock_irqrestore(&tgt->vhost->host->host_lock, flags);
 	complete(&tgt->nvme_delete_done);
 }
 
@@ -469,7 +472,9 @@ static struct nvme_fc_port_template ibmvfc_nvme_fc_transport = {
 int ibmvfc_nvme_register_remoteport(struct ibmvfc_target *tgt)
 {
 	struct ibmvfc_host *vhost = tgt->vhost;
+	struct nvme_fc_remote_port *rport;
 	struct nvme_fc_port_info pinfo;
+	unsigned long flags;
 	int rc;
 
 	if (!IS_ENABLED(CONFIG_NVME_FC))
@@ -486,14 +491,16 @@ int ibmvfc_nvme_register_remoteport(struct ibmvfc_target *tgt)
 	pinfo.port_id = tgt->ids.port_id;
 	pinfo.port_role = FC_PORT_ROLE_NVME_TARGET;
 
-	rc = nvme_fc_register_remoteport(vhost->nvme_local_port, &pinfo,
-					 &tgt->nvme_remote_port);
+	rc = nvme_fc_register_remoteport(vhost->nvme_local_port, &pinfo, &rport);
 
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	if (!rc) {
 		ibmvfc_log(vhost, 2, "register_remoteport: traddr=nn-0x%llx:pn-0x%llx PortID:%x\n",
 			   pinfo.node_name, pinfo.port_name, pinfo.port_id);
-		tgt->nvme_remote_port->private = tgt;
+		rport->private = tgt;
+		tgt->nvme_remote_port = rport;
 	}
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
 
 	return rc;
 }
-- 
2.55.0

