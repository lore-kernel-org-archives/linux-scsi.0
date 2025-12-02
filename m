Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582922FCC16
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 05:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654381; cv=none; b=nB7liKYtzh6bLVmpu87LFnj7B4iLmxeOvQ5PUlrMMac5eRgvt+oG9s7po+34PktSyr2N48ZkNM2y3S9YXsu0CaTwjdRkXVqirXT7dHkX/b+R3ClojkKy3QpxBYR096HnSxxDO1sHksuY6hVDi7BP/gP6Rxyrj2YSeBKvkHya57w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654381; c=relaxed/simple;
	bh=RnWZ4ya9VzEEkkFeO69Wvc3AcDJ2ty3DCFq0iLhr+Zk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JYtjgEgyrjIuae52QOoGy53+usnVn8bTchKtBC9cF3nbtEn/a0EkbPSccKc9zP4JNP2yGCM5czdZwK+/I10tFdXGW3Bzo5xjEyG96RAaebrTFuGbbkXu19UC2XMzDrqWqwN65oLltQNEpqPMXvc1kCsDPi1RvgF4C0EaEbwP2RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DleBRQNo; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DleBRQNo"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1H0nsq4147931;
	Mon, 1 Dec 2025 21:46:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=v
	XH1FPq4s/cVS00pTUdJznkXy7XMm/ruCJexMo3T+CU=; b=DleBRQNoRCZp6ACSz
	bOKFSFz1M9+hW2i+d127r0SnR716WmT8b++/YI49jX4Mc6k10kEquvQVm51xFZnm
	fHL/hwTKeBksD1aR51PIB8qxPBnKbLmrRc+diUjT6da2GULcTPch8emwV4lKy0gM
	OCSj/CUZtIwzp/3UFOsN84p/jGJYf+xQ954ZOFH//n6lv/S8bg0kxroUrUn/dw7C
	YPmAzLBIZ1pM+oe4HPsuIZtIyMBMmsQcKELWFRtUK7FwHJKHqGw6tz5BYuBIo3Rq
	ZR3SPokDn/yFXQOfsto6oWBr1gsubwHnrlVWUUTcYRdZcWu5gE0B4KYIcvXKBSbT
	K6X1Q==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ar17nn81s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 21:46:15 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 21:46:28 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 21:46:28 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id A4D7C5B6975;
	Mon,  1 Dec 2025 21:46:12 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 09/12] qla2xxx: validate sp before freeing associated memory
Date: Tue, 2 Dec 2025 11:14:41 +0530
Message-ID: <20251202054444.1711778-10-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251202054444.1711778-1-njavali@marvell.com>
References: <20251202054444.1711778-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: W9c9MrWuyCwu7o8Hkr5QZT1KGYicROcg
X-Authority-Analysis: v=2.4 cv=R+MO2NRX c=1 sm=1 tr=0 ts=692e7d27 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=6UGMoZGkOhPUpegkkFQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: W9c9MrWuyCwu7o8Hkr5QZT1KGYicROcg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0MyBTYWx0ZWRfXy7UhtPirPToT
 QfvbMYtb9tKLaP+N7/H1IqmSv4rjf3rXPfChLKVQGgz0CCvG/gndgzT4NG1a0sD8gJbhor3WZK9
 11kxAYjFOU6YoF2xYJssTSPNYl+MaStuzOgcthC6BFtvOz0155jW5upVSdf++s7cX+eJbwtZqMw
 QTEtUpmzZwKVsn9W9S0GVRMSJWp5MBMYOgt1iGRQf+wys4hzaQBR1dCfGvPhCN0mYh6k5+pRfRZ
 8aV1zG0PWgtwT/0EOLd97RVopNEuzDwAPVlhBlBljSVnJiY5EoReNFFJoJplY7OoGa9ys5vzTRk
 xGx3ZzrIElKEcuVPJBK4YGZWZfcHZuQNLZy2bRk/A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

