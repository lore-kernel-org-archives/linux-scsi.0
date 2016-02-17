From: Michal Marek <mmarek@suse.cz>
Subject: Re: aicasm: fix kbuild for separated build directories
Date: Thu, 18 Feb 2016 00:46:04 +0100
Message-ID: <20160217234604.GA16500@pobox.suse.cz>
References: <1455316946.2396.65.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422955AbcBQXqI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Feb 2016 18:46:08 -0500
Content-Disposition: inline
In-Reply-To: <1455316946.2396.65.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Feb 12, 2016 at 02:42:26PM -0800, James Bottomley wrote:
> I've recently been experimenting with building in emulated architecture
> containers which allow me to build natively on my laptop a kernel for
> any architecture which qemu will emulate.  To do this, I've been
> building into build/$(uname -m) and this caused the aicasm stuff to
> fail to build (using CONFIG_AIC7XXX_BUILD_FIRMWARE=y).  I think this
> patch corrects the problem, but I'm not hugely familiar with the kbuild
> infrastructure so I cc'd an expert for a second opinion.

Hi James,

Sorry for the late reply. Letting kbuild handle the aicasm directory is
a step in the right direction. However, it still failed for me and
instead of trying to understand how the rules work, I removed them and
used the existing kbuild infrastructure. Please try the patch below on
top of yours.

Michal

>From 6d8ec207b67f51f9f54a3721b161d5b5f1b7f93e Mon Sep 17 00:00:00 2001
From: Michal Marek <mmarek@suse.com>
Date: Thu, 18 Feb 2016 00:26:39 +0100
Subject: [PATCH] aicasm: Convert Makefile to a regular kbuild file

Use the existing infrastructure to generate the lexer and parser and
compile the aicasm binary.

This patch should be followed by

  make REGENERATE_PARSERS=1 drivers/scsi/aic7xxx/
  git add drivers/scsi/aic7xxx/aicasm/*_shipped
  git commit

This is what we do in other places, to be able to build the kernel
without flex/bison.

Signed-off-by: Michal Marek <mmarek@suse.com>
---
 drivers/scsi/aic7xxx/aicasm/Makefile            | 74 ++++++-------------------
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l |  2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l       |  2 +-
 3 files changed, 18 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/aicasm/Makefile
index 73559f0..c132d8a 100644
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -1,43 +1,25 @@
-PROG=	$(obj)/aicasm
+all: $(obj)/aicasm
 
-all: $(PROG)
+hostprogs-y += aicasm
+aicasm-objs := aicasm.o aicasm_symbol.o \
+	aicasm_scan.lex.o aicasm_macro_scan.lex.o \
+	aicasm_gram.tab.o aicasm_macro_gram.tab.o
 
-.SUFFIXES= .l .y .c .h
+clean-files := aicasm_scan.lex.c aicasm_macro_scan.lex.c \
+	aicasm_gram.tab.c aicasm_gram.tab.h \
+	aicasm_macro_gram.tab.c aicasm_macro_gram.tab.h \
+	aicdb.h
 
-CSRCS=	$(srctree)/$(src)/aicasm.c $(srctree)/$(src)/aicasm_symbol.c
-YSRCS=	$(src)/aicasm_gram.y $(src)/aicasm_macro_gram.y
-LSRCS=	$(src)/aicasm_scan.l $(src)/aicasm_macro_scan.l
+$(obj)/aicasm_symbol.o: $(obj)/aicdb.h
 
-GENHDRS=	$(obj)/aicdb.h $(patsubst $(src)/%.y,$(obj)/%.h,$(YSRCS))
-GENSRCS=	$(patsubst $(src)/%.y,$(obj)/%.c,$(YSRCS)) \
-		$(patsubst $(src)/%.l,$(obj)/%.c,$(LSRCS))
+$(obj)/aicasm_scan.lex.o: $(obj)/aicasm_gram.tab.h
 
-SRCS=	$(CSRCS) $(GENSRCS)
-LIBS=	-ldb
-clean-files:= ${GENSRCS} ${GENHDRS} $(YSRCS:.y=.output) $(PROG)
-# Override default kernel CFLAGS.  This is a userland app.
-AICASM_CFLAGS:= -I/usr/include -I. -I$(srctree)/$(src)
-LEX= flex
-YACC= bison
-YFLAGS= -d
+$(obj)/aicasm_macro_scan.lex.o: $(obj)/aicasm_macro_gram.tab.h
 
-NOMAN=	noman
-
-ifneq ($(HOSTCC),)
-AICASM_CC= $(HOSTCC)
-else
-AICASM_CC= $(CC)
-endif
-
-ifdef DEBUG
-CFLAGS+= -DDEBUG -g
-YFLAGS+= -t -v
-LFLAGS= -d
-endif
-
-$(PROG): $(GENHDRS) $(SRCS)
-	echo "SRCS=$(SRCS)"
-	$(AICASM_CC) $(AICASM_CFLAGS) $(SRCS) -o $@ $(LIBS)
+HOSTLOADLIBES_aicasm += -ldb
+HOST_EXTRACFLAGS := -I$(src)
+LEX_PREFIX_aicasm_macro_scan  := mm
+YACC_PREFIX_aicasm_macro_gram := mm
 
 $(obj)/aicdb.h:
 	@if [ -e "/usr/include/db4/db_185.h" ]; then		\
@@ -56,27 +38,3 @@ $(obj)/aicdb.h:
 		echo "*** Install db development libraries";	\
 	 fi
 
-clean:
-	rm -f $(clean-files)
-
-# Create a dependency chain in generated files
-# to avoid concurrent invocations of the single
-# rule that builds them all.
-$(obj)/aicasm_gram.c $(obj)/aicasm_gram.h: $(src)/aicasm_gram.y
-	$(YACC) $(YFLAGS) -b $(@:.h=) $<
-	mv $(@:.h=).tab.c $(@:.h=.c)
-	mv $(@:.h=).tab.h $(@:.y=.h)
-
-# Create a dependency chain in generated files
-# to avoid concurrent invocations of the single
-# rule that builds them all.
-$(obj)/aicasm_macro_gram.c $(obj)/aicasm_macro_gram.h: $(src)/aicasm_macro_gram.y
-	$(YACC) $(YFLAGS) -b $(@:.h=) -p mm $<
-	mv $(@:.h=).tab.c $(@:.h=.c)
-	mv $(@:.h=).tab.h $(@:.h=.h)
-
-$(obj)/aicasm_scan.c: $(src)/aicasm_scan.l
-	$(LEX) $(LFLAGS) -o$@ $<
-
-$(obj)/aicasm_macro_scan.c: $(src)/aicasm_macro_scan.l
-	$(LEX) $(LFLAGS) -Pmm -o$@ $<
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
index c0457b8..aa7316c 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_scan.l
@@ -59,7 +59,7 @@
 
 #include "aicasm.h"
 #include "aicasm_symbol.h"
-#include "aicasm_macro_gram.h"
+#include "aicasm_macro_gram.tab.h"
 
 #define MAX_STR_CONST 4096
 static char string_buf[MAX_STR_CONST];
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
index 93c8667..4e08095 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -59,7 +59,7 @@
 
 #include "aicasm.h"
 #include "aicasm_symbol.h"
-#include "aicasm_gram.h"
+#include "aicasm_gram.tab.h"
 
 /* This is used for macro body capture too, so err on the large size. */
 #define MAX_STR_CONST 4096
-- 
1.9.2

