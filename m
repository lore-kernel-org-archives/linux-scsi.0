From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH 2/4] aic7xxx: fix aicasm out-of-tree build
Date: Sat, 29 Jul 2017 03:01:57 +0200
Message-ID: <ee5449064a4a40b0de286bc222814b53c3a5b2cf.1501288712.git.mirq-linux@rere.qmqm.pl>
References: <cover.1501288712.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([91.227.64.183]:60658 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753131AbdG2BB7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 21:01:59 -0400
In-Reply-To: <cover.1501288712.git.mirq-linux@rere.qmqm.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Fix out-of-tree build with CONFIG_PREVENT_FIRMWARE_BUILD=n.

[...]
make[3]: *** No rule to make target 'drivers/scsi/aic7xxx/aicasm/*.[chyl]', needed by 'drivers/scsi/aic7xxx/aicasm/aicasm'.  Stop.
/mnt/src/jaja/git/scsi-upstream/Makefile:1682: recipe for target 'drivers/scsi/aic7xxx/' failed
make[2]: *** [drivers/scsi/aic7xxx/] Error 2
[...]

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/scsi/aic7xxx/Makefile        | 36 ++++++++++++++++++------------------
 drivers/scsi/aic7xxx/aicasm/Makefile |  3 ++-
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index 741d81861d17..d76cbbba795d 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -47,39 +47,39 @@ clean-files += aic79xx_seq.h aic79xx_reg.h aic79xx_reg_print.c
 $(addprefix $(obj)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h $(obj)/aic7xxx_reg.h
 $(addprefix $(obj)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h $(obj)/aic79xx_reg.h
 
-aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:= $(obj)/aic7xxx_reg.h
+aicasm-src := $(if $(KBUILD_SRC),$(srctree)/)$(src)
+
+aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:= $(obj)/aic7xxx_reg.h \
+						   $(obj)/aic7xxx_seq.h
 aic7xxx-gen-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT)	+= $(obj)/aic7xxx_reg_print.c
 
 aicasm-7xxx-opts-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT) := \
 	-p $(obj)/aic7xxx_reg_print.c -i aic7xxx_osm.h
 
 ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
-$(obj)/aic7xxx_seq.h: $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
-	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic7xxx_reg.h \
+$(aic7xxx-gen-y): $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
+	$(obj)/aicasm/aicasm -I$(aicasm-src) -r $(obj)/aic7xxx_reg.h \
 			      $(aicasm-7xxx-opts-y) -o $(obj)/aic7xxx_seq.h \
-			      $(src)/aic7xxx.seq
-
-$(aic7xxx-gen-y): $(obj)/aic7xxx_seq.h
-else
-$(obj)/aic7xxx_reg_print.c: $(src)/aic7xxx_reg_print.c_shipped
+			      $(aicasm-src)/aic7xxx.seq
 endif
 
-aic79xx-gen-$(CONFIG_AIC79XX_BUILD_FIRMWARE)	:= $(obj)/aic79xx_reg.h
+aic79xx-gen-$(CONFIG_AIC79XX_BUILD_FIRMWARE)	:= $(obj)/aic79xx_reg.h \
+						   $(obj)/aic79xx_seq.h
 aic79xx-gen-$(CONFIG_AIC79XX_REG_PRETTY_PRINT)	+= $(obj)/aic79xx_reg_print.c
 
 aicasm-79xx-opts-$(CONFIG_AIC79XX_REG_PRETTY_PRINT) := \
 	-p $(obj)/aic79xx_reg_print.c -i aic79xx_osm.h
 
 ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
-$(obj)/aic79xx_seq.h: $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
-	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic79xx_reg.h \
+$(aic79xx-gen-y): $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
+	$(obj)/aicasm/aicasm -I$(aicasm-src) -r $(obj)/aic79xx_reg.h \
 			      $(aicasm-79xx-opts-y) -o $(obj)/aic79xx_seq.h \
-			      $(src)/aic79xx.seq
-
-$(aic79xx-gen-y): $(obj)/aic79xx_seq.h
-else
-$(obj)/aic79xx_reg_print.c: $(src)/aic79xx_reg_print.c_shipped
+			      $(aicasm-src)/aic79xx.seq
 endif
 
-$(obj)/aicasm/aicasm: $(src)/aicasm/*.[chyl]
-	$(MAKE) -C $(src)/aicasm
+$(obj)/aicasm/aicasm: $(aicasm-src)/aicasm/Makefile $(aicasm-src)/aicasm/*.[chyl]
+ifneq ($(KBUILD_SRC),)
+	mkdir -p $(obj)/aicasm
+	cp -ax $^ $(obj)/aicasm/
+endif
+	$(MAKE) -C $(obj)/aicasm KSRC=$(if $(KBUILD_SRC),$(aicasm-src)/aicasm,.)
diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/aicasm/Makefile
index b98c5c1056c3..29ca14d50597 100644
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -13,7 +13,7 @@ SRCS=	${CSRCS} ${GENSRCS}
 LIBS=	-ldb
 clean-files:= ${GENSRCS} ${GENHDRS} $(YSRCS:.y=.output) $(PROG)
 # Override default kernel CFLAGS.  This is a userland app.
-AICASM_CFLAGS:= -I/usr/include -I.
+AICASM_CFLAGS:= -I/usr/include -I. -I$(KSRC)
 LEX= flex
 YACC= bison
 YFLAGS= -d
@@ -50,6 +50,7 @@ aicdb.h:
 		echo "#include <db_185.h>" > aicdb.h;		\
 	 else							\
 		echo "*** Install db development libraries";	\
+		false;						\
 	 fi
 
 clean:
-- 
2.11.0
