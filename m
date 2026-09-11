Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3CF3C2BAF;
	Fri, 11 Sep 2026 02:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789092508; cv=none; b=iYuxga/5J+p4fhT2DAw0O1BXS4odzoXnNdUJp4rIOV+5xhUsp9cHfOSb44O1qqnoJErXYDFT6lUtVeWZroU4SixhFKBxue7BJxO04A9owI8ZO3WQSEQb4RGGDFXyu07+dRvdMBaVOrfc2wgeocKZ2W3mgSyIcsn6usgFuWKnAhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789092508; c=relaxed/simple;
	bh=Kne77NuE+y1LmifNvjd7W0ry+d9iGmUjewUOEP1dScw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Y6cIq1zWuN7AXGep5gnLdLqOC/CnyDB120mr3M5bVZYJ9k3tAeNgJbi99cA37eMKu9d0EveSirGoRGM0VDB3Z6oQqz/KrLL+kYg+8WIehK04oI2z/9XdKnUCFMTXSppPYohtcDKwKSlsGWl6fZCuuFsV6Mgj4tcy6uNFX3QHUgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hQzKW4+K; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hQzKW4+K"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12QVf348208;
	Fri, 11 Sep 2026 02:08:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=fX329TkfZvDAeS3NAfrFYW51BJAS
	DixWlQBJrIcZvtI=; b=hQzKW4+KA0Lso1DbuWQXEa0gGMDc42n8gKqBRcpwm8QN
	12saHORKJfKD6vMjUzEmj3dN3jpmvs67WVpeOlXPsYOoV6OsMTFcXjOAU99EGKOH
	z66v0F3hdxJeYadOH+/I498QH3FntI1bkYFDWzQcAVF91iCCaHGUekA95tu1BH2L
	iIMvXzIoIngfPpRu0L9JW4eeeotXwvuWAMWRbsoRcwrg77dhDR7jLkTRwP+rL+qG
	9UglSimRr25+UtL3eZxvz0qN635v6IMXA9NK0b4FoZ9O8Gk9w8XV2MnSmhqB4Qgm
	0jzlxVZoZ3hzLgdS7wpFUa+2vr8uOlgQqz/hf1i2Ew==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8t0p5b-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:19 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B150Bb900639;
	Fri, 11 Sep 2026 02:08:18 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvnrkukk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:18 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B28Hik60948976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:08:17 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CF0058056;
	Fri, 11 Sep 2026 02:08:17 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F3F4D58052;
	Fri, 11 Sep 2026 02:08:16 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:08:16 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v8 0/9] scsi: ibmvfc: make ibmvfc support FPIN messages
Date: Thu, 10 Sep 2026 19:08:06 -0700
Message-ID: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfXxTCFxXQG1WeW
 swmqdQXdOzjpBemZIlBXDAJw5v7ZpR28mcI6XhD0W8ID84/nK9Jytmz66cLousplvCVkKiqe7gL
 8T2OlIn/yqkWCrqiUhJ/Qgo73BvqoZ4=
X-Proofpoint-ORIG-GUID: CprZPG3IInOSMqOhjTWwBw54xxxcVQqW
X-Proofpoint-GUID: CprZPG3IInOSMqOhjTWwBw54xxxcVQqW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX2sFDZfmCoCwG
 kiH/XXHGNzwhzs7P/LfRHIimRPxFkhZxbbFXVywGOTASUKVjoYgLBZtL/hbx7BmD25rO4sGo9Nt
 F1MHKvtfQ8Y2r+P0d63ItbzWKo/PvVijoldwyTax5NhK0guV12c8IdxBH0FB1oJyuEG39vKA59a
 +e01QvSc1usKjqVT7C5dQYO+l51TFaApRCjkTbv556GCvQuq8aMcjE1//qkLj2STX+J5RJh3OGH
 U9ShZPQdMj8H7oLWq7UWIjw7RTkf01f86nXrOC4jwgLhGPA0rd2aNlYIE1DLPejNViT/KPjuISq
 j9A5nOYhp+3VJGw28hefcuweiPDLwkramVtH7drvo5PcVr/JtUgzqrx0INanGeZ6pwzMtoHl817
 +pzgcrIR8LqhAcaAJm8vaeUBUiphK6hYLOyq15Q8pOQj6BbrQqHPopSHQEF9zb8YrsLL4DlM4AW
 Tm4FvqamjX+Uiq1v6Dg==
X-Authority-Analysis: v=2.4 cv=PIGaavqC c=1 sm=1 tr=0 ts=6aa36293 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=bC-a23v3AAAA:8 a=bLk-5xynAAAA:8 a=pGLkceISAAAA:8
 a=voM4FWlXAAAA:8 a=5GWuvAQmnGDQSWin3f0A:9 a=QEXdDO2ut3YA:10
 a=FO4_E8m0qiDe52t0p3_H:22 a=zSyb8xVVt2t83sZkrLMb:22 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110024
Message-ID: <20260911020806.cSDWsQqBa8ldRvP38xQbZTf7GRVWL2_Ez8vLUCD9wVY@z>

From: Dave Marquardt <davemarq@linux.ibm.com>

This patch series adds FPIN (fabric performance impact notification)
support to the ibmvfc (IBM Virtual Fibre Channel) driver. This comes
in three flavors:

- basic, to recognize existing FPIN messages from the virtual I/O
  server (VIOS) (patch 1)
- full, supporting additional FPIN information and using its own
  asynchronous sub-queue and interrupt (patches 3-8)
- extended, supporting FC-LS-5 (patch 9)

