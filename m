From: Rusty Trivial Russell <trivial@rustcorp.com.au>
Subject: [TRIVIAL] fix parallel builds for aic7xxx]
Date: Wed, 24 Sep 2003 12:56:01 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030924032922.BE68C2C21F@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:61643 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S261458AbTIXD3X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2003 23:29:23 -0400
List-Id: linux-scsi@vger.kernel.org
To: Justin Gibbs <gibbs@btc.adaptec.com>, Kai Germaschewski <kai@tp1.ruhr-uni-bochum.de>, linux-scsi@vger.kernel.org, axboe@suse.de
Cc: John Cherry <cherry@osdl.org>

[ Sorry, did you guys end up with consensus on this?  Should I forward
  or drop?  Thanks, Rusty ]

From:  John Cherry <cherry@osdl.org>

  My compile regression scripts were getting random build failures for
  aic7xxx.  The two makefiles could not handle parallel build. 
  Occasionally they would succeed...timing dependent.  The following two
  patches fix this.
  
  Part 1 - drivers/scsi/aic7xxx/Makefile
  Part 2 - drivers/scsi/aic7xxx/aicasm/Makefile
  
  John
   

--- trivial-2.6.0-test5-bk10/drivers/scsi/aic7xxx/Makefile.orig	2003-09-24 12:27:20.000000000 +1000
+++ trivial-2.6.0-test5-bk10/drivers/scsi/aic7xxx/Makefile	2003-09-24 12:27:20.000000000 +1000
@@ -58,7 +58,9 @@
 	-p $(obj)/aic7xxx_reg_print.c -i aic7xxx_osm.h
 
 ifeq ($(CONFIG_AIC7XXX_BUILD_FIRMWARE),y)
-$(aic7xxx-gen-y): $(src)/aic7xxx.seq $(src)/aic7xxx.reg $(obj)/aicasm/aicasm
+$(aic7xxx-gen-y): $(src)/aic7xxx.seq 
+
+$(src)/aic7xxx.seq: $(obj)/aicasm/aicasm $(src)/aic7xxx.reg
 	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic7xxx_reg.h \
 			      $(aicasm-7xxx-opts-y) -o $(obj)/aic7xxx_seq.h \
 			      $(src)/aic7xxx.seq
@@ -72,7 +74,9 @@
 	-p $(obj)/aic79xx_reg_print.c -i aic79xx_osm.h
 
 ifeq ($(CONFIG_AIC79XX_BUILD_FIRMWARE),y)
-$(aic79xx-gen-y): $(src)/aic79xx.seq $(src)/aic79xx.reg $(obj)/aicasm/aicasm
+$(aic79xx-gen-y): $(src)/aic79xx.seq
+
+$(src)/aic79xx.seq: $(obj)/aicasm/aicasm $(src)/aic79xx.reg
 	$(obj)/aicasm/aicasm -I$(src) -r $(obj)/aic79xx_reg.h \
 			      $(aicasm-79xx-opts-y) -o $(obj)/aic79xx_seq.h \
 			      $(src)/aic79xx.seq
--- trivial-2.6.0-test5-bk10/drivers/scsi/aic7xxx/aicasm/Makefile.orig	2003-09-24 12:27:20.000000000 +1000
+++ trivial-2.6.0-test5-bk10/drivers/scsi/aic7xxx/aicasm/Makefile	2003-09-24 12:27:20.000000000 +1000
@@ -49,14 +49,18 @@
 clean:
 	rm -f $(clean-files)
 
-aicasm_gram.c aicasm_gram.h: aicasm_gram.y
+aicasm_gram.c: aicasm_gram.h 
+	mv $(<:.h=).tab.c $(<:.h=.c)
+
+aicasm_gram.h: aicasm_gram.y
 	$(YACC) $(YFLAGS) -b $(<:.y=) $<
-	mv $(<:.y=).tab.c $(<:.y=.c)
 	mv $(<:.y=).tab.h $(<:.y=.h)
 
-aicasm_macro_gram.c aicasm_macro_gram.h: aicasm_macro_gram.y
+aicasm_macro_gram.c: aicasm_macro_gram.h
+	mv $(<:.h=).tab.c $(<:.h=.c)
+
+aicasm_macro_gram.h: aicasm_macro_gram.y
 	$(YACC) $(YFLAGS) -b $(<:.y=) -p mm $<
-	mv $(<:.y=).tab.c $(<:.y=.c)
 	mv $(<:.y=).tab.h $(<:.y=.h)
 
 aicasm_scan.c: aicasm_scan.l
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: John Cherry <cherry@osdl.org>: [TRIVIAL][PATCH] fix parallel builds for aic7xxx]
