From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix tcm_mod_builder.py default EXTRA_CFLAGS
Date: Tue, 18 Jan 2011 13:30:22 -0800
Message-ID: <1295386222-12869-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:24741 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751739Ab1ARVab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 16:30:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the unnecessary default EXTRA_CFLAGS include paths
for newly generated fabric modules, which now only contains:

	include/
	drivers/target/$NEW_FABRIC_MOD

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 Documentation/target/tcm_mod_builder.py |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index bb0038c..cf857c0 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -980,7 +980,7 @@ def tcm_mod_build_kbuild(fabric_mod_dir_var, fabric_mod_name):
 	if not p:
 		tcm_mod_err("Unable to open file: " + f)
 
-	buf = "EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/include/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/" + fabric_mod_name + "\n\n"
+	buf = "EXTRA_CFLAGS += -I$(srctree)/include/ -I$(srctree)/drivers/target/" + fabric_mod_name + "\n\n"
 	buf += fabric_mod_name + "-objs			:= " + fabric_mod_name + "_fabric.o \\\n"
 	buf += "					   " + fabric_mod_name + "_configfs.o\n"
 	buf += "obj-$(CONFIG_" + fabric_mod_name.upper() + ")		+= " + fabric_mod_name + ".o\n"
-- 
1.7.3.5

