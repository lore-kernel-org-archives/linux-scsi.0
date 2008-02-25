From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH] Fixed build failure  when using -j option of make.
Date: Mon, 25 Feb 2008 03:22:28 -0800
Message-ID: <20080225112228.22450.45718.stgit@vdinit.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:54668 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbYBYTlP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 14:41:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org

This patch removed make dependency on any other .o files which were causing
build failure when make -j 10 used. So moved other .o related code under
openfc dir as these .o  files were used only by openfc module.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/ofc/Makefile                    |    3 
 drivers/scsi/ofc/fcoe/Makefile               |    2 
 drivers/scsi/ofc/libcrc/Makefile             |    9 
 drivers/scsi/ofc/libcrc/crc32_le.c           |  149 --
 drivers/scsi/ofc/libcrc/crc32_le_tab.c       |  594 --------
 drivers/scsi/ofc/libfc/Makefile              |   20 
 drivers/scsi/ofc/libfc/fc_disc_targ.c        |  655 ---------
 drivers/scsi/ofc/libfc/fc_disc_targ.h        |   48 -
 drivers/scsi/ofc/libfc/fc_exch.c             | 1560 ----------------------
 drivers/scsi/ofc/libfc/fc_exch_impl.h        |  141 --
 drivers/scsi/ofc/libfc/fc_fcip.h             |  131 --
 drivers/scsi/ofc/libfc/fc_frame.c            |  105 -
 drivers/scsi/ofc/libfc/fc_ils.h              |  524 -------
 drivers/scsi/ofc/libfc/fc_local_port.c       | 1856 --------------------------
 drivers/scsi/ofc/libfc/fc_local_port_impl.h  |  162 --
 drivers/scsi/ofc/libfc/fc_port.c             |  246 ---
 drivers/scsi/ofc/libfc/fc_print.c            |  138 --
 drivers/scsi/ofc/libfc/fc_remote_port.c      |  329 -----
 drivers/scsi/ofc/libfc/fc_scsi.h             |  463 ------
 drivers/scsi/ofc/libfc/fc_sess.c             | 1445 --------------------
 drivers/scsi/ofc/libfc/fc_sess_impl.h        |   75 -
 drivers/scsi/ofc/libfc/fc_virt_fab.c         |   90 -
 drivers/scsi/ofc/libfc/fc_virt_fab.h         |   43 -
 drivers/scsi/ofc/libfc/fc_virt_fab_impl.h    |   48 -
 drivers/scsi/ofc/libfc/fcs_attr.c            |  297 ----
 drivers/scsi/ofc/libfc/fcs_cmd.c             |  255 ----
 drivers/scsi/ofc/libfc/fcs_event.c           |  225 ---
 drivers/scsi/ofc/libfc/fcs_state.c           |  448 ------
 drivers/scsi/ofc/libfc/fcs_state_impl.h      |   41 -
 drivers/scsi/ofc/libsa/Makefile              |    9 
 drivers/scsi/ofc/libsa/sa_event.c            |  232 ---
 drivers/scsi/ofc/libsa/sa_hash_kern.c        |  141 --
 drivers/scsi/ofc/openfc/Makefile             |   22 
 drivers/scsi/ofc/openfc/crc32_le.c           |  149 ++
 drivers/scsi/ofc/openfc/crc32_le_tab.c       |  594 ++++++++
 drivers/scsi/ofc/openfc/fc_disc_targ.c       |  655 +++++++++
 drivers/scsi/ofc/openfc/fc_disc_targ.h       |   48 +
 drivers/scsi/ofc/openfc/fc_exch.c            | 1560 ++++++++++++++++++++++
 drivers/scsi/ofc/openfc/fc_exch_impl.h       |  141 ++
 drivers/scsi/ofc/openfc/fc_fcip.h            |  131 ++
 drivers/scsi/ofc/openfc/fc_frame.c           |  105 +
 drivers/scsi/ofc/openfc/fc_ils.h             |  524 +++++++
 drivers/scsi/ofc/openfc/fc_local_port.c      | 1856 ++++++++++++++++++++++++++
 drivers/scsi/ofc/openfc/fc_local_port_impl.h |  162 ++
 drivers/scsi/ofc/openfc/fc_port.c            |  246 +++
 drivers/scsi/ofc/openfc/fc_print.c           |  138 ++
 drivers/scsi/ofc/openfc/fc_remote_port.c     |  329 +++++
 drivers/scsi/ofc/openfc/fc_scsi.h            |  463 ++++++
 drivers/scsi/ofc/openfc/fc_sess.c            | 1445 ++++++++++++++++++++
 drivers/scsi/ofc/openfc/fc_sess_impl.h       |   75 +
 drivers/scsi/ofc/openfc/fc_virt_fab.c        |   90 +
 drivers/scsi/ofc/openfc/fc_virt_fab.h        |   43 +
 drivers/scsi/ofc/openfc/fc_virt_fab_impl.h   |   48 +
 drivers/scsi/ofc/openfc/fcs_attr.c           |  297 ++++
 drivers/scsi/ofc/openfc/fcs_cmd.c            |  255 ++++
 drivers/scsi/ofc/openfc/fcs_event.c          |  225 +++
 drivers/scsi/ofc/openfc/fcs_state.c          |  448 ++++++
 drivers/scsi/ofc/openfc/fcs_state_impl.h     |   41 +
 drivers/scsi/ofc/openfc/sa_event.c           |  232 +++
 drivers/scsi/ofc/openfc/sa_hash_kern.c       |  141 ++
 60 files changed, 10460 insertions(+), 10487 deletions(-)

