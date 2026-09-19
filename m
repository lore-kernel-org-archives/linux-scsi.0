Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DBC3BD24A;
	Sat, 19 Sep 2026 01:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789781606; cv=none; b=SbgrVLmVQufigNKl3FZak70wPDyzYcb9b6JyNKgiARWdHj0yzISmCWbSi4yWT85x7Mo9bi9mzz6nefMjFCUq2rNBkDtXBJZO3KOF0mT7zRAqiX4OkWyys0tVmkO0iqLvho3zvmMnjdiUbpEe2dVyMNNlq37NlAlMWoa2kiUB1HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789781606; c=relaxed/simple;
	bh=mRN9TrU9azaHLmQ2cdZwn9aXgtGsuF3tPTGiXkx8e5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pIr0lX8477VbI5c2incgGoVYx0G2cAy0bBSFvn23EWeeEzYDu3AVHC2M4Q5M+oNV9QEllJQRu68ggJGp+GprW1Lvz/ycjOuRKctgnzUG5t5G5owzmH/eLGmZtTV9ML8Ipyl0z7NZhV+x3W21L4T9pk9VC1aZjChy2XEEFd9OfVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M4Vs/ej2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M4Vs/ej2"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68J01UIi2662264;
	Sat, 19 Sep 2026 01:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=ebWLUfZn3oR42+/dEwVdHBPGu9D7
	h5C3rx/Aw/5kEU4=; b=M4Vs/ej2IQQ+XvYE/QPBwZ/UztaKm6y0nf2MnqtFrwpi
	WiZ7qDpkhvmqs6CcR50pARpTij1KdxuB2QW1e3BtWonTIenp+LSab3eRzPZsdcLc
	/kFikeGn4GZeh2vrM3K8XZnipPvw8scJpR8c8olPPshavaCRJyZ+h8LJE13nw5B9
	tTkQ5QmyIXA/I4IlLhsNf1bskO0vqB0Dvr4YNoXvBo8uyt7qgF5TMDSHY9B7CzKS
	ZEK2hn2vrIkx7tBYAQuPN68+qYWmVTxYVfvbZW6FPavHYf2Y0W2kwIly+RfX7dII
	umzIsEvrTSQQY5zgqI9KfF9iQA+6+sZAE8pN4ZYSNA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmx84b0j6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:13 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68J1TJi21629906;
	Sat, 19 Sep 2026 01:33:12 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gsgsar08b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 19 Sep 2026 01:33:12 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68J1XB5h31523544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 19 Sep 2026 01:33:11 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E8B5558051;
	Sat, 19 Sep 2026 01:33:10 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45E045805C;
	Sat, 19 Sep 2026 01:33:10 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.101.145])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 19 Sep 2026 01:33:10 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 00/20] scsi: ibmvfc: Fixes and cleanup for NVMe/FC support
Date: Fri, 18 Sep 2026 18:32:46 -0700
Message-ID: <20260919013306.2948028-1-tyreld@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX5QgUgPGtnjgF
 Mu2xAXcI84X2a5jr0RHl3NC9MX8/imCS2oDOvkwdzLhhab48mZCmgO6TPCSGSDZueLlFxWNBWLp
 h7w6bmlG5ZHrmiDS+rlfSp1v4T14O9+vTFKAUQ3RwYnZ/5MP2N1gy/Z4HZrzAIDadrDa7s5P0+v
 C6O2I/t+PVsthOXF/m+oLUSlvyT7mHK94YjbBjh6nHWaGC4Vhdvq7iXJ+aiJpzWsCVa9RmhI5Ig
 QLmVnLyjHVj7VrE97E/eAICDKZH+U3/z+EI+He/mrY1dKWRDrV1iuZtWqBzfW5pUM9ppNMlyDQV
 KS/HIVzdAMz0qpDNf3WvEd8u/fab0QoAUBu8sgUFcbm8nnOihyQFZWFCzXD40YpKydHwb63kQ6I
 yjIuZHInM1JXyv3JMSGEmT+9ImSpyevaoVcCUKCGOhskO+fS0eI5Ojj0hAkmICxkWMH8w6WnS9G
 Y3AUCkEedA2wDu06Ltw==
X-Proofpoint-ORIG-GUID: 5bL7f3oOgOlCGgdCqTHMEkpc0GUCZ07X
X-Proofpoint-GUID: 5bL7f3oOgOlCGgdCqTHMEkpc0GUCZ07X
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE5MDAxOCBTYWx0ZWRfX+XaHjyI//f2R
 A2hwkcarwWXjgB3SaSLorAn9r7hUXukTJLTKMccXLo757qjgV/ynLoBd9l9kBvuhnCVDcZsBDzL
 kqr/1eMI6rJZNypHvRJQ7+oHYTcLB+A=
X-Authority-Analysis: v=2.4 cv=cY9HPXDM c=1 sm=1 tr=0 ts=6aade659 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=O1L0M5XMSBBk1Q02lnEA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_07,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609190018

This series addresses a collection of bugs and corner cases introduced with
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

Changes since v1:
  - Reordered patches: the discover-targets race fix (previously patch 19)
    is now patch 20, and the nr_nvme_hw_queues fix (previously patch 20) is
    now patch 19, to better group related fixes.
  - Reworked the discover-targets fix (patch 20): replaced the pending_disc
    counter approach with fully serialised discovery — the SCSI MAD is sent
    first; on completion, if NVMe is active the job_step is chained to a new
    ibmvfc_discover_nvme_targets() function; the NVMe MAD is only sent after
    SCSI discovery has finished. This eliminates the counter corruption race
    on retry and the early ALLOC_TGTS transition race without requiring any
    shared state. The pending_disc bitfield is removed from ibmvfc_host.
  - Updated all Fixes: tags to reference the correct upstream commit IDs as
    merged into linux-next/master.
  - Addressed all issues raised by Sashiko review.

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
  scsi: ibmvfc: fix nr_nvme_hw_queues module parameter ignored for NVMe
    queue sizing
  scsi: ibmvfc: fix concurrent SCSI and NVMe discover-targets race
    dropping targets

 drivers/scsi/ibmvscsi/ibmvfc-core.c | 214 +++++++++++++++++++++-------
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c | 130 +++++++++--------
 drivers/scsi/ibmvscsi/ibmvfc.h      |   1 +
 3 files changed, 233 insertions(+), 112 deletions(-)

-- 
2.55.0

