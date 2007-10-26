From: Vegard Nossum <vegard.nossum@gmail.com>
Subject: [PATCH] Add missing $(obj) to aic7xxx makefile
Date: Fri, 26 Oct 2007 13:31:13 +0200
Message-ID: <1193398273.8993.8.camel@grianne>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:35717 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbXJZLbT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2007 07:31:19 -0400
Received: by nf-out-0910.google.com with SMTP id g13so758839nfb
        for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 04:31:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>

Hi,

This patch adds the proper $(obj) and $(src) prefixes to dependency
rules in aic7xxx makefile. Without this patch, there is a remote
possibility that parallel make with a different output directory can
fail.

Also changed the deprecated EXTRA_CFLAGS construct to ccflags-y syntax.


Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index 9a6ce19..83c1812 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -33,11 +33,10 @@ aic79xx-y					+= aic79xx_osm.o	\
 						   aic79xx_proc.o	\
 						   aic79xx_osm_pci.o
 
-EXTRA_CFLAGS += -Idrivers/scsi
+ccflags-y += -Idrivers/scsi -I$(obj)
 ifdef WARNINGS_BECOME_ERRORS
-EXTRA_CFLAGS += -Werror
+ccflags-y += -Werror
 endif
-#EXTRA_CFLAGS += -g
 
 # Files generated that shall be removed upon make clean
 clean-files := aic7xxx_seq.h aic7xxx_reg.h aic7xxx_reg_print.c
@@ -64,9 +63,9 @@ ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
 # Create a dependency chain in generated files
 # to avoid concurrent invocations of the single
 # rule that builds them all.
-aic7xxx_seq.h: aic7xxx_reg.h
+$(obj)/aic7xxx_seq.h: $(src)/aic7xxx_reg.h
 ifeq ($(CONFIG_AIC7XXX_REG_PRETTY_PRINT),y)
-aic7xxx_reg.h: aic7xxx_reg_print.c
+$(obj)aic7xxx_reg.h: $(src)/aic7xxx_reg_print.c
 endif
 $(aic7xxx-gen-y): $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
 	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic7xxx_reg.h \
@@ -85,9 +84,9 @@ ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
 # Create a dependency chain in generated files
 # to avoid concurrent invocations of the single
 # rule that builds them all.
-aic79xx_seq.h: aic79xx_reg.h
+$(obj)/aic79xx_seq.h: $(src)/aic79xx_reg.h
 ifeq ($(CONFIG_AIC79XX_REG_PRETTY_PRINT),y)
-aic79xx_reg.h: aic79xx_reg_print.c
+$(obj)/aic79xx_reg.h: $(src)/aic79xx_reg_print.c
 endif
 $(aic79xx-gen-y): $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
 	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic79xx_reg.h \


