From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm_qla2xxx: Add tfo->tpg_check_demo_mode_login_only usage
Date: Wed, 27 Jul 2011 00:45:18 +0000
Message-ID: <1311727518-1927-4-git-send-email-nab@linux-iscsi.org>
References: <1311727518-1927-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52622 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab1G0BJE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 21:09:04 -0400
In-Reply-To: <1311727518-1927-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Roland Dreier <roland@purestorage.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch enables target_core_fabric_ops->tpg_check_demo_mode_login_only=1
in tcm_qla2xxx in order to allow demo-mode I_T FC nexuses to login, and
only return 'not connected' in standard INQUIRY response instead of the
default TPG LUN layout.

Reported-by: Roland Dreier <roland@purestorage.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
---
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
index ac970e1..f6ffc74 100644
--- a/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
+++ b/drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
@@ -1201,6 +1201,7 @@ static struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.tpg_check_demo_mode_cache	= tcm_qla2xxx_check_demo_mode_cache,
 	.tpg_check_demo_mode_write_protect = tcm_qla2xxx_check_demo_write_protect,
 	.tpg_check_prod_mode_write_protect = tcm_qla2xxx_check_prod_write_protect,
+	.tpg_check_demo_mode_login_only = tcm_qla2xxx_check_true,
 	.tpg_alloc_fabric_acl		= tcm_qla2xxx_alloc_fabric_acl,
 	.tpg_release_fabric_acl		= tcm_qla2xxx_release_fabric_acl,
 	.tpg_get_inst_index		= tcm_qla2xxx_tpg_get_inst_index,
@@ -1253,6 +1254,7 @@ static struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 	.tpg_check_demo_mode_cache	= tcm_qla2xxx_check_true,
 	.tpg_check_demo_mode_write_protect = tcm_qla2xxx_check_true,
 	.tpg_check_prod_mode_write_protect = tcm_qla2xxx_check_false,
+	.tpg_check_demo_mode_login_only	= tcm_qla2xxx_check_true,
 	.tpg_alloc_fabric_acl		= tcm_qla2xxx_alloc_fabric_acl,
 	.tpg_release_fabric_acl		= tcm_qla2xxx_release_fabric_acl,
 	.tpg_get_inst_index		= tcm_qla2xxx_tpg_get_inst_index,
-- 
1.7.2.5

