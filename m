Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576474B3364;
	Wed, 16 Sep 2026 23:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789600177; cv=none; b=XtFv5RV8K78W8LC5WB2Y2RhEiB5x6IIlXgEwZkSmWblG/VICPZSisah2TGq5Qz/43oGOZqLTA5torh68NZzmabiW5O5oi2ZzGus6vGCtsHzMAp8ewvueJ4KNtbfCeuF6K/zbPmKdSOgPlaWVMJ81CqGFHJlWZh4Fn3Y8two3utQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789600177; c=relaxed/simple;
	bh=gJNxHYMu4gq3BaIouWxXAT9r6CIhL4uf1wu1IWDDR1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tL23UTnLeAmSpMQ1Woo2T5gK+m65NBjghD2Ns647zwCvxfoi+dXTg70On/YCII7TQpgpVf0pRTe9fmI6ynE2ZR+YBlYYK4nhW/dUNUpKp/rFEE3NYc0cRJ6L2CFBbRwMz0Bqg+JgsYjCfNaEPIIbWUqVdcW51A892sl8ClqP2uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gFCQoy62; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gFCQoy62"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GG1cTn018016;
	Wed, 16 Sep 2026 23:09:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=eKhKzcumM0B+jhQ6Ba1R2m7KViaw
	duDOYj6k0INtOv0=; b=gFCQoy62VQt7FgBbGqvONiUeFm+kgL17R4FdoN4rin8v
	si2rvWRdnmJgSPOpc13tNP7qRhGsbLzl6b7oaTSZIZkdFBYBbYgj+nhwDaT2BtaC
	jzQxyaa6lIlwrzZ+/kt/1qaCSIjdHBrg0G1tm5YJKWEnXfC3CuWvqZ2l0+bQvp5j
	P7Vyb0ZBAVgi913haYvFYsmtnCsh27l95EsjviQsInrERL4ao9yZkkbvirc+WRJj
	vIG2l1/HnbQ0125GG2+Zm6mjoxP4o6CrALu+skOZfAfRxK1ZU1gjUk34liOTj5xB
	QrVtfzWafCCe4ljMTcv85CDHzpC14KxlxDKBz9rHCg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf57dwu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:29 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68GN2slR1663490;
	Wed, 16 Sep 2026 23:09:28 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gq089rths-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Sep 2026 23:09:28 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68GN9R3g32703022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Sep 2026 23:09:27 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E44458060;
	Wed, 16 Sep 2026 23:09:27 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BEDB58056;
	Wed, 16 Sep 2026 23:09:26 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.141.190])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Sep 2026 23:09:26 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 00/20] scsi: ibmvfc: Fixes and cleanup for NVMe/FC support
Date: Wed, 16 Sep 2026 16:09:01 -0700
Message-ID: <20260916230921.2204729-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: yRlE_xVyLu1Y-FEE7Nhy3KrDUmTyrKXC
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX9Bld07N6wiSs
 u6M3USIEXYOKsVoBzuLqFIezvt6nWJqX7O3iDevWgrE1qUawvReQhYVqq5C1fSbqc62TjrBHfEA
 q7qNc0gAZmhY45U4c9v78++Xj3gEY1s=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aab21a9 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=74HtKBEAB4_Zr82afOYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: yRlE_xVyLu1Y-FEE7Nhy3KrDUmTyrKXC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDMyMiBTYWx0ZWRfX8rbOaTYCXta2
 Rci4FcLbWirZCxUu1JdNZXHgJ0wSzHuis+2OzkyhGfQL1nh9vu/40z28V5VG9HnWM6brb6r7ZhM
 PQuen2lkZB2nNF6giXf4uHLAVx4jmCARHAUxMIYQ3aPuN1Jyv47vhrkdtzbv3LMQVBv2GFfgOSq
 0XRQJHZfsSClUqQE8vQB8ICcYN3cK54Ua7nLXPr1DbMB/5i8x+/VjAUjlaaI8jFXuWLC0G6oecp
 9Q9x8Ea/GBAzfIbkYtDfsExvr2Y19B51gBAglroGM5hyFRU9/AhDQw+ej5jyuubUcGWIeS8oQRn
 F8D13XlNX28914q0S6FacThFSIg6iUvBZevE0PF0ab3J9YUsMUB1DiNkDOl9BBau4HDxt76sCcN
 nsgCTHzNZTAal7SvMsxkx2Q8HxW1U2xmxzSVFc7UucXV55UAdedlBuzJPAb4IKmQVpho0f1ND6h
 4xm+CI+KueEs1/gN+MA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160322

