Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73273C73D9;
	Fri, 25 Sep 2026 04:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790311712; cv=none; b=hFxXRozF+5tSYLle/y5qkIoBfVt/b4REhFs9W+p76D5Zur+E04h9jZFSzOUbL0hq+IB2WAdxHQPfRmHVu+jomuz+nwOfQIBppf92IP1tcwLiYG3l2mDeN/2b/67MjFxGUL/jBrOhLJ58gTnnktqq1MsqaGxwyaKM7N3GstneEac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790311712; c=relaxed/simple;
	bh=6dQAE0gwAMiJAh//t+0UJLAtsv7HiK+tjKwjRsBxFTg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B7xcDh8H9yjdLNgGgaHcZInBP7bf7lgG+jJaasRXmZT8zglBxigWzTgto8cqvGgUKBCGCRPg3GWia2uUW7LUhK5icFinJU+sX6hts/iFbq2qvfuvBC9xvN83rHnaqM5mZPb/1COLKaLxqUzwaJ1o6dO+HUwxH35VRzdIJWXuUXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bp1UTOWm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bp1UTOWm"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4ZvKm4104249;
	Fri, 25 Sep 2026 04:48:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=G7jhdkklPlOJC85ujOghG54zPDINjvnsEUD4BdkSK
	hw=; b=bp1UTOWmMVsEhqrKuGoEcwZ95muW8e3MvL9pO+63b1Ghdh2GQnB1kTWLT
	lpX6/G5J/mrmuqGQKK8n/o8rAB+6xAtzK/1B6Ipwz0AzJsTnKJVem8nqDsc986MO
	YhvShMzDk3mFvMAHkYoHMRMpoH/qK1tltZYKtegSc6i0NrilTldNazE0Lb8s+A9f
	mmMiefpDB0XlsN5aIatDL/a1IjtMnmSgHpQPCE+FMF07Lgosz/YXNmXj8+HLGinX
	I4aq+CPJX5sAe1mO2TTIaPL83Bv1CzkZUNn/ULULXlMba7y/CF24//8ReoHyrNeD
	jWYUhX9Vzt3yLtyTxYOr2LOvxQGDA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1vcwh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 04:48:22 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4lYan3298386;
	Fri, 25 Sep 2026 04:48:21 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gvb8k12q1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 25 Sep 2026 04:48:21 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68P4mJeH20251230
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Sep 2026 04:48:20 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D025658051;
	Fri, 25 Sep 2026 04:48:19 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6D265805C;
	Fri, 25 Sep 2026 04:48:18 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.142.241])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 25 Sep 2026 04:48:18 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v11 00/11] scsi: ibmvfc: make ibmvfc support FPIN messages
Date: Thu, 24 Sep 2026 21:48:49 -0700
Message-ID: <20260925044900.414340-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: i6cqxHBivG8M-qJBCsbJO-mX-vNczbZH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDAxOCBTYWx0ZWRfXwTp1vNxfx3u/
 IU4PpQqiCxyct8iNZR4RPJXXqvut1Y1xjwZWi7quC0iC4drq6kcuSJAoMa7WPQLBpQuJhqbf3Dl
 3QtEyUvJ2v7BJqLlH0nk/ddZNEtAJT5O7i3dvVU+bV2mM5iacY7CONX3vsuesgLSR0s6PcA8loV
 8Hg9Jl2hmah7HGqZzykrnBJ7NM6CNochciWw6O7jSWHrP7X0t7eF92ZgeikD7e8WIZ6RFexdL/J
 flFMdD6PcydTE6Hb3PLQbAWoAeKFQEKofDO1Q3Eq9i36Usy0KDZaf5hZ3mDn2oM3FQj/EwXe4na
 ve29rfazLs73oT7E8ook30YHIihMwTJF1Novs1gScMSmFRRw63bCO/m3vP9rNGHXQQShlCNMfsk
 Jn5sl2B/BUHQF1p4ZNmqjotfgJ4Msx3QgCinyvzuxM9JSFIX6INbN86hvzxtPhv2I4M+CnBHhZn
 oArASF9bhirIGOdxifQ==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab5fd16 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=bC-a23v3AAAA:8
 a=bLk-5xynAAAA:8 a=pGLkceISAAAA:8 a=voM4FWlXAAAA:8 a=6DafL9IWkEjNMtfswHYA:9
 a=FO4_E8m0qiDe52t0p3_H:22 a=zSyb8xVVt2t83sZkrLMb:22 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDAxOCBTYWx0ZWRfX3ONmfI5HGjGL
 OO+I2masxdDBnjbSLJaCvXrLrjnWsM4BqGb4+FiYH6ORtyae4E0eHHzMszp81Yzv8p/Lh/k5JHu
 RQLCOpSqK77c5wK1fg0mwDUulAO1rUA=
