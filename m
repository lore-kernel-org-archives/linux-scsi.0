From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] ieee1394: sbp2: enforce 32bit DMA mapping
Date: Sun, 4 Feb 2007 20:25:43 +0100 (CET)
Message-ID: <tkrat.90c5934ce8c089ca@s5r6.in-berlin.de>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
	<1168802387.2780.1.camel@mulgrave.il.steeleye.com>
	<tkrat.581ea0f6f3fe6292@s5r6.in-berlin.de>
	<tkrat.e82713a8340840b3@s5r6.in-berlin.de>
	<tkrat.61995f33104845d9@s5r6.in-berlin.de>
	<1170605197.26464.16.camel@PISCES.MIT.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1170605197.26464.16.camel@PISCES.MIT.EDU>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: David Moore <dcm@MIT.EDU>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

David Moore wrote:
> Yes, I think you should use GFP_DMA32 instead of GFP_DMA.  GFP_DMA
> refers to just the first 16MB of memory.

Yes, I forgot that GFP_DMA is for ISA DMA. However since GFP_DMA32 is
nowhere enforced except in allocations for coherent PCI DMA and in some
AGP code I think now I'll just drop that hunk.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: ieee1394: sbp2: enforce 32bit DMA mapping

In order to use OHCI-1394 physical DMA, all s/g elements, s/g tables,
ORBs, and response buffers have to reside within the first 4 GB of the
FireWire controller's physical address space.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Index: linux-2.6.20-rc5/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.20-rc5.orig/drivers/ieee1394/sbp2.c
+++ linux-2.6.20-rc5/drivers/ieee1394/sbp2.c
@@ -757,6 +757,11 @@ static struct sbp2_lu *sbp2_alloc_device
 			SBP2_ERR("failed to register lower 4GB address range");
 			goto failed_alloc;
 		}
+#else
+		if (dma_set_mask(hi->host->device.parent, DMA_32BIT_MASK)) {
+			SBP2_ERR("failed to set 4GB DMA mask");
+			goto failed_alloc;
+		}
 #endif
 	}
 

-- 
Stefan Richter
-=====-=-=== --=- --=--
http://arcgraph.de/sr/


-------------------------------------------------------------------------
Using Tomcat but need to do more? Need to support web services, security?
Get stuff done quickly with pre-integrated technology to make your job easier.
Download IBM WebSphere Application Server v.1.0.1 based on Apache Geronimo
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=120709&bid=263057&dat=121642
