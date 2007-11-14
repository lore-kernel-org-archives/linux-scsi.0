From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Add missing $(obj) to aic7xxx makefile
Date: Wed, 14 Nov 2007 21:30:46 +0100
Message-ID: <20071114203046.GA10669@uranus.ravnborg.org>
References: <1193398273.8993.8.camel@grianne>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:52151 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176AbXKNU3I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2007 15:29:08 -0500
Content-Disposition: inline
In-Reply-To: <1193398273.8993.8.camel@grianne>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-scsi@vger.kernel.org

Hi Vegard.

I had to modify the patch to make it actually work
reliable with "make drivers/scsi/ -j".
I have applied the below to kbuild.git.

linux-scsi cc'ed - please let me know if you prefer
to take it via scsi tree.

	Sam

commit c102f89b1e35c793a3483c67bce6b28a9adb7f2f
Author: Vegard Nossum <vegard.nossum@gmail.com>
Date:   Fri Oct 26 13:31:13 2007 +0200

    aic7(3*x): fix firmware build
    
    This patch adds the proper $(obj) and $(src) prefixes to dependency
    rules in aic7xxx makefile. Without this patch, there is a remote
    possibility that parallel make with a different output directory can
    fail.
    
    Also changed the deprecated EXTRA_CFLAGS construct to ccflags-y syntax.
    
    Fixed up patch to survive "make drivers/scsi/ -j"
    with BUILD_FIRMWARE enable. /Sam
    
    Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
    Cc: linux-scsi@vger.kernel.org

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index 9a6ce19..6b3aee3 100644
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
@@ -47,52 +46,42 @@ clean-files += aic79xx_seq.h aic79xx_reg.h aic79xx_reg_print.c
 
 $(obj)/aic7xxx_core.o: $(obj)/aic7xxx_seq.h
 $(obj)/aic79xx_core.o: $(obj)/aic79xx_seq.h
-$(obj)/aic79xx_reg_print.c: $(src)/aic79xx_reg_print.c_shipped
-$(obj)/aic7xxx_reg_print.c: $(src)/aic7xxx_reg_print.c_shipped
 
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
