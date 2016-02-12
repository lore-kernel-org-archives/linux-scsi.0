From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: aicasm: fix kbuild for separated build directories
Date: Fri, 12 Feb 2016 14:42:26 -0800
Message-ID: <1455316946.2396.65.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47686 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbcBLWmd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 17:42:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>

I've recently been experimenting with building in emulated architecture
containers which allow me to build natively on my laptop a kernel for
any architecture which qemu will emulate.  To do this, I've been
building into build/$(uname -m) and this caused the aicasm stuff to
fail to build (using CONFIG_AIC7XXX_BUILD_FIRMWARE=y).  I think this
patch corrects the problem, but I'm not hugely familiar with the kbuild
infrastructure so I cc'd an expert for a second opinion.

James

---

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefile
index 741d818..c21c922 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -5,7 +5,7 @@
 #
 
 # Let kbuild descend into aicasm when cleaning
-subdir-				+= aicasm
+subdir-				+= aicasm/
 
 obj-$(CONFIG_SCSI_AIC7XXX)	+= aic7xxx.o
 obj-$(CONFIG_SCSI_AIC79XX)	+= aic79xx.o
@@ -55,9 +55,9 @@ aicasm-7xxx-opts-$(CONFIG_AIC7XXX_REG_PRETTY_PRINT) := \
 
 ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
 $(obj)/aic7xxx_seq.h: $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
-	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic7xxx_reg.h \
+	$(obj)/aicasm/aicasm -I$(srctree)/$(src) -r $(obj)/aic7xxx_reg.h \
 			      $(aicasm-7xxx-opts-y) -o $(obj)/aic7xxx_seq.h \
-			      $(src)/aic7xxx.seq
+			      $(srctree)/$(src)/aic7xxx.seq
 
 $(aic7xxx-gen-y): $(obj)/aic7xxx_seq.h
 else
@@ -72,14 +72,14 @@ aicasm-79xx-opts-$(CONFIG_AIC79XX_REG_PRETTY_PRINT) := \
 
 ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
 $(obj)/aic79xx_seq.h: $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
-	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic79xx_reg.h \
-			      $(aicasm-79xx-opts-y) -o $(obj)/aic79xx_seq.h \
-			      $(src)/aic79xx.seq
+	$(obj)/aicasm/aicasm -I$(srctree)/$(src) -r $(obj)/aic79xx_reg.h \
+			      $(aicasm-79xx-opts-y) -o $@ \
+			      $(srctree)/$(src)/aic79xx.seq
 
 $(aic79xx-gen-y): $(obj)/aic79xx_seq.h
 else
 $(obj)/aic79xx_reg_print.c: $(src)/aic79xx_reg_print.c_shipped
 endif
 
