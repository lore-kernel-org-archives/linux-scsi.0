From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] cxgbi: fix build with EXTRA_CFLAGS
Date: Tue,  9 Jun 2015 14:19:12 +0200
Message-ID: <1433852352-32043-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Odin.com
Cc: kxie@chelsio.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
List-Id: linux-scsi@vger.kernel.org

EXTRA_CFLAGS are intended to be used on the command line, not by
Kbuild. In case of cxgbi drivers, use of EXTRA_CFLAGS results in a
compilation failure:
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:24:21: fatal error: t4_regs.h: No such file or directory
when building like:
$ make drivers/scsi/cxgbi/ EXTRA_CFLAGS=-Wwhatever

Use ccflags-y instead of EXTRA_CFLAGS.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/cxgbi/cxgb3i/Kbuild | 2 +-
 drivers/scsi/cxgbi/cxgb4i/Kbuild | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/Kbuild b/drivers/scsi/cxgbi/cxgb3i/Kbuild
index 6f095e28a974..961a12f6d318 100644
--- a/drivers/scsi/cxgbi/cxgb3i/Kbuild
+++ b/drivers/scsi/cxgbi/cxgb3i/Kbuild
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
+ccflags-y += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
 
 obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
diff --git a/drivers/scsi/cxgbi/cxgb4i/Kbuild b/drivers/scsi/cxgbi/cxgb4i/Kbuild
index 8290cdaa4652..37458643749b 100644
--- a/drivers/scsi/cxgbi/cxgb4i/Kbuild
+++ b/drivers/scsi/cxgbi/cxgb4i/Kbuild
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
+ccflags-y += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
 
 obj-$(CONFIG_SCSI_CXGB4_ISCSI) += cxgb4i.o
-- 
2.4.2
