From: giridhar.malavali@qlogic.com
Subject: [PATCH 2/5] qla2xxx: Fix for a multiqueue bug in CPU affinity mode
Date: Tue, 15 Dec 2009 21:29:45 -0800
Message-ID: <1260941388-548-3-git-send-email-giridhar.malavali@qlogic.com>
References: <1260941388-548-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:57216 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752153AbZLPF3v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 00:29:51 -0500
In-Reply-To: <1260941388-548-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Hold the hardware lock while do the response completion in work queue threads as
it involves sharing a common request queue among multiple threads.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mid.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 2a4c7f4..b901aa2 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -639,8 +639,10 @@ static void qla_do_work(struct work_struct *work)
 	struct rsp_que *rsp = container_of(work, struct rsp_que, q_work);
 	struct scsi_qla_host *vha;
 
+	spin_lock_irq(&rsp->hw->hardware_lock);
 	vha = qla25xx_get_host(rsp);
 	qla24xx_process_response_queue(vha, rsp);
+	spin_unlock_irq(&rsp->hw->hardware_lock);
 }
 
 /* create response queue */
-- 
1.6.2.rc1.30.gd43c

