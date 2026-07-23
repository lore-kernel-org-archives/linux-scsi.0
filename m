Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C5A3128A3;
	Thu, 23 Jul 2026 04:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784780518; cv=none; b=GP3ePTuCSkAbRkPcSz8NCwnM9Xmf0Mqx6HUgrsC504bPG7JDc2alJKV29XZAMwap+AvU+HhwBxpCizK6cyGViWaLdGMCd6vIpYVEtOjyrOuhJiEqPXPq29yJvp+4lloS9TCrxw9QNiZdGYKPlzQS29uMVq2328Mt3nhYChC8m0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784780518; c=relaxed/simple;
	bh=X8aoDR71PG2kWt7CZNmFJYHGrmEwi4AcZfUVmYa/+Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iVrjVGSxg3cZFkMJwqlzFvTpMrZpT+NZk4cxks26TiOgT1+StDK0GEmZqTKPLm21bUfd/Qp/cI+Bqgq0FQIeeD9JCa7w68rAp/aTc36ZvQ+0chwagY5kILSMoB4VDm/Mg4E7wIOa933XOZEtRxP7iA0GKRRsespflkIz69tqYKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4h5Hww0m9TzYQtqZ;
	Thu, 23 Jul 2026 12:20:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 3FE564058D;
	Thu, 23 Jul 2026 12:21:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgCntnK8lmFqSTnpCA--.7917S4;
	Thu, 23 Jul 2026 12:21:18 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org
Cc: linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	yukuai@fygo.io,
	wozizhi@huawei.com,
	zhousiqi5@huawei.com
Subject: [PATCH] scsi: core: do not block on tag allocation in scsi_eh_lock_door()
Date: Thu, 23 Jul 2026 12:12:38 +0800
Message-ID: <20260723041238.1584632-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCntnK8lmFqSTnpCA--.7917S4
X-Coremail-Antispam: 1UD129KBjvJXoW7AFWDurWktr4UJFW3WrWkXrb_yoW5Jr48pr
	WDWa1qk398WF1093Wqq3sxuFyYvw47C347tF4xW34fAFZ8JFy0vFnrta4jqFWxuF97tF4D
	Jr1qqFyDWw1UX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I
	0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWU
	tVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcV
	CY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAF
	wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvj
	xUF1v3UUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/

From: Zizhi Wo <wozizhi@huawei.com>

scsi_eh_lock_door() is called from scsi_restart_operations() while the host
is still in the SHOST_RECOVERY state, i.e. before the host is switched back
to SHOST_RUNNING and scsi_run_host_queues() restarts the queues. It
allocates a request via scsi_alloc_request() with no flags, so
blk_mq_get_tag() may block waiting for a free sched tag when all tags are
already in use.

Those tags can be held by commands that were just requeued by
scsi_eh_flush_done_q() during error handling. Such commands cannot be
dispatched until the host leaves SHOST_RECOVERY and scsi_run_host_queues()
is called - which only happens *after* scsi_eh_lock_door() returns.

This forms a circular dependency:

  - scsi_eh_lock_door(), running in the SCSI error handler thread, waits
    for a sched tag held by a requeued command;
  - the requeued command cannot complete and release its sched tag until
    the error handler thread leaves scsi_restart_operations() and restart
    the queues.

For devices with a single driver tag (e.g. USB storage) it is a guaranteed
deadlock and I/O that can never be submitted. This problem has also been
reproduced in our environment.

Locking the door is a best-effort operation, and scsi_eh_lock_door()
already returns silently when the request allocation fails. Pass
BLK_MQ_REQ_NOWAIT to scsi_alloc_request() so the allocation fails instead
of blocking when no tag is available. This breaks the circular dependency
and allows the error handler to finish restarting the queues, after which
the pending commands are dispatched normally.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..3d42fe7701b7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2139,11 +2139,11 @@ static enum rq_end_io_ret eh_lock_door_done(struct request *req,
 static void scsi_eh_lock_door(struct scsi_device *sdev)
 {
 	struct scsi_cmnd *scmd;
 	struct request *req;
 
-	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, 0);
+	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN, BLK_MQ_REQ_NOWAIT);
 	if (IS_ERR(req))
 		return;
 	scmd = blk_mq_rq_to_pdu(req);
 
 	scmd->cmnd[0] = ALLOW_MEDIUM_REMOVAL;
-- 
2.52.0

