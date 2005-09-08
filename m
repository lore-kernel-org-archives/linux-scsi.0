From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] move iscsi to a better place in Kconfig
Date: Thu, 08 Sep 2005 09:56:18 -0500
Message-ID: <1126191378.4845.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41627 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932520AbVIHO43 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 10:56:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Aizman <itn780@yahoo.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Now it looks like we'll have multiple users of the iscsi transport
class, the iscsi initiator shouldn't really be a dependency of it.  This
patch moves iscsi to being an initiator in its own right which selects
the transport attributes.

James

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -235,12 +235,18 @@ config SCSI_ISCSI_ATTRS
 	  each attached iSCSI device to sysfs, say Y.
 	  Otherwise, say N.
 
+endmenu
+
+menu "SCSI low-level drivers"
+	depends on SCSI!=n
+
 config ISCSI_TCP
 	tristate "iSCSI Initiator over TCP/IP"
-	depends on SCSI && INET && SCSI_ISCSI_ATTRS
+	depends on SCSI && INET
 	select CRYPTO
 	select CRYPTO_MD5
 	select CRYPTO_CRC32C
+	select SCSI_ISCSI_ATTRS
 	help
 	 The iSCSI Driver provides a host with the ability to access storage
 	 through an IP network. The driver uses the iSCSI protocol to transport
@@ -258,11 +264,6 @@ config ISCSI_TCP
 
 	 http://linux-iscsi.sf.net
 
-endmenu
-
-menu "SCSI low-level drivers"
-	depends on SCSI!=n
-
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
 	depends on SGI_IP22 && SCSI


