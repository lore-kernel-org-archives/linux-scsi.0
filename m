Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2293306774;
	Thu, 23 Jul 2026 00:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764939; cv=none; b=dJCXebbqrX8VSpwDSPfvMAKdh6Pej5cuYnrnE3sn5AiDVOKHYaS5UmwQ0r2hTN/9Wg9VsZmP+oKQYPv2GsYNSAILKTjlESnMCIIlUuUHMR9P+Fs4tjcAOI9vit6sLDP6iAeKNa1OHZ3UQ4wJlyzNvomV5d1sdTduHu4sZ6zzW88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764939; c=relaxed/simple;
	bh=1r3en/L9ONvbvUXUWlyc4iRKf0SW5WtsYogliFBB/oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrjL1ljJ6eAjcQNB0P99G6qnooXUbsRvuREfxa+FznvQ9rGAx1BfqOTfIN6VJfmWSdDFG58YXDmCBUCefafW97rY3HeD3GH+WOvbn/FKbTOAIlhilUVHNzoDapEzyrITzLlkvOTUiorhdS8oM4xpo89CLWLx2FQ/kDcbe3Mwsyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qLxHey/O; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qLxHey/O"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBghn704661;
	Thu, 23 Jul 2026 00:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=iKP19Gy0I7YPiZgvG
	eYzV8XDayV05CWOuwTMZlJYS2U=; b=qLxHey/OEA4HYfEIy7niFjdvpOS4PbO7F
	ayszK5pJEJbLM9XUrtq4AQHow34wV4qHZYP2EtxDJCakugxn40zOZoBpmhXEvhVU
	wLtWQHnBor8BBp4JDNy9T5nFf+QUFf1NFsDxnODj9fhNDafhkEYtN/E4IGzqO9kz
	BwHFAAi54ZScmzqFL7n0kVeOKQ5CEsUXTrYYYjPG643tFgHzDtXG63bNl0DoCB8u
	tdCkhp/ysLXm5VE9ypf+DOijfX/sDilspku+Vv3L4A1MpQXu5viIxHJmiWJfaAus
	iMv7B6/bf5ThiTjhAtlqj4+dyEFj2qT7KCmXSgF3yZ3Fjm3O2QvSQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abmynb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:05 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnaPc028971;
	Thu, 23 Jul 2026 00:02:04 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgpgyhfqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:04 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N023qn21234260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:02:03 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 30C2F58061;
	Thu, 23 Jul 2026 00:02:03 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 894695803F;
	Thu, 23 Jul 2026 00:02:02 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:02:02 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 13/33] ibmvfc: add helper to check NVMe/FC support with active channels
Date: Wed, 22 Jul 2026 17:01:29 -0700
Message-ID: <20260723000149.969416-14-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX5YgSDN194RHq
 myrqK3HySiNyXAIJ5rzsnyQJG3aRyzeUeHdhzMrlYlbGookYxvRvd3fi4yimCFmoH3UQ7d9BTeQ
 zUzCmevudOLSZdrLLDxMlE9FKgP3QAa9XJ0h+j7ajHR7hyJjrUvS/tM3kAogLZfD2xu5IwQyiNW
 8IT3fIydkp0DnfYpUXhBKHlmASI4utwagw9/HnbyNHTvZ4i3wD34838Di4M+9j8M+HSTEe8h91g
 kKAbXFN9Q+NQocx4rcZQojwwG1oT3fiWJxUIbwELn4tkWAoloGZ3ty49Mw2YtN3gm5auKtCZ3FH
 vo6yO8v2nPDwTsEMgRXxt45MZW0D0ixwz1UsYJzvDA3SlveI4pJC97eAG1WAEkBfrLv05oFnQt3
 YFCON0iI/BeS3sm7TfSqxhmms6c/I9455s2sLE+H8uOqVf/sD/meIF2svKsJHiuljkAPJ3X2iSf
 3yZ9megMPT3eHoJ0fQw==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a6159fd cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=9D5glHWTs2YOxXNpKTwA:9
X-Proofpoint-ORIG-GUID: fhaIbfKXM5g4EUlIehfpZYMvkdI4pPoE
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfXxmi+qEE/LQDw
 pJXumRDvVIwaXXSWJsLEsjHC9ChNOdaGwr5ZQ0WoFLtzLk5rPCAEIfXl7LfkaX85v9VY2zBrZ2T
 +1i/a5tK3jFKk02bnFpBkxhQiItS0Dg=
X-Proofpoint-GUID: fhaIbfKXM5g4EUlIehfpZYMvkdI4pPoE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

It can be the case that NVMeoF is enabled on both the client and VIOS,
but no queues are configured making the need to do NVMe target discovery
pointless. Add a helper to short hand the capabilities check and active
NVMe queue check.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 84302f982a6a..088167ec04ff 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -207,6 +207,12 @@ static int ibmvfc_check_caps(struct ibmvfc_host *vhost, unsigned long cap_flags)
 	return (host_caps & cap_flags) ? 1 : 0;
 }
 
+static int ibmvfc_nvme_active(struct ibmvfc_host *vhost)
+{
+	return (ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NVMEOF) &&
+		vhost->nvme_scrqs.active_queues);
+}
+
 static struct ibmvfc_fcp_cmd_iu *ibmvfc_get_fcp_iu(struct ibmvfc_host *vhost,
 						   struct ibmvfc_cmd *vfc_cmd)
 {
-- 
2.55.0

