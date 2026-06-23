Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3F1375F83;
	Tue, 23 Jun 2026 01:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178252; cv=none; b=ZG1TO4NJ9k5EFmJB84QzaqfmBwZ1JlJqy3lx1lQmcd+XpUWl/9BX17mWYQYQ17zpLTqsdueOLir41UDKrAZ0sXaATRFDC+DU9NEtl9Uwli8glTzL8pObPFVGLg/H4eBeyepst1KZ2TJwZQgZ7FEuiLaRFGi8q8mY2urrSFNHRyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178252; c=relaxed/simple;
	bh=f+s0I2GwSpI7/zd1U0H96oPFFWt5MVUjG57CwKoWh8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a6aSCVz39zmKecal/P9Y6biW9r/NlT7jl9J7p7uOZv+bholIV+fJIp/h68GRgima3GHpnxC280HPgzHBvLcJXDlvwyn5XrPychk+Jkz7MiPAW8X3SNVDnqsGHMk+iC0ZulF8ITpVFMv5MSwtzj4f6up5bSAdp5j4JbTkckHAwsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=elkLZR/1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="elkLZR/1"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mY3n551122;
	Tue, 23 Jun 2026 01:30:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=fghvTa+mDQe7lrkWzHwDkmMybVS+EPvFqMdA2olPD
	DQ=; b=elkLZR/1k9Tww0P17E2du0i1Q3s8LujAUng8/3ZG+JMF5rZNj7Kpn2Ow0
	ZiHgi248Hinf2IEzeo9DKn99wk39OrK4Qtsbbt47jKI+jRpjD989Ht+TnJ5wsqF0
	Z9x7iZFIhcM1oXuk+IhD3JlKJJCloXnTricrkky5kdp3Nrib44LX3xDRTxzNmTuh
	OF9RPMMQwX12pdIwcVm6uVhKqtGzpTXnPZdeU9GFmF/kGQkDXGWjpeZFsHsRTLRZ
	RqysbndyIF7wQFUSQ+ZDCyOESaHkzFEZvgisflSvQ2IpGYwNskxJz0o0IEP0pD8A
	XI6IgQ/MBkwd2EeYPMzYhXt46ZzMw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjhqm1rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:40 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1Jf2L018367;
	Tue, 23 Jun 2026 01:30:40 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7vygn2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:40 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1Uc5m40305342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:38 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37A8758052;
	Tue, 23 Jun 2026 01:30:38 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 978D658056;
	Tue, 23 Jun 2026 01:30:37 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:37 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 00/29] ibmvfc: Add NVMe-FC support
Date: Mon, 22 Jun 2026 18:30:06 -0700
Message-ID: <20260623013035.3436640-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=I4VVgtgg c=1 sm=1 tr=0 ts=6a39e1c0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=N94uNd9e9YkJgE3VtxQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX5JOGC5SzOjqI
 dRughRgfpxhfDge6mKar2JhCow9RJDPBstMIJU8a3F6RD+8yihODdElfz4s+MM+NgM4zfE+1h7y
 h2eB8Hw/d0Z5z1ta2nlPsLeHZBwuXjOy9TGYu7qJm5LcU9yozHrGDb+eEnbQRFz0Bi2/lq7AFC9
 QutQevb0zGLo9lQ/ujsu7vEIp6sCSD8zzwZ60JEJQ7AZjMgpF/YD05SxHRX3FvNEUP2pmrlUydI
 KQ/TSFOYM4TOk2F1uUsDyBehWyVIdZFmfr9B7+gXXD1Jq3TsmxINM0i9KwNupJrVk2w+H3fDw6f
 yFLp4FCTouMaNGrPm5OuJttKye0Z9OmJ5B43ma4gHvxVhahwxhSoQmX+dMSzQB4axhkqL0T4lFM
 zFedPl4MvAiq8Vio9C3PDZQ1GIn1hiAjfpLpf3Q7iU35msJJiECfeWkkS00TT7Xe8fzH9bgqOgP
 zoeeL3sbbULOZPpDQPA==
X-Proofpoint-GUID: qultZKOEUbE9dECoVlMUR0INbbiSe649
X-Proofpoint-ORIG-GUID: qultZKOEUbE9dECoVlMUR0INbbiSe649
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX3S6HzEy9BFjJ
 tLDUxhUnlwQQacuc68MEZEYv3RTtUq5WYD93Sswc16j+yFg+zsDZJEC5Zw4zpkShwt576h5ihhp
 2zyxZNnlmfRDCvZ4Lo1yaFePw9AygDE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606230008