-$(obj)/aicasm/aicasm: $(src)/aicasm/*.[chyl]
-	$(MAKE) -C $(src)/aicasm
+$(obj)/aicasm/aicasm:
+	$(Q)$(MAKE) $(build)=drivers/scsi/aic7xxx/aicasm all
diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/aicasm/Makefile
index b98c5c1..73559f0 100644
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -1,19 +1,22 @@
-PROG=	aicasm
+PROG=	$(obj)/aicasm
+
+all: $(PROG)
 
 .SUFFIXES= .l .y .c .h
 
-CSRCS=	aicasm.c aicasm_symbol.c
-YSRCS=	aicasm_gram.y aicasm_macro_gram.y
-LSRCS=	aicasm_scan.l aicasm_macro_scan.l
+CSRCS=	$(srctree)/$(src)/aicasm.c $(srctree)/$(src)/aicasm_symbol.c
+YSRCS=	$(src)/aicasm_gram.y $(src)/aicasm_macro_gram.y
+LSRCS=	$(src)/aicasm_scan.l $(src)/aicasm_macro_scan.l
 
-GENHDRS=	aicdb.h $(YSRCS:.y=.h)
-GENSRCS=	$(YSRCS:.y=.c) $(LSRCS:.l=.c)
+GENHDRS=	$(obj)/aicdb.h $(patsubst $(src)/%.y,$(obj)/%.h,$(YSRCS))
+GENSRCS=	$(patsubst $(src)/%.y,$(obj)/%.c,$(YSRCS)) \
+		$(patsubst $(src)/%.l,$(obj)/%.c,$(LSRCS))
 
-SRCS=	${CSRCS} ${GENSRCS}
+SRCS=	$(CSRCS) $(GENSRCS)
 LIBS=	-ldb
 clean-files:= ${GENSRCS} ${GENHDRS} $(YSRCS:.y=.output) $(PROG)
 # Override default kernel CFLAGS.  This is a userland app.
-AICASM_CFLAGS:= -I/usr/include -I.
+AICASM_CFLAGS:= -I/usr/include -I. -I$(srctree)/$(src)
 LEX= flex
 YACC= bison
 YFLAGS= -d
@@ -32,22 +35,23 @@ YFLAGS+= -t -v
 LFLAGS= -d
 endif
 
-$(PROG):  ${GENHDRS} $(SRCS)
-	$(AICASM_CC) $(AICASM_CFLAGS) $(SRCS) -o $(PROG) $(LIBS)
+$(PROG): $(GENHDRS) $(SRCS)
+	echo "SRCS=$(SRCS)"
+	$(AICASM_CC) $(AICASM_CFLAGS) $(SRCS) -o $@ $(LIBS)
 
-aicdb.h:
+$(obj)/aicdb.h:
 	@if [ -e "/usr/include/db4/db_185.h" ]; then		\
-		echo "#include <db4/db_185.h>" > aicdb.h;	\
+		echo "#include <db4/db_185.h>" > $(obj)/aicdb.h;	\
 	 elif [ -e "/usr/include/db3/db_185.h" ]; then		\
-		echo "#include <db3/db_185.h>" > aicdb.h;	\
+		echo "#include <db3/db_185.h>" > $(obj)/aicdb.h;	\
 	 elif [ -e "/usr/include/db2/db_185.h" ]; then		\
-		echo "#include <db2/db_185.h>" > aicdb.h;	\
+		echo "#include <db2/db_185.h>" > $(obj)/aicdb.h;	\
 	 elif [ -e "/usr/include/db1/db_185.h" ]; then		\
-		echo "#include <db1/db_185.h>" > aicdb.h;	\
+		echo "#include <db1/db_185.h>" > $(obj)/aicdb.h;	\
 	 elif [ -e "/usr/include/db/db_185.h" ]; then		\
-		echo "#include <db/db_185.h>" > aicdb.h;	\
+		echo "#include <db/db_185.h>" > $(obj)/aicdb.h;	\
 	 elif [ -e "/usr/include/db_185.h" ]; then		\
-		echo "#include <db_185.h>" > aicdb.h;		\
+		echo "#include <db_185.h>" > $(obj)/aicdb.h;		\
 	 else							\
 		echo "*** Install db development libraries";	\
 	 fi
@@ -58,23 +62,21 @@ clean:
 # Create a dependency chain in generated files
 # to avoid concurrent invocations of the single
 # rule that builds them all.
-aicasm_gram.c: aicasm_gram.h
-aicasm_gram.c aicasm_gram.h: aicasm_gram.y
-	$(YACC) $(YFLAGS) -b $(<:.y=) $<
-	mv $(<:.y=).tab.c $(<:.y=.c)
-	mv $(<:.y=).tab.h $(<:.y=.h)
+$(obj)/aicasm_gram.c $(obj)/aicasm_gram.h: $(src)/aicasm_gram.y
+	$(YACC) $(YFLAGS) -b $(@:.h=) $<
+	mv $(@:.h=).tab.c $(@:.h=.c)
+	mv $(@:.h=).tab.h $(@:.y=.h)
 
 # Create a dependency chain in generated files
 # to avoid concurrent invocations of the single
 # rule that builds them all.
-aicasm_macro_gram.c: aicasm_macro_gram.h
-aicasm_macro_gram.c aicasm_macro_gram.h: aicasm_macro_gram.y
-	$(YACC) $(YFLAGS) -b $(<:.y=) -p mm $<
-	mv $(<:.y=).tab.c $(<:.y=.c)
-	mv $(<:.y=).tab.h $(<:.y=.h)
+$(obj)/aicasm_macro_gram.c $(obj)/aicasm_macro_gram.h: $(src)/aicasm_macro_gram.y
+	$(YACC) $(YFLAGS) -b $(@:.h=) -p mm $<
+	mv $(@:.h=).tab.c $(@:.h=.c)
+	mv $(@:.h=).tab.h $(@:.h=.h)
 
-aicasm_scan.c: aicasm_scan.l
+$(obj)/aicasm_scan.c: $(src)/aicasm_scan.l
 	$(LEX) $(LFLAGS) -o$@ $<
 
-aicasm_macro_scan.c: aicasm_macro_scan.l
+$(obj)/aicasm_macro_scan.c: $(src)/aicasm_macro_scan.l
 	$(LEX) $(LFLAGS) -Pmm -o$@ $<
