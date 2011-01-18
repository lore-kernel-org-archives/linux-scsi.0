From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Convert tcm_mod_builder.py from Kbuild -> Makefile
Date: Tue, 18 Jan 2011 12:47:21 -0800
Message-ID: <1295383641-12681-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm9-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.192]:36336 "HELO
	nm9-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752168Ab1ARUr2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 15:47:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the tcm_mod_builder.py generation script to
create a new drivers/target/$TCM_FABRIC_MOD/Makefile and update
drivers/target/Makefile, instead of creating+updating a 'Kbuild'
filename.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 Documentation/target/tcm_mod_builder.py |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index dbeb8a0..bb0038c 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -973,7 +973,7 @@ def tcm_mod_dump_fabric_ops(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 def tcm_mod_build_kbuild(fabric_mod_dir_var, fabric_mod_name):
 
 	buf = ""
-	f = fabric_mod_dir_var + "/Kbuild"
+	f = fabric_mod_dir_var + "/Makefile"
 	print "Writing file: " + f
 
 	p = open(f, 'w')
@@ -1018,7 +1018,7 @@ def tcm_mod_build_kconfig(fabric_mod_dir_var, fabric_mod_name):
 
 def tcm_mod_add_kbuild(tcm_dir, fabric_mod_name):
 	buf = "obj-$(CONFIG_" + fabric_mod_name.upper() + ")	+= " + fabric_mod_name.lower() + "/\n"
-	kbuild = tcm_dir + "/drivers/target/Kbuild"
+	kbuild = tcm_dir + "/drivers/target/Makefile"
 
 	f = open(kbuild, 'a')
 	f.write(buf)
@@ -1064,7 +1064,7 @@ def main(modname, proto_ident):
 	tcm_mod_build_kbuild(fabric_mod_dir, fabric_mod_name)
 	tcm_mod_build_kconfig(fabric_mod_dir, fabric_mod_name)
 
-	input = raw_input("Would you like to add " + fabric_mod_name + "to drivers/target/Kbuild..? [yes,no]: ")
+	input = raw_input("Would you like to add " + fabric_mod_name + "to drivers/target/Makefile..? [yes,no]: ")
 	if input == "yes" or input == "y":
 		tcm_mod_add_kbuild(tcm_dir, fabric_mod_name)
 
-- 
1.7.3.5

