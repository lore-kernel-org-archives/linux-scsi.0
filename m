From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 13/14] bfa: Brocade BFA FC SCSI driver (makefile)
Date: Fri, 24 Jul 2009 23:24:06 -0700
Message-ID: <200907250624.n6P6O65M025999@swe57.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx10.brocade.com ([208.185.105.18]:48908 "EHLO mx10.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZGYGYH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2009 02:24:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains Makefile and Kconfig file for scsi and bfa.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 Kconfig      |   10 ++++++++++
 Makefile     |    1 +
 bfa/Makefile |   30 ++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

diff -urpN orig/drivers/scsi/Kconfig patch/drivers/scsi/Kconfig
--- orig/drivers/scsi/Kconfig	2009-07-21 15:34:05.000000000 -0700
+++ patch/drivers/scsi/Kconfig	2009-07-21 15:34:00.000000000 -0700
@@ -1819,6 +1819,16 @@ config SCSI_SRP
 	  To compile this driver as a module, choose M here: the
 	  module will be called libsrp.
 
+config SCSI_BFA_FC
+	tristate "Brocade BFA Fibre Channel Support"
+	depends on PCI && SCSI
+	select SCSI_FC_ATTRS
+	help
+	  This bfa driver supports all Brocade PCIe FC/FCOE host adapters.
+
+	  To compile this driver as a module, choose M here. The module will
+	  be called bfa.
+
 endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
diff -urpN orig/drivers/scsi/Makefile patch/drivers/scsi/Makefile
--- orig/drivers/scsi/Makefile	2009-07-21 15:34:05.000000000 -0700
+++ patch/drivers/scsi/Makefile	2009-07-21 15:34:01.000000000 -0700
@@ -86,6 +86,7 @@ obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla128
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
 obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
+obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
 obj-$(CONFIG_SCSI_T128)		+= t128.o
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
diff -urpN orig/drivers/scsi/bfa/Makefile patch/drivers/scsi/bfa/Makefile
--- orig/drivers/scsi/bfa/Makefile	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/Makefile	2009-07-21 15:34:05.000000000 -0700
@@ -0,0 +1,30 @@
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
+	bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_aen.o bfa_fcxp.o bfa_lps.o \
+	bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o \
+	bfa_fcport.o bfa_port.o bfa_uf.o bfa_sgpg.o bfa_module.o bfa_ioim.o \
+	bfa_itnim.o bfa_fcpim.o bfa_tskim.o bfa_log.o bfa_log_module.o \
+	bfa_csdebug.o bfa_sm.o plog.o fcbuild.o fabric.o fcpim.o vfapi.o \
+	fcptm.o bfa_fcs.o bfa_fcs_port.o bfa_fcs_uf.o bfa_fcs_lport.o \
+        fab.o fdmi.o ms.o ns.o scn.o loop.o lport_api.o n2n.o rport.o \
+        rport_api.o rport_ftrs.o vport.o
+
+
+EXTRA_CFLAGS += -I$(obj) -I$(obj)/include -I$(obj)/include/cna