diff --git a/drivers/scsi/ofc/Makefile b/drivers/scsi/ofc/Makefile
index 912494b..233f487 100644
--- a/drivers/scsi/ofc/Makefile
+++ b/drivers/scsi/ofc/Makefile
@@ -4,8 +4,5 @@ OFC_DIR ?= drivers/scsi/ofc
 
 export  OFC_DIR
 
-obj-$(CONFIG_OFC) += libcrc/
-obj-$(CONFIG_OFC) += libsa/
-obj-$(CONFIG_OFC) += libfc/
 obj-$(CONFIG_OFC) += openfc/
 obj-$(CONFIG_FCOE) += fcoe/
diff --git a/drivers/scsi/ofc/fcoe/Makefile b/drivers/scsi/ofc/fcoe/Makefile
index b46aeae..9ce08da 100644
--- a/drivers/scsi/ofc/fcoe/Makefile
+++ b/drivers/scsi/ofc/fcoe/Makefile
@@ -4,7 +4,7 @@ EXTRA_CFLAGS += -I$(OFC_DIR)/include
 
 obj-$(CONFIG_FCOE) += fcoe.o
 
-fcoe-y := \
+fcoe-objs := \
 	fcoe_dev.o \
 	fcoe_if.o \
 	fcoeinit.o \
diff --git a/drivers/scsi/ofc/libcrc/Makefile b/drivers/scsi/ofc/libcrc/Makefile
deleted file mode 100644
index b556b9d..0000000
--- a/drivers/scsi/ofc/libcrc/Makefile
+++ /dev/null
@@ -1,9 +0,0 @@
-# $Id: Makefile
-
-EXTRA_CFLAGS += -I$(OFC_DIR)/include
-
-obj-y += libcrc.o
-
-libcrc-y := \
-	crc32_le.o \
-	crc32_le_tab.o
diff --git a/drivers/scsi/ofc/libfc/Makefile b/drivers/scsi/ofc/libfc/Makefile
deleted file mode 100644
index 944ac31..0000000
--- a/drivers/scsi/ofc/libfc/Makefile
+++ /dev/null
@@ -1,20 +0,0 @@
-# $Id: Makefile
-
-EXTRA_CFLAGS += -I$(OFC_DIR)/include
-
-obj-y += libfc.o
-
-libfc-y := \
-	fc_disc_targ.o \
-	fc_exch.o \
-	fc_frame.o \
-	fc_local_port.o \
-	fc_port.o \
-	fc_print.o \
-	fc_remote_port.o \
-	fcs_attr.o \
-	fcs_cmd.o \
-	fc_sess.o \
-	fcs_event.o \
-	fcs_state.o \
-	fc_virt_fab.o
diff --git a/drivers/scsi/ofc/libsa/Makefile b/drivers/scsi/ofc/libsa/Makefile
deleted file mode 100644
index 3453608..0000000
--- a/drivers/scsi/ofc/libsa/Makefile
+++ /dev/null
@@ -1,9 +0,0 @@
-# $Id: Makefile
-
-EXTRA_CFLAGS += -I$(OFC_DIR)/include
-
-obj-y += libsa.o
-
-libsa-y := \
-	sa_event.o \
-	sa_hash_kern.o
diff --git a/drivers/scsi/ofc/openfc/Makefile b/drivers/scsi/ofc/openfc/Makefile
index 00606a2..490144d 100644
--- a/drivers/scsi/ofc/openfc/Makefile
+++ b/drivers/scsi/ofc/openfc/Makefile
@@ -4,12 +4,26 @@ EXTRA_CFLAGS += -I$(OFC_DIR)/include
 
 obj-$(CONFIG_OFC) += openfc.o
 
