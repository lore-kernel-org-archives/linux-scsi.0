From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] tcm: Fix NULL pointer dereference for target_fabric_port_attrs[]
Date: Wed, 22 Sep 2010 04:19:52 -0700
Message-ID: <1285154392-6360-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Joel Becker <Joel.Becker@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a NULL pointer dereference in target_fabric_port_attrs[]
callers when handling the MappedLUN + non existent struct se_lun config_group
case in commit 036866f50e2.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index c689463..5d1a81d 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -517,6 +517,9 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_gp(
 	struct se_lun *lun,
 	char *page)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -528,6 +531,9 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_gp(
 	const char *page,
 	size_t count)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -543,6 +549,9 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_offline(
 	struct se_lun *lun,
 	char *page)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -554,6 +563,9 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_offline(
 	const char *page,
 	size_t count)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -569,6 +581,9 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_status(
 	struct se_lun *lun,
 	char *page)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -580,6 +595,9 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_status(
 	const char *page,
 	size_t count)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -595,6 +613,9 @@ static ssize_t target_fabric_port_show_attr_alua_tg_pt_write_md(
 	struct se_lun *lun,
 	char *page)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
@@ -606,6 +627,9 @@ static ssize_t target_fabric_port_store_attr_alua_tg_pt_write_md(
 	const char *page,
 	size_t count)
 {
+	if (!(lun))
+		return -ENODEV;
+
 	if (!(lun->lun_sep))
 		return -ENODEV;
 
-- 
1.5.6.5
