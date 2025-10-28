Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CADD523A995
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 14:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761661478; cv=none; b=FFwZcVgDAh4XVS60vap60mIRrB7Fi6dCiu7izrvFVSFQvIYhB6FbMM4DISYWSVe8KT1G2R74qOrFgSVIJDILNhI6yOYhI2731T5TMo7Br7tpIeE0Tmmr0hA0KVXKAVv8neZIOVG+dRizrenz7xr+4H9s6YawiTfltIecjUE6Erw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761661478; c=relaxed/simple;
	bh=jJHO70NXWzWCBEI5NzrTWNHhFhwUylJWUMBF4cigvkA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tOY97121+6ytp+OOGpCinnzibTvipWPWVX6se1/4axL2ntCHAl52VSebBNOKZtk69LCTFS8tTVXs6FUyd/pZ0KUqsA+YCIN3DWyCe6oiHvNd9sFtm10/PAwMTjdt4Cj8nCqN+Ih3uJ+7i9cqE4rrwYFGj+DjRUekQMvB8nmUCX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NI/JMp+9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NI/JMp+9"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59SEI93J032633;
	Tue, 28 Oct 2025 14:24:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=7Esj2ZkOakp2cA96Oj20fIJYneMH+CcSe+codG/Hg
	hA=; b=NI/JMp+9gQHyHUZkuSixvn/3RE95a6ncZ+CYRmXHj6IgackwLvd5aINez
	9rVNw14yyDg8hraVkPGfbJ3Gx6qLZUrsH8WQuoV9n51ylfkpb0WvkXs/59g8Eamz
	RM0TZ+9hGSul2wJRNBDZtjQmVgxSZqtboh16B7D4uQOUrcm+RAh1p+h1Xs1JLcbW
	m8cTxRbYNgZR3AzZAz81ZVMnn8L/YjGDda2/yfBbmo7agKtqiWD/pZt++Q+wn5dn
	QYp18fGvWqi6tVXtgnG8/UoxbEVnZhT5HwyefROUVSqyCSdMG6S4MisQl0y8VxAt
	9FynZ+3aIg8DEweW8HBGDAcDo+erA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a0kytcjnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 14:24:35 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59SD0Fqg009411;
	Tue, 28 Oct 2025 14:24:34 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a1b3j31e7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Oct 2025 14:24:34 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59SEOUiU14746134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Oct 2025 14:24:30 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A2635805F;
	Tue, 28 Oct 2025 14:24:30 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB8B05805E;
	Tue, 28 Oct 2025 14:24:29 +0000 (GMT)
Received: from smith3.rch.stglabs.ibm.com (unknown [9.5.53.254])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Oct 2025 14:24:29 +0000 (GMT)
From: wenxiong@linux.ibm.com
To: njavali@marvell.com, brking@linux.ibm.com, linux-scsi@vger.kernel.org
Cc: wenxiong@us.ibm.com, Wen Xiong <wenxiong@linux.ibm.com>
Subject: [PATCH 0/2 V2] enable/disable IRQD_NO_BALANCING during reset
Date: Tue, 28 Oct 2025 09:24:25 -0500
Message-ID: <20251028142427.3969819-1-wenxiong@linux.ibm.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uFZGGSoiulVu0ZEpmAkar2-O8YplzTJx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI1MDAwMSBTYWx0ZWRfX2KoylkIKAITq
 8vwIHCNqD8q2+CCPMZ5M/21pjjg3v1YlbXwIcVZlgdlgZer7a+z6s3WCKVTWadufgXj3DxbvPwh
 2lcTuBu6VF6BTXIXN4lvLRF6D7Jp4nsUc8Vc2kPP8OEG8blvo731VNlsrh1Lg3shn9Bvxyrtsnm
 Vyu4OTv7UWMJIQpsgIsHUKwTYUJKazkx4hn4E6ZvgFYlkk54BE50bS9a/+70c+ogi/AlCOCDdBh
 iLEh4cE5cL0lbSO2TFEK6ekIcigmrlZ70JB79IIdMq0k6/FhkEzGbtF2JQzjzwYO9EDdoHJ9XBL
 MIx4NctNoY5JWsD/JGKunhmO4uqrrxA2Gsyg1/KGA/hgIoAY2bscBvKo8Vh0UobRklXT2j5ESoB
 jKaGt21Yex1zew7wpJvjRdOKM2ZMPw==
X-Proofpoint-GUID: uFZGGSoiulVu0ZEpmAkar2-O8YplzTJx
X-Authority-Analysis: v=2.4 cv=FaE6BZ+6 c=1 sm=1 tr=0 ts=6900d223 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=cBzspS9LAY2_2Rje7H0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-28_05,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510250001

From: Wen Xiong <wenxiong@linux.ibm.com>

Issue is:
Dynamic remove/add storage adapter(SCSI IPR and FC Qlogic) test
hits EEH on Powerpc.

This patchset fixes the issue with enable/disable IRQD_NO_BALANCING
during adapter reset in both of ipr and qla2xxx drivers.

V2: fixes the complier issue on x86 platform.

Wen Xiong (2):
  scsi/ipr: enable/disable IRQD_NO_BALANCING during reset
  scsi/qla2xxx: enable/disable IRQD_NO_BALANCING during reset

 drivers/scsi/ipr.c            | 28 +++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 1 deletion(-)

-- 
2.47.3

