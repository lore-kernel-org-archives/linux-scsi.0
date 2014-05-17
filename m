From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] target: fix memory leak on XCOPY
Date: Sat, 17 May 2014 06:49:22 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1405170647430.15837@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On each processed XCOPY command, two "kmalloc-512" memory objects are
leaked. These represent two allocations of struct xcopy_pt_cmd in
target_core_xcopy.c.

The reason for the memory leak is that the cmd_kref field is not
initialized (thus, it is zero because the allocations were done with
kzalloc). When we decrement zero kref in target_put_sess_cmd, the result
is not zero, thus target_release_cmd_kref is not called.

This patch fixes the bug by moving kref initialization from
target_get_sess_cmd to transport_init_se_cmd (this function is called from
target_core_xcopy.c, so it will correctly initialize cmd_kref). It can be
easily verified that all code that calls target_get_sess_cmd also calls
transport_init_se_cmd earlier, thus moving kref_init shouldn't introduce
any new problems.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# 3.12+

---
 drivers/target/target_core_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-3.15-rc5/drivers/target/target_core_transport.c
===================================================================
--- linux-3.15-rc5.orig/drivers/target/target_core_transport.c	2014-04-14 16:08:15.000000000 +0200
+++ linux-3.15-rc5/drivers/target/target_core_transport.c	2014-05-16 18:24:57.000000000 +0200
@@ -1113,6 +1113,7 @@ void transport_init_se_cmd(
 	init_completion(&cmd->cmd_wait_comp);
 	init_completion(&cmd->task_stop_comp);
 	spin_lock_init(&cmd->t_state_lock);
+	kref_init(&cmd->cmd_kref);
 	cmd->transport_state = CMD_T_DEV_ACTIVE;
 
 	cmd->se_tfo = tfo;
@@ -2357,7 +2358,6 @@ int target_get_sess_cmd(struct se_sessio
 	unsigned long flags;
 	int ret = 0;
 
-	kref_init(&se_cmd->cmd_kref);
 	/*
 	 * Add a second kref if the fabric caller is expecting to handle
 	 * fabric acknowledgement that requires two target_put_sess_cmd()