This patch series adds NVMe-FC protocol support to the ibmvfc driver,
enabling IBM POWER virtual Fibre Channel adapters to handle both SCSI
and NVMe storage traffic through a unified driver architecture.

The implementation leverages the existing multi-queue infrastructure
and extends the driver's protocol handling to support NVMe-FC alongside
traditional SCSI FCP. Key architectural changes include:

- Refactoring the driver into protocol-agnostic core (ibmvfc-core.c)
  and protocol-specific modules (ibmvfc-nvme.c for NVMe-FC)
- Extending the target discovery and management state machine to handle
  NVMe/FC targets with appropriate protocol-specific login sequences
- Implementing the nvme-fc LLDD (Low-Level Device Driver) callbacks for
  queue management, command submission, and abort handling
- Adding support for NVMe-FC specific MAD (Management Adapter Data)
  operations including target discovery, port login, process login,
  and implicit logout/move login
- Implementing NVMe FCP and Link Services (LS) command submission and
  abort paths using the existing sub-CRQ infrastructure

The series is organized to introduce changes incrementally:

Patches 1-8: Infrastructure and refactoring
- Move target lists to protocol-specific channel groups
- Split NVMe support into separate source file
- Add protocol interface definitions and helper functions
- Initialize NVMe channel configuration

Patches 9-16: NVMe/FC MAD operations and target management
- Implement discovery, port login, process login, query target
- Add target allocation based on protocol
- Update state machine for NVMe/FC target processing
- Handle NVMe/FC target deletion

Patches 17-20: Local and remote port registration
- Implement nvme-fc local port registration after fabric login
- Process NVMe/FC rports in work thread
- Extend debug visibility for NVMe components

Patches 21-26: LLDD callback implementation
- Implement queue mapping callbacks
- Add LS and FCP command submission paths
- Implement NVMe FCP and LS abort handling

Patches 27-29: Error handling and debugging
- Fail NVMe requests during transport reset


Tyrel Datwyler (29):
  ibmvfc: move target list from host to protocol specific channel groups
  ibmvfc: add NVMe/FC protocol interface definitions
  ibmvfc: split NVMe support into separate source file and add transport
    stubs
  ibmvfc: initialize NVMe channel configuration during driver probe
  ibmvfc: alloc/dealloc sub-queues for nvme channels
  ibmvfc: add logic for protocol specific fabric logins
  ibmvfc: add wrapper to get vhost associated with a channel struct
  ibmvfc: add helper for creating protocol specific discovery event
  ibmvfc: add helper to check NVMe/FC support with active channels
  ibmvfc: allocate and free NVMe channel group discover buffer
  ibmvfc: send NVMe target discovery MAD
  ibmvfc: add NVMe/FC Implicit Logout and Move Login support
  ibmvfc: add NVMe/FC Port Login support
  ibmvfc: add NVMe/FC Process Login support
  ibmvfc: add NVMe/FC Query Target support
  ibmvfc: allocate targets based on protocol
  ibmvfc: delete NVMe/FC targets as well as SCSI
  ibmvfc: update state machine to process NVMe/FC targets
  ibmvfc: implement NVMe/FC stubs for local/remote port registration
  ibmvfc: register local nvme fc port after fabric login
  ibmvfc: process NVMe/FC rports in work thread
  ibmvfc: extend ibmvfc_debug visibility to ibmvfc-nvme.h
  ibmvfc: declare global function definitions
  ibmvfc: implement LLDD callbacks for mapping nvme-fc queues
  ibmvfc: implement nvme-fc LS submission transport callback
  ibmvfc: implement nvme-fc IO command submission callback
  ibmvfc: implement nvme-fc LS abort handling callback
  ibmvfc: implement nvme-fc FCP abort callback
  ibmvfc: fail nvme-fc fcp-io and ls requests during transport reset

 drivers/scsi/ibmvscsi/Makefile                |   2 +
 .../scsi/ibmvscsi/{ibmvfc.c => ibmvfc-core.c} | 709 ++++++++++++++----
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c           | 565 ++++++++++++++
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h           |  48 ++
 drivers/scsi/ibmvscsi/ibmvfc.h                | 209 +++++-
 5 files changed, 1360 insertions(+), 173 deletions(-)
 rename drivers/scsi/ibmvscsi/{ibmvfc.c => ibmvfc-core.c} (89%)
 create mode 100644 drivers/scsi/ibmvscsi/ibmvfc-nvme.c
 create mode 100644 drivers/scsi/ibmvscsi/ibmvfc-nvme.h

-- 
2.54.0

