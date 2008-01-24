From: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 11/77] aic7(3*x): fix firmware build
Date: Thu, 24 Jan 2008 23:02:52 +0100
Message-ID: <1201212238-4369-11-git-send-email-sam@ravnborg.org>
References: <20080124215813.GA4204@uranus.ravnborg.org>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <20080124215813.GA4204@uranus.ravnborg.org>
Sender: linux-kbuild-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Vegard Nossum <vegard.nossum@gmail.com>

This patch adds the proper $(obj) and $(src) prefixes to dependency
rules in aic7xxx makefile. Without this patch, there is a remote
possibility that parallel make with a different output directory can
fail.

Also changed the deprecated EXTRA_CFLAGS construct to ccflags-y syntax.

Fixed up patch to survive "make drivers/scsi/ -j"
with BUILD_FIRMWARE enable. /Sam

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aic7xxx/Makefile |   45 ++++++++++++++++------------------------
 1 files changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index 9a6ce19..e4f70c5 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -33,11 +33,10 @@ aic79xx-y					+= aic79xx_osm.o	\
 						   aic79xx_proc.o	\
 						   aic79xx_osm_pci.o
 
-EXTRA_CFLAGS += -Idrivers/scsi
+ccflags-y += -Idrivers/scsi
 ifdef WARNINGS_BECOME_ERRORS
-EXTRA_CFLAGS += -Werror
+ccflags-y += -Werror
 endif
-#EXTRA_CFLAGS += -g
 
 # Files generated that shall be removed upon make clean
 clean-files := aic7xxx_seq.h aic7xxx_reg.h aic7xxx_reg_print.c
@@ -46,53 +45,45 @@ clean-files += aic79xx_seq.h aic79xx_reg.h aic79xx_reg_print.c
 # Dependencies for generated files need to be listed explicitly
 
 $(obj)/aic7xxx_core.o: $(obj)/aic7xxx_seq.h
+$(obj)/aic7xxx_core.o: $(obj)/aic7xxx_reg.h
 $(obj)/aic79xx_core.o: $(obj)/aic79xx_seq.h
-$(obj)/aic79xx_reg_print.c: $(src)/aic79xx_reg_print.c_shipped
-$(obj)/aic7xxx_reg_print.c: $(src)/aic7xxx_reg_print.c_shipped
+$(obj)/aic79xx_core.o: $(obj)/aic79xx_reg.h
 
-$(addprefix $(obj)/,$(aic7xxx-y)): $(obj)/aic7xxx_reg.h
-$(addprefix $(obj)/,$(aic79xx-y)): $(obj)/aic79xx_reg.h
+$(addprefix $(obj)/,$(aic7xxx-y)): $(obj)/aic7xxx_seq.h
+$(addprefix $(obj)/,$(aic79xx-y)): $(obj)/aic79xx_seq.h
 
-aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:= $(obj)/aic7xxx_seq.h \
-						   $(obj)/aic7xxx_reg.h
+aic7xxx-gen-$(CONFIG_AIC7XXX_BUILD_FIRMWARE)	:= $(obj)/aic7xxx_reg.h
 aic7xxx-gen-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT)	+= $(obj)/aic7xxx_reg_print.c
 
 aicasm-7xxx-opts-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT) := \
 	-p $(obj)/aic7xxx_reg_print.c -i aic7xxx_osm.h
 
 ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
-# Create a dependency chain in generated files
-# to avoid concurrent invocations of the single
-# rule that builds them all.
-aic7xxx_seq.h: aic7xxx_reg.h
-ifeq ($(CONFIG_AIC7XXX_REG_PRETTY_PRINT),y)
-aic7xxx_reg.h: aic7xxx_reg_print.c
-endif
-$(aic7xxx-gen-y): $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
+$(obj)/aic7xxx_seq.h: $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
 	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic7xxx_reg.h \
 			      $(aicasm-7xxx-opts-y) -o $(obj)/aic7xxx_seq.h \
 			      $(src)/aic7xxx.seq
+
+$(aic7xxx-gen-y): $(obj)/aic7xxx_seq.h
+else
+$(obj)/aic7xxx_reg_print.c: $(src)/aic7xxx_reg_print.c_shipped
 endif
 
-aic79xx-gen-$(CONFIG_AIC79XX_BUILD_FIRMWARE)	:= $(obj)/aic79xx_seq.h \
-						   $(obj)/aic79xx_reg.h
+aic79xx-gen-$(CONFIG_AIC79XX_BUILD_FIRMWARE)	:= $(obj)/aic79xx_reg.h
 aic79xx-gen-$(CONFIG_AIC79XX_REG_PRETTY_PRINT)	+= $(obj)/aic79xx_reg_print.c
 
 aicasm-79xx-opts-$(CONFIG_AIC79XX_REG_PRETTY_PRINT) := \
 	-p $(obj)/aic79xx_reg_print.c -i aic79xx_osm.h
 
 ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
-# Create a dependency chain in generated files
-# to avoid concurrent invocations of the single
-# rule that builds them all.
-aic79xx_seq.h: aic79xx_reg.h
-ifeq ($(CONFIG_AIC79XX_REG_PRETTY_PRINT),y)
-aic79xx_reg.h: aic79xx_reg_print.c
-endif
-$(aic79xx-gen-y): $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
+$(obj)/aic79xx_seq.h: $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
 	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic79xx_reg.h \
 			      $(aicasm-79xx-opts-y) -o $(obj)/aic79xx_seq.h \
 			      $(src)/aic79xx.seq
+
+$(aic79xx-gen-y): $(obj)/aic79xx_seq.h
+else
+$(obj)/aic79xx_reg_print.c: $(src)/aic79xx_reg_print.c_shipped
 endif
 
 $(obj)/aicasm/aicasm: $(src)/aicasm/*.[chyl]
-- 
1.5.4.rc3.14.g44397

