From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 4/5] bfa: Brocade BFA FC SCSI driver submission
Date: Tue, 27 Jan 2009 10:55:24 -0800
Message-ID: <200901271855.n0RItOUA026905@swe37.brocade.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:42834 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897AbZA0S6l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2009 13:58:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

From: Jing Huang <huangj@brocade.com>

This patch contains Makefile and Kconfig file for scsi and bfa. It is created
using 2.6.29-rc2 kernel.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/Kconfig      |    6 ++++++
 drivers/scsi/Makefile     |    1 +
 drivers/scsi/bfa/Kconfig  |    6 ++++++
 drivers/scsi/bfa/Makefile |   25 +++++++++++++++++++++++++
 4 files changed, 38 insertions(+)

diff -urpN orig/drivers/scsi/bfa/Kconfig patch/drivers/scsi/bfa/Kconfig
--- orig/drivers/scsi/bfa/Kconfig	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/Kconfig	2009-01-26 17:28:26.000000000 -0800
@@ -0,0 +1,6 @@
+config SCSI_BFA_FC
+	tristate "Brocade BFA Fibre Channel Support"
+	depends on PCI && SCSI
+	---help---
+	Select M for building module
+
diff -urpN orig/drivers/scsi/bfa/Makefile patch/drivers/scsi/bfa/Makefile
--- orig/drivers/scsi/bfa/Makefile	1969-12-31 16:00:00.000000000 -0800
+++ patch/drivers/scsi/bfa/Makefile	2009-01-26 17:28:26.000000000 -0800
@@ -0,0 +1,25 @@
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
+bfa-objs := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o	\
+	bfad_fwimg.o bfa_fcs.o bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_hw_cb.o	\
+	bfa_hw_ct.o bfa_fcxp.o bfa_intr.o bfa_timer.o bfa_rport.o bfa_port.o	\
+	bfa_uf.o bfa_sgpg.o bfa_module.o bfa_ioim.o bfa_itnim.o bfa_fcpim.o	\
+	bfa_tskim.o bfa_log.o bfa_log_module.o bfa_csdebug.o bfa_sm.o plog.o
+
+EXTRA_CFLAGS += -I$(obj) -I$(obj)/include
diff -urpN orig/drivers/scsi/Kconfig patch/drivers/scsi/Kconfig
--- orig/drivers/scsi/Kconfig	2009-01-26 17:28:26.000000000 -0800
+++ patch/drivers/scsi/Kconfig	2009-01-26 17:28:21.000000000 -0800
@@ -1797,6 +1797,12 @@ config SCSI_SRP
 	  To compile this driver as a module, choose M here: the
 	  module will be called libsrp.
 
+config SCSI_BFA_FC
+	tristate "Brocade BFA Fibre Channel Support"
+	depends on PCI && SCSI
+	---help---
+	  To compile this driver as a module, choose M here. The module will be called bfa
+
 endif # SCSI_LOWLEVEL
 
 source "drivers/scsi/pcmcia/Kconfig"
diff -urpN orig/drivers/scsi/Makefile patch/drivers/scsi/Makefile
--- orig/drivers/scsi/Makefile	2009-01-26 17:28:26.000000000 -0800
+++ patch/drivers/scsi/Makefile	2009-01-26 17:28:21.000000000 -0800
@@ -84,6 +84,7 @@ obj-$(CONFIG_SCSI_QLOGIC_1280)	+= qla128
 obj-$(CONFIG_SCSI_QLA_FC)	+= qla2xxx/
 obj-$(CONFIG_SCSI_QLA_ISCSI)	+= qla4xxx/
 obj-$(CONFIG_SCSI_LPFC)		+= lpfc/
+obj-$(CONFIG_SCSI_BFA_FC)	+= bfa/
 obj-$(CONFIG_SCSI_PAS16)	+= pas16.o
 obj-$(CONFIG_SCSI_T128)		+= t128.o
 obj-$(CONFIG_SCSI_DMX3191D)	+= dmx3191d.o
