From: Janet Morgan <janetmor@us.ibm.com>
Subject: [PATCH] aic7xxx bouncing over 4G
Date: Fri, 20 Dec 2002 16:12:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

I have an Adaptec AIC-7897 Ultra2 SCSI adapter on a system with 8G
of physical memory.  The adapter is using bounce buffers when DMA'ing
to memory >4G because of a bug in the aic7xxx driver. 

The problem is ahc_linux_get_memsize() returns an erroneous memory size 
(i.e., shifts out the high-order bits) for configurations >4G and the 
wrong dma mask is set by the caller.   The following patch fixes the problem 
by adding the needed cast.


--- linux-2.5.52/drivers/scsi/aic7xxx/aic7xxx_linux.c	Sun Dec 15 18:07:54 2002
+++ nobounce/drivers/scsi/aic7xxx/aic7xxx_linux.c	Fri Dec 20 16:08:11 2002
@@ -1156,7 +1156,7 @@
 	struct sysinfo si;
 
 	si_meminfo(&si);
-	return (si.totalram << PAGE_SHIFT);
+	return ((uint64_t)si.totalram << PAGE_SHIFT);
 }
 
 /*