System crash with the following signature
[154563.214890] nvme nvme2: NVME-FC{1}: controller connect complete
[154564.169363] qla2xxx [0000:b0:00.1]-3002:2: nvme: Sched: Set ZIO exchange threshold to 3.
[154564.169405] qla2xxx [0000:b0:00.1]-ffffff:2: SET ZIO Activity exchange threshold to 5.
[154565.539974] qla2xxx [0000:b0:00.1]-5013:2: RSCN database changed – 0078 0080 0000.
[154565.545744] qla2xxx [0000:b0:00.1]-5013:2: RSCN database changed – 0078 00a0 0000.
[154565.545857] qla2xxx [0000:b0:00.1]-11a2:2: FEC=enabled (data rate).
[154565.552760] qla2xxx [0000:b0:00.1]-11a2:2: FEC=enabled (data rate).
[154565.553079] BUG: kernel NULL pointer dereference, address: 00000000000000f8
[154565.553080] #PF: supervisor read access in kernel mode
[154565.553082] #PF: error_code(0x0000) - not-present page
[154565.553084] PGD 80000010488ab067 P4D 80000010488ab067 PUD 104978a067 PMD 0
[154565.553089] Oops: 0000 1 PREEMPT SMP PTI
[154565.553092] CPU: 10 PID: 858 Comm: qla2xxx_2_dpc Kdump: loaded Tainted: G           OE     -------  ---  5.14.0-503.11.1.el9_5.x86_64 #1
[154565.553096] Hardware name: HPE Synergy 660 Gen10/Synergy 660 Gen10 Compute Module, BIOS I43 09/30/2024
[154565.553097] RIP: 0010:qla_fab_async_scan.part.0+0x40b/0x870 [qla2xxx]
[154565.553141] Code: 00 00 e8 58 a3 ec d4 49 89 e9 ba 12 20 00 00 4c 89 e6 49 c7 c0 00 ee a8 c0 48 c7 c1 66 c0 a9 c0 bf 00 80 00 10 e8 15 69 00 00 <4c> 8b 8d f8 00 00 00 4d 85 c9 74 35 49 8b 84 24 00 19 00 00 48 8b
[154565.553143] RSP: 0018:ffffb4dbc8aebdd0 EFLAGS: 00010286
[154565.553145] RAX: 0000000000000000 RBX: ffff8ec2cf0908d0 RCX: 0000000000000002
[154565.553147] RDX: 0000000000000000 RSI: ffffffffc0a9c896 RDI: ffffb4dbc8aebd47
[154565.553148] RBP: 0000000000000000 R08: ffffb4dbc8aebd45 R09: 0000000000ffff0a
[154565.553150] R10: 0000000000000000 R11: 000000000000000f R12: ffff8ec2cf0908d0
[154565.553151] R13: ffff8ec2cf090900 R14: 0000000000000102 R15: ffff8ec2cf084000
[154565.553152] FS:  0000000000000000(0000) GS:ffff8ed27f800000(0000) knlGS:0000000000000000
[154565.553154] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[154565.553155] CR2: 00000000000000f8 CR3: 000000113ae0a005 CR4: 00000000007706f0
[154565.553157] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[154565.553158] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[154565.553159] PKRU: 55555554
[154565.553160] Call Trace:
[154565.553162]  <TASK>
[154565.553165]  ? show_trace_log_lvl+0x1c4/0x2df
[154565.553172]  ? show_trace_log_lvl+0x1c4/0x2df
[154565.553177]  ? qla_fab_async_scan.part.0+0x40b/0x870 [qla2xxx]
[154565.553215]  ? __die_body.cold+0x8/0xd
[154565.553218]  ? page_fault_oops+0x134/0x170
[154565.553223]  ? snprintf+0x49/0x70
[154565.553229]  ? exc_page_fault+0x62/0x150
[154565.553238]  ? asm_exc_page_fault+0x22/0x30

Check for sp being non NULL before freeing any associated memory

Fixes: a4239945b8ad ("scsi: qla2xxx: Add switch command to simplify fabric discovery")
Cc: stable@vger.kernel.org
Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index e5ebb9c5b650..880cd73feaca 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3698,23 +3698,25 @@ int qla_fab_async_scan(scsi_qla_host_t *vha, srb_t *sp)
 	return rval;
 
 done_free_sp:
-	if (sp->u.iocb_cmd.u.ctarg.req) {
-		dma_free_coherent(&vha->hw->pdev->dev,
-		    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
-		    sp->u.iocb_cmd.u.ctarg.req,
-		    sp->u.iocb_cmd.u.ctarg.req_dma);
-		sp->u.iocb_cmd.u.ctarg.req = NULL;
-	}
-	if (sp->u.iocb_cmd.u.ctarg.rsp) {
-		dma_free_coherent(&vha->hw->pdev->dev,
-		    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
-		    sp->u.iocb_cmd.u.ctarg.rsp,
-		    sp->u.iocb_cmd.u.ctarg.rsp_dma);
-		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
-	}
+	if (sp) {
+		if (sp->u.iocb_cmd.u.ctarg.req) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+			    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
+			    sp->u.iocb_cmd.u.ctarg.req,
+			    sp->u.iocb_cmd.u.ctarg.req_dma);
+			sp->u.iocb_cmd.u.ctarg.req = NULL;
+		}
+		if (sp->u.iocb_cmd.u.ctarg.rsp) {
+			dma_free_coherent(&vha->hw->pdev->dev,
+			    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
+			    sp->u.iocb_cmd.u.ctarg.rsp,
+			    sp->u.iocb_cmd.u.ctarg.rsp_dma);
+			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
+		}
 
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
+	}
 
 	spin_lock_irqsave(&vha->work_lock, flags);
 	vha->scan.scan_flags &= ~SF_SCANNING;
-- 
2.23.1

