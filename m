Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A9C2E54D3;
	Thu, 23 Jul 2026 00:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764939; cv=none; b=O2gygS3juLPBfzDJbUXSZkVAf2GtM5NFIKk5WQsXV8SFZXDQsrrrO+IrlOmIOwdkWP9/iFfcdgifn7LjS6hBDHLJ5pJt768IKF5BUygc4SWg3/0RzlesL+U3p7Qo+egfX/LYsupeNS1aULpV901uFbH6jIdrjH5tumAoHDVtHJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764939; c=relaxed/simple;
	bh=wn5KyesstrINpD48PMHM/6aTzCfwlj0p6IUSyjMsrAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpNLCL8pMgU/WUs9Tz0CW5iT26bYTulILPhbDcnbZIv4jlGsEJwPB/BNP2K9LJsnczMrenmrrxOFqrYQkTB35A35zfYlbTo/303sPypGlx5IGOW7c96o415LcWoG2x0sM+0QrDMniuC7JZX33SebGgqnggRPDy4U3ecQ1il5W4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O4dofb19; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O4dofb19"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBkOm712855;
	Thu, 23 Jul 2026 00:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+CV+3oeauSD53h+iE
	18B3fD83narQ9ScmrEbL6F/fLc=; b=O4dofb19wGSefWdHRV7Aap71fbZzrwhT8
	ca/e2fbbNVkL0WzaOjLs4kgOIzkAvTLLk0bNAl0QN0rwRkQel9+w94mnArwPoePl
	cdiXToHuKlWD+QNdUNvaxu0Ulc4JLx7XuNsJyySv8ezw9H+gu6bLtBV3VesyfLRc
	1axnJOfFfFnwEpkfUCyiVYyS6ShL/LI7mqo64QU7AzWUD+hW/bqLmyeTX7YEmZp0
	p/n46Sscc7A95kUMFClGlwcVHyKP82eY5wevGtZXyhFvE8XYm1FBXOZvmgvgLt6Z
	PuYMNd7oG30WTINDJjj0IipjPQrJRsgt1xw36zXVi2/ld+kIqKOOQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7ahcct1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:03 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnr2q021831;
	Thu, 23 Jul 2026 00:02:03 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgm6w9uj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:02 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N021xs58982878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:01 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADDB258061;
	Thu, 23 Jul 2026 00:02:01 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1207D58056;
	Thu, 23 Jul 2026 00:02:01 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:00 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 11/33] ibmvfc: add wrapper to get vhost associated with a channel struct
Date: Wed, 22 Jul 2026 17:01:27 -0700
Message-ID: <20260723000149.969416-12-tyreld@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: BhCmXeIcrOEyCkim8HofqM-Y156p43W_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX63hp360X0nrj
 OjHi2juBkPQHqVnt+Ty6MkVlsT6EvJVHV6qUN9yRjb1wSV35MR0eLMC1O5cNdxnMBhEZ9sufPfR
 tv3BgU0IEdWtro3qspAZVYTu2MdzBJBjl12eDc+/XxQui2kDDyfwY7way2V861/rWH5p3Cm8LQb
 C1kXjouBkv53QNcg2kiKB0N2VVkpqoXdJUukoOEd7zOGzhg/69S9VUtU+OMPWWGwW9hK24jggs5
 pOF01s83wgvZL34YwOfI49DZV0xGSdy8qg59pDEDZxV0pZQqpWsz9o5ArkzMBDy4jiHl0bZu51j
 VeR+dNJZ7fMYN+fhZXi4UzoLdz0e3GYZV9vZZNlchkJxoT+6fYgtOuC8cl1bNNkOh9r68lxHx3V
 4kXUgkZd+/XTzNO8gnSJGBabuEBJV1b5mTSSeQSZJYX6r/TczlpkO0TdNMNheKmQAZJwpa0uEuI
 oqyarZhu93vBlDKTkHQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX4vfywXRGGBJS
 72CQHHNb8scDV6SKy4o2kYnwMf80/4e3HTVPj1QxkZ7UWtC7DNgM9HQfz82XoOTLm/Jxbp+cK6M
 AdtD5db0Wo7wXoYeuVJH9r/YcvVgWcI=
X-Proofpoint-GUID: BhCmXeIcrOEyCkim8HofqM-Y156p43W_
X-Authority-Analysis: v=2.4 cv=SM5ykuvH c=1 sm=1 tr=0 ts=6a6159fb cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=LqRknZQVlxeFVEtwFW4A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

Add ibmvfc_channels_to_vhost() to recover the parent struct ibmvfc_host
from a protocol-specific struct ibmvfc_channels.

Later patches need to operate on either the SCSI or NVMe channel group
and still access host-wide state such as the primary CRQ, device, and
logging context. Centralize that mapping in a helper instead of open-
coding container lookups at each call site.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 454968de925b..67f546ff092e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -1011,6 +1011,16 @@ struct ibmvfc_host {
 	wait_queue_head_t work_wait_q;
 };
 
+static inline struct ibmvfc_host *ibmvfc_channels_to_vhost(struct ibmvfc_channels *channels)
+{
+	if (channels->protocol == IBMVFC_PROTO_SCSI)
+		return container_of(channels, struct ibmvfc_host, scsi_scrqs);
+	else if (channels->protocol == IBMVFC_PROTO_NVME)
+		return container_of(channels, struct ibmvfc_host, nvme_scrqs);
+
+	return NULL;
+}
+
 #define DBG_CMD(CMD) do { if (ibmvfc_debug) CMD; } while (0)
 
 #define tgt_dbg(t, fmt, ...)			\
-- 
2.55.0

