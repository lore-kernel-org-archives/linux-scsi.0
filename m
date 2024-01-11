Received: from mta-04.yadro.com (mta-04.yadro.com [89.207.88.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6FA15AFD;
	Thu, 11 Jan 2024 12:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="Q3P5jDze";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="ZvjJg+VD"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-04.yadro.com 4EBF3C0002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1704977992; bh=YFHaQVMXrI5pbRCPJfwdULlobUxAamN8K/hXYDdoZRs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=Q3P5jDzeiISadnxFPp6JUJPvgYCXpW7xvth8NA2jq7LRHV0w+evtcseILobMNrOep
	 WD0/WvC1XE/HMntXquPvu45KBk0xgSxzgpCLy59c5iw7eEzLewKT5TJBsYExsk7znE
	 l5kmdWzv2XnmR5DA9vgekWErlX5WlOvIeLmkq0RywSRzK2DyYsF5e9CBlATkL3NOup
	 qVEMlCPFKzpECQs/cuWjgkes0jBi+D/NqsYxJe3nzEt+AMaRq2PF5T0T5x2svQ6VtV
	 b0Ka6aP7dNwpAYma38X4eAaxBvDnT7brase8c0hnmcGW83/Dy/E9PFFsGAh9Z3uG1s
	 +OC2prfBtUsnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1704977992; bh=YFHaQVMXrI5pbRCPJfwdULlobUxAamN8K/hXYDdoZRs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=ZvjJg+VDGiG+aBhB27A+vCUpTtlZRhvrhQh4ef2YuL7mCwXX6c4T57YMuj070ukEn
	 uFHhl0ZjqKOI/eT1zPjLxjw7QeOhK1FHTtj5Pqmx7ovT9O4qWbVVJB/1HdYgvy5551
	 GN8KYqt33brwPPhLzYg5TcYIPVLfPPyMWALgNUPzuRiukAhD+9xDmUhtdxSwoNh17c
	 SO8IXJp6sQIPP5xB+b9bI2tIVEG0VuVtpL0NniHTuh/8Kq2wQxs8FEDw2zj+VtBGby
	 bwjZbS71RfXokWT87ekH55yRX8TjEbmihiCUi+coSyf7phoUzXfAIGDQIdVhMm96/V
	 F60COaS6oYvOQ==
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Martin Petersen <martin.petersen@oracle.com>,
	<target-devel@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux@yadro.com>, Dmitry Bogdanov
	<d.bogdanov@yadro.com>
Subject: [PATCH] scsi: target: add TMF to tmr_list at the handling
Date: Thu, 11 Jan 2024 15:59:41 +0300
Message-ID: <20240111125941.8688-1-d.bogdanov@yadro.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-10.corp.yadro.com (172.17.11.60) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

iSCSI Abort that are responded by iscsi itself is added to tmr_list but
it does not go to target core. On other side LUN_RESET that goes throught
tmr_list takes a refcounter of that abort and wait for completion of the abort
that will be never completed because it was not even started in the target core.

Such logs shows that situations:

 Unable to locate ITT: 0x05000000 on CID: 0
 Unable to locate RefTaskTag: 0x05000000 on CID: 0.
 wait_for_tasks: Stopping tmf LUN_RESET with tag 0x0 ref_task_tag 0x0 i_state 34 t_state ISTATE_PROCESSING refcnt 2 transport_state active,stop,fabric_stop
 wait for tasks: tmf LUN_RESET with tag 0x0 ref_task_tag 0x0 i_state 34 t_state ISTATE_PROCESSING refcnt 2 transport_state active,stop,fabric_stop
...
 INFO: task kworker/0:2:49 blocked for more than 491 seconds.
 task:kworker/0:2     state:D stack:    0 pid:   49 ppid:     2 flags:0x00000800
 Workqueue: events target_tmr_work [target_core_mod]
Call Trace:
 __switch_to+0x2c4/0x470
 _schedule+0x314/0x1730
 schedule+0x64/0x130
 schedule_timeout+0x168/0x430
 wait_for_completion+0x140/0x270
 target_put_cmd_and_wait+0x64/0xb0 [target_core_mod]
 core_tmr_lun_reset+0x30/0xa0 [target_core_mod]
 target_tmr_work+0xc8/0x1b0 [target_core_mod]
 process_one_work+0x2d4/0x5d0
 worker_thread+0x78/0x6c0

To fix that, add an Abort to tmr_list only if that Abort will be handled by
target core.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
---
 drivers/target/target_core_device.c    | 5 -----
 drivers/target/target_core_transport.c | 4 ++++
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f7279dfcafa0..4d6cc20903d6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -151,7 +151,6 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	struct se_session *se_sess = se_cmd->se_sess;
 	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
-	unsigned long flags;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, se_cmd->orig_fe_lun);
@@ -182,10 +181,6 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd)
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
 	se_tmr->tmr_dev = rcu_dereference_raw(se_lun->lun_se_dev);
 
-	spin_lock_irqsave(&se_tmr->tmr_dev->se_tmr_lock, flags);
-	list_add_tail(&se_tmr->tmr_list, &se_tmr->tmr_dev->dev_tmr_list);
-	spin_unlock_irqrestore(&se_tmr->tmr_dev->se_tmr_lock, flags);
-
 	return 0;
 }
 EXPORT_SYMBOL(transport_lookup_tmr_lun);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 923fe8453d5e..ab570aa17798 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3894,6 +3894,10 @@ int transport_generic_handle_tmr(
 	unsigned long flags;
 	bool aborted = false;
 
+	spin_lock_irqsave(&cmd->se_dev->se_tmr_lock, flags);
+	list_add_tail(&cmd->se_tmr_req->tmr_list, &cmd->se_dev->dev_tmr_list);
+	spin_unlock_irqrestore(&cmd->se_dev->se_tmr_lock, flags);
+
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (cmd->transport_state & CMD_T_ABORTED) {
 		aborted = true;
-- 
2.25.1

