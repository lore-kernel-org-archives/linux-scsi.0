Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99293CC32E;
	Sat, 19 Sep 2026 01:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781607; cv=none; b=q760nlQ2Zo4On3JaL9UoG1R5ivgDDdiJ84RZzDta/Dd8YLBKVo7pKD4XWl78sLTAn/0zCTawMd4FZl3WbCIqSlbrQ/YKT8U+8SHSAFnd9Lb7Co9i8Fni+TO+aPhf/rbeGL49ast4P0ZMakmjnzsZPDblKI85qfciSiiNJLuz0po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781607; c=relaxed/simple;
	bh=pxxcnXY0+hue1ldpYJe4b0dJH0KVEu5oUd8PZcc+kTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRsVAGuqOE96C3No01v4/aasx1wq9JTKZJShfHNr9OkCmmdDx4kVmDJfjQg6ODtm1oujMgwHQXPxb8Ug5TsYP3dP+FJw4WTecwFgAkpqRJ2ALp0R929BOVDmRRdTjTANAZBXq2aO3ci797dloI495DsUY8ZifXaS7adKDuo/0mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CTlhCqXF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CTlhCqXF"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1VnPA1676575;
	Sat, 19 Sep 2026 01:33:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=kBHt8BpvlOCU9iqJH
	JhW+RlT/TeDRrZPy1ETOcrXw5g=; b=CTlhCqXFzU0oS6/0bU+NLl8aIm+euZsHU
	puK3QpMd5JhC9/4+hHsXmexIKooYBIFdO3bYB1PQhoHbFXlA+K5fLbb6XFl4YIXX
	knKaBCc2FwdSxmqV0EJgT1ZwGDefr/Gh0ytJP55p4k6OCDVSYN9QFfSV3VY/JLZG
	O2ZYcZG5eVRzR06+6prC2f72GPDvh5rE3azzFrd6C8QvwChhM8mL43Cz9SUGHfV5
	40WhMAYLavY5HrHqgfamnSV+JmcKH+I10lVBAB2mZ+tG09lSn/VAx6fXMDHAxbF1
	mxQZ54pXhg/q2VmeYsdOZgCGWKyJnIGHYwwngeuF6bAAXkwDIW7vw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gsgtd803n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:17 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1RlP91659398;
	Sat, 19 Sep 2026 01:33:17 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gsgrgg0cq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:17 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XFF955378402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:15 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64EA058051;
	Sat, 19 Sep 2026 01:33:15 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C46755805A;
	Sat, 19 Sep 2026 01:33:14 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:14 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 06/20] scsi: ibmvfc: fix uninitialized shwqs in ibmvfc_purge_requests()
Date: Fri, 18 Sep 2026 18:32:52 -0700
Message-ID: <20260919013306.2948028-7-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX8OLIdcJgL3k9
 QI/hViVuYIxbF0US0PKYrzI5PpQ1nP2lfUVtJlFkIrfDy6wpVoogbslsD3izA7lncu4PgXgAUcH
 Ig1zdi3w/SaPFCGC+UUeAKgVPWHUy9Ls1yztSRotAbKBBvDUmGOwOtfhPWSO6C6vN/R6JZzWcjr
 91hhT5iuOGm83/HBrO1GI3C2r+lMb52p0pWA9JMHQlMiSYdu2ll6JAgaPUylZPLWd+naUcxdR+g
 QrOhJFbhUCO+fXrSPC+/Z40yZIl8hzSgIiCLbBlLDixVTGMLKkn0qkh2YittVJksNl1hm4hJ2az
 Alk6Va1YMTKg7xVQmOTBwA+Oj2btAQz7xSTXhvQtkAU/xJdwicmGLTlI1LYM396SqCuvk6BjE0t
 n9p/beI5cPBURYPgtBXn6pX8ZtV/Sq1xIYS6dY3dqsjnJlGj7cfu3Nvlkurkmxsb0SLyoyWT0WT
 bdfSD9q4iV1mt/2SjkA==
X-Proofpoint-GUID: wmjiTiqsqXtEU21zBwXIjXUQYOEtu5ZJ
X-Proofpoint-ORIG-GUID: wmjiTiqsqXtEU21zBwXIjXUQYOEtu5ZJ
X-Authority-Analysis: v=2.4 cv=Q49HcI2a c=1 sm=1 tr=0 ts=6aade65d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=6DixLaR-r_zTwfx8U4UA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX0sXlOeAckxSd
 oyEuYgtsWg+uo9HIoOzzt8Y4ha1qiw7sY2tBAcSr4s/3pKhbJBTe3IxtaPm5y0TPbzDCcLE9QJT
 VyXGeLhC/MaSfXlGEB6xlLSqgtRXGy8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

In ibmvfc_purge_requests() the variables shwqs and nhwqs are declared as:

    int shwqs, nhwqs = 0;

This initialises only nhwqs to zero; shwqs is left uninitialised. Both
are assigned inside the 'if (vhost->using_channels)' block, so when
using_channels is false the block is skipped and shwqs retains its
garbage stack value. The subsequent loop

    for (i = 0; i < shwqs; i++)

then iterates an arbitrary number of times over scsi_scrqs.scrqs[], which
may be NULL on the non-channel path, resulting in out-of-bounds heap
accesses and a kernel crash during any adapter reset or shutdown that
occurs before channels are established.

Fix by initialising shwqs to 0 in the declaration so that both loop
bounds are zero when using_channels is false and neither sub-queue loop
executes.

Fixes: 4857949b58cd ("ibmvfc: fail nvme-fc fcp-io and ls requests during transport reset")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index e4a21ca6815d..5ba8058991ef 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1192,7 +1192,7 @@ static void ibmvfc_purge_requests(struct ibmvfc_host *vhost, int error_code)
 	struct ibmvfc_queue *scsi_q = vhost->scsi_scrqs.scrqs;
 	struct ibmvfc_queue *nvme_q = vhost->nvme_scrqs.scrqs;
 	unsigned long flags;
-	int shwqs, nhwqs = 0;
+	int shwqs = 0, nhwqs = 0;
 	int i;
 
 	if (vhost->using_channels) {
-- 
2.55.0

