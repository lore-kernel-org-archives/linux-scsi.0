From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Remove unnecessary tcm_mod_builder.py kbuild EXTRA_CFLAGS
Date: Tue, 18 Jan 2011 14:00:26 -0800
Message-ID: <1295388026-13052-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm19-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.212]:21176 "HELO
	nm19-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751532Ab1ARWAg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 17:00:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the remaining EXTRA_CFLAGS includes from
tcm_mod_build_kbuild(), and converts fabric module generated .c
code to us ""-style includes for $FABRIC_MOD_[base,fabric].h

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 Documentation/target/tcm_mod_builder.py |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index cf857c0..89af6c7 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -239,8 +239,8 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 	buf += "#include <target/target_core_configfs.h>\n"
 	buf += "#include <target/target_core_base.h>\n"
 	buf += "#include <target/configfs_macros.h>\n\n"
-	buf += "#include <" + fabric_mod_name + "_base.h>\n"
-	buf += "#include <" + fabric_mod_name + "_fabric.h>\n\n"
+	buf += "#include \"" + fabric_mod_name + "_base.h\"\n"
+	buf += "#include \"" + fabric_mod_name + "_fabric.h\"\n\n"
 
 	buf += "/* Local pointer to allocated TCM configfs fabric module */\n"
 	buf += "struct target_fabric_configfs *" + fabric_mod_name + "_fabric_configfs;\n\n"
@@ -583,9 +583,9 @@ def tcm_mod_dump_fabric_ops(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 	buf += "#include <target/target_core_fabric_lib.h>\n"
 	buf += "#include <target/target_core_device.h>\n"
 	buf += "#include <target/target_core_tpg.h>\n"
-	buf += "#include <target/target_core_configfs.h>\n"
-	buf += "#include <" + fabric_mod_name + "_base.h>\n"
-	buf += "#include <" + fabric_mod_name + "_fabric.h>\n\n"
+	buf += "#include <target/target_core_configfs.h>\n\n"
+	buf += "#include \"" + fabric_mod_name + "_base.h\"\n"
+	buf += "#include \"" + fabric_mod_name + "_fabric.h\"\n\n"
 
 	buf += "int " + fabric_mod_name + "_check_true(struct se_portal_group *se_tpg)\n"
 	buf += "{\n"
@@ -980,7 +980,6 @@ def tcm_mod_build_kbuild(fabric_mod_dir_var, fabric_mod_name):
 	if not p:
 		tcm_mod_err("Unable to open file: " + f)
 
-	buf = "EXTRA_CFLAGS += -I$(srctree)/include/ -I$(srctree)/drivers/target/" + fabric_mod_name + "\n\n"
 	buf += fabric_mod_name + "-objs			:= " + fabric_mod_name + "_fabric.o \\\n"
 	buf += "					   " + fabric_mod_name + "_configfs.o\n"
 	buf += "obj-$(CONFIG_" + fabric_mod_name.upper() + ")		+= " + fabric_mod_name + ".o\n"
-- 
1.7.3.5