This series addresses a collection of bugs and corner cases introduced with in
the recently merged NVMe/FC support for the ibmvfc driver.

The NVMe/FC code added a parallel target management path, a new set of
sub-CRQ channels (nvme_scrqs), and integration with the nvme-fc transport
layer alongside the existing SCSI infrastructure. Several issues crept in
during that integration: missing initialisation, incorrect locking, blocking
calls in atomic context, and logic errors in shared code paths that were not
previously exercised by the SCSI-only driver.

The fixes fall into a few broad categories:

  - Correctness in the NVMe FCP/LS I/O path: initialise evt->tgt, fix trace
    logging reading SCSI IU fields for NVMe events, and ensure H_CLOSED send
    failures call fcp_req->done() so the transport is not silently stalled.

  - Locking and context fixes: defer nvme_fc_register_localport() out of the
    MAD completion handler (which runs under host_lock with IRQs disabled),
    and make the FCP and LS abort callbacks fully asynchronous to eliminate
    blocking wait_for_completion() calls on the same path.

  - Data races and UAF: protect tgt->nvme_remote_port reads and writes with
    host_lock, fix a use-after-free and stall in the LS abort timeout handler,
    and handle ibmvfc_send_event() failure in ibmvfc_cancel_all_mq() to
    prevent a hang and UAF on queued cancel events.

  - Shared-path bugs exposed by NVMe: fix an uninitialised _done dereference
    for SCSI TMF events on send failure, an uninitialised shwqs stack variable
    in ibmvfc_purge_requests(), a u16 overflow of max_cmds in
    ibmvfc_set_login_info() reachable with combined SCSI and NVMe queue
    counts, and a wrong target action in the implicit logout NULL-evt error
    path that caused an infinite reset loop.

  - Lifecycle and resource management: call ibmvfc_nvme_unregister() on
    adapter removal and before ibmvfc_release_sub_crqs() to close a TOCTOU
    race in ibmvfc_nvme_create_queue(), guard against local port leaks on
    link bounce, and fix NVMe sub-queue registration failure incorrectly
    disabling SCSI multiqueue.

  - Concurrency in target discovery: serialise the SCSI and NVMe
    discover-targets MADs so both completions have written their target counts
    before ibmvfc_alloc_targets() runs.

  - Minor fixes: correct an inverted suppress-ABTS capability check in the
    NVMe TMF path, fix an uninitialised status variable logged on LS abort
    send failure, and honour the nr_nvme_hw_queues module parameter when
    sizing NVMe queues at probe time.

Tyrel Datwyler (20):
  scsi: ibmvfc: initialize evt->tgt for NVMe FCP commands
  scsi: ibmvfc: fix trace logging for NVMe FCP commands
  scsi: ibmvfc: complete NVMe FCP requests on H_CLOSED send failure
  scsi: ibmvfc: defer NVMe local port registration out of atomic context
  scsi: ibmvfc: fix uninitialized _done dereference for TMF events on
    send failure
  scsi: ibmvfc: fix uninitialized shwqs in ibmvfc_purge_requests()
  scsi: ibmvfc: fix uninitialized status logged on LS abort send failure
  scsi: ibmvfc: fix inverted suppress-ABTS capability check in NVMe TMF
    path
  scsi: ibmvfc: fix infinite reset loop on NULL evt in implicit logout
    path
  scsi: ibmvfc: fix u16 overflow of max_cmds in ibmvfc_set_login_info()
  scsi: ibmvfc: fix UAF and hang in ibmvfc_cancel_all_mq() on send
    failure
  scsi: ibmvfc: fix data race on tgt->nvme_remote_port
  scsi: ibmvfc: make NVMe FCP abort callback asynchronous
  scsi: ibmvfc: fix UAF and stall in NVMe LS abort callback
  scsi: ibmvfc: unregister NVMe local port on adapter removal
  scsi: ibmvfc: fix NVMe local port leak on fabric link bounce
  scsi: ibmvfc: fix TOCTOU race in ibmvfc_nvme_create_queue() on adapter
    removal
  scsi: ibmvfc: fix NVMe sub-queue registration failure disabling SCSI
    multiqueue
  scsi: ibmvfc: fix concurrent SCSI and NVMe discover-targets race
    dropping targets
  scsi: ibmvfc: fix nr_nvme_hw_queues module parameter ignored for NVMe
    queue sizing

 drivers/scsi/ibmvscsi/ibmvfc-core.c |  79 +++++++++++++-----
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 123 +++++++++++++++-------------
 drivers/scsi/ibmvscsi/ibmvfc.h      |   2 +
 3 files changed, 127 insertions(+), 77 deletions(-)

-- 
2.55.0

