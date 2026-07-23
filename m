Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E984333D6CA;
	Thu, 23 Jul 2026 00:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764941; cv=none; b=oPaA6c9f1Y8DaCB759aWCyWPPz+5jU8IJNsPWONTPQ2cm/EfXSv+NCOPyZuHb3G5JoohKj++B/Rc5UWwqMJq+3EYxQ+ZJ1ISdBYnbPFSfk1geHlBJRFA4G4i7KbKuStdf38imZNMGBAs7UhLxl1a0a1misIYzMymM5nHaroHwng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764941; c=relaxed/simple;
	bh=znw8sDpBwUz3+TV2aAwWSg5Zd+56kJ0sYGMgiWqNipU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BS26u12SMbB8RtZ7d1Z9g3pyi7HS8NrdVMMmMkj76N1sFUB0u4IJFKD9P67Zh+mOHIvx5FI7bqjFoQoe+ZB+NjAcxXa9NVqGNJPHnAmnr0iVvplV0zMjbhKdEjEkX2nPc9mCwjjKgimNsu+eVV7j5lTy5BpMSmgq7DWq98lySV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ly3YWDUQ; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ly3YWDUQ"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MICSqM714590;
	Thu, 23 Jul 2026 00:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=LU8iUAZRNHYghpMlB
	jgOCU4nmEYRCejYOKDMT+BakN4=; b=Ly3YWDUQsRnGee8KeCVsXCT2xZ/kH7rOw
	Dyarl04VAivZT0GpMdUczteTSQdZRWJzQ9/pGFjoHOcNGS7ojTnxELjd3vY06bYo
	naYoa7tlGIhI6REK+YJ595cn+LIBKxbSOG/ZjIRVmJivEGCAe+EOxsw1ljr9xDFK
	u5l7d/rJ/EXG/qqANaXVPRDsKMS1iBrJ02DabsVO46+KkhewXWycQ/IXw68JjXmL
	J2OacIYV/rHykoLJbI7VLxkEG+7nhPZgI063kwuzhSTjKCPwLKRuU8S/7X9Xew8X
	C1nBI89IE/8/m5QJ2JMm3Ab44lkqr7Y9P06p4Xeqs1uIHbUDK8cMg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7ahcct6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:05 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnuoF026514;
	Thu, 23 Jul 2026 00:02:04 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgktq9x2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:04 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N023ao19464800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:04 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E1F305805A;
	Thu, 23 Jul 2026 00:02:03 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D9C858063;
	Thu, 23 Jul 2026 00:02:03 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:03 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 14/33] ibmvfc: allocate and free NVMe channel group discover buffer
Date: Wed, 22 Jul 2026 17:01:30 -0700
Message-ID: <20260723000149.969416-15-tyreld@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: DD9qkgwYUMEwGKjFOPlWTa3EJmqOu9ZY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX4i0Q5kIrqTK8
 d1F+tbSr+CmxBd19r3UhTYrmYorbpZB0obqQQqJfG1NQ+8G2bPJI8oZp83Lc/VTcMJrITknCFoe
 fFhWiqTs48xXWBe4szapRxHxvjK0JhXMwnoOflEqt+YisXHebuKdjdE/9Tqax5zFWrmDMRcK2d+
 nTQKo3prf/8U8DLmCdbjcOs7XI02mMvWHmL8ikKZGjpwnmcQ+Vd6wvhEVceaaPexWJji+4pmWyi
 eDqz2XXUgmm8xKjydwOPiZNl9td+2uRpMil9Ut11pXbo+58QXwXZyXYSvR7sAjN5msNPypVSGL9
 A2X91Z6YZJw2D9HZU5yDYkw6kB6Q5EkmU4z9NLyg9vJHJ+PmozUz02jPEY40IDbgfjvEvJ9stqj
 2Ihen3+SM71rsmb0jc0YqMzXZae1uqjB0wIooWKOZSngTwM9gJfrWcClUzbQf5q84h1kY5vZsWt
 zXJzdIExS/63L/HBQfg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX+SSHhF8yEo5z
 Lbfj02bOzxK69JJM0QaJIHPiTJQMUGoRp8UwBSRabNadZu+iD8UOZN6tKfpynOJ73MZjll0bUnT
 4ulkLV9xIl6zMeB1pfDdVPtoOMPz9VE=
X-Proofpoint-GUID: DD9qkgwYUMEwGKjFOPlWTa3EJmqOu9ZY
X-Authority-Analysis: v=2.4 cv=SM5ykuvH c=1 sm=1 tr=0 ts=6a6159fd cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=FxNEJgEJPZLGpAZHG_oA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

Allocate a discovery buffer for the NVMe channel group and free it on
all teardown and error paths.

The existing discovery-buffer allocation only covered the SCSI channel
group. This patch is prepratory for sending NVMe/FC target discovery
MAD.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 088167ec04ff..a700e2554e69 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6375,6 +6375,7 @@ static void ibmvfc_free_mem(struct ibmvfc_host *vhost)
 	mempool_destroy(vhost->tgt_pool);
 	kfree(vhost->trace);
 	ibmvfc_free_disc_buf(vhost->dev, &vhost->scsi_scrqs);
+	ibmvfc_free_disc_buf(vhost->dev, &vhost->nvme_scrqs);
 	dma_free_coherent(vhost->dev, sizeof(*vhost->login_buf),
 			  vhost->login_buf, vhost->login_buf_dma);
 	dma_free_coherent(vhost->dev, sizeof(*vhost->channel_setup_buf),
@@ -6437,12 +6438,15 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 	if (ibmvfc_alloc_disc_buf(dev, &vhost->scsi_scrqs))
 		goto free_login_buffer;
 
+	if (ibmvfc_alloc_disc_buf(dev, &vhost->nvme_scrqs))
+		goto free_scsi_disc_buffer;
+
 	vhost->trace = kzalloc_objs(struct ibmvfc_trace_entry,
 				    IBMVFC_NUM_TRACE_ENTRIES);
 	atomic_set(&vhost->trace_index, -1);
 
 	if (!vhost->trace)
-		goto free_scsi_disc_buffer;
+		goto free_nvme_disc_buffer;
 
 	vhost->tgt_pool = mempool_create_kmalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
 						      sizeof(struct ibmvfc_target));
@@ -6468,6 +6472,8 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 	mempool_destroy(vhost->tgt_pool);
 free_trace:
 	kfree(vhost->trace);
+free_nvme_disc_buffer:
+	ibmvfc_free_disc_buf(dev, &vhost->nvme_scrqs);
 free_scsi_disc_buffer:
 	ibmvfc_free_disc_buf(dev, &vhost->scsi_scrqs);
 free_login_buffer:
-- 
2.55.0

