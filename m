Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0B53128CC
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361806; cv=none; b=qmIdCvt4TZLPQu5sUIKM00lNn63qu4KZ1aLgex1JIqq5tOw6tFjVuxy+Bw946UbApZoxKVLMQfWfwqxz6fAeH+nI9IKYzu706doxYHfG7F7Mn5+LwBxh5cmP4MJLHx6tp0F416F7fy36YA7n8wGHyA84CNug/EqllhRufbs+1Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361806; c=relaxed/simple;
	bh=5+Yt5rUlyUEHztAUso6Wy0cKr3WygtrYm3pdLg/Cjcs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rCs3s3hyQGMXgpvAE+5ZUybwVZsExLjI63k4oOp3JQtpqxwcHSst8CPyjRzSBZRT1cgwxyRfu9hnw1emh8WYa5mEFLgZhwJJ8fOx0RGGDsOEOuRaCGUWMy5SbK6cYPFuvbLxObNsiK1mMl2HEl9+jm0Qw4vl68nujcAOiz9y/RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DTOZSVvE; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DTOZSVvE"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4aCmo164110;
	Wed, 10 Dec 2025 02:16:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=8
	f+0Qs4vVXYzMyOv9VXVaMTxhb7aFWUpBSCmxzqQbOg=; b=DTOZSVvEOaxfNwlDk
	J6dfrjMrOaj9j6jqirXeVFNn0cjyqwwqPgU9xv5qXrrIbBGxV+ROXdd7fNMzva+I
	mUEjYIWsArNu9YUgoFVh2p5iiBsEDj15YWkwMmpBWM499zruVduz/Ev+NVhYp/hE
	RHJMd2R39KA5S4mGYHkjC6E/1gSiu14v+1FfvB51/H104r9Hm4KWYMFl+/Z/oXOc
	1x761c89XWQ+abxYqfgEt7c/24VTsviFhPxrA2+QwuqBjKF+DN2kLJHjD1BnlK1Y
	d9psLIiVaswI7sM5HrL18ojh/B2TvrCgrwo0Hfd50Ma35AqFDTBBKntg//pxGWac
	FDQJQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4axwgd168y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:43 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:16:55 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:16:55 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id E74563F709D;
	Wed, 10 Dec 2025 02:16:39 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 09/12] qla2xxx: validate sp before freeing associated memory
Date: Wed, 10 Dec 2025 15:46:01 +0530
Message-ID: <20251210101604.431868-10-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251210101604.431868-1-njavali@marvell.com>
References: <20251210101604.431868-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: A1lUWg4txwXpCFWxKixSl6UbzUpNVwA4
X-Proofpoint-GUID: A1lUWg4txwXpCFWxKixSl6UbzUpNVwA4
X-Authority-Analysis: v=2.4 cv=OIcqHCaB c=1 sm=1 tr=0 ts=6939488b cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=6UGMoZGkOhPUpegkkFQA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfX+O2txTw96iEy
 +Y09vUO+Xlk2jVJ1OEbiSMSKwmGwV5+9+WHafPjCqsdOizFCXl+RqtnKCJkjETPLvddb+9Dkcgf
 FiCgze+y2FXAhqBOZ8LiMpnIdediOmKvvCmV+6H5guoFkKHACB/7Z3AuejR3oSJ1IXM9EaAGgLi
 Pa7v2vVoYcBXL+2mJULOzw9fEYu6R9+8dK2REyQTbv9bjEv4yGUjp7S0cqBi4PpKkLTXKY4Oh75
 RrwqmDtvxZslMo2epUXkO16aipwFKYfQng5rrJHN/ApyZLMp3ul/qRu2ftE+ElGE60mHAe+voOT
 4pL9eNlAALxogTYmz9e+hlu/BLTaLcMFlUjg0dqQFKvs7sc1aDnmcxIAGpXp5TVeEaTmNbPIt8j
 7/GKSkZOkhi6azQAsExfBVKMDPKI6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

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
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
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