X-Proofpoint-GUID: i6cqxHBivG8M-qJBCsbJO-mX-vNczbZH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250018

This patch series adds FPIN (fabric performance impact notification)
support to the ibmvfc (IBM Virtual Fibre Channel) driver. This comes
in three flavors:

- basic, to recognize existing FPIN messages from the virtual I/O
  server (VIOS) (patch 4)
- full, supporting additional FPIN information and using its own
  asynchronous sub-queue and interrupt (patches 6-10)
- extended, supporting FC-LS-5 (patch 11)

Full and extended FPIN support requires a new asynchronous sub-queue
with its own interrupt. The asynchronous sub-queue support requires
ibmvfc to also support a new IBMVFC_NOOP command, which the driver
recognizes and ignores (patch 5).

The asynchronous sub-queue work is split across four patches: patch 6
defines the necessary data structures, patch 8 adds the interrupt and
drain routines for the queue, patch 9 extends channel registration and
deregistration to accommodate the new queue, and patches 1-3 fix IRQ
cleanup and error handling bugs exposed during that work. Patch 10
wires everything together, registering the async sub-queue during
channel initialization and advertising support to VIOS during NPIV login.

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

Changes in v11:
- Split the IRQ cleanup and NULL-pointer fixes out of the "register and
  use" patch into two dedicated bug-fix patches (patches 1-2 and 1-3),
  making the series 11 patches instead of 9
- Replaced the single ibmvfc_queue async_sub_crq field in ibmvfc_host with
  an ibmvfc_channels async_scrqs field, reusing the existing channel
  infrastructure for allocation, registration, and teardown (patches 6, 9, 10)
- Added IBMVFC_PROTO_ASYNC to enum ibmvfc_protocol; ibmvfc_register_channel()
  and ibmvfc_deregister_channel() now dispatch on protocol rather than a
  negative-index sentinel (patch 9)
- Added IBMVFC_ASYNC_SUB_CRQ_FMT format enum value and corresponding
  async_scrq pointer in union ibmvfc_msgs (patch 6)
- ibmvfc_alloc_channels() selects IBMVFC_ASYNC_SUB_CRQ_FMT for async
  protocol channels so queues are sized for ibmvfc_async_sub_crq entries
  (patch 10)
- Link to v10: https://lore.kernel.org/linux-scsi/20260911021910.1038128-1-tyreld@linux.ibm.com/

Changes in v10:
- Fix ibmvfc_find_target() to use logical and (&&) instead of logical or (||)
  when checking whether fc and nvme remote ports are NULL (patch 4)
- Fix build issues due to missing & operator when referencing the host lock
  during irqsave/restore calls (patch 4, patch 7, patch 8, patch 11)
- Fix kunit build issues caused by inclusion of code meant for later patches
  (patch 4, patch 7, patch 11)
- Link to v9: https://lore.kernel.org/linux-scsi/20260911021910.1038128-1-tyreld@linux.ibm.com/

Changes in v9:
- Fix ibmvfc_find_target() to check for either a valid rport or nvme_remote_port
  so nvme targets are not silently dropped (patch 4)
- Restore xxx_host_remove() ordering and destroy async work queue prior to these
  calls. Check that the host is not offline prior to enqueuing new async work
  (patch 4)
- Link to v8: https://lore.kernel.org/linux-scsi/20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com

Changes in v8:
- Split patch 6 into two patches: extend channel registration/deregistration
  for async subq (patch 9), and clear sub-CRQ IRQ on registration failure
  and guard teardown (patch 1)
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
- Moved ibmvfc_find_target into patch 4
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
  scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
  scsi: ibmvfc: add basic FPIN support
  scsi: ibmvfc: add NOOP command support
  scsi: ibmvfc: add FPIN extended flag and async sub-CRQ queue handle
  scsi: ibmvfc: extend async event handlers for async sub-CRQ events
  scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
  scsi: ibmvfc: extend channel reg/dereg helpers for async sub-CRQ
  scsi: ibmvfc: register and use asynchronous sub CRQ for events
  scsi: ibmvfc: handle extended FPIN events

Tyrel Datwyler (2):
  scsi: ibmvfc: fix potential clobbering of rc after failed irq setup
  scsi: ibmvfc: fix potential NULL pointer dereference on failed queue
    allocation

 drivers/scsi/Kconfig                 |  10 +
 drivers/scsi/ibmvscsi/Makefile       |   1 +
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 720 ++++++++++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h       |  66 +++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 409 +++++++++++++++
 5 files changed, 1141 insertions(+), 65 deletions(-)
 create mode 100644 drivers/scsi/ibmvscsi/ibmvfc_kunit.c

-- 
2.55.0

