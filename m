From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/1] DAC960: PCI id table fixup
Date: Thu, 03 Aug 2006 13:54:59 -0500
Message-ID: <200608031855.k73It1tI018162@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:7651 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964809AbWHCSzD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2006 14:55:03 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k73It2Vm030924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 3 Aug 2006 14:55:03 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k73It2L0294860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 3 Aug 2006 14:55:02 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k73It1sK018207
	for <linux-scsi@vger.kernel.org>; Thu, 3 Aug 2006 14:55:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The PCI ID table in the DAC960 driver conflicts with some devices
that use the ipr driver. All ipr adapters that use this chip
have an IBM subvendor ID and all DAC960 adapters that use this
chip have a Mylex subvendor id.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/block/DAC960.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/DAC960.c~dac960_id_table_fixup drivers/block/DAC960.c
--- linux-2.6/drivers/block/DAC960.c~dac960_id_table_fixup	2006-08-03 13:53:13.000000000 -0500
+++ linux-2.6-bjking1/drivers/block/DAC960.c	2006-08-03 13:53:13.000000000 -0500
@@ -7115,7 +7115,7 @@ static struct pci_device_id DAC960_id_ta
 	{
 		.vendor 	= PCI_VENDOR_ID_MYLEX,
 		.device		= PCI_DEVICE_ID_MYLEX_DAC960_GEM,
-		.subvendor	= PCI_ANY_ID,
+		.subvendor	= PCI_VENDOR_ID_MYLEX,
 		.subdevice	= PCI_ANY_ID,
 		.driver_data	= (unsigned long) &DAC960_GEM_privdata,
 	},
_
