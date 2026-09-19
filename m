Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1527E3E16A0;
	Sat, 19 Sep 2026 01:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781615; cv=none; b=S+yFG6pqC7umzBYKXmCTEsahByRdfpRzDF/82QzlqzqRFKxJphwHoNFifXKOLlkc0k/TEbv3XtjazLS+xO78A2pEmP0LLHRmkEk4tzWmJsHB3syC/e/SVsXsSM0jDmlCOSON5caQjIp5vJe7KMabStrKaEbzUNMVcgJ6HaShlDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781615; c=relaxed/simple;
	bh=9n3jw0bc9GOBbZxnNNcZzb6TQF3SJuAl2o09sJ0/0PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvXBW0kCvvpDskr+l/QlRAQHKA9Ogd3+4P7VmAEjFnOJnn/rxK80PPgrP901pUFzzy3zthGMZLteuR5aNYRgY8KsFynKJRP/h6W69Fl3+taFMBt3nG2+3KDsX+aScsLVuuYhq2Pg0KUkExCK06R3sL6TsVqS/YrPzYSyCp0a/G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CII3xBLl; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CII3xBLl"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J01Uiv2680644;
	Sat, 19 Sep 2026 01:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=phbR+VoCy+l67iNzM
	nzZ/XlM0J8ZoivbSnF1+CYAYxU=; b=CII3xBLlyQYnDKPjBTPG3bmy0duU/Qez9
	JoUBAPnW78QfbEquUxfD/eVKj/mi7DTJERdI3QzzXsh8/yuyqA+XZnYFm90qcNfl
	L4EQvtWdkOFU3GPh3wrFQN5G5mf2X5x3E7ayK1vUFaevr6OqaT0MwlxZjrYSuGCq
	Ie7zyZze5QYIaKNeHbOWLey51SriWkdEJmWR/2PWlmZlezI5CcM89A8QzkPTuODS
	1PBeSMF9ZIG3pSKHiIZCSq8XvfPAXJh9Zok7jxRTGHG69x3bAtdlm8dMd4jxE9iS
	xNjEReyjVr6jozNMduCVEeu0QLRpqLAnbwTVQMEVA0eifcKUolHGA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf5k1u1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1PhbC1662563;
	Sat, 19 Sep 2026 01:33:26 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gsgqn00g1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:26 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XPbK33686172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:25 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5450E58051;
	Sat, 19 Sep 2026 01:33:25 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AEE965805A;
	Sat, 19 Sep 2026 01:33:24 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:24 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 19/20] scsi: ibmvfc: fix nr_nvme_hw_queues module parameter ignored for NVMe queue sizing
Date: Fri, 18 Sep 2026 18:33:05 -0700
Message-ID: <20260919013306.2948028-20-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919013306.2948028-1-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DMtZrPxcUgzOq1SiOIwIWvjbMY9RYhoE
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX0Wsiw+z+D5Sr
 paOttF/1T2exjygXFibE683sytJ77wji1ihz1pzX4LAb4TutJOdL1J+WoXPZW/kXS32f7as8feg
 9cgVfV28P0HnaoDTqp2mOuNlKxsSmOo=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aade667 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=YHccNbNTKC1xL-9NveAA:9
X-Proofpoint-ORIG-GUID: DMtZrPxcUgzOq1SiOIwIWvjbMY9RYhoE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX2ZBhi0x1BnuG
 /37qsL9Oo8OpxNPpmnjeb2bvc2dhdDhDNHw2MWlgTIcYPeDIu6HzNvr/BggFm0X7OTMYGi9md43
 DW6p3vxZZGZMnIwVgTNFNMccGAH9fJrJaO4Ioo5cOH1g0nHHTd2ygGt0vGoI1oarVeMZPCNZmIp
 ZzmIluOfL2O+k+CX8kC45qsWxCRwBzobGrcjxHM6kn2J1OFxcNq74biiEJHYFTUtJVIC9UfW9Ug
 p3ePlVBw8a4crAOhunNIOcm9LdvjWuIxWeqfIXwtGq2PtbCXO9voOsJyLRj59QbvsAHw5SZX9Xa
 pEeQFT7j+tUfaBd/oQaeqSN3ghe6K/45/MjdfaaXxzO5Qee2iKXp7mvlEY/I4GAWn6YgClc9ZxA
 1umTbS23se8Dx/p20l2UAu+adCM0ojDkpFmA0zt8JRZ9WA3DVbX9hrbcnphNYIy3S4hfVqAJVIF
 ELmCew6fsc1WvV9eQww==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609190018

max_nvme_queues was computed as min(IBMVFC_MAX_NVME_QUEUES, online_cpus),
silently ignoring the nr_nvme_hw_queues module parameter.  The SCSI path
correctly caps shost->nr_hw_queues with nr_scsi_hw_queues, but the NVMe
equivalent was never applied, making the 'nvme_host_queues' parameter a
no-op.

Apply the same pattern as the SCSI side: incorporate nr_nvme_hw_queues
into the max_nvme_queues calculation at probe time so that
nvme_scrqs.max_queues and nvme_scrqs.desired_queues both respect the
administrator-provided limit.

Fixes: 018fc3965291 ("scsi: ibmvfc: initialize NVMe channel configuration during driver probe")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 914dafd576a0..ca9a0437fc0c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -6871,7 +6871,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	int rc = -ENOMEM;
 	unsigned int online_cpus = num_online_cpus();
 	unsigned int max_scsi_queues = min_t(unsigned int, IBMVFC_MAX_SCSI_QUEUES, online_cpus);
-	unsigned int max_nvme_queues = min_t(unsigned int, IBMVFC_MAX_NVME_QUEUES, online_cpus);
+	unsigned int max_nvme_queues = min_t(unsigned int,
+					     min(IBMVFC_MAX_NVME_QUEUES, nr_nvme_hw_queues),
+					     online_cpus);
 
 	ENTER;
 	shost = scsi_host_alloc(&driver_template, sizeof(*vhost));
-- 
2.55.0

