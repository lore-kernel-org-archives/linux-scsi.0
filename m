Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7443CF039;
	Tue, 21 Apr 2026 13:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776777812; cv=none; b=jIzH0862m/m5SGHL6Kn/pj0MQh6dtS56Rb4RYIJ7LMgUZ2BJNbjS373AjWBuMF35hIN/TDYxvmUfrTOGHB8AO1MHRGBsxJfiKgN7r+BxgW3+I4MyycOpXCnyb0kZ8PbmmPQEG3WgQZXanuijb6KD5h7uS7Nznc8kK947VeFkkzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776777812; c=relaxed/simple;
	bh=tljg4FXB347O9sX99L+AjUS3gX5fnCNc0D3hYh9X4yA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WHs+/3+xQOkrWuIUsAlI2p+lu6Ht7IvMA4eNjkMyyboEfVmoUI+wRiPPcZqw9q5qAipnA1EGFH4HINZu9UdtjS8KCIzzBLv7A+cD4oVwDaQlmZl2h2KE9IbEUrBQaz3kB+mrcLHkhrJdZYSZ7hBn6BrQIg9JeYudqjSwpd4MdpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from altlinux.ipa.basealt.ru (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 7ABA823394;
	Tue, 21 Apr 2026 16:23:29 +0300 (MSK)
From: Vasiliy Kovalev <kovalev@altlinux.org>
To: stable@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	linux-scsi@vger.kernel.org,
	lvc-project@linuxtesting.org,
	kovalev@altlinux.org
Subject: [PATCH 5.10.y 2/2] scsi: qla2xxx: Fix crash when I/O abort times out
Date: Tue, 21 Apr 2026 16:23:27 +0300
Message-Id: <20260421132327.38389-3-kovalev@altlinux.org>
X-Mailer: git-send-email 2.33.8
In-Reply-To: <20260421132327.38389-1-kovalev@altlinux.org>
References: <20260421132327.38389-1-kovalev@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arun Easi <aeasi@marvell.com>

commit 68ad83188d782b2ecef2e41ac245d27e0710fe8e upstream.

While performing CPU hotplug, a crash with the following stack was seen:

Call Trace:
     qla24xx_process_response_queue+0x42a/0x970 [qla2xxx]
     qla2x00_start_nvme_mq+0x3a2/0x4b0 [qla2xxx]
     qla_nvme_post_cmd+0x166/0x240 [qla2xxx]
     nvme_fc_start_fcp_op.part.0+0x119/0x2e0 [nvme_fc]
     blk_mq_dispatch_rq_list+0x17b/0x610
     __blk_mq_sched_dispatch_requests+0xb0/0x140
     blk_mq_sched_dispatch_requests+0x30/0x60
     __blk_mq_run_hw_queue+0x35/0x90
     __blk_mq_delay_run_hw_queue+0x161/0x180
     blk_execute_rq+0xbe/0x160
     __nvme_submit_sync_cmd+0x16f/0x220 [nvme_core]
     nvmf_connect_admin_queue+0x11a/0x170 [nvme_fabrics]
     nvme_fc_create_association.cold+0x50/0x3dc [nvme_fc]
     nvme_fc_connect_ctrl_work+0x19/0x30 [nvme_fc]
     process_one_work+0x1e8/0x3c0

On abort timeout, completion was called without checking if the I/O was
already completed.

Verify that I/O and abort request are indeed outstanding before attempting
completion.

Fixes: 71c80b75ce8f ("scsi: qla2xxx: Do command completion on abort timeout")
Reported-by: Marco Patalano <mpatalan@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20221129092634.15347-1-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[ kovalev: bp to fix CVE-2022-50493 ]
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 79b9571f6350..4a057748ba17 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -101,6 +101,7 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	struct qla_qpair *qpair = sp->qpair;
 	u32 handle;
 	unsigned long flags;
+	int sp_found = 0, cmdsp_found = 0;
 
 	if (sp->cmd_sp)
 		ql_dbg(ql_dbg_async, sp->vha, 0x507c,
@@ -115,22 +116,27 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	for (handle = 1; handle < qpair->req->num_outstanding_cmds; handle++) {
 		if (sp->cmd_sp && (qpair->req->outstanding_cmds[handle] ==
-		    sp->cmd_sp))
+		    sp->cmd_sp)) {
 			qpair->req->outstanding_cmds[handle] = NULL;
+			cmdsp_found = 1;
+		}
 
 		/* removing the abort */
 		if (qpair->req->outstanding_cmds[handle] == sp) {
 			qpair->req->outstanding_cmds[handle] = NULL;
+			sp_found = 1;
 			break;
 		}
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-	if (sp->cmd_sp)
+	if (cmdsp_found && sp->cmd_sp)
 		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
 
-	abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
-	sp->done(sp, QLA_OS_TIMER_EXPIRED);
+	if (sp_found) {
+		abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
+		sp->done(sp, QLA_OS_TIMER_EXPIRED);
+	}
 }
 
 static void qla24xx_abort_sp_done(srb_t *sp, int res)
-- 
2.50.1

