Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DF42F87B;
	Fri, 11 Sep 2026 02:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093164; cv=none; b=Aa7jTpyMqS2F368AIn4s0ZJZy0z8KxVL3aQhkD50sXoBkAD/hFTP2srI3DFe86OQK0DzLvWHRqqdJFvsSejBXhrWN5mUA+3kVQbKT0oGdH8mLKDr0NkY4FQN0wI9JYhuUMNtuDDXxXscCO16JcrKyu4CXpBwIHMY8HY+J/D9fj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093164; c=relaxed/simple;
	bh=4xFqXS/FESGVcxpcsdv8mnuluG3+HO/tziXdSDVsEds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gGHGFo4D6l/rQJY2jpFLsdYO/8jOzK+9fBeSKeYq501hKvr8NjCVrh0aA0bk+pFnF4eg3pymH0LzPII3Xqq06izeG979t4+COyfdZ6q9/+7bbqhSMrCg7iq51fsG8kyJanHYeFVO0oNkc+09VwM6i4wFShRKoSvmRJRosAq0bYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bWTS7Jgi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bWTS7Jgi"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B13Cj9179342;
	Fri, 11 Sep 2026 02:19:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=T1jV3KrTc5l6i41ezm/Inf0vbzOwg7TizNcwcknRG
	r0=; b=bWTS7Jgi4uwF+CVY4iNbLCx8Bq7OB+bDIi90nLCaB1a2XCmx+F+v7P+BO
	+peYAZVrQYkBP4AAJ+DoS/XqmAN7hiVU4t2kY+HWTVI7IM1FTe3ZpY2eTbAFDY5/
	qXG1nDyISILLlas4OKHGf547g3I5mrj11K9H0zlLl1eDc8yLe5Tlho0LxZd3pdKb
	ruq9yFt8ICwEg5SDQjgFBpCxt3sBHjIefaEUQ6VDE7OvkTaPGWM9d9OOjLNFsDNo
	WvHM34eTodWaAqO3+De9yuteYCWVxHRAR/urS5pzG82pJ5GZhFDAds2Fts65ZekH
	44P/IUVgQixzF+c6XYcLmGTetaUow==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8s8psq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:19:14 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B150N3891377;
	Fri, 11 Sep 2026 02:19:14 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvq2uvpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:19:14 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B2JCTD26870314
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:19:12 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8751C5804B;
	Fri, 11 Sep 2026 02:19:12 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9850858055;
	Fri, 11 Sep 2026 02:19:11 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:19:11 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v9 0/9] scsi: ibmvfc: make ibmvfc support FPIN messages
Date: Thu, 10 Sep 2026 19:19:00 -0700
Message-ID: <20260911021910.1038128-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EkTYJBy2NSgpqgY84qyxYopoc47MNtsM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX5IrpIXJ6jsQM
 6LapbHtkBxVLZ8c5JCpwzjEF83h2j6tIYYfKvrWdOnSwmdX230KSixIVCCNfSaqekwJttJTn6F3
 vBpVpLM6S/m1lCvt6SgS/Yww5Gklq6YK2/dAxDwLKqLTaElt3AMb7tX/bn4+iDnQPtTWBmns/N0
 s7WUvDsYBmtHLcBzISUjwtaNH7ykyPPMsrzVs6pjFMN1j7zz/N6LtOaT+IKHgoixz02DFyVWB3n
 eLXo2QQJjRFisV8p38tGbRK1DL4ebL89o4FXbpRwRDk2DEDn3OzaoQPA+pxvYQs0XdhYUbah6R3
 oRwShE/vLqioQq97c/8k9YMtQ5ropCvm5XbV+L7VDnXaZfnvFqI8ZDYkUlJ8uBeee543u++vvNi
 2AcgDjyPx3/PW5eGxlr2lM1ptGXk9gQAM716GZeZwKsVYXw8cJgONabchHQ5fwQa27TgqHi/J7d
 grfGgz+OBaHFuG1CfgA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX73S935TAQMll
 OjDn1ZGKJTrk/3qN+YIdTjzjuOkIPyy/U3+QG/sENha8UibpEvDq7MDEGw1EKScj+SIzD4mlly5
 pGJ5oFFcaQJnCEQzo+1SiErtxxEyNPU=
X-Authority-Analysis: v=2.4 cv=MpXHeGae c=1 sm=1 tr=0 ts=6aa36522 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=bC-a23v3AAAA:8
 a=bLk-5xynAAAA:8 a=pGLkceISAAAA:8 a=voM4FWlXAAAA:8 a=5GWuvAQmnGDQSWin3f0A:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=zSyb8xVVt2t83sZkrLMb:22 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-GUID: EkTYJBy2NSgpqgY84qyxYopoc47MNtsM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110024

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
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 724 ++++++++++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h       |  63 +++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 408 +++++++++++++++
 5 files changed, 1144 insertions(+), 62 deletions(-)
 create mode 100644 drivers/scsi/ibmvscsi/ibmvfc_kunit.c

--
2.55.0

