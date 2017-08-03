From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH v2 2/5] aic7xxx: fix firmware build deps
Date: Fri, 04 Aug 2017 01:28:08 +0200
Message-ID: <f97a697901a5a5ada4d8d1c5c0cce3c160f7f5e7.1501802727.git.mirq-linux@rere.qmqm.pl>
References: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([91.227.64.183]:35128 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751926AbdHCX2K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Aug 2017 19:28:10 -0400
In-Reply-To: <cover.1501802726.git.mirq-linux@rere.qmqm.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

We need to override Kbuild rules for copying shipped files, otherwise
aic7xxx_reg.h and aic7xxx_reg_print.c will be ovewritten by old versions.

Fixes: 516b7db593f3a541e2e98867575c3c697f41a247
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/scsi/aic7xxx/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index 07b60a780c06..b03ba0df7a83 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -59,7 +59,8 @@ $(obj)/aic7xxx_seq.h: $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
 			      $(aicasm-7xxx-opts-y) -o $(obj)/aic7xxx_seq.h \
 			      $(srctree)/$(src)/aic7xxx.seq
 
-$(aic7xxx-gen-y): $(obj)/aic7xxx_seq.h
+$(aic7xxx-gen-y): $(objtree)/$(obj)/aic7xxx_seq.h
+	@true
 else
 $(obj)/aic7xxx_reg_print.c: $(src)/aic7xxx_reg_print.c_shipped
 endif
@@ -76,7 +77,8 @@ $(obj)/aic79xx_seq.h: $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
 			      $(aicasm-79xx-opts-y) -o $(obj)/aic79xx_seq.h \
 			      $(srctree)/$(src)/aic79xx.seq
 
-$(aic79xx-gen-y): $(obj)/aic79xx_seq.h
+$(aic79xx-gen-y): $(objtree)/$(obj)/aic79xx_seq.h
+	@true
 else
 $(obj)/aic79xx_reg_print.c: $(src)/aic79xx_reg_print.c_shipped
 endif
-- 
2.11.0
