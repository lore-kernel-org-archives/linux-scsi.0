From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 13/14] bfa: Brocade BFA FC SCSI driver (make)
Date: Fri, 28 Aug 2009 01:24:26 -0700
Message-ID: <200908280824.n7S8OQho005486@blc-10-6.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:38776 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbZH1IYY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2009 04:24:24 -0400
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
 bfa/Makefile |   15 +++++++++++++++
 3 files changed, 26 insertions(+)

diff -urpN orig/drivers/scsi/Kconfig patch/drivers/scsi/Kconfig
--- orig/drivers/scsi/Kconfig	2009-08-27 19:42:00.000000000 -0700
+++ patch/drivers/scsi/Kconfig	2009-08-27 19:41:54.000000000 -0700
@@ -1821,6 +1821,16 @@ config SCSI_SRP
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
--- orig/drivers/scsi/Makefile	2009-08-27 19:42:00.000000000 -0700
+++ patch/drivers/scsi/Makefile	2009-08-27 19:41:54.000000000 -0700
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
+++ patch/drivers/scsi/bfa/Makefile	2009-08-27 19:42:00.000000000 -0700
@@ -0,0 +1,15 @@
+obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
+
+bfa-y := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o
+
+bfa-y += bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_fcxp.o bfa_lps.o
+bfa-y += bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o 
+bfa-y += bfa_fcport.o bfa_port.o bfa_uf.o bfa_sgpg.o bfa_module.o bfa_ioim.o
+bfa-y += bfa_itnim.o bfa_fcpim.o bfa_tskim.o bfa_log.o bfa_log_module.o
+bfa-y += bfa_csdebug.o bfa_sm.o plog.o
+
+bfa-y += fcbuild.o fabric.o fcpim.o vfapi.o fcptm.o bfa_fcs.o bfa_fcs_port.o 
+bfa-y += bfa_fcs_uf.o bfa_fcs_lport.o fab.o fdmi.o ms.o ns.o scn.o loop.o
+bfa-y += lport_api.o n2n.o rport.o rport_api.o rport_ftrs.o vport.o
+
+ccflags-y := -I$(obj) -I$(obj)/include -I$(obj)/include/cna
