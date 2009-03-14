From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 4/5] bfa: Brocade BFA FC SCSI driver (makefile)
Date: Sat, 14 Mar 2009 12:58:41 -0700
Message-ID: <200903141958.n2EJwffd030299@blc-10-6.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx30.brocade.com ([144.49.194.4]:56444 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbZCNT7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Mar 2009 15:59:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains Makefile and Kconfig file for scsi and bfa. It is created
using 2.6.29-rc8 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 Kconfig      |    9 +++++++++
 Makefile     |    1 +
 bfa/Makefile |   28 ++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff -urpN orig/drivers/scsi/bfa/Makefile patch/drivers/scsi/bfa/Makefile
--- orig/drivers/scsi/bfa/Makefile	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/Makefile	2009-03-14 11:44:59.337712000 -0700
@@ -0,0 +1,28 @@
+#
+# Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
+# All rights reserved
+# www.brocade.com
+# 
+# Linux driver for Brocade Fibre Channel Host Bus Adapter.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License (GPL) Version 2 as
+# published by the Free Software Foundation
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+# General Public License for more details.
+#
+obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
+
+bfa-objs := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o \
+	    bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_fcxp.o bfa_diag.o \
+	    bfa_fcdiag.o bfa_lps.o bfa_hw_cb.o bfa_hw_ct.o bfa_drv.o  \
+            bfa_intr.o bfa_timer.o bfa_rport.o bfa_port.o bfa_uf.o \
+            bfa_sgpg.o  bfa_module.o bfa_ioim.o bfa_itnim.o bfa_fcpim.o \
+	    bfa_tskim.o bfa_port.o bfa_vport.o bfa_lport.o bfa_fabric.o   \
+            bfa_auth.o  bfa_vfapi.o bfa_log.o bfa_log_module.o bfa_csdebug.o \
+            bfa_sm.o plog.o
+
+EXTRA_CFLAGS += -I$(obj) -I$(obj)/include
diff -urpN orig/drivers/scsi/Kconfig patch/drivers/scsi/Kconfig
--- orig/drivers/scsi/Kconfig	2009-03-14 11:44:59.381081000 -0700
+++ patch/drivers/scsi/Kconfig	2009-03-14 11:44:53.382314000 -0700
@@ -1797,6 +1797,15 @@ config SCSI_SRP
 	  To compile this driver as a module, choose M here: the
 	  module will be called libsrp.
 
+config SCSI_BFA_FC
+	tristate "Brocade BFA Fibre Channel Support"
+	depends on PCI && SCSI
+	help
+	  This bfa driver supports all Brocade PCIe Fibre Channel host adapters.
+
+	  To compile this driver as a module, choose M here. The module will
+	  be called bfa.
+
 endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
diff -urpN orig/drivers/scsi/Makefile patch/drivers/scsi/Makefile
--- orig/drivers/scsi/Makefile	2009-03-14 11:44:59.393920000 -0700
+++ patch/drivers/scsi/Makefile	2009-03-14 11:44:53.417722000 -0700
@@ -84,6 +84,7 @@ obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla128
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
 obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
+obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
 obj-$(CONFIG_SCSI_T128)		+= t128.o
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
