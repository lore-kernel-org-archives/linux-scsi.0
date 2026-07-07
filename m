Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15AC27466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403911; cv=none; b=azZ9sZcwk0E5SM7QWCgz2gKEaaIB58Y20H9cGJf/wECUYR6DnZDaWKxptSUO7Kjzk3HM+bcKD+PFp0u1KKkJ6Cq3/r5ZLhsSUhWXamS8RyRdpgPbsTNotaQ3OinUAiwYZSOVMzic8xxt/rLRDQKS616ucB1kCcK0Oc9AW2aJgwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403911; c=relaxed/simple;
	bh=QK0yMQZE4Xa/Sq1NZsZNm2PzulOgzHdKMYgP2MsrzME=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aVIVEbcjarpf+JES0cPgC3f4AAtJAmd5nos3030mvsREpu7r4LjGoZQsy1sOv48YRsOUIWznwTask8pMumPP3NBzULxwwQqLCp6XHE1kfsxdhnH2hKrHa13E8tK168TxjvH9b1LEpuZm64BiCw0hJ5w/NLwu9hvQ9qhvi9oJaXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=VPySjMqA; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VPySjMqA"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748bun1656070;
	Mon, 6 Jul 2026 22:58:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=l
	LMnB3OjqQe5m5VcmPXHfGV6BA0M+DEq8uO2mVtainU=; b=VPySjMqASm23+7JC4
	reD4warJtQK2qIkb3awp6VPXy83iTqeIOLnWit1fM6DO6kNhxR6EHEuIaacsLGSo
	97TSRffaxO3ok+O8WujDGHnWLtKozmdboJYgY2ePS3LzHSNzc4K2xkMaU3V6/X+K
	qvOq3z2FXlqIQtrP4O1+1P7ta0E7cPTf0seeY0q5+0vTjoiAqxGi9kLHbbrJc5JO
	LgpkABfonFSETSVGEdRjW7eFLzPiBsRE4Fs7Z+cNRU61Ozk+ovudtb7V01ke8RcL
	uqsG3CmiWNyIuxACI596YqTbkNBsFQKt9NXkkoZVj2+PHaDJtj8UI/STN30NFsyN
	P0Vtw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:27 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:26 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 221053F7066;
	Mon,  6 Jul 2026 22:58:23 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 71/88] scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()
Date: Tue, 7 Jul 2026 11:24:18 +0530
Message-ID: <20260707055435.2680300-72-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: -cRWO0Hc999npFFtu37KjgowJ70luufj
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c9583 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=eDWT5XFMryaHyjyZKjIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: -cRWO0Hc999npFFtu37KjgowJ70luufj
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX3Csaob+Fm68S
 21etKV7euqOYEJetoZct7drSumzuaibOkcatYxP5gCf+vOEYaotAnX52Z4MOciXFBuLNn2SGlMi
 zzOXsJTG27MlffJ0st0artYe6z/MDVk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX5qSNvZFK6Nvt
 RCFVSP2iGbFdoYmyPZLfQANory/Z5E5yKzyNLek8QrmTj0rmcy55yW38h5ZKTY+6LgZCDKAxgdd
 eL93T8uofSJb6uPF7Q8ImlMZoCsxERIOJzqezVJrKJjA+gLql0fjaMojTl8mDNiA+1L80zoWPH6
 iNjgGaSWSYKjSBnfJ1uCsn0rU+MrhWM6fSEnMZ6epkP9BIbvDrCo3T1SlNTS+1rlRRP2TIXj1rJ
 d+fPTwY1yS44Eix+nokAOwjRd0AKd2ZQzKolLhnF/4+mrYGBJOodOqa03ftrxzRtX0K2NwGN6LX
 iUtylqDgajNQlwmv6pkUU4EvY6HoFsgTbyPlcYae0WSmSCvQoHQ+b06FaNz8bETa9nEMTUltoyj
 uoVm1XW1N2DgJSvvvcsla1mRLFp91Cv5VHvgka4K6e2n4gINfiyCpJUMZEHeMtKUOx46XOQD4gA
 r5yzhznI4A49CB0KLMg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla2x00_error_entry() reads ha->req_q_map[que] twice: once for the NULL
check and again when assigning it to req. The map slot is cleared by
qla25xx_free_req_que() (ha->req_q_map[que_id] = NULL under mq_lock)
during queue teardown, while the response-queue interrupt that drives
qla2x00_error_entry() is still registered (the IRQ is released later in
qla25xx_free_rsp_que()). If the slot is set to NULL between the two
reads, req becomes NULL and is dereferenced.

Read the slot once into req and NULL-check the local before use. mq_lock
is a mutex and cannot be taken from interrupt context, so the single
read plus local check is the appropriate fix for the reported NULL
dereference.

Fixes: a6fe35c052c4 ("[SCSI] qla2xxx: Avoid invalid request queue dereference for bad response packets.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 91a8344fea6c..829671937f92 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3927,10 +3927,12 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	    "iocb type %xh with error status %xh, handle %xh, rspq id %d\n",
 	    pkt->entry_type, pkt->entry_status, pkt->handle, rsp->id);
 
-	if (que >= ha->max_req_queues || !ha->req_q_map[que])
+	if (que >= ha->max_req_queues)
 		goto fatal;
 
 	req = ha->req_q_map[que];
+	if (!req)
+		goto fatal;
 
 	if (pkt->entry_status & RF_BUSY)
 		res = DID_BUS_BUSY << 16;
-- 
2.47.3

