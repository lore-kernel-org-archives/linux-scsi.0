From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target/ConfigFS]: Add lio_target_port_check_link()
Date: Fri, 03 Apr 2009 01:26:57 -0700
Message-ID: <1238747217.4250.451.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:25666 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759956AbZDCI1G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2009 04:27:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Greetings all,

This patch adds struct configfs_item_operations->check_link() for
lio_target_port_item_ops that allows existing LIO-Target Port Logical Unit
ACL to prevent an unlink(2) from a exported target_core_mod/ConfigFS
Linux storage object at:

/sys/kernel/config/target/iscsi/$TARGET_IQN/$TPGT/lun/$LUN/$PORT

when iSCSI Initiator LUN ACLs exist to LIO-Target/ConfigFS storage
objects in:

/sys/kernel/config/target/iscsi/$IQN/$TPGT/acl/$INITIATOR_IQN/$LUN

These patches are made against lio-core-2.6.git/master and tested on
v2.6.29 x86 32-bit HVM.  The lio-core-2.6.git tree can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_configfs.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_configfs.c b/drivers/lio-core/iscsi_target_configfs.c
index dc6ef88..acaa436 100644
--- a/drivers/lio-core/iscsi_target_configfs.c
+++ b/drivers/lio-core/iscsi_target_configfs.c
@@ -523,6 +523,13 @@ out:
 	return(ret);
 }
 
+static int lio_target_port_check_link(struct config_item *lun_ci)
+{
+	se_lun_t *lun = container_of(to_config_group(lun_ci), se_lun_t, lun_group);
+
+	return atomic_read(&lun->lun_acl_count) ? -EACCES : 0;
+}
+
 static int lio_target_port_unlink (struct config_item *lun_ci, struct config_item *se_dev_ci)
 {
 	iscsi_portal_group_t *tpg;
@@ -568,6 +575,7 @@ static struct configfs_item_operations lio_target_port_item_ops = {
 	.show_attribute		= lio_target_port_show,
 	.store_attribute	= lio_target_port_store,
 	.allow_link		= lio_target_port_link,
+	.check_link		= lio_target_port_check_link,
 	.drop_link		= lio_target_port_unlink,
 };
 
-- 
1.5.4.1



