From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Add missing NULL match_table_t entries
Date: Thu, 11 Nov 2010 05:00:25 -0800
Message-ID: <1289480425-14174-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm18-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.37]:23641 "HELO
	nm18-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755146Ab0KKNA2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 08:00:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the missing trailing NULL entries for match_token() to
function properly in various backend ->set_configfs_dev_params() callers
and PR APTPL match_table_t tokens.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |    3 ++-
 drivers/target/target_core_file.c     |    3 ++-
 drivers/target/target_core_iblock.c   |    3 ++-
 drivers/target/target_core_pscsi.c    |    4 +++-
 drivers/target/target_core_rd.c       |    3 ++-
 drivers/target/target_core_stgt.c     |    3 ++-
 6 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 15f715c..74de6c2 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1460,7 +1460,7 @@ enum {
 	Opt_initiator_fabric, Opt_initiator_node, Opt_initiator_sid,
 	Opt_sa_res_key, Opt_res_holder, Opt_res_type, Opt_res_scope,
 	Opt_res_all_tg_pt, Opt_mapped_lun, Opt_target_fabric,
-	Opt_target_node, Opt_tpgt, Opt_port_rtpi, Opt_target_lun
+	Opt_target_node, Opt_tpgt, Opt_port_rtpi, Opt_target_lun, Opt_err
 };
 
 static match_table_t tokens = {
@@ -1478,6 +1478,7 @@ static match_table_t tokens = {
 	{Opt_tpgt, "tpgt=%d"},
 	{Opt_port_rtpi, "port_rtpi=%d"},
 	{Opt_target_lun, "target_lun=%d"},
+	{Opt_err, NULL}
 };
 
 static ssize_t target_core_dev_pr_store_attr_res_aptpl_metadata(
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 217711f..7e37504 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -606,13 +606,14 @@ static void fd_free_task(struct se_task *task)
 }
 
 enum {
-	Opt_fd_dev_name, Opt_fd_dev_size, Opt_fd_buffered_io
+	Opt_fd_dev_name, Opt_fd_dev_size, Opt_fd_buffered_io, Opt_err
 };
 
 static match_table_t tokens = {
 	{Opt_fd_dev_name, "fd_dev_name=%s"},
 	{Opt_fd_dev_size, "fd_dev_size=%s"},
 	{Opt_fd_buffered_io, "fd_buffered_id=%d"},
+	{Opt_err, NULL}
 };
 	
 static ssize_t fd_set_configfs_dev_params(
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 7a3a06d..667e0f3 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -470,12 +470,13 @@ static void iblock_free_task(struct se_task *task)
 }
 
 enum {
-	Opt_udev_path, Opt_force
+	Opt_udev_path, Opt_force, Opt_err
 };
 
 static match_table_t tokens = {
 	{Opt_udev_path, "udev_path=%s"},
 	{Opt_force, "force=%d"},
+	{Opt_err, NULL}
 };
 
 static ssize_t iblock_set_configfs_dev_params(struct se_hba *hba,
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index d11957f..5123e16 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -804,7 +804,8 @@ static void pscsi_free_task(struct se_task *task)
 }
 
 enum {
-	Opt_scsi_host_id, Opt_scsi_channel_id, Opt_scsi_target_id, Opt_scsi_lun_id
+	Opt_scsi_host_id, Opt_scsi_channel_id, Opt_scsi_target_id,
+	Opt_scsi_lun_id, Opt_err
 };
 
 static match_table_t tokens = {
@@ -812,6 +813,7 @@ static match_table_t tokens = {
 	{Opt_scsi_channel_id, "scsi_channel_id=%d"},
 	{Opt_scsi_target_id, "scsi_target_id=%d"},
 	{Opt_scsi_lun_id, "scsi_lun_id=%d"},
+	{Opt_err, NULL}
 };
 
 static ssize_t pscsi_set_configfs_dev_params(struct se_hba *hba,
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 981098a..bfa9cc4 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -990,11 +990,12 @@ static void rd_free_task(struct se_task *task)
 }
 
 enum {
-	Opt_rd_pages
+	Opt_rd_pages, Opt_err
 };
 
 static match_table_t tokens = {
 	{Opt_rd_pages, "rd_pages=%d"},
+	{Opt_err, NULL}
 };
 
 static ssize_t rd_set_configfs_dev_params(
diff --git a/drivers/target/target_core_stgt.c b/drivers/target/target_core_stgt.c
index 004173b..172ad69 100644
--- a/drivers/target/target_core_stgt.c
+++ b/drivers/target/target_core_stgt.c
@@ -421,13 +421,14 @@ static void stgt_free_task(struct se_task *task)
 }
 
 enum {
-	Opt_scsi_channel_id, Opt_scsi_target_id, Opt_scsi_lun_id
+	Opt_scsi_channel_id, Opt_scsi_target_id, Opt_scsi_lun_id, Opt_err
 };
 
 static match_table_t tokens = {
 	{Opt_scsi_channel_id, "scsi_channel_id=%d"},
 	{Opt_scsi_target_id, "scsi_target_id=%d"},
 	{Opt_scsi_lun_id, "scsi_lun_id=%d"},
+	{Opt_err, NULL}
 };
 
 static ssize_t stgt_set_configfs_dev_params(struct se_hba *hba,
-- 
1.5.6.5

