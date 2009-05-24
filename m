From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 10/10] osd: Remove out-of-tree left overs
Date: Sun, 24 May 2009 20:05:58 +0300
Message-ID: <1243184758-17169-1-git-send-email-bharrosh@panasas.com>
References: <4A197CB5.60709@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:1664 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754350AbZEXRF7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2009 13:05:59 -0400
In-Reply-To: <4A197CB5.60709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
Cc: Jeff Garzik <jeff@garzik.org>

* Delete Makefile. It is only used for out-of-tree compilation
  and was never needed. It slipped in by mistake.
* Remove from Kbuild all the out of tree stuff as promised.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/Kbuild   |   25 -------------------------
 drivers/scsi/osd/Makefile |   37 -------------------------------------
 2 files changed, 0 insertions(+), 62 deletions(-)
 delete mode 100755 drivers/scsi/osd/Makefile

diff --git a/drivers/scsi/osd/Kbuild b/drivers/scsi/osd/Kbuild
index 0e207aa..5fd73d7 100644
--- a/drivers/scsi/osd/Kbuild
+++ b/drivers/scsi/osd/Kbuild
@@ -11,31 +11,6 @@
 # it under the terms of the GNU General Public License version 2
 #
 
-ifneq ($(OSD_INC),)
-# we are built out-of-tree Kconfigure everything as on
-
-CONFIG_SCSI_OSD_INITIATOR=m
-ccflags-y += -DCONFIG_SCSI_OSD_INITIATOR -DCONFIG_SCSI_OSD_INITIATOR_MODULE
-
-CONFIG_SCSI_OSD_ULD=m
-ccflags-y += -DCONFIG_SCSI_OSD_ULD -DCONFIG_SCSI_OSD_ULD_MODULE
-
-# CONFIG_SCSI_OSD_DPRINT_SENSE =
-#	0 - no print of errors
-#	1 - print errors
-#	2 - errors + warrnings
-ccflags-y += -DCONFIG_SCSI_OSD_DPRINT_SENSE=1
-
-# Uncomment to turn debug on
-# ccflags-y += -DCONFIG_SCSI_OSD_DEBUG
-
-# if we are built out-of-tree and the hosting kernel has OSD headers
-# then "ccflags-y +=" will not pick the out-off-tree headers. Only by doing
-# this it will work. This might break in future kernels
-LINUXINCLUDE := -I$(OSD_INC) $(LINUXINCLUDE)
-
-endif
-
 # libosd.ko - osd-initiator library
 libosd-y := osd_initiator.o
 obj-$(CONFIG_SCSI_OSD_INITIATOR) += libosd.o
diff --git a/drivers/scsi/osd/Makefile b/drivers/scsi/osd/Makefile
deleted file mode 100755
index d905344..0000000
--- a/drivers/scsi/osd/Makefile
+++ /dev/null
@@ -1,37 +0,0 @@
-#
-# Makefile for the OSD modules (out of tree)
-#
-# Copyright (C) 2008 Panasas Inc.  All rights reserved.
-#
-# Authors:
-#   Boaz Harrosh <bharrosh@panasas.com>
-#   Benny Halevy <bhalevy@panasas.com>
-#
-# This program is free software; you can redistribute it and/or modify
-# it under the terms of the GNU General Public License version 2
-#
-# This Makefile is used to call the kernel Makefile in case of an out-of-tree
-# build.
-# $KSRC should point to a Kernel source tree otherwise host's default is
-# used. (eg. /lib/modules/`uname -r`/build)
-
-# include path for out-of-tree Headers
-OSD_INC ?= `pwd`/../../../include
-
-# allow users to override these
-# e.g. to compile for a kernel that you aren't currently running
-KSRC ?= /lib/modules/$(shell uname -r)/build
-KBUILD_OUTPUT ?=
-ARCH ?=
-V ?= 0
-
-# this is the basic Kbuild out-of-tree invocation, with the M= option
-KBUILD_BASE = +$(MAKE) -C $(KSRC) M=`pwd` KBUILD_OUTPUT=$(KBUILD_OUTPUT) ARCH=$(ARCH) V=$(V)
-
-all: libosd
-
-libosd: ;
-	$(KBUILD_BASE) OSD_INC=$(OSD_INC) modules
-
-clean:
-	$(KBUILD_BASE) clean
-- 
1.6.2.1

