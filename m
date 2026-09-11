Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4373DB651;
	Fri, 11 Sep 2026 02:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093165; cv=none; b=SOhMH1Afi6uLEAIxze8HzYBHfcWyw0Z9Q0P5S0GtWecRS6UumLF9rO9deIqOX2nfhI+2p5XQFhM0wN6pox6rhKG1mbYsMhNkOSx9nT6xfsG9+3XbI5br7rcCo/JDSKPxqkmEDPnxj1AMrVlojOqQD+VCo53nXV505V1WFykrsQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093165; c=relaxed/simple;
	bh=Yy0OU3dKq8cR/JdYCoiXYE3T/GnzwysU3idedb1DPV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRdRcC0hTmkocuqicsVnHuRJMIcSC3Wgw6dZTbR38pMMnC76fYWMNsLDajJwHUor1BJkG0knXvaQ6is6vddO5H5W6Hj1mww9PL4TvdQrgwSVwEGfVyzFQ2YStoqJW/Wwyq2LJLHv8cQz7f34IwW24EbZ9qKGigANP2eEzonVSww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T4zsGC7B; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T4zsGC7B"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12J2r311149;
	Fri, 11 Sep 2026 02:19:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=bVsy6e7RIWsa4inSY
	VWZiBsIlesxYTQaoaS4XZ8tKXk=; b=T4zsGC7BM8fBhzVfvenCKJQ3lKExHkc/m
	tFhy2b8kJlQHOg26yotKL2KgGQa2ZAyjj9m6RFgIMs2BGbq88Chsa7goH5TNTiLu
	UX7zUw1XRalHeJN0pDnhdsxPBd5xWgHBfeHSZPWJzMwenM5+Kw9io1jDQjtNbfdo
	pWNEpUH3aNx/Mdw9Vl5SaQPj0vnHJviKfNsCT25qPe4f9GqC9aTWjw4WUHJGGuEs
	BMKTjKcZEYnygMzomgB7onFUDKYhoY7cWi4K6AORQCHAualBAxcGGAN+rzkcHoxN
	ewhMfzDCceQLzocJLd1oxsbcGKJdmdPhU9ThC+GTQURwAQTEUor6Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8prtbm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:19:18 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B15AC7872168;
	Fri, 11 Sep 2026 02:19:17 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvwk3u32-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:19:17 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B2JGVC26411620
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:19:16 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDFBA58063;
	Fri, 11 Sep 2026 02:19:15 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA86458059;
	Fri, 11 Sep 2026 02:19:14 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:19:14 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v9 3/9] scsi: ibmvfc: add FPIN extended flag and async sub-CRQ queue handle
Date: Thu, 10 Sep 2026 19:19:03 -0700
Message-ID: <20260911021910.1038128-4-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911021910.1038128-1-tyreld@linux.ibm.com>
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=eM2GH3p1 c=1 sm=1 tr=0 ts=6aa36526 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=dC3NDtCKD2fC6gceAXcA:9
X-Proofpoint-ORIG-GUID: CdLyKflFMqogQUlNhQxfQfVAn0POrVpC
X-Proofpoint-GUID: CdLyKflFMqogQUlNhQxfQfVAn0POrVpC
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX1Pgz1/tfv3Zo
 jwD+JQwyJyR1A+NFWn+LDRQfk0Co2ozeeg0cIecIVCCXeWrzvZFlHfhIuAqmsWWupgpjRtLDb2e
 YYgQf2SuiMBgA/akMwro4Nmv1aGLfgs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX+bHwBgJqnsd+
 UWycja9q87HJSiXt4uY0p6oT3fsjqW2SmSuXh1nwx4AY8hbPzy1VI6YSad2raWF/De+qgElVNag
 M34FOIuXA2O0FoC+YURpLC7+XAqQwqQEB1+vj5UHnIpnt18+ZN15jdgJDKNsLNmT/6qAL9OWyuM
 bhOIyV8CVkfjqLdq193jTE32b0JigYVWZT9NRVW8ETu0QOP4PSvYQhFlkQrSYLJJqSvTL9F1MTZ
 sXhFAmw3mRdZDRZjPA875jedB73nlvV1fosOH101WlhbEb19hVXOCimSsMp20HkXULxJDwJeBHV
 AmW+GQjEXo11Nsf92/b/AQyfxFNx+JZf3bCHaSwU+qtUw//TSmymiK2+Jim0DiAUtdjNBGsGAUg
 CYf42Xx95M2JwW9IIIqnY3MbYtusqtKi/aW8VJLGfNZx7EgSfEEx5iBeMdnCCtwZBKNZEI9KxzP
 SyDWucQ5IYjJmeIqJPQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110024

From: Dave Marquardt <davemarq@linux.ibm.com>

Add IBMVFC_ASYNC_IS_FPIN_EXT flag bit (0x02) to ibmvfc_async_sub_crq.flags
to distinguish extended FPIN events from standard ones.

Add async_sub_crq field of type ibmvfc_queue to ibmvfc_host to hold the
queue handle for the asynchronous sub-CRQ, alongside the existing crq and
async_crq queues.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index d7a30e7a4a28..a8a063d99564 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -773,6 +773,7 @@ struct ibmvfc_async_sub_crq {
 	volatile u8 valid;
 	u8 flags;
 #define IBMVFC_ASYNC_ID_IS_ASSOC_ID	0x01
+#define IBMVFC_ASYNC_IS_FPIN_EXT	0x02
 	u8 link_state;
 	u8 fpin_status;
 	__be16 event;
@@ -990,6 +991,7 @@ struct ibmvfc_host {
 	mempool_t *tgt_pool;
 	struct ibmvfc_queue crq;
 	struct ibmvfc_queue async_crq;
+	struct ibmvfc_queue async_sub_crq;
 	struct ibmvfc_channels scsi_scrqs;
 	struct ibmvfc_channels nvme_scrqs;
 	struct ibmvfc_npiv_login login_info;
-- 
2.55.0

