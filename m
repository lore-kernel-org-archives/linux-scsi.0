Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72611442106
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 15:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427187; cv=none; b=USpZzmwQvQQJd/WHEAyYIjHcFe63QD7Mcj68mOkXULXYb1X2xxoNbQ5UOcwu9euRFDoASY7B0dZ8g06/wcoROyVhF7wznjW+YnrCGBWwSlACILe/4/2S8/j2Hr7DHkxwRTIi4gXdKmDAQEnL+f2epQCR7OQUd3VHWgVV4Nm97c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427187; c=relaxed/simple;
	bh=KXt88AEroHhW0td1aa21tq61GwFy1OpmA0m/bQT+yBw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jAE3Ip8olWNd508gd9OieHvrAD49AO7Fava+yVjrYIfc3hX3oUz0MGfz0TrFB0X5jp6Lb7a8lz/SC5Y6deviTpFmzgCK9zIowrCNb9qX7J+/cEhfImEspVtMRRe0dpJl/ZXnuIV3KWlvyTrgUothi/DtpPYR3iHvJnpMDAJeUnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=HXhrOvKC; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="HXhrOvKC"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWI9r1321633;
	Thu, 30 Jul 2026 08:59:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=i
	F8VPnzdKU66rIBVOM+3Gt8ufadF7Ot+2ykwXW9t1kU=; b=HXhrOvKClPaB3YRL9
	lI81paFl0OEAKHz1ta4dA+z2eKckS6RkMCxuRtBuhHu5tA8KZO4bl1MA7r4En0DR
	N2PtT7jT1YCHTppUINfUgw6jZ1MsH4R7Sh0N9K2mMk1l5+bUTct7xGMFUHwJFdpz
	peEIqHcn6XinQZ1TBJOD5xjYbLFOeVc12nwPeAtflqi9DX5NSUWYee7PWPVmnSI4
	mjSPfgyNuQ1Pw8oc6BVd6GuY7ErQki/K8WuWo83avBUOs3lQVesnGftM0T0D6tGD
	DkZZHdAF49Gt8q9iPY1VqB3dvBRxhf7T/viJrPtY3gmZxMRaE8YXrLDFMWmssWqe
	mLMwA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 08:59:42 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 08:59:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 08:59:41 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id CE5C23F704A;
	Thu, 30 Jul 2026 08:59:39 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 14/33] scsi: qla2xxx: Fix soft lockup polling continuation IOCB signature
Date: Thu, 30 Jul 2026 21:28:19 +0530
Message-ID: <20260730155838.2119230-15-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: mH828iykLHQYlPVVBfxH77DyiBm-7wzI
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXzHBYL+XlbVmb
 78GHkvMvchhyJK5jlTpH1d908sZKrrao0dQZMSEpfGR4OK5ae55gCH5JvcD6EinRZOeRwDLPkRV
 6CbwwSqTmaenfxZSTmkKx2LbuHcDsDI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX89d0GCVlt2HH
 FF9tGak5Q1bcPciCOu2BssAtsqpl+R6CzkJIDNOgq26yNOXNpeSaixkpCK+GYjn5iJPFstpetDh
 OMaBcZnXP7lK32H0OCYT1XkA5AduWAJkCIasDfpOpVVBsuGB7SC8N9ArELsKkcOsEe9MIFUUdm2
 L9uZkcDQ0c/6c9N/99J5OgHuaGwmha5cm+2oIfDnNqmYkx7Tbwt6Dgz/ML6/X1gQoc6KaTiIKPO
 veQaB03OlkSGKudBdOxz922w/FMhh99gLBv+txHFe4sZmxsYrkgx9Rh+WLRtdSMvhfhtqxjzq4i
 7nPt4069+iaBBvSr6YHPV05fLAuYKvwzjOrHvkZnfN8Dq/y/8WiMbA/YYLnJM8rzNRz6Uys4uxX
 pKwuyhiP7lpGfli9p627WK39kW2Jpk6bfh2Vjw/uA/9SmwXjatyKu0ylGv09amYLLScmbI7wGfY
 H6o/73oQGLvR7o82I7w==
