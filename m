From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] let bnx2i iSCSI driver depend on PCI
Date: Mon, 15 Jun 2009 22:35:42 +0200
Message-ID: <20090615203542.GB4788@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:64575 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634AbZFOUfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2009 16:35:51 -0400
Received: from d06nrmr1707.portsmouth.uk.ibm.com (d06nrmr1707.portsmouth.uk.ibm.com [9.149.39.225])
	by mtagate4.uk.ibm.com (8.14.3/8.13.8) with ESMTP id n5FKZhkh195714
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2009 20:35:43 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1707.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5FKZhvZ1249290
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2009 21:35:43 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5FKZg4A011412
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2009 21:35:43 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Michael Chan <mchan@broadcom.com>, linux-scsi@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

allyesconfig on s390 fails like this because of lack of PCI:

drivers/scsi/bnx2i/bnx2i_iscsi.c:760:
  error: implicit declaration of function 'pci_dev_get'

Cc: Michael Chan <mchan@broadcom.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/scsi/bnx2i/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/scsi/bnx2i/Kconfig
===================================================================
--- linux-2.6.orig/drivers/scsi/bnx2i/Kconfig
+++ linux-2.6/drivers/scsi/bnx2i/Kconfig
@@ -2,6 +2,7 @@ config SCSI_BNX2_ISCSI
 	tristate "Broadcom NetXtreme II iSCSI support"
 	select SCSI_ISCSI_ATTRS
 	select CNIC
+	depends on PCI
 	---help---
 	This driver supports iSCSI offload for the Broadcom NetXtreme II
 	devices.
