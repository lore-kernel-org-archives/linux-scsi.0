From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] Bug 4940 Repeatable Kernel Panic on Adaptec 2015S I20 device on bootup
Date: Mon, 8 Aug 2005 10:06:11 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684222@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:16598 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932067AbVHHOIj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 10:08:39 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Markus.Lidel@shadowconnect.com, Andrew Morton <akpm@osdl.org>, alan@redhat.com

Suitable for both 2.4 and 2.6 version of the driver. Applies to
scsi-misc-2.6 git tree.

Prevent driver from loading if another driver (i2o) has already claimed
the resources associated with the card. Discussion associated with this
bug can be referenced at http://bugzilla.kernel.org/show_bug.cgi?id=4940
where it was agreed to use pci_request_regions in both the dpt_i2o and
the i2o driver to prevent both drivers loading on the same adapter(s).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

Index: a/drivers/scsi/dpt_i2o.c
===================================================================
--- a/drivers/scsi/dpt_i2o.c	2005-07-26 11:42:03.000000000 -0400
+++ b/drivers/scsi/dpt_i2o.c	2005-08-08 09:50:33.247595544 -0400
@@ -908,8 +908,12 @@
 	}
 
-
+ 	if (pci_request_regions(pDev)) {
+ 		PERROR("dpti: adpt_config_hba: pci request region
failed\n");
+ 		return -EINVAL;
+ 	}
 	base_addr_virt = ioremap(base_addr0_phys,hba_map0_area_size);
 	if (!base_addr_virt) {
+ 		pci_release_regions(pDev);
 		PERROR("dpti: adpt_config_hba: io remap failed\n");
 		return -EINVAL;
 	}
@@ -919,6 +924,7 @@
 		if (!msg_addr_virt) {
 			PERROR("dpti: adpt_config_hba: io remap failed
on BAR1\n");
 			iounmap(base_addr_virt);
+			pci_release_regions(pDev);
 			return -EINVAL;
 		}
 	} else {
@@ -932,6 +938,7 @@
 			iounmap(msg_addr_virt);
 		}
 		iounmap(base_addr_virt);
+		pci_release_regions(pDev);
 		return -ENOMEM;
 	}
 	memset(pHba, 0, sizeof(adpt_hba));
@@ -1027,6 +1034,7 @@
 	up(&adpt_configuration_lock);
 
 	iounmap(pHba->base_addr_virt);
+	pci_release_regions(pHba->pDev);
 	if(pHba->msg_addr_virt != pHba->base_addr_virt){
 		iounmap(pHba->msg_addr_virt);
 	}

Sincerely -- Mark Salyzyn
