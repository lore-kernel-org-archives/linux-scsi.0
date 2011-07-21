From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 038/103] target: Fold transport_device_setup_cmd() into lookup_{tmr,cmd}_lun()
Date: Thu, 21 Jul 2011 00:07:50 -0700
Message-ID: <1311232135-6653-39-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm10-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.122]:22943
	"HELO nm10-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752388Ab1GUHKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:10:04 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

The function just sets cmd->se_dev based on the lun's se_dev. Since
lookup_tmr_lun is the function that finds the se_lun for a cmd, we can
just set se_dev there.

I've done a lot of checking of fabrics to make sure this is ok, but also
I'd think since cmd->se_lun gets set in lookup_tmr, all the old callers of
setup_cmd must already have been calling lookup_tmr first.

(nab: Fix transport_lookup_tmr_lun failure case)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c     |    1 -
 drivers/target/target_core_device.c    |    8 +++++++-
 drivers/target/target_core_transport.c |    8 --------
 include/target/target_core_transport.h |    1 -
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 38e936b..cd73940 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -128,7 +128,6 @@ static struct se_cmd *tcm_loop_allocate_core_cmd(
 		return NULL;
 	}
 
-	transport_device_setup_cmd(se_cmd);
 	return se_cmd;
 }
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c8d4654..ea92f75 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -149,6 +149,9 @@ int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		return -ENODEV;
 	}
 
+	/* Directly associate cmd with se_dev */
+	se_cmd->se_dev = se_lun->lun_se_dev;
+
 	/* TODO: get rid of this and use atomics for stats */
 	dev = se_lun->lun_se_dev;
 	spin_lock_irq(&dev->stats_lock);
@@ -193,7 +196,6 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		se_tmr->tmr_lun = deve->se_lun;
 		se_cmd->se_lun = deve->se_lun;
 		se_lun = deve->se_lun;
-		se_tmr->tmr_dev = se_lun->lun_se_dev;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_orig_obj_ptr = se_cmd->se_dev;
@@ -217,6 +219,10 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		return -ENODEV;
 	}
 
+	/* Directly associate cmd with se_dev */
+	se_cmd->se_dev = se_lun->lun_se_dev;
+	se_tmr->tmr_dev = se_lun->lun_se_dev;
+
 	spin_lock(&se_tmr->tmr_dev->se_tmr_lock);
 	list_add_tail(&se_tmr->tmr_list, &se_tmr->tmr_dev->dev_tmr_list);
 	spin_unlock(&se_tmr->tmr_dev->se_tmr_lock);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bd445ff..646649a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1685,12 +1685,6 @@ transport_generic_get_task(struct se_cmd *cmd,
 
 static int transport_generic_cmd_sequencer(struct se_cmd *, unsigned char *);
 
-void transport_device_setup_cmd(struct se_cmd *cmd)
-{
-	cmd->se_dev = cmd->se_lun->lun_se_dev;
-}
-EXPORT_SYMBOL(transport_device_setup_cmd);
-
 /*
  * Used by fabric modules containing a local struct se_cmd within their
  * fabric dependent per I/O descriptor.
@@ -1782,7 +1776,6 @@ int transport_generic_allocate_tasks(
 	 */
 	cmd->transport_wait_for_tasks = &transport_generic_wait_for_tasks;
 
-	transport_device_setup_cmd(cmd);
 	/*
 	 * Ensure that the received CDB is less than the max (252 + 8) bytes
 	 * for VARIABLE_LENGTH_CMD
@@ -1917,7 +1910,6 @@ int transport_generic_handle_tmr(
 	 * This is needed for early exceptions.
 	 */
 	cmd->transport_wait_for_tasks = &transport_generic_wait_for_tasks;
-	transport_device_setup_cmd(cmd);
 
 	transport_add_cmd_to_queue(cmd, TRANSPORT_PROCESS_TMR);
 	return 0;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 1dd4d18..acd5914 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -159,7 +159,6 @@ extern struct se_device *transport_add_device_to_core_hba(struct se_hba *,
 					struct se_subsystem_dev *, u32,
 					void *, struct se_dev_limits *,
 					const char *, const char *);
-extern void transport_device_setup_cmd(struct se_cmd *);
 extern void transport_init_se_cmd(struct se_cmd *,
 					struct target_core_fabric_ops *,
 					struct se_session *, u32, int, int,
-- 
1.7.6

