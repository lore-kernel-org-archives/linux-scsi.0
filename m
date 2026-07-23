Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F0B35957;
	Thu, 23 Jul 2026 00:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764929; cv=none; b=iMOWZWQuYQcLNdWvNlPAco1dlZtC62muq78kYiPmEn7U6KicfcP7wE03M3oh4t/4J8FuBDt5OwnLZVnqgXNAftGLYBfbUxrGe3G/sX+8JQtJ7w/g4uJqTv7oZYc9E/ehjbBqGzT6pdg5xh2UA4YXVzrN+T1c0QqSbZ1AdR+xzzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764929; c=relaxed/simple;
	bh=l/PPm39S1o5+s9UsWhNCMPbNjQwunYMP/IYpA7RTmb4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LVAJ7DnZ7jVnuWCm8a+SUIMFjThTT5K/q+BGm8qm0hgJL83VDugi0zLg0iZzFzX48m8T/j22zLNPE1Y7aqpTNjFg/9NqbCB2N7W8Slw7QLYr3RjJkWvHcTo3s2GKB3w18yGV/Hv7xzbTQN7d2NFsThyCAg/rud0LZELEPuBbbi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fqhxl3/t; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fqhxl3/t"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBvST633586;
	Thu, 23 Jul 2026 00:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=cEHb1pCK0zwOqr0hC6s7iNU8No4AXe7uVRApBUHBY
	Zs=; b=fqhxl3/tHBd5M2LMUUYbAxnq1aYU8iK31z1OTxyabGFib+k4UkgOJ9Teg
	awivaR+/qdTzk+1KEqE9OCkEQUKW/w95r6ibSDwlIzV5K+MCMC/G8nSM0/QiAhvF
	TErux1I5XCoVBy/twh1ZWd2//VmIViu+ukJ41tJCPt3DbMQ0dM/KFumYEEq2IWdo
	S8L/Z0rQ3L+1D6Cznht1vHW9rbU0xl4aMI+j0DfLUOIKxqPL556QaXnqE1Xhsahi
	orhlGEZtzFXfo5+16fnxNgX6aJFAuIuoTEcu8xVmMIkE27jD0RHz0ge0DNIeavTA
	BD/TRHn3ug6b6kThdo27kOtWIq84g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg77kce5m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:01:56 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNndVE028983;
	Thu, 23 Jul 2026 00:01:55 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgpgyhfq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:01:55 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N01rmE29033134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:01:53 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60B885806A;
	Thu, 23 Jul 2026 00:01:53 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEFA758056;
	Thu, 23 Jul 2026 00:01:52 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:01:52 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 00/33] ibmvfc: NVMe/FC support over IBM Virtual FC
Date: Wed, 22 Jul 2026 17:01:16 -0700
Message-ID: <20260723000149.969416-1-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HJXz0Itv c=1 sm=1 tr=0 ts=6a6159f4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=tRCg95uVR1cYIH-zKwoA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfXyUjvNal32jbM
 RUFU4JiAVUN0i2t3wNcphzwKX0eLwUO9YBdYevGeayjRqu6Mq2WReYDYm6e5uWQ+3BEd9wwTjfx
 5krb1P0pfrGS2GSx9RX/I4J+EPspbXeNNa6u6+lN2iJ7tv5cY/KyqSnFBVHl1MatnuiQXT9+gSq
 L8Gjen63C6xcmcLmz0XWJfkL5yLlvTERqbPItUvdvzeEWiCQB0fgO329qpIpgc01664+BV3/3Ib
 BsVXr+c2iFHLu1tS3BYj33FI8Sw7TcXdWpB8L7yEJ6XxrUF5B+LXelamKwgww1Topol5CKTgj76
 7EFYdrVuX0RTkhB3rzxfjt56U8KLONnm70k3NBriD1T/YJ2vJlHKdjb1ETvG0m4c9nG49fIhn8h
 OAb3Ulc6ST9SL7dBqwgny9K31OPekZzVEa5YcSui7N84lFyPBbR4NVSaRk4pGp//rwjc7gdoUKH
 pkKPaBUL7CKYNZkgAwA==
X-Proofpoint-ORIG-GUID: NqxlExpqI0U6u8Iek6u2asljL9brODZ2
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfXyE1rLIHU3y1/
 LBVB6S6wek0duikBplxd3YLcd29l44Ae6lKVuG/bfD149uFFmUib5S/yqzId/wbQKqeAIMH/MNp
 evziz6TsRbAWTVdJgjiIXE5Yz989TPg=
X-Proofpoint-GUID: NqxlExpqI0U6u8Iek6u2asljL9brODZ2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607220234

This series adds NVMe/FC initiator support to the ibmvfc driver, enabling
IBM POWER virtual machines to discover and use NVMe namespaces presented by
the IBM Virtual I/O Server (VIOS) over the existing NPIV transport.

The ibmvfc driver communicates with the VIOS via a CRQ-based protocol. With
this series the VIOS can present both SCSI/FCP and NVMe/FC targets through
parallel sets of protocol-specific MAD opcodes, fabric login flows, and
sub-CRQ channels.

The series is organized into three phases:

