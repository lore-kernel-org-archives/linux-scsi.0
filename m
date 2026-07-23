Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FF831F9B9;
	Thu, 23 Jul 2026 00:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764941; cv=none; b=j+VF7MGfpiz9uVJ2hoE39u6mmkwqGn9RXnYpR5/SV5iBUbKf95V7y60/OxJtX2FzKl+kT+xIZa+KZvkUH5JnyqBZlonTkwVsVJQGlzV6dtZlfbLmUBR6PTRK6XHygzDHYn3TxV1POv+1tPAJfzJzhZN0vMdWyEKzdBUUj19/SAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764941; c=relaxed/simple;
	bh=+T47terft/rgw3rZhcOJmOXfN8fD3xpvi8ZEGqdlYSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0GufIcgOlw5zqjgDTf/CMnLD8PHQn9u3NZjXrF1+817LvYUcXXZWO2yCoOEOykKoE94hCRYyQEAB9pE+DB9bJUV5miOt1+GdfnKnXGkJooUnsDL2ZlGGRrh9GyOrGnbkBJ2sJyI6EPVRw5LxPB2r/y2Q+jb44vP1VAlO8OrsdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=n656rn7/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="n656rn7/"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBt4K633457;
	Thu, 23 Jul 2026 00:02:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=eblGcB34wmCvotF7J
	o6JQc5j0CGO07E5cvvhhak1EyQ=; b=n656rn7/Fk/XMxSSK0sbvyLhBq564iwRm
	Bbf0TBm9l3NGEyqtFOPbqsFnYfAoNKyLKFqovdcgsOE6EK2wCdp7HHfu6WJa4F3j
	ZNsZiwrDWPjjy2NcbQAxRrL6yghTCozRCifGGnWPOziOrRjJFzSkHKp+o42xTm2j
	txLt5rDIf3pvjf2Grg/JCfPVaNeGcoCcrmkLiHlxZVwvX578mkWUIea7wNb1hgu/
	wNH/RI/BzuRGPha3t7Z99/9CQkuV/YlFlSilIhVmvv2vI7dgzCUUC1fq7HNHEKXc
	PSciJVNYc85PthoRAoWCSIJxNXVAMXbLCUDZBsy3qbdS9n7SGn9Iw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg77kce7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnaIN028159;
	Thu, 23 Jul 2026 00:02:14 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgnah9q3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:14 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N02DOL29491862
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:13 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 064DD58068;
	Thu, 23 Jul 2026 00:02:13 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 668AB58063;
	Thu, 23 Jul 2026 00:02:12 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:12 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 26/33] ibmvfc: extend ibmvfc_debug visibility to ibmvfc-nvme.h
Date: Wed, 22 Jul 2026 17:01:42 -0700
Message-ID: <20260723000149.969416-27-tyreld@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=HJXz0Itv c=1 sm=1 tr=0 ts=6a615a07 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=Jem0i5WXB_Or_wZ5oY8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX1WKhg2on7PuR
 6WjTCHqG4MeKRzzj2jnHtCRGQGKv+Mh+5wP4DfvzW86VfFlBv8zh1rAHONnUnT6NmAQS3wG3cbH
 BWN5CpGf19kX8LqRrbCDPpZZACbCWHe99m3U+kaclPkZ5c1RCGRCvENyBzoxsHQv5/ir9jIjelm
 wBcs1iQ+vgnSM6QRg3lSPxI6mQfpkOjmG5QkMaO+N7R22KYM2cC2HGfj4lRZFOxfR3zVOCgm3hU
 cMRY3lkyDitWmC2WmGhwo8gyuR7mtG2946Me5l4NN36G/c+WiXyx5zabZZ9qKPyBrVFaZJ8q3M3
 J8kbslAk3IRQaooFqufTylFhmYB1uNop+6rkwYnAlFmWz8Bv9OszmSkYSGBhEGS7WuxjgHXtogK
 NBeEwqXPI+BcXPZeRAyCZ8MnsKzLsGqvjIQXVZZ6PSurtFMH0MSTB5GROPqLgZga1DmvTygLUZK
 tqwTLIKJswdZvEu+qTA==
X-Proofpoint-ORIG-GUID: _EkLsC7_0EeeU2lf45v8g3l5RXgrQNlL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX5CbvxQ6XYVxO
 GTxE3/CZfygiJcZLq6ut6svZMroTUGeb800Sc/vO4n+nD2U8fEvYeAC6iQaqUesJlSeV990jyeM
 4cm05aBrOxcyJnW5nVKKHjKMAd7i4GA=
X-Proofpoint-GUID: _EkLsC7_0EeeU2lf45v8g3l5RXgrQNlL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607220234

Export ibmvfc_debug so the NVMe support code can use the
existing ibmvfc_dbg logging macro.

The debug control variable is currently file-local to the core driver,
which prevents protocol-specific code in ibmvfc-nvme.c from using the
shared debug infrastructure. Make the variable global within the module
and declare it in ibmvfc-nvme.h.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 3 ++-
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index ffb579816e84..6156f10871ac 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -41,7 +41,6 @@ static unsigned int max_requests = IBMVFC_MAX_REQUESTS_DEFAULT;
 static u16 max_sectors = IBMVFC_MAX_SECTORS;
 static u16 scsi_qdepth = IBMVFC_SCSI_QDEPTH;
 static unsigned int disc_threads = IBMVFC_MAX_DISC_THREADS;
-static unsigned int ibmvfc_debug = IBMVFC_DEBUG;
 static unsigned int log_level = IBMVFC_DEFAULT_LOG_LEVEL;
 static unsigned int cls3_error = IBMVFC_CLS3_ERROR;
 static unsigned int mq_enabled = IBMVFC_MQ;
@@ -53,6 +52,8 @@ static unsigned int nr_nvme_channels = IBMVFC_NVME_CHANNELS;
 static unsigned int mig_channels_only = IBMVFC_MIG_NO_SUB_TO_CRQ;
 static unsigned int mig_no_less_channels = IBMVFC_MIG_NO_N_TO_M;
 
+unsigned int ibmvfc_debug = IBMVFC_DEBUG;
+
 static LIST_HEAD(ibmvfc_head);
 static DEFINE_SPINLOCK(ibmvfc_driver_lock);
 static struct scsi_transport_template *ibmvfc_transport_template;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
index 0465e8719881..3aa285788795 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
@@ -22,6 +22,8 @@
 #define IBMVFC_MAX_NVME_QUEUES	16
 #define IBMVFC_NVME_CHANNELS	8
 
+extern unsigned int ibmvfc_debug;
+
 struct ibmvfc_host;
 struct ibmvfc_target;
 
-- 
2.55.0

