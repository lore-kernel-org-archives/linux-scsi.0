From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 16:24:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212282224.gBSMO5h03843@localhost.localdomain>
References: <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_8987307530"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA17290
	for <linux-scsi@vger.kernel.org>; Sat, 28 Dec 2002 14:24:12 -0800
In-Reply-To: Message from "Justin T. Gibbs" <gibbs@scsiguy.com>
   of "Sat, 28 Dec 2002 13:50:51 MST." <770128112.1041108651@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_8987307530
Content-Type: text/plain; charset=us-ascii

gibbs@scsiguy.com said:
> Hmm.  The only previous bug report I had in this area was related to a
> missing cast.  That was fixed, but I guess it wasn't enough to solve
> the problem. 

It looks like possibly a config option that doesn't exist (and a possibly 
improper reliance on the dma_mask default value---which should work almost all 
the time, but it's safer to set it).

Andrew, could you try the attached (untested) patch and see if the problem 
goes away.

James


--==_Exmh_8987307530
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

===== aic7xxx_osm.c 1.7 vs edited =====
--- 1.7/drivers/scsi/aic7xxx/aic7xxx_osm.c	Fri Dec 20 18:59:50 2002
+++ edited/aic7xxx_osm.c	Sat Dec 28 16:18:40 2002
@@ -1297,14 +1297,12 @@
 	 */
 	.max_sectors		= 8192,
 #endif
-#if defined CONFIG_HIGHIO
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,18)
 /* Assume RedHat Distribution with its different HIGHIO conventions. */
 	.can_dma_32		= 1,
 	.single_sg_okay		= 1,
 #else
 	.highmem_io		= 1,
-#endif
 #endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0)
 	.name			= "aic7xxx",
===== aic7xxx_osm_pci.c 1.3 vs edited =====
--- 1.3/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	Thu Dec 12 14:44:00 2002
+++ edited/aic7xxx_osm_pci.c	Sat Dec 28 15:47:14 2002
@@ -166,6 +166,9 @@
 		ahc->flags |= AHC_39BIT_ADDRESSING;
 		ahc->platform_data->hw_dma_mask =
 		    (bus_addr_t)(0x7FFFFFFFFFULL & (bus_addr_t)~0);
+	} else {
+		ahc_pci_set_dma_mask(pdev, 0xffffffffULL);
+		ahc->platform_data->hw_dma_mask = 0xffffffffULL;
 	}
 #endif
 	ahc->dev_softc = pci;

--==_Exmh_8987307530--


