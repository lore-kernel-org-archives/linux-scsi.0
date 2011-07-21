From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 021/103] target: remove extraneous returns at end of void functions
Date: Thu, 21 Jul 2011 00:04:57 -0700
Message-ID: <1311231979-6631-22-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm15.bullet.mail.bf1.yahoo.com ([98.139.212.174]:36904 "HELO
	nm15.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752212Ab1GUHHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:01 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c  |    3 ---
 drivers/target/target_core_device.c    |   12 ------------
 drivers/target/target_core_pscsi.c     |    2 --
 drivers/target/target_core_transport.c |    2 --
 drivers/target/tcm_fc/tfc_cmd.c        |    1 -
 5 files changed, 0 insertions(+), 20 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 27effbc..8196b72 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -601,7 +601,6 @@ void target_fabric_configfs_deregister(
 
 	printk("<<<<<<<<<<<<<<<<<<<<<< END FABRIC API >>>>>>>>>>>>>>>>>"
 			">>>>>\n");
-	return;
 }
 EXPORT_SYMBOL(target_fabric_configfs_deregister);
 
@@ -3304,8 +3303,6 @@ static void __exit target_core_exit_configfs(void)
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
 	release_se_kmem_caches();
-
-	return;
 }
 
 MODULE_DESCRIPTION("Target_Core_Mod/ConfigFS");
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index fe5474c..ff57891 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -339,8 +339,6 @@ void core_dec_lacl_count(struct se_node_acl *se_nacl, struct se_cmd *se_cmd)
 	deve = &se_nacl->device_list[se_cmd->orig_fe_lun];
 	deve->deve_cmds--;
 	spin_unlock_irq(&se_nacl->device_list_lock);
-
-	return;
 }
 
 void core_update_device_list_access(
@@ -360,8 +358,6 @@ void core_update_device_list_access(
 		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
 	}
 	spin_unlock_irq(&nacl->device_list_lock);
-
-	return;
 }
 
 /*      core_update_device_list_for_node():
@@ -508,8 +504,6 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 		spin_lock_bh(&tpg->acl_node_lock);
 	}
 	spin_unlock_bh(&tpg->acl_node_lock);
-
-	return;
 }
 
 static struct se_port *core_alloc_port(struct se_device *dev)
@@ -623,8 +617,6 @@ static void core_release_port(struct se_device *dev, struct se_port *port)
 	list_del(&port->sep_list);
 	dev->dev_port_count--;
 	kfree(port);
-
-	return;
 }
 
 int core_dev_export(
@@ -761,8 +753,6 @@ void se_release_device_for_hba(struct se_device *dev)
 	se_release_vpd_for_dev(dev);
 
 	kfree(dev);
-
-	return;
 }
 
 void se_release_vpd_for_dev(struct se_device *dev)
@@ -776,8 +766,6 @@ void se_release_vpd_for_dev(struct se_device *dev)
 		kfree(vpd);
 	}
 	spin_unlock(&DEV_T10_WWN(dev)->t10_vpd_lock);
-
-	return;
 }
 
 /*	se_free_virtual_device():
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e221dea..afe5f57 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1369,8 +1369,6 @@ static inline void pscsi_process_SAM_status(
 		transport_complete_task(task, 0);
 		break;
 	}
-
-	return;
 }
 
 static void pscsi_req_done(struct request *req, int uptodate)
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7e0d69a..473032e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1103,8 +1103,6 @@ static void transport_add_tasks_from_cmd(struct se_cmd *cmd)
 		task_prev = task;
 	}
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
-
-	return;
 }
 
 /*	transport_get_task_from_execute_queue():
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 92a449a..5823ccf 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -670,7 +670,6 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 
 err:
 	ft_send_resp_code(cmd, FCP_CMND_FIELDS_INVALID);
-	return;
 }
 
 /*
-- 
1.7.6

