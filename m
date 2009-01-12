From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/MIBS]: Add missing SCSI MIBs
	initialization call during module_init()
Date: Mon, 12 Jan 2009 15:03:08 -0800
Message-ID: <1231801388.4560.1169.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:43384 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750918AbZALXGN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jan 2009 18:06:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Greetings all,

This patch is made against lio-core-2.6.git/master
and tested on v2.6.28.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Thanks,

--nab

>From 53b6924090a2182433e36cbd106d2f0249e3b8cc Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 12 Jan 2009 14:56:56 -0800
Subject: [PATCH] [Target_Core_Mod/MIBS]: Add missing SCSI MIBs initialization call during module_init()

During the v3.0 splitup of SCSI MIBs and iSCSI MIBs into target_core_mibs.c and
iscsi_target_mibs.c respectively, a new initialization function for SCSI MIBs was
added called init_scsi_index_table().  However this function was not added to
target_core_mod's module_init() function: target_core_init_configfs().

This patch adds the missing init_scsi_index_table() before init_se_global()
(which uses SCSI MIB logic) in target_core_init_configfs().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_configfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/target_core_configfs.c b/drivers/lio-core/target_core_configfs.c
index 0fceeab..46a84a7 100644
--- a/drivers/lio-core/target_core_configfs.c
+++ b/drivers/lio-core/target_core_configfs.c
@@ -1023,7 +1023,9 @@ extern int target_core_init_configfs (void)
 	 */
 	INIT_LIST_HEAD(&g_tf_list);
 	mutex_init(&g_tf_lock);
-
+#ifdef SNMP_SUPPORT
+	init_scsi_index_table();
+#endif
 	if ((ret = configfs_register_subsystem(subsys)) < 0) {
 		printk(KERN_ERR "Error %d while registering subsystem %s\n",
 			ret, subsys->su_group.cg_item.ci_namebuf);
-- 
1.5.4.1



