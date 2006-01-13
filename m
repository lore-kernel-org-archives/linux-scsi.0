From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH] - fusion - fix pci express bug
Date: Fri, 13 Jan 2006 16:25:29 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7ED@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:14774 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1423104AbWAMXZd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 18:25:33 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@lst.de, James.Bottomley@steeleye.com

The fix is to write  'MPI_HIM_DIM' to the Host Interrupt Mask 
register, when enabling interrupts.  Instead of the
tilde of MPI_HIM_RIM.

Apparently writing '1's to some of the reserved bits was causing
all the bits to go to `1`, which effectly disabled all interrupts.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarN b/drivers/message/fusion/mptbase.c
a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-01-13 15:42:07.000000000
-0700
+++ a/drivers/message/fusion/mptbase.c	2006-01-13 15:50:02.000000000
-0700
@@ -1630,7 +1630,7 @@
 	pci_enable_device(pdev);
 
 	/* enable interrupts */
-	CHIPREG_WRITE32(&ioc->chip->IntMask, ~(MPI_HIM_RIM));
+	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
 	ioc->active = 1;
 
 	/* F/W not running */
@@ -1723,7 +1723,7 @@
 				/* (re)Enable alt-IOC! (reply interrupt,
FreeQ) */
 				dprintk((KERN_INFO MYNAM ": alt-%s reply
irq re-enabled\n",
 						ioc->alt_ioc->name));
-
CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, ~(MPI_HIM_RIM));
+
CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
 				ioc->alt_ioc->active = 1;
 			}
 
@@ -1839,7 +1839,7 @@
 
 	if (ret == 0) {
 		/* Enable! (reply interrupt) */
-		CHIPREG_WRITE32(&ioc->chip->IntMask, ~(MPI_HIM_RIM));
+		CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
 		ioc->active = 1;
 	}
 
@@ -1847,7 +1847,7 @@
 		/* (re)Enable alt-IOC! (reply interrupt) */
 		dinitprintk((KERN_INFO MYNAM ": alt-%s reply irq
re-enabled\n",
 				ioc->alt_ioc->name));
-		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask,
~(MPI_HIM_RIM));
+		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask,
MPI_HIM_DIM);
 		ioc->alt_ioc->active = 1;
 	}
 
