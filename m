From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Convert to cpu_relax() for atomic_read() in tight loops
Date: Thu,  9 Sep 2010 14:29:28 -0700
Message-ID: <1284067768-23863-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:32071 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753792Ab0IIV3e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2010 17:29:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This patch converts the following functions from within shutdown and release
path code to use cpu_relax() instead of msleep() while doing atomic_read() in
a tight loop waiting for various PR and MIB reference count(s) to return to zero:

	*) core_update_device_list_for_node() + struct se_dev_entry->pr_ref_count
	*) core_release_port() + struct se_port->sep_tg_pt_ref_cnt
	*) se_dev_stop() + struct se_hba->dev_mib_access_count
	*) __core_scsi3_free_registration() + struct t10_pr_registration->pr_res_holders
	*) core_tpg_wait_for_nacl_pr_ref() + struct se_node_acl->acl_pr_ref_count
	*) core_tpg_wait_for_mib_ref() + struct se_node_acl->mib_ref_count
	*) core_tpg_deregister() + struct se_portal_group->tpg_pr_ref_count
	*) transport_deregister_session() + struct se_session->mib_ref_count

Thanks to Konrad Rzeszutek Wilk for mentioning cpu_relax() usage!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    |    6 +++---
 drivers/target/target_core_pr.c        |    2 +-
 drivers/target/target_core_tpg.c       |    6 +++---
 drivers/target/target_core_transport.c |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 665b8e2..459f0f8 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -532,7 +532,7 @@ int core_update_device_list_for_node(
 	 */
 	spin_unlock_irq(&nacl->device_list_lock);
 	while (atomic_read(&deve->pr_ref_count) != 0)
-		msleep(100);
+		cpu_relax();
 	spin_lock_irq(&nacl->device_list_lock);
 	/*
 	 * Disable struct se_dev_entry LUN ACL mapping
@@ -687,7 +687,7 @@ void core_release_port(struct se_device *dev, struct se_port *port)
 	 */
 	spin_unlock(&dev->se_port_lock);
 	if (atomic_read(&port->sep_tg_pt_ref_cnt))
-		msleep(100);
+		cpu_relax();
 	spin_lock(&dev->se_port_lock);
 
 	core_alua_free_tg_pt_gp_mem(port);
@@ -965,7 +965,7 @@ void se_dev_stop(struct se_device *dev)
 	spin_unlock(&hba->device_lock);
 
 	while (atomic_read(&hba->dev_mib_access_count))
-		msleep(10);
+		cpu_relax();
 }
 
 int se_dev_check_online(struct se_device *dev)
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 2cebafa..11118fb 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1289,7 +1289,7 @@ static void __core_scsi3_free_registration(
 		spin_unlock(&pr_tmpl->registration_lock);
 		printk("SPC-3 PR [%s] waiting for pr_res_holders\n",
 				tfo->get_fabric_name());
-		msleep(10);
+		cpu_relax();
 		spin_lock(&pr_tmpl->registration_lock);
 	}
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 75c3900..e598f2b 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -315,13 +315,13 @@ EXPORT_SYMBOL(core_tpg_check_initiator_node_acl);
 void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
 {
 	while (atomic_read(&nacl->acl_pr_ref_count) != 0)
-		msleep(100);
+		cpu_relax();
 }
 
 void core_tpg_wait_for_mib_ref(struct se_node_acl *nacl)
 {
 	while (atomic_read(&nacl->mib_ref_count) != 0)
-		msleep(100);
+		cpu_relax();
 }
 
 void core_tpg_clear_object_luns(struct se_portal_group *tpg)
@@ -713,7 +713,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	spin_unlock_bh(&se_global->se_tpg_lock);
 
 	while (atomic_read(&se_tpg->tpg_pr_ref_count) != 0)
-		msleep(100);
+		cpu_relax();
 
 	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL)
 		core_tpg_release_virtual_lun0(se_tpg);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9e7582b..95401cb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -750,7 +750,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	 * scsi_att_intr_port_seq_show()
 	 */
 	while (atomic_read(&se_sess->mib_ref_count) != 0)
-		msleep(100);
+		cpu_relax();
 
 	spin_lock_bh(&se_tpg->session_lock);
 	list_del(&se_sess->sess_list);
-- 
1.5.6.5

