From: Alex Aizman <itn780@yahoo.com>
Subject: [ANNOUNCE 7/7] Open-iSCSI/Linux-iSCSI-5 High-Performance Initiator:
 iscsi-Kconfig.patch
Date: Wed, 01 Jun 2005 13:10:22 -0700
Message-ID: <429E162E.1000908@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261173AbVFAUMF@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

	iscsi-Kconfig.patch - drivers/scsi/Kconfig changes.

	Signed-off-by: Alex Aizman <itn780@yahoo.com>
	Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
	Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Index: drivers/scsi/Kconfig
===================================================================
--- 7570fde464d579ce455c865f07a613e967e9396c/drivers/scsi/Kconfig  (mode:100644 sha1:750b11cefd934349480d6237f6df564edf6d297b)
+++ uncommitted/drivers/scsi/Kconfig  (mode:100644)
@@ -205,12 +205,35 @@
 
 config SCSI_ISCSI_ATTRS
 	tristate "iSCSI Transport Attributes"
-	depends on SCSI
+	depends on SCSI && NET
 	help
 	  If you wish to export transport-specific information about
 	  each attached iSCSI device to sysfs, say Y.
 	  Otherwise, say N.
 
+config ISCSI_TCP
+	tristate "iSCSI Initiator over TCP/IP"
+	depends on SCSI && INET && SCSI_ISCSI_ATTRS
+	select CRYPTO
+	select CRYPTO_MD5
+	select CRYPTO_CRC32C
+	help
+	 The iSCSI Driver provides a host with the ability to access storage
+	 through an IP network. The driver uses the iSCSI protocol to transport
+	 SCSI requests and responses over a TCP/IP network between the host
+	 (the "initiator") and "targets".  Architecturally, the iSCSI driver
+	 combines with the host's TCP/IP stack, network drivers, and Network
+	 Interface Card (NIC) to provide the same functions as a SCSI or a
+	 Fibre Channel (FC) adapter driver with a Host Bus Adapter (HBA).
+
+	 To compile this driver as a module, choose M here: the
+	 module will be called iscsi_tcp.
+
+	 The userspace component needed to initialize the driver, documentation,
+	 and sample configuration files can be found here:
+
+	 http://linux-iscsi.sf.net
+
 endmenu
 
 menu "SCSI low-level drivers"
