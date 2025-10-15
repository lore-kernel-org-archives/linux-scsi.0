Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C542046BA
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2025 20:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760561601; cv=none; b=co5QkdjjLEHuST+ou+HrpgJSunfNaGrroJiLuf3MBThB/8PoJQiSNwDFWV8AcJ9w8rd5IhWbrYJz8ruU+jn3+2mA1YcqgwGcGo0OA430fXMyzp03Nb4SV53GCtl8XSiCgzgBSY52d9gN2W0RSfWWLc4n/Mp+8WlAizDK/mbT4qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760561601; c=relaxed/simple;
	bh=+XVak7bVymPqkxKYjULdtigGhv9PEpKQW1czaG+7n0A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cZ0mFvOm1ICkuZO3/RwGZ31eEKbO5+S0KoyGG2SJizm1hUtg7R3DxQ+YGFMAAhgJTRj4mCe8QLXQEy6d8wm2tyIPnL3NLy2kc1Z3bN+ce8XUWc68DxnKfZOH0bDVI5xTkF1vJi5Hh5HoqI2WeYpv87Zb3s/kWs5r339jsD5gcPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ktEbaHyk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ktEbaHyk"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59FDhDHx021809;
	Wed, 15 Oct 2025 20:53:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Z5MyP2IxPcPPymT/eAwpVfn6i6t8+jBnSFUOcAXkf
	Lw=; b=ktEbaHykKoFQhdVrRS0SsS/DW3emCC+vAxrVJWznevpDdCsxUeHF737ZB
	icHbhw1PjwLWhnkinVYWC/w0HhjJrs3AfYM0xmV2GWBVv3IFVgFc21tCvNrXeYID
	0PKK7OxOa5QD65pQkuiU8tGdiL/ntgqnRn4xMqSKxAvx0lobNMuKVMiBpxk2i+9Q
	2Nkhxy7EIQT+0gGm09n7DO8ew7PCgw7XQfc9/vEY2ssEIYrwkMEimKOmvAyzxU9S
	1WXLTz9H66Bl0Xl3l9qxO41wCsT37c1IM1q0GnBCZRajkcDmhiqzjCBca5gbP3i2
	CUI+KpVBfmbTzGthty9jTUql3uKtg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qey8xwej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 20:53:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59FI8kpf016745;
	Wed, 15 Oct 2025 20:53:16 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r32k2ax4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Oct 2025 20:53:16 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59FKrEar23528168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 20:53:14 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 575635805A;
	Wed, 15 Oct 2025 20:53:14 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C6F458062;
	Wed, 15 Oct 2025 20:53:14 +0000 (GMT)
Received: from smith3.rch.stglabs.ibm.com (unknown [9.5.53.254])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Oct 2025 20:53:13 +0000 (GMT)
From: wenxiong@linux.ibm.com
To: njavali@marvell.com, brking@linux.ibm.com, linux-scsi@vger.kernel.org
Cc: wenxiong@us.ibm.com, Wen Xiong <wenxiong@linux.ibm.com>
Subject: [PATCH 0/2] enable/disable IRQD_NO_BALANCING during reset
Date: Wed, 15 Oct 2025 15:53:09 -0500
Message-ID: <20251015205311.122963-1-wenxiong@linux.ibm.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: X4BgsJrdKfAXk1-mzzTJTkYOKBwa5BGV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMSBTYWx0ZWRfX0tev5t8aogzR
 vwAR/CKRxW/qIjo0yaYX53NKtSHEYOrppFtGXY9y+BDlkpFqpyYuyzBBsw50aIA46aPQhZu3cOk
 2t9lbVRWPseG6zDe6MjbjAFnmtosLYeEUI8sFTdzXzDhYuiQ5l0ZkDqiQh1uEtQQ85Km2yizG+A
 vktg7PyXFoCNNe4eI2eJ3XyOxmjrJwT+YWSNGiW0SmQhCEpYgMDOirQUZKnqh9D6sMOpX0XvxfU
 fHAyriUL1Q3DgRnrZboJcH8YUs+CbZ7prv9Nj3aYqJIfEb/IdwRboDW5gQDsFqh5E3v4RykuVkh
 u/BV6uj9/QzO0a+vLDKv7RmmNT5k0jC/FNLLMXPCo72rndJF9Oy9cwo4Ldl1AXq8eCCyUPKi0ie
 Qq16QBBlupsKSXSTSNAXl+uFRigBHA==
X-Proofpoint-GUID: X4BgsJrdKfAXk1-mzzTJTkYOKBwa5BGV
X-Authority-Analysis: v=2.4 cv=QZ5rf8bv c=1 sm=1 tr=0 ts=68f009bd cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=cBzspS9LAY2_2Rje7H0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 impostorscore=0 clxscore=1011 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110011

From: Wen Xiong <wenxiong@linux.ibm.com>

Issue is:
Dynamic remove/add storage adapter(SCSI IPR and FC Qlogic) test
hits EEH on Powerpc.

This patchset fixes the issue with enable/disable IRQD_NO_BALANCING
during adapter reset in both of ipr and qla2xxx drivers.

Wen Xiong (2):
  scsi/ipr: enable/disable IRQD_NO_BALANCING during reset
  scsi/qla2xxx: enable/disable IRQD_NO_BALANCING during reset

 drivers/scsi/ipr.c            | 26 ++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

-- 
2.47.3

