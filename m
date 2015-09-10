From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -resend 1/1] cxgbi: fix build with EXTRA_CFLAGS
Date: Thu, 10 Sep 2015 09:32:35 +0200
Message-ID: <1441870355-25237-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbbIJHci (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2015 03:32:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kxie@chelsio.com, linux-scsi@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>

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
2.5.1