-openfc-y := \
+openfc-objs := \
+	crc32_le.o \
+	crc32_le_tab.o \
+	fc_disc_targ.o \
+	fc_exch.o \
+	fc_frame.o \
+	fc_local_port.o \
+	fc_port.o \
+	fc_print.o \
+	fc_remote_port.o \
+	fcs_attr.o \
+	fcs_cmd.o \
+	fc_sess.o \
+	fcs_event.o \
+	fcs_state.o \
+	fc_virt_fab.o \
 	openfc_attr.o \
 	openfc_if.o \
 	openfc_ioctl.o \
 	openfc_pkt.o \
 	openfc_scsi.o \
-	../libfc/libfc.o \
-	../libsa/libsa.o \
-	../libcrc/libcrc.o
+	sa_event.o \
+	sa_hash_kern.o
diff --git a/drivers/scsi/ofc/libcrc/crc32_le.c b/drivers/scsi/ofc/openfc/crc32_le.c
similarity index 100%
rename from drivers/scsi/ofc/libcrc/crc32_le.c
rename to drivers/scsi/ofc/openfc/crc32_le.c
diff --git a/drivers/scsi/ofc/libcrc/crc32_le_tab.c b/drivers/scsi/ofc/openfc/crc32_le_tab.c
similarity index 100%
rename from drivers/scsi/ofc/libcrc/crc32_le_tab.c
rename to drivers/scsi/ofc/openfc/crc32_le_tab.c
diff --git a/drivers/scsi/ofc/libfc/fc_disc_targ.c b/drivers/scsi/ofc/openfc/fc_disc_targ.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_disc_targ.c
rename to drivers/scsi/ofc/openfc/fc_disc_targ.c
diff --git a/drivers/scsi/ofc/libfc/fc_disc_targ.h b/drivers/scsi/ofc/openfc/fc_disc_targ.h
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_disc_targ.h
rename to drivers/scsi/ofc/openfc/fc_disc_targ.h
diff --git a/drivers/scsi/ofc/libfc/fc_exch.c b/drivers/scsi/ofc/openfc/fc_exch.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_exch.c
rename to drivers/scsi/ofc/openfc/fc_exch.c
diff --git a/drivers/scsi/ofc/libfc/fc_exch_impl.h b/drivers/scsi/ofc/openfc/fc_exch_impl.h
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_exch_impl.h
rename to drivers/scsi/ofc/openfc/fc_exch_impl.h
diff --git a/drivers/scsi/ofc/libfc/fc_fcip.h b/drivers/scsi/ofc/openfc/fc_fcip.h
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_fcip.h
rename to drivers/scsi/ofc/openfc/fc_fcip.h
diff --git a/drivers/scsi/ofc/libfc/fc_frame.c b/drivers/scsi/ofc/openfc/fc_frame.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_frame.c
rename to drivers/scsi/ofc/openfc/fc_frame.c
diff --git a/drivers/scsi/ofc/libfc/fc_ils.h b/drivers/scsi/ofc/openfc/fc_ils.h
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_ils.h
rename to drivers/scsi/ofc/openfc/fc_ils.h
diff --git a/drivers/scsi/ofc/libfc/fc_local_port.c b/drivers/scsi/ofc/openfc/fc_local_port.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_local_port.c
rename to drivers/scsi/ofc/openfc/fc_local_port.c
diff --git a/drivers/scsi/ofc/libfc/fc_local_port_impl.h b/drivers/scsi/ofc/openfc/fc_local_port_impl.h
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_local_port_impl.h
rename to drivers/scsi/ofc/openfc/fc_local_port_impl.h
diff --git a/drivers/scsi/ofc/libfc/fc_port.c b/drivers/scsi/ofc/openfc/fc_port.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_port.c
rename to drivers/scsi/ofc/openfc/fc_port.c
diff --git a/drivers/scsi/ofc/libfc/fc_print.c b/drivers/scsi/ofc/openfc/fc_print.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_print.c
rename to drivers/scsi/ofc/openfc/fc_print.c
diff --git a/drivers/scsi/ofc/libfc/fc_remote_port.c b/drivers/scsi/ofc/openfc/fc_remote_port.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_remote_port.c
rename to drivers/scsi/ofc/openfc/fc_remote_port.c
diff --git a/drivers/scsi/ofc/libfc/fc_scsi.h b/drivers/scsi/ofc/openfc/fc_scsi.h
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_scsi.h
rename to drivers/scsi/ofc/openfc/fc_scsi.h
diff --git a/drivers/scsi/ofc/libfc/fc_sess.c b/drivers/scsi/ofc/openfc/fc_sess.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_sess.c
rename to drivers/scsi/ofc/openfc/fc_sess.c
diff --git a/drivers/scsi/ofc/libfc/fc_sess_impl.h b/drivers/scsi/ofc/openfc/fc_sess_impl.h
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_sess_impl.h
rename to drivers/scsi/ofc/openfc/fc_sess_impl.h
diff --git a/drivers/scsi/ofc/libfc/fc_virt_fab.c b/drivers/scsi/ofc/openfc/fc_virt_fab.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_virt_fab.c
rename to drivers/scsi/ofc/openfc/fc_virt_fab.c
diff --git a/drivers/scsi/ofc/libfc/fc_virt_fab.h b/drivers/scsi/ofc/openfc/fc_virt_fab.h
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_virt_fab.h
rename to drivers/scsi/ofc/openfc/fc_virt_fab.h
diff --git a/drivers/scsi/ofc/libfc/fc_virt_fab_impl.h b/drivers/scsi/ofc/openfc/fc_virt_fab_impl.h
similarity index 100%
rename from drivers/scsi/ofc/libfc/fc_virt_fab_impl.h
rename to drivers/scsi/ofc/openfc/fc_virt_fab_impl.h
diff --git a/drivers/scsi/ofc/libfc/fcs_attr.c b/drivers/scsi/ofc/openfc/fcs_attr.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fcs_attr.c
rename to drivers/scsi/ofc/openfc/fcs_attr.c
diff --git a/drivers/scsi/ofc/libfc/fcs_cmd.c b/drivers/scsi/ofc/openfc/fcs_cmd.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fcs_cmd.c
rename to drivers/scsi/ofc/openfc/fcs_cmd.c
diff --git a/drivers/scsi/ofc/libfc/fcs_event.c b/drivers/scsi/ofc/openfc/fcs_event.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fcs_event.c
rename to drivers/scsi/ofc/openfc/fcs_event.c
diff --git a/drivers/scsi/ofc/libfc/fcs_state.c b/drivers/scsi/ofc/openfc/fcs_state.c
similarity index 100%
rename from drivers/scsi/ofc/libfc/fcs_state.c
rename to drivers/scsi/ofc/openfc/fcs_state.c
diff --git a/drivers/scsi/ofc/libfc/fcs_state_impl.h b/drivers/scsi/ofc/openfc/fcs_state_impl.h
similarity index 100%
rename from drivers/scsi/ofc/libfc/fcs_state_impl.h
rename to drivers/scsi/ofc/openfc/fcs_state_impl.h
diff --git a/drivers/scsi/ofc/libsa/sa_event.c b/drivers/scsi/ofc/openfc/sa_event.c
similarity index 100%
rename from drivers/scsi/ofc/libsa/sa_event.c
rename to drivers/scsi/ofc/openfc/sa_event.c
diff --git a/drivers/scsi/ofc/libsa/sa_hash_kern.c b/drivers/scsi/ofc/openfc/sa_hash_kern.c
similarity index 100%
rename from drivers/scsi/ofc/libsa/sa_hash_kern.c
rename to drivers/scsi/ofc/openfc/sa_hash_kern.c

