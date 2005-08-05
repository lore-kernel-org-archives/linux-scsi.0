From: Alex Aizman <itn780@yahoo.com>
Subject: [ANNOUNCE 7/7] open-iscsi/linux-iscsi-5 Initiator: open-iscsi-Kconfig.patch
Date: Thu, 04 Aug 2005 19:33:15 -0700
Message-ID: <42F2CFEB.5000001@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.mail.sc5.yahoo.com ([66.163.169.226]:48283 "HELO
	smtp106.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S262824AbVHECd2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 22:33:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "David S. Miller" <davem@davemloft.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

	open-iscsi-Kconfig.patch - drivers/scsi/Kconfig changes.

	Signed-off-by: Alex Aizman <itn780@yahoo.com>
	Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
	Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -223,12 +223,35 @@ config SCSI_FC_ATTRS
 
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


