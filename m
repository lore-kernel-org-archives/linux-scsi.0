From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/10][RFC] linux-iscsi driver
Date: Mon, 10 Jan 2005 14:56:45 -0800
Message-ID: <41E3082D.1@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070207080704050608090602"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:61659 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S262703AbVAJW4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 17:56:52 -0500
Received: from [192.168.1.7] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j0AMuoZi024961
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 16:56:51 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070207080704050608090602
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Add Makefile and Kconfig

--------------070207080704050608090602
Content-Type: text/x-patch;
 name="01-kconfig-mk.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01-kconfig-mk.patch"

diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/Kconfig scsi-misc-2.6.test/drivers/scsi/iscsi-sfnet/Kconfig
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/Kconfig	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.test/drivers/scsi/iscsi-sfnet/Kconfig	2005-01-05 01:15:07.712291051 -0800
@@ -0,0 +1,25 @@
+config SCSI_ISCSI_SFNET
+	tristate "Software iSCSI support"
+	depends on SCSI && INET
+	select SCSI_ISCSI_ATTRS
+	select CRYPTO
+	select CRYPTO_MD5
+	select CRYPTO_CRC32C
+	---help---
+	To compile this driver as a module, choose M here: the
+	module will be called iscsi_sfnet.
+
+	The iSCSI Driver provides a host with the ability to access
+	storage through an IP network. The driver uses the iSCSI
+	protocol to transport SCSI requests and responses over an IP
+	network between the host (the "initiator") and "targets".
+	Architecturally, the iSCSI driver combines with the host's
+	TCP/IP stack, network drivers, and Network Interface Card
+	(NIC) to provide the same functions as a SCSI or a Fibre
+	Channel (FC) adapter driver with a Host Bus Adapter (HBA).
+
+	The userspace component needed to initialize the driver,
+	documentation, and sample configuration files can be found
+	here:
+
+	http://linux-iscsi.sourceforge.net
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/Makefile scsi-misc-2.6.test/drivers/scsi/iscsi-sfnet/Makefile
--- scsi-misc-2.6.orig/drivers/scsi/iscsi-sfnet/Makefile	1969-12-31 16:00:00.000000000 -0800
+++ scsi-misc-2.6.test/drivers/scsi/iscsi-sfnet/Makefile	2005-01-05 01:15:18.661906339 -0800
@@ -0,0 +1,16 @@
+#
+# Makefile for Software iSCSI driver
+#
+obj-$(CONFIG_SCSI_ISCSI_SFNET)	+= 	iscsi_sfnet.o
+iscsi_sfnet-objs		:=	iscsi-initiator.o
+iscsi_sfnet-objs		+= 	iscsi-attr.o \
+					iscsi-session.o \
+					iscsi-task.o \
+					iscsi-portal.o \
+					iscsi-ioctl.o \
+					iscsi-network.o \
+					iscsi-recv-pdu.o \
+					iscsi-xmit-pdu.o \
+					iscsi-auth.o \
+					iscsi-login.o \
+					iscsi-auth-client.o
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/Kconfig scsi-misc-2.6.test/drivers/scsi/Kconfig
--- scsi-misc-2.6.orig/drivers/scsi/Kconfig	2005-01-05 01:13:32.951273657 -0800
+++ scsi-misc-2.6.test/drivers/scsi/Kconfig	2005-01-05 01:14:37.771077311 -0800
@@ -854,6 +854,8 @@ config SCSI_PPA
 	  To compile this driver as a module, choose M here: the
 	  module will be called ppa.
 
+source "drivers/scsi/iscsi-sfnet/Kconfig"
+
 config SCSI_IMM
 	tristate "IOMEGA parallel port (imm - newer drives)"
 	depends on SCSI && PARPORT
diff -Naurp scsi-misc-2.6.orig/drivers/scsi/Makefile scsi-misc-2.6.test/drivers/scsi/Makefile
--- scsi-misc-2.6.orig/drivers/scsi/Makefile	2005-01-05 01:13:33.221239510 -0800
+++ scsi-misc-2.6.test/drivers/scsi/Makefile	2005-01-05 01:14:33.208654238 -0800
@@ -132,6 +132,7 @@ obj-$(CONFIG_SCSI_SATA_SIS)	+= libata.o 
 obj-$(CONFIG_SCSI_SATA_SX4)	+= libata.o sata_sx4.o
 obj-$(CONFIG_SCSI_SATA_NV)	+= libata.o sata_nv.o
 obj-$(CONFIG_SCSI_SATA_ULI)	+= libata.o sata_uli.o
+obj-$(CONFIG_SCSI_ISCSI_SFNET)	+= iscsi-sfnet/
 
 obj-$(CONFIG_ARM)		+= arm/
 

--------------070207080704050608090602--
