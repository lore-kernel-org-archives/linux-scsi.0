Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E4A3CE0A4;
	Fri, 11 Sep 2026 02:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789092510; cv=none; b=gJelLMCcR4IPu+f8L7FEq083BO8lU/Sc5FPuD5ipr9aoDTOsgFsZHnNLkMXc6vC8STygSkOexGGF6DT6N77/VYJ3MPxYUaLVYkYsYINpuYEwgfurJAslpXY5GIr2NCC93rxDW+ESl1/C5jJkFebsR9F0f6YVc5NLq2B/upQjGdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789092510; c=relaxed/simple;
	bh=Yy0OU3dKq8cR/JdYCoiXYE3T/GnzwysU3idedb1DPV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2vUmVBarOIErH31arz9Az464vz52yVGU3kXPd9BINYioot3C1kHimUAo5PY8REbhk034pvxEP4PlPNlQ46v1GbtAe0512PLgKbN7CU+zwR8LsvN5BWLnQkX6tZujmzZdeY4j8R3SJk/o4+88tyHLBF9y96wx0JGb7orTjnmrGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fDbosF1t; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fDbosF1t"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12Q3U348209;
	Fri, 11 Sep 2026 02:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=bVsy6e7RIWsa4inSY
	VWZiBsIlesxYTQaoaS4XZ8tKXk=; b=fDbosF1tPg9d+nBN5tD16l6aFDBGod/iq
	NmuS1+g1DVQG2RgKk+TlQf7kKQT3XkOURvnEx/U1++DujX3X8U4TKHuwIgBFDLk/
	LZkO58mKLUPn+d7PFYj771G97Y1eBY5JndZxGqu0XhHwpdAYcEyZJV/E6DO3ieDM
	w7/FCl9t3QJgvctDb3S7Ff+puJn0tBqdIonYCpa4EZx9zk3XwQvvoO/lz9gs6NCK
	fuRfLWwmnf3cUI+ARbLwBcwA9LW33H4IneUCrNTijbBjKwg5qVrd1LWzL89S15yD
	BiXhtdj00axNeusNj0laGTTTqqqIp0nfgBXXBXRWBfGFuVLxK38iw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8t0p5k-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:22 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B154OC919386;
	Fri, 11 Sep 2026 02:08:21 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvmhkvf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:21 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B27cxk28050100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:07:38 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CDAA58052;
	Fri, 11 Sep 2026 02:08:20 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58A7958063;
	Fri, 11 Sep 2026 02:08:19 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:08:19 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v9 3/9] scsi: ibmvfc: add FPIN extended flag and async sub-CRQ queue handle
Date: Thu, 10 Sep 2026 19:08:09 -0700
Message-ID: <20260911020817.1033789-3-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX7M3gp2qud/N+
 gx9GaBDIF5ljDTbiEClk90n0k6lCvF5QxtO0YH7CKqCNpRGc0+mYQH8Ehja6AtgcPkfZ8OGYINR
 /tbzgAizXhoynbIS5gLVAaw/Izoa95M=
X-Proofpoint-ORIG-GUID: l6iYNfgYEL254GTn9esFTMyWulottP_W
X-Proofpoint-GUID: l6iYNfgYEL254GTn9esFTMyWulottP_W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfXyPmDRXSTjcha
 uiIh4kVsapqOA5BtuJeWBcd2aH/z1hT9hc8IKDmgt0bKYdAFlt9yNF+MFrxBlsegWqV3DR7uLe9
 /JvbQta4yxP/CCZrRxl0B+g/whjiXEyQPcDI86ylh0I6pYA5HNCPX1AtQEnHz0V/m2e4R2BlJcV
 Cwixszdx0WSWbbrP2z1MlZQyss6vP6BSf4Wyvf/Bq3IXfO7/gvsQqXqJwll+iGIqMJHDLeLPTLm
 RIlJXju16a6b6lXXIwXRusmUjjoRrBQLDmYF2S6inP/TjEKXY7FPJpNUT4qPAlNot6Yiqam+dZh
 K7I8YvN5MhjtuLKyizmeyjiyNYPXM1s7Ig4nTv7AdED0/USApXEalKCw/8rpqAVkH+isebYalCq
 wPxaEjl0aPmKI0EqcRJUEV+gMpezdyflTKZGFiEJ8szda8Kq/RU0FpH6hwnyTbKCtRY7sLn3EKS
 9UgZJB9IUnnd0TWbu/Q==
X-Authority-Analysis: v=2.4 cv=PIGaavqC c=1 sm=1 tr=0 ts=6aa36296 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=dC3NDtCKD2fC6gceAXcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
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

