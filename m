Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1352194A59
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720631496; cv=none; b=ofa4f9jk+73NvNFYzQ3yaYaYwmDhE55ZHb+fDq7aN+axvUjDVf5E9joP04iqFwLg1m48piTnHMnVyUsuEimVgb0VYqUoW2UTLD1CGhr0wt4wNKnd5k/LPYRuedhKxWqe7Q336OMIQUeVOQ+JGLjhe+LwyfJWhF3/xeEuiUkOu70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720631496; c=relaxed/simple;
	bh=+CO3BPz4W44DkSkNuf7qPS1f+sHH31xfXjZfxNKkgrg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TU+fm9hngf0xD07cDB6E+xXpwAnID4KsuDJEuoekqXK/rEgLHxljIMlVeER+KaCiwXxGDKaORVJuacEGqRH/ttb1lOqbKz8QSe852pACE8vNnxDmIyYO5MSj01V8xYL9zDH7AfpI6Kocl8WzoyM5G8yyR7Zm1MYshy16VQFfTY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=VaVNJO7T; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VaVNJO7T"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AGCxJe017206;
	Wed, 10 Jul 2024 10:11:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=t
	ynMF0/Rvrh4WYWs54dpTLovBZvzy17c8JcHjd0TgVg=; b=VaVNJO7TgonLpRmUv
	cC7w9gxmxE9KnHRTN+VANsGg88vwERa213VC+zSq/K8zFMbn+5O03o9tZ11Bkei7
	FRos+W4Liv5MJ6pnLlLTDWpPEfDdgdv+jKRDS9THH3+tVc1ebTdCEaVXJvoI8dFi
	dNV04RjyiWKv5F3wonft75STrpp8v5HjPpApRi2KF5VKMJWBWHc53sPItc6QODBO
	VCgpPJlMzLfqhPpYP27Vq7QSg5bL2g0xJF+wCtqomsnbr6+CTyM5OhjumyanIQW3
	D7T2RFBZlmw3WasQU1SVsW3HGFBHCS+IywRameFucuQf3fUoKVNNKEjLgBApJUOt
	CtAhA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 409wmd8awu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 10:11:32 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 10 Jul 2024 10:11:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 10:11:31 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 54A733F708F;
	Wed, 10 Jul 2024 10:11:29 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 07/11] qla2xxx: During vport delete send async logout explicitly
Date: Wed, 10 Jul 2024 22:40:53 +0530
Message-ID: <20240710171057.35066-8-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240710171057.35066-1-njavali@marvell.com>
References: <20240710171057.35066-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: yq_rLZEBIz2xKPzsZfg0cU02ey0nF_z7
X-Proofpoint-ORIG-GUID: yq_rLZEBIz2xKPzsZfg0cU02ey0nF_z7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_12,2024-07-10_01,2024-05-17_01

From: Manish Rangankar <mrangankar@marvell.com>

During vport delete, it is observed that during unload we hit a
crash because of stale entries in outstanding command array.
For all these stale I/O entries, eh_abort was issued and aborted
(fast_fail_io = 2009h) but I/Os could not complete while vport delete
is in process of deleting.

  BUG: kernel NULL pointer dereference, address: 000000000000001c
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  Workqueue: qla2xxx_wq qla_do_work [qla2xxx]
  RIP: 0010:dma_direct_unmap_sg+0x51/0x1e0
  RSP: 0018:ffffa1e1e150fc68 EFLAGS: 00010046
  RAX: 0000000000000000 RBX: 0000000000000021 RCX: 0000000000000001
  RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffff8ce208a7a0d0
  RBP: ffff8ce208a7a0d0 R08: 0000000000000000 R09: ffff8ce378aac9c8
  R10: ffff8ce378aac8a0 R11: ffffa1e1e150f9d8 R12: 0000000000000000
  R13: 0000000000000000 R14: ffff8ce378aac9c8 R15: 0000000000000000
  FS:  0000000000000000(0000) GS:ffff8d217f000000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000000000000001c CR3: 0000002089acc000 CR4: 0000000000350ee0
  Call Trace:
  <TASK>
  qla2xxx_qpair_sp_free_dma+0x417/0x4e0
  ? qla2xxx_qpair_sp_compl+0x10d/0x1a0
  ? qla2x00_status_entry+0x768/0x2830
  ? newidle_balance+0x2f0/0x430
  ? dequeue_entity+0x100/0x3c0
  ? qla24xx_process_response_queue+0x6a1/0x19e0
  ? __schedule+0x2d5/0x1140
  ? qla_do_work+0x47/0x60
  ? process_one_work+0x267/0x440
  ? process_one_work+0x440/0x440
  ? worker_thread+0x2d/0x3d0
  ? process_one_work+0x440/0x440
  ? kthread+0x156/0x180
  ? set_kthread_struct+0x50/0x50
  ? ret_from_fork+0x22/0x30
  </TASK>

Send out async logout explicitly for all the ports during
vport delete.

Cc: stable@vger.kernel.org
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index b67416951a5f..76703f2706b8 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -180,7 +180,7 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	list_for_each_entry(fcport, &vha->vp_fcports, list)
-		fcport->logout_on_delete = 0;
+		fcport->logout_on_delete = 1;
 
 	if (!vha->hw->flags.edif_enabled)
 		qla2x00_wait_for_sess_deletion(vha);
-- 
2.23.1

