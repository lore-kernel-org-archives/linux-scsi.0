From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 03/21] target: tcm_mod_builder.py generated Makefile cleanups
Date: Mon, 14 Mar 2011 04:05:57 -0700
Message-ID: <1300100775-10012-4-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm1.bullet.mail.sp2.yahoo.com ([98.139.91.71]:25828 "HELO
	nm1.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753273Ab1CNLGi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 07:06:38 -0400
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the tcm_mod_builder.py generation script to
create a new drivers/target/$TCM_FABRIC_MOD/Makefile and update
drivers/target/Makefile, instead of creating+updating a 'Kbuild'
filename.

It also removes the remaining EXTRA_CFLAGS includes from
tcm_mod_build_kbuild(), and converts fabric module generated .c
code to us ""-style includes for $FABRIC_MOD_[base,fabric].h

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 Documentation/target/tcm_mod_builder.py |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index dbeb8a0..89af6c7 100755
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
@@ -973,14 +973,13 @@ def tcm_mod_dump_fabric_ops(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 def tcm_mod_build_kbuild(fabric_mod_dir_var, fabric_mod_name):
 
 	buf = ""
-	f = fabric_mod_dir_var + "/Kbuild"
+	f = fabric_mod_dir_var + "/Makefile"
 	print "Writing file: " + f
 
 	p = open(f, 'w')
 	if not p:
 		tcm_mod_err("Unable to open file: " + f)
 
-	buf = "EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/include/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/" + fabric_mod_name + "\n\n"
 	buf += fabric_mod_name + "-objs			:= " + fabric_mod_name + "_fabric.o \\\n"
 	buf += "					   " + fabric_mod_name + "_configfs.o\n"
 	buf += "obj-$(CONFIG_" + fabric_mod_name.upper() + ")		+= " + fabric_mod_name + ".o\n"
@@ -1018,7 +1017,7 @@ def tcm_mod_build_kconfig(fabric_mod_dir_var, fabric_mod_name):
 
 def tcm_mod_add_kbuild(tcm_dir, fabric_mod_name):
 	buf = "obj-$(CONFIG_" + fabric_mod_name.upper() + ")	+= " + fabric_mod_name.lower() + "/\n"
-	kbuild = tcm_dir + "/drivers/target/Kbuild"
+	kbuild = tcm_dir + "/drivers/target/Makefile"
 
 	f = open(kbuild, 'a')
 	f.write(buf)
@@ -1064,7 +1063,7 @@ def main(modname, proto_ident):
 	tcm_mod_build_kbuild(fabric_mod_dir, fabric_mod_name)
 	tcm_mod_build_kconfig(fabric_mod_dir, fabric_mod_name)
 
-	input = raw_input("Would you like to add " + fabric_mod_name + "to drivers/target/Kbuild..? [yes,no]: ")
+	input = raw_input("Would you like to add " + fabric_mod_name + "to drivers/target/Makefile..? [yes,no]: ")
 	if input == "yes" or input == "y":
 		tcm_mod_add_kbuild(tcm_dir, fabric_mod_name)
 
-- 
1.7.4.1