Full and extended FPIN support requires a new asynchronous sub-queue
with its own interrupt. The asynchronous sub-queue support requires
ibmvfc to also support a new IBMVFC_NOOP command, which the driver
recognizes and ignores (patch 2).

The asynchronous sub-queue work is split across four patches: patch 3
defines the necessary data structures, patch 5 adds the interrupt and
drain routines for the queue, patch 6 extends channel registration and
deregistration to accommodate the new queue, and patch 7 fixes IRQ
cleanup on registration failure. Patch 8 wires everything together,
registering the async sub-queue during channel initialization and
advertising support to VIOS during NPIV login.

All three modes convert an incoming FPIN message from VIOS to an FC
extended link service message, in some cases using default values for
information not provided by the VIOS FPIN message but expected in the
FC ELS message. This FC ELS message is passed to fc_host_rcv_fpin for
updating statistics and sending the information upstream by netlink
multicast, where it may be read by listeners including the DM
multipath daemon "multipathd."

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
Changes in v9:
- Fix ibmvfc_find_target() to check for either a valid rport or nvme_remote_port 
  so nvme targets are not silently dropped (patch 1)
- Restore xxx_host_remove() ordering and destroy async work queue prior to these
  calls. Check that the host is not offline prior to enqueuing new async work
  (patch 1)
- Link to v8: https://lore.kernel.org/linux-scsi/20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com

Changes in v8:
- Split patch 6 into two patches: extend channel registration/deregistration
  for async subq (patch 6), and clear sub-CRQ IRQ on registration failure
  and guard teardown (patch 7)
- Fixed NULL dereference in ibmvfc_deregister_channel() when called on
  an unallocated queue: guard memset() behind scrq->msgs.handle check
- Fixed variable-shadowing bug in ibmvfc_register_channel() error path
  where H_FREE_SUB_CRQ hcall result clobbered the return code
- Deregister and re-register async sub-CRQ in ibmvfc_reenable_crq_queue()
  and ibmvfc_reset_crq() alongside SCSI channel queues
- Link to v7: https://patch.msgid.link/20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com

Changes in v7:
- Removed CRQ valid bit clearing to callers of ibmvfc_handle_async in
  all cases
- Added validity checks that IBMVFC_ASYNC_ID_IS_ASSOC_ID is clear
  before using node_name
- Fixed error path cleanup in ibmvfc_init_sub_crqs
- Deregister and reregister async sub-CRQ in CRQ reset and reenable
  code.
- Moved work queue destruction after sub CRQs teardown in ibmvfc_remove
- Modified async event handling code to use a tagged union rather than
  void *.
- Use WQ_UNBOUND rather than WQ_PERCPU for fpin workqueue, as FPIN
  events should be rare. Hold q_lock only in
  ibmvfc_drain_async_subq(), like ibmvfc_drain_sub_crq().
- Hardened KUnit tests to use host_lock and kref.
- Link to v6: https://patch.msgid.link/20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com

Changes in v6:
- Use alloc_workqueue rather than devm_alloc_workqueue, and add
  explicit destroy_workqueue calls
- Moved ibmvfc_find_target into patch 1
- Link to v5: https://patch.msgid.link/20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com

Changes in v5:
- Incorporate changes for NVME-over-FC.
- Removed now redundant fabric login patch.
- Link to v4: https://patch.msgid.link/20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com

Changes in v4:
- Refactored channel registration
- Check whether async work queue is allocated before using or freeing
- Fixed work queue allocation/destruction
- Skip basic KUnit test when there are no ibmvfc devices available
- Fix target not found condition in ibmvfc_process_async_work
- Link to v3: https://patch.msgid.link/20260702-ibmvfc-fpin-support-v3-0-d95b9747cf88@linux.ibm.com

Changes in v3:
- Fixed latent bug, exposed by VFC_NOOP, related to dataless CRQs and events
- Fixed FPIN TLV descriptor length calculations
- Use safe list walker to walk targets in ibmvfc_process_async_work
- Added write memory barriers after clearing CRQ valid field
- Use per-vhost work queue for FPIN work
- Link to v2: https://patch.msgid.link/20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com

Highlights of changes in v2:
- Refactored mostly common FPIN conversion routines and async event
  processing into single routines with wrappers for differences.
- Moved FPIN processing to a work queue to avoid conflicts with
  fc_host_fpin_rcv and memory allocation
- Set descriptor sizes correctly
- Use target WWPN for basic FPIN descriptor
- Split patch 4 into 3 patches, for definition, allocation, and use of
  the asynchronous sub-queue for events
- Link to v1: https://patch.msgid.link/20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com

To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <mkp@kernel.org>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
To: Nicholas Piggin <npiggin@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org

---
Dave Marquardt (9):
      scsi: ibmvfc: add basic FPIN support
      scsi: ibmvfc: add NOOP command support
      scsi: ibmvfc: add FPIN extended flag and async sub-CRQ queue handle
      scsi: ibmvfc: extend async event handlers for async sub-CRQ events
      scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
      scsi: ibmvfc: extend channel reg/dereg helpers for async sub-CRQ
      scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
      scsi: ibmvfc: register and use asynchronous sub CRQ for events
      scsi: ibmvfc: handle extended FPIN events

 drivers/scsi/Kconfig                 |  10 +
 drivers/scsi/ibmvscsi/Makefile       |   1 +
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 726 ++++++++++++++++++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h       |  63 +++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 408 ++++++++++++++++++++
 5 files changed, 1144 insertions(+), 64 deletions(-)
---
base-commit: 12e67eb89eb2b9516685c744d3f7de0a2d1bd701
change-id: 20260407-ibmvfc-fpin-support-b9b575cd2da1

Best regards,
--  
Dave Marquardt <davemarq@linux.ibm.com>