X-Proofpoint-ORIG-GUID: mH828iykLHQYlPVVBfxH77DyiBm-7wzI
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b74ee cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=IrLq_TGKNdb9oMbP3NkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla27xx_copy_multiple_pkt() and qla27xx_copy_fpin_pkt() poll
rsp_q->ring_ptr->signature for RESPONSE_PROCESSED (0xDEADDEAD) to decide
whether the next continuation IOCB has arrived, spinning on cpu_relax()
without advancing the ring or decrementing the entry count while it has
not. response_t::signature lives at byte offset 60, but a continuation
IOCB (sts_cont_entry_t / struct sts_cont_entry_ext) carries raw FC frame
payload at that offset (data[56..59]). A received frame whose payload
bytes happen to equal 0xDEADDEAD is therefore misread as "not yet
arrived", and the loop spins forever in interrupt/DPC context, causing a
CPU soft lockup.

The poll is also unnecessary: callers of qla27xx_copy_multiple_pkt()
(PT_LS4_UNSOL and the NVMe purls path) already gate on
qla_chk_cont_iocb_avail(), which guarantees all entry_count IOCBs are
present before copying begins. The sibling helper
__qla_copy_purex_to_buffer() already drops the signature poll and relies
on the entry_type == STATUS_CONT_TYPE guard instead.

Remove the signature busy-wait from both helpers, keeping the entry_type
guard, and gate the FPIN path with qla_chk_cont_iocb_avail() so it defers
and re-processes on the next interrupt once all continuation IOCBs have
arrived, mirroring the ELS_AUTH_ELS and PT_LS4_UNSOL arms. With this the
signature field is never read on a continuation IOCB, eliminating the
payload-aliasing lockup.

Fixes: 9f2475fe7406 ("scsi: qla2xxx: SAN congestion management implementation")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6375c18fe392..d9019f2b059c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1002,14 +1002,6 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 
 	do {
 		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
-			if (rsp_q->ring_ptr->signature == RESPONSE_PROCESSED) {
-				ql_dbg(ql_dbg_async, vha, 0x5084,
-				       "Ran out of IOCBs, partial data 0x%x\n",
-				       buffer_copy_offset);
-				cpu_relax();
-				continue;
-			}
-
 			*pkt = rsp_q->ring_ptr;
 			data = ((sts_cont_entry_t *)*pkt)->data;
 			data_sz = qla_sts_cont_data_size(ha);
@@ -1299,14 +1291,6 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 
 	do {
 		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
-			if (rsp_q->ring_ptr->signature == RESPONSE_PROCESSED) {
-				ql_dbg(ql_dbg_async, vha, 0x5084,
-				       "Ran out of IOCBs, partial data 0x%x\n",
-				       buffer_copy_offset);
-				cpu_relax();
-				continue;
-			}
-
 			*pkt = rsp_q->ring_ptr;
 			data = ((sts_cont_entry_t *)*pkt)->data;
 			data_sz = qla_sts_cont_data_size(ha);
@@ -4272,9 +4256,24 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 					       "SCM not active for this port\n");
 					break;
 				}
+				if (qla_chk_cont_iocb_avail(vha, rsp,
+				    (response_t *)pkt, rsp_in)) {
+					/*
+					 * ring_ptr and ring_index were
+					 * pre-incremented above. Reset them
+					 * back to current. Wait for next
+					 * interrupt with all IOCBs to arrive
+					 * and re-process.
+					 */
+					qla_rsp_ring_rewind_to(rsp,
+					    (response_t *)pkt, cur_ring_index);
+
+					ql_dbg(ql_dbg_init, vha, 0x5095,
+					    "Defer processing FPIN...\n");
+					return;
+				}
 				pure_item = qla27xx_copy_fpin_pkt(vha,
 							  (void **)&pkt, &rsp);
-				__update_rsp_in(is_shadow_hba, rsp, rsp_in);
 				if (!pure_item)
 					break;
 				qla24xx_queue_purex_item(vha, pure_item,
-- 
2.47.3

