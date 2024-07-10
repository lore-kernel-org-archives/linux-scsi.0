Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430DF1922E3
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 17:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720631494; cv=none; b=H9gbCaBKzW3ITulQ3MFs9aPRDVZDxOacabGZFZC1C9KCi31qkuWi4lIKXU9rdsJ880jrAd0xe1tqD/L0KDia8Wu4biV051Z8fywFN4iqbTZ0VChkmsHrNiW5gShoQYUEeOpeFH89V1NqEY6Kn0rrPV694dL3d19wLv3HomAlqtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720631494; c=relaxed/simple;
	bh=5D72bmMU/tm3RjIGFi4kkDw330m1zTtTvWoIWnifanY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RY06pH+Xk0gnHpSljzhPyg670ANiZlH1fRwcRM2GgANLgD4ZRBbT4k/rRNGXZxd4VKhKz+gbaxO8jAmhzWlj5dyvLttK4sO+1rsOkM5RFof0SsmMNaK8Uu6uIlsDnMmHgFRDPCvUdi1KdtqlQMFqtIoUJy4ucmUe0teu5BubcCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=T9AhEegP; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="T9AhEegP"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46A9lB4m023801;
	Wed, 10 Jul 2024 10:11:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=I
	4rxSN2fPWlz6Wa6bc1rmpUayKopQjDGqey0zoGBm5M=; b=T9AhEegP5AEwwNoDS
	nyuZTVua3FwnI8/yV9l1CawGxzXYvEBJ7jC+LNQ4mvuGl1BOeLqVIpGrdKlHdm7U
	ff5rYHvrIBE3zekLl7OvH6aNZ5l5mNj60NO3w0HCrahJfKAw444YQurjqGId0Fh3
	lyST6pr0ewqfr8G/rurLIyzVt+AT0BIb5lmPpyPH3BHUqp3DCQxEPm2jmMJ+SMmz
	0DF5/AyoJZ2yErTWdlK7wQ8V7sXOSZTLbslePnTMeuNm6jucatjg7Bw0+S8fLm1p
	Tlj97IvPK50CwtZ9TKXUaBCMgHHLNIDrGQi2LvRdTfkESbFj0kjrlxAJZX1bZAKZ
	mP//w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 409qyf21nv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 10:11:30 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 10 Jul 2024 10:11:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 10:11:29 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 8AB343F708F;
	Wed, 10 Jul 2024 10:11:26 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 06/11] qla2xxx: complete command early within lock
Date: Wed, 10 Jul 2024 22:40:52 +0530
Message-ID: <20240710171057.35066-7-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: Ca4loensHZ_4aIkaAzYgOd1Orvf5crMg
X-Proofpoint-GUID: Ca4loensHZ_4aIkaAzYgOd1Orvf5crMg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_12,2024-07-10_01,2024-05-17_01

From: Shreyas Deodhar <sdeodhar@marvell.com>

A crash was observed while performing NPIV and FW reset,

 BUG: kernel NULL pointer dereference, address: 000000000000001c
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 1 PREEMPT_RT SMP NOPTI
 RIP: 0010:dma_direct_unmap_sg+0x51/0x1e0
 RSP: 0018:ffffc90026f47b88 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000021 RCX: 0000000000000002
 RDX: 0000000000000021 RSI: 0000000000000000 RDI: ffff8881041130d0
 RBP: ffff8881041130d0 R08: 0000000000000000 R09: 0000000000000034
 R10: ffffc90026f47c48 R11: 0000000000000031 R12: 0000000000000000
 R13: 0000000000000000 R14: ffff8881565e4a20 R15: 0000000000000000
 FS: 00007f4c69ed3d00(0000) GS:ffff889faac80000(0000) knlGS:0000000000000000
 CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000000000000001c CR3: 0000000288a50002 CR4: 00000000007706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
 <TASK>
 ? __die_body+0x1a/0x60
 ? page_fault_oops+0x16f/0x4a0
 ? do_user_addr_fault+0x174/0x7f0
 ? exc_page_fault+0x69/0x1a0
 ? asm_exc_page_fault+0x22/0x30
 ? dma_direct_unmap_sg+0x51/0x1e0
 ? preempt_count_sub+0x96/0xe0
 qla2xxx_qpair_sp_free_dma+0x29f/0x3b0 [qla2xxx]
 qla2xxx_qpair_sp_compl+0x60/0x80 [qla2xxx]
 __qla2x00_abort_all_cmds+0xa2/0x450 [qla2xxx]

The command completion was done early while aborting the
commands in driver unload path but outside lock to
avoid the WARN_ON condition of performing dma_free_attr
within the lock. However this caused race condition
while command completion via multiple paths causing system
crash.

Hence complete the command early in unload path
but within the lock to avoid race condition.

Fixes: 0367076b0817 ("scsi: qla2xxx: Perform lockless command completion in abort path")
Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 70f43eab3f01..e4056cddb727 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1875,14 +1875,9 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 		sp = req->outstanding_cmds[cnt];
 		if (sp) {
-			/*
-			 * perform lockless completion during driver unload
-			 */
 			if (qla2x00_chip_is_down(vha)) {
 				req->outstanding_cmds[cnt] = NULL;
-				spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
 				sp->done(sp, res);
-				spin_lock_irqsave(qp->qp_lock_ptr, flags);
 				continue;
 			}
 
-- 
2.23.1

