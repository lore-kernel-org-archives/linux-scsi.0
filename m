From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [patch 06/11] drivers/scsi/aacraid/*: convert to pci_register_driver
Date: Tue, 15 Mar 2005 08:38:07 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BE5AF5F@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:51651 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261237AbVCONiK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2005 08:38:10 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: domen@coderock.org, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, c.lucas@ifrance.com

I have to reject this change since pci_module_init() has a different
return code than pci_register_driver().

The patch should look like:

-	error = pci_module_init(&aac_pci_driver);
+	error = pci_register_driver(&aac_pci_driver);
-	if (error)
+	if (error < 0)
 		return error;

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of
domen@coderock.org
Sent: Sunday, March 06, 2005 5:27 PM
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org; domen@coderock.org; c.lucas@ifrance.com
Subject: [patch 06/11] drivers/scsi/aacraid/*: convert to
pci_register_driver


convert from pci_module_init to pci_register_driver
(from:http://kerneljanitors.org/TODO).

Signed-off-by: Christophe Lucas <c.lucas@ifrance.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/aacraid/linit.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN
drivers/scsi/aacraid/linit.c~pci_register_driver-drivers_scsi_aacraid
drivers/scsi/aacraid/linit.c
---
kj/drivers/scsi/aacraid/linit.c~pci_register_driver-drivers_scsi_aacraid
2005-03-05 16:12:51.000000000 +0100
+++ kj-domen/drivers/scsi/aacraid/linit.c	2005-03-05
16:12:51.000000000 +0100
@@ -690,7 +690,7 @@ static int __init aac_init(void)
 	printk(KERN_INFO "Red Hat/Adaptec aacraid driver (%s %s)\n",
 			AAC_DRIVER_VERSION, AAC_DRIVER_BUILD_DATE);
 
-	error = pci_module_init(&aac_pci_driver);
+	error = pci_register_driver(&aac_pci_driver);
 	if (error)
 		return error;
 
_
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
