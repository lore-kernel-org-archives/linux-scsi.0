From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: qla2xxx and feral ISP updates in their respective BK trees
Date: Thu, 19 Jun 2003 08:51:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030619155116.GA23092@praka.local.home>
References: <1055971780.2075.484.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MGYHOYXEY6WxJCY8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls02.socal.rr.com ([66.75.160.17]:2470 "EHLO
	orngca-mls02.socal.rr.com") by vger.kernel.org with ESMTP
	id S265416AbTFSQfP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jun 2003 12:35:15 -0400
Received: from san.rr.com (66-75-128-22.san.rr.com [66.75.128.22])
	by orngca-mls02.socal.rr.com (8.11.4/8.11.3) with ESMTP id h5JGjmk00437
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2003 09:45:48 -0700 (PDT)
Received: from san.rr.com (localhost [127.0.0.1])
	by san.rr.com (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id h5JFpIvl023164
	for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2003 08:51:19 -0700
Received: (from praka@localhost)
	by san.rr.com (8.12.3/8.12.3/Submit) id h5JFpHHP023163
	for linux-scsi@vger.kernel.org; Thu, 19 Jun 2003 08:51:17 -0700
Content-Disposition: inline
In-Reply-To: <1055971780.2075.484.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, 18 Jun 2003, James Bottomley wrote:

> I've tried building these:
> 
> Qlogic:
> 
> qla2100 still refuses to build, which is the only FC card I have.
> 

Attached is a small patch against 8.00.00b3 that should get the
qla2100 driver to build properly -- some residual ip codes that are
not valid with isp2100 chips.

> Also, I could do with the directory tree being laid out in a
> standard fashion (i.e. with the docs under Documentation/scsi like
> I've done in the BK tree).
>

I'll make the changes before I release 8.00.00b4 (RSN).

--
Andrew Vasquez

--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2100_build_fix-v8.00.00b3.diff"

diff -X ../../dontdiff -Nurd 80000b3/Makefile 80000b3_isp2100/Makefile
--- 80000b3/Makefile	2003-05-30 09:11:11.000000000 -0700
+++ 80000b3_isp2100/Makefile	2003-06-19 08:59:59.045535864 -0700
@@ -5,33 +5,45 @@
 ISPTYPES := qla2100 qla2200 qla2300
 ISPDIRS := $(foreach dir, $(ISPTYPES), $(addsuffix /, $(addprefix .,$(dir))))
 
-ISP2100_FW := ql2100tp_fw.o
-ISP2200_FW := ql2200ip_fw.o
-ISP2300_FW := ql2300ipx_fw.o #ql2322tpx_fw.o
-
 COMMON_SRCS := qla_os.c qla_init.c qla_mbx.c qla_iocb.c qla_isr.c qla_xioct.c \
-	 qla_inioct.c qla_ip.c qla_fo.c qla_cfg.c qla_cfgln.c qla_vendor.c \
-	 qla_dbg.c qla_sup.c 
-COMMON_OBJS := $(foreach file, $(COMMON_SRCS), $(patsubst %.c, %.o, $(file)))
+	qla_inioct.c qla_fo.c qla_cfg.c qla_cfgln.c qla_vendor.c qla_dbg.c qla_sup.c 
+ISP2100_SRCS := $(COMMON_SRCS) ql2100tp_fw.c
+ISP2200_SRCS := $(COMMON_SRCS) qla_ip.c ql2200ip_fw.c
+ISP2300_SRCS := $(COMMON_SRCS) qla_ip.c ql2300ipx_fw.c #ql2322tpx_fw.c
+ISP2100_OBJS := $(foreach file, $(ISP2100_SRCS), $(patsubst %.c, %.o, $(file)))
+ISP2200_OBJS := $(foreach file, $(ISP2200_SRCS), $(patsubst %.c, %.o, $(file)))
+ISP2300_OBJS := $(foreach file, $(ISP2300_SRCS), $(patsubst %.c, %.o, $(file)))
 
-ISP2100_DIR_SRCS := $(foreach file, $(COMMON_SRCS), $(addprefix .qla2100/,$(file)))
-ISP2100_DIR_OBJS := $(foreach file, $(COMMON_OBJS), $(addprefix .qla2100/,$(file)))
-ISP2200_DIR_SRCS := $(foreach file, $(COMMON_SRCS), $(addprefix .qla2200/,$(file)))
-ISP2200_DIR_OBJS := $(foreach file, $(COMMON_OBJS), $(addprefix .qla2200/,$(file)))
-ISP2300_DIR_SRCS := $(foreach file, $(COMMON_SRCS), $(addprefix .qla2300/,$(file)))
-ISP2300_DIR_OBJS := $(foreach file, $(COMMON_OBJS), $(addprefix .qla2300/,$(file)))
+ISP2100_DIR_SRCS := $(foreach file, $(ISP2100_SRCS), $(addprefix .qla2100/,$(file)))
+ISP2200_DIR_SRCS := $(foreach file, $(ISP2200_SRCS), $(addprefix .qla2200/,$(file)))
+ISP2300_DIR_SRCS := $(foreach file, $(ISP2300_SRCS), $(addprefix .qla2300/,$(file)))
+ISP2100_DIR_OBJS := $(foreach file, $(ISP2100_OBJS), $(addprefix .qla2100/,$(file)))
+ISP2200_DIR_OBJS := $(foreach file, $(ISP2200_OBJS), $(addprefix .qla2200/,$(file)))
+ISP2300_DIR_OBJS := $(foreach file, $(ISP2300_OBJS), $(addprefix .qla2300/,$(file)))
 
 PREPALL := $(shell for dir in $(ISPDIRS) ; \
 	do \
 		if [ ! -d $(obj)/$${dir} ] ; then \
 			mkdir $(obj)/$${dir} ; \
 		fi ; \
-	 	for link in $(foreach file, $(COMMON_OBJS), $(patsubst %.o, %.c, $(file))) ; \
-	 	do \
-			if [ ! -h $(obj)/$${dir}$${link} ] ; then \
-				ln -sf ../$${link} $(obj)/$${dir}$${link} ; \
-			fi ; \
-	 	done \
+	done ; \
+	for link in $(ISP2100_SRCS) ; \
+	do \
+		if [ ! -h $(obj)/.qla2100/$${link} ] ; then \
+			ln -sf ../$${link} $(obj)/.qla2100/$${link} ; \
+		fi ; \
+	done ; \
+	for link in $(ISP2200_SRCS) ; \
+	do \
+		if [ ! -h $(obj)/.qla2200/$${link} ] ; then \
+			ln -sf ../$${link} $(obj)/.qla2200/$${link} ; \
+		fi ; \
+	done ; \
+	for link in $(ISP2300_SRCS) ; \
+	do \
+		if [ ! -h $(obj)/.qla2300/$${link} ] ; then \
+			ln -sf ../$${link} $(obj)/.qla2300/$${link} ; \
+		fi ; \
 	done)
 
 obj-$(CONFIG_SCSI_QLA2XXX_QLA21XX) += qla2100.o
@@ -46,8 +58,8 @@
 $(src)/.qla2200/%: EXTRA_CFLAGS += -Dqla22xx
 $(src)/.qla2300/%: EXTRA_CFLAGS += -Dqla23xx -DEXTENDED_IDS 
 
-qla2100-objs := $(ISP2100_DIR_OBJS) $(ISP2100_FW) 
-qla2200-objs := $(ISP2200_DIR_OBJS) $(ISP2200_FW) 
-qla2300-objs := $(ISP2300_DIR_OBJS) $(ISP2300_FW) 
+qla2100-objs := $(ISP2100_DIR_OBJS)
+qla2200-objs := $(ISP2200_DIR_OBJS)
+qla2300-objs := $(ISP2300_DIR_OBJS)
 
 clean-files := $(ISP2100_DIR_SRCS) $(ISP2200_DIR_SRCS) $(ISP2300_DIR_SRCS)
diff -X ../../dontdiff -Nurd 80000b3/qla_def.h 80000b3_isp2100/qla_def.h
--- 80000b3/qla_def.h	2003-05-30 09:11:11.000000000 -0700
+++ 80000b3_isp2100/qla_def.h	2003-06-19 08:53:58.179395856 -0700
@@ -60,6 +60,7 @@
 #include "exioct.h"
 #include "inioct.h"
 
+#if !defined(ISP2100)
 #define FC_IP_SUPPORT
 #if defined(FC_IP_SUPPORT)
 #include <linux/ip.h>
@@ -67,6 +68,7 @@
 #include <linux/skbuff.h>
 #include "qla_ip.h"
 #endif
+#endif
 
 
 /* 

--MGYHOYXEY6WxJCY8--