Patches 1-5: Bug fixes and preparatory refactoring
  Four pre-existing bugs are fixed before any NVMe/FC work is introduced:
  a deadlock in the MAD send-failure path (locked done variant called with
  host_lock already held), a race during driver teardown where
  rport_add_work_q work items can outlive the FC host, a NULL event
  dereference in ibmvfc_tgt_implicit_logout_and_del, and an allocator
  mismatch where mempool-allocated ibmvfc_target structs are freed via kfree
  rather than mempool_free. Patch 5 moves the target list and count from
  struct ibmvfc_host into struct ibmvfc_channels as the structural
  prerequisite for independent per-protocol target tracking.

Patches 6-27: Protocol interface and driver scaffolding
  Patch 6 extends ibmvfc.h with NVMe/FC protocol definitions: MAD opcodes,
  capability flags, the v3 command layout, the fabric login MAD, async
  sub-CRQ event format, and updated channel enquiry/setup fields. Patch 7
  splits ibmvfc.c into ibmvfc-core.c and the new ibmvfc-nvme.c/h, registers
  an nvme_fc_port_template with stub callbacks, and adds NVMe module
  parameters. The remaining patches build the NVMe/FC plumbing: NVMe
  channel-group initialization, sub-CRQ lifecycle management, protocol-
  specific fabric login flow, target discovery, PLOGI/PRLI/query-target,
  implicit logout, move-login, protocol-driven target allocation, NVMe
  target deletion, state machine updates, and local/remote port registration
  with the NVMe-FC transport layer.

Patches 28-33: NVMe-FC LLDD callbacks and I/O path
  Implements the full nvme_fc_port_template: create_queue/delete_queue map
  NVMe controller queues to sub-CRQ handles; ls_req submits FC-LS frames via
  the ibmvfc passthru MAD; fcp_io builds and submits NVMe FCP commands via
  the NVMe sub-CRQ and completes them via nvme_fc_rcv_fcp_rsp(); ls_abort
  and fcp_abort cancel outstanding requests via NVMF cancel MADs. Patch 33
  extends the purge path to fail outstanding NVMe FCP and LS requests during
  host reset and link-down events.

Changes since v1 (29 patches -> 33 patches)
--------------------------------------------
  - Added four bug-fix patches (1-4) ahead of any NVMe/FC changes to ensure
    the series is bisect-safe. These address issues identified in the v1
    review: the mempool_free/kfree mismatch (previously flagged on multiple
    patches), the rport_add_work_q teardown race, the NULL event dereference
    in the implicit logout and delete path, and the MAD send-failure deadlock
    due to the locked done handler being invoked with host_lock already held.
  - Fixed the NULL pointer dereference in ibmvfc_nvme_unregister() and
    ibmvfc_nvme_unregister_remoteport() by adding proper NULL guards before
    dereferencing the local and remote port pointers (v1 patch 19/20).
  - Fixed self-deadlock in ibmvfc_send_event() error path for MAD commands:
    on send failure the driver now falls back to the unlocked evt->_done
    handler instead of the locked variant (patch 1 in v2).
  - Fixed NVMe targets being entirely ignored by the TGT_DEL and TGT_DEL_FAILED
    work-loop actions; both the SCSI and NVMe target lists are now walked in
    the relevant state machine helpers (v1 patches 18/21).
  - Fixed the purge path omission: NVMe FCP and LS requests are now properly
    failed during host reset (patch 33, expanded from v1 patch 29 which only
    handled the transport reset case).

Tyrel Datwyler (33):
  ibmvfc: don't call locked done variant for MADs on send failure
  ibmvfc: flush rport_add_work_q during driver teardown
  ibmvfc: check for NULL evt in implicit LOGO and target delete path
  ibmvfc: free ibmvfc_target allocations with mempool_free
  ibmvfc: move target list from host to protocol specific channel groups
  ibmvfc: add NVMe/FC protocol interface definitions
  ibmvfc: split NVMe support into separate source file and add transport stubs
  ibmvfc: initialize NVMe channel configuration during probe
  ibmvfc: alloc/dealloc sub-queues for nvme channels
  ibmvfc: add logic for protocol specific fabric login
  ibmvfc: add wrapper to get vhost associated with a channel group
  ibmvfc: add helper for creating protocol specific discover target events
  ibmvfc: add helper to check NVMe/FC support with active queues
  ibmvfc: allocate and free NVMe channel group discovery buffers
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
  ibmvfc: extend ibmvfc_debug visibility to ibmvfc-nvme.c
  ibmvfc: declare global function definitions
  ibmvfc: implement LLDD callbacks for mapping nvme-fc queues
  ibmvfc: implement nvme-fc LS submission transport callback
  ibmvfc: implement nvme-fc IO command submission callback
  ibmvfc: implement nvme-fc LS abort handling callback
  ibmvfc: implement nvme-fc FCP abort callback
  ibmvfc: fail nvme-fc fcp-io and ls requests during host reset

 drivers/scsi/ibmvscsi/Makefile                     |   2 +
 drivers/scsi/ibmvscsi/{ibmvfc.c => ibmvfc-core.c}  | ...
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c                | ...
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h                | ...
 drivers/scsi/ibmvscsi/ibmvfc.h                     | ...
 5 files changed

-- 
2.55.0
